-- CityBus canonical schema.
--
-- The data model follows the GTFS (General Transit Feed Specification) static
-- format, normalized into a relational schema.
--
-- Design decisions (discussed in docs/database.md):
--  * GTFS entities use surrogate `bigint GENERATED ALWAYS AS IDENTITY` keys;
--    relationship tables use meaningful composite keys. Original GTFS string
--    identifiers remain UNIQUE natural keys.
--  * GTFS `service_id` is a logical entity referenced by both calendar and
--    calendar_dates, so it is normalized into its own `services` table.
--  * stop_times.arrival_time / departure_time are `interval`, NOT `time`:
--    GTFS times may exceed 24:00:00 for after-midnight service (e.g. 25:30:00),
--    which `time` cannot represent.
--  * shapes.geom is a LineString derived from the ordered shape_points rows at
--    import time, so a route polyline is a single-row fetch.
--
-- The finest-grained table is stop_times: one row per (trip, stop) scheduled
-- event. Everything else describes or aggregates around it.

-- ---------------------------------------------------------------------------
-- agency: the transit operator (GTFS agency.txt)
-- ---------------------------------------------------------------------------
CREATE TABLE agency (
    id              bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    gtfs_agency_id  text NOT NULL UNIQUE,
    name            text NOT NULL,
    url             text,
    timezone        text NOT NULL,
    lang            text,
    phone           text
);

COMMENT ON TABLE agency IS 'Transit operator (GTFS agency.txt). One row per operating company.';
COMMENT ON COLUMN agency.gtfs_agency_id IS 'Original GTFS string identifier, preserved as a natural key.';
COMMENT ON COLUMN agency.timezone IS 'IANA timezone the schedule times are expressed in (e.g. Europe/Skopje).';

-- ---------------------------------------------------------------------------
-- routes: a named bus line (GTFS routes.txt)
-- ---------------------------------------------------------------------------
CREATE TABLE routes (
    id                bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    gtfs_route_id     text NOT NULL UNIQUE,
    agency_id         bigint NOT NULL REFERENCES agency(id) ON DELETE CASCADE,
    short_name        text,
    long_name         text,
    route_type        smallint NOT NULL DEFAULT 3,   -- GTFS enum; 3 = bus
    color             char(6),                        -- hex RGB, no '#'
    text_color        char(6),
    CONSTRAINT routes_name_present CHECK (short_name IS NOT NULL OR long_name IS NOT NULL),
    CONSTRAINT routes_color_hex CHECK (color IS NULL OR color ~ '^[0-9A-Fa-f]{6}$'),
    CONSTRAINT routes_text_color_hex CHECK (text_color IS NULL OR text_color ~ '^[0-9A-Fa-f]{6}$')
);

COMMENT ON TABLE routes IS 'Bus line as riders know it (GTFS routes.txt), e.g. line "5". A route groups many trips.';
COMMENT ON COLUMN routes.route_type IS 'GTFS route_type enum; 3 = bus. Kept generic to allow other modes.';
COMMENT ON COLUMN routes.color IS 'Line color as 6-digit hex without the # prefix, for map/UI rendering.';

-- ---------------------------------------------------------------------------
-- stops: a physical stop or station (GTFS stops.txt)
-- ---------------------------------------------------------------------------
CREATE TABLE stops (
    id                 bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    gtfs_stop_id       text NOT NULL UNIQUE,
    code               text,
    name               text NOT NULL,
    description        text,
    lat                double precision NOT NULL,
    lon                double precision NOT NULL,
    geom               geometry(Point, 4326) GENERATED ALWAYS AS (
                           ST_SetSRID(ST_MakePoint(lon, lat), 4326)
                       ) STORED NOT NULL,
    location_type      smallint NOT NULL DEFAULT 0,   -- GTFS enum; 0 = stop/platform, 1 = station
    parent_station_id  bigint REFERENCES stops(id) ON DELETE SET NULL,
    CONSTRAINT stops_lat_range CHECK (lat BETWEEN -90 AND 90),
    CONSTRAINT stops_lon_range CHECK (lon BETWEEN -180 AND 180),
    CONSTRAINT stops_location_type_range CHECK (location_type BETWEEN 0 AND 4),
    CONSTRAINT stops_parent_not_self CHECK (parent_station_id IS NULL OR parent_station_id <> id)
);

COMMENT ON TABLE stops IS 'Physical bus stop or station (GTFS stops.txt). geom mirrors lat/lon as a PostGIS point for spatial queries.';
COMMENT ON COLUMN stops.geom IS 'Stored generated point in WGS84 (SRID 4326), derived from lon/lat. Indexed with GiST for nearby-stop queries.';
COMMENT ON COLUMN stops.location_type IS 'GTFS enum: 0 = stop/platform, 1 = station grouping child stops.';
COMMENT ON COLUMN stops.parent_station_id IS 'Self-reference to a parent station row, when this stop is a platform of a station.';

-- ---------------------------------------------------------------------------
-- services: normalized GTFS service_id
-- ---------------------------------------------------------------------------
-- GTFS has no services.txt: service_id appears in calendar.txt,
-- calendar_dates.txt and trips.txt. Modeling it as its own entity normalizes
-- the schema and supports feeds that define services only via calendar_dates.
CREATE TABLE services (
    id               bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    gtfs_service_id  text NOT NULL UNIQUE
);

COMMENT ON TABLE services IS 'Logical service pattern (GTFS service_id), referenced by calendar, calendar_dates and trips.';

-- ---------------------------------------------------------------------------
-- calendar: weekly operating pattern of a service (GTFS calendar.txt)
-- ---------------------------------------------------------------------------
CREATE TABLE calendar (
    service_id  bigint PRIMARY KEY REFERENCES services(id) ON DELETE CASCADE,
    monday      boolean NOT NULL,
    tuesday     boolean NOT NULL,
    wednesday   boolean NOT NULL,
    thursday    boolean NOT NULL,
    friday      boolean NOT NULL,
    saturday    boolean NOT NULL,
    sunday      boolean NOT NULL,
    start_date  date NOT NULL,
    end_date    date NOT NULL,
    CONSTRAINT calendar_date_range CHECK (start_date <= end_date)
);

COMMENT ON TABLE calendar IS 'Weekly day-of-week pattern and validity window for a service (GTFS calendar.txt). 1:1 with services.';

-- ---------------------------------------------------------------------------
-- calendar_dates: per-date exceptions to calendar (GTFS calendar_dates.txt)
-- ---------------------------------------------------------------------------
CREATE TABLE calendar_dates (
    id              bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    service_id      bigint NOT NULL REFERENCES services(id) ON DELETE CASCADE,
    date            date NOT NULL,
    exception_type  smallint NOT NULL CHECK (exception_type IN (1, 2)), -- 1 = service added, 2 = removed
    UNIQUE (service_id, date)
);

COMMENT ON TABLE calendar_dates IS 'Date-specific exceptions (holidays etc.) to the weekly calendar (GTFS calendar_dates.txt).';
COMMENT ON COLUMN calendar_dates.exception_type IS 'GTFS enum: 1 = service runs on this date, 2 = service does not run.';

-- ---------------------------------------------------------------------------
-- shapes: the drawable polyline of a trip path (GTFS shapes.txt, header row)
-- ---------------------------------------------------------------------------
CREATE TABLE shapes (
    id             bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    gtfs_shape_id  text NOT NULL UNIQUE,
    geom           geometry(LineString, 4326)
);

COMMENT ON TABLE shapes IS 'One row per GTFS shape_id. geom is a LineString built from the ordered shape_points at import, so a route polyline is one query.';
COMMENT ON COLUMN shapes.geom IS 'Derived LineString (WGS84). NULL until the importer assembles it from shape_points.';

-- ---------------------------------------------------------------------------
-- shape_points: ordered vertices of a shape (GTFS shapes.txt, detail rows)
-- ---------------------------------------------------------------------------
CREATE TABLE shape_points (
    id             bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    shape_id       bigint NOT NULL REFERENCES shapes(id) ON DELETE CASCADE,
    pt_sequence    integer NOT NULL,
    lat            double precision NOT NULL,
    lon            double precision NOT NULL,
    dist_traveled  double precision,
    UNIQUE (shape_id, pt_sequence),
    CONSTRAINT shape_points_sequence_positive CHECK (pt_sequence > 0),
    CONSTRAINT shape_points_distance_nonnegative CHECK (
        dist_traveled IS NULL OR dist_traveled >= 0
    )
);

COMMENT ON TABLE shape_points IS 'Raw ordered vertices of each shape, as delivered in the GTFS feed. Source data for shapes.geom.';
COMMENT ON COLUMN shape_points.dist_traveled IS 'Optional GTFS cumulative distance along the shape, in feed-defined units.';

-- ---------------------------------------------------------------------------
-- route patterns: distinct direction/shape/ordered-stop variants of a route
-- ---------------------------------------------------------------------------
CREATE TABLE route_patterns (
    id              bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    route_id        bigint NOT NULL REFERENCES routes(id) ON DELETE CASCADE,
    direction_id    smallint CHECK (direction_id IN (0, 1)),
    shape_id        bigint REFERENCES shapes(id) ON DELETE SET NULL,
    stop_signature  bigint[] NOT NULL CHECK (cardinality(stop_signature) >= 2),
    CONSTRAINT route_patterns_identity UNIQUE NULLS NOT DISTINCT
        (route_id, direction_id, shape_id, stop_signature)
);

CREATE TABLE route_pattern_stops (
    pattern_id  bigint NOT NULL REFERENCES route_patterns(id) ON DELETE CASCADE,
    stop_order  integer NOT NULL CHECK (stop_order > 0),
    stop_id     bigint NOT NULL REFERENCES stops(id) ON DELETE RESTRICT,
    PRIMARY KEY (pattern_id, stop_order)
);

-- ---------------------------------------------------------------------------
-- trips: one scheduled run of a vehicle along a route (GTFS trips.txt)
-- ---------------------------------------------------------------------------
CREATE TABLE trips (
    id            bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    gtfs_trip_id  text NOT NULL UNIQUE,
    route_id      bigint NOT NULL REFERENCES routes(id) ON DELETE CASCADE,
    service_id    bigint NOT NULL REFERENCES services(id) ON DELETE CASCADE,
    shape_id      bigint REFERENCES shapes(id) ON DELETE SET NULL,
    route_pattern_id bigint NOT NULL REFERENCES route_patterns(id) ON DELETE RESTRICT,
    headsign      text,
    direction_id  smallint CHECK (direction_id IN (0, 1)),
    block_id      text
);

COMMENT ON TABLE trips IS 'A single scheduled vehicle run along a route (GTFS trips.txt), active on days its service runs.';
COMMENT ON COLUMN trips.headsign IS 'Destination text shown on the vehicle, e.g. the terminus stop name.';
COMMENT ON COLUMN trips.direction_id IS 'GTFS enum: 0 = outbound, 1 = inbound (opposite direction of travel).';
COMMENT ON COLUMN trips.block_id IS 'GTFS block identifier: trips with the same block are operated by the same vehicle.';

-- ---------------------------------------------------------------------------
-- stop_times: the finest grain — one scheduled stop event of one trip
-- (GTFS stop_times.txt)
-- ---------------------------------------------------------------------------
CREATE TABLE stop_times (
    trip_id              bigint NOT NULL REFERENCES trips(id) ON DELETE CASCADE,
    stop_id              bigint NOT NULL REFERENCES stops(id) ON DELETE CASCADE,
    stop_sequence        integer NOT NULL,
    arrival_time         interval NOT NULL,   -- may exceed 24:00:00 (after-midnight service)
    departure_time       interval NOT NULL,   -- may exceed 24:00:00
    stop_headsign        text,
    pickup_type          smallint NOT NULL DEFAULT 0 CHECK (pickup_type   IN (0,1,2,3)),
    drop_off_type        smallint NOT NULL DEFAULT 0 CHECK (drop_off_type IN (0,1,2,3)),
    shape_dist_traveled  double precision,
    CONSTRAINT stop_times_sequence_positive CHECK (stop_sequence > 0),
    CONSTRAINT stop_times_arrival_nonnegative CHECK (arrival_time >= interval '0'),
    CONSTRAINT stop_times_departure_after_arrival CHECK (departure_time >= arrival_time),
    CONSTRAINT stop_times_distance_nonnegative CHECK (
        shape_dist_traveled IS NULL OR shape_dist_traveled >= 0
    ),
    PRIMARY KEY (trip_id, stop_sequence)
);

COMMENT ON TABLE stop_times IS 'One row per (trip, stop) scheduled event — the fact table / finest grain of the schema (GTFS stop_times.txt).';
COMMENT ON COLUMN stop_times.arrival_time IS 'Time since service midnight, stored as interval because GTFS allows values >= 24:00:00.';
COMMENT ON COLUMN stop_times.departure_time IS 'Time since service midnight, stored as interval because GTFS allows values >= 24:00:00.';
COMMENT ON COLUMN stop_times.pickup_type IS 'GTFS enum: 0 regular, 1 none, 2 phone agency, 3 coordinate with driver.';
COMMENT ON COLUMN stop_times.drop_off_type IS 'GTFS enum: 0 regular, 1 none, 2 phone agency, 3 coordinate with driver.';

-- ---------------------------------------------------------------------------
-- current_vehicle_positions: one upserted row per simulated vehicle
-- ---------------------------------------------------------------------------
CREATE TABLE current_vehicle_positions (
    vehicle_id       text PRIMARY KEY,
    trip_id          bigint REFERENCES trips(id) ON DELETE SET NULL,
    lat              double precision NOT NULL,
    lon              double precision NOT NULL,
    geom             geometry(Point, 4326) GENERATED ALWAYS AS (
                         ST_SetSRID(ST_MakePoint(lon, lat), 4326)
                     ) STORED NOT NULL,
    delay_seconds    integer NOT NULL DEFAULT 0,
    current_stop_id  bigint REFERENCES stops(id) ON DELETE SET NULL,
    recorded_at      timestamptz NOT NULL DEFAULT now(),
    CHECK (lat BETWEEN -90 AND 90),
    CHECK (lon BETWEEN -180 AND 180)
);

-- ---------------------------------------------------------------------------
-- vehicle_position_history: append-only telemetry, daily UTC partitions
-- ---------------------------------------------------------------------------
CREATE TABLE vehicle_position_history (
    id               bigint GENERATED ALWAYS AS IDENTITY,
    vehicle_id       text NOT NULL,
    trip_id          bigint REFERENCES trips(id) ON DELETE SET NULL,
    lat              double precision NOT NULL,
    lon              double precision NOT NULL,
    geom             geometry(Point, 4326) GENERATED ALWAYS AS (
                         ST_SetSRID(ST_MakePoint(lon, lat), 4326)
                     ) STORED NOT NULL,
    delay_seconds    integer NOT NULL DEFAULT 0,
    current_stop_id  bigint REFERENCES stops(id) ON DELETE SET NULL,
    recorded_at      timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (recorded_at, id),
    CHECK (lat BETWEEN -90 AND 90),
    CHECK (lon BETWEEN -180 AND 180)
) PARTITION BY RANGE (recorded_at);

CREATE OR REPLACE FUNCTION maintain_vehicle_position_partitions(
    reference_date date,
    retention_days integer DEFAULT 30,
    future_days integer DEFAULT 7
) RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE
    partition_day date;
    partition_name text;
    child record;
BEGIN
    IF retention_days < 1 OR future_days < 0 THEN
        RAISE EXCEPTION 'invalid vehicle-position partition policy';
    END IF;
    PERFORM pg_advisory_xact_lock(hashtext('citybus.vehicle_position_partitions'));
    FOR offset_days IN 0..future_days LOOP
        partition_day := reference_date + offset_days;
        partition_name := 'vehicle_position_history_' || to_char(partition_day, 'YYYYMMDD');
        EXECUTE format(
            'CREATE TABLE IF NOT EXISTS %I PARTITION OF vehicle_position_history '
            'FOR VALUES FROM (%L) TO (%L)', partition_name,
            partition_day::timestamp AT TIME ZONE 'UTC',
            (partition_day + 1)::timestamp AT TIME ZONE 'UTC'
        );
    END LOOP;
    FOR child IN
        SELECT c.relname FROM pg_inherits i
        JOIN pg_class c ON c.oid = i.inhrelid
        JOIN pg_class p ON p.oid = i.inhparent
        WHERE p.relname = 'vehicle_position_history'
          AND c.relname ~ '^vehicle_position_history_[0-9]{8}$'
    LOOP
        partition_day := to_date(right(child.relname, 8), 'YYYYMMDD');
        IF partition_day < reference_date - (retention_days - 1) THEN
            EXECUTE format('DROP TABLE %I', child.relname);
        END IF;
    END LOOP;
    DELETE FROM current_vehicle_positions
    WHERE recorded_at < now() - interval '24 hours';
END;
$$;

SELECT maintain_vehicle_position_partitions((now() AT TIME ZONE 'UTC')::date, 30, 7);

COMMENT ON TABLE current_vehicle_positions IS 'Latest simulated state, one upserted row per vehicle.';
COMMENT ON TABLE vehicle_position_history IS 'Append-only simulated telemetry partitioned by UTC day.';
COMMENT ON COLUMN vehicle_position_history.delay_seconds IS 'Deviation from schedule in seconds; positive = late, negative = early.';
COMMENT ON COLUMN vehicle_position_history.current_stop_id IS 'Stop the vehicle is at or approaching, when known.';
