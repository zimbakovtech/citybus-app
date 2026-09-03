"""GTFS preflight validation and atomic rejection."""

import shutil
from pathlib import Path

import pytest
from sqlalchemy import func, select

from app.core.database import SessionFactory
from app.models import Stop
from app.services.gtfs_import_service import GtfsFeed, GtfsImportService
from app.services.gtfs_validation import GtfsValidationError, validate_feed

SEED = Path(__file__).resolve().parents[3] / "database" / "seed" / "gtfs"


def _invalid_feed(tmp_path: Path) -> Path:
    destination = tmp_path / "gtfs"
    shutil.copytree(SEED, destination)
    stops = destination / "stops.txt"
    stops.write_text(stops.read_text().replace("41.9857", "999", 1))
    routes = destination / "routes.txt"
    routes.write_text(routes.read_text().replace("D32F2F", "NOTHEX", 1))
    return destination


def test_committed_feed_passes_preflight_validation() -> None:
    result = validate_feed(GtfsFeed(SEED))
    assert len(result.trip_stop_ids) == 682
    assert sum(len(stops) for stops in result.trip_stop_ids.values()) == 6396


def test_validation_collects_multiple_actionable_issues(tmp_path: Path) -> None:
    with pytest.raises(GtfsValidationError) as caught:
        validate_feed(GtfsFeed(_invalid_feed(tmp_path)))

    assert caught.value.total_issues >= 2
    assert {issue.code for issue in caught.value.issues} >= {"out_of_range", "invalid_color"}
    assert all(issue.file for issue in caught.value.issues)


async def test_invalid_feed_does_not_truncate_committed_data(tmp_path: Path) -> None:
    async with SessionFactory() as session:
        before = await session.scalar(select(func.count()).select_from(Stop))
        with pytest.raises(GtfsValidationError):
            await GtfsImportService(session).import_feed(_invalid_feed(tmp_path))
        after = await session.scalar(select(func.count()).select_from(Stop))

    assert before == after == 30
