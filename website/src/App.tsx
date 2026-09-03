import { Nav } from './components/Nav'
import { Hero } from './components/Hero'
import { Features } from './components/Features'
import { Screenshots } from './components/Screenshots'
import { Architecture } from './components/Architecture'
import { Database } from './components/Database'
import { Api } from './components/Api'
import { Footer } from './components/Footer'

export default function App() {
  return (
    <div className="bg-slate-50 font-sans text-slate-900 antialiased">
      <a
        href="#main"
        className="sr-only focus:not-sr-only focus:fixed focus:top-4 focus:left-4 focus:z-50 focus:rounded-lg focus:bg-blue-600 focus:px-4 focus:py-2 focus:text-white"
      >
        Skip to main content
      </a>
      <Nav />
      <main id="main">
        <Hero />
        <Features />
        <Screenshots />
        <Architecture />
        <Database />
        <Api />
      </main>
      <Footer />
    </div>
  )
}
