-- Scaled synthetic CityBus network for benchmarking.
-- Run AFTER database/sql/00_extensions.sql + 01_schema.sql and BEFORE
-- 02_indexes.sql, so the canonical indexes are built once over the full data.
--
--   10 000 stops · 500 routes (15-40 stops each) · 1 000 route patterns/shapes
--   ~110 000 trips · ~3 000 000 stop_times · 5 days of vehicle telemetry
--
-- Deterministic: setseed() + arithmetic, so re-runs produce the same feed.

\set ON_ERROR_STOP on
\timing on

SELECT setseed(0.42);

INSERT INTO agency (gtfs_agency_id, name, url, timezone, lang)
VALUES ('BENCH', 'CityBus Bench', 'https://citybus.example', 'Europe/Skopje', 'mk');

-- stops: uniform over a ~44 x 41 km box around Skopje (~5.5 stops / km2)
INSERT INTO stops (gtfs_stop_id, code, name, lat, lon)
SELECT 'S' || g,
       'C' || g,
       (ARRAY['Centar','Karpos','Aerodrom','Kisela Voda','Gazi Baba','Chair','Butel',
              'Gjorche Petrov','Saraj','Shuto Orizari','Lisice','Taftalidze','Vlae',
              'Drachevo','Madzari','Avtokomanda','Bit Pazar','Debar Maalo','Kapistec',
              'Zelezara'])[1 + g % 20]
       || ' ' ||
       (ARRAY['Pazar','Park','Skola','Klinika','Plostad','Most','Stanica','Ulica',
              'Maalo','Kruzen tek'])[1 + (g / 20) % 10]
       || ' ' || g,
       41.80 + random() * 0.40,
       21.20 + random() * 0.50
FROM generate_series(1, 10000) g;

-- order stops along a space-filling curve so consecutive stops are close:
-- a route is a run of consecutive positions, i.e. a geographically coherent line
CREATE TEMP TABLE stop_pos AS
SELECT id AS stop_id,
       (row_number() OVER (ORDER BY ST_GeoHash(geom, 12)) - 1)::int AS pos
FROM stops;
CREATE UNIQUE INDEX ON stop_pos (pos);

INSERT INTO routes (gtfs_route_id, agency_id, short_name, long_name, route_type, color, text_color)
SELECT 'R' || r, (SELECT id FROM agency), r::text, 'Linija ' || r, 3,
       lpad(to_hex((r * 2654435) % 16777216), 6, '0'), 'FFFFFF'
FROM generate_series(1, 500) r;

-- direction 0 stop list of each route: 15..40 consecutive curve positions
CREATE TEMP TABLE route_stop_seq AS
SELECT r.id AS route_id,
       k    AS stop_order,
       sp.stop_id,
       (60 + ((r.id * 31 + k * 17) % 121))::int AS hop_s     -- 60..180 s per hop
FROM routes r
CROSS JOIN LATERAL generate_series(1, 15 + (r.id * 37) % 26) k
JOIN stop_pos sp ON sp.pos = (((r.id - 1) * 20) + k - 1) % 10000;

-- both directions, with cumulative travel offset from the first stop
CREATE TEMP TABLE pattern_stops AS
WITH both_dirs AS (
    SELECT route_id, 0 AS direction_id, stop_order, stop_id, hop_s
    FROM route_stop_seq
    UNION ALL
    SELECT route_id, 1,
           max(stop_order) OVER (PARTITION BY route_id) + 1 - stop_order,
           stop_id, hop_s
    FROM route_stop_seq
)
SELECT route_id, direction_id, stop_order, stop_id,
       sum(CASE WHEN stop_order = 1 THEN 0 ELSE hop_s END)
           OVER (PARTITION BY route_id, direction_id ORDER BY stop_order)::int AS offset_s
FROM both_dirs;

INSERT INTO shapes (gtfs_shape_id)
SELECT 'SHP-' || r.gtfs_route_id || '-D' || d
FROM routes r CROSS JOIN generate_series(0, 1) d
ORDER BY r.id, d;

-- shape vertices: 10 points per stop-to-stop hop plus the final stop
CREATE TEMP TABLE pattern_coords AS
SELECT p.route_id, p.direction_id, p.stop_order, s.lat, s.lon,
       sh.id AS shape_id,
       max(p.stop_order) OVER (PARTITION BY p.route_id, p.direction_id) AS last_order
FROM pattern_stops p
JOIN stops s   ON s.id = p.stop_id
JOIN routes r  ON r.id = p.route_id
JOIN shapes sh ON sh.gtfs_shape_id = 'SHP-' || r.gtfs_route_id || '-D' || p.direction_id;

INSERT INTO shape_points (shape_id, pt_sequence, lat, lon)
SELECT a.shape_id,
       (a.stop_order - 1) * 10 + i + 1,
       a.lat + (b.lat - a.lat) * i / 10.0 + CASE WHEN i % 2 = 1 THEN 0.0002 ELSE 0 END,
       a.lon + (b.lon - a.lon) * i / 10.0
FROM pattern_coords a
JOIN pattern_coords b
  ON b.route_id = a.route_id AND b.direction_id = a.direction_id
 AND b.stop_order = a.stop_order + 1
CROSS JOIN generate_series(0, 9) i
UNION ALL
SELECT shape_id, (stop_order - 1) * 10 + 1, lat, lon
FROM pattern_coords
WHERE stop_order = last_order;

-- same statement the importer runs: one LineString per shape
UPDATE shapes s
SET geom = sub.line
FROM (
    SELECT shape_id,
           ST_MakeLine(ST_SetSRID(ST_MakePoint(lon, lat), 4326) ORDER BY pt_sequence) AS line
    FROM shape_points
    GROUP BY shape_id
) sub
WHERE sub.shape_id = s.id;

INSERT INTO services (gtfs_service_id) VALUES ('WEEKDAY'), ('WEEKEND');
INSERT INTO calendar (service_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday,
                      start_date, end_date)
SELECT id, wd, wd, wd, wd, wd, NOT wd, NOT wd, DATE '2026-01-01', DATE '2026-12-31'
FROM (SELECT id, gtfs_service_id = 'WEEKDAY' AS wd FROM services) s;
INSERT INTO calendar_dates (service_id, date, exception_type)
SELECT id, DATE '2026-09-08', CASE gtfs_service_id WHEN 'WEEKDAY' THEN 2 ELSE 1 END
FROM services;

INSERT INTO route_patterns (route_id, direction_id, shape_id, stop_signature)
SELECT p.route_id, p.direction_id, pc.shape_id, array_agg(p.stop_id ORDER BY p.stop_order)
FROM pattern_stops p
JOIN (SELECT DISTINCT route_id, direction_id, shape_id FROM pattern_coords) pc
  ON pc.route_id = p.route_id AND pc.direction_id = p.direction_id
GROUP BY p.route_id, p.direction_id, pc.shape_id;

INSERT INTO route_pattern_stops (pattern_id, stop_order, stop_id)
SELECT rp.id, p.stop_order, p.stop_id
FROM route_patterns rp
JOIN pattern_stops p ON p.route_id = rp.route_id AND p.direction_id = rp.direction_id;

-- trips: weekday 06:00-23:00 every 10-20 min, weekend 07:00-22:00 every 15-30 min
CREATE TEMP TABLE trip_plan AS
SELECT r.id AS route_id, d AS direction_id, s.id AS service_id, dep_s,
       r.gtfs_route_id || '-D' || d || '-'
           || CASE s.gtfs_service_id WHEN 'WEEKDAY' THEN 'WD' ELSE 'WE' END || '-'
           || to_char(make_interval(secs => dep_s), 'HH24MI') AS gtfs_trip_id
FROM routes r
CROSS JOIN generate_series(0, 1) d
CROSS JOIN services s
CROSS JOIN LATERAL generate_series(
    CASE s.gtfs_service_id WHEN 'WEEKDAY' THEN 6 * 3600 ELSE 7 * 3600 END,
    CASE s.gtfs_service_id WHEN 'WEEKDAY' THEN 23 * 3600 ELSE 22 * 3600 END,
    CASE s.gtfs_service_id WHEN 'WEEKDAY' THEN (10 + r.id % 11) * 60
                                          ELSE (15 + r.id % 16) * 60 END
) dep_s;

INSERT INTO trips (gtfs_trip_id, route_id, service_id, shape_id, route_pattern_id,
                   headsign, direction_id)
SELECT tp.gtfs_trip_id, tp.route_id, tp.service_id, rp.shape_id, rp.id,
       'Terminus ' || tp.route_id || '/' || tp.direction_id, tp.direction_id
FROM trip_plan tp
JOIN route_patterns rp ON rp.route_id = tp.route_id AND rp.direction_id = tp.direction_id
ORDER BY tp.route_id, tp.direction_id, tp.service_id, tp.dep_s;

-- stop_times in trip order, as the importer writes them from stop_times.txt
INSERT INTO stop_times (trip_id, stop_id, stop_sequence, arrival_time, departure_time)
SELECT t.id, p.stop_id, p.stop_order,
       make_interval(secs => tp.dep_s + p.offset_s),
       make_interval(secs => tp.dep_s + p.offset_s)
FROM trip_plan tp
JOIN trips t         ON t.gtfs_trip_id = tp.gtfs_trip_id
JOIN pattern_stops p ON p.route_id = tp.route_id AND p.direction_id = tp.direction_id
ORDER BY t.id, p.stop_order;

-- ---------------------------------------------------------------------------
-- vehicle telemetry: what the simulator writes (25 vehicles, one row per
-- vehicle every 2 s) for the last 5 days -> ~5.4 M rows, stored twice:
--   * vehicle_position_history  (current design: daily partitions, rev. 0003)
--   * vehicle_positions         (old design: one heap table, rev. 0001/0002)
-- ---------------------------------------------------------------------------
SELECT maintain_vehicle_position_partitions((now() AT TIME ZONE 'UTC')::date - 5, 30, 12);

-- bulk load only: data is generated consistent, skip per-row FK triggers
SET session_replication_role = replica;

INSERT INTO vehicle_position_history
    (vehicle_id, trip_id, lat, lon, delay_seconds, current_stop_id, recorded_at)
SELECT 'BUS-' || v,
       v * 4000,
       41.90 + (tick % 1000) * 0.0001,
       21.40 + v * 0.001,
       (tick + v) % 300 - 60,
       1 + (tick * 7 + v) % 10000,
       ts
FROM generate_series(now() - interval '5 days', now() - interval '2 minutes',
                     interval '2 seconds') WITH ORDINALITY AS ticks(ts, tick)
CROSS JOIN generate_series(1, 25) v;

CREATE TABLE vehicle_positions (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    vehicle_id text NOT NULL,
    trip_id bigint REFERENCES trips(id) ON DELETE SET NULL,
    lat double precision NOT NULL CHECK (lat BETWEEN -90 AND 90),
    lon double precision NOT NULL CHECK (lon BETWEEN -180 AND 180),
    geom geometry(Point, 4326) GENERATED ALWAYS AS (
        ST_SetSRID(ST_MakePoint(lon, lat), 4326)
    ) STORED NOT NULL,
    delay_seconds integer NOT NULL DEFAULT 0,
    current_stop_id bigint REFERENCES stops(id) ON DELETE SET NULL,
    recorded_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO vehicle_positions
    (vehicle_id, trip_id, lat, lon, delay_seconds, current_stop_id, recorded_at)
SELECT vehicle_id, trip_id, lat, lon, delay_seconds, current_stop_id, recorded_at
FROM vehicle_position_history
ORDER BY recorded_at, vehicle_id;

SET session_replication_role = origin;

-- old-design indexes as they stood after revision 0002
CREATE INDEX idx_vpos_trip        ON vehicle_positions (trip_id);
CREATE INDEX idx_vpos_recorded_at ON vehicle_positions (recorded_at DESC);

SELECT 'stops' AS t, count(*) FROM stops
UNION ALL SELECT 'routes', count(*) FROM routes
UNION ALL SELECT 'route_patterns', count(*) FROM route_patterns
UNION ALL SELECT 'route_pattern_stops', count(*) FROM route_pattern_stops
UNION ALL SELECT 'shapes', count(*) FROM shapes
UNION ALL SELECT 'shape_points', count(*) FROM shape_points
UNION ALL SELECT 'trips', count(*) FROM trips
UNION ALL SELECT 'stop_times', count(*) FROM stop_times
UNION ALL SELECT 'vehicle_position_history', count(*) FROM vehicle_position_history
UNION ALL SELECT 'vehicle_positions (old)', count(*) FROM vehicle_positions;
