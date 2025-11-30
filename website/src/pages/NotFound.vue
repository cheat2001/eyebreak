<script setup lang="ts">
import { useRouter } from 'vue-router'

const router = useRouter()

const goHome = () => {
  router.push('/')
}

const goBack = () => {
  router.back()
}
</script>

<template>
  <div class="min-h-screen bg-gray-950 flex items-center justify-center px-4 py-20">
    <!-- Background effects -->
    <div class="absolute inset-0 overflow-hidden">
      <div class="absolute top-1/4 left-1/4 w-96 h-96 bg-blue-600/5 rounded-full blur-3xl"></div>
      <div class="absolute bottom-1/4 right-1/4 w-96 h-96 bg-purple-600/5 rounded-full blur-3xl"></div>
    </div>

    <div class="relative z-10 text-center max-w-2xl mx-auto">
      <!-- 404 Icon -->
      <div class="mb-8 flex justify-center">
        <div class="relative group">
          <div class="absolute inset-0 bg-blue-600 rounded-3xl blur-2xl opacity-30 group-hover:opacity-50 transition-opacity"></div>
          <div class="relative w-32 h-32 bg-gradient-to-br from-blue-600 to-blue-700 rounded-3xl shadow-2xl flex items-center justify-center">
            <svg class="w-20 h-20 text-white opacity-50" fill="currentColor" viewBox="0 0 24 24">
              <path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/>
            </svg>
          </div>
        </div>
      </div>

      <!-- 404 Text -->
      <h1 class="text-9xl font-bold mb-6 bg-gradient-to-r from-blue-400 to-blue-600 bg-clip-text text-transparent animate-pulse">
        404
      </h1>
      
      <!-- Message -->
      <h2 class="text-4xl md:text-5xl font-bold text-white mb-6">
        Page Not Found
      </h2>
      
      <p class="text-xl text-gray-400 mb-12 leading-relaxed">
        Oops! The page you're looking for doesn't exist or has been moved.<br />
        Time to give your eyes a break and return to safety.
      </p>

      <!-- Action Buttons -->
      <div class="flex flex-col sm:flex-row gap-4 justify-center items-center">
        <button
          @click="goHome"
          class="group px-8 py-4 bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition-all duration-300 font-semibold hover:shadow-lg hover:shadow-blue-500/50 flex items-center gap-2"
        >
          <svg class="w-5 h-5 group-hover:-translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/>
          </svg>
          <span>Back to Home</span>
        </button>
        
        <button
          @click="goBack"
          class="px-8 py-4 bg-gray-800 hover:bg-gray-700 text-gray-300 hover:text-white border border-gray-700 rounded-lg transition-all duration-300 font-semibold"
        >
          Go Back
        </button>
      </div>

      <!-- Helpful Links -->
      <div class="mt-16 pt-8 border-t border-gray-800">
        <p class="text-gray-500 mb-4">Looking for something specific?</p>
        <div class="flex flex-wrap justify-center gap-4 text-sm">
          <button @click="router.push('/')" class="text-gray-400 hover:text-blue-400 transition-colors">
            Home
          </button>
          <span class="text-gray-700">•</span>
          <button @click="router.push('/releases')" class="text-gray-400 hover:text-blue-400 transition-colors">
            Releases
          </button>
          <span class="text-gray-700">•</span>
          <a href="https://github.com/cheat2001/eyebreak" target="_blank" rel="noopener noreferrer" class="text-gray-400 hover:text-blue-400 transition-colors">
            GitHub
          </a>
          <span class="text-gray-700">•</span>
          <button @click="router.push('/privacy')" class="text-gray-400 hover:text-blue-400 transition-colors">
            Privacy
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
@keyframes float {
  0%, 100% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(-10px);
  }
}
</style>
