<script setup lang="ts">
interface Screenshot {
  title: string
  description: string
  image: string
  badge?: string
}

const screenshots: Screenshot[] = [
  {
    title: 'Clean Menu Bar Integration',
    description: 'Lightweight app that lives in your menu bar with quick access to all features',
    image: new URL('../assets/images/menu.png', import.meta.url).href,
    badge: 'Menu Bar'
  },
  {
    title: 'Beautiful Break Overlay',
    description: 'Full-screen blur with customizable themes and smooth animations',
    image: new URL('../assets/images/eyebreak.png', import.meta.url).href,
    badge: 'Break Screen'
  },
  {
    title: 'Water Reminder',
    description: 'Stay hydrated with smart reminders - blur screen or ambient pop-up styles',
    image: new URL('../assets/images/waterbreak.png', import.meta.url).href,
    badge: 'NEW in v2.1'
  },
  {
    title: 'Ambient Reminders',
    description: 'Gentle floating notifications with glass morphism effects',
    image: new URL('../assets/images/Ambient.png', import.meta.url).href,
    badge: 'Ambient'
  },
  {
    title: 'Comprehensive Settings',
    description: 'Customize every aspect: intervals, themes, sounds, and more',
    image: new URL('../assets/images/setting.png', import.meta.url).href,
    badge: 'Settings'
  },
  {
    title: 'Analytics Dashboard',
    description: 'Track your progress with beautiful charts and insights',
    image: new URL('../assets/images/Analytics.png', import.meta.url).href,
    badge: 'Statistics'
  }
]

const featuredScreenshot = screenshots[1] as Screenshot
const sideScreenshots = [screenshots[0], screenshots[2]] as Screenshot[]
const galleryScreenshots = screenshots.slice(3)
</script>

<template>
  <section id="screenshots" class="relative overflow-hidden bg-gradient-to-b from-slate-950 via-slate-900 to-slate-950 px-4 py-24">
    <div class="absolute inset-0 bg-[linear-gradient(120deg,transparent,rgba(34,211,238,0.08),transparent)]"></div>

    <div class="container relative z-10 mx-auto max-w-7xl">
      <div data-reveal class="mb-16 text-center">
        <div class="mb-4 inline-flex items-center gap-3 rounded-full border border-fuchsia-300/20 bg-fuchsia-300/10 px-4 py-2 text-sm font-semibold text-fuchsia-100">
          <svg class="w-5 h-5 text-fuchsia-200" fill="currentColor" viewBox="0 0 24 24">
            <path d="M21 19V5c0-1.1-.9-2-2-2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2zM8.5 13.5l2.5 3.01L14.5 12l4.5 6H5l3.5-4.5z"/>
          </svg>
          Product gallery
        </div>
        <h2 class="text-balance text-4xl font-black text-white md:text-6xl">A calmer layer over your busiest screen.</h2>
        <p class="mx-auto mt-5 max-w-3xl text-lg leading-8 text-slate-400">
          From menu bar control to analytics, every surface is designed to be quick, quiet, and easy to trust.
        </p>
      </div>

      <div data-reveal class="mb-8 grid gap-8 lg:grid-cols-[1.35fr_0.65fr]">
        <div class="group relative overflow-hidden rounded-lg border border-white/10 bg-slate-950 shadow-2xl shadow-black/40">
          <img
            :src="featuredScreenshot.image"
            :alt="featuredScreenshot.title"
            class="aspect-[16/10] w-full object-cover transition-transform duration-700 group-hover:scale-105"
            loading="lazy"
          />
          <div class="absolute inset-0 bg-gradient-to-t from-slate-950 via-slate-950/20 to-transparent"></div>
          <div class="absolute bottom-0 left-0 right-0 p-6 md:p-8">
            <span class="mb-3 inline-flex rounded-full bg-cyan-300 px-3 py-1 text-xs font-black uppercase tracking-[0.16em] text-slate-950">
              {{ featuredScreenshot.badge }}
            </span>
            <h3 class="text-2xl font-black text-white md:text-4xl">{{ featuredScreenshot.title }}</h3>
            <p class="mt-3 max-w-2xl text-slate-300">{{ featuredScreenshot.description }}</p>
          </div>
        </div>

        <div class="grid gap-8">
          <div
            v-for="screenshot in sideScreenshots"
            :key="screenshot.title"
            class="group overflow-hidden rounded-lg border border-white/10 bg-white/[0.04] shadow-xl shadow-black/20"
          >
            <img
              :src="screenshot.image"
              :alt="screenshot.title"
              class="aspect-video w-full object-cover transition-transform duration-500 group-hover:scale-105"
              loading="lazy"
            />
            <div class="p-5">
              <div class="mb-2 text-xs font-semibold uppercase tracking-[0.18em] text-cyan-200">{{ screenshot.badge }}</div>
              <h3 class="text-lg font-bold text-white">{{ screenshot.title }}</h3>
            </div>
          </div>
        </div>
      </div>

      <div class="grid grid-cols-1 gap-6 md:grid-cols-3">
        <div
          v-for="(screenshot, index) in galleryScreenshots"
          :key="screenshot.title"
          data-reveal
          class="group relative overflow-hidden rounded-lg border border-white/10 bg-white/[0.04] transition-all duration-300 hover:-translate-y-1 hover:border-fuchsia-300/30"
          :style="{ '--reveal-delay': `${index * 80}ms` }"
        >
          <div 
            v-if="screenshot.badge"
            class="absolute right-4 top-4 z-10 rounded-full bg-slate-950/80 px-3 py-1.5 text-xs font-bold text-white shadow-lg backdrop-blur-xl"
          >
            {{ screenshot.badge }}
          </div>

          <div class="aspect-video overflow-hidden bg-slate-950">
            <img 
              :src="screenshot.image" 
              :alt="screenshot.title"
              class="h-full w-full object-cover transition-transform duration-500 group-hover:scale-105"
              loading="lazy"
            />
          </div>

          <div class="p-6">
            <h3 class="mb-2 text-lg font-bold text-white transition-colors group-hover:text-fuchsia-100">
              {{ screenshot.title }}
            </h3>
            <p class="text-sm leading-relaxed text-slate-400">
              {{ screenshot.description }}
            </p>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>
