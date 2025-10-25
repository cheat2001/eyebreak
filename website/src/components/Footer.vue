<script setup lang="ts">
const currentYear = new Date().getFullYear()

interface Link {
  text: string
  href: string
}

const quickLinks: Link[] = [
  { text: 'Home', href: '#' },
  { text: 'Features', href: '#features' },
  { text: 'Screenshots', href: '#screenshots' },
  { text: 'Installation', href: '#installation' },
  { text: 'Documentation', href: '#documentation' }
]

const resources: Link[] = [
  { text: 'GitHub', href: 'https://github.com/cheat2001/eyebreak' },
  { text: 'Releases', href: 'https://github.com/cheat2001/eyebreak/releases' },
  { text: 'Issues', href: 'https://github.com/cheat2001/eyebreak/issues' },
  { text: 'Discussions', href: 'https://github.com/cheat2001/eyebreak/discussions' },
  { text: 'Contributing', href: 'https://github.com/cheat2001/eyebreak/blob/main/CONTRIBUTING.md' }
]

const docs: Link[] = [
  { text: 'Quick Start', href: 'https://github.com/cheat2001/eyebreak/blob/main/QUICK_START.md' },
  { text: 'README', href: 'https://github.com/cheat2001/eyebreak/blob/main/README.md' },
  { text: 'FAQ', href: 'https://github.com/cheat2001/eyebreak/blob/main/docs/FAQ.md' },
  { text: 'Water Reminder Guide', href: 'https://github.com/cheat2001/eyebreak/blob/main/docs/WATER_REMINDER_FEATURE.md' },
  { text: 'Release Notes', href: 'https://github.com/cheat2001/eyebreak/blob/main/docs/releases/RELEASE_NOTES_v2.1.0.md' }
]

const scrollToTop = () => {
  window.scrollTo({ top: 0, behavior: 'smooth' })
}
</script>

<template>
  <footer class="bg-gray-950 border-t border-gray-800/50 text-white py-16 px-4">
    <div class="container mx-auto max-w-7xl">
      <!-- Main Footer Content -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-12 mb-12">
        <!-- Brand Section -->
        <div>
          <div class="flex items-center gap-3 mb-6">
            <div class="w-12 h-12 bg-gradient-to-br from-blue-600 to-blue-700 rounded-xl flex items-center justify-center">
              <svg class="w-7 h-7 text-white" fill="currentColor" viewBox="0 0 24 24">
                <path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/>
              </svg>
            </div>
            <h3 class="text-2xl font-bold bg-gradient-to-r from-white to-gray-300 bg-clip-text text-transparent">EyeBreak</h3>
          </div>
          <p class="text-gray-400 mb-6 leading-relaxed">
            Your eyes deserve a break. A minimalistic macOS app for healthier screen time habits.
          </p>
          <div class="flex gap-4">
            <a
              href="https://github.com/cheat2001/eyebreak"
              target="_blank"
              class="group w-12 h-12 bg-gray-800/50 hover:bg-gray-700/50 border border-gray-700 hover:border-gray-600 rounded-xl flex items-center justify-center transition-all duration-300 hover:-translate-y-1"
            >
              <svg class="w-6 h-6 text-gray-400 group-hover:text-white transition-colors" fill="currentColor" viewBox="0 0 24 24">
                <path d="M12 0C5.37 0 0 5.37 0 12c0 5.31 3.435 9.795 8.205 11.385.6.105.825-.255.825-.57 0-.285-.015-1.23-.015-2.235-3.015.555-3.795-.735-4.035-1.41-.135-.345-.72-1.41-1.23-1.695-.42-.225-1.02-.78-.015-.795.945-.015 1.62.87 1.845 1.23 1.08 1.815 2.805 1.305 3.495.99.105-.78.42-1.305.765-1.605-2.67-.3-5.46-1.335-5.46-5.925 0-1.305.465-2.385 1.23-3.225-.12-.3-.54-1.53.12-3.18 0 0 1.005-.315 3.3 1.23.96-.27 1.98-.405 3-.405s2.04.135 3 .405c2.295-1.56 3.3-1.23 3.3-1.23.66 1.65.24 2.88.12 3.18.765.84 1.23 1.905 1.23 3.225 0 4.605-2.805 5.625-5.475 5.925.435.375.81 1.095.81 2.22 0 1.605-.015 2.895-.015 3.3 0 .315.225.69.825.57A12.02 12.02 0 0024 12c0-6.63-5.37-12-12-12z"/>
              </svg>
            </a>
          </div>
        </div>

        <!-- Quick Links -->
        <div>
          <h4 class="text-lg font-semibold mb-6 text-white">Quick Links</h4>
          <ul class="space-y-3">
            <li v-for="link in quickLinks" :key="link.text">
              <a
                :href="link.href"
                class="text-gray-400 hover:text-white transition-colors hover:translate-x-1 inline-block"
              >
                {{ link.text }}
              </a>
            </li>
          </ul>
        </div>

        <!-- Resources -->
        <div>
          <h4 class="text-lg font-semibold mb-6 text-white">Resources</h4>
          <ul class="space-y-3">
            <li v-for="link in resources" :key="link.text">
              <a
                :href="link.href"
                target="_blank"
                class="text-gray-400 hover:text-white transition-colors hover:translate-x-1 inline-block"
              >
                {{ link.text }}
              </a>
            </li>
          </ul>
        </div>

        <!-- Documentation -->
        <div>
          <h4 class="text-lg font-semibold mb-6 text-white">Documentation</h4>
          <ul class="space-y-3">
            <li v-for="link in docs" :key="link.text">
              <a
                :href="link.href"
                target="_blank"
                class="text-gray-400 hover:text-white transition-colors hover:translate-x-1 inline-block"
              >
                {{ link.text }}
              </a>
            </li>
          </ul>
        </div>
      </div>

      <!-- Divider -->
      <div class="border-t border-gray-800/50 my-12"></div>

      <!-- Bottom Footer -->
      <div class="flex flex-col md:flex-row justify-between items-center gap-6">
        <div class="text-gray-400 text-sm">
          <p>&copy; {{ currentYear }} EyeBreak. Released under the MIT License.</p>
        </div>

        <div class="flex items-center gap-6 text-sm text-gray-400">
          <a
            href="https://github.com/cheat2001/eyebreak/blob/main/LICENSE"
            target="_blank"
            class="hover:text-white transition-colors"
          >
            MIT License
          </a>
          <span>•</span>
          <button
            @click="scrollToTop"
            class="hover:text-white transition-colors flex items-center gap-2 group"
          >
            <span>Back to Top</span>
            <span class="group-hover:-translate-y-1 transition-transform">↑</span>
          </button>
        </div>
      </div>

      <!-- Version Badge -->
      <div class="mt-12 text-center">
        <span class="inline-block px-6 py-3 bg-gray-800/50 border border-gray-700 backdrop-blur-sm rounded-full text-sm text-gray-400">
          v2.1.0 • macOS 14.0+ • Universal Binary
        </span>
      </div>
    </div>
  </footer>
</template>

<style scoped>
a {
  text-decoration: none;
}
</style>
