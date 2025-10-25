<script setup lang="ts">
interface Screenshot {
  title: string
  description: string
  image: string
  badge?: string
}

const screenshots: Screenshot[] = [
  {
    title: 'Clean Menu Bar Integration',
    description: 'Lightweight app that lives in your menu bar with quick access to all features',
    image: new URL('../assets/images/menu.png', import.meta.url).href,
    badge: 'Menu Bar'
  },
  {
    title: 'Beautiful Break Overlay',
    description: 'Full-screen blur with customizable themes and smooth animations',
    image: new URL('../assets/images/eyebreak.png', import.meta.url).href,
    badge: 'Break Screen'
  },
  {
    title: 'Water Reminder',
    description: 'Stay hydrated with smart reminders - blur screen or ambient pop-up styles',
    image: new URL('../assets/images/waterbreak.png', import.meta.url).href,
    badge: 'NEW in v2.1'
  },
  {
    title: 'Ambient Reminders',
    description: 'Gentle floating notifications with glass morphism effects',
    image: new URL('../assets/images/Ambient.png', import.meta.url).href,
    badge: 'Ambient'
  },
  {
    title: 'Comprehensive Settings',
    description: 'Customize every aspect: intervals, themes, sounds, and more',
    image: new URL('../assets/images/setting.png', import.meta.url).href,
    badge: 'Settings'
  },
  {
    title: 'Analytics Dashboard',
    description: 'Track your progress with beautiful charts and insights',
    image: new URL('../assets/images/Analytics.png', import.meta.url).href,
    badge: 'Statistics'
  }
]
</script>

<template>
  <section id="screenshots" class="py-24 px-4 bg-gradient-to-b from-gray-950 to-gray-900 relative">
    <div class="container mx-auto max-w-7xl">
      <!-- Section Header -->
      <div class="text-center mb-20">
        <div class="inline-flex items-center gap-3 mb-4">
          <svg class="w-10 h-10 text-purple-500" fill="currentColor" viewBox="0 0 24 24">
            <path d="M21 19V5c0-1.1-.9-2-2-2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2zM8.5 13.5l2.5 3.01L14.5 12l4.5 6H5l3.5-4.5z"/>
          </svg>
          <h2 class="section-title">See It In Action</h2>
        </div>
        <p class="section-subtitle">
          Beautiful, intuitive interface designed for macOS
        </p>
      </div>

      <!-- Screenshots Grid -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        <div
          v-for="(screenshot, index) in screenshots"
          :key="index"
          class="group relative overflow-hidden rounded-2xl hover:-translate-y-2 transition-all duration-300"
        >
          <!-- Badge -->
          <div 
            v-if="screenshot.badge"
            class="absolute top-6 right-6 z-10 px-4 py-2 bg-blue-600 text-white text-sm font-semibold rounded-full shadow-lg"
          >
            {{ screenshot.badge }}
          </div>

          <!-- Card -->
          <div class="card h-full p-0 overflow-hidden">
            <!-- Image -->
            <div class="aspect-video bg-gradient-to-br from-gray-800 to-gray-900 overflow-hidden group-hover:scale-105 transition-transform duration-500">
              <img 
                :src="screenshot.image" 
                :alt="screenshot.title"
                class="w-full h-full object-cover"
                loading="lazy"
              />
            </div>

            <!-- Content -->
            <div class="p-6">
              <h3 class="text-lg font-bold text-white mb-2 group-hover:text-blue-400 transition-colors">
                {{ screenshot.title }}
              </h3>
              <p class="text-gray-400 text-sm leading-relaxed">
                {{ screenshot.description }}
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
.group:hover .aspect-video {
  transform: scale(1.02);
  transition: transform 0.3s ease;
}
</style>
