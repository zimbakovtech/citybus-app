"""GTFS static feed importer.

Reads a GTFS feed (directory of .txt files or a .zip archive) and loads it into
the database, resolving GTFS string IDs to surrogate keys as it goes.

Idempotency: the importer TRUNCATEs all GTFS tables (RESTART IDENTITY CASCADE)
before loading, so re-running it replaces the feed instead of duplicating rows.
A truncate-and-reload was chosen over upserts because a GTFS feed is a coherent
snapshot — partial merges of two feeds are not meaningful.

Import order (parents before children so foreign keys resolve):
  agency -> routes -> services (derived from calendar + calendar_dates)
  -> calendar -> calendar_dates -> stops -> shapes -> shape_points
  -> trips -> stop_times, then shapes.geom is assembled from shape_points.
"""

import csv
import io
import logging
import zipfile
from collections.abc import Iterator
from contextlib import contextmanager
from datetime import date, datetime, timedelta
from pathlib import Path

from sqlalchemy import insert, text
from sqlalchemy.ext.asyncio import AsyncSession

from app.models import (
    Agency,
    Calendar,
    CalendarDate,
    Route,
    Service,
    Shape,
    ShapePoint,
    Stop,
    StopTime,
    Trip,
)

logger = logging.getLogger(__name__)

GTFS_TABLES = [
    "vehicle_positions",
    "stop_times",
    "trips",
    "shape_points",
    "shapes",
    "calendar_dates",
    "calendar",
    "services",
    "stops",
    "routes",
    "agency",
]

STOP_TIMES_BATCH = 5000


def parse_gtfs_time(value: str) -> timedelta:
    """Parse GTFS HH:MM:SS into an interval. Hours may exceed 24 (after-midnight
    service) and must NOT be clamped."""
    h, m, s = (int(part) for part in value.strip().split(":"))
    return timedelta(hours=h, minutes=m, seconds=s)


def parse_gtfs_date(value: str) -> date:
    return datetime.strptime(value.strip(), "%Y%m%d").date()


def _opt(row: dict[str, str], key: str) -> str | None:
    """Optional GTFS field: missing column or empty string -> None."""
    value = row.get(key, "").strip()
    return value or None


class GtfsFeed:
    """Uniform access to the .txt files of a feed directory or .zip archive."""

    def __init__(self, path: str | Path):
        self.path = Path(path)
        if not self.path.exists():
            raise FileNotFoundError(f"GTFS feed not found: {self.path}")
        self._zip = zipfile.ZipFile(self.path) if self.path.suffix == ".zip" else None

    @contextmanager
    def open(self, filename: str):
        if self._zip is not None:
            # a feed zip may nest files in a single top-level folder
            member = next((n for n in self._zip.namelist() if n.split("/")[-1] == filename), None)
            if member is None:
                raise FileNotFoundError(filename)
            with self._zip.open(member) as f:
                yield io.TextIOWrapper(f, encoding="utf-8-sig")
        else:
            with (self.path / filename).open(encoding="utf-8-sig") as f:
                yield f

    def rows(self, filename: str) -> Iterator[dict[str, str]]:
        with self.open(filename) as f:
            yield from csv.DictReader(f)

    def has(self, filename: str) -> bool:
        if self._zip is not None:
            return any(n.split("/")[-1] == filename for n in self._zip.namelist())
        return (self.path / filename).exists()


class GtfsImportService:
    def __init__(self, session: AsyncSession):
        self.session = session

    async def import_feed(self, path: str | Path) -> dict[str, int]:
        """Load a full GTFS feed. Returns row counts per table."""
        feed = GtfsFeed(path)
        counts: dict[str, int] = {}

        await self._truncate()
        counts["agency"] = await self._import_agencies(feed)
        counts["routes"] = await self._import_routes(feed)
        counts["services"], counts["calendar"], counts["calendar_dates"] = (
            await self._import_services(feed)
        )
        counts["stops"] = await self._import_stops(feed)
        counts["shapes"], counts["shape_points"] = await self._import_shapes(feed)
        counts["trips"] = await self._import_trips(feed)
        counts["stop_times"] = await self._import_stop_times(feed)
        await self._build_shape_geometries()
        await self.session.commit()

        for table, count in counts.items():
            logger.info("imported %-15s %6d rows", table, count)
        return counts

    async def _truncate(self) -> None:
        tables = ", ".join(GTFS_TABLES)
        await self.session.execute(text(f"TRUNCATE {tables} RESTART IDENTITY CASCADE"))
        logger.info("truncated GTFS tables")

    async def _import_agencies(self, feed: GtfsFeed) -> int:
        self._agency_ids: dict[str, int] = {}
        count = 0
        for row in feed.rows("agency.txt"):
            result = await self.session.execute(
                insert(Agency)
                .values(
                    gtfs_agency_id=row["agency_id"],
                    name=row["agency_name"],
                    url=_opt(row, "agency_url"),
                    timezone=row["agency_timezone"],
                    lang=_opt(row, "agency_lang"),
                    phone=_opt(row, "agency_phone"),
                )
                .returning(Agency.id)
            )
            self._agency_ids[row["agency_id"]] = result.scalar_one()
            count += 1
        return count

    async def _import_routes(self, feed: GtfsFeed) -> int:
        self._route_ids: dict[str, int] = {}
        count = 0
        for row in feed.rows("routes.txt"):
            result = await self.session.execute(
                insert(Route)
                .values(
                    gtfs_route_id=row["route_id"],
                    agency_id=self._agency_ids[row["agency_id"]],
                    short_name=_opt(row, "route_short_name"),
                    long_name=_opt(row, "route_long_name"),
                    route_type=int(row.get("route_type") or 3),
                    color=_opt(row, "route_color"),
                    text_color=_opt(row, "route_text_color"),
                )
                .returning(Route.id)
            )
            self._route_ids[row["route_id"]] = result.scalar_one()
            count += 1
        return count

    async def _import_services(self, feed: GtfsFeed) -> tuple[int, int, int]:
        """services is derived: every service_id seen in calendar.txt or
        calendar_dates.txt becomes one services row."""
        self._service_ids: dict[str, int] = {}
        calendar_rows = list(feed.rows("calendar.txt")) if feed.has("calendar.txt") else []
        exception_rows = (
            list(feed.rows("calendar_dates.txt")) if feed.has("calendar_dates.txt") else []
        )

        gtfs_service_ids = {r["service_id"] for r in calendar_rows} | {
            r["service_id"] for r in exception_rows
        }
        for gtfs_id in sorted(gtfs_service_ids):
            result = await self.session.execute(
                insert(Service).values(gtfs_service_id=gtfs_id).returning(Service.id)
            )
            self._service_ids[gtfs_id] = result.scalar_one()

        for row in calendar_rows:
            await self.session.execute(
                insert(Calendar).values(
                    service_id=self._service_ids[row["service_id"]],
                    monday=row["monday"] == "1",
                    tuesday=row["tuesday"] == "1",
                    wednesday=row["wednesday"] == "1",
                    thursday=row["thursday"] == "1",
                    friday=row["friday"] == "1",
                    saturday=row["saturday"] == "1",
                    sunday=row["sunday"] == "1",
                    start_date=parse_gtfs_date(row["start_date"]),
                    end_date=parse_gtfs_date(row["end_date"]),
                )
            )
        for row in exception_rows:
            await self.session.execute(
                insert(CalendarDate).values(
                    service_id=self._service_ids[row["service_id"]],
                    date=parse_gtfs_date(row["date"]),
                    exception_type=int(row["exception_type"]),
                )
            )
        return len(gtfs_service_ids), len(calendar_rows), len(exception_rows)

    async def _import_stops(self, feed: GtfsFeed) -> int:
        self._stop_ids: dict[str, int] = {}
        parents: dict[str, str] = {}  # child gtfs id -> parent gtfs id
        count = 0
        for row in feed.rows("stops.txt"):
            lat, lon = float(row["stop_lat"]), float(row["stop_lon"])
            result = await self.session.execute(
                insert(Stop)
                .values(
                    gtfs_stop_id=row["stop_id"],
                    code=_opt(row, "stop_code"),
                    name=row["stop_name"],
                    description=_opt(row, "stop_desc"),
                    lat=lat,
                    lon=lon,
                    location_type=int(row.get("location_type") or 0),
                )
                .returning(Stop.id)
            )
            self._stop_ids[row["stop_id"]] = result.scalar_one()
            if _opt(row, "parent_station"):
                parents[row["stop_id"]] = row["parent_station"]
            count += 1

        # second pass: parent stations may appear after their children
        for child, parent in parents.items():
            await self.session.execute(
                text("UPDATE stops SET parent_station_id = :parent WHERE id = :child"),
                {"parent": self._stop_ids[parent], "child": self._stop_ids[child]},
            )
        return count

    async def _import_shapes(self, feed: GtfsFeed) -> tuple[int, int]:
        self._shape_ids: dict[str, int] = {}
        if not feed.has("shapes.txt"):
            return 0, 0

        point_rows: list[dict] = []
        for row in feed.rows("shapes.txt"):
            gtfs_id = row["shape_id"]
            if gtfs_id not in self._shape_ids:
                result = await self.session.execute(
                    insert(Shape).values(gtfs_shape_id=gtfs_id).returning(Shape.id)
                )
                self._shape_ids[gtfs_id] = result.scalar_one()
            dist = _opt(row, "shape_dist_traveled")
            point_rows.append(
                {
                    "shape_id": self._shape_ids[gtfs_id],
                    "pt_sequence": int(row["shape_pt_sequence"]),
                    "lat": float(row["shape_pt_lat"]),
                    "lon": float(row["shape_pt_lon"]),
                    "dist_traveled": float(dist) if dist else None,
                }
            )
        if point_rows:
            await self.session.execute(insert(ShapePoint), point_rows)
        return len(self._shape_ids), len(point_rows)

    async def _import_trips(self, feed: GtfsFeed) -> int:
        self._trip_ids: dict[str, int] = {}
        count = 0
        for row in feed.rows("trips.txt"):
            direction = _opt(row, "direction_id")
            shape = _opt(row, "shape_id")
            result = await self.session.execute(
                insert(Trip)
                .values(
                    gtfs_trip_id=row["trip_id"],
                    route_id=self._route_ids[row["route_id"]],
                    service_id=self._service_ids[row["service_id"]],
                    shape_id=self._shape_ids.get(shape) if shape else None,
                    headsign=_opt(row, "trip_headsign"),
                    direction_id=int(direction) if direction is not None else None,
                    block_id=_opt(row, "block_id"),
                )
                .returning(Trip.id)
            )
            self._trip_ids[row["trip_id"]] = result.scalar_one()
            count += 1
        return count

    async def _import_stop_times(self, feed: GtfsFeed) -> int:
        batch: list[dict] = []
        count = 0
        for row in feed.rows("stop_times.txt"):
            dist = _opt(row, "shape_dist_traveled")
            batch.append(
                {
                    "trip_id": self._trip_ids[row["trip_id"]],
                    "stop_id": self._stop_ids[row["stop_id"]],
                    "stop_sequence": int(row["stop_sequence"]),
                    "arrival_time": parse_gtfs_time(row["arrival_time"]),
                    "departure_time": parse_gtfs_time(row["departure_time"]),
                    "stop_headsign": _opt(row, "stop_headsign"),
                    "pickup_type": int(row.get("pickup_type") or 0),
                    "drop_off_type": int(row.get("drop_off_type") or 0),
                    "shape_dist_traveled": float(dist) if dist else None,
                }
            )
            count += 1
            if len(batch) >= STOP_TIMES_BATCH:
                await self.session.execute(insert(StopTime), batch)
                batch = []
        if batch:
            await self.session.execute(insert(StopTime), batch)
        return count

    async def _build_shape_geometries(self) -> None:
        """Assemble each shape's LineString from its ordered points (X = lon)."""
        await self.session.execute(
            text(
                """
                UPDATE shapes s
                SET geom = sub.line
                FROM (
                    SELECT shape_id,
                           ST_MakeLine(
                               ST_SetSRID(ST_MakePoint(lon, lat), 4326)
                               ORDER BY pt_sequence
                           ) AS line
                    FROM shape_points
                    GROUP BY shape_id
                ) sub
                WHERE sub.shape_id = s.id
                """
            )
        )
        logger.info("assembled shapes.geom from shape_points")
