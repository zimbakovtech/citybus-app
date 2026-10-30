-- Same hot queries on the committed seed feed (database "citybus"), to show
-- how the picture changes with scale.

\set ON_ERROR_STOP on
\pset format unaligned
\pset tuples_only on
\pset fieldsep '|'
\pset pager off

SELECT id AS svc_weekday FROM services WHERE gtfs_service_id = 'WEEKDAY' \gset
SELECT stop_id AS dep_stop FROM route_pattern_stops GROUP BY stop_id
ORDER BY count(DISTINCT pattern_id) DESC, stop_id LIMIT 1 \gset
SELECT 'param', 'seed_dep_stop', :dep_stop;
SELECT 'param', 'seed_stop_times', count(*) FROM stop_times;

\set q_nearby 'SELECT id, name, code, lat, lon, ST_Distance(geom::geography, ST_SetSRID(ST_MakePoint(21.4314, 41.9947), 4326)::geography) AS distance_m FROM stops WHERE ST_DWithin(geom::geography, ST_SetSRID(ST_MakePoint(21.4314, 41.9947), 4326)::geography, 500) ORDER BY geom <-> ST_SetSRID(ST_MakePoint(21.4314, 41.9947), 4326) LIMIT 10'
SELECT 'seed_nearby', 'current', * FROM bench_run(:'q_nearby');
BEGIN;
DROP INDEX idx_stops_geography;
DROP INDEX idx_stops_geom;
SELECT 'seed_nearby', 'no_spatial_index', * FROM bench_run(:'q_nearby');
ROLLBACK;

\set q_search_page 'SELECT * FROM stops WHERE name ILIKE ''%centar%'' ORDER BY name, id LIMIT 20 OFFSET 0'
SELECT 'seed_search_page', 'current', * FROM bench_run(:'q_search_page');
BEGIN;
DROP INDEX idx_stops_name_trgm;
SELECT 'seed_search_page', 'no_trgm_index', * FROM bench_run(:'q_search_page');
ROLLBACK;

\set q_dep_tpl 'SELECT st.trip_id, st.stop_sequence, st.departure_time, t.headsign, r.id AS route_id, r.short_name, r.long_name, r.color FROM stop_times st JOIN trips t ON t.id = st.trip_id JOIN routes r ON r.id = t.route_id WHERE st.stop_id = %s AND t.service_id IN (%s) AND st.departure_time >= interval ''08:00'' AND st.departure_time <= interval ''09:00'' AND st.stop_sequence < (SELECT max(st2.stop_sequence) FROM stop_times st2 WHERE st2.trip_id = t.id) ORDER BY st.departure_time'
SELECT format(:'q_dep_tpl', :dep_stop, :svc_weekday) AS q_dep \gset
SELECT 'seed_departures', 'current', * FROM bench_run(:'q_dep');
BEGIN;
DROP INDEX idx_stop_times_stop_dep;
SELECT 'seed_departures', 'no_stop_dep_index', * FROM bench_run(:'q_dep');
ROLLBACK;
