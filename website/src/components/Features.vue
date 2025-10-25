<script setup lang="ts">
interface Feature {
  iconPath: string
  title: string
  description: string
  color: string
}

const features: Feature[] = [
  {
    iconPath: 'M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z',
    title: '20-20-20 Rule',
    description: 'Follow the scientifically-backed eye care method: Every 20 minutes, look 20 feet away for 20 seconds.',
    color: 'from-blue-400 to-blue-600'
  },
  {
    iconPath: 'M12 2.69l5.66 5.66a8 8 0 1 1-11.31 0z',
    title: 'Water Reminders',
    description: 'Smart hydration reminders with blur screen or ambient pop-up styles to keep you refreshed.',
    color: 'from-cyan-400 to-cyan-600'
  },
  {
    iconPath: 'M12 2L4.5 20.29l.71.71L12 18l6.79 3 .71-.71z',
    title: 'Launch at Login',
    description: 'Automatically start EyeBreak when you log in. Never forget your eye care routine.',
    color: 'from-purple-400 to-purple-600'
  },
  {
    iconPath: 'M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zM12 20c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8zm.5-13H11v6l5.25 3.15.75-1.23-4.5-2.67z',
    title: 'Smart Timer System',
    description: 'Customizable work/break intervals with intelligent idle detection and automatic pausing.',
    color: 'from-orange-400 to-orange-600'
  },
  {
    iconPath: 'M12 22C6.49 22 2 17.51 2 12S6.49 2 12 2s10 4.04 10 9c0 3.31-2.69 6-6 6h-1.77c-.28 0-.5.22-.5.5 0 .12.05.23.13.33.41.47.64 1.06.64 1.67A2.5 2.5 0 0112 22zm0-18c-4.41 0-8 3.59-8 8s3.59 8 8 8c.28 0 .5-.22.5-.5a.54.54 0 00-.14-.35c-.41-.46-.63-1.05-.63-1.65a2.5 2.5 0 012.5-2.5H16c2.21 0 4-1.79 4-4 0-3.86-3.59-7-8-7z M6.5 11.5a1.5 1.5 0 110-3 1.5 1.5 0 010 3zm3-4a1.5 1.5 0 110-3 1.5 1.5 0 010 3zm5 0a1.5 1.5 0 110-3 1.5 1.5 0 010 3zm3 4a1.5 1.5 0 110-3 1.5 1.5 0 010 3z',
    title: 'Beautiful Themes',
    description: 'Customize colors with Default, Random, or Custom themes. Independent settings for each reminder type.',
    color: 'from-pink-400 to-pink-600'
  },
  {
    iconPath: 'M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm4 18H6V4h7v5h5v11zM8 15.01l1.41 1.41L11 14.84V19h2v-4.16l1.59 1.59L16 15.01 12.01 11z',
    title: 'Screen Blur',
    description: 'Gentle screen blur during breaks to help you actually rest your eyes.',
    color: 'from-indigo-400 to-indigo-600'
  },
  {
    iconPath: 'M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z',
    title: 'Analytics & Insights',
    description: 'Track your break history, streaks, and get personalized recommendations.',
    color: 'from-green-400 to-green-600'
  },
  {
    iconPath: 'M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2z',
    title: 'Privacy First',
    description: 'Zero data collection. Everything stays on your Mac. Works completely offline.',
    color: 'from-gray-400 to-gray-600'
  },
  {
    iconPath: 'M20 5H4c-1.1 0-1.99.9-1.99 2L2 17c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2zm-9 3h2v2h-2V8zm0 3h2v2h-2v-2zM8 8h2v2H8V8zm0 3h2v2H8v-2zm-1 2H5v-2h2v2zm0-3H5V8h2v2zm9 7H8v-2h8v2zm0-4h-2v-2h2v2zm0-3h-2V8h2v2zm3 3h-2v-2h2v2zm0-3h-2V8h2v2z',
    title: 'Keyboard Shortcuts',
    description: 'Quick access with shortcuts: ⌘⇧B for break, ⌘⇧W for water, ⌘⇧R for ambient reminder.',
    color: 'from-red-400 to-red-600'
  },
  {
    iconPath: 'M11 15h2v2h-2zm0-8h2v6h-2zm.99-5C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zM12 20c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8z M9 1h6v2H9z M9 21h6v2H9z',
    title: 'Pomodoro Mode',
    description: 'Built-in 25/5 work/break cycles for maximum productivity and focus.',
    color: 'from-yellow-400 to-yellow-600'
  },
  {
    iconPath: 'M12 22c1.1 0 2-.9 2-2h-4c0 1.1.89 2 2 2zm6-6v-5c0-3.07-1.64-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5s-1.5.67-1.5 1.5v.68C7.63 5.36 6 7.92 6 11v5l-2 2v1h16v-1l-2-2z',
    title: 'Pre-Break Warnings',
    description: '30-second notification before breaks start, so you can save your work.',
    color: 'from-teal-400 to-teal-600'
  },
  {
    iconPath: 'M20.5 6c-2.61.7-5.67 1-8.5 1s-5.89-.3-8.5-1L3 8c1.86.5 4 .83 6 1v13h2v-6h2v6h2V9c2-.17 4.14-.5 6-1l-.5-2zM12 6c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2z',
    title: 'Accessibility',
    description: 'Full VoiceOver, Dynamic Type, and Reduced Motion support for everyone.',
    color: 'from-lime-400 to-lime-600'
  }
]
</script>

<template>
  <section id="features" class="py-24 px-4 bg-gray-950 relative overflow-hidden">
    <!-- Background glow effects -->
    <div class="absolute top-0 left-1/3 w-96 h-96 bg-blue-600/5 rounded-full blur-3xl"></div>
    <div class="absolute bottom-0 right-1/3 w-96 h-96 bg-purple-600/5 rounded-full blur-3xl"></div>
    
    <div class="container mx-auto max-w-7xl relative z-10">
      <!-- Section Header -->
      <div class="text-center mb-20">
        <div class="inline-flex items-center gap-3 mb-4">
          <svg class="w-10 h-10 text-blue-500" fill="currentColor" viewBox="0 0 24 24">
            <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/>
          </svg>
          <h2 class="section-title">Powerful Features</h2>
        </div>
        <p class="section-subtitle">
          Everything you need for healthy screen time habits
        </p>
      </div>

      <!-- Features Grid -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <div
          v-for="(feature, index) in features"
          :key="index"
          class="group card hover:-translate-y-1"
        >
          <!-- Icon with Gradient Background -->
          <div class="mb-5">
            <div 
              class="w-16 h-16 rounded-2xl bg-gradient-to-br flex items-center justify-center shadow-lg group-hover:scale-110 transition-transform duration-300 relative"
              :class="feature.color"
            >
              <div class="absolute inset-0 rounded-2xl bg-white/10 group-hover:bg-white/20 transition-colors"></div>
              <svg class="w-8 h-8 text-white relative z-10" fill="currentColor" viewBox="0 0 24 24">
                <path :d="feature.iconPath" />
              </svg>
            </div>
          </div>

          <!-- Feature Title -->
          <h3 class="text-xl font-bold text-white mb-3 group-hover:text-blue-400 transition-colors">
            {{ feature.title }}
          </h3>

          <!-- Feature Description -->
          <p class="text-gray-400 leading-relaxed group-hover:text-gray-300 transition-colors">
            {{ feature.description }}
          </p>
        </div>
      </div>

      <!-- Additional Info -->
      <div class="mt-20 text-center">
        <div class="inline-flex items-center gap-3 px-8 py-4 bg-gradient-to-r from-green-600/20 to-blue-600/20 border border-green-500/30 rounded-full backdrop-blur-sm">
          <svg class="w-6 h-6 text-green-400" fill="currentColor" viewBox="0 0 24 24">
            <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
          </svg>
          <span class="text-white font-semibold text-lg">100% Free & Open Source</span>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
.card {
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}
</style>
