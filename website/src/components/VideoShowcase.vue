<script setup lang="ts">
import { onMounted, onUnmounted, ref } from 'vue'

const videoRef = ref<HTMLVideoElement | null>(null)
const videoContainerRef = ref<HTMLElement | null>(null)
const isPlaying = ref(false)
const animateIn = ref(false)
const videoError = ref(false)
const hasAutoPlayed = ref(false)
const demoVideo = new URL('../assets/videos/eyebreak video.mov', import.meta.url).href
const posterImage = new URL('../assets/images/eyebreak.png', import.meta.url).href

const callouts = [
  {
    title: 'Native rhythm',
    description: 'Menu bar control, keyboard shortcuts, and break cues feel at home on macOS.',
    iconPath: 'M20 5H4c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2zm-2 10H6V9h12v6z'
  },
  {
    title: 'Gentle interruption',
    description: 'Visual overlays help you pause without turning every reminder into an alarm.',
    iconPath: 'M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zm0 12.5a5 5 0 110-10 5 5 0 010 10z'
  },
  {
    title: 'Healthy momentum',
    description: 'Breaks, water, Pomodoro, and analytics work together as one compact habit system.',
    iconPath: 'M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z'
  }
]

const togglePlay = () => {
  if (!videoRef.value) return

  if (videoRef.value.paused) {
    videoRef.value.play()
      .then(() => {
        isPlaying.value = true
        videoError.value = false
      })
      .catch(() => {
        videoError.value = true
      })
  } else {
    videoRef.value.pause()
    isPlaying.value = false
  }
}

let observer: IntersectionObserver | null = null

onMounted(() => {
  const video = videoRef.value

  if (video) {
    video.addEventListener('play', () => {
      isPlaying.value = true
    })
    video.addEventListener('pause', () => {
      isPlaying.value = false
    })
    video.addEventListener('ended', () => {
      isPlaying.value = false
    })
    video.addEventListener('loadstart', () => {
      videoError.value = false
    })
    video.addEventListener('canplay', () => {
      videoError.value = false
    })
    video.addEventListener('loadedmetadata', () => {
      videoError.value = false
    })
    video.addEventListener('loadeddata', () => {
      videoError.value = false
    })
    video.addEventListener('playing', () => {
      videoError.value = false
    })
    video.addEventListener('error', () => {
      videoError.value = true
    })
  }

  if (videoContainerRef.value) {
    observer = new IntersectionObserver(
      ([entry]) => {
        if (entry?.isIntersecting) {
          animateIn.value = true

          if (!hasAutoPlayed.value && videoRef.value) {
            videoRef.value.muted = true
            videoRef.value.play()
              .then(() => {
                hasAutoPlayed.value = true
                isPlaying.value = true
                videoError.value = false
              })
              .catch(() => {
                hasAutoPlayed.value = true
              })
          }
        } else if (videoRef.value && !videoRef.value.paused) {
          videoRef.value.pause()
          isPlaying.value = false
        }
      },
      { threshold: 0.45 }
    )

    observer.observe(videoContainerRef.value)
  }
})

onUnmounted(() => {
  observer?.disconnect()
})
</script>

<template>
  <section class="relative overflow-hidden bg-slate-950 px-4 py-24">
    <div class="grid-paper absolute inset-0 opacity-35"></div>
    <div class="absolute inset-x-0 top-0 h-px bg-gradient-to-r from-transparent via-fuchsia-300/30 to-transparent"></div>

    <div class="container relative z-10 mx-auto max-w-7xl">
      <div data-reveal class="mb-14 grid gap-8 lg:grid-cols-[0.85fr_1.15fr] lg:items-end">
        <div>
          <div class="mb-4 inline-flex items-center gap-2 rounded-full border border-fuchsia-300/20 bg-fuchsia-300/10 px-4 py-2 text-sm font-semibold text-fuchsia-100">
            <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">
              <path d="M8 5v14l11-7z"/>
            </svg>
            Watch the workflow
          </div>
          <h2 class="text-balance text-4xl font-black text-white md:text-6xl">
            See the pause happen before your eyes get tired.
          </h2>
        </div>
        <p class="max-w-2xl text-lg leading-8 text-slate-400 lg:justify-self-end">
          A quick look at how EyeBreak sits quietly in the background, then steps forward with a clear, calm reminder exactly when you need it.
        </p>
      </div>

      <div
        ref="videoContainerRef"
        class="relative mx-auto max-w-6xl transition-transform duration-700"
        :class="animateIn ? 'scale-100' : 'scale-[0.99]'"
      >
        <div class="absolute -inset-4 rounded-[2rem] bg-gradient-to-r from-cyan-300/15 via-fuchsia-300/15 to-lime-300/15 blur-3xl"></div>

        <div class="relative overflow-hidden rounded-lg border border-white/10 bg-slate-900/80 shadow-2xl shadow-black/50 backdrop-blur-2xl">
          <div class="flex items-center justify-between border-b border-white/10 bg-white/[0.04] px-4 py-3">
            <div class="flex gap-2">
              <span class="h-3 w-3 rounded-full bg-red-400"></span>
              <span class="h-3 w-3 rounded-full bg-amber-300"></span>
              <span class="h-3 w-3 rounded-full bg-lime-300"></span>
            </div>
            <div class="hidden rounded-full bg-white/5 px-3 py-1 text-xs font-medium text-slate-400 sm:block">
              EyeBreak product demo
            </div>
          </div>

          <div class="relative aspect-video bg-slate-950">
            <video
              ref="videoRef"
              class="h-full w-full cursor-pointer object-contain"
              controls
              muted
              playsinline
              preload="metadata"
              :poster="posterImage"
              @click="togglePlay"
            >
              <source :src="demoVideo" type="video/mp4">
              <source :src="demoVideo" type="video/quicktime">
              Your browser does not support the video tag.
            </video>

            <div
              v-if="videoError"
              class="absolute inset-0 z-20 grid place-items-center bg-slate-950/85 p-5 text-center backdrop-blur-sm"
            >
              <div class="max-w-sm">
                <div class="mx-auto mb-4 grid h-14 w-14 place-items-center rounded-full bg-cyan-300 text-slate-950">
                  <svg class="h-7 w-7" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M8 5v14l11-7z"/>
                  </svg>
                </div>
                <h3 class="text-xl font-black text-white">Demo video is not supported here</h3>
                <p class="mt-2 text-sm leading-6 text-slate-400">
                  Some mobile browsers refuse this QuickTime file. You can still open it directly.
                </p>
                <a
                  :href="demoVideo"
                  target="_blank"
                  class="mt-5 inline-flex rounded-full bg-cyan-300 px-5 py-3 font-black text-slate-950"
                >
                  Open demo video
                </a>
              </div>
            </div>

            <button
              v-if="!isPlaying && !videoError"
              @click="togglePlay"
              class="absolute inset-0 grid place-items-center bg-slate-950/25 backdrop-blur-[2px] transition-colors hover:bg-slate-950/35"
              aria-label="Play EyeBreak demo video"
            >
              <span class="grid place-items-center gap-4">
                <span class="relative grid h-24 w-24 place-items-center rounded-full bg-cyan-300 text-slate-950 shadow-2xl shadow-cyan-950/40 transition-transform hover:scale-105">
                  <span class="absolute inset-0 rounded-full bg-cyan-300 opacity-30 animate-ping"></span>
                  <svg class="relative z-10 ml-1 h-11 w-11" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M8 5v14l11-7z"/>
                  </svg>
                </span>
                <span class="rounded-full border border-white/10 bg-slate-950/80 px-4 py-2 text-sm font-bold text-white backdrop-blur-xl">
                  Play demo
                </span>
              </span>
            </button>
          </div>

          <div class="grid gap-4 border-t border-white/10 bg-slate-950/75 p-5 md:grid-cols-[1fr_auto] md:items-center">
            <div class="flex items-center gap-4">
              <div class="grid h-12 w-12 place-items-center rounded-lg bg-cyan-300 text-slate-950">
                <svg class="h-7 w-7" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5z"/>
                </svg>
              </div>
              <div>
                <h3 class="font-bold text-white">Full app walkthrough</h3>
                <p class="text-sm text-slate-400">Break overlay, water reminders, settings, and analytics.</p>
              </div>
            </div>

            <div class="flex flex-wrap gap-2">
              <span class="rounded-full border border-cyan-300/20 bg-cyan-300/10 px-3 py-1.5 text-sm font-semibold text-cyan-100">Break timer</span>
              <span class="rounded-full border border-lime-300/20 bg-lime-300/10 px-3 py-1.5 text-sm font-semibold text-lime-100">Hydration</span>
              <span class="rounded-full border border-fuchsia-300/20 bg-fuchsia-300/10 px-3 py-1.5 text-sm font-semibold text-fuchsia-100">Themes</span>
            </div>
          </div>
        </div>
      </div>

      <div class="mt-10 grid gap-5 md:grid-cols-3">
        <div
          v-for="(callout, index) in callouts"
          :key="callout.title"
          data-reveal
          class="rounded-lg border border-white/10 bg-white/[0.035] p-6 transition-all duration-300 hover:-translate-y-1 hover:border-cyan-300/30"
          :style="{ '--reveal-delay': `${index * 90}ms` }"
        >
          <div class="mb-5 grid h-12 w-12 place-items-center rounded-lg bg-white/10 text-cyan-100">
            <svg class="h-6 w-6" fill="currentColor" viewBox="0 0 24 24">
              <path :d="callout.iconPath" />
            </svg>
          </div>
          <h3 class="text-lg font-bold text-white">{{ callout.title }}</h3>
          <p class="mt-2 leading-7 text-slate-400">{{ callout.description }}</p>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
video::-webkit-media-controls-panel {
  background: linear-gradient(to bottom, rgba(2, 6, 23, 0.4), rgba(2, 6, 23, 0.88));
}
</style>
