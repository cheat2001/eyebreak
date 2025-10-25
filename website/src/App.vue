<script setup lang="ts">
import Navbar from './components/Navbar.vue'
import Hero from './components/Hero.vue'
import Features from './components/Features.vue'
import Installation from './components/Installation.vue'
import Screenshots from './components/Screenshots.vue'
import Documentation from './components/Documentation.vue'
import Footer from './components/Footer.vue'
</script>

<template>
  <div class="app bg-gray-950">
    <Navbar />
    <Hero />
    <Features />
    <Screenshots />
    <Installation />
    <Documentation />
    <Footer />
  </div>
</template>

<style scoped>
.app {
  min-height: 100vh;
}
</style>

