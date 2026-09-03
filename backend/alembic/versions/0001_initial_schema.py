"""initial schema

Executes an immutable snapshot of the original DDL. Current canonical SQL may
evolve, but an existing revision must always build the same historical schema.

Revision ID: 0001
Revises:
Create Date: 2026-07-17
"""

from pathlib import Path

from alembic import op

revision = "0001"
down_revision = None
branch_labels = None
depends_on = None

# Immutable DDL snapshot owned by this revision.  Never point an existing
# migration at database/sql: those files describe the current schema and are
# expected to evolve as new revisions are added.
SQL_DIR = Path(__file__).resolve().parents[1] / "sql" / "0001"
SQL_FILES = ["00_extensions.sql", "01_schema.sql", "02_indexes.sql"]


def _statements(sql: str) -> list[str]:
    """Split a DDL file into single statements (asyncpg cannot execute
    multi-statement strings). Splits on ';' but respects single-quoted string
    literals and '--' line comments, both of which may contain semicolons."""
    statements: list[str] = []
    buf: list[str] = []
    in_string = in_comment = False
    for i, ch in enumerate(sql):
        if in_string:
            if ch == "'":
                in_string = False
        elif in_comment:
            if ch == "\n":
                in_comment = False
        elif ch == "'":
            in_string = True
        elif ch == "-" and sql[i : i + 2] == "--":
            in_comment = True
        elif ch == ";":
            statements.append("".join(buf).strip())
            buf = []
            continue
        buf.append(ch)
    if "".join(buf).strip():
        statements.append("".join(buf).strip())
    return [s for s in statements if s]


def upgrade() -> None:
    for name in SQL_FILES:
        for statement in _statements((SQL_DIR / name).read_text()):
            op.execute(statement)


def downgrade() -> None:
    for table in [
        "vehicle_positions",
        "stop_times",
        "trips",
        "shape_points",
        "shapes",
        "calendar_dates",
        "calendar",
        "services",
        "stops",
        "routes",
        "agency",
    ]:
        op.execute(f"DROP TABLE IF EXISTS {table} CASCADE")
