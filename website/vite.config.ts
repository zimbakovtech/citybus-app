import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

// Served as a GitHub Pages project site at zimbakovtech.github.io/citybus-app/,
// so every asset URL needs the repo name as its base path.
export default defineConfig({
  base: '/citybus-app/',
  plugins: [react(), tailwindcss()],
})
