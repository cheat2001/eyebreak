import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import router from './router'

// Setup error monitoring in production
if (import.meta.env.PROD) {
  window.addEventListener('error', (event) => {
    console.error('Global error:', event.error)
  })

  window.addEventListener('unhandledrejection', (event) => {
    console.error('Unhandled promise rejection:', event.reason)
  })
}

createApp(App).use(router).mount('#app')
