from datetime import date

from sqlalchemy import BigInteger, CheckConstraint, Date, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column

from app.models.base import Base


class Calendar(Base):
    """Weekly operating pattern of a service (GTFS calendar.txt). 1:1 with services."""

    __tablename__ = "calendar"
    __table_args__ = (CheckConstraint("start_date <= end_date", name="calendar_date_range"),)

    service_id: Mapped[int] = mapped_column(
        BigInteger, ForeignKey("services.id", ondelete="CASCADE"), primary_key=True
    )
    monday: Mapped[bool]
    tuesday: Mapped[bool]
    wednesday: Mapped[bool]
    thursday: Mapped[bool]
    friday: Mapped[bool]
    saturday: Mapped[bool]
    sunday: Mapped[bool]
    start_date: Mapped[date] = mapped_column(Date)
    end_date: Mapped[date] = mapped_column(Date)
