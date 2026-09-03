"""explicit route patterns derived from trip stop sequences

Revision ID: 0004
Revises: 0003
"""

from alembic import op

revision = "0004"
down_revision = "0003"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.execute(
        """
        CREATE TABLE route_patterns (
            id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
            route_id bigint NOT NULL REFERENCES routes(id) ON DELETE CASCADE,
            direction_id smallint CHECK (direction_id IN (0, 1)),
            shape_id bigint REFERENCES shapes(id) ON DELETE SET NULL,
            stop_signature bigint[] NOT NULL CHECK (cardinality(stop_signature) >= 2),
            CONSTRAINT route_patterns_identity UNIQUE NULLS NOT DISTINCT
                (route_id, direction_id, shape_id, stop_signature)
        )
        """
    )
    op.execute(
        """
        CREATE TABLE route_pattern_stops (
            pattern_id bigint NOT NULL REFERENCES route_patterns(id) ON DELETE CASCADE,
            stop_order integer NOT NULL CHECK (stop_order > 0),
            stop_id bigint NOT NULL REFERENCES stops(id) ON DELETE RESTRICT,
            PRIMARY KEY (pattern_id, stop_order)
        )
        """
    )
    op.execute("ALTER TABLE trips ADD COLUMN route_pattern_id bigint")
    op.execute(
        """
        INSERT INTO route_patterns (route_id, direction_id, shape_id, stop_signature)
        SELECT route_id, direction_id, shape_id, stop_signature
        FROM (
            SELECT t.route_id, t.direction_id, t.shape_id,
                   array_agg(st.stop_id ORDER BY st.stop_sequence)::bigint[] AS stop_signature
            FROM trips t
            JOIN stop_times st ON st.trip_id = t.id
            GROUP BY t.id, t.route_id, t.direction_id, t.shape_id
        ) signatures
        GROUP BY route_id, direction_id, shape_id, stop_signature
        """
    )
    op.execute(
        """
        INSERT INTO route_pattern_stops (pattern_id, stop_order, stop_id)
        SELECT rp.id, points.ordinality::integer, points.stop_id
        FROM route_patterns rp
        CROSS JOIN LATERAL unnest(rp.stop_signature)
            WITH ORDINALITY AS points(stop_id, ordinality)
        """
    )
    op.execute(
        """
        WITH signatures AS (
            SELECT t.id AS trip_id, t.route_id, t.direction_id, t.shape_id,
                   array_agg(st.stop_id ORDER BY st.stop_sequence)::bigint[] AS stop_signature
            FROM trips t
            JOIN stop_times st ON st.trip_id = t.id
            GROUP BY t.id, t.route_id, t.direction_id, t.shape_id
        )
        UPDATE trips t
        SET route_pattern_id = rp.id
        FROM signatures s
        JOIN route_patterns rp
          ON rp.route_id = s.route_id
         AND rp.direction_id IS NOT DISTINCT FROM s.direction_id
         AND rp.shape_id IS NOT DISTINCT FROM s.shape_id
         AND rp.stop_signature = s.stop_signature
        WHERE t.id = s.trip_id
        """
    )
    op.execute(
        """
        DO $$ BEGIN
            IF EXISTS (SELECT 1 FROM trips WHERE route_pattern_id IS NULL) THEN
                RAISE EXCEPTION 'cannot assign a route pattern to every existing trip';
            END IF;
        END $$
        """
    )
    op.execute("ALTER TABLE trips ALTER COLUMN route_pattern_id SET NOT NULL")
    op.execute(
        """ALTER TABLE trips ADD CONSTRAINT trips_route_pattern_id_fkey
        FOREIGN KEY (route_pattern_id) REFERENCES route_patterns(id) ON DELETE RESTRICT"""
    )
    op.execute("CREATE INDEX idx_trips_route_pattern ON trips (route_pattern_id)")
    op.execute("CREATE INDEX idx_route_patterns_route ON route_patterns (route_id)")
    op.execute("CREATE INDEX idx_route_patterns_shape ON route_patterns (shape_id)")
    op.execute("CREATE INDEX idx_route_pattern_stops_stop ON route_pattern_stops (stop_id)")


def downgrade() -> None:
    op.execute("ALTER TABLE trips DROP COLUMN route_pattern_id")
    op.execute("DROP TABLE route_pattern_stops")
    op.execute("DROP TABLE route_patterns")
