-- CityBus benchmark on the scaled network (database "bench").
-- Every "before" variant drops an index inside a transaction that is rolled
-- back, so the canonical schema is never modified.
-- Output: case|variant|median_ms|min_ms|max_ms|plan   (and labelled extras)

\set ON_ERROR_STOP on
\pset format unaligned
\pset tuples_only on
\pset fieldsep '|'
\pset pager off

-- parameters -----------------------------------------------------------------
SELECT id AS svc_weekday FROM services WHERE gtfs_service_id = 'WEEKDAY' \gset
SELECT stop_id AS dep_stop
FROM route_pattern_stops GROUP BY stop_id
HAVING count(DISTINCT pattern_id) >= 4 ORDER BY stop_id LIMIT 1 \gset
SELECT id AS bench_route FROM routes WHERE gtfs_route_id = 'R250' \gset
SELECT t.id AS rep_trip
FROM trips t JOIN stop_times st ON st.trip_id = t.id
WHERE t.route_id = :bench_route AND t.direction_id = 0
GROUP BY t.id ORDER BY count(*) DESC, t.id LIMIT 1 \gset
SELECT rp.id AS def_pattern
FROM route_patterns rp JOIN trips t ON t.route_pattern_id = rp.id
WHERE rp.route_id = :bench_route AND rp.direction_id = 0
GROUP BY rp.id ORDER BY count(t.id) DESC, cardinality(rp.stop_signature) DESC, rp.id LIMIT 1 \gset

SELECT 'param', 'dep_stop', :dep_stop;
SELECT 'param', 'bench_route', :bench_route;
SELECT 'param', 'route_trips_dir0', count(*) FROM trips WHERE route_id = :bench_route AND direction_id = 0;
SELECT 'param', 'route_stop_times_dir0', count(*) FROM stop_times st JOIN trips t ON t.id = st.trip_id
       WHERE t.route_id = :bench_route AND t.direction_id = 0;
SELECT 'param', 'pattern_points', count(*) FROM shape_points sp JOIN route_patterns rp ON rp.shape_id = sp.shape_id
       WHERE rp.id = :def_pattern;
SELECT 'param', 'nearby_matches', count(*) FROM stops
       WHERE ST_DWithin(geom::geography, ST_SetSRID(ST_MakePoint(21.45, 42.0), 4326)::geography, 500);
SELECT 'param', 'search_matches', count(*) FROM stops WHERE name ILIKE '%karpos most%';

-- 1. nearby stops (exact StopRepository.nearby query) -------------------------
\set q_nearby 'SELECT id, name, code, lat, lon, ST_Distance(geom::geography, ST_SetSRID(ST_MakePoint(21.45, 42.0), 4326)::geography) AS distance_m FROM stops WHERE ST_DWithin(geom::geography, ST_SetSRID(ST_MakePoint(21.45, 42.0), 4326)::geography, 500) ORDER BY geom <-> ST_SetSRID(ST_MakePoint(21.45, 42.0), 4326) LIMIT 10'

SELECT 'nearby', 'current', * FROM bench_run(:'q_nearby');
BEGIN;
DROP INDEX idx_stops_geography;
SELECT 'nearby', 'rev0001_geometry_gist_only', * FROM bench_run(:'q_nearby');
ROLLBACK;
BEGIN;
DROP INDEX idx_stops_geography;
DROP INDEX idx_stops_geom;
SELECT 'nearby', 'no_spatial_index', * FROM bench_run(:'q_nearby');
ROLLBACK;

\echo ---plan nearby current---
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF) :q_nearby;
BEGIN;
DROP INDEX idx_stops_geography;
\echo ---plan nearby rev0001---
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF) :q_nearby;
ROLLBACK;

-- 1b. the same request from 200 random locations in one statement, so the
-- result does not hinge on one point (time / 200 = average per request)
SELECT setseed(0.7);
CREATE TEMP TABLE bench_points AS
SELECT g AS id, 41.80 + random() * 0.40 AS lat, 21.20 + random() * 0.50 AS lon
FROM generate_series(1, 200) g;
ANALYZE bench_points;
CREATE TEMP TABLE bench_point_matches AS
SELECT p.id, (SELECT count(*) FROM stops s
              WHERE ST_DWithin(s.geom::geography,
                               ST_SetSRID(ST_MakePoint(p.lon, p.lat), 4326)::geography, 500)) AS n
FROM bench_points p;
SELECT 'param', 'points_avg_matches', round(avg(n), 2) FROM bench_point_matches;
SELECT 'param', 'points_with_lt10_matches', count(*) FILTER (WHERE n < 10) FROM bench_point_matches;

\set q_nearby_multi 'SELECT p.id, n.* FROM bench_points p CROSS JOIN LATERAL (SELECT s.id AS stop_id, ST_Distance(s.geom::geography, ST_SetSRID(ST_MakePoint(p.lon, p.lat), 4326)::geography) AS distance_m FROM stops s WHERE ST_DWithin(s.geom::geography, ST_SetSRID(ST_MakePoint(p.lon, p.lat), 4326)::geography, 500) ORDER BY s.geom <-> ST_SetSRID(ST_MakePoint(p.lon, p.lat), 4326) LIMIT 10) n'
SELECT 'nearby_200', 'current', * FROM bench_run(:'q_nearby_multi', 7, 2);
BEGIN;
DROP INDEX idx_stops_geography;
SELECT 'nearby_200', 'rev0001_geometry_gist_only', * FROM bench_run(:'q_nearby_multi', 5, 1);
ROLLBACK;
BEGIN;
DROP INDEX idx_stops_geography;
DROP INDEX idx_stops_geom;
SELECT 'nearby_200', 'no_spatial_index', * FROM bench_run(:'q_nearby_multi', 5, 1);
ROLLBACK;

-- 2. snap a coordinate to the nearest stop (planner) --------------------------
\set q_nearest 'SELECT id FROM stops ORDER BY geom <-> ST_SetSRID(ST_MakePoint(21.45, 42.0), 4326) LIMIT 1'
SELECT 'nearest', 'current', * FROM bench_run(:'q_nearest');
BEGIN;
DROP INDEX idx_stops_geom;
SELECT 'nearest', 'no_spatial_index', * FROM bench_run(:'q_nearest');
ROLLBACK;

-- 3. stop search: count + first page (StopRepository.search) ------------------
\set q_search_count 'SELECT count(*) FROM (SELECT * FROM stops WHERE name ILIKE ''%karpos most%'') s'
\set q_search_page 'SELECT * FROM stops WHERE name ILIKE ''%karpos most%'' ORDER BY name, id LIMIT 20 OFFSET 0'
SELECT 'search_count', 'current', * FROM bench_run(:'q_search_count');
SELECT 'search_page', 'current', * FROM bench_run(:'q_search_page');
BEGIN;
DROP INDEX idx_stops_name_trgm;
SELECT 'search_count', 'no_trgm_index', * FROM bench_run(:'q_search_count');
SELECT 'search_page', 'no_trgm_index', * FROM bench_run(:'q_search_page');
ROLLBACK;

-- 4. departures at a stop, 60-minute window (StopRepository.departures) -------
\set q_dep_tpl 'SELECT st.trip_id, st.stop_sequence, st.departure_time, t.headsign, r.id AS route_id, r.short_name, r.long_name, r.color FROM stop_times st JOIN trips t ON t.id = st.trip_id JOIN routes r ON r.id = t.route_id WHERE st.stop_id = %s AND t.service_id IN (%s) AND st.departure_time >= interval ''08:00'' AND st.departure_time <= interval ''09:00'' AND st.stop_sequence < (SELECT max(st2.stop_sequence) FROM stop_times st2 WHERE st2.trip_id = t.id) ORDER BY st.departure_time'
SELECT format(:'q_dep_tpl', :dep_stop, :svc_weekday) AS q_dep \gset
SELECT 'param', 'departures_rows', count(*) FROM (SELECT 1 FROM stop_times st JOIN trips t ON t.id = st.trip_id
       WHERE st.stop_id = :dep_stop AND t.service_id = :svc_weekday
         AND st.departure_time BETWEEN interval '08:00' AND interval '09:00') x;
SELECT 'departures', 'current', * FROM bench_run(:'q_dep');
BEGIN;
DROP INDEX idx_stop_times_stop_dep;
SELECT 'departures', 'no_stop_dep_index', * FROM bench_run(:'q_dep', 11, 2);
ROLLBACK;
\echo ---plan departures current---
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF) :q_dep;
BEGIN;
DROP INDEX idx_stop_times_stop_dep;
\echo ---plan departures no index---
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF) :q_dep;
ROLLBACK;

-- 5. routes serving a stop (StopRepository.routes_serving_stop) ---------------
SELECT format('SELECT DISTINCT r.* FROM routes r JOIN trips t ON t.route_id = r.id JOIN stop_times st ON st.trip_id = t.id WHERE st.stop_id = %s ORDER BY r.id', :dep_stop) AS q_serving \gset
SELECT 'serving_routes', 'current', * FROM bench_run(:'q_serving');
BEGIN;
DROP INDEX idx_stop_times_stop_dep;
SELECT 'serving_routes', 'no_stop_dep_index', * FROM bench_run(:'q_serving', 11, 2);
ROLLBACK;

-- 6. ordered stops of a route: representative trip (<= rev 0003) vs pattern (rev 0004)
SELECT format('SELECT t.id FROM trips t JOIN stop_times st ON st.trip_id = t.id WHERE t.route_id = %s AND t.direction_id = 0 GROUP BY t.id ORDER BY count(*) DESC, t.id LIMIT 1', :bench_route) AS q_rs_old1 \gset
SELECT format('SELECT s.id, s.name, s.code, s.lat, s.lon, st.stop_sequence FROM stops s JOIN stop_times st ON st.stop_id = s.id WHERE st.trip_id = %s ORDER BY st.stop_sequence', :rep_trip) AS q_rs_old2 \gset
SELECT format('SELECT rp.id FROM route_patterns rp JOIN trips t ON t.route_pattern_id = rp.id WHERE rp.route_id = %s AND rp.direction_id = 0 GROUP BY rp.id ORDER BY count(t.id) DESC, cardinality(rp.stop_signature) DESC, rp.id LIMIT 1', :bench_route) AS q_rs_new1 \gset
SELECT format('SELECT s.id, s.name, s.code, s.lat, s.lon, rps.stop_order FROM stops s JOIN route_pattern_stops rps ON rps.stop_id = s.id WHERE rps.pattern_id = %s ORDER BY rps.stop_order', :def_pattern) AS q_rs_new2 \gset
SELECT 'route_stops_pick', 'old_representative_trip', * FROM bench_run(:'q_rs_old1');
SELECT 'route_stops_list', 'old_trip_stop_times', * FROM bench_run(:'q_rs_old2');
SELECT 'route_stops_pick', 'new_route_pattern', * FROM bench_run(:'q_rs_new1');
SELECT 'route_stops_list', 'new_pattern_stops', * FROM bench_run(:'q_rs_new2');

-- 7. route polyline: stored LineString vs assembling shape_points per request -
SELECT format('SELECT ST_AsGeoJSON(s.geom) FROM shapes s JOIN route_patterns rp ON rp.shape_id = s.id WHERE rp.id = %s AND s.geom IS NOT NULL', :def_pattern) AS q_shape_stored \gset
SELECT format('SELECT ST_AsGeoJSON(ST_MakeLine(ST_SetSRID(ST_MakePoint(sp.lon, sp.lat), 4326) ORDER BY sp.pt_sequence)) FROM shape_points sp JOIN route_patterns rp ON rp.shape_id = sp.shape_id WHERE rp.id = %s', :def_pattern) AS q_shape_built \gset
SELECT 'shape', 'stored_linestring', * FROM bench_run(:'q_shape_stored');
SELECT 'shape', 'built_per_request', * FROM bench_run(:'q_shape_built');

-- 8. realtime: top up the last 2 minutes, as a running simulator would --------
SET session_replication_role = replica;
CREATE TEMP TABLE topup AS
SELECT 'BUS-' || v AS vehicle_id, v * 4000 AS trip_id, 41.95::float8 AS lat,
       (21.40 + v * 0.001)::float8 AS lon, 30 AS delay_seconds, 1 + v AS current_stop_id, ts AS recorded_at
FROM generate_series(now() - interval '118 seconds', now(), interval '2 seconds') ts
CROSS JOIN generate_series(1, 25) v;
INSERT INTO vehicle_position_history (vehicle_id, trip_id, lat, lon, delay_seconds, current_stop_id, recorded_at)
SELECT * FROM topup;
INSERT INTO vehicle_positions (vehicle_id, trip_id, lat, lon, delay_seconds, current_stop_id, recorded_at)
SELECT * FROM topup;
INSERT INTO current_vehicle_positions (vehicle_id, trip_id, lat, lon, delay_seconds, current_stop_id, recorded_at)
SELECT DISTINCT ON (vehicle_id) * FROM topup ORDER BY vehicle_id, recorded_at DESC
ON CONFLICT (vehicle_id) DO UPDATE SET recorded_at = excluded.recorded_at;
SET session_replication_role = origin;
ANALYZE current_vehicle_positions;

\set q_live_old 'SELECT DISTINCT ON (vp.vehicle_id) vp.vehicle_id, vp.trip_id, vp.lat, vp.lon, vp.delay_seconds, vp.current_stop_id, vp.recorded_at, r.short_name AS route_short_name FROM vehicle_positions vp LEFT JOIN trips t ON t.id = vp.trip_id LEFT JOIN routes r ON r.id = t.route_id WHERE vp.recorded_at > now() - make_interval(secs => 60) ORDER BY vp.vehicle_id, vp.recorded_at DESC'
\set q_live_new 'SELECT DISTINCT ON (vp.vehicle_id) vp.vehicle_id, vp.trip_id, vp.lat, vp.lon, vp.delay_seconds, vp.current_stop_id, vp.recorded_at, r.short_name AS route_short_name FROM current_vehicle_positions vp LEFT JOIN trips t ON t.id = vp.trip_id LEFT JOIN routes r ON r.id = t.route_id WHERE vp.recorded_at > now() - make_interval(secs => 60) ORDER BY vp.vehicle_id, vp.recorded_at DESC'
SELECT 'live_snapshot', 'old_single_table', * FROM bench_run(:'q_live_old');
SELECT 'live_snapshot', 'new_current_table', * FROM bench_run(:'q_live_new');

\set q_vh_old 'SELECT recorded_at, lat, lon, delay_seconds FROM vehicle_positions WHERE vehicle_id = ''BUS-7'' AND recorded_at > now() - interval ''1 hour'' ORDER BY recorded_at DESC'
\set q_vh_new 'SELECT recorded_at, lat, lon, delay_seconds FROM vehicle_position_history WHERE vehicle_id = ''BUS-7'' AND recorded_at > now() - interval ''1 hour'' ORDER BY recorded_at DESC'
SELECT 'vehicle_last_hour', 'old_single_table', * FROM bench_run(:'q_vh_old');
SELECT 'vehicle_last_hour', 'new_partitioned', * FROM bench_run(:'q_vh_new');

-- 9. retention of one full day of telemetry -----------------------------------
SELECT ((now() AT TIME ZONE 'UTC')::date - 4)::text AS drop_day \gset
SELECT :'drop_day' || ' 00:00:00+00' AS d0, (:'drop_day'::date + 1)::text || ' 00:00:00+00' AS d1,
       'vehicle_position_history_' || to_char(:'drop_day'::date, 'YYYYMMDD') AS drop_part \gset
SELECT 'param', 'retention_day_rows', count(*) FROM vehicle_positions WHERE recorded_at >= :'d0' AND recorded_at < :'d1';
SELECT format('DELETE FROM vehicle_positions WHERE recorded_at >= %L AND recorded_at < %L', :'d0', :'d1') AS q_del_old \gset
SELECT format('DELETE FROM vehicle_position_history WHERE recorded_at >= %L AND recorded_at < %L', :'d0', :'d1') AS q_del_new \gset
SELECT format('DROP TABLE %I', :'drop_part') AS q_drop \gset

BEGIN; SELECT 'retention', 'old_delete_day', bench_time(:'q_del_old'); ROLLBACK;
BEGIN; SELECT 'retention', 'old_delete_day', bench_time(:'q_del_old'); ROLLBACK;
BEGIN; SELECT 'retention', 'old_delete_day', bench_time(:'q_del_old'); ROLLBACK;
BEGIN; SELECT 'retention', 'partitioned_delete_day', bench_time(:'q_del_new'); ROLLBACK;
BEGIN; SELECT 'retention', 'partitioned_delete_day', bench_time(:'q_del_new'); ROLLBACK;
BEGIN; SELECT 'retention', 'partitioned_delete_day', bench_time(:'q_del_new'); ROLLBACK;
BEGIN; SELECT 'retention', 'drop_partition', bench_time(:'q_drop'); ROLLBACK;
BEGIN; SELECT 'retention', 'drop_partition', bench_time(:'q_drop'); ROLLBACK;
BEGIN; SELECT 'retention', 'drop_partition', bench_time(:'q_drop'); ROLLBACK;

-- committed: what is left behind
SELECT 'retention_effect', 'old_size_before', pg_total_relation_size('vehicle_positions');
SELECT 'retention_effect', 'old_delete_ms', bench_time(:'q_del_old');
SELECT pg_sleep(2);
SELECT 'retention_effect', 'old_dead_tuples', n_dead_tup FROM pg_stat_user_tables WHERE relname = 'vehicle_positions';
SELECT 'retention_effect', 'old_size_after_delete', pg_total_relation_size('vehicle_positions');
SELECT extract(epoch FROM clock_timestamp()) AS vac_t0 \gset
VACUUM vehicle_positions;
SELECT 'retention_effect', 'old_vacuum_ms', round(((extract(epoch FROM clock_timestamp()) - :vac_t0) * 1000)::numeric, 1);
SELECT 'retention_effect', 'old_size_after_vacuum', pg_total_relation_size('vehicle_positions');
SELECT 'retention_effect', 'new_size_before', sum(pg_total_relation_size(inhrelid))
       FROM pg_inherits WHERE inhparent = 'vehicle_position_history'::regclass;
SELECT 'retention_effect', 'new_drop_ms', bench_time(:'q_drop');
SELECT 'retention_effect', 'new_size_after_drop', sum(pg_total_relation_size(inhrelid))
       FROM pg_inherits WHERE inhparent = 'vehicle_position_history'::regclass;

-- 10. storage: stop_times and its indexes; the redundant index removed in 0002
SELECT 'storage', 'stop_times_heap', pg_relation_size('stop_times');
SELECT 'storage', 'stop_times_pkey', pg_relation_size('stop_times_pkey');
SELECT 'storage', 'idx_stop_times_stop_dep', pg_relation_size('idx_stop_times_stop_dep');
BEGIN;
CREATE INDEX idx_stop_times_trip ON stop_times (trip_id, stop_sequence);
SELECT 'storage', 'redundant_idx_stop_times_trip', pg_relation_size('idx_stop_times_trip');
ROLLBACK;

-- 11. natural (GTFS text) keys instead of bigint surrogates --------------------
CREATE TABLE stop_times_natural AS
SELECT t.gtfs_trip_id AS trip_id, s.gtfs_stop_id AS stop_id, st.stop_sequence,
       st.arrival_time, st.departure_time, st.stop_headsign, st.pickup_type,
       st.drop_off_type, st.shape_dist_traveled
FROM stop_times st
JOIN trips t ON t.id = st.trip_id
JOIN stops s ON s.id = st.stop_id
ORDER BY st.trip_id, st.stop_sequence;
ALTER TABLE stop_times_natural ADD CONSTRAINT stop_times_natural_pkey PRIMARY KEY (trip_id, stop_sequence);
CREATE INDEX stop_times_natural_stop_dep ON stop_times_natural (stop_id, departure_time);
SELECT 'natural_keys', 'avg_trip_id_bytes', round(avg(octet_length(gtfs_trip_id)), 1) FROM trips;
SELECT 'natural_keys', 'avg_stop_id_bytes', round(avg(octet_length(gtfs_stop_id)), 1) FROM stops;
SELECT 'natural_keys', 'heap', pg_relation_size('stop_times_natural');
SELECT 'natural_keys', 'pkey', pg_relation_size('stop_times_natural_pkey');
SELECT 'natural_keys', 'stop_dep', pg_relation_size('stop_times_natural_stop_dep');
DROP TABLE stop_times_natural;

-- 12. write cost of one extra (redundant) B-tree on a full stop_times load ----
CREATE TABLE st_clone (LIKE stop_times INCLUDING ALL);
SELECT 'write', 'load_pk_stopdep', bench_time('INSERT INTO st_clone SELECT * FROM stop_times');
TRUNCATE st_clone;
SELECT 'write', 'load_pk_stopdep', bench_time('INSERT INTO st_clone SELECT * FROM stop_times');
TRUNCATE st_clone;
CREATE INDEX st_clone_redundant ON st_clone (trip_id, stop_sequence);
SELECT 'write', 'load_plus_redundant', bench_time('INSERT INTO st_clone SELECT * FROM stop_times');
TRUNCATE st_clone;
SELECT 'write', 'load_plus_redundant', bench_time('INSERT INTO st_clone SELECT * FROM stop_times');
DROP TABLE st_clone;

-- 13. interval vs time for GTFS times past midnight ----------------------------
SELECT 'types', 'interval_24_29', '24:29:00'::interval::text;
DO $$
BEGIN
    PERFORM '24:29:00'::time;
EXCEPTION WHEN others THEN
    RAISE NOTICE 'types|time_24_29|%', SQLERRM;
END $$;
