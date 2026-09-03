from datetime import datetime

from geoalchemy2 import Geometry, WKBElement
from sqlalchemy import (
    BigInteger,
    CheckConstraint,
    Computed,
    ForeignKey,
    Identity,
    Integer,
    PrimaryKeyConstraint,
    Text,
    text,
)
from sqlalchemy.dialects.postgresql import TIMESTAMP
from sqlalchemy.orm import Mapped, mapped_column

from app.models.base import Base


class CurrentVehiclePosition(Base):
    """Latest known state of one vehicle, upserted on every simulator tick."""

    __tablename__ = "current_vehicle_positions"
    __table_args__ = (
        CheckConstraint("lat BETWEEN -90 AND 90"),
        CheckConstraint("lon BETWEEN -180 AND 180"),
    )

    vehicle_id: Mapped[str] = mapped_column(Text, primary_key=True)
    trip_id: Mapped[int | None] = mapped_column(
        BigInteger, ForeignKey("trips.id", ondelete="SET NULL")
    )
    lat: Mapped[float]
    lon: Mapped[float]
    geom: Mapped[WKBElement] = mapped_column(
        Geometry(geometry_type="POINT", srid=4326, spatial_index=False),
        Computed("ST_SetSRID(ST_MakePoint(lon, lat), 4326)", persisted=True),
    )
    delay_seconds: Mapped[int] = mapped_column(Integer, default=0, server_default="0")
    current_stop_id: Mapped[int | None] = mapped_column(
        BigInteger, ForeignKey("stops.id", ondelete="SET NULL")
    )
    recorded_at: Mapped[datetime] = mapped_column(
        TIMESTAMP(timezone=True), server_default=text("now()")
    )


class VehiclePositionHistory(Base):
    """Append-only, daily-partitioned vehicle telemetry."""

    __tablename__ = "vehicle_position_history"
    __table_args__ = (
        PrimaryKeyConstraint("recorded_at", "id"),
        CheckConstraint("lat BETWEEN -90 AND 90"),
        CheckConstraint("lon BETWEEN -180 AND 180"),
        {"postgresql_partition_by": "RANGE (recorded_at)"},
    )

    id: Mapped[int] = mapped_column(BigInteger, Identity(always=True))
    vehicle_id: Mapped[str] = mapped_column(Text)
    trip_id: Mapped[int | None] = mapped_column(
        BigInteger, ForeignKey("trips.id", ondelete="SET NULL")
    )
    lat: Mapped[float]
    lon: Mapped[float]
    geom: Mapped[WKBElement] = mapped_column(
        Geometry(geometry_type="POINT", srid=4326, spatial_index=False),
        Computed("ST_SetSRID(ST_MakePoint(lon, lat), 4326)", persisted=True),
    )
    delay_seconds: Mapped[int] = mapped_column(Integer, default=0, server_default="0")
    current_stop_id: Mapped[int | None] = mapped_column(
        BigInteger, ForeignKey("stops.id", ondelete="SET NULL")
    )
    recorded_at: Mapped[datetime] = mapped_column(
        TIMESTAMP(timezone=True), server_default=text("now()")
    )
