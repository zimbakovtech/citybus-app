#!/usr/bin/env bash
# Reproducible CityBus database benchmark.
# Uses throwaway containers on a private network; no other container, volume
# or local database is touched.
#
#   database/benchmark/run_all.sh [results-dir]      (~3 min)
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$HERE/../.." && pwd)"
OUT="${1:-$HERE/results}"
mkdir -p "$OUT"

NET=citybus-bench-net
DB=citybus-bench
IMAGE=postgis/postgis:16-3.5   # same image as docker-compose.yml and CI

docker rm -f "$DB" >/dev/null 2>&1 || true
docker network inspect "$NET" >/dev/null 2>&1 || docker network create "$NET" >/dev/null

docker run -d --rm --name "$DB" --network "$NET" --platform linux/amd64 --shm-size=1g \
  -e POSTGRES_DB=citybus -e POSTGRES_USER=citybus -e POSTGRES_PASSWORD=citybus \
  "$IMAGE" -c jit=off -c maintenance_work_mem=512MB -c max_wal_size=8GB \
  -c checkpoint_timeout=30min >/dev/null

# the entrypoint runs a temporary server during init; wait for the real one
until docker logs "$DB" 2>&1 | grep -q "PostgreSQL init process complete"; do sleep 1; done
until docker exec "$DB" pg_isready -U citybus -d citybus >/dev/null 2>&1; do sleep 1; done

pg() { docker exec -i "$DB" psql -U citybus -v ON_ERROR_STOP=1 "$@"; }

echo "[1/4] seed feed via the project's migrations + importer"
docker run --rm --network "$NET" -v "$REPO":/repo:ro -w /repo/backend \
  -e PYTHONDONTWRITEBYTECODE=1 -e PIP_DISABLE_PIP_VERSION_CHECK=1 -e PIP_ROOT_USER_ACTION=ignore \
  -e DATABASE_URL="postgresql+asyncpg://citybus:citybus@$DB:5432/citybus" \
  python:3.13-slim \
  sh -c "pip install -q -r requirements.txt && alembic upgrade head && python scripts/import_gtfs.py" \
  > "$OUT/seed_import.log" 2>&1

echo "[2/4] scaled network from the canonical DDL"
pg -d citybus -qc "CREATE DATABASE bench"
cat "$REPO/database/sql/00_extensions.sql" "$REPO/database/sql/01_schema.sql" | pg -d bench -q -f -
pg -d bench -f - < "$HERE/01_generate.sql" > "$OUT/generate.log" 2>&1
pg -d bench -f - < "$REPO/database/sql/02_indexes.sql" > "$OUT/indexes.log" 2>&1

echo "[3/4] vacuum + analyze"
pg -d bench -qc "VACUUM ANALYZE"
pg -d citybus -qc "VACUUM ANALYZE"

echo "[4/4] benchmarks"
for d in citybus bench; do pg -d "$d" -q -f - < "$HERE/02_harness.sql"; done
pg -d citybus -f - < "$HERE/04_seed.sql" > "$OUT/seed_results.txt" 2>&1
pg -d bench -f - < "$HERE/03_bench.sql" > "$OUT/bench_results.txt" 2>&1

docker exec "$DB" psql -U citybus -d bench -Atc \
  "select version()" > "$OUT/environment.txt"
docker info --format 'docker {{.ServerVersion}} {{.OSType}}/{{.Architecture}} cpus={{.NCPU}} mem={{.MemTotal}}' \
  >> "$OUT/environment.txt"

docker stop "$DB" >/dev/null
docker network rm "$NET" >/dev/null
echo "done -> $OUT"
