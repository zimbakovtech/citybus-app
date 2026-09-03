"""Realtime simulation and WebSocket tests.

The simulation clock is frozen to a weekday morning (2026-05-04 08:00, Monday)
via RealtimeService.now_override so trips are guaranteed to be under way."""

from collections.abc import Iterator
from datetime import datetime

import pytest
from fastapi.testclient import TestClient
from httpx import AsyncClient
from sqlalchemy import text

from app.core.config import settings
from app.core.database import SessionFactory, engine
from app.main import app
from app.services.realtime_service import RealtimeService

MONDAY_MORNING = datetime(2026, 5, 4, 8, 0, 0)


@pytest.fixture
def frozen_clock() -> Iterator[None]:
    RealtimeService.now_override = MONDAY_MORNING
    yield
    RealtimeService.now_override = None


async def test_tick_produces_vehicles_and_live_snapshot(
    client: AsyncClient, frozen_clock: None
) -> None:
    async with SessionFactory() as session:
        messages = await RealtimeService(session).tick()

    assert messages, "expected active vehicles on a weekday morning"
    message = messages[0]
    assert message["type"] == "vehicle_position"
    assert message["vehicle_id"].startswith("BUS-")
    assert 41 < message["lat"] < 43 and 21 < message["lon"] < 22
    assert 0 <= message["bearing"] < 360
    assert -60 <= message["delay_seconds"] <= 600

    response = await client.get("/api/v1/live/vehicles")
    assert response.status_code == 200
    vehicles = response.json()
    by_id = {v["vehicle_id"]: v for v in vehicles}
    # the snapshot may also contain vehicles from other recent simulation runs
    # (60 s recency window), so check containment rather than equality
    assert {m["vehicle_id"] for m in messages} <= set(by_id)
    assert by_id[message["vehicle_id"]]["route_short_name"] == message["route_short_name"]


async def test_tick_appends_history_and_upserts_current_state(frozen_clock: None) -> None:
    async with SessionFactory() as session:
        before_history = await session.scalar(text("SELECT count(*) FROM vehicle_position_history"))
        service = RealtimeService(session)
        first = await service.tick()
        second = await service.tick()
        after_history = await session.scalar(text("SELECT count(*) FROM vehicle_position_history"))
        current_count = await session.scalar(
            text(
                "SELECT count(*) FROM current_vehicle_positions "
                "WHERE vehicle_id = ANY(:vehicle_ids)"
            ),
            {"vehicle_ids": [message["vehicle_id"] for message in first]},
        )

    assert first and len(second) == len(first)
    assert after_history == before_history + len(first) + len(second)
    assert current_count == len(first)


def test_websocket_snapshot_then_updates(frozen_clock: None) -> None:
    """A connecting client gets a snapshot first, then vehicle_position
    updates pushed by the simulation loop (started by the app lifespan)."""
    # TestClient drives the app in its own event loop; drop pooled connections
    # bound to other tests' loop (and again afterwards for the reverse)
    engine.sync_engine.dispose(close=False)
    original_tick = settings.realtime_tick_seconds
    settings.realtime_tick_seconds = 0.05
    try:
        with (
            TestClient(app) as test_client,
            test_client.websocket_connect("/ws/realtime") as websocket,
        ):
            snapshot = websocket.receive_json()
            assert snapshot["type"] == "snapshot"
            assert isinstance(snapshot["vehicles"], list)

            update = websocket.receive_json()
            assert update["type"] == "vehicle_position"
            assert update["vehicle_id"].startswith("BUS-")
            assert update["route_short_name"]
    finally:
        settings.realtime_tick_seconds = original_tick
        engine.sync_engine.dispose(close=False)
