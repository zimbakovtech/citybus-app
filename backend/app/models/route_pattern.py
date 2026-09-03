from sqlalchemy import (
    BigInteger,
    CheckConstraint,
    ForeignKey,
    Identity,
    Integer,
    SmallInteger,
    UniqueConstraint,
)
from sqlalchemy.dialects.postgresql import ARRAY
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import Base


class RoutePattern(Base):
    """A route/direction/shape with one ordered stop sequence."""

    __tablename__ = "route_patterns"
    __table_args__ = (
        CheckConstraint("direction_id IN (0, 1)"),
        CheckConstraint("cardinality(stop_signature) >= 2"),
        UniqueConstraint(
            "route_id",
            "direction_id",
            "shape_id",
            "stop_signature",
            name="route_patterns_identity",
            postgresql_nulls_not_distinct=True,
        ),
    )

    id: Mapped[int] = mapped_column(BigInteger, Identity(always=True), primary_key=True)
    route_id: Mapped[int] = mapped_column(BigInteger, ForeignKey("routes.id", ondelete="CASCADE"))
    direction_id: Mapped[int | None] = mapped_column(SmallInteger)
    shape_id: Mapped[int | None] = mapped_column(
        BigInteger, ForeignKey("shapes.id", ondelete="SET NULL")
    )
    stop_signature: Mapped[list[int]] = mapped_column(ARRAY(BigInteger))

    stops: Mapped[list["RoutePatternStop"]] = relationship(  # noqa: F821
        back_populates="pattern", order_by="RoutePatternStop.stop_order"
    )


class RoutePatternStop(Base):
    """One ordered stop in a route pattern."""

    __tablename__ = "route_pattern_stops"
    __table_args__ = (CheckConstraint("stop_order > 0"),)

    pattern_id: Mapped[int] = mapped_column(
        BigInteger, ForeignKey("route_patterns.id", ondelete="CASCADE"), primary_key=True
    )
    stop_order: Mapped[int] = mapped_column(Integer, primary_key=True)
    stop_id: Mapped[int] = mapped_column(BigInteger, ForeignKey("stops.id", ondelete="RESTRICT"))

    pattern: Mapped[RoutePattern] = relationship(back_populates="stops")
