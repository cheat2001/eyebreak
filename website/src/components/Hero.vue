<script setup lang="ts">
const scrollToInstallation = () => {
  const element = document.getElementById('installation')
  if (element) {
    element.scrollIntoView({ behavior: 'smooth' })
  }
}

const viewGitHub = () => {
  window.open('https://github.com/cheat2001/eyebreak', '_blank')
}
</script>

<template>
  <section class="hero-section min-h-screen flex items-center justify-center px-4 py-20 relative overflow-hidden">
    <!-- Dark base background -->
    <div class="absolute inset-0 bg-gray-950"></div>
    
    <!-- Subtle gradient overlay -->
    <div class="absolute inset-0 bg-gradient-to-b from-blue-950/30 via-gray-950 to-gray-950"></div>
    
    <!-- Glow effects -->
    <div class="absolute top-20 left-1/4 w-96 h-96 bg-blue-600/5 rounded-full blur-3xl"></div>
    <div class="absolute bottom-20 right-1/4 w-96 h-96 bg-purple-600/5 rounded-full blur-3xl"></div>
    
    <div class="container mx-auto max-w-6xl relative z-10">
      <div class="text-center animate-fade-in">
        <!-- App Icon -->
        <div class="mb-12 flex justify-center">
          <div class="relative group">
            <div class="absolute inset-0 bg-blue-600 rounded-3xl blur-2xl opacity-50 group-hover:opacity-70 transition-opacity"></div>
            <div class="relative w-32 h-32 bg-gradient-to-br from-blue-600 to-blue-700 rounded-3xl shadow-2xl flex items-center justify-center transform group-hover:scale-110 transition-transform duration-300">
              <svg class="w-20 h-20 text-white" fill="currentColor" viewBox="0 0 24 24">
                <path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/>
              </svg>
            </div>
          </div>
        </div>

        <!-- Title -->
        <h1 class="text-6xl md:text-8xl font-bold mb-6 animate-slide-up">
          <span class="bg-gradient-to-r from-white via-gray-100 to-gray-300 bg-clip-text text-transparent">Eye</span><span class="bg-gradient-to-r from-blue-400 to-blue-600 bg-clip-text text-transparent">Break</span>
        </h1>

        <!-- Tagline -->
        <p class="text-2xl md:text-4xl text-gray-300 mb-6 animate-slide-up font-light" style="animation-delay: 0.1s">
          Your Eyes Deserve a Break
        </p>

        <!-- Description -->
        <p class="text-lg md:text-xl text-gray-400 max-w-3xl mx-auto mb-12 animate-slide-up leading-relaxed" style="animation-delay: 0.2s">
          A minimalistic macOS app that helps reduce digital eye strain with the 20-20-20 rule,
          smart hydration reminders, and beautiful customizable themes.
        </p>

        <!-- Version Badges -->
        <div class="mb-12 flex justify-center gap-3 flex-wrap animate-slide-up" style="animation-delay: 0.3s">
          <span class="px-5 py-2.5 bg-blue-600/20 border border-blue-500/30 text-blue-300 rounded-full text-sm font-semibold backdrop-blur-sm">
            v2.2.0
          </span>
          <span class="px-5 py-2.5 bg-green-600/20 border border-green-500/30 text-green-300 rounded-full text-sm font-semibold backdrop-blur-sm">
            macOS 14.0+
          </span>
          <span class="px-5 py-2.5 bg-purple-600/20 border border-purple-500/30 text-purple-300 rounded-full text-sm font-semibold backdrop-blur-sm">
            Free & Open Source
          </span>
        </div>

        <!-- CTA Buttons -->
        <div class="flex flex-col sm:flex-row gap-4 justify-center items-center animate-slide-up mb-20" style="animation-delay: 0.4s">
          <button @click="scrollToInstallation" class="btn-primary text-lg px-10 py-4 group">
            <span class="flex items-center gap-3">
              <svg class="w-6 h-6 group-hover:animate-bounce" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M9 19l3 3m0 0l3-3m-3 3V10"></path>
              </svg>
              <span>Download for macOS</span>
            </span>
          </button>
          <button @click="viewGitHub" class="btn-secondary text-lg px-10 py-4 group">
            <span class="flex items-center gap-3">
              <svg class="w-6 h-6 group-hover:rotate-12 transition-transform" fill="currentColor" viewBox="0 0 24 24">
                <path d="M12 0C5.37 0 0 5.37 0 12c0 5.31 3.435 9.795 8.205 11.385.6.105.825-.255.825-.57 0-.285-.015-1.23-.015-2.235-3.015.555-3.795-.735-4.035-1.41-.135-.345-.72-1.41-1.23-1.695-.42-.225-1.02-.78-.015-.795.945-.015 1.62.87 1.845 1.23 1.08 1.815 2.805 1.305 3.495.99.105-.78.42-1.305.765-1.605-2.67-.3-5.46-1.335-5.46-5.925 0-1.305.465-2.385 1.23-3.225-.12-.3-.54-1.53.12-3.18 0 0 1.005-.315 3.3 1.23.96-.27 1.98-.405 3-.405s2.04.135 3 .405c2.295-1.56 3.3-1.23 3.3-1.23.66 1.65.24 2.88.12 3.18.765.84 1.23 1.905 1.23 3.225 0 4.605-2.805 5.625-5.475 5.925.435.375.81 1.095.81 2.22 0 1.605-.015 2.895-.015 3.3 0 .315.225.69.825.57A12.02 12.02 0 0024 12c0-6.63-5.37-12-12-12z"/>
              </svg>
              <span>View on GitHub</span>
            </span>
          </button>
        </div>

        <!-- Features Highlight -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-5xl mx-auto animate-slide-up" style="animation-delay: 0.5s">
          <div class="group p-8 bg-gray-900/40 backdrop-blur-xl rounded-2xl border border-gray-800/50 hover:border-red-500/50 hover:bg-gray-900/60 transition-all duration-300">
            <div class="mb-4 flex justify-center">
              <div class="w-16 h-16 bg-gradient-to-br from-red-500 to-red-600 rounded-2xl flex items-center justify-center group-hover:scale-110 transition-transform">
                <svg class="w-10 h-10 text-white" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zM12 20c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8zm.5-13H11v6l5.25 3.15.75-1.23-4.5-2.67z"/>
                </svg>
              </div>
            </div>
            <h3 class="text-xl font-semibold text-white mb-2">20-20-20 Rule</h3>
            <p class="text-gray-400">Science-backed eye care method</p>
          </div>
          <div class="group p-8 bg-gray-900/40 backdrop-blur-xl rounded-2xl border border-gray-800/50 hover:border-blue-500/50 hover:bg-gray-900/60 transition-all duration-300">
            <div class="mb-4 flex justify-center">
              <div class="w-16 h-16 bg-gradient-to-br from-cyan-500 to-blue-600 rounded-2xl flex items-center justify-center group-hover:scale-110 transition-transform">
                <svg class="w-10 h-10 text-white" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M12 2.69l5.66 5.66a8 8 0 1 1-11.31 0z"/>
                </svg>
              </div>
            </div>
            <h3 class="text-xl font-semibold text-white mb-2">Hydration Reminders</h3>
            <p class="text-gray-400">Stay refreshed & healthy</p>
          </div>
          <div class="group p-8 bg-gray-900/40 backdrop-blur-xl rounded-2xl border border-gray-800/50 hover:border-purple-500/50 hover:bg-gray-900/60 transition-all duration-300">
            <div class="mb-4 flex justify-center">
              <div class="w-16 h-16 bg-gradient-to-br from-purple-500 to-pink-600 rounded-2xl flex items-center justify-center group-hover:scale-110 transition-transform">
                <svg class="w-10 h-10 text-white" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M12 22C6.49 22 2 17.51 2 12S6.49 2 12 2s10 4.04 10 9c0 3.31-2.69 6-6 6h-1.77c-.28 0-.5.22-.5.5 0 .12.05.23.13.33.41.47.64 1.06.64 1.67A2.5 2.5 0 0112 22zm0-18c-4.41 0-8 3.59-8 8s3.59 8 8 8c.28 0 .5-.22.5-.5a.54.54 0 00-.14-.35c-.41-.46-.63-1.05-.63-1.65a2.5 2.5 0 012.5-2.5H16c2.21 0 4-1.79 4-4 0-3.86-3.59-7-8-7z M6.5 11.5a1.5 1.5 0 110-3 1.5 1.5 0 010 3zm3-4a1.5 1.5 0 110-3 1.5 1.5 0 010 3zm5 0a1.5 1.5 0 110-3 1.5 1.5 0 010 3zm3 4a1.5 1.5 0 110-3 1.5 1.5 0 010 3z"/>
                </svg>
              </div>
            </div>
            <h3 class="text-xl font-semibold text-white mb-2">Beautiful Themes</h3>
            <p class="text-gray-400">Customize your experience</p>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
.hero-section {
  background: linear-gradient(to bottom, #0f172a, #020617);
}

@keyframes float {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-20px); }
}

@keyframes fade-in {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes slide-up {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-float {
  animation: float 3s ease-in-out infinite;
}

.animate-fade-in {
  animation: fade-in 0.6s ease-out;
}

.animate-slide-up {
  animation: slide-up 0.6s ease-out backwards;
}
</style>

<style scoped>
.hero-section {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  background: linear-gradient(to bottom right, #f9fafb, #dbeafe);
}
</style>
