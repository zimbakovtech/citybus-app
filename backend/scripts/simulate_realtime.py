#!/usr/bin/env python3
"""Standalone vehicle simulator (optional — the API runs the same loop as a
background task when REALTIME_ENABLED=true).

Writes simulated vehicle history and upserts current state every tick; useful
for populating realtime data without running the API.

Usage: python scripts/simulate_realtime.py [--ticks N]
"""

import argparse
import asyncio
import logging
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from app.core.config import settings  # noqa: E402
from app.core.database import SessionFactory, engine  # noqa: E402
from app.core.logging import configure_logging  # noqa: E402
from app.services.realtime_service import RealtimeService  # noqa: E402

logger = logging.getLogger("simulate_realtime")


async def main(ticks: int | None) -> None:
    async with SessionFactory() as session:
        service = RealtimeService(session)
        n = 0
        while ticks is None or n < ticks:
            messages = await service.tick()
            logger.info("tick %d: %d active vehicles", n, len(messages))
            n += 1
            if ticks is None or n < ticks:
                await asyncio.sleep(settings.realtime_tick_seconds)
    await engine.dispose()


if __name__ == "__main__":
    configure_logging()
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--ticks", type=int, default=None, help="stop after N ticks (default: run forever)"
    )
    args = parser.parse_args()
    asyncio.run(main(args.ticks))
