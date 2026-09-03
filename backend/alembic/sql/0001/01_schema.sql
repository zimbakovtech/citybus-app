-- Immutable revision 0001 schema snapshot.
CREATE TABLE agency (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    gtfs_agency_id text NOT NULL UNIQUE,
    name text NOT NULL,
    url text,
    timezone text NOT NULL,
    lang text,
    phone text
);

CREATE TABLE routes (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    gtfs_route_id text NOT NULL UNIQUE,
    agency_id bigint NOT NULL REFERENCES agency(id) ON DELETE CASCADE,
    short_name text,
    long_name text,
    route_type smallint NOT NULL DEFAULT 3,
    color char(6),
    text_color char(6),
    CONSTRAINT routes_name_present CHECK (short_name IS NOT NULL OR long_name IS NOT NULL)
);

CREATE TABLE stops (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    gtfs_stop_id text NOT NULL UNIQUE,
    code text,
    name text NOT NULL,
    description text,
    lat double precision NOT NULL,
    lon double precision NOT NULL,
    geom geometry(Point, 4326) NOT NULL,
    location_type smallint NOT NULL DEFAULT 0,
    parent_station_id bigint REFERENCES stops(id) ON DELETE SET NULL
);

CREATE TABLE services (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    gtfs_service_id text NOT NULL UNIQUE
);

CREATE TABLE calendar (
    service_id bigint PRIMARY KEY REFERENCES services(id) ON DELETE CASCADE,
    monday boolean NOT NULL,
    tuesday boolean NOT NULL,
    wednesday boolean NOT NULL,
    thursday boolean NOT NULL,
    friday boolean NOT NULL,
    saturday boolean NOT NULL,
    sunday boolean NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL
);

CREATE TABLE calendar_dates (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    service_id bigint NOT NULL REFERENCES services(id) ON DELETE CASCADE,
    date date NOT NULL,
    exception_type smallint NOT NULL CHECK (exception_type IN (1, 2)),
    UNIQUE (service_id, date)
);

CREATE TABLE shapes (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    gtfs_shape_id text NOT NULL UNIQUE,
    geom geometry(LineString, 4326)
);

CREATE TABLE shape_points (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    shape_id bigint NOT NULL REFERENCES shapes(id) ON DELETE CASCADE,
    pt_sequence integer NOT NULL,
    lat double precision NOT NULL,
    lon double precision NOT NULL,
    dist_traveled double precision,
    UNIQUE (shape_id, pt_sequence)
);

CREATE TABLE trips (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    gtfs_trip_id text NOT NULL UNIQUE,
    route_id bigint NOT NULL REFERENCES routes(id) ON DELETE CASCADE,
    service_id bigint NOT NULL REFERENCES services(id) ON DELETE CASCADE,
    shape_id bigint REFERENCES shapes(id) ON DELETE SET NULL,
    headsign text,
    direction_id smallint CHECK (direction_id IN (0, 1)),
    block_id text
);

CREATE TABLE stop_times (
    trip_id bigint NOT NULL REFERENCES trips(id) ON DELETE CASCADE,
    stop_id bigint NOT NULL REFERENCES stops(id) ON DELETE CASCADE,
    stop_sequence integer NOT NULL,
    arrival_time interval NOT NULL,
    departure_time interval NOT NULL,
    stop_headsign text,
    pickup_type smallint NOT NULL DEFAULT 0 CHECK (pickup_type IN (0,1,2,3)),
    drop_off_type smallint NOT NULL DEFAULT 0 CHECK (drop_off_type IN (0,1,2,3)),
    shape_dist_traveled double precision,
    PRIMARY KEY (trip_id, stop_sequence)
);

CREATE TABLE vehicle_positions (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    vehicle_id text NOT NULL,
    trip_id bigint REFERENCES trips(id) ON DELETE SET NULL,
    lat double precision NOT NULL,
    lon double precision NOT NULL,
    geom geometry(Point, 4326) NOT NULL,
    delay_seconds integer NOT NULL DEFAULT 0,
    current_stop_id bigint REFERENCES stops(id) ON DELETE SET NULL,
    recorded_at timestamptz NOT NULL DEFAULT now()
);
