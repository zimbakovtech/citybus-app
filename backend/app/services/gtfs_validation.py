"""Preflight validation for the GTFS subset supported by CityBus."""

from __future__ import annotations

from collections import defaultdict
from dataclasses import dataclass
from datetime import date, datetime, timedelta
from typing import Protocol


class FeedReader(Protocol):
    def has(self, filename: str) -> bool: ...

    def rows(self, filename: str): ...


@dataclass(frozen=True)
class ValidationIssue:
    file: str
    row: int | None
    field: str | None
    code: str
    message: str

    def __str__(self) -> str:
        location = self.file
        if self.row is not None:
            location += f":{self.row}"
        if self.field:
            location += f" [{self.field}]"
        return f"{location}: {self.code}: {self.message}"


class GtfsValidationError(ValueError):
    def __init__(self, issues: list[ValidationIssue], total_issues: int):
        self.issues = issues
        self.total_issues = total_issues
        suffix = "" if total_issues == len(issues) else f" (showing first {len(issues)})"
        super().__init__(f"GTFS validation failed with {total_issues} issue(s){suffix}")


@dataclass(frozen=True)
class ValidatedFeed:
    trip_stop_ids: dict[str, list[str]]


class _Issues:
    def __init__(self, limit: int = 100):
        self.limit = limit
        self.items: list[ValidationIssue] = []
        self.total = 0

    def add(
        self,
        filename: str,
        row: int | None,
        field: str | None,
        code: str,
        message: str,
    ) -> None:
        self.total += 1
        if len(self.items) < self.limit:
            self.items.append(ValidationIssue(filename, row, field, code, message))


def _required(row: dict[str, str], field: str, filename: str, line: int, issues: _Issues) -> str:
    value = row.get(field, "").strip()
    if not value:
        issues.add(filename, line, field, "required", "value is required by the CityBus importer")
    return value


def _number(
    value: str,
    filename: str,
    line: int,
    field: str,
    issues: _Issues,
    converter,
):
    try:
        return converter(value)
    except (TypeError, ValueError):
        issues.add(filename, line, field, "invalid_number", f"cannot parse {value!r}")
        return None


def _gtfs_time(
    value: str, filename: str, line: int, field: str, issues: _Issues
) -> timedelta | None:
    try:
        parts = [int(part) for part in value.split(":")]
        if len(parts) != 3 or parts[0] < 0 or not 0 <= parts[1] < 60 or not 0 <= parts[2] < 60:
            raise ValueError
        return timedelta(hours=parts[0], minutes=parts[1], seconds=parts[2])
    except (TypeError, ValueError):
        issues.add(filename, line, field, "invalid_time", f"invalid GTFS time {value!r}")
        return None


def _gtfs_date(value: str, filename: str, line: int, field: str, issues: _Issues) -> date | None:
    try:
        return datetime.strptime(value, "%Y%m%d").date()
    except (TypeError, ValueError):
        issues.add(filename, line, field, "invalid_date", f"invalid GTFS date {value!r}")
        return None


def _read(feed: FeedReader, filename: str, issues: _Issues, required: bool = True):
    if not feed.has(filename):
        if required:
            issues.add(filename, None, None, "missing_file", "required GTFS file is missing")
        return []
    return list(feed.rows(filename))


def _unique_ids(rows: list[dict[str, str]], filename: str, field: str, issues: _Issues) -> set[str]:
    found: set[str] = set()
    for line, row in enumerate(rows, start=2):
        value = _required(row, field, filename, line, issues)
        if value in found:
            issues.add(filename, line, field, "duplicate_id", f"duplicate identifier {value!r}")
        elif value:
            found.add(value)
    return found


def validate_feed(feed: FeedReader) -> ValidatedFeed:
    issues = _Issues()
    agency_rows = _read(feed, "agency.txt", issues)
    route_rows = _read(feed, "routes.txt", issues)
    stop_rows = _read(feed, "stops.txt", issues)
    trip_rows = _read(feed, "trips.txt", issues)
    stop_time_rows = _read(feed, "stop_times.txt", issues)
    calendar_rows = _read(feed, "calendar.txt", issues, required=False)
    exception_rows = _read(feed, "calendar_dates.txt", issues, required=False)
    shape_rows = _read(feed, "shapes.txt", issues, required=False)

    agency_ids = _unique_ids(agency_rows, "agency.txt", "agency_id", issues)
    route_ids = _unique_ids(route_rows, "routes.txt", "route_id", issues)
    stop_ids = _unique_ids(stop_rows, "stops.txt", "stop_id", issues)
    trip_ids = _unique_ids(trip_rows, "trips.txt", "trip_id", issues)

    service_ids: set[str] = set()
    for filename, rows in (("calendar.txt", calendar_rows), ("calendar_dates.txt", exception_rows)):
        for line, row in enumerate(rows, start=2):
            value = _required(row, "service_id", filename, line, issues)
            if value:
                service_ids.add(value)
    if not service_ids:
        issues.add(
            "calendar.txt",
            None,
            "service_id",
            "missing_services",
            "at least one service must be defined by calendar or calendar_dates",
        )

    for line, row in enumerate(route_rows, start=2):
        agency_id = _required(row, "agency_id", "routes.txt", line, issues)
        if agency_id and agency_id not in agency_ids:
            issues.add("routes.txt", line, "agency_id", "unknown_reference", agency_id)
        if (
            not row.get("route_short_name", "").strip()
            and not row.get("route_long_name", "").strip()
        ):
            issues.add("routes.txt", line, None, "missing_name", "a route name is required")
        for field in ("route_color", "route_text_color"):
            value = row.get(field, "").strip()
            if value and (len(value) != 6 or any(c not in "0123456789abcdefABCDEF" for c in value)):
                issues.add("routes.txt", line, field, "invalid_color", value)

    parents: dict[str, str] = {}
    for line, row in enumerate(stop_rows, start=2):
        _required(row, "stop_name", "stops.txt", line, issues)
        lat = _number(row.get("stop_lat", ""), "stops.txt", line, "stop_lat", issues, float)
        lon = _number(row.get("stop_lon", ""), "stops.txt", line, "stop_lon", issues, float)
        if lat is not None and not -90 <= lat <= 90:
            issues.add("stops.txt", line, "stop_lat", "out_of_range", str(lat))
        if lon is not None and not -180 <= lon <= 180:
            issues.add("stops.txt", line, "stop_lon", "out_of_range", str(lon))
        location = _number(
            row.get("location_type") or "0",
            "stops.txt",
            line,
            "location_type",
            issues,
            int,
        )
        if location is not None and location not in range(5):
            issues.add("stops.txt", line, "location_type", "unsupported_enum", str(location))
        parent = row.get("parent_station", "").strip()
        child = row.get("stop_id", "").strip()
        if parent:
            parents[child] = parent
            if parent not in stop_ids:
                issues.add("stops.txt", line, "parent_station", "unknown_reference", parent)
            if parent == child:
                issues.add("stops.txt", line, "parent_station", "self_reference", parent)

    for child in parents:
        seen: set[str] = set()
        current = child
        while current in parents:
            if current in seen:
                issues.add("stops.txt", None, "parent_station", "parent_cycle", child)
                break
            seen.add(current)
            current = parents[current]

    calendar_service_ids: set[str] = set()
    for line, row in enumerate(calendar_rows, start=2):
        calendar_service_id = row.get("service_id", "").strip()
        if calendar_service_id in calendar_service_ids:
            issues.add(
                "calendar.txt",
                line,
                "service_id",
                "duplicate_id",
                calendar_service_id,
            )
        calendar_service_ids.add(calendar_service_id)
        start = _gtfs_date(
            _required(row, "start_date", "calendar.txt", line, issues),
            "calendar.txt",
            line,
            "start_date",
            issues,
        )
        end = _gtfs_date(
            _required(row, "end_date", "calendar.txt", line, issues),
            "calendar.txt",
            line,
            "end_date",
            issues,
        )
        if start and end and start > end:
            issues.add("calendar.txt", line, None, "invalid_range", "start_date exceeds end_date")
        for field in (
            "monday",
            "tuesday",
            "wednesday",
            "thursday",
            "friday",
            "saturday",
            "sunday",
        ):
            if row.get(field, "").strip() not in {"0", "1"}:
                issues.add("calendar.txt", line, field, "invalid_boolean", row.get(field, ""))

    exception_keys: set[tuple[str, str]] = set()
    for line, row in enumerate(exception_rows, start=2):
        service_id = row.get("service_id", "").strip()
        raw_date = _required(row, "date", "calendar_dates.txt", line, issues)
        _gtfs_date(raw_date, "calendar_dates.txt", line, "date", issues)
        key = (service_id, raw_date)
        if key in exception_keys:
            issues.add("calendar_dates.txt", line, None, "duplicate_exception", str(key))
        exception_keys.add(key)
        if row.get("exception_type", "").strip() not in {"1", "2"}:
            issues.add(
                "calendar_dates.txt",
                line,
                "exception_type",
                "unsupported_enum",
                row.get("exception_type", ""),
            )

    shape_points: dict[str, list[tuple[int, int, float | None]]] = defaultdict(list)
    shape_ids: set[str] = set()
    for line, row in enumerate(shape_rows, start=2):
        shape_id = _required(row, "shape_id", "shapes.txt", line, issues)
        shape_ids.add(shape_id)
        sequence = _number(
            row.get("shape_pt_sequence", ""),
            "shapes.txt",
            line,
            "shape_pt_sequence",
            issues,
            int,
        )
        lat = _number(
            row.get("shape_pt_lat", ""), "shapes.txt", line, "shape_pt_lat", issues, float
        )
        lon = _number(
            row.get("shape_pt_lon", ""), "shapes.txt", line, "shape_pt_lon", issues, float
        )
        if sequence is not None and sequence <= 0:
            issues.add("shapes.txt", line, "shape_pt_sequence", "out_of_range", str(sequence))
        if lat is not None and not -90 <= lat <= 90:
            issues.add("shapes.txt", line, "shape_pt_lat", "out_of_range", str(lat))
        if lon is not None and not -180 <= lon <= 180:
            issues.add("shapes.txt", line, "shape_pt_lon", "out_of_range", str(lon))
        distance = row.get("shape_dist_traveled", "").strip()
        parsed_distance = None
        if distance:
            parsed_distance = _number(
                distance, "shapes.txt", line, "shape_dist_traveled", issues, float
            )
            if parsed_distance is not None and parsed_distance < 0:
                issues.add("shapes.txt", line, "shape_dist_traveled", "negative", distance)
        if sequence is not None:
            shape_points[shape_id].append((sequence, line, parsed_distance))
    for shape_id, points in shape_points.items():
        sequences = [point[0] for point in points]
        if len(sequences) != len(set(sequences)):
            issues.add("shapes.txt", None, "shape_pt_sequence", "duplicate_sequence", shape_id)
        if len(sequences) < 2:
            issues.add("shapes.txt", None, None, "insufficient_points", shape_id)
        previous_distance: float | None = None
        for _sequence, line, distance in sorted(points):
            if (
                distance is not None
                and previous_distance is not None
                and distance < previous_distance
            ):
                issues.add(
                    "shapes.txt",
                    line,
                    "shape_dist_traveled",
                    "distance_decreases",
                    shape_id,
                )
            if distance is not None:
                previous_distance = distance

    for line, row in enumerate(trip_rows, start=2):
        route_id = _required(row, "route_id", "trips.txt", line, issues)
        service_id = _required(row, "service_id", "trips.txt", line, issues)
        if route_id and route_id not in route_ids:
            issues.add("trips.txt", line, "route_id", "unknown_reference", route_id)
        if service_id and service_id not in service_ids:
            issues.add("trips.txt", line, "service_id", "unknown_reference", service_id)
        direction = row.get("direction_id", "").strip()
        if direction and direction not in {"0", "1"}:
            issues.add("trips.txt", line, "direction_id", "unsupported_enum", direction)
        shape_id = row.get("shape_id", "").strip()
        if shape_id and shape_id not in shape_ids:
            issues.add("trips.txt", line, "shape_id", "unknown_reference", shape_id)

    trip_events: dict[
        str, list[tuple[int, str, timedelta | None, timedelta | None, float | None, int]]
    ] = defaultdict(list)
    for line, row in enumerate(stop_time_rows, start=2):
        trip_id = _required(row, "trip_id", "stop_times.txt", line, issues)
        stop_id = _required(row, "stop_id", "stop_times.txt", line, issues)
        if trip_id and trip_id not in trip_ids:
            issues.add("stop_times.txt", line, "trip_id", "unknown_reference", trip_id)
        if stop_id and stop_id not in stop_ids:
            issues.add("stop_times.txt", line, "stop_id", "unknown_reference", stop_id)
        sequence = _number(
            row.get("stop_sequence", ""),
            "stop_times.txt",
            line,
            "stop_sequence",
            issues,
            int,
        )
        arrival = _gtfs_time(
            _required(row, "arrival_time", "stop_times.txt", line, issues),
            "stop_times.txt",
            line,
            "arrival_time",
            issues,
        )
        departure = _gtfs_time(
            _required(row, "departure_time", "stop_times.txt", line, issues),
            "stop_times.txt",
            line,
            "departure_time",
            issues,
        )
        if arrival is not None and departure is not None and departure < arrival:
            issues.add("stop_times.txt", line, None, "departure_before_arrival", trip_id)
        for field in ("pickup_type", "drop_off_type"):
            value = row.get(field, "").strip() or "0"
            if value not in {"0", "1", "2", "3"}:
                issues.add("stop_times.txt", line, field, "unsupported_enum", value)
        distance = row.get("shape_dist_traveled", "").strip()
        parsed_distance = None
        if distance:
            parsed_distance = _number(
                distance, "stop_times.txt", line, "shape_dist_traveled", issues, float
            )
            if parsed_distance is not None and parsed_distance < 0:
                issues.add("stop_times.txt", line, "shape_dist_traveled", "negative", distance)
        if sequence is not None:
            if sequence <= 0:
                issues.add("stop_times.txt", line, "stop_sequence", "out_of_range", str(sequence))
            trip_events[trip_id].append(
                (sequence, stop_id, arrival, departure, parsed_distance, line)
            )

    trip_stop_ids: dict[str, list[str]] = {}
    for trip_id in trip_ids:
        events = sorted(trip_events.get(trip_id, []), key=lambda event: event[0])
        if len(events) < 2:
            issues.add("stop_times.txt", None, "trip_id", "insufficient_stops", trip_id)
            continue
        sequences = [event[0] for event in events]
        if len(sequences) != len(set(sequences)):
            issues.add("stop_times.txt", None, "stop_sequence", "duplicate_sequence", trip_id)
        previous_departure: timedelta | None = None
        previous_distance: float | None = None
        for _sequence, _stop, arrival, departure, distance, line in events:
            if (
                previous_departure is not None
                and arrival is not None
                and arrival < previous_departure
            ):
                issues.add(
                    "stop_times.txt",
                    line,
                    "arrival_time",
                    "time_decreases",
                    trip_id,
                )
            if departure is not None:
                previous_departure = departure
            if (
                distance is not None
                and previous_distance is not None
                and distance < previous_distance
            ):
                issues.add(
                    "stop_times.txt",
                    line,
                    "shape_dist_traveled",
                    "distance_decreases",
                    trip_id,
                )
            if distance is not None:
                previous_distance = distance
        trip_stop_ids[trip_id] = [event[1] for event in events]

    if issues.total:
        raise GtfsValidationError(issues.items, issues.total)
    return ValidatedFeed(trip_stop_ids=trip_stop_ids)
