"""Route use-cases: search, detail, ordered stops, shape polyline, trips by date."""

from datetime import date

from sqlalchemy.ext.asyncio import AsyncSession

from app.core.exceptions import InvalidRequestError, NotFoundError
from app.core.gtfs_time import format_interval
from app.repositories.route_repository import RouteRepository
from app.repositories.service_repository import ServiceRepository
from app.schemas.common import Page
from app.schemas.route import (
    RouteDetail,
    RoutePatternSummary,
    RouteSummary,
    ShapeGeoJson,
    TripSummary,
)
from app.schemas.stop import StopSummary


class RouteService:
    def __init__(self, session: AsyncSession):
        self.routes = RouteRepository(session)
        self.services = ServiceRepository(session)

    async def search(self, query: str | None, limit: int, offset: int) -> Page[RouteSummary]:
        routes, total = await self.routes.search(query, limit, offset)
        return Page(
            items=[RouteSummary.model_validate(r, from_attributes=True) for r in routes],
            total=total,
            limit=limit,
            offset=offset,
        )

    async def detail(self, route_id: int) -> RouteDetail:
        row = await self.routes.get_with_agency(route_id)
        if row is None:
            raise NotFoundError("route", route_id)
        route = row.Route
        return RouteDetail(
            id=route.id,
            short_name=route.short_name,
            long_name=route.long_name,
            color=route.color,
            gtfs_route_id=route.gtfs_route_id,
            route_type=route.route_type,
            text_color=route.text_color,
            agency_name=row.agency_name,
        )

    async def patterns(self, route_id: int, direction_id: int | None) -> list[RoutePatternSummary]:
        if await self.routes.get(route_id) is None:
            raise NotFoundError("route", route_id)
        rows = await self.routes.patterns(route_id, direction_id)
        return [RoutePatternSummary.model_validate(row, from_attributes=True) for row in rows]

    async def _resolve_pattern_id(
        self,
        route_id: int,
        direction_id: int | None,
        pattern_id: int | None,
    ) -> int | None:
        if pattern_id is None:
            return await self.routes.default_pattern_id(route_id, direction_id)
        pattern = await self.routes.get_pattern(route_id, pattern_id)
        if pattern is None:
            raise NotFoundError("route pattern", pattern_id)
        if direction_id is not None and pattern.direction_id != direction_id:
            raise InvalidRequestError(
                f"route pattern {pattern_id} does not have direction_id={direction_id}"
            )
        return pattern.id

    async def ordered_stops(
        self, route_id: int, direction_id: int | None, pattern_id: int | None
    ) -> list[StopSummary]:
        if await self.routes.get(route_id) is None:
            raise NotFoundError("route", route_id)
        resolved_pattern_id = await self._resolve_pattern_id(route_id, direction_id, pattern_id)
        if resolved_pattern_id is None:
            return []
        rows = await self.routes.ordered_stops(resolved_pattern_id)
        return [StopSummary.model_validate(r, from_attributes=True) for r in rows]

    async def shape(
        self, route_id: int, direction_id: int | None, pattern_id: int | None
    ) -> ShapeGeoJson:
        if await self.routes.get(route_id) is None:
            raise NotFoundError("route", route_id)
        effective_direction = direction_id if pattern_id is not None else direction_id or 0
        resolved_pattern_id = await self._resolve_pattern_id(
            route_id, effective_direction, pattern_id
        )
        if resolved_pattern_id is None:
            raise NotFoundError("shape for route", route_id)
        geojson = await self.routes.shape_geojson(resolved_pattern_id)
        if geojson is None:
            raise NotFoundError("shape for route", route_id)
        return ShapeGeoJson(**geojson)

    async def trips_on_date(self, route_id: int, service_date: date) -> list[TripSummary]:
        if await self.routes.get(route_id) is None:
            raise NotFoundError("route", route_id)
        service_ids = await self.services.active_service_ids(service_date)
        rows = await self.routes.trips_on_date(route_id, service_ids)
        return [
            TripSummary(
                id=row.id,
                headsign=row.headsign,
                direction_id=row.direction_id,
                starts_at=format_interval(row.starts_at),
                ends_at=format_interval(row.ends_at),
            )
            for row in rows
        ]
