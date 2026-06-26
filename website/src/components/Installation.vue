<script setup lang="ts">
import { ref } from 'vue'
import { config } from '../config'

const copiedStates = ref<{ [key: string]: boolean }>({})
const activeTab = ref<'terminal' | 'manual'>('terminal')

const downloadUrl = 'https://github.com/cheat2001/eyebreak/releases/download/v2.3.0/EyeBreak-v2.3.0.dmg'
const curlCommand = `curl -L ${downloadUrl} -o ~/Downloads/EyeBreak-v2.3.0.dmg && xattr -cr ~/Downloads/EyeBreak-v2.3.0.dmg && open ~/Downloads/EyeBreak-v2.3.0.dmg`
const xattrCommand = 'xattr -cr /Applications/EyeBreak.app'

const installSteps = [
  'Download the DMG',
  'Drag EyeBreak to Applications',
  'Remove quarantine if macOS asks',
  'Launch from the menu bar'
]

const copyToClipboard = async (text: string, key: string) => {
  try {
    await navigator.clipboard.writeText(text)
    copiedStates.value[key] = true
    setTimeout(() => {
      copiedStates.value[key] = false
    }, 2000)
  } catch (err) {
    console.error('Failed to copy:', err)
  }
}

const downloadDMG = () => {
  window.open(downloadUrl, '_blank')
}
</script>

<template>
  <section id="installation" class="relative overflow-hidden bg-slate-950 px-4 py-20 sm:py-24">
    <div class="absolute inset-0 aurora-mesh opacity-45"></div>
    <div class="absolute inset-0 bg-slate-950/60"></div>

    <div class="container relative z-10 mx-auto grid max-w-7xl gap-10 lg:grid-cols-[0.82fr_1.18fr] lg:items-center">
      <div data-reveal class="min-w-0">
        <div class="mb-5 inline-flex items-center gap-2 rounded-full border border-lime-300/20 bg-lime-300/10 px-4 py-2 text-sm font-semibold text-lime-100">
          <span class="h-2 w-2 rounded-full bg-lime-300"></span>
          Ready in minutes
        </div>

        <h2 class="text-balance max-w-2xl break-words text-4xl font-black leading-[1.03] text-white sm:text-5xl lg:text-6xl">
          Download once. Let EyeBreak handle the rhythm.
        </h2>

        <p class="mt-6 max-w-xl text-base leading-8 text-slate-300 sm:text-lg">
          Free, open source, and built for macOS {{ config.requirements.macOSVersion }}. Install it, start the timer, and keep your screen habits healthier every day.
        </p>

        <div class="mt-8 grid w-full max-w-xl grid-cols-2 gap-3 xl:grid-cols-4">
          <div
            v-for="item in [
              { value: `v${config.app.version}`, label: 'version' },
              { value: 'macOS', label: config.requirements.macOSVersion },
              { value: '10 MB', label: 'download' },
              { value: 'MIT', label: 'license' }
            ]"
            :key="item.label"
            class="min-w-0 rounded-lg border border-white/10 bg-white/[0.05] p-4"
          >
            <div class="truncate text-lg font-black text-white">{{ item.value }}</div>
            <div class="mt-1 text-[0.65rem] font-semibold uppercase tracking-[0.16em] text-slate-500">{{ item.label }}</div>
          </div>
        </div>

        <div class="mt-8 space-y-3 pb-2">
          <div
            v-for="(step, index) in installSteps"
            :key="step"
            class="flex items-center gap-3 text-slate-300"
          >
            <span class="grid h-7 w-7 place-items-center rounded-full bg-cyan-300 text-sm font-black text-slate-950">{{ index + 1 }}</span>
            <span>{{ step }}</span>
          </div>
        </div>
      </div>

      <div data-reveal style="--reveal-delay: 120ms" class="min-w-0 rounded-lg border border-white/10 bg-slate-900/80 shadow-2xl shadow-black/40 backdrop-blur-2xl">
        <div class="grid grid-cols-2 border-b border-white/10 p-2">
          <button
            @click="activeTab = 'terminal'"
            class="rounded-lg px-4 py-3 text-sm font-bold transition-colors"
            :class="activeTab === 'terminal' ? 'bg-cyan-300 text-slate-950' : 'text-slate-400 hover:bg-white/5 hover:text-white'"
          >
            Terminal
          </button>
          <button
            @click="activeTab = 'manual'"
            class="rounded-lg px-4 py-3 text-sm font-bold transition-colors"
            :class="activeTab === 'manual' ? 'bg-cyan-300 text-slate-950' : 'text-slate-400 hover:bg-white/5 hover:text-white'"
          >
            Manual
          </button>
        </div>

        <div class="min-w-0 p-5 sm:p-7">
          <div v-if="activeTab === 'terminal'">
            <div class="mb-4 flex items-center justify-between gap-4">
              <div>
                <h3 class="text-xl font-black text-white">One command install</h3>
                <p class="mt-1 text-sm text-slate-400">Download, clear quarantine, and open the DMG.</p>
              </div>
              <button
                @click="copyToClipboard(curlCommand, 'curl')"
                class="grid h-11 w-11 place-items-center rounded-lg border border-white/10 bg-white/5 text-slate-300 transition-colors hover:bg-white/10 hover:text-white"
                :class="copiedStates['curl'] ? 'border-lime-300/30 bg-lime-300/15 text-lime-100' : ''"
                aria-label="Copy terminal command"
              >
                <svg v-if="!copiedStates['curl']" class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
                </svg>
                <svg v-else class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                </svg>
              </button>
            </div>

            <div class="min-w-0 overflow-hidden rounded-lg border border-white/10 bg-black">
              <div class="flex items-center gap-2 border-b border-white/10 px-4 py-3">
                <span class="h-3 w-3 rounded-full bg-red-400"></span>
                <span class="h-3 w-3 rounded-full bg-amber-300"></span>
                <span class="h-3 w-3 rounded-full bg-lime-300"></span>
                <span class="ml-2 text-xs font-medium text-slate-500">Terminal</span>
              </div>
              <pre class="max-w-full overflow-x-auto whitespace-pre-wrap break-all p-4 text-sm leading-7 text-lime-200"><code>{{ curlCommand }}</code></pre>
            </div>
          </div>

          <div v-else>
            <h3 class="text-xl font-black text-white">Manual download</h3>
            <p class="mt-1 text-sm text-slate-400">Use this if you prefer the normal DMG install flow.</p>

            <button
              @click="downloadDMG"
              class="mt-5 inline-flex w-full items-center justify-center gap-3 rounded-lg bg-cyan-300 px-6 py-4 font-black text-slate-950 transition-transform hover:-translate-y-0.5 sm:w-auto"
            >
              <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24">
                <path d="M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z"/>
              </svg>
              Download EyeBreak-v2.3.0.dmg
            </button>

            <div class="mt-7 rounded-lg border border-amber-300/20 bg-amber-300/10 p-4">
              <div class="flex items-start gap-3">
                <div class="mt-1 h-2.5 w-2.5 rounded-full bg-amber-300"></div>
                <div>
                  <h4 class="font-bold text-amber-100">macOS quarantine command</h4>
                  <p class="mt-1 text-sm text-slate-300">Run this only if macOS blocks the app after installation.</p>
                </div>
              </div>
              <div class="mt-4 flex gap-3">
                <code class="min-w-0 flex-1 overflow-x-auto break-all rounded-lg bg-black px-4 py-3 text-sm text-amber-200">{{ xattrCommand }}</code>
                <button
                  @click="copyToClipboard(xattrCommand, 'xattr')"
                  class="grid h-12 w-12 flex-shrink-0 place-items-center rounded-lg bg-white/10 text-white transition-colors hover:bg-white/15"
                  aria-label="Copy quarantine command"
                >
                  <svg v-if="!copiedStates['xattr']" class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
                  </svg>
                  <svg v-else class="h-5 w-5 text-lime-200" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                  </svg>
                </button>
              </div>
            </div>
          </div>

          <a
            href="https://github.com/cheat2001/eyebreak/releases"
            target="_blank"
            class="mt-6 inline-flex items-center gap-2 text-sm font-semibold text-slate-400 transition-colors hover:text-white"
          >
            View all releases
            <span aria-hidden="true">-></span>
          </a>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
code,
pre {
  font-family: Monaco, Menlo, 'Courier New', monospace;
}
</style>
