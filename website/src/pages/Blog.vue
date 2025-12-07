<script setup lang="ts">
import { useRouter } from 'vue-router'
import Navbar from '../components/Navbar.vue'
import Footer from '../components/Footer.vue'

const router = useRouter()

interface BlogPost {
  slug: string
  title: string
  excerpt: string
  date: string
  readTime: string
  category: string
  image?: string
}

const blogPosts: BlogPost[] = [
  {
    slug: 'the-science-behind-20-20-20-rule',
    title: 'The Science Behind the 20-20-20 Rule',
    excerpt: 'Learn why looking at something 20 feet away for 20 seconds every 20 minutes can significantly reduce digital eye strain and improve your eye health.',
    date: 'December 5, 2025',
    readTime: '4 min read',
    category: 'Eye Health'
  },
  {
    slug: 'how-blue-light-affects-your-eyes',
    title: 'How Blue Light Affects Your Eyes',
    excerpt: 'Discover the effects of blue light from screens on your eyes and sleep patterns, and learn practical tips to protect yourself.',
    date: 'December 1, 2025',
    readTime: '5 min read',
    category: 'Digital Wellness'
  },
  {
    slug: 'hydration-and-eye-health',
    title: 'Why Hydration Matters for Eye Health',
    excerpt: 'Your eyes need proper hydration to function well. Learn how staying hydrated can prevent dry eyes and improve your overall eye comfort.',
    date: 'November 28, 2025',
    readTime: '3 min read',
    category: 'Eye Health'
  },
  {
    slug: 'remote-work-eye-care-tips',
    title: 'Best Eye Care Practices for Remote Workers',
    excerpt: 'Working from home means more screen time. Here are essential tips to keep your eyes healthy during long work sessions.',
    date: 'November 20, 2025',
    readTime: '6 min read',
    category: 'Productivity'
  }
]

const navigateToPost = (slug: string) => {
  router.push(`/blog/${slug}`)
}

const getCategoryColor = (category: string): string => {
  const colors: Record<string, string> = {
    'Eye Health': 'bg-blue-600/20 text-blue-400 border-blue-500/30',
    'Digital Wellness': 'bg-purple-600/20 text-purple-400 border-purple-500/30',
    'Productivity': 'bg-green-600/20 text-green-400 border-green-500/30'
  }
  return colors[category] || 'bg-gray-600/20 text-gray-400 border-gray-500/30'
}
</script>

<template>
  <div class="min-h-screen bg-gray-950">
    <Navbar />

    <main class="pt-24 pb-20 px-4">
      <div class="container mx-auto max-w-5xl">
        <!-- Header -->
        <div class="text-center mb-16">
          <div class="inline-flex items-center gap-3 mb-4">
            <svg class="w-10 h-10 text-blue-500" fill="currentColor" viewBox="0 0 24 24">
              <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-5 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/>
            </svg>
            <h1 class="section-title">Blog</h1>
          </div>
          <p class="section-subtitle">
            Tips and insights for healthier screen time habits
          </p>
        </div>

        <!-- Blog Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
          <article
            v-for="post in blogPosts"
            :key="post.slug"
            @click="navigateToPost(post.slug)"
            class="group card cursor-pointer hover:-translate-y-1"
          >
            <!-- Category Badge -->
            <div class="mb-4">
              <span :class="['px-3 py-1 text-xs font-semibold rounded-full border', getCategoryColor(post.category)]">
                {{ post.category }}
              </span>
            </div>

            <!-- Title -->
            <h2 class="text-xl font-bold text-white mb-3 group-hover:text-blue-400 transition-colors">
              {{ post.title }}
            </h2>

            <!-- Excerpt -->
            <p class="text-gray-400 mb-4 leading-relaxed">
              {{ post.excerpt }}
            </p>

            <!-- Meta -->
            <div class="flex items-center justify-between text-sm text-gray-500">
              <span>{{ post.date }}</span>
              <span class="flex items-center gap-1">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                {{ post.readTime }}
              </span>
            </div>

            <!-- Read More Arrow -->
            <div class="mt-4 flex items-center gap-2 text-blue-400 opacity-0 group-hover:opacity-100 transition-opacity">
              <span class="text-sm font-medium">Read more</span>
              <svg class="w-4 h-4 group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
              </svg>
            </div>
          </article>
        </div>

        <!-- Coming Soon Note -->
        <div class="mt-16 text-center">
          <p class="text-gray-500">
            More articles coming soon. Stay tuned for more eye health tips!
          </p>
        </div>
      </div>
    </main>

    <Footer />
  </div>
</template>
