<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'

const isVisible = ref(false)
const showTooltip = ref(false)

const checkScroll = () => {
  // Show button after scrolling 200px
  isVisible.value = window.scrollY > 200
}

const scrollToSupport = () => {
  const supportSection = document.querySelector('#support')
  if (supportSection) {
    // Scroll to show the support section with some padding
    const yOffset = -50 // Add some offset to show above the section
    const y = supportSection.getBoundingClientRect().top + window.pageYOffset + yOffset
    window.scrollTo({ top: y, behavior: 'smooth' })
  } else {
    // Fallback to footer if #support not found
    const footer = document.querySelector('footer')
    if (footer) {
      footer.scrollIntoView({ behavior: 'smooth', block: 'start' })
    }
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
      class="fixed bottom-8 right-8 z-40 hidden sm:block"
      @mouseenter="showTooltip = true"
      @mouseleave="showTooltip = false"
    >
      <!-- Tooltip -->
      <Transition name="tooltip">
        <div
          v-if="showTooltip"
          class="absolute bottom-full right-0 mb-3 whitespace-nowrap rounded-lg border border-white/10 bg-slate-950/90 px-4 py-2 text-sm font-semibold text-white shadow-xl backdrop-blur-xl"
        >
          Support EyeBreak
          <div class="absolute bottom-0 right-6 h-2 w-2 translate-y-1/2 rotate-45 border-b border-r border-white/10 bg-slate-950"></div>
        </div>
      </Transition>

      <!-- Donate Button -->
      <a
        href="#support"
        class="group flex h-14 w-14 items-center justify-center rounded-full border border-cyan-200/30 bg-cyan-300 text-slate-950 shadow-lg shadow-cyan-950/30 transition-all duration-300 hover:scale-110 hover:bg-cyan-200"
        @click.prevent="scrollToSupport"
        aria-label="Support EyeBreak"
      >
        <svg class="w-7 h-7 group-hover:scale-110 transition-transform" fill="currentColor" viewBox="0 0 24 24">
          <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
        </svg>

        <!-- Ripple Effect -->
        <span class="absolute inset-0 rounded-full bg-cyan-200 opacity-0 group-hover:opacity-20 group-hover:animate-ping"></span>
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
