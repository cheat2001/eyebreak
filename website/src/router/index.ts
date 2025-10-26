import { createRouter, createWebHistory } from 'vue-router'
import Home from '../pages/Home.vue'
import Releases from '../pages/Releases.vue'
import Privacy from '../pages/Privacy.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: Home
    },
    {
      path: '/releases',
      name: 'releases',
      component: Releases
    },
    {
      path: '/privacy',
      name: 'privacy',
      component: Privacy
    }
  ],
  scrollBehavior(to, _from, savedPosition) {
    if (savedPosition) {
      return savedPosition
    } else if (to.hash) {
      return {
        el: to.hash,
        behavior: 'smooth'
      }
    } else {
      return { top: 0 }
    }
  }
})

export default router
