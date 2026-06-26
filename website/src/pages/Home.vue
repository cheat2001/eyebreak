<script setup lang="ts">
import { onMounted, onUnmounted, nextTick } from 'vue'
import Hero from '../components/Hero.vue'
import VideoShowcase from '../components/VideoShowcase.vue'
import Features from '../components/Features.vue'
import Installation from '../components/Installation.vue'
import Screenshots from '../components/Screenshots.vue'
import Documentation from '../components/Documentation.vue'
import Footer from '../components/Footer.vue'
import FloatingDonate from '../components/FloatingDonate.vue'

let revealObserver: IntersectionObserver | null = null

onMounted(async () => {
  await nextTick()

  const revealElements = document.querySelectorAll<HTMLElement>('[data-reveal]')

  if (!('IntersectionObserver' in window)) {
    revealElements.forEach((element) => element.classList.add('is-visible'))
    return
  }

  revealObserver = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-visible')
          revealObserver?.unobserve(entry.target)
        }
      })
    },
    {
      rootMargin: '0px 0px -12% 0px',
      threshold: 0.12
    }
  )

  revealElements.forEach((element) => revealObserver?.observe(element))
})

onUnmounted(() => {
  revealObserver?.disconnect()
})
</script>

<template>
  <div class="home">
    <Hero />
    <VideoShowcase />
    <Features />
    <Screenshots />
    <Installation />
    <Documentation />
    <Footer />
    <FloatingDonate />
  </div>
</template>

<style scoped>
.home {
  min-height: 100vh;
}
</style>
