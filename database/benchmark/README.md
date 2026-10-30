# Database benchmark

Measures the hot queries of the backend before and after the schema
decisions documented in [docs/database.md](../../docs/database.md), on the
seed feed and on a scaled synthetic network (10 000 stops, 114 568 trips,
3 153 040 stop_times, 5.4 M telemetry rows).

```bash
database/benchmark/run_all.sh            # needs Docker; ~3 min
```

The script starts a throwaway `postgis/postgis:16-3.5` container on a private
network, builds the seed database with the real Alembic migrations and
importer, builds the scaled network from `database/sql/` plus
`01_generate.sql`, runs `03_bench.sql` / `04_seed.sql` and removes the
container. Nothing else is touched.

| File | Purpose |
|---|---|
| `01_generate.sql` | deterministic scaled network + telemetry in the old and new layout |
| `02_harness.sql` | `bench_run()`: warm-up, then median `EXPLAIN (ANALYZE)` execution time |
| `03_bench.sql` | scaled-network cases; "before" variants drop an index inside a rolled-back transaction |
| `04_seed.sql` | the same hot queries on the committed seed feed |

Results land in `results/` (git-ignored): `bench_results.txt` and
`seed_results.txt`, one `case|variant|median_ms|min_ms|max_ms|plan` line per
measurement.
