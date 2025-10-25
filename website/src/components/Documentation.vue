<script setup lang="ts">
interface Doc {
  title: string
  description: string
  iconPath: string
  link: string
}

const docs: Doc[] = [
  {
    title: 'Quick Start Guide',
    description: 'Get up and running with EyeBreak in minutes',
    iconPath: 'M12 2L4.5 20.29l.71.71L12 18l6.79 3 .71-.71z',
    link: 'https://github.com/cheat2001/eyebreak/blob/main/QUICK_START.md'
  },
  {
    title: 'User Guide',
    description: 'Comprehensive documentation for all features',
    iconPath: 'M18 2H6c-1.1 0-2 .9-2 2v16c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zM6 4h5v8l-2.5-1.5L6 12V4z',
    link: 'https://github.com/cheat2001/eyebreak/blob/main/README.md'
  },
  {
    title: 'Water Reminder Guide',
    description: 'Learn how to use the hydration reminder feature',
    iconPath: 'M12 2.69l5.66 5.66a8 8 0 1 1-11.31 0z',
    link: 'https://github.com/cheat2001/eyebreak/blob/main/docs/WATER_REMINDER_FEATURE.md'
  },
  {
    title: 'Theme Customization',
    description: 'Customize colors, opacity, and visual effects',
    iconPath: 'M12 22C6.49 22 2 17.51 2 12S6.49 2 12 2s10 4.04 10 9c0 3.31-2.69 6-6 6h-1.77c-.28 0-.5.22-.5.5 0 .12.05.23.13.33.41.47.64 1.06.64 1.67A2.5 2.5 0 0112 22zm0-18c-4.41 0-8 3.59-8 8s3.59 8 8 8c.28 0 .5-.22.5-.5a.54.54 0 00-.14-.35c-.41-.46-.63-1.05-.63-1.65a2.5 2.5 0 012.5-2.5H16c2.21 0 4-1.79 4-4 0-3.86-3.59-7-8-7z M6.5 11.5a1.5 1.5 0 110-3 1.5 1.5 0 010 3zm3-4a1.5 1.5 0 110-3 1.5 1.5 0 010 3zm5 0a1.5 1.5 0 110-3 1.5 1.5 0 010 3zm3 4a1.5 1.5 0 110-3 1.5 1.5 0 010 3z',
    link: 'https://github.com/cheat2001/eyebreak/blob/main/docs/FAQ.md'
  },
  {
    title: 'Keyboard Shortcuts',
    description: 'Master all keyboard shortcuts for quick access',
    iconPath: 'M20 5H4c-1.1 0-1.99.9-1.99 2L2 17c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2zm-9 3h2v2h-2V8zm0 3h2v2h-2v-2zM8 8h2v2H8V8zm0 3h2v2H8v-2zm-1 2H5v-2h2v2zm0-3H5V8h2v2zm9 7H8v-2h8v2zm0-4h-2v-2h2v2zm0-3h-2V8h2v2zm3 3h-2v-2h2v2zm0-3h-2V8h2v2z',
    link: 'https://github.com/cheat2001/eyebreak/blob/main/README.md#-keyboard-shortcuts'
  },
  {
    title: 'Troubleshooting & FAQ',
    description: 'Common issues and their solutions',
    iconPath: 'M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 17h-2v-2h2v2zm2.07-7.75l-.9.92C13.45 12.9 13 13.5 13 15h-2v-.5c0-1.1.45-2.1 1.17-2.83l1.24-1.26c.37-.36.59-.86.59-1.41 0-1.1-.9-2-2-2s-2 .9-2 2H8c0-2.21 1.79-4 4-4s4 1.79 4 4c0 .88-.36 1.68-.93 2.25z',
    link: 'https://github.com/cheat2001/eyebreak/blob/main/docs/FAQ.md'
  }
]

interface ShortcutGroup {
  title: string
  shortcuts: Array<{ keys: string; description: string }>
}

const shortcuts: ShortcutGroup[] = [
  {
    title: 'Break Control',
    shortcuts: [
      { keys: '⌘ ⇧ B', description: 'Take break now' },
      { keys: '⌘ ⇧ S', description: 'Start timer' },
      { keys: '⌘ ⇧ X', description: 'Stop timer' }
    ]
  },
  {
    title: 'Reminders',
    shortcuts: [
      { keys: '⌘ ⇧ R', description: 'Show ambient reminder' },
      { keys: '⌘ ⇧ W', description: 'Show water reminder' }
    ]
  },
  {
    title: 'Settings',
    shortcuts: [
      { keys: '⌘ ⇧ O', description: 'Open settings' },
      { keys: '⌘ ,', description: 'Preferences' }
    ]
  }
]
</script>

<template>
  <section id="documentation" class="py-24 px-4 bg-gray-950 relative overflow-hidden">
    <!-- Background effects -->
    <div class="absolute top-1/4 right-1/4 w-96 h-96 bg-purple-600/5 rounded-full blur-3xl"></div>
    
    <div class="container mx-auto max-w-7xl relative z-10">
      <!-- Section Header -->
      <div class="text-center mb-20">
        <div class="inline-flex items-center gap-3 mb-4">
          <svg class="w-10 h-10 text-blue-500" fill="currentColor" viewBox="0 0 24 24">
            <path d="M18 2H6c-1.1 0-2 .9-2 2v16c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zM6 4h5v8l-2.5-1.5L6 12V4z"/>
          </svg>
          <h2 class="section-title">Documentation & Help</h2>
        </div>
        <p class="section-subtitle">
          Everything you need to make the most of EyeBreak
        </p>
      </div>

      <!-- Documentation Links -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-20">
        <a
          v-for="(doc, index) in docs"
          :key="index"
          :href="doc.link"
          target="_blank"
          class="card hover:-translate-y-1 border-2 cursor-pointer group"
        >
          <div class="flex items-start gap-4">
            <div class="flex-shrink-0">
              <div class="w-12 h-12 bg-gradient-to-br from-blue-500 to-purple-600 rounded-xl flex items-center justify-center group-hover:scale-110 transition-transform">
                <svg class="w-6 h-6 text-white" fill="currentColor" viewBox="0 0 24 24">
                  <path :d="doc.iconPath" />
                </svg>
              </div>
            </div>
            <div class="flex-1">
              <h3 class="text-lg font-bold text-white mb-2 group-hover:text-blue-400 transition-colors">
                {{ doc.title }}
              </h3>
              <p class="text-gray-400 text-sm group-hover:text-gray-300 transition-colors">{{ doc.description }}</p>
            </div>
            <div class="text-blue-500 opacity-0 group-hover:opacity-100 transition-opacity text-xl">
              →
            </div>
          </div>
        </a>
      </div>

      <!-- Keyboard Shortcuts Reference -->
      <div class="max-w-5xl mx-auto">
        <div class="card bg-gradient-to-br from-gray-900/50 to-gray-800/50">
          <h3 class="text-3xl font-bold text-white mb-8 flex items-center gap-3">
            <svg class="w-8 h-8 text-purple-500" fill="currentColor" viewBox="0 0 24 24">
              <path d="M20 5H4c-1.1 0-1.99.9-1.99 2L2 17c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2zm-9 3h2v2h-2V8zm0 3h2v2h-2v-2zM8 8h2v2H8V8zm0 3h2v2H8v-2zm-1 2H5v-2h2v2zm0-3H5V8h2v2zm9 7H8v-2h8v2zm0-4h-2v-2h2v2zm0-3h-2V8h2v2zm3 3h-2v-2h2v2zm0-3h-2V8h2v2z"/>
            </svg>
            <span>Keyboard Shortcuts</span>
          </h3>
          
          <div class="grid grid-cols-1 md:grid-cols-3 gap-10">
            <div
              v-for="(group, index) in shortcuts"
              :key="index"
            >
              <h4 class="font-semibold text-white mb-4 text-lg">{{ group.title }}</h4>
              <div class="space-y-4">
                <div
                  v-for="(shortcut, idx) in group.shortcuts"
                  :key="idx"
                  class="flex items-center justify-between gap-4 group"
                >
                  <span class="text-sm text-gray-400 group-hover:text-gray-300 transition-colors">{{ shortcut.description }}</span>
                  <code class="px-4 py-2 bg-gray-800 border border-gray-700 rounded-lg text-sm font-mono text-blue-400 whitespace-nowrap">
                    {{ shortcut.keys }}
                  </code>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Support Section -->
      <div class="mt-16 text-center">
        <div class="card max-w-3xl mx-auto bg-gradient-to-br from-blue-900/20 to-purple-900/20 border-blue-500/30">
          <h3 class="text-2xl font-bold text-white mb-4">Need Help?</h3>
          <p class="text-gray-400 mb-8 text-lg">
            Found a bug or have a feature request? We're here to help!
          </p>
          <div class="flex flex-col sm:flex-row gap-4 justify-center">
            <a
              href="https://github.com/cheat2001/eyebreak/issues"
              target="_blank"
              class="btn-primary"
            >
              <span class="flex items-center gap-2">
                <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M20 8h-2.81c-.45-.78-1.07-1.45-1.82-1.96L17 4.41 15.59 3l-2.17 2.17C12.96 5.06 12.49 5 12 5c-.49 0-.96.06-1.41.17L8.41 3 7 4.41l1.62 1.63C7.88 6.55 7.26 7.22 6.81 8H4v2h2.09c-.05.33-.09.66-.09 1v1H4v2h2v1c0 .34.04.67.09 1H4v2h2.81c1.04 1.79 2.97 3 5.19 3s4.15-1.21 5.19-3H20v-2h-2.09c.05-.33.09-.66.09-1v-1h2v-2h-2v-1c0-.34-.04-.67-.09-1H20V8zm-6 8h-4v-2h4v2zm0-4h-4v-2h4v2z"/>
                </svg>
                <span>Report Issue</span>
              </span>
            </a>
            <a
              href="https://github.com/cheat2001/eyebreak/discussions"
              target="_blank"
              class="btn-secondary"
            >
              <span class="flex items-center gap-2">
                <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm0 14H6l-2 2V4h16v12z"/>
                </svg>
                <span>Discussions</span>
              </span>
            </a>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
code {
  font-family: 'Monaco', 'Menlo', 'Courier New', monospace;
}

a.card {
  text-decoration: none;
}
</style>
