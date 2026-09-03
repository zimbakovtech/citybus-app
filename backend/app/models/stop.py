from geoalchemy2 import Geometry, WKBElement
from sqlalchemy import (
    BigInteger,
    CheckConstraint,
    Computed,
    ForeignKey,
    Identity,
    SmallInteger,
    Text,
)
from sqlalchemy.orm import Mapped, mapped_column

from app.models.base import Base


class Stop(Base):
    """Physical bus stop or station (GTFS stops.txt)."""

    __tablename__ = "stops"
    __table_args__ = (
        CheckConstraint("lat BETWEEN -90 AND 90", name="stops_lat_range"),
        CheckConstraint("lon BETWEEN -180 AND 180", name="stops_lon_range"),
        CheckConstraint("location_type BETWEEN 0 AND 4", name="stops_location_type_range"),
        CheckConstraint(
            "parent_station_id IS NULL OR parent_station_id <> id",
            name="stops_parent_not_self",
        ),
    )

    id: Mapped[int] = mapped_column(BigInteger, Identity(always=True), primary_key=True)
    gtfs_stop_id: Mapped[str] = mapped_column(Text, unique=True)
    code: Mapped[str | None] = mapped_column(Text)
    name: Mapped[str] = mapped_column(Text)
    description: Mapped[str | None] = mapped_column(Text)
    lat: Mapped[float]
    lon: Mapped[float]
    # mirrors lat/lon as a PostGIS point; indexed with GiST (02_indexes.sql)
    geom: Mapped[WKBElement] = mapped_column(
        Geometry(geometry_type="POINT", srid=4326, spatial_index=False),
        Computed("ST_SetSRID(ST_MakePoint(lon, lat), 4326)", persisted=True),
    )
    location_type: Mapped[int] = mapped_column(SmallInteger, default=0, server_default="0")
    parent_station_id: Mapped[int | None] = mapped_column(
        BigInteger, ForeignKey("stops.id", ondelete="SET NULL")
    )
