"""ORM models — one file per table; import them all so Base.metadata is complete."""

from app.models.agency import Agency
from app.models.base import Base
from app.models.calendar import Calendar
from app.models.calendar_date import CalendarDate
from app.models.route import Route
from app.models.route_pattern import RoutePattern, RoutePatternStop
from app.models.service import Service
from app.models.shape import Shape
from app.models.shape_point import ShapePoint
from app.models.stop import Stop
from app.models.stop_time import StopTime
from app.models.trip import Trip
from app.models.vehicle_position import CurrentVehiclePosition, VehiclePositionHistory

__all__ = [
    "Agency",
    "Base",
    "Calendar",
    "CalendarDate",
    "Route",
    "RoutePattern",
    "RoutePatternStop",
    "Service",
    "Shape",
    "ShapePoint",
    "Stop",
    "StopTime",
    "Trip",
    "CurrentVehiclePosition",
    "VehiclePositionHistory",
]
