import { createRouter, createWebHistory } from 'vue-router'
import Home from '../pages/Home.vue'
import Releases from '../pages/Releases.vue'
import Privacy from '../pages/Privacy.vue'
import Blog from '../pages/Blog.vue'
import BlogPost from '../pages/BlogPost.vue'
import NotFound from '../pages/NotFound.vue'

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
    },
    {
      path: '/blog',
      name: 'blog',
      component: Blog
    },
    {
      path: '/blog/:slug',
      name: 'blog-post',
      component: BlogPost
    },
    {
      path: '/:pathMatch(.*)*',
      name: 'not-found',
      component: NotFound
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
      return { top: 0, behavior: 'smooth' }
    }
  }
})

export default router
