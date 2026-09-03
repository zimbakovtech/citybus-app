from datetime import timedelta

from sqlalchemy import BigInteger, CheckConstraint, ForeignKey, Integer, SmallInteger, Text
from sqlalchemy.dialects.postgresql import INTERVAL
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import Base


class StopTime(Base):
    """One scheduled stop event of one trip — the finest grain of the schema.

    arrival_time / departure_time are intervals since service midnight, because
    GTFS allows values >= 24:00:00 for after-midnight service.
    """

    __tablename__ = "stop_times"
    __table_args__ = (
        CheckConstraint("pickup_type IN (0,1,2,3)", name="stop_times_pickup_type_check"),
        CheckConstraint("drop_off_type IN (0,1,2,3)", name="stop_times_drop_off_type_check"),
        CheckConstraint("stop_sequence > 0", name="stop_times_sequence_positive"),
        CheckConstraint("arrival_time >= interval '0'", name="stop_times_arrival_nonnegative"),
        CheckConstraint(
            "departure_time >= arrival_time", name="stop_times_departure_after_arrival"
        ),
        CheckConstraint(
            "shape_dist_traveled IS NULL OR shape_dist_traveled >= 0",
            name="stop_times_distance_nonnegative",
        ),
    )

    trip_id: Mapped[int] = mapped_column(
        BigInteger, ForeignKey("trips.id", ondelete="CASCADE"), primary_key=True
    )
    stop_id: Mapped[int] = mapped_column(BigInteger, ForeignKey("stops.id", ondelete="CASCADE"))
    stop_sequence: Mapped[int] = mapped_column(Integer, primary_key=True)
    arrival_time: Mapped[timedelta] = mapped_column(INTERVAL)
    departure_time: Mapped[timedelta] = mapped_column(INTERVAL)
    stop_headsign: Mapped[str | None] = mapped_column(Text)
    pickup_type: Mapped[int] = mapped_column(SmallInteger, default=0, server_default="0")
    drop_off_type: Mapped[int] = mapped_column(SmallInteger, default=0, server_default="0")
    shape_dist_traveled: Mapped[float | None]

    trip: Mapped["Trip"] = relationship(back_populates="stop_times")  # noqa: F821
    stop: Mapped["Stop"] = relationship()  # noqa: F821
