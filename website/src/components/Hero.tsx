import { ArrowRight } from 'lucide-react'
import { asset, GITHUB_URL } from '../lib/constants'
import { GithubIcon } from './GithubIcon'

const STATS = [
  { value: '5', label: 'bus lines' },
  { value: '30', label: 'stops' },
  { value: '682', label: 'trips' },
  { value: '6,396', label: 'stop events' },
]

export function Hero() {
  return (
    <section className="relative overflow-hidden bg-gradient-to-b from-blue-50/80 to-slate-50 pt-16">
      <div className="mx-auto grid max-w-6xl items-center gap-12 px-4 py-16 sm:px-6 sm:py-20 lg:grid-cols-[1.1fr_0.9fr] lg:py-24">
        <div>
          <p className="inline-flex items-center gap-2 rounded-full border border-blue-200 bg-blue-50 px-3 py-1 text-xs font-medium text-blue-700">
            Databases course project · FINKI
          </p>
          <h1 className="font-display mt-5 text-4xl font-bold tracking-tight text-balance sm:text-5xl lg:text-6xl">
            A city bus network,{' '}
            <span className="text-blue-600">modeled end to end</span>
          </h1>
          <p className="mt-5 max-w-xl text-lg leading-relaxed text-slate-600">
            CityBus is a public-transport system built around a{' '}
            <strong className="font-semibold text-slate-800">
              PostgreSQL + PostGIS
            </strong>{' '}
            database storing a GTFS-modeled bus network for Skopje — served by a{' '}
            <strong className="font-semibold text-slate-800">FastAPI</strong>{' '}
            backend and a{' '}
            <strong className="font-semibold text-slate-800">Flutter</strong>{' '}
            app with search, departures, a transfer-aware journey planner and a
            live vehicle map.
          </p>
          <div className="mt-8 flex flex-wrap items-center gap-3">
            <a
              href={GITHUB_URL}
              target="_blank"
              rel="noreferrer"
              className="inline-flex items-center gap-2 rounded-xl bg-blue-600 px-5 py-3 text-sm font-semibold text-white shadow-sm transition-colors hover:bg-blue-700"
            >
              <GithubIcon className="size-4" />
              View on GitHub
            </a>
            <a
              href="#architecture"
              className="inline-flex items-center gap-2 rounded-xl border border-slate-300 bg-white px-5 py-3 text-sm font-semibold text-slate-700 transition-colors hover:border-slate-400 hover:bg-slate-50"
            >
              Explore the architecture
              <ArrowRight className="size-4" aria-hidden="true" />
            </a>
          </div>

          <dl className="mt-10 grid max-w-md grid-cols-4 gap-4 border-t border-slate-200 pt-6">
            {STATS.map(({ value, label }) => (
              <div key={label}>
                <dt className="order-last text-xs text-slate-500">{label}</dt>
                <dd className="font-display text-2xl font-bold text-slate-900">
                  {value}
                </dd>
              </div>
            ))}
          </dl>
          <p className="mt-3 text-xs text-slate-400">
            Synthetic GTFS feed committed with the repo — everything runs fully
            offline.
          </p>
        </div>

        <div className="relative mx-auto w-full max-w-[300px] lg:max-w-[320px]">
          <div
            className="absolute -inset-8 rounded-full bg-blue-100/60 blur-3xl"
            aria-hidden="true"
          />
          <div className="relative rounded-[2.2rem] border border-slate-800 bg-slate-900 p-2 shadow-2xl shadow-slate-900/25">
            <img
              src={asset('screenshots/live.webp')}
              alt="CityBus app showing the live vehicle map of Skopje with buses moving along their routes"
              width="540"
              height="1174"
              fetchPriority="high"
              className="w-full rounded-[1.7rem]"
            />
          </div>
        </div>
      </div>
    </section>
  )
}
