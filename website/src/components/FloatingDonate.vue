<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'

const isVisible = ref(false)
const showTooltip = ref(false)

const checkScroll = () => {
  // Show button after scrolling 200px
  isVisible.value = window.scrollY > 200
}

const scrollToSupport = () => {
  const footer = document.querySelector('footer')
  if (footer) {
    footer.scrollIntoView({ behavior: 'smooth', block: 'center' })
  }
}

onMounted(() => {
  window.addEventListener('scroll', checkScroll)
  checkScroll()
})

onUnmounted(() => {
  window.removeEventListener('scroll', checkScroll)
})
</script>

<template>
  <Transition name="fade">
    <div
      v-if="isVisible"
      class="fixed bottom-8 right-8 z-40"
      @mouseenter="showTooltip = true"
      @mouseleave="showTooltip = false"
    >
      <!-- Tooltip -->
      <Transition name="tooltip">
        <div
          v-if="showTooltip"
          class="absolute bottom-full right-0 mb-3 px-4 py-2 bg-gray-900 border border-gray-700 text-white text-sm rounded-lg shadow-xl whitespace-nowrap"
        >
          Support EyeBreak ❤️
          <div class="absolute bottom-0 right-6 transform translate-y-1/2 rotate-45 w-2 h-2 bg-gray-900 border-r border-b border-gray-700"></div>
        </div>
      </Transition>

      <!-- Donate Button -->
      <a
        href="#support"
        class="group flex items-center justify-center w-14 h-14 bg-gradient-to-br from-pink-600 to-purple-600 hover:from-pink-700 hover:to-purple-700 rounded-full shadow-lg hover:shadow-pink-500/50 transition-all duration-300 hover:scale-110 animate-pulse-slow"
        @click.prevent="scrollToSupport"
      >
        <svg class="w-7 h-7 text-white group-hover:scale-110 transition-transform" fill="currentColor" viewBox="0 0 24 24">
          <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
        </svg>

        <!-- Ripple Effect -->
        <span class="absolute inset-0 rounded-full bg-pink-400 opacity-0 group-hover:opacity-20 group-hover:animate-ping"></span>
      </a>
    </div>
  </Transition>
</template>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: all 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
  transform: translateY(20px);
}

.tooltip-enter-active,
.tooltip-leave-active {
  transition: all 0.2s ease;
}

.tooltip-enter-from,
.tooltip-leave-to {
  opacity: 0;
  transform: translateY(10px);
}

@keyframes pulse-slow {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.8;
  }
}

.animate-pulse-slow {
  animation: pulse-slow 3s ease-in-out infinite;
}
</style>
