<script setup lang="ts">
import { useRouter } from 'vue-router'

const router = useRouter()

const goHome = () => {
  router.push('/')
}

const goBack = () => {
  router.back()
}
</script>

<template>
  <div class="relative flex min-h-screen items-center justify-center overflow-hidden bg-slate-950 px-4 py-28">
    <div class="absolute inset-0 aurora-mesh opacity-45"></div>
    <div class="absolute inset-0 bg-slate-950/72"></div>
    <div class="grid-paper absolute inset-0 opacity-35"></div>

    <div class="relative z-10 mx-auto max-w-3xl text-center">
      <div class="mx-auto mb-8 grid h-24 w-24 place-items-center rounded-full bg-cyan-300 text-slate-950 shadow-2xl shadow-cyan-950/40 breath-motion">
        <svg class="h-12 w-12" fill="currentColor" viewBox="0 0 24 24">
          <path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5z"/>
        </svg>
      </div>

      <p class="mb-4 text-sm font-black uppercase tracking-[0.28em] text-cyan-100">404</p>
      <h1 class="text-balance text-5xl font-black text-white md:text-7xl">This page took a break.</h1>
      <p class="mx-auto mt-6 max-w-2xl text-lg leading-8 text-slate-400">
        The route you opened does not exist or has moved. Let us bring you back to the app story.
      </p>

      <div class="mt-10 flex flex-col justify-center gap-4 sm:flex-row">
        <button @click="goHome" class="btn-primary inline-flex items-center justify-center gap-2">
          Back to home
        </button>
        <button @click="goBack" class="btn-secondary inline-flex items-center justify-center gap-2">
          Go back
        </button>
      </div>

      <div class="mt-12 flex flex-wrap justify-center gap-4 text-sm font-semibold text-slate-400">
        <button @click="router.push('/releases')" class="hover:text-white">Releases</button>
        <span class="text-slate-700">/</span>
        <button @click="router.push('/blog')" class="hover:text-white">Blog</button>
        <span class="text-slate-700">/</span>
        <button @click="router.push('/privacy')" class="hover:text-white">Privacy</button>
        <span class="text-slate-700">/</span>
        <a href="https://github.com/cheat2001/eyebreak" target="_blank" rel="noopener noreferrer" class="hover:text-white">GitHub</a>
      </div>
    </div>
  </div>
</template>
