<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { config } from '../config'

const currentYear = new Date().getFullYear()
const router = useRouter()
const showDonateModal = ref(false)
const showKHQRModal = ref(false)

interface Link {
  text: string
  href?: string
  route?: string
  external?: boolean
}

const quickLinks: Link[] = [
  { text: 'Home', route: '/' },
  { text: 'Features', href: '#features' },
  { text: 'Blog', route: '/blog' },
  { text: 'Installation', href: '#installation' },
  { text: 'Documentation', href: '#documentation' }
]

const resources: Link[] = [
  { text: 'GitHub', href: config.github.url, external: true },
  { text: 'Releases', route: '/releases' },
  { text: 'Issues', href: `${config.github.url}/issues`, external: true },
  { text: 'Discussions', href: `${config.github.url}/discussions`, external: true },
  { text: 'Contributing', href: `${config.github.url}/blob/main/CONTRIBUTING.md`, external: true }
]

const docs: Link[] = [
  { text: 'Quick Start', href: `${config.github.url}/blob/main/QUICK_START.md`, external: true },
  { text: 'README', href: `${config.github.url}/blob/main/README.md`, external: true },
  { text: 'FAQ', href: `${config.github.url}/blob/main/docs/FAQ.md`, external: true },
  { text: 'Water Reminder Guide', href: `${config.github.url}/blob/main/docs/WATER_REMINDER_FEATURE.md`, external: true },
  { text: 'Release Notes', route: '/releases' }
]

const handleLinkClick = (link: Link) => {
  if (link.route) {
    router.push(link.route)
  } else if (link.href && !link.external) {
    // Internal anchor link
    const element = document.querySelector(link.href)
    if (element) {
      element.scrollIntoView({ behavior: 'smooth' })
    }
  }
}

const scrollToTop = () => {
  window.scrollTo({ top: 0, behavior: 'smooth' })
}
</script>

<template>
  <footer class="relative overflow-hidden border-t border-white/10 bg-slate-950 px-4 py-16 text-white">
    <div class="absolute inset-0 aurora-mesh opacity-35"></div>
    <div class="absolute inset-0 bg-slate-950/72"></div>

    <div class="container relative z-10 mx-auto max-w-7xl">
      <!-- Main Footer Content -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-12 mb-12">
        <!-- Brand Section -->
        <div class="lg:pr-8">
          <div class="flex items-center gap-3 mb-6">
            <div class="grid h-12 w-12 place-items-center rounded-lg bg-cyan-300 text-slate-950 shadow-xl shadow-cyan-950/30">
              <svg class="w-7 h-7" fill="currentColor" viewBox="0 0 24 24">
                <path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/>
              </svg>
            </div>
            <h3 class="text-2xl font-black text-white">EyeBreak</h3>
          </div>
          <p class="text-slate-400 mb-6 leading-relaxed">
            Screen care for people who spend serious time at their Mac. Quiet reminders, healthy rhythms, and zero data collection.
          </p>
          <div class="flex gap-4">
            <a
              :href="config.github.url"
              target="_blank"
              class="group flex h-12 w-12 items-center justify-center rounded-lg border border-white/10 bg-white/5 transition-all duration-300 hover:-translate-y-1 hover:border-cyan-300/30 hover:bg-cyan-300/10"
            >
              <svg class="w-6 h-6 text-slate-400 group-hover:text-cyan-100 transition-colors" fill="currentColor" viewBox="0 0 24 24">
                <path d="M12 0C5.37 0 0 5.37 0 12c0 5.31 3.435 9.795 8.205 11.385.6.105.825-.255.825-.57 0-.285-.015-1.23-.015-2.235-3.015.555-3.795-.735-4.035-1.41-.135-.345-.72-1.41-1.23-1.695-.42-.225-1.02-.78-.015-.795.945-.015 1.62.87 1.845 1.23 1.08 1.815 2.805 1.305 3.495.99.105-.78.42-1.305.765-1.605-2.67-.3-5.46-1.335-5.46-5.925 0-1.305.465-2.385 1.23-3.225-.12-.3-.54-1.53.12-3.18 0 0 1.005-.315 3.3 1.23.96-.27 1.98-.405 3-.405s2.04.135 3 .405c2.295-1.56 3.3-1.23 3.3-1.23.66 1.65.24 2.88.12 3.18.765.84 1.23 1.905 1.23 3.225 0 4.605-2.805 5.625-5.475 5.925.435.375.81 1.095.81 2.22 0 1.605-.015 2.895-.015 3.3 0 .315.225.69.825.57A12.02 12.02 0 0024 12c0-6.63-5.37-12-12-12z"/>
              </svg>
            </a>
          </div>
        </div>

        <!-- Quick Links -->
        <div>
          <h4 class="text-sm font-black uppercase tracking-[0.18em] text-slate-500 mb-6">Quick Links</h4>
          <ul class="space-y-3">
            <li v-for="link in quickLinks" :key="link.text">
              <a
                v-if="link.href || link.external"
                :href="link.href"
                :target="link.external ? '_blank' : undefined"
                class="footer-link"
              >
                {{ link.text }}
              </a>
              <button
                v-else
                @click="handleLinkClick(link)"
                class="footer-link text-left"
              >
                {{ link.text }}
              </button>
            </li>
          </ul>
        </div>

        <!-- Resources -->
        <div>
          <h4 class="text-sm font-black uppercase tracking-[0.18em] text-slate-500 mb-6">Resources</h4>
          <ul class="space-y-3">
            <li v-for="link in resources" :key="link.text">
              <a
                v-if="link.href || link.external"
                :href="link.href"
                :target="link.external ? '_blank' : undefined"
                class="footer-link"
              >
                {{ link.text }}
              </a>
              <button
                v-else
                @click="handleLinkClick(link)"
                class="footer-link text-left"
              >
                {{ link.text }}
              </button>
            </li>
          </ul>
        </div>

        <!-- Documentation -->
        <div>
          <h4 class="text-sm font-black uppercase tracking-[0.18em] text-slate-500 mb-6">Documentation</h4>
          <ul class="space-y-3">
            <li v-for="link in docs" :key="link.text">
              <a
                v-if="link.href || link.external"
                :href="link.href"
                :target="link.external ? '_blank' : undefined"
                class="footer-link"
              >
                {{ link.text }}
              </a>
              <button
                v-else
                @click="handleLinkClick(link)"
                class="footer-link text-left"
              >
                {{ link.text }}
              </button>
            </li>
          </ul>
        </div>
      </div>

      <!-- Divider -->
      <div class="border-t border-white/10 my-12"></div>

      <!-- Support Section -->
      <div id="support" class="mb-12">
        <div class="mx-auto max-w-3xl rounded-lg border border-white/10 bg-white/[0.04] p-8 text-center shadow-2xl shadow-black/20 backdrop-blur-2xl">
          <div class="inline-flex items-center gap-2 mb-4">
            <svg class="w-6 h-6 text-fuchsia-300" fill="currentColor" viewBox="0 0 24 24">
              <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
            </svg>
            <h4 class="text-xl font-black text-white">Support EyeBreak</h4>
          </div>
          <p class="text-slate-400 mb-6 leading-relaxed">
            EyeBreak is free and open-source. If it helps protect your eyes, consider supporting the project to keep it alive and thriving.
          </p>
          <div class="flex flex-wrap justify-center gap-4">
            <!-- PayPal (International) -->
            <button
              @click="showDonateModal = true"
              class="group inline-flex items-center gap-3 rounded-lg border border-cyan-300/20 bg-cyan-300/10 px-6 py-3 text-cyan-100 transition-all duration-300 hover:-translate-y-1 hover:border-cyan-300/40 hover:bg-cyan-300/15"
            >
              <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                <path d="M7.076 21.337H2.47a.641.641 0 0 1-.633-.74L4.944.901C5.026.382 5.474 0 5.998 0h7.46c2.57 0 4.578.543 5.69 1.81 1.01 1.15 1.304 2.42 1.012 4.287-.023.143-.047.288-.077.437-.983 5.05-4.349 6.797-8.647 6.797h-2.19c-.524 0-.968.382-1.05.9l-1.12 7.106zm14.146-14.42a3.35 3.35 0 0 0-.607-.541c-.013.076-.026.175-.041.254-.93 4.778-4.005 7.201-9.138 7.201h-2.19a.563.563 0 0 0-.556.479l-1.187 7.527h-.506l-.24 1.516a.56.56 0 0 0 .554.647h3.882c.46 0 .85-.334.922-.788.06-.26.76-4.852.816-5.09a.932.932 0 0 1 .923-.788h.58c3.76 0 6.705-1.528 7.565-5.946.36-1.847.174-3.388-.777-4.471z"/>
              </svg>
              <div class="text-left">
                <div class="font-semibold">PayPal</div>
                <div class="text-xs text-slate-500">International</div>
              </div>
            </button>
            
            <!-- KHQR (Cambodia Local) -->
            <button
              @click="showKHQRModal = true"
              class="group inline-flex items-center gap-3 rounded-lg border border-lime-300/20 bg-lime-300/10 px-6 py-3 text-lime-100 transition-all duration-300 hover:-translate-y-1 hover:border-lime-300/40 hover:bg-lime-300/15"
            >
              <img src="/khqr_logo.png" alt="KHQR" class="w-6 h-6 object-contain" />
              <div class="text-left">
                <div class="font-semibold">KHQR</div>
                <div class="text-xs text-slate-500">Cambodia</div>
              </div>
            </button>
          </div>
          <p class="text-xs text-slate-500 mt-4">
            Every contribution helps keep EyeBreak free and ad-free for everyone.
          </p>
        </div>
      </div>

      <!-- PayPal Donate Modal -->
      <Teleport to="body">
        <Transition name="modal">
          <div
            v-if="showDonateModal"
            class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/70 backdrop-blur-sm"
            @click="showDonateModal = false"
          >
            <div
              class="bg-gray-900 border border-gray-700 rounded-2xl max-w-md w-full p-8 shadow-2xl"
              @click.stop
            >
              <div class="flex justify-between items-start mb-6">
                <div>
                  <h3 class="text-2xl font-bold text-white mb-2">PayPal Donation</h3>
                  <p class="text-gray-400 text-sm">International supporters</p>
                </div>
                <button
                  @click="showDonateModal = false"
                  class="text-gray-400 hover:text-white transition-colors"
                >
                  <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                  </svg>
                </button>
              </div>

              <!-- PayPal QR Code -->
              <div class="bg-white p-6 rounded-xl mb-6 flex items-center justify-center">
                <img 
                  src="/paypal.png" 
                  alt="PayPal Donation QR Code"
                  class="w-64 h-64 object-contain"
                />
              </div>

              <p class="text-center text-gray-400 text-sm mb-6">
                Scan with your PayPal app or click the button below
              </p>

              <div class="flex gap-3">
                <a
                  :href="config.donation.paypalUrl"
                  target="_blank"
                  class="flex-1 px-4 py-3 bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition-colors text-center font-semibold"
                >
                  Donate via PayPal
                </a>
                <button
                  @click="showDonateModal = false"
                  class="px-4 py-3 bg-gray-800 hover:bg-gray-700 text-gray-300 rounded-lg transition-colors"
                >
                  Close
                </button>
              </div>
            </div>
          </div>
        </Transition>
      </Teleport>

      <!-- KHQR Modal -->
      <Teleport to="body">
        <Transition name="modal">
          <div
            v-if="showKHQRModal"
            class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/70 backdrop-blur-sm"
            @click="showKHQRModal = false"
          >
            <div
              class="bg-gray-900 border border-gray-700 rounded-2xl max-w-md w-full p-8 shadow-2xl"
              @click.stop
            >
              <div class="flex justify-between items-start mb-6">
                <div>
                  <h3 class="text-2xl font-bold text-white mb-2">KHQR Payment</h3>
                  <p class="text-gray-400 text-sm">For Cambodia supporters 🇰🇭</p>
                </div>
                <button
                  @click="showKHQRModal = false"
                  class="text-gray-400 hover:text-white transition-colors"
                >
                  <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                  </svg>
                </button>
              </div>

              <!-- KHQR Code -->
              <div class="bg-white p-6 rounded-xl mb-6 flex items-center justify-center">
                <img 
                  src="/khqr_pay.jpg" 
                  alt="KHQR Payment Code"
                  class="w-64 h-64 object-contain"
                />
              </div>

              <p class="text-center text-gray-400 text-sm mb-6">
                Scan with any Cambodian banking app (ABA, Wing, ACLEDA, etc.)
              </p>

              <div class="flex gap-3">
                <a
                  :href="config.donation.khqrUrl"
                  target="_blank"
                  class="flex-1 px-4 py-3 bg-green-600 hover:bg-green-700 text-white rounded-lg transition-colors text-center font-semibold"
                >
                  Pay via KHQR
                </a>
                <button
                  @click="showKHQRModal = false"
                  class="px-4 py-3 bg-gray-800 hover:bg-gray-700 text-gray-300 rounded-lg transition-colors"
                >
                  Close
                </button>
              </div>
            </div>
          </div>
        </Transition>
      </Teleport>

      <!-- Divider -->
      <div class="border-t border-white/10 my-12"></div>

      <!-- Bottom Footer -->
      <div class="flex flex-col md:flex-row justify-between items-center gap-6">
        <div class="text-slate-400 text-sm">
          <p>&copy; {{ currentYear }} EyeBreak. Released under the MIT License.</p>
        </div>

        <div class="flex items-center gap-6 text-sm text-slate-400">
          <button
            @click="router.push('/privacy')"
            class="hover:text-white transition-colors"
          >
            Privacy Policy
          </button>
          <span class="text-slate-700">/</span>
          <a
            :href="`${config.github.url}/blob/main/LICENSE`"
            target="_blank"
            class="hover:text-white transition-colors"
          >
            MIT License
          </a>
          <span class="text-slate-700">/</span>
          <button
            @click="scrollToTop"
            class="hover:text-white transition-colors flex items-center gap-2 group"
          >
            <span>Back to Top</span>
            <span class="group-hover:-translate-y-1 transition-transform">↑</span>
          </button>
        </div>
      </div>

      <!-- Version Badge -->
      <div class="mt-12 text-center">
        <span class="inline-block rounded-full border border-white/10 bg-white/5 px-6 py-3 text-sm text-slate-400 backdrop-blur-sm">
          v{{ config.app.version }} / macOS {{ config.requirements.macOSVersion }} / Universal Binary
        </span>
      </div>
    </div>
  </footer>
</template>

<style scoped>
a {
  text-decoration: none;
}

.footer-link {
  @apply inline-block cursor-pointer text-slate-400 transition-all hover:translate-x-1 hover:text-white;
}

.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.3s ease;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}

.modal-enter-active > div,
.modal-leave-active > div {
  transition: transform 0.3s ease;
}

.modal-enter-from > div,
.modal-leave-to > div {
  transform: scale(0.9);
}
</style>
