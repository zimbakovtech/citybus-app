-- CityBus indexes.
--
-- Strategy:
--  * Geometry GiST for KNN and a geography-expression GiST for meter-based
--    ST_DWithin filtering in /stops/nearby.
--  * GIN + gin_trgm_ops on searchable text (stop and route names) — powers
--    fast fuzzy/substring ILIKE search.
--  * B-tree composites for the hot schedule lookups: departures at a stop
--    ordered by time, and a trip's stop_times in sequence order.
--  * B-trees on queried foreign keys and telemetry lookup paths.

CREATE INDEX idx_stops_geom              ON stops USING GIST (geom);
CREATE INDEX idx_stops_geography         ON stops USING GIST ((geom::geography));
CREATE INDEX idx_stops_name_trgm         ON stops USING GIN (name gin_trgm_ops);
CREATE INDEX idx_routes_shortname_trgm   ON routes USING GIN (short_name gin_trgm_ops);
CREATE INDEX idx_routes_longname_trgm    ON routes USING GIN (long_name  gin_trgm_ops);
CREATE INDEX idx_routes_agency           ON routes (agency_id);
CREATE INDEX idx_stops_parent            ON stops (parent_station_id);
CREATE INDEX idx_trips_route_service     ON trips (route_id, service_id);
CREATE INDEX idx_trips_service           ON trips (service_id);
CREATE INDEX idx_trips_shape             ON trips (shape_id);
CREATE INDEX idx_trips_route_pattern     ON trips (route_pattern_id);
CREATE INDEX idx_stop_times_stop_dep     ON stop_times (stop_id, departure_time);
CREATE INDEX idx_route_patterns_route    ON route_patterns (route_id);
CREATE INDEX idx_route_patterns_shape    ON route_patterns (shape_id);
CREATE INDEX idx_route_pattern_stops_stop ON route_pattern_stops (stop_id);
CREATE INDEX idx_current_vpos_recorded   ON current_vehicle_positions (recorded_at);
CREATE INDEX idx_current_vpos_trip       ON current_vehicle_positions (trip_id);
CREATE INDEX idx_current_vpos_stop       ON current_vehicle_positions (current_stop_id);
CREATE INDEX idx_vpos_history_vehicle_recorded
    ON vehicle_position_history (vehicle_id, recorded_at DESC);
CREATE INDEX idx_vpos_history_trip_recorded
    ON vehicle_position_history (trip_id, recorded_at DESC);
CREATE INDEX idx_vpos_history_stop       ON vehicle_position_history (current_stop_id);
