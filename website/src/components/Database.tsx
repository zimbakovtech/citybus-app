import { ArrowRight, Database as DatabaseIcon, MoveHorizontal } from 'lucide-react'
import { GITHUB_URL } from '../lib/constants'

type Field = {
  name: string
  type: string
  key?: 'PK' | 'FK' | 'UK' | 'PK/FK'
}

type Entity = {
  name: string
  source: string
  x: number
  y: number
  accent: string
  fields: Field[]
}

const ENTITIES: Entity[] = [
  {
    name: 'agency',
    source: 'agency.txt',
    x: 20,
    y: 20,
    accent: 'bg-sky-400',
    fields: [
      { name: 'id', type: 'bigint', key: 'PK' },
      { name: 'gtfs_agency_id', type: 'text', key: 'UK' },
      { name: 'name', type: 'text' },
      { name: 'timezone', type: 'text' },
    ],
  },
  {
    name: 'routes',
    source: 'routes.txt',
    x: 300,
    y: 20,
    accent: 'bg-sky-400',
    fields: [
      { name: 'id', type: 'bigint', key: 'PK' },
      { name: 'gtfs_route_id', type: 'text', key: 'UK' },
      { name: 'agency_id', type: 'bigint', key: 'FK' },
      { name: 'short_name', type: 'text' },
      { name: 'long_name', type: 'text' },
      { name: 'route_type', type: 'smallint' },
    ],
  },
  {
    name: 'services',
    source: 'normalized entity',
    x: 590,
    y: 20,
    accent: 'bg-amber-400',
    fields: [
      { name: 'id', type: 'bigint', key: 'PK' },
      { name: 'gtfs_service_id', type: 'text', key: 'UK' },
    ],
  },
  {
    name: 'calendar',
    source: 'calendar.txt',
    x: 950,
    y: 10,
    accent: 'bg-amber-400',
    fields: [
      { name: 'service_id', type: 'bigint', key: 'PK/FK' },
      { name: 'monday … sunday', type: 'boolean' },
      { name: 'start_date', type: 'date' },
      { name: 'end_date', type: 'date' },
    ],
  },
  {
    name: 'calendar_dates',
    source: 'calendar_dates.txt',
    x: 950,
    y: 230,
    accent: 'bg-amber-400',
    fields: [
      { name: 'id', type: 'bigint', key: 'PK' },
      { name: 'service_id', type: 'bigint', key: 'FK' },
      { name: 'date', type: 'date' },
      { name: 'exception_type', type: 'smallint' },
    ],
  },
  {
    name: 'shapes',
    source: 'shapes.txt',
    x: 20,
    y: 330,
    accent: 'bg-emerald-400',
    fields: [
      { name: 'id', type: 'bigint', key: 'PK' },
      { name: 'gtfs_shape_id', type: 'text', key: 'UK' },
      { name: 'geom', type: 'LineString' },
    ],
  },
  {
    name: 'shape_points',
    source: 'shapes.txt rows',
    x: 20,
    y: 650,
    accent: 'bg-emerald-400',
    fields: [
      { name: 'id', type: 'bigint', key: 'PK' },
      { name: 'shape_id', type: 'bigint', key: 'FK' },
      { name: 'pt_sequence', type: 'integer' },
      { name: 'lat', type: 'double' },
      { name: 'lon', type: 'double' },
      { name: 'dist_traveled', type: 'double' },
    ],
  },
  {
    name: 'trips',
    source: 'trips.txt',
    x: 300,
    y: 330,
    accent: 'bg-sky-400',
    fields: [
      { name: 'id', type: 'bigint', key: 'PK' },
      { name: 'gtfs_trip_id', type: 'text', key: 'UK' },
      { name: 'route_id', type: 'bigint', key: 'FK' },
      { name: 'service_id', type: 'bigint', key: 'FK' },
      { name: 'shape_id', type: 'bigint', key: 'FK' },
      { name: 'direction_id', type: 'smallint' },
    ],
  },
  {
    name: 'stop_times',
    source: 'stop_times.txt · fact table',
    x: 620,
    y: 440,
    accent: 'bg-blue-400',
    fields: [
      { name: 'trip_id', type: 'bigint', key: 'PK/FK' },
      { name: 'stop_sequence', type: 'integer', key: 'PK' },
      { name: 'stop_id', type: 'bigint', key: 'FK' },
      { name: 'arrival_time', type: 'interval' },
      { name: 'departure_time', type: 'interval' },
      { name: 'pickup / drop_off', type: 'smallint' },
    ],
  },
  {
    name: 'stops',
    source: 'stops.txt',
    x: 950,
    y: 430,
    accent: 'bg-emerald-400',
    fields: [
      { name: 'id', type: 'bigint', key: 'PK' },
      { name: 'gtfs_stop_id', type: 'text', key: 'UK' },
      { name: 'name', type: 'text' },
      { name: 'geom', type: 'Point' },
      { name: 'parent_station_id', type: 'bigint', key: 'FK' },
    ],
  },
  {
    name: 'vehicle_positions',
    source: 'realtime telemetry',
    x: 620,
    y: 750,
    accent: 'bg-violet-400',
    fields: [
      { name: 'id', type: 'bigint', key: 'PK' },
      { name: 'vehicle_id', type: 'text' },
      { name: 'trip_id', type: 'bigint', key: 'FK' },
      { name: 'current_stop_id', type: 'bigint', key: 'FK' },
      { name: 'geom', type: 'Point' },
      { name: 'delay_seconds', type: 'integer' },
      { name: 'recorded_at', type: 'timestamptz' },
    ],
  },
]

const RELATIONSHIPS = [
  { d: 'M 250 94 H 300', x: 275, y: 79, label: 'operates' },
  { d: 'M 415 246 V 330', x: 457, y: 292, label: 'has many' },
  {
    d: 'M 590 91 H 560 V 403 H 530',
    x: 560,
    y: 288,
    label: 'schedules',
  },
  { d: 'M 820 75 H 950', x: 885, y: 60, label: 'defines 0..1' },
  {
    d: 'M 820 101 H 870 V 302 H 950',
    x: 870,
    y: 287,
    label: 'excepts',
  },
  {
    d: 'M 135 466 V 650',
    x: 177,
    y: 563,
    label: 'built from',
  },
  { d: 'M 250 404 H 300', x: 275, y: 389, label: 'path for' },
  {
    d: 'M 530 424 H 575 V 514 H 620',
    x: 576,
    y: 498,
    label: 'contains',
  },
  { d: 'M 950 514 H 850', x: 900, y: 499, label: 'served at' },
  {
    d: 'M 415 556 V 680 H 590 V 824 H 620',
    x: 532,
    y: 666,
    label: 'tracks',
  },
  {
    d: 'M 1065 630 V 700 H 900 V 824 H 850',
    x: 938,
    y: 686,
    label: 'near',
  },
  {
    d: 'M 1180 510 H 1210 V 615 H 1180',
    x: 1205,
    y: 565,
    label: 'parent',
  },
] as const

function EntityCard({ entity }: { entity: Entity }) {
  return (
    <article
      className="absolute w-[230px] overflow-hidden rounded-xl border border-slate-700 bg-slate-900 shadow-xl shadow-black/20"
      style={{ left: entity.x, top: entity.y }}
    >
      <header className="relative border-b border-slate-700 bg-slate-800/90 px-3.5 py-2.5">
        <span
          className={`absolute inset-y-0 left-0 w-1 ${entity.accent}`}
          aria-hidden="true"
        />
        <h3 className="font-display text-sm font-semibold text-white">
          {entity.name}
        </h3>
        <p className="mt-0.5 text-[10px] text-slate-400">{entity.source}</p>
      </header>
      <ul className="divide-y divide-slate-800 px-3 py-1.5">
        {entity.fields.map((field) => (
          <li
            key={field.name}
            className="flex min-h-7 items-center gap-2 font-mono text-[10px]"
          >
            {field.key ? (
              <span
                className={`w-9 shrink-0 rounded px-1 py-0.5 text-center text-[8px] font-bold tracking-wide ${
                  field.key.includes('PK')
                    ? 'bg-blue-400/15 text-blue-300'
                    : field.key === 'FK'
                      ? 'bg-violet-400/15 text-violet-300'
                      : 'bg-amber-400/15 text-amber-300'
                }`}
              >
                {field.key}
              </span>
            ) : (
              <span className="w-9 shrink-0" aria-hidden="true" />
            )}
            <span className="min-w-0 flex-1 text-slate-200">{field.name}</span>
            <span className="shrink-0 text-slate-500">{field.type}</span>
          </li>
        ))}
      </ul>
    </article>
  )
}

export function Database() {
  return (
    <section
      id="database"
      className="overflow-hidden bg-slate-950 py-20 sm:py-24"
    >
      <div className="mx-auto max-w-6xl px-4 sm:px-6">
        <div className="flex flex-col justify-between gap-8 lg:flex-row lg:items-end">
          <div className="max-w-2xl">
            <p className="text-sm font-semibold tracking-wide text-blue-400 uppercase">
              Database
            </p>
            <h2 className="font-display mt-2 text-3xl font-bold tracking-tight text-white sm:text-4xl">
              The whole network, relationally
            </h2>
            <p className="mt-4 text-lg leading-relaxed text-slate-400">
              Eleven tables turn a GTFS feed into routes riders recognize,
              schedules the planner can scan, map-ready geometry and a live
              stream of vehicle positions.
            </p>
          </div>

          <a
            href={`${GITHUB_URL}/blob/main/docs/database.md`}
            target="_blank"
            rel="noreferrer"
            className="inline-flex w-fit items-center gap-2 text-sm font-semibold text-blue-300 transition-colors hover:text-blue-200"
          >
            Read the design decisions
            <ArrowRight className="size-4" aria-hidden="true" />
          </a>
        </div>

        <div className="mt-10 flex flex-wrap items-center justify-between gap-4 border-y border-slate-800 py-4">
          <div className="flex flex-wrap gap-2 text-[11px] font-medium">
            <span className="rounded-md bg-blue-400/15 px-2 py-1 text-blue-300">
              PK primary key
            </span>
            <span className="rounded-md bg-violet-400/15 px-2 py-1 text-violet-300">
              FK foreign key
            </span>
            <span className="rounded-md bg-amber-400/15 px-2 py-1 text-amber-300">
              UK GTFS identity
            </span>
            <span className="rounded-md bg-slate-800 px-2 py-1 text-slate-400">
              1 → many unless marked
            </span>
          </div>
          <p className="flex items-center gap-2 text-xs text-slate-500 xl:hidden">
            <MoveHorizontal className="size-4" aria-hidden="true" />
            Scroll to explore
          </p>
        </div>

        <figure className="mt-6 xl:-mx-16">
          <div
            className="overflow-x-auto rounded-2xl border border-slate-800 bg-slate-900/40 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-blue-400"
            tabIndex={0}
            role="region"
            aria-label="Scrollable CityBus entity relationship diagram"
          >
            <div
              className="relative h-[1050px] w-[1230px]"
              role="group"
              aria-label="Eleven database entities and their relationships"
            >
              <svg
                className="absolute inset-0 size-full text-slate-600"
                viewBox="0 0 1230 1050"
                aria-hidden="true"
              >
                <defs>
                  <filter
                    id="erd-label-shadow"
                    x="-20%"
                    y="-30%"
                    width="140%"
                    height="160%"
                  >
                    <feDropShadow
                      dx="0"
                      dy="0"
                      stdDeviation="4"
                      floodColor="#020617"
                      floodOpacity="1"
                    />
                  </filter>
                </defs>
                {RELATIONSHIPS.map(({ d, x, y, label }) => (
                  <g key={label + d}>
                    <path
                      d={d}
                      fill="none"
                      stroke="currentColor"
                      strokeWidth="1.5"
                      strokeLinejoin="round"
                    />
                    <text
                      x={x}
                      y={y}
                      fill="#94a3b8"
                      fontFamily="Work Sans, sans-serif"
                      fontSize="10"
                      fontWeight="600"
                      textAnchor="middle"
                      filter="url(#erd-label-shadow)"
                    >
                      {label}
                    </text>
                  </g>
                ))}
              </svg>

              {ENTITIES.map((entity) => (
                <EntityCard key={entity.name} entity={entity} />
              ))}

              <ul className="sr-only">
                <li>One agency operates many routes.</li>
                <li>One route has many trips.</li>
                <li>One service schedules many trips.</li>
                <li>One service defines zero or one weekly calendar.</li>
                <li>One service has many calendar date exceptions.</li>
                <li>One shape is built from many shape points.</li>
                <li>One shape can provide the path for many trips.</li>
                <li>One trip contains many stop times.</li>
                <li>One stop is referenced by many stop times.</li>
                <li>One trip can have many recorded vehicle positions.</li>
                <li>One stop can be near many recorded vehicle positions.</li>
                <li>A stop can have one parent and a parent can have many child stops.</li>
              </ul>
            </div>
          </div>
          <figcaption className="mt-4 flex flex-col gap-3 text-xs leading-relaxed text-slate-500 sm:flex-row sm:items-center sm:justify-between">
            <span>
              Lines show foreign-key relationships; optional references use{' '}
              <code className="text-slate-400">ON DELETE SET NULL</code>, while
              composition edges cascade.
            </span>
            <span className="inline-flex shrink-0 items-center gap-1.5 text-slate-400">
              <DatabaseIcon className="size-3.5" aria-hidden="true" />
              PostgreSQL 16 · PostGIS 3.5
            </span>
          </figcaption>
        </figure>
      </div>
    </section>
  )
}
