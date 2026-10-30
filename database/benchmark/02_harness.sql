-- Benchmark helpers. Install into each database that is measured.

-- Compact, depth-first description of an EXPLAIN (FORMAT JSON) plan tree,
-- e.g. "Limit > Sort > Bitmap Heap Scan (stops) > Bitmap Index Scan [idx_stops_geography]"
CREATE OR REPLACE FUNCTION bench_plan_nodes(p json) RETURNS text
LANGUAGE sql AS $$
    WITH RECURSIVE n(node, path) AS (
        SELECT p -> 0 -> 'Plan', ARRAY[0]
        UNION ALL
        SELECT c.value, n.path || c.ordinality::int
        FROM n, json_array_elements(n.node -> 'Plans') WITH ORDINALITY c
    )
    SELECT string_agg(
               (node ->> 'Node Type')
               || coalesce(' [' || (node ->> 'Index Name') || ']', '')
               || coalesce(' (' || (node ->> 'Relation Name') || ')', ''),
               ' > ' ORDER BY path)
    FROM n
$$;

-- Runs q `warmup` times, then `runs` times under EXPLAIN ANALYZE (TIMING OFF
-- keeps per-node instrumentation overhead out of the total) and reports the
-- median / min / max server-side execution time in milliseconds.
CREATE OR REPLACE FUNCTION bench_run(q text, runs int DEFAULT 21, warmup int DEFAULT 5)
RETURNS TABLE (median_ms numeric, min_ms numeric, max_ms numeric, plan text)
LANGUAGE plpgsql AS $$
DECLARE
    p json;
    times float8[] := '{}';
BEGIN
    FOR i IN 1..warmup LOOP
        EXECUTE 'EXPLAIN (ANALYZE, TIMING OFF, FORMAT JSON) ' || q INTO p;
    END LOOP;
    FOR i IN 1..runs LOOP
        EXECUTE 'EXPLAIN (ANALYZE, TIMING OFF, FORMAT JSON) ' || q INTO p;
        times := times || (p -> 0 ->> 'Execution Time')::float8;
    END LOOP;
    RETURN QUERY
    SELECT round((percentile_cont(0.5) WITHIN GROUP (ORDER BY x))::numeric, 3),
           round(min(x)::numeric, 3),
           round(max(x)::numeric, 3),
           bench_plan_nodes(p)
    FROM unnest(times) x;
END;
$$;

-- Wall-clock milliseconds of one statement (DDL / DML), measured server-side.
CREATE OR REPLACE FUNCTION bench_time(stmt text) RETURNS numeric
LANGUAGE plpgsql AS $$
DECLARE
    t0 timestamptz := clock_timestamp();
BEGIN
    EXECUTE stmt;
    RETURN round((extract(epoch FROM clock_timestamp() - t0) * 1000)::numeric, 1);
END;
$$;
