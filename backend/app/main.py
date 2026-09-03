"""CityBus API application entry point."""

import asyncio
import contextlib
import logging
from collections.abc import AsyncIterator

from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from app.api.v1.router import api_router
from app.core.config import settings
from app.core.database import SessionFactory
from app.core.exceptions import InvalidRequestError, NotFoundError
from app.core.logging import configure_logging
from app.services.realtime_service import RealtimeService
from app.websocket.handlers import ws_router
from app.websocket.manager import manager

configure_logging()
logger = logging.getLogger(__name__)


async def _realtime_loop() -> None:
    """Background task: advance the vehicle simulation and broadcast updates."""
    async with SessionFactory() as session:
        service = RealtimeService(session)
        while True:
            try:
                for message in await service.tick():
                    await manager.broadcast(message)
            except Exception:
                logger.exception("realtime tick failed")
            await asyncio.sleep(settings.realtime_tick_seconds)


@contextlib.asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncIterator[None]:
    task = asyncio.create_task(_realtime_loop()) if settings.realtime_enabled else None
    yield
    if task is not None:
        task.cancel()
        with contextlib.suppress(asyncio.CancelledError):
            await task


app = FastAPI(
    title="CityBus API",
    description=(
        "Public-transport API over a GTFS-modeled PostGIS database: stops, "
        "routes, schedules, a journey planner and simulated realtime vehicles."
    ),
    version="1.0.0",
    lifespan=lifespan,
)

# local development only: the Flutter app runs on a device/emulator origin
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.exception_handler(NotFoundError)
async def not_found_handler(request: Request, exc: NotFoundError) -> JSONResponse:
    return JSONResponse(status_code=404, content={"detail": str(exc)})


@app.exception_handler(InvalidRequestError)
async def invalid_request_handler(request: Request, exc: InvalidRequestError) -> JSONResponse:
    return JSONResponse(status_code=422, content={"detail": str(exc)})


app.include_router(api_router)
app.include_router(ws_router)
