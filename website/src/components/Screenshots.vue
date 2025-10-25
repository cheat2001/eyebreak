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
    image: '/screenshots/menubar.png',
    badge: 'Menu Bar'
  },
  {
    title: 'Beautiful Break Overlay',
    description: 'Full-screen blur with customizable themes and smooth animations',
    image: '/screenshots/break-overlay.png',
    badge: 'Break Screen'
  },
  {
    title: 'Water Reminder',
    description: 'Stay hydrated with smart reminders - blur screen or ambient pop-up styles',
    image: '/screenshots/water-reminder.png',
    badge: 'NEW in v2.1'
  },
  {
    title: 'Ambient Reminders',
    description: 'Gentle floating notifications with glass morphism effects',
    image: '/screenshots/ambient.png',
    badge: 'Ambient'
  },
  {
    title: 'Comprehensive Settings',
    description: 'Customize every aspect: intervals, themes, sounds, and more',
    image: '/screenshots/settings.png',
    badge: 'Settings'
  },
  {
    title: 'Analytics Dashboard',
    description: 'Track your progress with beautiful charts and insights',
    image: '/screenshots/stats.png',
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
            <!-- Image Placeholder -->
            <div class="aspect-video bg-gradient-to-br from-gray-800 to-gray-900 flex items-center justify-center overflow-hidden group-hover:scale-105 transition-transform duration-500">
              <div class="text-center p-8">
                <div class="mb-4 flex justify-center">
                  <div class="w-16 h-16 bg-gradient-to-br from-purple-600 to-pink-600 rounded-2xl flex items-center justify-center group-hover:scale-110 transition-transform">
                    <svg class="w-10 h-10 text-white" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M21 19V5c0-1.1-.9-2-2-2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2zM8.5 13.5l2.5 3.01L14.5 12l4.5 6H5l3.5-4.5z"/>
                    </svg>
                  </div>
                </div>
                <p class="text-gray-400 font-medium">{{ screenshot.title }}</p>
              </div>
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

      <!-- Note -->
      <div class="mt-16 text-center">
        <div class="inline-flex items-center gap-3 px-6 py-3 bg-gray-800/50 border border-gray-700 rounded-xl backdrop-blur-sm">
          <svg class="w-5 h-5 text-yellow-400" fill="currentColor" viewBox="0 0 24 24">
            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/>
          </svg>
          <p class="text-gray-400 text-sm">
            <strong class="text-white">Note:</strong> Actual screenshots coming soon. The app is fully functional!
          </p>
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
