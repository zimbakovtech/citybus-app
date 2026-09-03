# Architecture

## Components

```
                       ┌──────────────────────────────┐
                       │   Flutter app (mobile/)      │
                       │  Riverpod · GoRouter · Dio   │
                       │  flutter_map (OSM tiles)     │
                       └───────┬──────────────┬───────┘
                        REST /api/v1     WS /ws/realtime
                               │              │
                       ┌───────▼──────────────▼───────┐
                       │   FastAPI backend (backend/) │
                       │ endpoints → services → repos │
                       │  CSA planner · vehicle sim   │
                       └──────────────┬───────────────┘
                            SQLAlchemy (async, asyncpg)
                                      │
                       ┌──────────────▼───────────────┐
                       │  PostgreSQL 16 + PostGIS     │
                       │  GTFS schema · pg_trgm       │
                       │  (docker compose, service db)│
                       └──────────────▲───────────────┘
                                      │
                       ┌──────────────┴───────────────┐
                       │  GTFS feed (database/seed/)  │
                       │  scripts/import_gtfs.py      │
                       └──────────────────────────────┘
```

## Data flow

1. **Import** — `import_gtfs.py` reads a GTFS feed (committed synthetic Skopje
   feed by default, any real feed via `GTFS_ZIP_PATH`), resolves GTFS string
   ids to surrogate keys, builds PostGIS geometries (stop points, shape
   linestrings) and bulk-loads the schema.
2. **Query** — the API serves stops/routes/trips from the relational schema;
   spatial queries (nearby stops, coordinate snapping) run on GiST-indexed
   geometry, text search on trigram-indexed names, and departures resolve the
   active services for the date (calendar + calendar_dates).
3. **Plan** — `/planner` builds the day's connection array straight out of
   `stop_times` (LEAD window function) and runs the Connection Scan Algorithm
   in the service layer.
4. **Realtime** — a background task interpolates vehicle positions along
   active trips' schedules every ~2 s, appends partitioned history, upserts the
   current-state table, and broadcasts JSON messages to WebSocket subscribers.
5. **Mobile** — the Flutter app renders all of it: search lists, route
   polylines on OpenStreetMap tiles, journey plans, and live moving markers.

## Backend layering

```
api/v1/endpoints   HTTP concerns only (validation, status codes, OpenAPI)
      │
services           business logic (planner, departures windows, simulation)
      │
repositories       all SQL/ORM queries
      │
core               config, db engine/session, logging, domain exceptions
```

## Mobile structure

Feature-first: `features/{stops,routes,planner,live_tracking}/`, each split
into `data` (freezed models, Dio datasource, repository impl), `domain`
(repository interface) and `presentation` (Riverpod providers, pages,
widgets). Shared plumbing lives in `core/` (Dio client, WebSocket client,
env config, map scaffold, status views).
