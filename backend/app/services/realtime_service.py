"""Simulated GTFS-Realtime: advances vehicles along their trips' schedules.

Each tick finds every trip that is under way at the current (simulated) clock,
interpolates the vehicle's position between the two stops it is traveling
between, applies a slowly-drifting random delay, appends a history row, upserts
current state and returns the update messages to broadcast.
"""

import logging
import math
import random
from datetime import UTC, date, datetime, timedelta

from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import settings
from app.repositories.service_repository import ServiceRepository
from app.repositories.vehicle_position_repository import VehiclePositionRepository

logger = logging.getLogger(__name__)

DAY_S = 24 * 3600
MAX_VEHICLES = 25


def bearing_deg(lat1: float, lon1: float, lat2: float, lon2: float) -> float:
    """Initial compass bearing from point 1 to point 2, in degrees [0, 360)."""
    p1, p2 = math.radians(lat1), math.radians(lat2)
    dl = math.radians(lon2 - lon1)
    x = math.sin(dl) * math.cos(p2)
    y = math.cos(p1) * math.sin(p2) - math.sin(p1) * math.cos(p2) * math.cos(dl)
    return math.degrees(math.atan2(x, y)) % 360


class RealtimeService:
    # test hook: freeze the simulation clock (see app/tests/test_realtime.py)
    now_override: datetime | None = None

    def __init__(self, session: AsyncSession):
        self.session = session
        self.services = ServiceRepository(session)
        self.positions = VehiclePositionRepository(session)
        # per-vehicle delay state drifts between ticks (seeded: reproducible)
        self._rng = random.Random(42)
        self._delays: dict[str, int] = {}
        self._partition_maintenance_date: date | None = None

    def _now(self) -> datetime:
        return type(self).now_override or datetime.now()

    async def tick(self) -> list[dict]:
        """Advance one step, storing history and current state atomically."""
        now = self._now()
        utc_date = datetime.now(UTC).date()
        if self._partition_maintenance_date != utc_date:
            await self.positions.maintain_partitions(
                utc_date,
                settings.vehicle_history_retention_days,
                settings.vehicle_partition_future_days,
            )
            self._partition_maintenance_date = utc_date
        now_s = int(
            timedelta(hours=now.hour, minutes=now.minute, seconds=now.second).total_seconds()
        )

        # a moment belongs to two service days: today, and yesterday for night
        # trips whose stop_times run past 24:00:00
        segments: list[tuple] = []  # (segment row, clock seconds it was matched at)
        for service_date, clock_s in ((now.date(), now_s), (self._yesterday(now), now_s + DAY_S)):
            service_ids = await self.services.active_service_ids(service_date)
            found = await self.positions.active_segments(
                service_ids, clock_s, MAX_VEHICLES - len(segments)
            )
            segments += [(seg, clock_s) for seg in found]

        rows: list[dict] = []
        messages: list[dict] = []
        for seg, clock_s in segments:
            vehicle_id = f"BUS-{seg.route_short_name}-{seg.trip_id}"
            span = max(seg.arr_s - seg.dep_s, 1)
            fraction = min(max((clock_s - seg.dep_s) / span, 0.0), 1.0)
            lat = seg.dep_lat + (seg.arr_lat - seg.dep_lat) * fraction
            lon = seg.dep_lon + (seg.arr_lon - seg.dep_lon) * fraction

            # delay drifts by up to ±15 s per tick, clamped to [-60 s, +10 min]
            delay = self._delays.get(vehicle_id, self._rng.randint(0, 120))
            delay = max(-60, min(600, delay + self._rng.randint(-15, 15)))
            self._delays[vehicle_id] = delay

            rows.append(
                {
                    "vehicle_id": vehicle_id,
                    "trip_id": seg.trip_id,
                    "lat": lat,
                    "lon": lon,
                    "delay_seconds": delay,
                    "current_stop_id": seg.next_stop_id,
                }
            )
            messages.append(
                {
                    "type": "vehicle_position",
                    "vehicle_id": vehicle_id,
                    "trip_id": seg.trip_id,
                    "route_short_name": seg.route_short_name,
                    "lat": round(lat, 6),
                    "lon": round(lon, 6),
                    "bearing": round(
                        bearing_deg(seg.dep_lat, seg.dep_lon, seg.arr_lat, seg.arr_lon), 1
                    ),
                    "delay_seconds": delay,
                    "current_stop_id": seg.next_stop_id,
                    "timestamp": now.isoformat(),
                }
            )

        await self.positions.insert_positions(rows)
        await self.session.commit()
        return messages

    async def snapshot(self) -> dict:
        """Current state of all recently-seen vehicles, for new subscribers
        and the /live/vehicles endpoint."""
        rows = await self.positions.latest_positions()
        return {
            "type": "snapshot",
            "vehicles": [
                {
                    "vehicle_id": row.vehicle_id,
                    "trip_id": row.trip_id,
                    "route_short_name": row.route_short_name,
                    "lat": row.lat,
                    "lon": row.lon,
                    "delay_seconds": row.delay_seconds,
                    "current_stop_id": row.current_stop_id,
                    "recorded_at": row.recorded_at.isoformat(),
                }
                for row in rows
            ],
        }

    @staticmethod
    def _yesterday(now: datetime) -> date:
        return (now - timedelta(days=1)).date()
