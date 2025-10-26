<script setup lang="ts">
import { RouterView } from 'vue-router'
import Navbar from './components/Navbar.vue'
</script>

<template>
  <div class="app bg-gray-950">
    <Navbar />
    <RouterView />
  </div>
</template>

<style scoped>
.app {
  min-height: 100vh;
}
</style>

