# CityBus backend

FastAPI + SQLAlchemy 2 (async) + PostGIS. See the root README for the full
picture; this is the quick reference.

```bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
alembic upgrade head                 # applies immutable, incremental revisions
python scripts/import_gtfs.py        # seed feed; idempotent (truncate + reload)
uvicorn app.main:app --reload        # http://localhost:8000/docs
pytest                               # needs the seeded database
ruff check app scripts && black --check app scripts
```

Layout: `app/api/v1/endpoints` (HTTP) → `app/services` (logic: CSA planner,
departures, realtime simulation) → `app/repositories` (all SQL) →
`app/core` (config, async engine, logging, exceptions). `app/models` holds the
ORM (one file per table), `app/schemas` the Pydantic response models,
`app/websocket` the connection manager + `/ws/realtime` handler.

Alembic revision `0001` owns an immutable snapshot of the original DDL;
subsequent schema changes are incremental migrations. `../database/sql/`
documents the complete schema at the current head revision.
