<script setup lang="ts">
interface InstallStep {
  number: number
  title: string
  description: string
  iconPath: string
}

const installSteps: InstallStep[] = [
  {
    number: 1,
    title: 'Download',
    description: 'Download the EyeBreak-v2.1.0.dmg file from GitHub releases',
    iconPath: 'M12 2a10 10 0 0110 10 10 10 0 01-10 10A10 10 0 012 12 10 10 0 0112 2m0 2a8 8 0 00-8 8 8 8 0 008 8 8 8 0 008-8 8 8 0 00-8-8m1 8v-4h-2v4H8l4 4 4-4h-3z'
  },
  {
    number: 2,
    title: 'Open DMG',
    description: 'Double-click the downloaded DMG file to mount it',
    iconPath: 'M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm0-12.5c-2.49 0-4.5 2.01-4.5 4.5s2.01 4.5 4.5 4.5 4.5-2.01 4.5-4.5-2.01-4.5-4.5-4.5zm0 7c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z'
  },
  {
    number: 3,
    title: 'Drag to Applications',
    description: 'Drag EyeBreak.app to your Applications folder',
    iconPath: 'M10 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2h-8l-2-2z'
  },
  {
    number: 4,
    title: 'Launch & Enjoy',
    description: 'Open EyeBreak from Applications and start your eye care routine!',
    iconPath: 'M12 2L4.5 7.5l1.5 1.5L10 6v14h4V6l4 3 1.5-1.5L12 2z'
  }
]

const downloadDMG = () => {
  window.open('https://github.com/cheat2001/eyebreak/releases/download/v2.1.0/EyeBreak-v2.1.0.dmg', '_blank')
}

const viewReleases = () => {
  window.open('https://github.com/cheat2001/eyebreak/releases', '_blank')
}
</script>

<template>
  <section id="installation" class="py-20 px-4 bg-gray-950 relative overflow-hidden">
    <!-- Background glow -->
    <div class="absolute top-0 left-1/2 w-96 h-96 bg-blue-600/5 rounded-full blur-3xl"></div>
    
    <div class="container mx-auto max-w-7xl relative z-10">
      <!-- Section Header -->
      <div class="text-center mb-16">
        <div class="inline-flex items-center gap-3 mb-4">
          <svg class="w-10 h-10 text-blue-500" fill="currentColor" viewBox="0 0 24 24">
            <path d="M13 2.05v2.02c3.95.49 7 3.85 7 7.93s-3.05 7.44-7 7.93v2.02c5.05-.5 9-4.76 9-9.95s-3.95-9.45-9-9.95zM12 19c-3.87 0-7-3.13-7-7s3.13-7 7-7 7 3.13 7 7-3.13 7-7 7z"/>
          </svg>
          <h2 class="section-title">Quick Installation</h2>
        </div>
        <p class="section-subtitle">
          Get started in less than 2 minutes
        </p>
      </div>

      <!-- Installation Steps -->
      <div class="max-w-6xl mx-auto mb-16">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
          <div
            v-for="step in installSteps"
            :key="step.number"
            class="relative group"
          >
            <!-- Step Number Circle with SVG Icon -->
            <div class="flex flex-col items-center text-center">
              <div class="w-24 h-24 rounded-full bg-gradient-to-br from-blue-600 to-blue-700 flex items-center justify-center mb-6 shadow-xl group-hover:scale-110 transition-transform duration-300 relative">
                <!-- Glow effect -->
                <div class="absolute inset-0 rounded-full bg-blue-500 blur-xl opacity-50 group-hover:opacity-75 transition-opacity"></div>
                <svg class="w-12 h-12 text-white relative z-10" fill="currentColor" viewBox="0 0 24 24">
                  <path :d="step.iconPath" />
                </svg>
              </div>
              
              <!-- Connecting line -->
              <div class="absolute top-12 left-1/2 w-full h-0.5 bg-gradient-to-r from-blue-600/50 to-blue-600/50 -z-10 hidden lg:block" v-if="step.number < 4"></div>
              
              <div class="mb-3">
                <span class="inline-block px-4 py-1.5 bg-blue-600/20 text-blue-400 rounded-full text-sm font-bold border border-blue-500/30">
                  Step {{ step.number }}
                </span>
              </div>
              
              <h3 class="text-xl font-bold text-white mb-3">
                {{ step.title }}
              </h3>
              
              <p class="text-gray-400 text-sm leading-relaxed">
                {{ step.description }}
              </p>
            </div>
          </div>
        </div>
      </div>

      <!-- Download Section -->
      <div class="max-w-2xl mx-auto">
        <div class="card bg-gray-900/50 border-2 border-blue-500/30 backdrop-blur-xl hover:border-blue-500/50 transition-all duration-300">
          <div class="text-center">
            <h3 class="text-2xl font-bold text-white mb-4">
              Ready to protect your eyes?
            </h3>
            <p class="text-gray-400 mb-6">
              Download EyeBreak v2.1.0 for macOS 14.0+
            </p>
            
            <!-- Download Button -->
            <div class="flex flex-col sm:flex-row gap-4 justify-center items-center">
              <button @click="downloadDMG" class="btn-primary">
                <span class="flex items-center gap-2">
                  <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z"/>
                  </svg>
                  <span>Download DMG (Universal)</span>
                </span>
              </button>
              <button @click="viewReleases" class="btn-secondary">
                <span class="flex items-center gap-2">
                  <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M20.5 11H19V7c0-1.1-.9-2-2-2h-4V3.5C13 2.12 11.88 1 10.5 1S8 2.12 8 3.5V5H4c-1.1 0-1.99.9-1.99 2v3.8H3.5c1.49 0 2.7 1.21 2.7 2.7s-1.21 2.7-2.7 2.7H2V20c0 1.1.9 2 2 2h3.8v-1.5c0-1.49 1.21-2.7 2.7-2.7 1.49 0 2.7 1.21 2.7 2.7V22H17c1.1 0 2-.9 2-2v-4h1.5c1.38 0 2.5-1.12 2.5-2.5S21.88 11 20.5 11z"/>
                  </svg>
                  <span>All Releases</span>
                </span>
              </button>
            </div>

            <!-- Requirements -->
            <div class="mt-8 pt-6 border-t border-gray-700/50">
              <h4 class="font-semibold text-white mb-4">System Requirements</h4>
              <div class="grid grid-cols-1 sm:grid-cols-3 gap-4 text-sm">
                <div class="flex items-center justify-center gap-2">
                  <svg class="w-5 h-5 text-blue-400" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M20 18c1.1 0 1.99-.9 1.99-2L22 6c0-1.1-.9-2-2-2H4c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2H0v2h24v-2h-4zM4 6h16v10H4V6z"/>
                  </svg>
                  <span class="text-gray-300">macOS 14.0+</span>
                </div>
                <div class="flex items-center justify-center gap-2">
                  <svg class="w-5 h-5 text-blue-400" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
                  </svg>
                  <span class="text-gray-300">Universal Binary</span>
                </div>
                <div class="flex items-center justify-center gap-2">
                  <svg class="w-5 h-5 text-blue-400" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M19.35 10.04C18.67 6.59 15.64 4 12 4c-1.48 0-2.85.43-4.01 1.17l1.46 1.46C10.21 6.23 11.08 6 12 6c3.04 0 5.5 2.46 5.5 5.5v.5H19c1.66 0 3 1.34 3 3 0 1.13-.64 2.11-1.56 2.62l1.45 1.45C23.16 18.16 24 16.68 24 15c0-2.64-2.05-4.78-4.65-4.96zM3 5.27l2.75 2.74C2.56 8.15 0 10.77 0 14c0 3.31 2.69 6 6 6h11.73l2 2L21 20.73 4.27 4 3 5.27zM7.73 10l8 8H6c-2.21 0-4-1.79-4-4s1.79-4 4-4h1.73z"/>
                  </svg>
                  <span class="text-gray-400">~10 MB</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Command Line Installation -->
        <div class="mt-8 card bg-gray-900/50 border border-gray-700/50 backdrop-blur-xl">
          <h4 class="font-semibold text-white mb-4 flex items-center gap-2">
            <svg class="w-5 h-5 text-blue-400" fill="currentColor" viewBox="0 0 24 24">
              <path d="M20 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm-9 3h2v2h-2V7zm0 4h2v2h-2v-2zM8 7h2v2H8V7zm0 4h2v2H8v-2zm-1 4l-1-1v-2H4v2l1 1-1 1v2h2v-2l1-1zm9 2h-6v-2h6v2zm4-4h-2v2h2v-2zm0-4h-2v2h2V7z"/>
            </svg>
            <span>Install via Command Line</span>
          </h4>
          <div class="bg-gray-950 rounded-lg p-4 font-mono text-sm text-green-400 overflow-x-auto border border-gray-800">
            <code>curl -L https://github.com/cheat2001/eyebreak/releases/download/v2.1.0/EyeBreak-v2.1.0.dmg -o ~/Downloads/EyeBreak.dmg</code>
          </div>
          <p class="text-gray-400 text-sm mt-3">
            Download directly to your Downloads folder using curl
          </p>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
code {
  font-family: 'Monaco', 'Menlo', 'Courier New', monospace;
}
</style>
