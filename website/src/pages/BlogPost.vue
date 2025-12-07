<script setup lang="ts">
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import Navbar from '../components/Navbar.vue'
import Footer from '../components/Footer.vue'

const route = useRoute()
const router = useRouter()

interface BlogPostContent {
  slug: string
  title: string
  date: string
  readTime: string
  category: string
  content: string[]
}

const blogPosts: BlogPostContent[] = [
  {
    slug: 'the-science-behind-20-20-20-rule',
    title: 'The Science Behind the 20-20-20 Rule',
    date: 'December 5, 2025',
    readTime: '4 min read',
    category: 'Eye Health',
    content: [
      `If you spend hours staring at screens, you've probably experienced digital eye strain - that uncomfortable feeling of tired, dry, or irritated eyes. The 20-20-20 rule is a simple yet scientifically-backed technique to combat this modern problem.`,
      `## What is the 20-20-20 Rule?`,
      `The rule is straightforward: every 20 minutes, take a 20-second break and look at something 20 feet (about 6 meters) away. This simple practice can significantly reduce the strain on your eye muscles.`,
      `## Why Does It Work?`,
      `When you focus on a nearby screen, your eye muscles (specifically the ciliary muscles) contract to adjust the lens for close-up vision. Maintaining this contraction for extended periods leads to muscle fatigue - similar to how holding any muscle in one position becomes uncomfortable over time.`,
      `Looking at distant objects allows these muscles to relax. The 20-foot distance is far enough that your eyes can essentially rest in their natural, relaxed state.`,
      `## The Science Behind It`,
      `Research published in the Nepalese Journal of Ophthalmology found that participants who followed the 20-20-20 rule experienced significantly less eye strain symptoms compared to those who didn't. Another study in the Contact Lens and Anterior Eye journal confirmed that regular breaks reduce symptoms of computer vision syndrome.`,
      `## Tips for Implementation`,
      `- **Set a timer**: Use EyeBreak or any timer app to remind you every 20 minutes\n- **Find a distant target**: A window view works perfectly - look at trees, buildings, or the horizon\n- **Don't just look - focus**: Actually focus on the distant object, don't just look in that direction\n- **Blink**: Use this time to consciously blink several times to refresh your tear film`,
      `## Beyond 20-20-20`,
      `While the 20-20-20 rule is excellent for short breaks, consider taking longer breaks (5-10 minutes) every hour for more comprehensive rest. Combine this with proper lighting, screen positioning, and staying hydrated for optimal eye comfort.`,
      `Start implementing the 20-20-20 rule today with EyeBreak - your eyes will thank you!`
    ]
  },
  {
    slug: 'how-blue-light-affects-your-eyes',
    title: 'How Blue Light Affects Your Eyes',
    date: 'December 1, 2025',
    readTime: '5 min read',
    category: 'Digital Wellness',
    content: [
      `Blue light is everywhere - from the sun to our smartphones, computers, and LED lights. While blue light exposure during the day can be beneficial, excessive exposure, especially at night, can have significant effects on both your eyes and overall health.`,
      `## What is Blue Light?`,
      `Blue light is part of the visible light spectrum, with wavelengths between 380-500 nanometers. It's naturally present in sunlight but is also emitted in significant amounts by digital screens and LED lighting. Unlike other forms of light, blue light has shorter wavelengths and higher energy.`,
      `## Effects on Your Eyes`,
      `**Digital Eye Strain**: Blue light scatters more than other visible light, making it harder for your eyes to focus. This can contribute to digital eye strain, causing symptoms like:\n- Dry eyes\n- Blurred vision\n- Headaches\n- Difficulty focusing`,
      `**Potential Long-term Concerns**: Some research suggests that prolonged blue light exposure might contribute to retinal damage over time, though more studies are needed. The eyes' natural filters don't block blue light effectively, allowing it to reach the retina.`,
      `## Effects on Sleep`,
      `Perhaps the most well-documented effect of blue light is its impact on sleep. Blue light suppresses melatonin production - the hormone that regulates your sleep-wake cycle. Using devices before bed can:\n- Delay sleep onset\n- Reduce sleep quality\n- Disrupt your circadian rhythm`,
      `## How to Protect Yourself`,
      `**Use Night Mode**: Most devices now include blue light filters or night modes that shift the display to warmer colors in the evening.`,
      `**Follow the 20-20-20 Rule**: Regular breaks help reduce overall exposure and give your eyes rest.`,
      `**Consider Blue Light Glasses**: While the evidence is mixed, some people find blue light filtering glasses helpful for reducing eye strain.`,
      `**Limit Evening Screen Time**: Try to avoid screens for 1-2 hours before bed, or use blue light filters if you must use devices.`,
      `**Adjust Screen Brightness**: Match your screen brightness to your environment - too bright causes more strain.`,
      `## The Bottom Line`,
      `While blue light isn't inherently dangerous in moderate amounts, our unprecedented screen time means we're exposed to more than ever before. Taking simple precautions like using EyeBreak for regular reminders and enabling night mode can help protect your eyes and sleep quality.`
    ]
  },
  {
    slug: 'hydration-and-eye-health',
    title: 'Why Hydration Matters for Eye Health',
    date: 'November 28, 2025',
    readTime: '3 min read',
    category: 'Eye Health',
    content: [
      `You probably know that staying hydrated is important for your overall health, but did you know it's crucial for your eyes too? Dehydration can directly impact your eye comfort and vision quality.`,
      `## The Eye-Hydration Connection`,
      `Your eyes rely on adequate hydration to maintain their tear film - a thin layer of moisture that covers and protects the eye's surface. This tear film is essential for:\n- Clear vision\n- Comfortable eye movement\n- Protection against irritants\n- Nutrient delivery to the cornea`,
      `## Signs of Dehydrated Eyes`,
      `When you're not drinking enough water, your eyes often show it first:\n- Dry, gritty sensation\n- Burning or stinging\n- Redness\n- Blurred vision\n- Eye fatigue\n- Increased sensitivity to light`,
      `## How Much Water Do You Need?`,
      `While the "8 glasses a day" rule is a good starting point, your actual needs depend on factors like:\n- Body size\n- Activity level\n- Climate\n- Overall health`,
      `A good indicator is the color of your urine - pale yellow suggests adequate hydration, while dark yellow indicates you need more water.`,
      `## Tips for Better Eye Hydration`,
      `**Drink water consistently**: Don't wait until you're thirsty. Keep a water bottle nearby and sip throughout the day.`,
      `**Set reminders**: Use EyeBreak's water reminder feature to prompt you to hydrate regularly.`,
      `**Eat water-rich foods**: Cucumbers, watermelon, oranges, and other fruits and vegetables contribute to your fluid intake.`,
      `**Limit dehydrating beverages**: Coffee and alcohol can increase fluid loss. Balance them with extra water.`,
      `**Use a humidifier**: Especially in air-conditioned or heated environments, a humidifier can help prevent eye moisture loss.`,
      `## Hydration + Screen Breaks = Happy Eyes`,
      `Combining proper hydration with regular screen breaks creates the ideal environment for eye health. When you take your 20-20-20 breaks, use that time to drink some water too. EyeBreak can remind you to do both!`,
      `Your eyes are about 80% water - keep them well-hydrated for optimal comfort and vision.`
    ]
  },
  {
    slug: 'remote-work-eye-care-tips',
    title: 'Best Eye Care Practices for Remote Workers',
    date: 'November 20, 2025',
    readTime: '6 min read',
    category: 'Productivity',
    content: [
      `Remote work has become the norm for millions of people, and while it offers many benefits, it often means more screen time than ever. Here's your comprehensive guide to keeping your eyes healthy while working from home.`,
      `## Set Up an Eye-Friendly Workspace`,
      `**Monitor Position**: Place your screen about arm's length away (20-26 inches) and slightly below eye level. The top of your screen should be at or just below eye level.`,
      `**Lighting**: Avoid harsh overhead lighting directly above your screen. Position your desk perpendicular to windows to minimize glare. Use task lighting that doesn't create reflections on your screen.`,
      `**Screen Settings**: Adjust brightness to match your surroundings. Increase text size if you find yourself leaning in. Consider using dark mode in low-light conditions.`,
      `## Establish Healthy Habits`,
      `**Follow the 20-20-20 Rule**: Every 20 minutes, look at something 20 feet away for 20 seconds. Use EyeBreak to automate these reminders.`,
      `**Take Regular Breaks**: Beyond the 20-20-20 rule, take a longer break (5-10 minutes) every hour. Stand up, stretch, and let your eyes rest from all screens.`,
      `**Stay Hydrated**: Keep water at your desk and drink regularly. Dehydration worsens eye strain.`,
      `## Combat Dry Eyes`,
      `Home environments can be particularly drying for eyes due to heating, air conditioning, or poor ventilation.`,
      `**Blink consciously**: We blink less when focusing on screens. Make a conscious effort to blink fully and frequently.`,
      `**Use artificial tears**: Over-the-counter lubricating eye drops can provide relief. Avoid drops that "reduce redness" for regular use.`,
      `**Add humidity**: A humidifier can help maintain comfortable moisture levels in your workspace.`,
      `## Optimize Your Schedule`,
      `**Batch video calls**: Too many video meetings strain your eyes more than other work. Try to schedule them in blocks with recovery time between.`,
      `**Use audio alternatives**: When possible, opt for phone calls instead of video. This gives your eyes a complete break from the screen.`,
      `**Schedule outdoor time**: Take lunch breaks outside when possible. Natural light and long-distance viewing are great for your eyes.`,
      `## Signs You Need Professional Help`,
      `See an eye care professional if you experience:\n- Persistent eye pain\n- Significant vision changes\n- Frequent headaches\n- Double vision\n- Eye redness that doesn't improve`,
      `## Make It Automatic`,
      `The best eye care routine is one you don't have to think about. That's why EyeBreak exists - to automatically remind you to take breaks, drink water, and rest your eyes. Set it up once, and let it protect your eyes while you focus on your work.`,
      `Your eyes are your most valuable tool for remote work. Take care of them, and they'll take care of you!`
    ]
  }
]

const currentPost = computed(() => {
  const slug = route.params.slug as string
  return blogPosts.find(post => post.slug === slug)
})

const getCategoryColor = (category: string): string => {
  const colors: Record<string, string> = {
    'Eye Health': 'bg-blue-600/20 text-blue-400 border-blue-500/30',
    'Digital Wellness': 'bg-purple-600/20 text-purple-400 border-purple-500/30',
    'Productivity': 'bg-green-600/20 text-green-400 border-green-500/30'
  }
  return colors[category] || 'bg-gray-600/20 text-gray-400 border-gray-500/30'
}

const formatContent = (text: string): string => {
  // Convert markdown-style headers and lists to HTML
  return text
    .replace(/^## (.+)$/gm, '<h2 class="text-2xl font-bold text-white mt-8 mb-4">$1</h2>')
    .replace(/\*\*(.+?)\*\*/g, '<strong class="text-white">$1</strong>')
    .replace(/\n- /g, '</p><p class="text-gray-300 leading-relaxed mb-2 pl-4">• ')
    .replace(/\\n/g, '<br>')
}

const goBack = () => {
  router.push('/blog')
}
</script>

<template>
  <div class="min-h-screen bg-gray-950">
    <Navbar />

    <main class="pt-24 pb-20 px-4">
      <div class="container mx-auto max-w-3xl">
        <!-- Back Button -->
        <button
          @click="goBack"
          class="flex items-center gap-2 text-gray-400 hover:text-white transition-colors mb-8"
        >
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/>
          </svg>
          <span>Back to Blog</span>
        </button>

        <template v-if="currentPost">
          <!-- Article Header -->
          <header class="mb-12">
            <div class="mb-4">
              <span :class="['px-3 py-1 text-xs font-semibold rounded-full border', getCategoryColor(currentPost.category)]">
                {{ currentPost.category }}
              </span>
            </div>

            <h1 class="text-4xl md:text-5xl font-bold text-white mb-6 leading-tight">
              {{ currentPost.title }}
            </h1>

            <div class="flex items-center gap-4 text-gray-400">
              <span>{{ currentPost.date }}</span>
              <span>•</span>
              <span class="flex items-center gap-1">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                {{ currentPost.readTime }}
              </span>
            </div>
          </header>

          <!-- Article Content -->
          <article class="prose prose-invert max-w-none">
            <div
              v-for="(paragraph, index) in currentPost.content"
              :key="index"
              class="mb-6"
            >
              <p
                v-if="!paragraph.startsWith('##')"
                class="text-gray-300 leading-relaxed text-lg"
                v-html="formatContent(paragraph)"
              />
              <div v-else v-html="formatContent(paragraph)" />
            </div>
          </article>

          <!-- Share / CTA Section -->
          <div class="mt-16 pt-8 border-t border-gray-800">
            <div class="card text-center">
              <h3 class="text-xl font-bold text-white mb-3">Ready to protect your eyes?</h3>
              <p class="text-gray-400 mb-6">
                Download EyeBreak and start taking care of your eye health today.
              </p>
              <button
                @click="router.push('/')"
                class="btn-primary"
              >
                Get EyeBreak for Free
              </button>
            </div>
          </div>
        </template>

        <!-- Not Found -->
        <template v-else>
          <div class="text-center py-20">
            <h1 class="text-4xl font-bold text-white mb-4">Post Not Found</h1>
            <p class="text-gray-400 mb-8">The blog post you're looking for doesn't exist.</p>
            <button @click="goBack" class="btn-primary">
              Back to Blog
            </button>
          </div>
        </template>
      </div>
    </main>

    <Footer />
  </div>
</template>
