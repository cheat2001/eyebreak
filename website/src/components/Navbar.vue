<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'

const isScrolled = ref(false)
const mobileMenuOpen = ref(false)
const router = useRouter()

const handleScroll = () => {
  isScrolled.value = window.scrollY > 20
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll)
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})

const scrollToSection = (sectionId: string) => {
  // If not on home page, navigate first
  if (router.currentRoute.value.path !== '/') {
    router.push('/').then(() => {
      setTimeout(() => {
        const element = document.getElementById(sectionId)
        if (element) {
          element.scrollIntoView({ behavior: 'smooth' })
        }
      }, 100)
    })
  } else {
    const element = document.getElementById(sectionId)
    if (element) {
      element.scrollIntoView({ behavior: 'smooth' })
    }
  }
  mobileMenuOpen.value = false
}

const navigateToReleases = () => {
  router.push('/releases')
  mobileMenuOpen.value = false
}

const navigateToBlog = () => {
  router.push('/blog')
  mobileMenuOpen.value = false
}
</script>

<template>
  <nav 
    :class="[
      'fixed top-0 left-0 right-0 z-50 transition-all duration-300',
      isScrolled || mobileMenuOpen ? 'bg-gray-900/95 backdrop-blur-lg shadow-lg' : 'bg-transparent'
    ]"
  >
    <div class="container mx-auto px-4">
      <div class="flex items-center justify-between h-16">
        <!-- Logo -->
        <button @click="router.push('/')" class="flex items-center gap-2 text-white hover:text-blue-400 transition-colors">
          <div class="w-8 h-8 bg-gradient-to-br from-blue-600 to-blue-700 rounded-lg flex items-center justify-center">
            <svg class="w-5 h-5 text-white" fill="currentColor" viewBox="0 0 24 24">
              <path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/>
            </svg>
          </div>
          <span class="text-xl font-bold">EyeBreak</span>
        </button>

        <!-- Desktop Navigation -->
        <div class="hidden md:flex items-center gap-8">
          <button @click="scrollToSection('features')" class="nav-link">
            Features
          </button>
          <button @click="scrollToSection('screenshots')" class="nav-link">
            Screenshots
          </button>
          <button @click="navigateToReleases" class="nav-link">
            Releases
          </button>
          <button @click="navigateToBlog" class="nav-link">
            Blog
          </button>
          <button @click="scrollToSection('documentation')" class="nav-link">
            Docs
          </button>
          <button @click="scrollToSection('installation')" class="px-5 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition-colors font-semibold">
            Download
          </button>
        </div>

        <!-- Mobile Menu Button -->
        <button 
          @click="mobileMenuOpen = !mobileMenuOpen"
          class="md:hidden text-white"
        >
          <svg v-if="!mobileMenuOpen" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
          </svg>
          <svg v-else class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      </div>

      <!-- Mobile Menu -->
      <Transition name="mobile-menu">
        <div
          v-if="mobileMenuOpen"
          class="md:hidden py-4 border-t border-gray-700"
        >
        <div class="flex flex-col gap-4">
          <button @click="scrollToSection('features')" class="text-gray-300 hover:text-white transition-colors text-left">
            Features
          </button>
          <button @click="scrollToSection('screenshots')" class="text-gray-300 hover:text-white transition-colors text-left">
            Screenshots
          </button>
          <button @click="navigateToReleases" class="text-gray-300 hover:text-white transition-colors text-left">
            Releases
          </button>
          <button @click="navigateToBlog" class="text-gray-300 hover:text-white transition-colors text-left">
            Blog
          </button>
          <button @click="scrollToSection('documentation')" class="text-gray-300 hover:text-white transition-colors text-left">
            Docs
          </button>
          <button @click="scrollToSection('installation')" class="px-5 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition-colors font-semibold text-left">
            Download
          </button>
        </div>
        </div>
      </Transition>
    </div>
  </nav>
</template>

<style scoped>
.nav-link {
  @apply text-gray-300 hover:text-white transition-colors;
}

.mobile-menu-enter-active,
.mobile-menu-leave-active {
  transition: all 0.3s ease;
  overflow: hidden;
}

.mobile-menu-enter-from,
.mobile-menu-leave-to {
  opacity: 0;
  max-height: 0;
  padding-top: 0;
  padding-bottom: 0;
}

.mobile-menu-enter-to,
.mobile-menu-leave-from {
  opacity: 1;
  max-height: 500px;
}
</style>
