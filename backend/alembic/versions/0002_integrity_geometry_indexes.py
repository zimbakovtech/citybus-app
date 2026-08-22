"""integrity constraints, generated point geometry, and index corrections

Revision ID: 0002
Revises: 0001
"""

from alembic import op

revision = "0002"
down_revision = "0001"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.execute(
        """
        DO $$
        BEGIN
            IF EXISTS (
                SELECT 1 FROM routes
                WHERE (color IS NOT NULL AND color !~ '^[0-9A-Fa-f]{6}$')
                   OR (text_color IS NOT NULL AND text_color !~ '^[0-9A-Fa-f]{6}$')
            ) THEN RAISE EXCEPTION 'routes contain invalid color values'; END IF;
            IF EXISTS (
                SELECT 1 FROM stops
                WHERE lat NOT BETWEEN -90 AND 90 OR lon NOT BETWEEN -180 AND 180
                   OR location_type NOT BETWEEN 0 AND 4 OR parent_station_id = id
            ) THEN
                RAISE EXCEPTION 'stops contain invalid coordinates, location types, or parents';
            END IF;
            IF EXISTS (SELECT 1 FROM calendar WHERE start_date > end_date)
            THEN RAISE EXCEPTION 'calendar contains an invalid date range'; END IF;
            IF EXISTS (
                SELECT 1 FROM shape_points
                WHERE pt_sequence <= 0 OR (dist_traveled IS NOT NULL AND dist_traveled < 0)
            ) THEN RAISE EXCEPTION 'shape_points contain invalid sequences or distances'; END IF;
            IF EXISTS (
                SELECT 1 FROM stop_times
                WHERE stop_sequence <= 0 OR arrival_time < interval '0'
                   OR departure_time < arrival_time
                   OR (shape_dist_traveled IS NOT NULL AND shape_dist_traveled < 0)
            ) THEN
                RAISE EXCEPTION 'stop_times contain invalid sequences, times, or distances';
            END IF;
            IF EXISTS (
                SELECT 1 FROM vehicle_positions
                WHERE lat NOT BETWEEN -90 AND 90 OR lon NOT BETWEEN -180 AND 180
            ) THEN RAISE EXCEPTION 'vehicle_positions contain invalid coordinates'; END IF;
        END $$
        """
    )

    op.execute(
        "ALTER TABLE routes ADD CONSTRAINT routes_color_hex "
        "CHECK (color IS NULL OR color ~ '^[0-9A-Fa-f]{6}$')"
    )
    op.execute(
        "ALTER TABLE routes ADD CONSTRAINT routes_text_color_hex "
        "CHECK (text_color IS NULL OR text_color ~ '^[0-9A-Fa-f]{6}$')"
    )
    op.execute("ALTER TABLE stops ADD CONSTRAINT stops_lat_range CHECK (lat BETWEEN -90 AND 90)")
    op.execute("ALTER TABLE stops ADD CONSTRAINT stops_lon_range CHECK (lon BETWEEN -180 AND 180)")
    op.execute(
        "ALTER TABLE stops ADD CONSTRAINT stops_location_type_range "
        "CHECK (location_type BETWEEN 0 AND 4)"
    )
    op.execute(
        "ALTER TABLE stops ADD CONSTRAINT stops_parent_not_self "
        "CHECK (parent_station_id IS NULL OR parent_station_id <> id)"
    )
    op.execute(
        "ALTER TABLE calendar ADD CONSTRAINT calendar_date_range CHECK (start_date <= end_date)"
    )
    op.execute(
        "ALTER TABLE shape_points ADD CONSTRAINT shape_points_sequence_positive "
        "CHECK (pt_sequence > 0)"
    )
    op.execute(
        "ALTER TABLE shape_points ADD CONSTRAINT shape_points_distance_nonnegative "
        "CHECK (dist_traveled IS NULL OR dist_traveled >= 0)"
    )
    op.execute(
        "ALTER TABLE stop_times ADD CONSTRAINT stop_times_sequence_positive "
        "CHECK (stop_sequence > 0)"
    )
    op.execute(
        "ALTER TABLE stop_times ADD CONSTRAINT stop_times_arrival_nonnegative "
        "CHECK (arrival_time >= interval '0')"
    )
    op.execute(
        "ALTER TABLE stop_times ADD CONSTRAINT stop_times_departure_after_arrival "
        "CHECK (departure_time >= arrival_time)"
    )
    op.execute(
        "ALTER TABLE stop_times ADD CONSTRAINT stop_times_distance_nonnegative "
        "CHECK (shape_dist_traveled IS NULL OR shape_dist_traveled >= 0)"
    )
    op.execute(
        "ALTER TABLE vehicle_positions ADD CONSTRAINT vehicle_positions_lat_range "
        "CHECK (lat BETWEEN -90 AND 90)"
    )
    op.execute(
        "ALTER TABLE vehicle_positions ADD CONSTRAINT vehicle_positions_lon_range "
        "CHECK (lon BETWEEN -180 AND 180)"
    )

    op.execute("DROP INDEX idx_stops_geom")
    op.execute("DROP INDEX idx_vpos_geom")
    op.execute("ALTER TABLE stops DROP COLUMN geom")
    op.execute(
        """ALTER TABLE stops ADD COLUMN geom geometry(Point, 4326)
        GENERATED ALWAYS AS (ST_SetSRID(ST_MakePoint(lon, lat), 4326)) STORED"""
    )
    op.execute("ALTER TABLE stops ALTER COLUMN geom SET NOT NULL")
    op.execute("ALTER TABLE vehicle_positions DROP COLUMN geom")
    op.execute(
        """ALTER TABLE vehicle_positions ADD COLUMN geom geometry(Point, 4326)
        GENERATED ALWAYS AS (ST_SetSRID(ST_MakePoint(lon, lat), 4326)) STORED"""
    )
    op.execute("ALTER TABLE vehicle_positions ALTER COLUMN geom SET NOT NULL")

    op.execute("CREATE INDEX idx_stops_geom ON stops USING gist (geom)")
    op.execute("CREATE INDEX idx_stops_geography ON stops USING gist ((geom::geography))")
    op.execute("CREATE INDEX idx_stops_parent ON stops (parent_station_id)")
    op.execute("DROP INDEX idx_trips_route")
    op.execute("CREATE INDEX idx_trips_route_service ON trips (route_id, service_id)")
    op.execute("DROP INDEX idx_stop_times_trip")
    op.execute("DROP INDEX idx_calendar_dates_service")
    op.execute("DROP INDEX idx_shape_points_shape")


def downgrade() -> None:
    op.execute("DROP INDEX idx_stops_geography")
    op.execute("DROP INDEX idx_stops_geom")
    op.execute("ALTER TABLE stops DROP COLUMN geom")
    op.execute("ALTER TABLE stops ADD COLUMN geom geometry(Point, 4326)")
    op.execute("UPDATE stops SET geom = ST_SetSRID(ST_MakePoint(lon, lat), 4326)")
    op.execute("ALTER TABLE stops ALTER COLUMN geom SET NOT NULL")
    op.execute("CREATE INDEX idx_stops_geom ON stops USING gist (geom)")

    op.execute("ALTER TABLE vehicle_positions DROP COLUMN geom")
    op.execute("ALTER TABLE vehicle_positions ADD COLUMN geom geometry(Point, 4326)")
    op.execute("UPDATE vehicle_positions SET geom = ST_SetSRID(ST_MakePoint(lon, lat), 4326)")
    op.execute("ALTER TABLE vehicle_positions ALTER COLUMN geom SET NOT NULL")
    op.execute("CREATE INDEX idx_vpos_geom ON vehicle_positions USING gist (geom)")

    op.execute("DROP INDEX idx_stops_parent")
    op.execute("DROP INDEX idx_trips_route_service")
    op.execute("CREATE INDEX idx_trips_route ON trips (route_id)")
    op.execute("CREATE INDEX idx_stop_times_trip ON stop_times (trip_id, stop_sequence)")
    op.execute("CREATE INDEX idx_calendar_dates_service ON calendar_dates (service_id, date)")
    op.execute("CREATE INDEX idx_shape_points_shape ON shape_points (shape_id, pt_sequence)")

    for table, constraint in [
        ("routes", "routes_color_hex"),
        ("routes", "routes_text_color_hex"),
        ("stops", "stops_lat_range"),
        ("stops", "stops_lon_range"),
        ("stops", "stops_location_type_range"),
        ("stops", "stops_parent_not_self"),
        ("calendar", "calendar_date_range"),
        ("shape_points", "shape_points_sequence_positive"),
        ("shape_points", "shape_points_distance_nonnegative"),
        ("stop_times", "stop_times_sequence_positive"),
        ("stop_times", "stop_times_arrival_nonnegative"),
        ("stop_times", "stop_times_departure_after_arrival"),
        ("stop_times", "stop_times_distance_nonnegative"),
        ("vehicle_positions", "vehicle_positions_lat_range"),
        ("vehicle_positions", "vehicle_positions_lon_range"),
    ]:
        op.execute(f"ALTER TABLE {table} DROP CONSTRAINT {constraint}")
