# Database design

The schema models a city bus network in the shape of the
[GTFS static specification](https://gtfs.org/documentation/schedule/reference/),
normalized into relational tables. The canonical, commented DDL lives in
[`database/sql/`](../database/sql) — `01_schema.sql` (tables) and
`02_indexes.sql` (indexes). Alembic revision `0001` owns an immutable snapshot
of the original schema; later revisions upgrade it incrementally to the
canonical schema documented here.

## Grain

The finest-grained table is **`stop_times`**: one row per *(trip, stop)*
scheduled event — one arrival/departure of one vehicle run at one stop.
Everything else describes or aggregates around it:

- `trips` groups the stop events of one vehicle run; `routes` groups trips
  into the line riders know; `agency` owns routes.
- `services` + `calendar` + `calendar_dates` say **on which dates** a trip runs.
- `stops`, `shapes`/`shape_points` carry the **where** (PostGIS geometries).
- `route_patterns` groups trips that share a direction, shape and ordered stop
  sequence, so branches and short turns are represented explicitly.
- `current_vehicle_positions` is the live state; `vehicle_position_history` is
  the append-only, daily-partitioned telemetry log.

## Design decisions

### Surrogate keys, natural keys preserved

GTFS entity tables have a `bigint GENERATED ALWAYS AS IDENTITY` primary key,
while relationship tables use composite keys. The original GTFS string
identifier is kept as a `UNIQUE` natural key
(`gtfs_route_id`, `gtfs_stop_id`, …). Foreign keys reference the surrogate
keys. Rationale:

- 8-byte joins and index entries instead of arbitrary-length text.
- GTFS ids are only unique *within one feed*. This project stores one active
  feed and currently reallocates surrogate keys on a full feed reload.
- The importer resolves string ids → surrogate ids via in-memory lookup maps,
  which demonstrates the surrogate-vs-natural-key distinction explicitly.

### `services` as its own entity

GTFS has no `services.txt` — `service_id` just appears in `calendar.txt`,
`calendar_dates.txt` and `trips.txt`. Modeling it as a `services` table that
all three reference normalizes the schema (one entity, one row) and supports
feeds that define service purely via `calendar_dates` exceptions with no
weekly `calendar` row at all.

### `interval` for times past midnight

GTFS times may exceed `24:00:00` — a trip leaving at 23:45 arrives at its last
stop at e.g. `24:29:00`, *still labeled with the previous service day*. A
`time` column caps at 24 h and would corrupt such feeds, so
`stop_times.arrival_time`/`departure_time` are **`interval`** (duration since
the service day's midnight). The seed feed includes a night trip past
24:00:00 to exercise this. Consumers handle it explicitly: the departures
endpoint and the planner query *yesterday's* services with a +24 h-shifted
window in addition to today's.

### Derived shape geometry

`shape_points` stores the raw ordered vertices exactly as the feed delivers
them; the importer then assembles each `shapes.geom` **LineString** with
`ST_MakeLine(ST_MakePoint(lon, lat) ORDER BY pt_sequence)`. A route polyline
for the map is therefore a single-row fetch (`ST_AsGeoJSON(shapes.geom)`),
not a 20-row aggregation per request.

### PostGIS usage

- Point geometry is a stored generated column derived from `lon`/`lat`, so the
  scalar coordinates and PostGIS value cannot drift.
- `stops.geom` and both vehicle-position geometries are `geometry(Point, 4326)`;
  `shapes.geom` is `geometry(LineString, 4326)`. WGS84 throughout; note
  PostGIS points are **(X, Y) = (lon, lat)**.
- *Nearby stops* filters with `ST_DWithin` on `geom::geography` (correct
  meters on the ellipsoid) and orders with the geometry KNN operator `<->`.
  Separate matching GiST indexes serve the geography filter and geometry order.
- The planner snaps free coordinates to the nearest stop with a KNN lookup.

### Indexing strategy

| Index | Serves |
|---|---|
| GiST on `stops.geom` and `(stops.geom::geography)` | KNN ordering and meter-based `ST_DWithin` filters |
| GIN `gin_trgm_ops` on `stops.name`, `routes.short_name`/`long_name` | fuzzy `ILIKE '%…%'` search |
| B-tree `(stop_id, departure_time)` on `stop_times` | departures at a stop, time-windowed |
| `stop_times` primary key `(trip_id, stop_sequence)` | a trip's ordered stops; the planner's connection scan |
| Unique `(service_id, date)` on `calendar_dates` | active-service resolution |
| B-tree `(route_id, service_id)` on `trips` | route/date trip listings |
| B-tree `(vehicle_id, recorded_at DESC)` on history | per-vehicle telemetry history |

### Constraints

`NOT NULL` everywhere it is meaningful, `UNIQUE` on natural keys and
`(shape_id, pt_sequence)` / `(service_id, date)`, `CHECK` constraints encode
the GTFS enums (`exception_type IN (1,2)`, `pickup_type IN (0,1,2,3)`, …),
and every FK declares a deliberate `ON DELETE` policy: `CASCADE` down the
composition hierarchy (route → trips → stop_times), `SET NULL` for optional
references (trip → shape, vehicle → trip).

## Route patterns

A pattern is unique by route, direction, shape and ordered stop IDs. Trips on
different service calendars or departure times reuse the same pattern. The
route stops and shape endpoints choose the most-used matching pattern by
default and also accept an explicit `pattern_id` for branch-aware clients.

## Realtime storage

Every simulation tick appends to `vehicle_position_history` and upserts
`current_vehicle_positions` in one transaction. History is partitioned by UTC
day; maintenance retains today plus the previous 29 days, precreates seven
future partitions, and drops expired partitions. Live snapshots query only the
small current-state table and keep the existing 60-second recency filter.

## Active-service resolution

“Which services run on date D?” combines both calendar tables; exceptions win:

```sql
SELECT s.id
FROM services s
LEFT JOIN calendar c        ON c.service_id = s.id
LEFT JOIN calendar_dates cd ON cd.service_id = s.id AND cd.date = :d
WHERE CASE
    WHEN cd.exception_type = 1 THEN true      -- added for this date
    WHEN cd.exception_type = 2 THEN false     -- removed for this date
    ELSE c.service_id IS NOT NULL
         AND :d BETWEEN c.start_date AND c.end_date
         AND (ARRAY[c.sunday, c.monday, …, c.saturday])[EXTRACT(dow FROM :d)::int + 1]
END
```

The seed feed's holiday (2026-09-08, a Tuesday) removes the WEEKDAY service
and adds the WEEKEND one, exercising both branches.

## ERD

See [`erd.mmd`](erd.mmd) (rendered in the root README).
