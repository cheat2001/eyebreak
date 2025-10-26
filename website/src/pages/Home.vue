<script setup lang="ts">
import Hero from '../components/Hero.vue'
import Features from '../components/Features.vue'
import Installation from '../components/Installation.vue'
import Screenshots from '../components/Screenshots.vue'
import Documentation from '../components/Documentation.vue'
import Footer from '../components/Footer.vue'
</script>

<template>
  <div class="home">
    <Hero />
    <Features />
    <Screenshots />
    <Installation />
    <Documentation />
    <Footer />
  </div>
</template>

<style scoped>
.home {
  min-height: 100vh;
}
</style>
