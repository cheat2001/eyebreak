<script setup lang="ts">
interface Doc {
  title: string
  description: string
  iconPath: string
  link: string
  accent: string
}

interface ShortcutGroup {
  title: string
  shortcuts: Array<{ keys: string; description: string }>
}

const docs: Doc[] = [
  {
    title: 'Quick Start',
    description: 'Install, launch, and set your first break rhythm in minutes.',
    iconPath: 'M12 2L4.5 20.29l.71.71L12 18l6.79 3 .71-.71z',
    link: 'https://github.com/cheat2001/eyebreak/blob/main/QUICK_START.md',
    accent: 'bg-cyan-300 text-slate-950'
  },
  {
    title: 'User Guide',
    description: 'Every setting, reminder mode, and core workflow explained.',
    iconPath: 'M18 2H6c-1.1 0-2 .9-2 2v16c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zM6 4h5v8l-2.5-1.5L6 12V4z',
    link: 'https://github.com/cheat2001/eyebreak/blob/main/README.md',
    accent: 'bg-lime-300 text-slate-950'
  },
  {
    title: 'Water Reminder',
    description: 'Tune hydration nudges around your focus sessions.',
    iconPath: 'M12 2.69l5.66 5.66a8 8 0 1 1-11.31 0z',
    link: 'https://github.com/cheat2001/eyebreak/blob/main/docs/WATER_REMINDER_FEATURE.md',
    accent: 'bg-sky-300 text-slate-950'
  },
  {
    title: 'Themes',
    description: 'Customize colors, overlays, opacity, and visual effects.',
    iconPath: 'M12 22C6.49 22 2 17.51 2 12S6.49 2 12 2s10 4.04 10 9c0 3.31-2.69 6-6 6h-1.77c-.28 0-.5.22-.5.5 0 .12.05.23.13.33.41.47.64 1.06.64 1.67A2.5 2.5 0 0112 22z',
    link: 'https://github.com/cheat2001/eyebreak/blob/main/docs/FAQ.md',
    accent: 'bg-fuchsia-300 text-slate-950'
  },
  {
    title: 'Shortcuts',
    description: 'Move fast with global commands for breaks and reminders.',
    iconPath: 'M20 5H4c-1.1 0-1.99.9-1.99 2L2 17c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2zm-9 3h2v2h-2V8zm0 3h2v2h-2v-2z',
    link: 'https://github.com/cheat2001/eyebreak/blob/main/README.md#-keyboard-shortcuts',
    accent: 'bg-amber-300 text-slate-950'
  },
  {
    title: 'FAQ',
    description: 'Troubleshooting, macOS permissions, and common questions.',
    iconPath: 'M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 17h-2v-2h2v2zm2.07-7.75l-.9.92C13.45 12.9 13 13.5 13 15h-2v-.5c0-1.1.45-2.1 1.17-2.83l1.24-1.26c.37-.36.59-.86.59-1.41 0-1.1-.9-2-2-2s-2 .9-2 2H8c0-2.21 1.79-4 4-4s4 1.79 4 4c0 .88-.36 1.68-.93 2.25z',
    link: 'https://github.com/cheat2001/eyebreak/blob/main/docs/FAQ.md',
    accent: 'bg-slate-200 text-slate-950'
  }
]

const shortcuts: ShortcutGroup[] = [
  {
    title: 'Break Control',
    shortcuts: [
      { keys: 'Cmd Shift B', description: 'Take break now' },
      { keys: 'Cmd Shift S', description: 'Start timer' },
      { keys: 'Cmd Shift X', description: 'Stop timer' }
    ]
  },
  {
    title: 'Reminders',
    shortcuts: [
      { keys: 'Cmd Shift R', description: 'Show ambient reminder' },
      { keys: 'Cmd Shift W', description: 'Show water reminder' }
    ]
  },
  {
    title: 'Settings',
    shortcuts: [
      { keys: 'Cmd Shift O', description: 'Open settings' },
      { keys: 'Cmd ,', description: 'Preferences' }
    ]
  }
]
</script>

<template>
  <section id="documentation" class="relative overflow-hidden bg-slate-950 px-4 py-24">
    <div class="grid-paper absolute inset-0 opacity-30"></div>

    <div class="container relative z-10 mx-auto max-w-7xl">
      <div data-reveal class="mb-14 grid gap-8 lg:grid-cols-[0.85fr_1.15fr] lg:items-end">
        <div>
          <div class="mb-4 inline-flex items-center gap-2 rounded-full border border-cyan-300/20 bg-cyan-300/10 px-4 py-2 text-sm font-semibold text-cyan-100">
            <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">
              <path d="M18 2H6c-1.1 0-2 .9-2 2v16c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2z"/>
            </svg>
            Resource hub
          </div>
          <h2 class="text-balance text-4xl font-black text-white md:text-6xl">
            Everything you need, without digging around.
          </h2>
        </div>
        <p class="max-w-2xl text-lg leading-8 text-slate-400 lg:justify-self-end">
          Quick setup, feature guides, shortcuts, troubleshooting, and support links are gathered here for fast reference.
        </p>
      </div>

      <div class="grid gap-6 lg:grid-cols-[1fr_0.82fr]">
        <div class="grid gap-5 md:grid-cols-2">
          <a
            v-for="(doc, index) in docs"
            :key="doc.title"
            :href="doc.link"
            target="_blank"
            data-reveal
            class="group rounded-lg border border-white/10 bg-white/[0.035] p-6 transition-all duration-300 hover:-translate-y-1 hover:border-cyan-300/30 hover:bg-white/[0.06]"
            :style="{ '--reveal-delay': `${(index % 2) * 70}ms` }"
          >
            <div class="mb-6 flex items-center justify-between">
              <div class="grid h-12 w-12 place-items-center rounded-lg" :class="doc.accent">
                <svg class="h-6 w-6" fill="currentColor" viewBox="0 0 24 24">
                  <path :d="doc.iconPath" />
                </svg>
              </div>
              <span class="text-sm font-semibold text-slate-500 transition-transform group-hover:translate-x-1 group-hover:text-cyan-200">-></span>
            </div>
            <h3 class="text-xl font-bold text-white">{{ doc.title }}</h3>
            <p class="mt-2 leading-7 text-slate-400">{{ doc.description }}</p>
          </a>
        </div>

        <div data-reveal style="--reveal-delay: 120ms" class="space-y-6">
          <div class="rounded-lg border border-white/10 bg-slate-900/70 p-6 shadow-2xl shadow-black/30 backdrop-blur-2xl">
            <div class="mb-7 flex items-center gap-3">
              <div class="grid h-12 w-12 place-items-center rounded-lg bg-fuchsia-300 text-slate-950">
                <svg class="h-6 w-6" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M20 5H4c-1.1 0-1.99.9-1.99 2L2 17c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2z"/>
                </svg>
              </div>
              <div>
                <h3 class="text-2xl font-black text-white">Keyboard shortcuts</h3>
                <p class="text-sm text-slate-400">Fast controls for your flow.</p>
              </div>
            </div>

            <div class="space-y-7">
              <div v-for="group in shortcuts" :key="group.title">
                <h4 class="mb-3 text-sm font-bold uppercase tracking-[0.18em] text-slate-500">{{ group.title }}</h4>
                <div class="space-y-3">
                  <div
                    v-for="shortcut in group.shortcuts"
                    :key="shortcut.keys"
                    class="flex items-center justify-between gap-4 rounded-lg bg-slate-950/70 px-4 py-3"
                  >
                    <span class="text-sm text-slate-300">{{ shortcut.description }}</span>
                    <code class="rounded-md border border-white/10 bg-white/5 px-3 py-1.5 text-xs font-bold text-cyan-100">{{ shortcut.keys }}</code>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="rounded-lg border border-cyan-300/20 bg-cyan-300/10 p-6">
            <h3 class="text-2xl font-black text-white">Need help or want a feature?</h3>
            <p class="mt-3 leading-7 text-slate-300">
              Open an issue for bugs or start a discussion for ideas. EyeBreak is open source, so feedback can turn into the next useful release.
            </p>
            <div class="mt-6 flex flex-col gap-3 sm:flex-row">
              <a href="https://github.com/cheat2001/eyebreak/issues" target="_blank" class="btn-primary inline-flex items-center justify-center gap-2">
                Report issue
              </a>
              <a href="https://github.com/cheat2001/eyebreak/discussions" target="_blank" class="btn-secondary inline-flex items-center justify-center gap-2">
                Discussions
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
a {
  text-decoration: none;
}

code {
  font-family: Monaco, Menlo, 'Courier New', monospace;
}
</style>
