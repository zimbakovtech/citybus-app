import { asset, GITHUB_URL } from '../lib/constants'

const LINKS = [
  { href: GITHUB_URL, label: 'GitHub repository' },
  { href: `${GITHUB_URL}/blob/main/docs/architecture.md`, label: 'Architecture docs' },
  { href: `${GITHUB_URL}/blob/main/docs/database.md`, label: 'Database design' },
  { href: `${GITHUB_URL}/blob/main/LICENSE`, label: 'MIT License' },
]

export function Footer() {
  return (
    <footer className="bg-slate-950 py-14 text-slate-400">
      <div className="mx-auto flex max-w-6xl flex-col gap-10 px-4 sm:px-6 md:flex-row md:items-start md:justify-between">
        <div className="max-w-sm">
          <div className="flex items-center gap-2.5">
            <img src={asset('favicon.svg')} alt="" className="size-9" />
            <span className="font-display text-lg font-bold tracking-tight text-white">
              CityBus
            </span>
          </div>
          <p className="mt-4 text-sm leading-relaxed">
            A city bus transit system built for the Databases course at FINKI —
            PostgreSQL + PostGIS at the core, FastAPI and Flutter around it.
          </p>
        </div>

        <nav aria-label="Footer">
          <ul className="space-y-2.5 text-sm">
            {LINKS.map(({ href, label }) => (
              <li key={href}>
                <a
                  href={href}
                  target="_blank"
                  rel="noreferrer"
                  className="transition-colors hover:text-white"
                >
                  {label}
                </a>
              </li>
            ))}
          </ul>
        </nav>
      </div>
      <div className="mx-auto mt-10 max-w-6xl border-t border-slate-800 px-4 pt-6 sm:px-6">
        <p className="text-xs">
          Damjan Zimbakov &amp; Filip Karamachoski · FINKI Databases course ·
          MIT licensed
        </p>
      </div>
    </footer>
  )
}
