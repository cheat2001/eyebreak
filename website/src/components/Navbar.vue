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
      'fixed left-0 right-0 top-0 z-50 px-3 py-3 transition-all duration-300',
      isScrolled || mobileMenuOpen ? 'translate-y-0' : 'translate-y-0'
    ]"
  >
    <Transition name="nav-backdrop">
      <div
        v-if="mobileMenuOpen"
        class="fixed inset-0 -z-10 bg-slate-950/92 backdrop-blur-md md:hidden"
        @click="mobileMenuOpen = false"
      ></div>
    </Transition>

    <div
      :class="[
        'container mx-auto max-w-7xl border px-4 transition-colors duration-200',
        mobileMenuOpen
          ? 'rounded-[1.75rem] border-white/10 bg-slate-950 shadow-2xl shadow-black/40'
          : isScrolled
            ? 'rounded-full border-white/10 bg-slate-950/90 shadow-2xl shadow-black/25 backdrop-blur-2xl'
            : 'rounded-full border-white/5 bg-slate-950/52 backdrop-blur-xl'
      ]"
    >
      <div class="flex h-14 items-center justify-between">
        <!-- Logo -->
        <button @click="router.push('/')" class="group flex items-center gap-2 text-white transition-colors hover:text-cyan-100">
          <div class="grid h-9 w-9 place-items-center rounded-full bg-cyan-300 text-slate-950 shadow-lg shadow-cyan-950/30 transition-transform group-hover:scale-105">
            <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24">
              <path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/>
            </svg>
          </div>
          <span class="text-lg font-black tracking-normal">EyeBreak</span>
        </button>

        <!-- Desktop Navigation -->
        <div class="hidden items-center gap-1 md:flex">
          <button @click="scrollToSection('features')" class="nav-link">
            Features
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
          <button @click="scrollToSection('installation')" class="ml-2 rounded-full bg-cyan-300 px-5 py-2 text-sm font-black text-slate-950 shadow-lg shadow-cyan-950/30 transition-all hover:-translate-y-0.5 hover:bg-cyan-200">
            Download
          </button>
        </div>

        <!-- Mobile Menu Button -->
        <button 
          @click="mobileMenuOpen = !mobileMenuOpen"
          class="grid h-10 w-10 place-items-center rounded-full border border-white/10 bg-white/5 text-white md:hidden"
          aria-label="Toggle menu"
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
          class="border-t border-white/10 py-4 md:hidden"
        >
          <div class="flex flex-col gap-2">
            <button @click="scrollToSection('features')" class="mobile-link">
              Features
            </button>
            <button @click="navigateToReleases" class="mobile-link">
              Releases
            </button>
            <button @click="navigateToBlog" class="mobile-link">
              Blog
            </button>
            <button @click="scrollToSection('documentation')" class="mobile-link">
              Docs
            </button>
            <button @click="scrollToSection('installation')" class="mt-2 rounded-full bg-cyan-300 px-5 py-3 text-left font-black text-slate-950 transition-colors hover:bg-cyan-200">
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
  @apply rounded-full px-4 py-2 text-sm font-semibold text-slate-300 transition-colors hover:bg-white/10 hover:text-white;
}

.mobile-link {
  @apply rounded-lg px-4 py-3 text-left text-lg font-bold text-slate-200 transition-colors hover:bg-white/10 hover:text-white;
}

.mobile-menu-enter-active,
.mobile-menu-leave-active {
  transition: opacity 0.18s ease, max-height 0.18s ease;
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

.nav-backdrop-enter-active,
.nav-backdrop-leave-active {
  transition: opacity 0.2s ease;
}

.nav-backdrop-enter-from,
.nav-backdrop-leave-to {
  opacity: 0;
}
</style>
