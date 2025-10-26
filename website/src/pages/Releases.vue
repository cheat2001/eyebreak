<script setup lang="ts">
import Footer from '../components/Footer.vue'

interface Release {
  version: string
  date: string
  title: string
  badge?: 'Latest' | 'New'
  features: {
    title: string
    items: string[]
  }[]
  improvements?: string[]
  bugFixes?: string[]
}

const releases: Release[] = [
  {
    version: '2.1.0',
    date: 'October 25, 2025',
    title: 'Health & Productivity Update',
    badge: 'Latest',
    features: [
      {
        title: '⏰ Smart Schedule System',
        items: [
          'Customizable work hours (e.g., 9 AM - 5 PM)',
          'Active days selection (Mon-Sun toggles)',
          '5 quick preset schedules for common work patterns',
          'Real-time status indicator (Active/Paused)',
          'Manual override with "Show Anyway" option',
          'Applies to all features: breaks, ambient, and water reminders'
        ]
      },
      {
        title: '🚀 Auto-Start Timer',
        items: [
          'Automatic timer start on app launch',
          'One-click toggle in General Settings',
          'Smart integration with Launch at Login',
          '0.5s initialization delay for smooth startup'
        ]
      },
      {
        title: '🚀 Launch at Login',
        items: [
          'SMAppService integration for modern macOS 13+',
          'One-click toggle in Settings',
          'Automatic startup when you log into your Mac',
          'Easy enable/disable control'
        ]
      },
      {
        title: '💧 Water Reminder System',
        items: [
          'Two display styles: Blur Screen and Ambient Pop-up',
          '8 preset hydration messages with custom message support',
          '16 professional water-themed SF Symbol icons',
          '5 flexible timing intervals (30min - 2 hours)',
          'Full theme integration (Default, Random, Custom)',
          'Keyboard shortcut: ⌘⇧W for manual trigger',
          'Sound effects with "Glass" tone'
        ]
      }
    ],
    improvements: [
      'Enhanced settings UI with Smart Schedule section',
      'Improved keyboard shortcut documentation',
      'Better work-life balance with schedule-aware reminders',
      'More intuitive General Settings layout',
      'Removed all debug console logs for better performance'
    ]
  },
  {
    version: '2.0.0',
    date: 'October 18, 2025',
    title: 'Theme Customization & Visual Overhaul',
    features: [
      {
        title: '🎨 Advanced Theme System',
        items: [
          'Default Theme - Classic vibrant style',
          'Random Color Theme - 20 curated color palettes',
          'Custom Theme - Full control over colors and effects',
          'Independent settings for breaks and ambient reminders',
          'Real-time preview in settings'
        ]
      },
      {
        title: '🎯 Professional Icon System',
        items: [
          '16 professional SF Symbol icons',
          'Icon picker replaces emoji input',
          'Consistent visual language',
          'Support for system accent colors'
        ]
      },
      {
        title: '👁️ Ambient Reminder Enhancements',
        items: [
          'Customizable duration (3-15 seconds)',
          'Frequency control (1-10 minutes)',
          'Custom messages with icon support',
          'Theme integration with blur and glow effects'
        ]
      }
    ],
    improvements: [
      'Completely redesigned settings UI',
      'Enhanced color picker with opacity controls',
      'Improved overlay rendering performance',
      'Better multi-monitor support'
    ]
  },
  {
    version: '1.0.0',
    date: 'October 5, 2025',
    title: 'Initial Release',
    features: [
      {
        title: '⏰ Core Timer System',
        items: [
          'Customizable work/break intervals',
          '20-20-20 rule implementation',
          'Pomodoro mode (25/5 cycles)',
          'Pre-break warnings',
          'Idle detection'
        ]
      },
      {
        title: '🌫️ Break Overlays',
        items: [
          'Screen blur during breaks',
          'Floating break window option',
          'Guided eye exercises',
          'Skip functionality (discouraged)'
        ]
      },
      {
        title: '📊 Statistics & Insights',
        items: [
          'Daily break tracking',
          'Streak counter',
          '7-day and 30-day charts',
          'Completion rate analytics'
        ]
      },
      {
        title: '🎵 Sound & Notifications',
        items: [
          'Optional break sound effects',
          'System notifications',
          'Pre-break warnings',
          'Break completion alerts'
        ]
      }
    ]
  }
]

function scrollToTop() {
  window.scrollTo({ top: 0, behavior: 'smooth' })
}
</script>

<template>
  <div class="releases-page">
    <section id="releases" class="py-24 px-4 bg-gray-950 relative overflow-hidden">
    <!-- Background effects -->
    <div class="absolute top-0 left-1/4 w-96 h-96 bg-blue-600/5 rounded-full blur-3xl"></div>
    <div class="absolute bottom-0 right-1/4 w-96 h-96 bg-purple-600/5 rounded-full blur-3xl"></div>
    
    <div class="container mx-auto max-w-6xl relative z-10">
      <!-- Section Header -->
      <div class="text-center mb-16">
        <div class="inline-flex items-center gap-3 mb-4">
          <svg class="w-10 h-10 text-blue-500" fill="currentColor" viewBox="0 0 24 24">
            <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
          </svg>
          <h2 class="section-title">Release History</h2>
        </div>
        <p class="section-subtitle">
          Track our journey of continuous improvement
        </p>
      </div>

      <!-- Timeline -->
      <div class="relative">
        <!-- Vertical line -->
        <div class="absolute left-8 top-0 bottom-0 w-0.5 bg-gradient-to-b from-blue-500/50 via-purple-500/50 to-transparent hidden md:block"></div>

        <!-- Releases -->
        <div class="space-y-12">
          <div
            v-for="(release, index) in releases"
            :key="release.version"
            class="relative"
          >
            <!-- Timeline dot -->
            <div class="absolute left-8 top-8 w-4 h-4 bg-blue-500 rounded-full border-4 border-gray-950 hidden md:block"></div>

            <!-- Release card -->
            <div class="md:ml-20 card hover:border-blue-500/30 transition-all duration-300">
              <!-- Header -->
              <div class="flex flex-wrap items-start justify-between gap-4 mb-6">
                <div>
                  <div class="flex items-center gap-3 mb-2">
                    <h3 class="text-3xl font-bold text-white">
                      v{{ release.version }}
                    </h3>
                    <span
                      v-if="release.badge"
                      class="px-3 py-1 rounded-full text-sm font-semibold"
                      :class="release.badge === 'Latest' 
                        ? 'bg-green-500/20 text-green-400 border border-green-500/30' 
                        : 'bg-blue-500/20 text-blue-400 border border-blue-500/30'"
                    >
                      {{ release.badge }}
                    </span>
                  </div>
                  <h4 class="text-xl text-gray-300 mb-1">{{ release.title }}</h4>
                  <p class="text-gray-500 flex items-center gap-2">
                    <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M19 4h-1V2h-2v2H8V2H6v2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 16H5V10h14v10zm0-12H5V6h14v2z"/>
                    </svg>
                    {{ release.date }}
                  </p>
                </div>
                
                <!-- Download button for latest -->
                <a
                  v-if="index === 0"
                  href="https://github.com/cheat2001/eyebreak/releases/latest"
                  target="_blank"
                  rel="noopener noreferrer"
                  class="btn-primary"
                >
                  <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M5 20h14v-2H5v2zM19 9h-4V3H9v6H5l7 7 7-7z"/>
                  </svg>
                  Download
                </a>
              </div>

              <!-- Features -->
              <div class="space-y-6">
                <div
                  v-for="feature in release.features"
                  :key="feature.title"
                  class="space-y-3"
                >
                  <h5 class="text-lg font-semibold text-white flex items-center gap-2">
                    {{ feature.title }}
                  </h5>
                  <ul class="space-y-2 ml-4">
                    <li
                      v-for="item in feature.items"
                      :key="item"
                      class="text-gray-400 flex items-start gap-3"
                    >
                      <svg class="w-5 h-5 text-green-500 mt-0.5 flex-shrink-0" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                      </svg>
                      <span>{{ item }}</span>
                    </li>
                  </ul>
                </div>

                <!-- Improvements -->
                <div v-if="release.improvements" class="pt-4 border-t border-gray-800">
                  <h5 class="text-lg font-semibold text-blue-400 mb-3">🔄 Improvements</h5>
                  <ul class="space-y-2 ml-4">
                    <li
                      v-for="item in release.improvements"
                      :key="item"
                      class="text-gray-400 flex items-start gap-3"
                    >
                      <svg class="w-5 h-5 text-blue-400 mt-0.5 flex-shrink-0" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
                      </svg>
                      <span>{{ item }}</span>
                    </li>
                  </ul>
                </div>

                <!-- Bug Fixes -->
                <div v-if="release.bugFixes" class="pt-4 border-t border-gray-800">
                  <h5 class="text-lg font-semibold text-yellow-400 mb-3">🐛 Bug Fixes</h5>
                  <ul class="space-y-2 ml-4">
                    <li
                      v-for="item in release.bugFixes"
                      :key="item"
                      class="text-gray-400 flex items-start gap-3"
                    >
                      <svg class="w-5 h-5 text-yellow-400 mt-0.5 flex-shrink-0" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M20 8h-2.81c-.45-.78-1.07-1.45-1.82-1.96L17 4.41 15.59 3l-2.17 2.17C12.96 5.06 12.49 5 12 5c-.49 0-.96.06-1.41.17L8.41 3 7 4.41l1.62 1.63C7.88 6.55 7.26 7.22 6.81 8H4v2h2.09c-.05.33-.09.66-.09 1v1H4v2h2v1c0 .34.04.67.09 1H4v2h2.81c1.04 1.79 2.97 3 5.19 3s4.15-1.21 5.19-3H20v-2h-2.09c.05-.33.09-.66.09-1v-1h2v-2h-2v-1c0-.34-.04-.67-.09-1H20V8zm-6 8h-4v-2h4v2zm0-4h-4v-2h4v2z"/>
                      </svg>
                      <span>{{ item }}</span>
                    </li>
                  </ul>
                </div>
              </div>

              <!-- View full notes -->
              <div class="mt-6 pt-6 border-t border-gray-800">
                <a
                  :href="`https://github.com/cheat2001/eyebreak/releases/tag/v${release.version}`"
                  target="_blank"
                  rel="noopener noreferrer"
                  class="text-blue-400 hover:text-blue-300 transition-colors inline-flex items-center gap-2"
                >
                  View full release notes
                  <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2v7zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3h-7z"/>
                  </svg>
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Back to top -->
      <div class="mt-16 text-center">
        <button
          @click="scrollToTop"
          class="inline-flex items-center gap-2 px-6 py-3 bg-gray-800 hover:bg-gray-700 text-white rounded-lg transition-colors"
        >
          <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
            <path d="M7 14l5-5 5 5z"/>
          </svg>
          Back to Top
        </button>
      </div>
    </div>
    </section>

    <Footer />
  </div>
</template>

<style scoped>
.section-title {
  @apply text-5xl font-bold bg-gradient-to-r from-blue-400 to-purple-400 bg-clip-text text-transparent;
}

.section-subtitle {
  @apply text-xl text-gray-400 max-w-2xl mx-auto;
}

.card {
  @apply bg-gradient-to-br from-gray-900/80 to-gray-800/50 border border-gray-800 rounded-2xl p-8 backdrop-blur-sm;
}

.btn-primary {
  @apply inline-flex items-center gap-2 px-6 py-3 bg-gradient-to-r from-blue-600 to-purple-600 text-white rounded-lg font-semibold hover:from-blue-700 hover:to-purple-700 transition-all duration-300 transform hover:scale-105 shadow-lg hover:shadow-blue-500/25;
}
</style>
