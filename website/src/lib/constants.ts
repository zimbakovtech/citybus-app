export const GITHUB_URL = 'https://github.com/zimbakovtech/citybus'

export const NAV_LINKS = [
  { href: '#features', label: 'Features' },
  { href: '#app', label: 'App' },
  { href: '#architecture', label: 'Architecture' },
  { href: '#database', label: 'Database' },
  { href: '#api', label: 'API' },
] as const

/** Resolves a file in `public/` against the deploy base path. */
export const asset = (path: string) => `${import.meta.env.BASE_URL}${path}`
