"""Schema-level checks for generated geometry, indexes, and partitions."""

from datetime import UTC, datetime, timedelta

import pytest
from sqlalchemy import text
from sqlalchemy.exc import IntegrityError

from app.core.database import SessionFactory


async def test_point_geometry_is_generated_from_coordinates() -> None:
    async with SessionFactory() as session:
        generated = await session.scalar(
            text(
                """
                SELECT is_generated
                FROM information_schema.columns
                WHERE table_schema = 'public' AND table_name = 'stops' AND column_name = 'geom'
                """
            )
        )
        await session.execute(text("UPDATE stops SET lat = 41.5, lon = 21.5 WHERE id = 1"))
        point = (
            await session.execute(
                text(
                    "SELECT ST_Y(geom) AS lat, ST_X(geom) AS lon, "
                    "ST_SRID(geom) AS srid FROM stops WHERE id = 1"
                )
            )
        ).one()
        await session.rollback()

    assert generated == "ALWAYS"
    assert (point.lat, point.lon, point.srid) == (41.5, 21.5, 4326)


async def test_coordinate_constraint_rejects_invalid_stop() -> None:
    async with SessionFactory() as session:
        with pytest.raises(IntegrityError):
            await session.execute(text("UPDATE stops SET lat = 91 WHERE id = 1"))
            await session.flush()
        await session.rollback()


async def test_expected_indexes_exist_without_redundant_indexes() -> None:
    async with SessionFactory() as session:
        names = set(
            await session.scalars(
                text("SELECT indexname FROM pg_indexes WHERE schemaname = 'public'")
            )
        )

    assert {
        "idx_stops_geom",
        "idx_stops_geography",
        "idx_stops_parent",
        "idx_trips_route_service",
        "idx_current_vpos_recorded",
        "idx_vpos_history_vehicle_recorded",
    } <= names
    assert {
        "idx_stop_times_trip",
        "idx_calendar_dates_service",
        "idx_shape_points_shape",
    }.isdisjoint(names)


async def test_partition_maintenance_creates_current_utc_partition() -> None:
    today = datetime.now(UTC).date()
    expected = f"vehicle_position_history_{today:%Y%m%d}"
    async with SessionFactory() as session:
        await session.execute(
            text("SELECT maintain_vehicle_position_partitions(:today, 30, 0)"),
            {"today": today},
        )
        exists = await session.scalar(
            text("SELECT EXISTS (SELECT 1 FROM pg_class WHERE relname = :name)"),
            {"name": expected},
        )
        await session.rollback()

    assert exists is True


async def test_partition_maintenance_drops_expired_partition() -> None:
    today = datetime.now(UTC).date()
    expired_day = today - timedelta(days=30)
    next_day = expired_day + timedelta(days=1)
    partition_name = f"vehicle_position_history_{expired_day:%Y%m%d}"
    async with SessionFactory() as session:
        await session.execute(
            text(
                f"CREATE TABLE {partition_name} PARTITION OF vehicle_position_history "
                f"FOR VALUES FROM ('{expired_day} 00:00:00+00') "
                f"TO ('{next_day} 00:00:00+00')"
            )
        )
        await session.execute(
            text("SELECT maintain_vehicle_position_partitions(:today, 30, 0)"),
            {"today": today},
        )
        exists = await session.scalar(
            text("SELECT to_regclass(:name) IS NOT NULL"),
            {"name": partition_name},
        )
        await session.rollback()

    assert exists is False
