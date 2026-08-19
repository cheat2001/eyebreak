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
    version: '2.4.1',
    date: 'August 19, 2026',
    title: 'Idle CPU Fix',
    badge: 'Latest',
    features: [
      {
        title: '🔋 Much lower CPU and battery use',
        items: [
          'Idle CPU use drops from about a third of a CPU core to under 2%',
          'The settings interface was being redrawn every second into a window nobody could see',
          'It is now only built while its window is actually on screen',
          'Reminder countdowns no longer publish updates when nothing has changed',
          'Affected v2.3.0 and earlier too, not just the previous release'
        ]
      }
    ]
  },
  {
    version: '2.4.0',
    date: 'August 18, 2026',
    title: 'Automatic Updates',
    features: [
      {
        title: '🔄 One-Click Automatic Updates',
        items: [
          'EyeBreak now checks for new versions and updates itself',
          'One click downloads, installs and reopens on the new version',
          'Every update is cryptographically signed and verified first',
          'Turn it off or check manually in Settings → About',
          'This is the last version you need to install by hand'
        ]
      },
      {
        title: '⏱️ Longer Breaks',
        items: [
          'Break duration can now be set up to 120 seconds, up from 60',
          'Default stays at 20 seconds and existing settings are unchanged',
          'Follows research suggesting breaks of 1–2 minutes are more effective'
        ]
      },
      {
        title: '⌨️ Keyboard Shortcut Permission',
        items: [
          'Detects when macOS resets the Accessibility permission after an update',
          'Offers to restore it instead of leaving shortcuts silently broken',
          'Timers and break reminders are unaffected either way'
        ]
      }
    ],
    bugFixes: [
      'Release builds now report the correct version number',
      'Fixed a code-signing problem that could prevent the app from launching',
      'Homebrew install instructions now point at a cask that actually exists'
    ]
  },
  {
    version: '2.3.0',
    date: 'December 6, 2025',
    title: 'Professional UI Polish Update',
    features: [
      {
        title: '📊 Menu Bar Timer Display',
        items: [
          'Live countdown visible directly in the menu bar',
          'Dynamic state icons (eye, filled eye, slashed eye, pause)',
          'Monospaced digits for clean, stable display',
          'Smart tooltips with detailed status information'
        ]
      },
      {
        title: '🪟 Enhanced Floating Break Window',
        items: [
          'Improved header icon badge with gradient and shadow',
          'Enhanced close button with visible border',
          'Skip button with stronger border and shadow',
          'Increased divider visibility for better section separation'
        ]
      },
      {
        title: '🎨 Polished Onboarding Experience',
        items: [
          'Gradient icon badges with blue-to-cyan styling',
          'Spring animations on feature items',
          'Dynamic color theming on permission cards',
          'Hover effects on action buttons'
        ]
      },
      {
        title: '⚙️ Refined Settings Views',
        items: [
          'Hidden scrollbar in About section for cleaner look',
          'Compact layout with optimized spacing',
          'New SectionHeaderView component for consistency',
          'Enhanced stat boxes with gradient backgrounds'
        ]
      },
      {
        title: '🧩 New Reusable Components',
        items: [
          'SectionHeaderView - Consistent section headers',
          'ProfessionalButtonStyle - Subtle press animations',
          'HoverEffectModifier - Unified hover behavior',
          'BreakStyleOptionCard - Selection highlighting',
          'EnhancedSliderCard - Timing controls with icons'
        ]
      }
    ],
    improvements: [
      'Linear and angular gradients throughout the UI',
      'Color-matched shadow and glow effects',
      'Spring animations with tuned damping',
      'Content transitions for numeric text changes',
      'Rounded design fonts for friendly appearance',
      'Consistent sizing hierarchy across all views'
    ]
  },
  {
    version: '2.2.0',
    date: 'November 13, 2025',
    title: 'Smart Pause & Unified Dashboard Update',
    features: [
      {
        title: '🔒 Automatic Screen Lock Pause',
        items: [
          'All timers automatically pause when Mac screen locks',
          'Smart resume with exact remaining time when unlocked',
          'Works with macOS sleep/wake and screen lock/unlock events',
          'No manual intervention needed - fully automatic',
          'Preserves timer progress across lock/unlock cycles',
          'Better battery life by pausing unnecessary timers'
        ]
      },
      {
        title: '⏱️ Unified Countdown Dashboard',
        items: [
          'All-in-one timer view in Settings → General tab',
          'Eye breaks, ambient reminders, and water reminders in one place',
          'Real-time countdown updates every second',
          'Visual status indicators (Green=Active, Orange=Paused, Gray=Disabled)',
          'Smart status messages showing current state',
          'Beautiful glass-morphism cards with gradients',
          'Color-coded by reminder type (Blue, Orange, Cyan)'
        ]
      },
      {
        title: '🎨 Enhanced Timer Management',
        items: [
          'Date-based countdown calculations for better accuracy',
          'Countdown displays even when paused',
          'Intelligent resume after screen unlock',
          'Improved UI update frequency'
        ]
      }
    ],
    improvements: [
      'Optimized countdown update frequency (1-second intervals)',
      'Reduced CPU usage during idle periods',
      'Better memory management with weak references',
      'Smoother UI animations and transitions',
      'More accurate date calculations'
    ],
    bugFixes: [
      'Fixed ambient reminder timer not showing accurate countdown',
      'Fixed water reminder timer displaying static intervals',
      'Fixed timers continuing to run when Mac screen is locked',
      'Fixed resume behavior after screen unlock not preserving state'
    ]
  },
  {
    version: '2.1.0',
    date: 'October 25, 2025',
    title: 'Health & Productivity Update',
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
  <div class="min-h-screen bg-slate-950">
    <section id="releases" class="relative overflow-hidden px-4 pb-20 pt-32">
      <div class="absolute inset-0 aurora-mesh opacity-35"></div>
      <div class="absolute inset-0 bg-slate-950/76"></div>
      <div class="grid-paper absolute inset-0 opacity-25"></div>

      <div class="container relative z-10 mx-auto max-w-6xl">
        <div class="mb-16 grid gap-8 lg:grid-cols-[0.82fr_1.18fr] lg:items-end">
          <div>
            <div class="mb-4 inline-flex items-center gap-2 rounded-full border border-lime-300/20 bg-lime-300/10 px-4 py-2 text-sm font-semibold text-lime-100">
              <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">
                <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
              </svg>
              Release history
            </div>
            <h1 class="text-balance text-4xl font-black text-white md:text-6xl">
              Every version, every healthier detail.
            </h1>
          </div>
          <p class="max-w-2xl text-lg leading-8 text-slate-400 lg:justify-self-end">
            EyeBreak keeps evolving with better reminders, cleaner controls, deeper privacy, and smoother macOS polish.
          </p>
        </div>

        <div class="relative">
          <div class="absolute bottom-0 left-4 top-0 hidden w-px bg-gradient-to-b from-cyan-300/50 via-fuchsia-300/20 to-transparent md:block"></div>

          <div class="space-y-8">
            <article
              v-for="(release, index) in releases"
              :key="release.version"
              class="relative md:pl-12"
            >
              <div class="absolute left-2 top-7 hidden h-5 w-5 rounded-full border-4 border-slate-950 bg-cyan-300 md:block"></div>

              <div class="rounded-lg border border-white/10 bg-white/[0.04] p-5 shadow-2xl shadow-black/20 backdrop-blur-2xl transition-all duration-300 hover:border-cyan-300/30 sm:p-8">
                <div class="mb-7 flex flex-wrap items-start justify-between gap-4">
                  <div class="min-w-0">
                    <div class="mb-3 flex flex-wrap items-center gap-3">
                      <h2 class="text-3xl font-black text-white">v{{ release.version }}</h2>
                      <span
                        v-if="release.badge"
                        class="rounded-full border px-3 py-1 text-sm font-bold"
                        :class="release.badge === 'Latest'
                          ? 'border-lime-300/20 bg-lime-300/10 text-lime-100'
                          : 'border-cyan-300/20 bg-cyan-300/10 text-cyan-100'"
                      >
                        {{ release.badge }}
                      </span>
                    </div>
                    <h3 class="text-xl font-bold text-slate-200">{{ release.title }}</h3>
                    <p class="mt-2 text-sm font-medium text-slate-500">{{ release.date }}</p>
                  </div>

                  <a
                    v-if="index === 0"
                    href="https://github.com/cheat2001/eyebreak/releases/latest"
                    target="_blank"
                    rel="noopener noreferrer"
                    class="btn-primary inline-flex items-center justify-center gap-2"
                  >
                    Download
                  </a>
                </div>

                <div class="grid gap-6 lg:grid-cols-2">
                  <div
                    v-for="feature in release.features"
                    :key="feature.title"
                    class="rounded-lg border border-white/10 bg-slate-950/45 p-5"
                  >
                    <h4 class="mb-4 font-bold text-white">{{ feature.title }}</h4>
                    <ul class="space-y-3">
                      <li
                        v-for="item in feature.items"
                        :key="item"
                        class="flex items-start gap-3 text-sm leading-6 text-slate-400"
                      >
                        <span class="mt-2 h-1.5 w-1.5 flex-shrink-0 rounded-full bg-cyan-300"></span>
                        <span>{{ item }}</span>
                      </li>
                    </ul>
                  </div>
                </div>

                <div v-if="release.improvements || release.bugFixes" class="mt-6 grid gap-5 lg:grid-cols-2">
                  <div v-if="release.improvements" class="rounded-lg border border-cyan-300/15 bg-cyan-300/5 p-5">
                    <h4 class="mb-3 font-bold text-cyan-100">Improvements</h4>
                    <ul class="space-y-2">
                      <li v-for="item in release.improvements" :key="item" class="text-sm leading-6 text-slate-400">
                        {{ item }}
                      </li>
                    </ul>
                  </div>

                  <div v-if="release.bugFixes" class="rounded-lg border border-amber-300/15 bg-amber-300/5 p-5">
                    <h4 class="mb-3 font-bold text-amber-100">Bug fixes</h4>
                    <ul class="space-y-2">
                      <li v-for="item in release.bugFixes" :key="item" class="text-sm leading-6 text-slate-400">
                        {{ item }}
                      </li>
                    </ul>
                  </div>
                </div>

                <div class="mt-6 border-t border-white/10 pt-6">
                  <a
                    :href="`https://github.com/cheat2001/eyebreak/releases/tag/v${release.version}`"
                    target="_blank"
                    rel="noopener noreferrer"
                    class="inline-flex items-center gap-2 text-sm font-bold text-cyan-100 transition-transform hover:translate-x-1"
                  >
                    View full release notes
                    <span aria-hidden="true">-></span>
                  </a>
                </div>
              </div>
            </article>
          </div>
        </div>

        <div class="mt-16 text-center">
          <button
            @click="scrollToTop"
            class="rounded-full border border-white/10 bg-white/5 px-6 py-3 font-bold text-white transition-colors hover:bg-white/10"
          >
            Back to top
          </button>
        </div>
      </div>
    </section>

    <Footer />
  </div>
</template>
