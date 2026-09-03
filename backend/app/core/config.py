"""Application settings, loaded from the environment / .env file."""

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8")

    database_url: str = "postgresql+asyncpg://citybus:citybus@localhost:5432/citybus"
    gtfs_zip_path: str = "../database/seed/gtfs"

    realtime_enabled: bool = True
    realtime_tick_seconds: float = 2.0
    vehicle_history_retention_days: int = 30
    vehicle_partition_future_days: int = 7

    # minimum time needed to change vehicles at a stop (route planner)
    transfer_buffer_seconds: int = 120


settings = Settings()
