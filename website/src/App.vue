<script setup lang="ts">
import { RouterView } from 'vue-router'
import Navbar from './components/Navbar.vue'
</script>

<template>
  <div class="app bg-gray-950">
    <Navbar />
    <RouterView v-slot="{ Component }">
      <Transition name="page" mode="out-in">
        <component :is="Component" />
      </Transition>
    </RouterView>
  </div>
</template>

<style scoped>
.app {
  min-height: 100vh;
}

.page-enter-active,
.page-leave-active {
  transition: opacity 0.2s ease;
}

.page-enter-from,
.page-leave-to {
  opacity: 0;
}
</style>

