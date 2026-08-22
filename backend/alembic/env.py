"""Alembic environment — async engine, URL taken from app settings."""

import asyncio
import re
from logging.config import fileConfig

from sqlalchemy.engine import Connection
from sqlalchemy.ext.asyncio import async_engine_from_config

from alembic import context
from app.core.config import settings
from app.models import Base

config = context.config
if config.config_file_name is not None:
    fileConfig(config.config_file_name)

config.set_main_option("sqlalchemy.url", settings.database_url)

# model metadata, for `alembic check` / autogenerate support
target_metadata = Base.metadata


def include_object(obj: object, name: str, type_: str, reflected: bool, compare_to: object) -> bool:
    """Compare only application-owned, migration-managed schema objects.

    PostGIS owns its support schemas, history partitions are created dynamically,
    and indexes are deliberately managed by the SQL migrations rather than ORM
    metadata.  Those objects have separate schema tests and should not generate
    destructive Alembic revisions.
    """
    schema = getattr(obj, "schema", None)
    if schema in {"tiger", "tiger_data", "topology"}:
        return False
    if type_ == "table" and (
        name == "spatial_ref_sys"
        or re.fullmatch(r"vehicle_position_history_\d{8}", name) is not None
    ):
        return False
    return not (type_ == "index" and reflected and compare_to is None)


def do_run_migrations(connection: Connection) -> None:
    # Some PostGIS images append extension schemas (notably tiger/topology) to
    # the database search path. Migrations and drift detection own public only.
    connection.exec_driver_sql("SET search_path TO public")
    # SET starts an implicit transaction; close it so Alembic can own and
    # commit the migration transaction below.
    connection.commit()
    context.configure(
        connection=connection,
        target_metadata=target_metadata,
        include_object=include_object,
    )
    with context.begin_transaction():
        context.run_migrations()


async def run_async_migrations() -> None:
    engine = async_engine_from_config(
        config.get_section(config.config_ini_section, {}), prefix="sqlalchemy."
    )
    async with engine.connect() as connection:
        await connection.run_sync(do_run_migrations)
    await engine.dispose()


def run_migrations_offline() -> None:
    context.configure(url=settings.database_url, target_metadata=target_metadata)
    with context.begin_transaction():
        context.run_migrations()


if context.is_offline_mode():
    run_migrations_offline()
else:
    asyncio.run(run_async_migrations())
