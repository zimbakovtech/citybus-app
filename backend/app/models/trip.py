from sqlalchemy import BigInteger, CheckConstraint, ForeignKey, Identity, SmallInteger, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import Base


class Trip(Base):
    """A single scheduled vehicle run along a route (GTFS trips.txt)."""

    __tablename__ = "trips"
    __table_args__ = (CheckConstraint("direction_id IN (0, 1)", name="trips_direction_id_check"),)

    id: Mapped[int] = mapped_column(BigInteger, Identity(always=True), primary_key=True)
    gtfs_trip_id: Mapped[str] = mapped_column(Text, unique=True)
    route_id: Mapped[int] = mapped_column(BigInteger, ForeignKey("routes.id", ondelete="CASCADE"))
    service_id: Mapped[int] = mapped_column(
        BigInteger, ForeignKey("services.id", ondelete="CASCADE")
    )
    shape_id: Mapped[int | None] = mapped_column(
        BigInteger, ForeignKey("shapes.id", ondelete="SET NULL")
    )
    route_pattern_id: Mapped[int] = mapped_column(
        BigInteger, ForeignKey("route_patterns.id", ondelete="RESTRICT")
    )
    headsign: Mapped[str | None] = mapped_column(Text)
    direction_id: Mapped[int | None] = mapped_column(SmallInteger)
    block_id: Mapped[str | None] = mapped_column(Text)

    route: Mapped["Route"] = relationship(back_populates="trips")  # noqa: F821
    stop_times: Mapped[list["StopTime"]] = relationship(  # noqa: F821
        back_populates="trip", order_by="StopTime.stop_sequence"
    )
