import { asset, GITHUB_URL, NAV_LINKS } from '../lib/constants'
import { GithubIcon } from './GithubIcon'

export function Nav() {
  return (
    <header className="fixed inset-x-0 top-0 z-40 border-b border-slate-200/80 bg-white/85 backdrop-blur-md">
      <nav
        aria-label="Main"
        className="mx-auto flex h-16 max-w-6xl items-center justify-between px-4 sm:px-6"
      >
        <a href="#main" className="flex items-center gap-2.5">
          <img src={asset('favicon.svg')} alt="" className="size-9" />
          <span className="font-display text-lg font-bold tracking-tight">
            CityBus
          </span>
        </a>

        <div className="hidden items-center gap-1 md:flex">
          {NAV_LINKS.map(({ href, label }) => (
            <a
              key={href}
              href={href}
              className="rounded-lg px-3 py-2 text-sm font-medium text-slate-600 transition-colors hover:bg-slate-100 hover:text-slate-900"
            >
              {label}
            </a>
          ))}
        </div>

        <a
          href={GITHUB_URL}
          target="_blank"
          rel="noreferrer"
          className="inline-flex items-center gap-2 rounded-lg bg-slate-900 px-3.5 py-2 text-sm font-medium text-white transition-colors hover:bg-slate-700"
        >
          <GithubIcon className="size-4" />
          GitHub
        </a>
      </nav>
    </header>
  )
}
