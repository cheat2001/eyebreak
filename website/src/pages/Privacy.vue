<script setup lang="ts">
import Footer from '../components/Footer.vue'

const sections = [
  {
    title: 'Overview',
    body: 'EyeBreak is a free, open-source macOS application designed to help you take regular breaks and maintain healthy screen time habits. We are committed to protecting your privacy and being transparent about our data practices.'
  },
  {
    title: 'Data Collection',
    body: 'EyeBreak does not collect, store, or transmit any personal data. The app operates entirely on your local machine.',
    items: ['No analytics or tracking', 'No user accounts or registration', 'No internet connection required', 'All settings stored locally on your device']
  },
  {
    title: 'Local Storage',
    body: 'EyeBreak stores your preferences and settings locally on your Mac using standard macOS UserDefaults. This data never leaves your device and is deleted when you uninstall the app.',
    items: ['Break timer preferences', 'Theme and customization choices', 'Schedule settings', 'Water reminder preferences', 'Launch at login preference']
  },
  {
    title: 'Permissions',
    body: 'EyeBreak requests macOS permissions only for app functionality, never for data collection.',
    items: ['Screen Recording: optional idle detection', 'Notifications: break and water reminders', 'Accessibility: overlay windows during breaks']
  },
  {
    title: 'Open Source',
    body: 'EyeBreak is open-source software. You can review the complete source code on GitHub to verify our privacy claims.'
  },
  {
    title: 'Third-Party Services',
    body: 'EyeBreak does not integrate with any third-party services, APIs, or external servers.'
  },
  {
    title: 'Updates',
    body: 'Check for updates manually through GitHub releases. The app does not automatically check for updates or send any data during updates.'
  },
  {
    title: 'Contact',
    body: 'If you have questions about this Privacy Policy, please open an issue on our GitHub repository.'
  }
]
</script>

<template>
  <div class="min-h-screen bg-slate-950">
    <main class="relative overflow-hidden px-4 pb-20 pt-32">
      <div class="absolute inset-0 aurora-mesh opacity-35"></div>
      <div class="absolute inset-0 bg-slate-950/78"></div>
      <div class="grid-paper absolute inset-0 opacity-25"></div>

      <div class="container relative z-10 mx-auto max-w-5xl">
        <header class="mb-14">
          <div class="mb-4 inline-flex items-center gap-2 rounded-full border border-lime-300/20 bg-lime-300/10 px-4 py-2 text-sm font-semibold text-lime-100">
            <span class="h-2 w-2 rounded-full bg-lime-300"></span>
            Privacy-first by design
          </div>
          <h1 class="text-balance text-4xl font-black text-white md:text-6xl">Privacy Policy</h1>
          <p class="mt-5 max-w-2xl text-lg leading-8 text-slate-400">Last updated: October 26, 2025</p>
        </header>

        <div class="mb-10 rounded-lg border border-cyan-300/20 bg-cyan-300/10 p-6">
          <h2 class="text-2xl font-black text-white">Short version</h2>
          <p class="mt-3 leading-8 text-slate-300">
            EyeBreak is completely private. We do not collect data, track you, or require an internet connection. Your settings stay on your Mac.
          </p>
        </div>

        <div class="grid gap-5 md:grid-cols-2">
          <section
            v-for="section in sections"
            :key="section.title"
            class="rounded-lg border border-white/10 bg-white/[0.04] p-6 shadow-xl shadow-black/10"
          >
            <h2 class="text-2xl font-black text-white">{{ section.title }}</h2>
            <p class="mt-3 leading-8 text-slate-300">{{ section.body }}</p>
            <ul v-if="section.items" class="mt-5 space-y-3">
              <li v-for="item in section.items" :key="item" class="flex items-start gap-3 text-slate-400">
                <span class="mt-2 h-1.5 w-1.5 flex-shrink-0 rounded-full bg-cyan-300"></span>
                <span>{{ item }}</span>
              </li>
            </ul>
          </section>
        </div>

        <div class="mt-10 rounded-lg border border-white/10 bg-slate-900/70 p-6 text-slate-300">
          Review the project on
          <a href="https://github.com/cheat2001/eyebreak" target="_blank" rel="noopener noreferrer" class="font-bold text-cyan-100 hover:text-cyan-200">
            GitHub
          </a>
          or open a
          <a href="https://github.com/cheat2001/eyebreak/issues" target="_blank" rel="noopener noreferrer" class="font-bold text-cyan-100 hover:text-cyan-200">
            privacy question
          </a>.
        </div>
      </div>
    </main>

    <Footer />
  </div>
</template>
