<script setup lang="ts">
import { ref } from 'vue'

const copiedStates = ref<{ [key: string]: boolean }>({})
const activeTab = ref<'terminal' | 'manual'>('terminal')

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
  window.open('https://github.com/cheat2001/eyebreak/releases/download/v2.3.0/EyeBreak-v2.3.0.dmg', '_blank')
}

const curlCommand = 'curl -L https://github.com/cheat2001/eyebreak/releases/download/v2.3.0/EyeBreak-v2.3.0.dmg -o ~/Downloads/EyeBreak-v2.3.0.dmg && xattr -cr ~/Downloads/EyeBreak-v2.3.0.dmg && open ~/Downloads/EyeBreak-v2.3.0.dmg'
const xattrCommand = 'xattr -cr /Applications/EyeBreak.app'
</script>

<template>
  <section id="installation" class="py-24 px-4 bg-gray-950 relative overflow-hidden">
    <!-- Background elements -->
    <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[600px] h-[600px] bg-blue-600/5 rounded-full blur-3xl"></div>

    <div class="container mx-auto max-w-3xl relative z-10">
      <div class="text-center">
        <!-- Icon -->
        <div class="inline-flex items-center justify-center w-20 h-20 bg-gradient-to-br from-blue-600 to-blue-700 rounded-2xl mb-8 shadow-2xl shadow-blue-500/20">
          <svg class="w-10 h-10 text-white" fill="currentColor" viewBox="0 0 24 24">
            <path d="M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z"/>
          </svg>
        </div>

        <!-- Title -->
        <h2 class="text-3xl sm:text-4xl font-bold text-white mb-4">
          Download EyeBreak
        </h2>
        <p class="text-gray-400 text-lg mb-8">
          Free, open-source, and ready in seconds
        </p>

        <!-- Version & Requirements -->
        <div class="flex flex-wrap items-center justify-center gap-4 text-sm text-gray-400 mb-10">
          <span class="flex items-center gap-1.5">
            <span class="w-2 h-2 bg-green-500 rounded-full"></span>
            v2.3.0
          </span>
          <span class="text-gray-600">|</span>
          <span>macOS 14.0+</span>
          <span class="text-gray-600">|</span>
          <span>Universal Binary</span>
          <span class="text-gray-600">|</span>
          <span>~10 MB</span>
        </div>

        <!-- Installation Methods Tabs -->
        <div class="bg-gray-900/50 border border-gray-800 rounded-2xl overflow-hidden">
          <!-- Tab Headers -->
          <div class="grid grid-cols-2 border-b border-gray-800">
            <button
              @click="activeTab = 'terminal'"
              class="px-3 sm:px-6 py-3 sm:py-4 text-xs sm:text-sm font-medium transition-colors flex flex-col sm:flex-row items-center justify-center gap-1 sm:gap-2"
              :class="activeTab === 'terminal' ? 'bg-gray-800/50 text-white' : 'text-gray-400 hover:text-white'"
            >
              <svg class="w-5 h-5 flex-shrink-0" fill="currentColor" viewBox="0 0 24 24">
                <path d="M20 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm-9 3h2v2h-2V7zm0 4h2v2h-2v-2zM8 7h2v2H8V7zm0 4h2v2H8v-2zm-1 4l-1-1v-2H4v2l1 1-1 1v2h2v-2l1-1zm9 2h-6v-2h6v2zm4-4h-2v2h2v-2zm0-4h-2v2h2V7z"/>
              </svg>
              <span class="flex items-center gap-1">
                Terminal
                <span class="w-2 h-2 bg-green-500 rounded-full"></span>
              </span>
            </button>
            <button
              @click="activeTab = 'manual'"
              class="px-3 sm:px-6 py-3 sm:py-4 text-xs sm:text-sm font-medium transition-colors flex flex-col sm:flex-row items-center justify-center gap-1 sm:gap-2"
              :class="activeTab === 'manual' ? 'bg-gray-800/50 text-white' : 'text-gray-400 hover:text-white'"
            >
              <svg class="w-5 h-5 flex-shrink-0" fill="currentColor" viewBox="0 0 24 24">
                <path d="M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z"/>
              </svg>
              <span>Download</span>
            </button>
          </div>

          <!-- Tab Content -->
          <div class="p-6">
            <!-- Terminal Install Tab -->
            <div v-if="activeTab === 'terminal'" class="text-left">
              <p class="text-gray-300 mb-4">
                Paste this command in Terminal. It downloads, configures, and opens EyeBreak automatically:
              </p>
              <div class="relative group mb-4">
                <div class="bg-black rounded-lg p-4 pr-14 font-mono text-sm text-green-400 overflow-x-auto border border-gray-800">
                  <code class="break-all">{{ curlCommand }}</code>
                </div>
                <button
                  @click="copyToClipboard(curlCommand, 'curl')"
                  class="absolute right-3 top-1/2 -translate-y-1/2 p-2.5 bg-gray-800 hover:bg-gray-700 rounded-lg transition-colors"
                  :class="copiedStates['curl'] ? 'bg-green-600 hover:bg-green-600' : ''"
                >
                  <svg v-if="!copiedStates['curl']" class="w-5 h-5 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
                  </svg>
                  <svg v-else class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                  </svg>
                </button>
              </div>
              <div class="flex items-center gap-3 text-sm text-gray-400">
                <svg class="w-5 h-5 text-green-400" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
                </svg>
                <span>Then just drag to Applications and launch!</span>
              </div>
            </div>

            <!-- Manual Download Tab -->
            <div v-if="activeTab === 'manual'" class="text-left">
              <!-- Step 1: Download -->
              <div class="mb-6">
                <div class="flex items-center gap-3 mb-3">
                  <span class="w-7 h-7 bg-blue-600 rounded-full flex items-center justify-center text-white text-sm font-bold">1</span>
                  <span class="text-white font-medium">Download the DMG file</span>
                </div>
                <button
                  @click="downloadDMG"
                  class="w-full sm:w-auto inline-flex items-center justify-center gap-2 px-6 py-3 bg-blue-600 hover:bg-blue-500 text-white font-medium rounded-lg transition-colors"
                >
                  <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z"/>
                  </svg>
                  Download EyeBreak-v2.3.0.dmg
                </button>
              </div>

              <!-- Step 2: Install -->
              <div class="mb-6">
                <div class="flex items-center gap-3 mb-3">
                  <span class="w-7 h-7 bg-blue-600 rounded-full flex items-center justify-center text-white text-sm font-bold">2</span>
                  <span class="text-white font-medium">Open DMG and drag to Applications</span>
                </div>
                <p class="text-gray-400 text-sm ml-10">
                  Double-click the downloaded file and drag EyeBreak to your Applications folder.
                </p>
              </div>

              <!-- Step 3: Remove Quarantine -->
              <div class="mb-6">
                <div class="flex items-center gap-3 mb-3">
                  <span class="w-7 h-7 bg-amber-500 rounded-full flex items-center justify-center text-white text-sm font-bold">3</span>
                  <span class="text-white font-medium">Remove macOS quarantine</span>
                  <span class="px-2 py-0.5 bg-amber-500/20 text-amber-400 text-xs rounded-full">Required</span>
                </div>
                <p class="text-gray-400 text-sm ml-10 mb-3">
                  Open Terminal and run this command to allow the app to open:
                </p>
                <div class="relative group ml-10">
                  <div class="bg-black rounded-lg p-3 pr-14 font-mono text-sm text-amber-400 overflow-x-auto border border-gray-800">
                    <code>{{ xattrCommand }}</code>
                  </div>
                  <button
                    @click="copyToClipboard(xattrCommand, 'xattr')"
                    class="absolute right-2 top-1/2 -translate-y-1/2 p-2 bg-gray-800 hover:bg-gray-700 rounded-lg transition-colors"
                    :class="copiedStates['xattr'] ? 'bg-green-600 hover:bg-green-600' : ''"
                  >
                    <svg v-if="!copiedStates['xattr']" class="w-4 h-4 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
                    </svg>
                    <svg v-else class="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                    </svg>
                  </button>
                </div>
              </div>

              <!-- Step 4: Launch -->
              <div>
                <div class="flex items-center gap-3 mb-3">
                  <span class="w-7 h-7 bg-blue-600 rounded-full flex items-center justify-center text-white text-sm font-bold">4</span>
                  <span class="text-white font-medium">Launch EyeBreak</span>
                </div>
                <p class="text-gray-400 text-sm ml-10">
                  Open EyeBreak from your Applications folder and start protecting your eyes!
                </p>
              </div>
            </div>
          </div>
        </div>

        <!-- All Releases Link -->
        <a
          href="https://github.com/cheat2001/eyebreak/releases"
          target="_blank"
          class="inline-flex items-center gap-2 text-gray-400 hover:text-white text-sm transition-colors mt-6"
        >
          <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 24 24">
            <path d="M12 0C5.37 0 0 5.37 0 12c0 5.31 3.435 9.795 8.205 11.385.6.105.825-.255.825-.57 0-.285-.015-1.23-.015-2.235-3.015.555-3.795-.735-4.035-1.41-.135-.345-.72-1.41-1.23-1.695-.42-.225-1.02-.78-.015-.795.945-.015 1.62.87 1.845 1.23 1.08 1.815 2.805 1.305 3.495.99.105-.78.42-1.305.765-1.605-2.67-.3-5.46-1.335-5.46-5.925 0-1.305.465-2.385 1.23-3.225-.12-.3-.54-1.53.12-3.18 0 0 1.005-.315 3.3 1.23.96-.27 1.98-.405 3-.405s2.04.135 3 .405c2.295-1.56 3.3-1.23 3.3-1.23.66 1.65.24 2.88.12 3.18.765.84 1.23 1.905 1.23 3.225 0 4.605-2.805 5.625-5.475 5.925.435.375.81 1.095.81 2.22 0 1.605-.015 2.895-.015 3.3 0 .315.225.69.825.57A12.02 12.02 0 0024 12c0-6.63-5.37-12-12-12z"/>
          </svg>
          View all releases on GitHub
        </a>
      </div>
    </div>
  </section>
</template>

<style scoped>
code {
  font-family: 'Monaco', 'Menlo', 'Courier New', monospace;
}
</style>
