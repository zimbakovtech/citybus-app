from sqlalchemy import CHAR, BigInteger, CheckConstraint, ForeignKey, Identity, SmallInteger, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import Base


class Route(Base):
    """Bus line as riders know it (GTFS routes.txt)."""

    __tablename__ = "routes"
    __table_args__ = (
        CheckConstraint(
            "short_name IS NOT NULL OR long_name IS NOT NULL", name="routes_name_present"
        ),
        CheckConstraint("color IS NULL OR color ~ '^[0-9A-Fa-f]{6}$'", name="routes_color_hex"),
        CheckConstraint(
            "text_color IS NULL OR text_color ~ '^[0-9A-Fa-f]{6}$'",
            name="routes_text_color_hex",
        ),
    )

    id: Mapped[int] = mapped_column(BigInteger, Identity(always=True), primary_key=True)
    gtfs_route_id: Mapped[str] = mapped_column(Text, unique=True)
    agency_id: Mapped[int] = mapped_column(BigInteger, ForeignKey("agency.id", ondelete="CASCADE"))
    short_name: Mapped[str | None] = mapped_column(Text)
    long_name: Mapped[str | None] = mapped_column(Text)
    route_type: Mapped[int] = mapped_column(SmallInteger, default=3, server_default="3")
    color: Mapped[str | None] = mapped_column(CHAR(6))
    text_color: Mapped[str | None] = mapped_column(CHAR(6))

    trips: Mapped[list["Trip"]] = relationship(back_populates="route")  # noqa: F821
