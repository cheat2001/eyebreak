<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { config } from '../config'

interface Release {
  tag_name: string
  assets: Array<{
    download_count: number
  }>
}

interface RepoData {
  stargazers_count: number
  forks_count: number
}

const menuImage = new URL('../assets/images/menu.png', import.meta.url).href
const breakImage = new URL('../assets/images/eyebreak.png', import.meta.url).href
const analyticsImage = new URL('../assets/images/Analytics.png', import.meta.url).href

const totalDownloads = ref<number | null>(null)
const githubStars = ref<number | null>(null)
const isLoadingStats = ref(true)
const statsError = ref(false)

const heroStats = computed(() => [
  { value: '20-20-20', label: 'eye reset rhythm' },
  { value: githubStars.value === null ? 'Open' : githubStars.value.toLocaleString(), label: 'GitHub stars' },
  { value: totalDownloads.value === null ? 'Free' : totalDownloads.value.toLocaleString(), label: 'downloads' }
])

const scrollToInstallation = () => {
  const element = document.getElementById('installation')
  if (element) {
    element.scrollIntoView({ behavior: 'smooth' })
  }
}

const viewGitHub = () => {
  window.open(config.github.url, '_blank')
}

const fetchGitHubStats = async () => {
  try {
    isLoadingStats.value = true
    statsError.value = false

    const releasesResponse = await fetch(`https://api.github.com/repos/${config.github.owner}/${config.github.repo}/releases`)
    if (releasesResponse.ok) {
      const releases: Release[] = await releasesResponse.json()
      totalDownloads.value = releases.reduce((total, release) => {
        return total + release.assets.reduce((assetTotal, asset) => assetTotal + asset.download_count, 0)
      }, 0)
    }

    const repoResponse = await fetch(`https://api.github.com/repos/${config.github.owner}/${config.github.repo}`)
    if (repoResponse.ok) {
      const repoData: RepoData = await repoResponse.json()
      githubStars.value = repoData.stargazers_count
    }
  } catch (error) {
    statsError.value = true
  } finally {
    isLoadingStats.value = false
  }
}

onMounted(() => {
  fetchGitHubStats()
})
</script>

<template>
  <section class="relative min-h-screen overflow-hidden aurora-mesh px-4 pb-16 pt-28 md:pt-32">
    <div class="grid-paper absolute inset-0 opacity-70"></div>
    <div class="absolute inset-x-0 top-0 h-28 bg-gradient-to-b from-slate-950 to-transparent"></div>
    <div class="absolute inset-x-0 bottom-0 h-40 bg-gradient-to-t from-slate-950 to-transparent"></div>

    <div class="container relative z-10 mx-auto grid max-w-7xl items-center gap-14 lg:min-h-[calc(100vh-8rem)] lg:grid-cols-[0.92fr_1.08fr]">
      <div data-reveal class="max-w-3xl">
        <div class="mb-7 inline-flex items-center gap-3 rounded-full border border-white/10 bg-white/[0.06] px-4 py-2 text-sm font-medium text-slate-200 shadow-2xl shadow-black/20 backdrop-blur-xl">
          <span class="relative flex h-2.5 w-2.5">
            <span class="absolute inline-flex h-full w-full animate-ping rounded-full bg-lime-300 opacity-75"></span>
            <span class="relative inline-flex h-2.5 w-2.5 rounded-full bg-lime-300"></span>
          </span>
          macOS {{ config.requirements.macOSVersion }} | v{{ config.app.version }} | privacy-first
        </div>

        <h1 class="text-balance text-5xl font-black tracking-normal text-white sm:text-6xl lg:text-7xl">
          EyeBreak turns screen care into a calm desktop ritual.
        </h1>

        <p class="mt-7 max-w-2xl text-lg leading-8 text-slate-300 md:text-xl">
          A polished macOS companion for eye breaks, hydration reminders, focus cycles, and beautiful overlays that help you pause before fatigue wins.
        </p>

        <div class="mt-10 flex flex-col gap-4 sm:flex-row">
          <button @click="scrollToInstallation" class="btn-primary group inline-flex items-center justify-center gap-3 px-8 py-4 text-base">
            <svg class="h-5 w-5 transition-transform group-hover:translate-y-0.5" fill="currentColor" viewBox="0 0 24 24">
              <path d="M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z"/>
            </svg>
            Download for macOS
          </button>
          <button @click="viewGitHub" class="btn-secondary group inline-flex items-center justify-center gap-3 px-8 py-4 text-base">
            <svg class="h-5 w-5 transition-transform group-hover:rotate-6" fill="currentColor" viewBox="0 0 24 24">
              <path d="M12 0C5.37 0 0 5.37 0 12c0 5.31 3.435 9.795 8.205 11.385.6.105.825-.255.825-.57 0-.285-.015-1.23-.015-2.235-3.015.555-3.795-.735-4.035-1.41-.135-.345-.72-1.41-1.23-1.695-.42-.225-1.02-.78-.015-.795.945-.015 1.62.87 1.845 1.23 1.08 1.815 2.805 1.305 3.495.99.105-.78.42-1.305.765-1.605-2.67-.3-5.46-1.335-5.46-5.925 0-1.305.465-2.385 1.23-3.225-.12-.3-.54-1.53.12-3.18 0 0 1.005-.315 3.3 1.23.96-.27 1.98-.405 3-.405s2.04.135 3 .405c2.295-1.56 3.3-1.23 3.3-1.23.66 1.65.24 2.88.12 3.18.765.84 1.23 1.905 1.23 3.225 0 4.605-2.805 5.625-5.475 5.925.435.375.81 1.095.81 2.22 0 1.605-.015 2.895-.015 3.3 0 .315.225.69.825.57A12.02 12.02 0 0024 12c0-6.63-5.37-12-12-12z"/>
            </svg>
            View source
          </button>
        </div>

        <div class="mt-11 grid max-w-xl grid-cols-3 overflow-hidden rounded-lg border border-white/10 bg-slate-950/45 backdrop-blur-xl">
          <div
            v-for="stat in heroStats"
            :key="stat.label"
            class="border-r border-white/10 px-4 py-4 last:border-r-0"
          >
            <div class="text-xl font-black text-white sm:text-2xl">
              {{ isLoadingStats && stat.label !== 'eye reset rhythm' ? '...' : stat.value }}
            </div>
            <div class="mt-1 text-xs font-medium uppercase tracking-[0.18em] text-slate-500">
              {{ stat.label }}
            </div>
          </div>
        </div>
      </div>

      <div data-reveal style="--reveal-delay: 160ms" class="relative mx-auto w-full max-w-2xl lg:max-w-none">
        <div class="absolute -left-6 top-24 hidden w-28 rounded-lg border border-lime-300/20 bg-lime-300/10 p-3 text-lime-100 shadow-2xl shadow-lime-950/40 backdrop-blur-xl md:block orbit-motion">
          <div class="text-xs uppercase tracking-[0.2em] text-lime-200/70">blink</div>
          <div class="mt-1 text-2xl font-black">20s</div>
        </div>

        <div class="absolute -right-2 bottom-16 z-20 hidden w-44 rounded-lg border border-pink-300/20 bg-pink-300/10 p-4 text-pink-50 shadow-2xl shadow-pink-950/40 backdrop-blur-xl sm:block breath-motion">
          <div class="flex items-center gap-2 text-sm font-semibold">
            <span class="h-2 w-2 rounded-full bg-pink-300"></span>
            Hydration soon
          </div>
          <div class="mt-3 h-1.5 overflow-hidden rounded-full bg-white/10">
            <div class="h-full w-2/3 rounded-full bg-pink-300"></div>
          </div>
        </div>

        <div class="relative rounded-[2rem] border border-white/10 bg-slate-900/65 p-3 shadow-2xl shadow-black/50 backdrop-blur-2xl">
          <div class="overflow-hidden rounded-[1.45rem] border border-white/10 bg-slate-950">
            <div class="flex items-center justify-between border-b border-white/10 bg-white/[0.04] px-4 py-3">
              <div class="flex gap-2">
                <span class="h-3 w-3 rounded-full bg-red-400"></span>
                <span class="h-3 w-3 rounded-full bg-amber-300"></span>
                <span class="h-3 w-3 rounded-full bg-lime-300"></span>
              </div>
              <div class="rounded-full bg-white/5 px-3 py-1 text-xs text-slate-400">EyeBreak live workspace</div>
            </div>

            <div class="grid gap-4 p-4 lg:grid-cols-[0.7fr_1.3fr]">
              <div class="space-y-4">
                <div class="rounded-lg border border-white/10 bg-white/[0.04] p-4">
                  <div class="flex items-center justify-between">
                    <div>
                      <p class="text-xs uppercase tracking-[0.18em] text-cyan-200/70">next break</p>
                      <p class="mt-2 text-4xl font-black text-white">14:28</p>
                    </div>
                    <div class="grid h-16 w-16 place-items-center rounded-full border-4 border-cyan-300/30 text-cyan-200">
                      <svg class="h-7 w-7" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zm0 12.5a5 5 0 110-10 5 5 0 010 10z"/>
                      </svg>
                    </div>
                  </div>
                  <div class="mt-5 h-2 overflow-hidden rounded-full bg-white/10">
                    <div class="h-full w-3/5 rounded-full bg-gradient-to-r from-cyan-300 to-lime-300"></div>
                  </div>
                </div>

                <img :src="menuImage" alt="EyeBreak menu bar screenshot" class="h-36 w-full rounded-lg border border-white/10 object-cover object-left-top shadow-xl" />
              </div>

              <div class="relative min-h-[23rem] overflow-hidden rounded-lg border border-white/10 bg-slate-900">
                <img :src="breakImage" alt="EyeBreak break overlay screenshot" class="absolute inset-0 h-full w-full object-cover opacity-90" />
                <div class="absolute inset-0 bg-gradient-to-t from-slate-950 via-slate-950/15 to-transparent"></div>
                <div class="absolute bottom-4 left-4 right-4 rounded-lg border border-white/10 bg-slate-950/70 p-4 backdrop-blur-xl">
                  <div class="flex items-center justify-between gap-4">
                    <div>
                      <p class="text-xs uppercase tracking-[0.18em] text-slate-400">quiet overlay</p>
                      <p class="mt-1 text-lg font-bold text-white">Look away. Reset your focus.</p>
                    </div>
                    <div class="rounded-full bg-cyan-300 px-3 py-1 text-xs font-black text-slate-950">active</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <img :src="analyticsImage" alt="EyeBreak analytics dashboard screenshot" class="absolute -bottom-10 left-8 hidden w-56 rotate-[-6deg] rounded-lg border border-white/10 object-cover shadow-2xl shadow-black/50 md:block" />
      </div>
    </div>

    <div class="relative z-10 mx-auto mt-10 max-w-7xl overflow-hidden border-y border-white/10 py-4 text-sm font-semibold uppercase tracking-[0.24em] text-slate-400">
      <div class="flex w-max gap-10 ticker-motion">
        <span>eye breaks</span>
        <span>hydration</span>
        <span>focus cycles</span>
        <span>themes</span>
        <span>privacy</span>
        <span>keyboard shortcuts</span>
        <span>eye breaks</span>
        <span>hydration</span>
        <span>focus cycles</span>
        <span>themes</span>
        <span>privacy</span>
        <span>keyboard shortcuts</span>
      </div>
    </div>
  </section>
</template>
