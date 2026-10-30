# CityBus website

Public project website, served at
**https://zimbakovtech.github.io/citybus-app/** via GitHub Pages.

Built with Vite + React + TypeScript and Tailwind CSS 4. Fully static —
no runtime data fetching; screenshots are pre-compressed WebP copies of
[`docs/screenshots/`](../docs/screenshots).

## Development

```bash
npm install
npm run dev        # local dev server
npm run build      # type-check + static build into dist/
npm run preview    # serve the production build locally
```

## Deployment

[`.github/workflows/website.yml`](../.github/workflows/website.yml) builds
`dist/` and deploys it to GitHub Pages whenever a `v*.*.*` tag is pushed
(or manually via *workflow_dispatch*). It is a project site, so Vite's
`base` is `/citybus-app/`; reference files in `public/` through the
`asset()` helper in [`src/lib/constants.ts`](src/lib/constants.ts) rather
than as root-relative paths.
