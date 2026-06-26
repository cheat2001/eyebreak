<script setup lang="ts">
import { onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import Footer from '../components/Footer.vue'

const router = useRouter()

// Meta tag management
const setMetaTag = (name: string, content: string, isProperty = false) => {
  const attribute = isProperty ? 'property' : 'name'
  let meta = document.querySelector(`meta[${attribute}="${name}"]`) as HTMLMetaElement

  if (!meta) {
    meta = document.createElement('meta')
    meta.setAttribute(attribute, name)
    document.head.appendChild(meta)
  }

  meta.content = content
}

const updateMetaTags = () => {
  const title = 'Eye Health Blog | EyeBreak - Tips for Healthier Screen Time'
  const description = 'Discover expert tips on eye health, the 20-20-20 rule, blue light protection, and digital wellness. Learn how to protect your eyes while working on screens.'

  document.title = title
  setMetaTag('description', description)
  setMetaTag('og:title', title, true)
  setMetaTag('og:description', description, true)
  setMetaTag('og:url', 'https://eyebreak.app/blog', true)
  setMetaTag('og:type', 'website', true)
  setMetaTag('twitter:title', title)
  setMetaTag('twitter:description', description)
}

const cleanupMeta = () => {
  document.title = 'EyeBreak - Your Eyes Deserve a Break | Free macOS Eye Care App'
}

onMounted(() => {
  updateMetaTags()
})

onUnmounted(() => {
  cleanupMeta()
})

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
    'Eye Health': 'bg-cyan-300/10 text-cyan-100 border-cyan-300/20',
    'Digital Wellness': 'bg-fuchsia-300/10 text-fuchsia-100 border-fuchsia-300/20',
    'Productivity': 'bg-lime-300/10 text-lime-100 border-lime-300/20'
  }
  return colors[category] || 'bg-slate-600/20 text-slate-300 border-slate-500/30'
}
</script>

<template>
  <div class="min-h-screen bg-slate-950">
    <main class="relative overflow-hidden px-4 pb-20 pt-32">
      <div class="absolute inset-0 aurora-mesh opacity-45"></div>
      <div class="absolute inset-0 bg-slate-950/70"></div>
      <div class="grid-paper absolute inset-0 opacity-30"></div>

      <div class="container relative z-10 mx-auto max-w-6xl">
        <div class="mb-16 grid gap-8 lg:grid-cols-[0.85fr_1.15fr] lg:items-end">
          <div>
            <div class="mb-4 inline-flex items-center gap-2 rounded-full border border-cyan-300/20 bg-cyan-300/10 px-4 py-2 text-sm font-semibold text-cyan-100">
              <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">
                <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2z"/>
              </svg>
              Eye health notes
            </div>
            <h1 class="text-balance text-4xl font-black text-white md:text-6xl">
              Practical writing for healthier screen time.
            </h1>
          </div>
          <p class="max-w-2xl text-lg leading-8 text-slate-400 lg:justify-self-end">
            Short, useful guides about eye strain, focus habits, hydration, remote work, and making long screen days easier on your body.
          </p>
        </div>

        <div class="grid grid-cols-1 gap-6 md:grid-cols-2">
          <article
            v-for="(post, index) in blogPosts"
            :key="post.slug"
            @click="navigateToPost(post.slug)"
            class="group cursor-pointer rounded-lg border border-white/10 bg-white/[0.04] p-6 shadow-xl shadow-black/10 transition-all duration-300 hover:-translate-y-1 hover:border-cyan-300/30 hover:bg-white/[0.06]"
            :style="{ '--reveal-delay': `${(index % 2) * 80}ms` }"
          >
            <div class="mb-5">
              <span :class="['rounded-full border px-3 py-1 text-xs font-semibold', getCategoryColor(post.category)]">
                {{ post.category }}
              </span>
            </div>

            <h2 class="text-2xl font-black text-white transition-colors group-hover:text-cyan-100">
              {{ post.title }}
            </h2>

            <p class="mt-4 leading-7 text-slate-400">
              {{ post.excerpt }}
            </p>

            <div class="mt-6 flex items-center justify-between gap-4 border-t border-white/10 pt-5 text-sm text-slate-500">
              <span>{{ post.date }}</span>
              <span>{{ post.readTime }}</span>
            </div>

            <div class="mt-5 inline-flex items-center gap-2 text-sm font-bold text-cyan-100 opacity-80 transition-all group-hover:translate-x-1 group-hover:opacity-100">
              Read article
              <span aria-hidden="true">-></span>
            </div>
          </article>
        </div>

        <div class="mt-16 rounded-lg border border-white/10 bg-white/[0.04] p-6 text-center text-slate-400">
          More articles coming soon. Stay tuned for more eye health tips.
        </div>
      </div>
    </main>

    <Footer />
  </div>
</template>
