import { asset } from '../lib/constants'

type Shot = {
  src: string
  title: string
  caption: string
  alt: string
}

const SHOTS: Shot[] = [
  {
    src: asset('screenshots/stops.webp'),
    title: 'Stops',
    caption: 'Search and nearby tabs',
    alt: 'Stops screen with search field and a list of stops in Skopje',
  },
  {
    src: asset('screenshots/routes.webp'),
    title: 'Routes',
    caption: 'All lines at a glance',
    alt: 'Routes screen listing the bus lines',
  },
  {
    src: asset('screenshots/stop_lines.webp'),
    title: 'Stop detail',
    caption: 'Serving lines & departures',
    alt: 'Stop detail screen with serving lines and upcoming departures',
  },
  {
    src: asset('screenshots/planner.webp'),
    title: 'Planner',
    caption: 'Transfer-aware journeys',
    alt: 'Journey planner screen showing a planned trip with legs',
  },
  {
    src: asset('screenshots/live.webp'),
    title: 'Live',
    caption: 'Vehicles in realtime',
    alt: 'Live map screen with simulated vehicle positions',
  },
]

export function Screenshots() {
  return (
    <section id="app" className="bg-slate-950 py-20 sm:py-24">
      <div className="mx-auto max-w-6xl px-4 sm:px-6">
        <div className="max-w-2xl">
          <p className="text-sm font-semibold tracking-wide text-blue-400 uppercase">
            Mobile app
          </p>
          <h2 className="font-display mt-2 text-3xl font-bold tracking-tight text-white sm:text-4xl">
            The app, at a glance
          </h2>
          <p className="mt-4 text-lg leading-relaxed text-slate-400">
            A feature-first Flutter app — Riverpod for state, GoRouter for
            navigation, flutter_map with OpenStreetMap tiles for the maps.
          </p>
        </div>

        <ul className="mt-12 grid grid-cols-2 gap-x-4 gap-y-10 sm:grid-cols-3 lg:grid-cols-5">
          {SHOTS.map(({ src, title, caption, alt }) => (
            <li key={title} className="mx-auto w-full max-w-[220px]">
              <div className="rounded-[1.6rem] border border-slate-700/60 bg-slate-900 p-1.5 shadow-xl shadow-black/40">
                <img
                  src={src}
                  alt={alt}
                  width="540"
                  height="1174"
                  loading="lazy"
                  className="w-full rounded-[1.15rem]"
                />
              </div>
              <p className="font-display mt-4 text-center text-sm font-semibold text-white">
                {title}
              </p>
              <p className="mt-0.5 text-center text-xs text-slate-400">
                {caption}
              </p>
            </li>
          ))}
        </ul>
      </div>
    </section>
  )
}
