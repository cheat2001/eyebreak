<script setup lang="ts">
import Footer from '../components/Footer.vue'
</script>

<template>
  <div class="privacy-page bg-gray-950">
    <div class="container mx-auto max-w-4xl px-4 py-24">
      <div class="prose prose-invert max-w-none">
        <h1 class="text-5xl font-bold mb-8 bg-gradient-to-r from-blue-400 to-purple-400 bg-clip-text text-transparent">
          Privacy Policy
        </h1>
        
        <p class="text-xl text-gray-400 mb-12">
          Last updated: October 26, 2025
        </p>

        <div class="space-y-8 text-gray-300">
          <section>
            <h2 class="text-3xl font-bold text-white mb-4">Overview</h2>
            <p class="leading-relaxed">
              EyeBreak is a free, open-source macOS application designed to help you take regular breaks and maintain healthy screen time habits. We are committed to protecting your privacy and being transparent about our data practices.
            </p>
          </section>

          <section>
            <h2 class="text-3xl font-bold text-white mb-4">Data Collection</h2>
            <p class="leading-relaxed mb-4">
              <strong class="text-white">EyeBreak does NOT collect, store, or transmit any personal data.</strong> The app operates entirely on your local machine.
            </p>
            <ul class="list-disc list-inside space-y-2 ml-4">
              <li>No analytics or tracking</li>
              <li>No user accounts or registration</li>
              <li>No internet connection required</li>
              <li>All settings stored locally on your device</li>
            </ul>
          </section>

          <section>
            <h2 class="text-3xl font-bold text-white mb-4">Local Storage</h2>
            <p class="leading-relaxed">
              EyeBreak stores your preferences and settings locally on your Mac using standard macOS UserDefaults. This includes:
            </p>
            <ul class="list-disc list-inside space-y-2 ml-4">
              <li>Break timer preferences (interval, duration)</li>
              <li>Theme and customization choices</li>
              <li>Schedule settings (work hours, active days)</li>
              <li>Water reminder preferences</li>
              <li>Launch at login preference</li>
            </ul>
            <p class="leading-relaxed mt-4">
              This data never leaves your device and is deleted when you uninstall the app.
            </p>
          </section>

          <section>
            <h2 class="text-3xl font-bold text-white mb-4">Permissions</h2>
            <p class="leading-relaxed mb-4">
              EyeBreak requests the following macOS permissions:
            </p>
            <ul class="list-disc list-inside space-y-2 ml-4">
              <li><strong class="text-white">Screen Recording:</strong> Only used to detect user activity (optional idle detection feature)</li>
              <li><strong class="text-white">Notifications:</strong> To send break and water reminders</li>
              <li><strong class="text-white">Accessibility:</strong> To show overlay windows during breaks</li>
            </ul>
            <p class="leading-relaxed mt-4">
              These permissions are only used for the app's core functionality and never for data collection.
            </p>
          </section>

          <section>
            <h2 class="text-3xl font-bold text-white mb-4">Open Source</h2>
            <p class="leading-relaxed">
              EyeBreak is open-source software. You can review the complete source code on 
              <a href="https://github.com/cheat2001/eyebreak" target="_blank" class="text-blue-400 hover:text-blue-300 underline">
                GitHub
              </a> to verify our privacy claims.
            </p>
          </section>

          <section>
            <h2 class="text-3xl font-bold text-white mb-4">Third-Party Services</h2>
            <p class="leading-relaxed">
              EyeBreak does not integrate with any third-party services, APIs, or external servers.
            </p>
          </section>

          <section>
            <h2 class="text-3xl font-bold text-white mb-4">Updates</h2>
            <p class="leading-relaxed">
              Check for updates manually through GitHub releases. The app does not automatically check for updates or send any data during updates.
            </p>
          </section>

          <section>
            <h2 class="text-3xl font-bold text-white mb-4">Contact</h2>
            <p class="leading-relaxed">
              If you have questions about this Privacy Policy, please open an issue on our 
              <a href="https://github.com/cheat2001/eyebreak/issues" target="_blank" class="text-blue-400 hover:text-blue-300 underline">
                GitHub repository
              </a>.
            </p>
          </section>

          <section>
            <h2 class="text-3xl font-bold text-white mb-4">Changes to This Policy</h2>
            <p class="leading-relaxed">
              We may update this Privacy Policy from time to time. Any changes will be posted on this page with an updated revision date.
            </p>
          </section>
        </div>

        <div class="mt-16 p-6 bg-blue-600/10 border border-blue-500/30 rounded-xl">
          <h3 class="text-2xl font-bold text-white mb-3">Summary</h3>
          <p class="text-gray-300 leading-relaxed">
            <strong class="text-blue-400">TL;DR:</strong> EyeBreak is completely private. We don't collect any data, track you, or require an internet connection. All your settings stay on your Mac. Period.
          </p>
        </div>
      </div>
    </div>

    <Footer />
  </div>
</template>

<style scoped>
.prose {
  color: #d1d5db;
}

.prose h1, .prose h2, .prose h3 {
  margin-top: 2rem;
}

.prose p {
  margin-bottom: 1rem;
}

.prose ul {
  margin-top: 0.5rem;
  margin-bottom: 1rem;
}
</style>
