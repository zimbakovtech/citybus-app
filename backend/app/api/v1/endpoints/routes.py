from datetime import date

from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_session
from app.schemas.common import ErrorResponse, Page
from app.schemas.route import (
    RouteDetail,
    RoutePatternSummary,
    RouteSummary,
    ShapeGeoJson,
    TripSummary,
)
from app.schemas.stop import StopSummary
from app.services.route_service import RouteService

router = APIRouter(prefix="/routes", tags=["routes"])


def get_service(session: AsyncSession = Depends(get_session)) -> RouteService:
    return RouteService(session)


@router.get("", summary="Search routes", response_model=Page[RouteSummary])
async def list_routes(
    search: str | None = Query(None, description="Fuzzy match on short/long name"),
    limit: int = Query(20, ge=1, le=100),
    offset: int = Query(0, ge=0),
    service: RouteService = Depends(get_service),
) -> Page[RouteSummary]:
    return await service.search(search, limit, offset)


@router.get(
    "/{route_id}",
    summary="Route detail",
    response_model=RouteDetail,
    responses={404: {"model": ErrorResponse}},
)
async def route_detail(route_id: int, service: RouteService = Depends(get_service)) -> RouteDetail:
    return await service.detail(route_id)


@router.get(
    "/{route_id}/patterns",
    summary="Route patterns",
    description="Distinct direction/shape/ordered-stop patterns used by trips of this route.",
    response_model=list[RoutePatternSummary],
    responses={404: {"model": ErrorResponse}},
)
async def route_patterns(
    route_id: int,
    direction_id: int | None = Query(None, ge=0, le=1),
    service: RouteService = Depends(get_service),
) -> list[RoutePatternSummary]:
    return await service.patterns(route_id, direction_id)


@router.get(
    "/{route_id}/stops",
    summary="Ordered stops of a route",
    description="The selected pattern's stop sequence; defaults to the most-used pattern.",
    response_model=list[StopSummary],
    responses={404: {"model": ErrorResponse}},
)
async def route_stops(
    route_id: int,
    direction_id: int | None = Query(None, ge=0, le=1),
    pattern_id: int | None = Query(None, ge=1),
    service: RouteService = Depends(get_service),
) -> list[StopSummary]:
    return await service.ordered_stops(route_id, direction_id, pattern_id)


@router.get(
    "/{route_id}/shape",
    summary="Route polyline",
    description="The selected pattern's GeoJSON LineString ([lon, lat] pairs).",
    response_model=ShapeGeoJson,
    responses={404: {"model": ErrorResponse}},
)
async def route_shape(
    route_id: int,
    direction_id: int | None = Query(None, ge=0, le=1),
    pattern_id: int | None = Query(None, ge=1),
    service: RouteService = Depends(get_service),
) -> ShapeGeoJson:
    return await service.shape(route_id, direction_id, pattern_id)


@router.get(
    "/{route_id}/trips",
    summary="Trips of a route on a date",
    description="Trips whose service is active on service_date (calendar + exceptions).",
    response_model=list[TripSummary],
    responses={404: {"model": ErrorResponse}},
)
async def route_trips(
    route_id: int,
    service_date: date = Query(..., description="Service date (YYYY-MM-DD)"),
    service: RouteService = Depends(get_service),
) -> list[TripSummary]:
    return await service.trips_on_date(route_id, service_date)
