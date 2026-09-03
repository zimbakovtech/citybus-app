"""split current vehicle state from partitioned position history

Revision ID: 0003
Revises: 0002
"""

from alembic import op

revision = "0003"
down_revision = "0002"
branch_labels = None
depends_on = None


MAINTENANCE_FUNCTION = r"""
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
            'FOR VALUES FROM (%L) TO (%L)',
            partition_name,
            partition_day::timestamp AT TIME ZONE 'UTC',
            (partition_day + 1)::timestamp AT TIME ZONE 'UTC'
        );
    END LOOP;

    FOR child IN
        SELECT c.relname
        FROM pg_inherits i
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
$$
"""


def upgrade() -> None:
    op.execute(
        """
        CREATE TABLE current_vehicle_positions (
            vehicle_id text PRIMARY KEY,
            trip_id bigint REFERENCES trips(id) ON DELETE SET NULL,
            lat double precision NOT NULL CHECK (lat BETWEEN -90 AND 90),
            lon double precision NOT NULL CHECK (lon BETWEEN -180 AND 180),
            geom geometry(Point, 4326) GENERATED ALWAYS AS (
                ST_SetSRID(ST_MakePoint(lon, lat), 4326)
            ) STORED NOT NULL,
            delay_seconds integer NOT NULL DEFAULT 0,
            current_stop_id bigint REFERENCES stops(id) ON DELETE SET NULL,
            recorded_at timestamptz NOT NULL DEFAULT now()
        )
        """
    )
    op.execute(
        """
        CREATE TABLE vehicle_position_history (
            id bigint GENERATED ALWAYS AS IDENTITY,
            vehicle_id text NOT NULL,
            trip_id bigint REFERENCES trips(id) ON DELETE SET NULL,
            lat double precision NOT NULL CHECK (lat BETWEEN -90 AND 90),
            lon double precision NOT NULL CHECK (lon BETWEEN -180 AND 180),
            geom geometry(Point, 4326) GENERATED ALWAYS AS (
                ST_SetSRID(ST_MakePoint(lon, lat), 4326)
            ) STORED NOT NULL,
            delay_seconds integer NOT NULL DEFAULT 0,
            current_stop_id bigint REFERENCES stops(id) ON DELETE SET NULL,
            recorded_at timestamptz NOT NULL DEFAULT now(),
            PRIMARY KEY (recorded_at, id)
        ) PARTITION BY RANGE (recorded_at)
        """
    )
    op.execute(MAINTENANCE_FUNCTION)
    op.execute(
        """
        DO $$
        DECLARE
            partition_day date;
            first_day date;
            last_day date;
            retention_start date := (now() AT TIME ZONE 'UTC')::date - 29;
            partition_name text;
        BEGIN
            SELECT min(recorded_at AT TIME ZONE 'UTC')::date,
                   max(recorded_at AT TIME ZONE 'UTC')::date
            INTO first_day, last_day
            FROM vehicle_positions;

            first_day := GREATEST(
                COALESCE(first_day, (now() AT TIME ZONE 'UTC')::date),
                retention_start
            );
            last_day := GREATEST(
                COALESCE(last_day, first_day),
                (now() AT TIME ZONE 'UTC')::date + 7
            );

            FOR partition_day IN SELECT generate_series(first_day, last_day, interval '1 day')::date
            LOOP
                partition_name := 'vehicle_position_history_' || to_char(partition_day, 'YYYYMMDD');
                EXECUTE format(
                    'CREATE TABLE IF NOT EXISTS %I PARTITION OF vehicle_position_history '
                    'FOR VALUES FROM (%L) TO (%L)',
                    partition_name,
                    partition_day::timestamp AT TIME ZONE 'UTC',
                    (partition_day + 1)::timestamp AT TIME ZONE 'UTC'
                );
            END LOOP;
        END $$
        """
    )

    op.execute(
        """
        INSERT INTO vehicle_position_history
            (id, vehicle_id, trip_id, lat, lon, delay_seconds, current_stop_id, recorded_at)
        OVERRIDING SYSTEM VALUE
        SELECT id, vehicle_id, trip_id, lat, lon, delay_seconds, current_stop_id, recorded_at
        FROM vehicle_positions
        WHERE recorded_at >= (
            ((now() AT TIME ZONE 'UTC')::date - 29)::timestamp AT TIME ZONE 'UTC'
        )
        """
    )
    op.execute(
        """
        INSERT INTO current_vehicle_positions
            (vehicle_id, trip_id, lat, lon, delay_seconds, current_stop_id, recorded_at)
        SELECT DISTINCT ON (vehicle_id)
            vehicle_id, trip_id, lat, lon, delay_seconds, current_stop_id, recorded_at
        FROM vehicle_positions
        ORDER BY vehicle_id, recorded_at DESC, id DESC
        """
    )
    op.execute(
        """
        SELECT setval(
            pg_get_serial_sequence('vehicle_position_history', 'id'),
            COALESCE((SELECT max(id) FROM vehicle_position_history), 1),
            EXISTS (SELECT 1 FROM vehicle_position_history)
        )
        """
    )
    op.execute("DROP TABLE vehicle_positions")

    op.execute("CREATE INDEX idx_current_vpos_recorded ON current_vehicle_positions (recorded_at)")
    op.execute("CREATE INDEX idx_current_vpos_trip ON current_vehicle_positions (trip_id)")
    op.execute("CREATE INDEX idx_current_vpos_stop ON current_vehicle_positions (current_stop_id)")
    op.execute(
        "CREATE INDEX idx_vpos_history_vehicle_recorded "
        "ON vehicle_position_history (vehicle_id, recorded_at DESC)"
    )
    op.execute(
        "CREATE INDEX idx_vpos_history_trip_recorded "
        "ON vehicle_position_history (trip_id, recorded_at DESC)"
    )
    op.execute("CREATE INDEX idx_vpos_history_stop ON vehicle_position_history (current_stop_id)")


def downgrade() -> None:
    op.execute(
        """
        CREATE TABLE vehicle_positions (
            id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
            vehicle_id text NOT NULL,
            trip_id bigint REFERENCES trips(id) ON DELETE SET NULL,
            lat double precision NOT NULL CONSTRAINT vehicle_positions_lat_range
                CHECK (lat BETWEEN -90 AND 90),
            lon double precision NOT NULL CONSTRAINT vehicle_positions_lon_range
                CHECK (lon BETWEEN -180 AND 180),
            geom geometry(Point, 4326) GENERATED ALWAYS AS (
                ST_SetSRID(ST_MakePoint(lon, lat), 4326)
            ) STORED NOT NULL,
            delay_seconds integer NOT NULL DEFAULT 0,
            current_stop_id bigint REFERENCES stops(id) ON DELETE SET NULL,
            recorded_at timestamptz NOT NULL DEFAULT now()
        )
        """
    )
    op.execute(
        """
        INSERT INTO vehicle_positions
            (id, vehicle_id, trip_id, lat, lon, delay_seconds, current_stop_id, recorded_at)
        OVERRIDING SYSTEM VALUE
        SELECT id, vehicle_id, trip_id, lat, lon, delay_seconds, current_stop_id, recorded_at
        FROM vehicle_position_history
        """
    )
    op.execute(
        """
        INSERT INTO vehicle_positions
            (vehicle_id, trip_id, lat, lon, delay_seconds, current_stop_id, recorded_at)
        SELECT c.vehicle_id, c.trip_id, c.lat, c.lon, c.delay_seconds,
               c.current_stop_id, c.recorded_at
        FROM current_vehicle_positions c
        WHERE NOT EXISTS (
            SELECT 1 FROM vehicle_position_history h
            WHERE h.vehicle_id = c.vehicle_id AND h.recorded_at = c.recorded_at
        )
        """
    )
    op.execute(
        """
        SELECT setval(
            pg_get_serial_sequence('vehicle_positions', 'id'),
            COALESCE((SELECT max(id) FROM vehicle_positions), 1),
            EXISTS (SELECT 1 FROM vehicle_positions)
        )
        """
    )
    op.execute("CREATE INDEX idx_vpos_trip ON vehicle_positions (trip_id)")
    op.execute("CREATE INDEX idx_vpos_recorded_at ON vehicle_positions (recorded_at DESC)")
    op.execute("DROP FUNCTION maintain_vehicle_position_partitions(date, integer, integer)")
    op.execute("DROP TABLE current_vehicle_positions")
    op.execute("DROP TABLE vehicle_position_history")
