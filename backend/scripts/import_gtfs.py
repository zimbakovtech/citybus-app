#!/usr/bin/env python3
"""Load a GTFS feed (directory of .txt files or a .zip) into the database.

Usage:
    python scripts/import_gtfs.py [path-to-feed]

The path defaults to GTFS_ZIP_PATH from .env (the committed sample feed).
Re-running is safe: the importer truncates the GTFS tables first.
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
from app.services.gtfs_import_service import GtfsImportService  # noqa: E402
from app.services.gtfs_validation import GtfsValidationError  # noqa: E402

logger = logging.getLogger("import_gtfs")


async def main(feed_path: str) -> None:
    async with SessionFactory() as session:
        service = GtfsImportService(session)
        try:
            counts = await service.import_feed(feed_path)
        except GtfsValidationError as exc:
            logger.error("%s", exc)
            for issue in exc.issues:
                logger.error("  %s", issue)
            raise SystemExit(2) from exc
    await engine.dispose()

    total = sum(counts.values())
    logger.info("import complete: %d rows across %d tables", total, len(counts))


if __name__ == "__main__":
    configure_logging()
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "path",
        nargs="?",
        default=settings.gtfs_zip_path,
        help="GTFS feed: directory of .txt files or a .zip (default: %(default)s)",
    )
    args = parser.parse_args()
    asyncio.run(main(args.path))
