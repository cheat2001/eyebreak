<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'

const videoRef = ref<HTMLVideoElement | null>(null)
const videoContainerRef = ref<HTMLElement | null>(null)
const isPlaying = ref(false)
const showControls = ref(false)
const hasAutoPlayed = ref(false)
const animateIn = ref(false)
const isLoading = ref(true)
const loadProgress = ref(0)
const canPlayThrough = ref(false)
const mouseX = ref(0)
const mouseY = ref(0)

const handleMouseMove = (e: MouseEvent) => {
  if (videoContainerRef.value) {
    const rect = videoContainerRef.value.getBoundingClientRect()
    mouseX.value = e.clientX - rect.left
    mouseY.value = e.clientY - rect.top
  }
}

const togglePlay = () => {
  if (videoRef.value) {
    if (videoRef.value.paused) {
      videoRef.value.play()
      isPlaying.value = true
    } else {
      videoRef.value.pause()
      isPlaying.value = false
    }
  }
}

const handleOverlayClick = (e: MouseEvent) => {
  e.stopPropagation()
  togglePlay()
}

let observer: IntersectionObserver | null = null

onMounted(() => {
  if (videoRef.value) {
    // Video event listeners
    videoRef.value.addEventListener('play', () => {
      isPlaying.value = true
    })
    videoRef.value.addEventListener('pause', () => {
      isPlaying.value = false
    })
    videoRef.value.addEventListener('ended', () => {
      isPlaying.value = false
    })
    
    // Loading state listeners
    videoRef.value.addEventListener('loadstart', () => {
      isLoading.value = true
      loadProgress.value = 0
    })
    
    videoRef.value.addEventListener('progress', () => {
      if (videoRef.value) {
        const buffered = videoRef.value.buffered
        if (buffered.length > 0) {
          const loadedPercentage = (buffered.end(0) / videoRef.value.duration) * 100
          loadProgress.value = Math.round(loadedPercentage)
        }
      }
    })
    
    videoRef.value.addEventListener('canplay', () => {
      isLoading.value = false
    })
    
    videoRef.value.addEventListener('canplaythrough', () => {
      canPlayThrough.value = true
      isLoading.value = false
    })
    
    videoRef.value.addEventListener('waiting', () => {
      isLoading.value = true
    })
    
    videoRef.value.addEventListener('playing', () => {
      isLoading.value = false
    })
  }

  // Set up Intersection Observer for autoplay and animations
  if (videoContainerRef.value) {
    observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            // Trigger animations
            setTimeout(() => {
              animateIn.value = true
            }, 100)
            
            // Autoplay video
            if (!hasAutoPlayed.value && videoRef.value) {
              setTimeout(() => {
                // Only autoplay if video has buffered enough
                if (canPlayThrough.value || loadProgress.value > 25) {
                  videoRef.value?.play().then(() => {
                    hasAutoPlayed.value = true
                    isPlaying.value = true
                  }).catch((error) => {
                    console.log('Autoplay prevented:', error)
                  })
                }
              }, 600)
            }
          }
        })
        },
        {
          threshold: 0.15
        }
      )

      observer.observe(videoContainerRef.value)
  }
})

onUnmounted(() => {
  if (observer && videoContainerRef.value) {
    observer.unobserve(videoContainerRef.value)
    observer.disconnect()
  }
})
</script>

<template>
  <section class="video-showcase py-24 px-4 bg-gradient-to-b from-gray-950 via-gray-900 to-gray-950 relative overflow-hidden">
    <!-- Background effects -->
    <div class="absolute top-1/2 left-1/4 w-96 h-96 bg-blue-600/10 rounded-full blur-3xl"></div>
    <div class="absolute top-1/2 right-1/4 w-96 h-96 bg-purple-600/10 rounded-full blur-3xl"></div>
    
    <div class="container mx-auto max-w-7xl relative z-10">
      <!-- Section Header -->
      <div 
        class="text-center mb-16 transition-all duration-1000"
        :class="animateIn ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-10'"
      >
        <div class="inline-flex items-center gap-3 mb-4">
          <svg 
            class="w-10 h-10 text-blue-500 transition-transform duration-700"
            :class="animateIn ? 'scale-100 rotate-0' : 'scale-0 -rotate-180'"
            fill="currentColor" 
            viewBox="0 0 24 24"
          >
            <path d="M8 5v14l11-7z"/>
          </svg>
          <h2 class="text-4xl md:text-5xl font-bold bg-gradient-to-r from-white to-gray-300 bg-clip-text text-transparent">
            See EyeBreak in Action
          </h2>
        </div>
        <p class="text-xl text-gray-400 max-w-3xl mx-auto leading-relaxed">
          Watch how EyeBreak seamlessly integrates into your workflow to protect your eyes and boost productivity
        </p>
      </div>

      <!-- Video Container -->
      <div 
        ref="videoContainerRef"
        class="relative max-w-5xl mx-auto transition-all duration-1000 delay-200"
        :class="animateIn ? 'opacity-100 scale-100' : 'opacity-0 scale-95'"
        @mousemove="handleMouseMove"
      >
        <!-- Animated glow effect behind video -->
        <div 
          class="absolute inset-0 bg-gradient-to-r from-blue-600/20 via-purple-600/20 to-pink-600/20 blur-3xl scale-110 transition-all duration-1000"
          :class="isPlaying ? 'animate-pulse-glow' : ''"
        ></div>
        
        <!-- Interactive cursor glow -->
        <div 
          class="hidden lg:block absolute w-64 h-64 bg-blue-500/30 rounded-full blur-3xl pointer-events-none transition-opacity duration-300"
          :style="{
            left: `${mouseX}px`,
            top: `${mouseY}px`,
            transform: 'translate(-50%, -50%)',
            opacity: animateIn ? 0.5 : 0
          }"
        ></div>
        
        <!-- Floating particles effect -->
        <div class="absolute inset-0 overflow-hidden pointer-events-none">
          <div 
            v-for="i in 5" 
            :key="i"
            class="particle"
            :style="{
              left: `${Math.random() * 100}%`,
              animationDelay: `${Math.random() * 3}s`,
              animationDuration: `${3 + Math.random() * 4}s`
            }"
          ></div>
        </div>
        
        <!-- Main video card -->
        <div 
          class="relative bg-gray-900/50 backdrop-blur-xl rounded-3xl border overflow-hidden shadow-2xl group transition-all duration-500"
          :class="[
            isPlaying ? 'border-blue-500/50 shadow-blue-500/20' : 'border-gray-800/50',
            animateIn ? 'hover:scale-[1.01]' : ''
          ]"
          @mouseenter="showControls = true"
          @mouseleave="showControls = false"
        >
          <!-- Video element -->
          <div class="relative aspect-video bg-gray-950">
            <!-- Video thumbnail/poster while loading -->
            <div 
              v-if="isLoading" 
              class="absolute inset-0 flex items-center justify-center bg-gradient-to-br from-gray-900 to-gray-950"
            >
              <div class="text-center">
                <!-- Loading spinner -->
                <div class="relative w-24 h-24 mx-auto mb-6">
                  <div class="absolute inset-0 border-4 border-blue-500/20 rounded-full"></div>
                  <div class="absolute inset-0 border-4 border-transparent border-t-blue-500 rounded-full animate-spin"></div>
                  <div class="absolute inset-0 flex items-center justify-center">
                    <svg class="w-10 h-10 text-blue-500" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M8 5v14l11-7z"/>
                    </svg>
                  </div>
                </div>
                
                <!-- Loading text and progress -->
                <div class="space-y-3">
                  <p class="text-white font-semibold text-lg">Loading Video...</p>
                  <div class="w-64 mx-auto">
                    <div class="w-full bg-gray-800 rounded-full h-2 overflow-hidden">
                      <div 
                        class="bg-gradient-to-r from-blue-500 to-purple-500 h-full transition-all duration-300 ease-out"
                        :style="{ width: `${loadProgress}%` }"
                      ></div>
                    </div>
                    <p class="text-gray-400 text-sm mt-2">{{ loadProgress }}%</p>
                  </div>
                  <p class="text-gray-500 text-xs mt-2">High quality video • {{ (53).toFixed(0) }}MB</p>
                </div>
              </div>
            </div>
            
            <video
              ref="videoRef"
              class="w-full h-full object-contain cursor-pointer transition-opacity duration-500"
              :class="{ 'opacity-0': isLoading, 'opacity-100': !isLoading }"
              controls
              preload="metadata"
              muted
              playsinline
              poster=""
            >
              <source src="../assets/videos/eyebreak video.mov" type="video/quicktime">
              <source src="../assets/videos/eyebreak video.mov" type="video/mp4">
              Your browser does not support the video tag.
            </video>
            
            <!-- Play overlay (shows when video is paused and loaded) -->
            <div 
              v-if="!isPlaying && !isLoading"
              class="absolute inset-0 flex items-center justify-center bg-black/30 backdrop-blur-sm transition-all duration-500 cursor-pointer group-hover:bg-black/40"
              @click="handleOverlayClick"
            >
              <div class="relative">
                <!-- Multiple pulse rings -->
                <div class="absolute inset-0 bg-blue-500 rounded-full animate-ping opacity-75"></div>
                <div class="absolute inset-0 bg-purple-500 rounded-full animate-ping opacity-50" style="animation-delay: 0.5s"></div>
                <div class="absolute inset-0 bg-pink-500 rounded-full animate-ping opacity-25" style="animation-delay: 1s"></div>
                
                <!-- Play button with enhanced 3D effects -->
                <div class="relative w-28 h-28 bg-gradient-to-br from-blue-500 via-purple-500 to-pink-500 rounded-full flex items-center justify-center shadow-2xl transform group-hover:scale-125 group-hover:rotate-12 transition-all duration-500 animate-float" style="transform-style: preserve-3d;">
                  <div class="absolute inset-0 bg-gradient-to-br from-blue-400 to-purple-600 rounded-full blur-xl opacity-50 group-hover:opacity-75 transition-opacity"></div>
                  <svg class="w-14 h-14 text-white ml-1 relative z-10 drop-shadow-2xl" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M8 5v14l11-7z"/>
                  </svg>
                </div>
                
                <!-- Animated text below button - Hidden on mobile -->
                <div class="hidden md:block absolute -bottom-16 left-1/2 -translate-x-1/2 whitespace-nowrap">
                  <p class="text-white font-semibold text-lg animate-bounce">Click to Play</p>
                </div>
              </div>
            </div>
            
            <!-- Now Playing indicator - Hidden on mobile to avoid covering video content -->
            <div 
              v-if="isPlaying"
              class="hidden md:flex absolute top-6 right-6 items-center gap-2 px-4 py-2 bg-gradient-to-r from-green-500/90 to-emerald-500/90 backdrop-blur-md rounded-full shadow-lg animate-slide-in-right"
            >
              <div class="flex gap-1">
                <div class="w-1 h-4 bg-white rounded-full animate-sound-wave" style="animation-delay: 0s"></div>
                <div class="w-1 h-4 bg-white rounded-full animate-sound-wave" style="animation-delay: 0.2s"></div>
                <div class="w-1 h-4 bg-white rounded-full animate-sound-wave" style="animation-delay: 0.4s"></div>
              </div>
              <span class="text-white font-semibold text-sm">Now Playing</span>
            </div>
          </div>

          <!-- Video info bar -->
          <div class="px-4 md:px-8 py-6 bg-gray-900/80 backdrop-blur-sm border-t border-gray-800/50">
            <div class="flex items-center justify-between flex-wrap gap-4">
              <!-- Now Playing indicator for mobile - shows in info bar instead -->
              <div 
                v-if="isPlaying"
                class="md:hidden flex items-center gap-2 px-3 py-1.5 bg-gradient-to-r from-green-500/90 to-emerald-500/90 backdrop-blur-md rounded-full shadow-lg animate-slide-in-right order-first w-full justify-center sm:w-auto sm:order-none"
              >
                <div class="flex gap-1">
                  <div class="w-1 h-3 bg-white rounded-full animate-sound-wave" style="animation-delay: 0s"></div>
                  <div class="w-1 h-3 bg-white rounded-full animate-sound-wave" style="animation-delay: 0.2s"></div>
                  <div class="w-1 h-3 bg-white rounded-full animate-sound-wave" style="animation-delay: 0.4s"></div>
                </div>
                <span class="text-white font-semibold text-xs">Now Playing</span>
              </div>
              
              <div class="flex items-center gap-3">
                <div class="w-12 h-12 bg-gradient-to-br from-blue-600 to-blue-700 rounded-xl flex items-center justify-center shadow-lg">
                  <svg class="w-7 h-7 text-white" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/>
                  </svg>
                </div>
                <div>
                  <h3 class="text-lg font-semibold text-white">Full App Demo</h3>
                  <p class="text-sm text-gray-400">Complete walkthrough of all features</p>
                </div>
              </div>
              
              <!-- Feature highlights -->
              <div class="flex gap-2 flex-wrap">
                <span 
                  class="px-4 py-2 bg-blue-600/20 border border-blue-500/30 text-blue-300 rounded-full text-sm font-medium backdrop-blur-sm transition-all duration-300 hover:bg-blue-600/30 hover:border-blue-500/50 cursor-default"
                >
                  Break Timer
                </span>
                <span 
                  class="px-4 py-2 bg-cyan-600/20 border border-cyan-500/30 text-cyan-300 rounded-full text-sm font-medium backdrop-blur-sm transition-all duration-300 hover:bg-cyan-600/30 hover:border-cyan-500/50 cursor-default"
                >
                  Hydration
                </span>
                <span 
                  class="px-4 py-2 bg-purple-600/20 border border-purple-500/30 text-purple-300 rounded-full text-sm font-medium backdrop-blur-sm transition-all duration-300 hover:bg-purple-600/30 hover:border-purple-500/50 cursor-default"
                >
                  Themes
                </span>
              </div>
            </div>
          </div>
        </div>

        <!-- Feature callouts with staggered animation -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mt-12">
          <div 
            class="text-center p-6 bg-gray-900/40 backdrop-blur-xl rounded-2xl border border-gray-800/50 hover:border-green-500/50 transition-all duration-500 group transform hover:-translate-y-2"
            :class="animateIn ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-10'"
            style="transition-delay: 0.4s"
          >
            <div class="w-14 h-14 bg-gradient-to-br from-green-500 to-green-600 rounded-2xl flex items-center justify-center mx-auto mb-4 group-hover:scale-110 group-hover:rotate-6 transition-all duration-500 shadow-lg group-hover:shadow-green-500/50">
              <svg class="w-8 h-8 text-white" fill="currentColor" viewBox="0 0 24 24">
                <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
              </svg>
            </div>
            <h4 class="text-lg font-semibold text-white mb-2 group-hover:text-green-400 transition-colors">Easy to Use</h4>
            <p class="text-gray-400 text-sm group-hover:text-gray-300 transition-colors">Simple, intuitive interface that just works</p>
          </div>

          <div 
            class="text-center p-6 bg-gray-900/40 backdrop-blur-xl rounded-2xl border border-gray-800/50 hover:border-purple-500/50 transition-all duration-500 group transform hover:-translate-y-2"
            :class="animateIn ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-10'"
            style="transition-delay: 0.6s"
          >
            <div class="w-14 h-14 bg-gradient-to-br from-purple-500 to-purple-600 rounded-2xl flex items-center justify-center mx-auto mb-4 group-hover:scale-110 group-hover:rotate-6 transition-all duration-500 shadow-lg group-hover:shadow-purple-500/50">
              <svg class="w-8 h-8 text-white" fill="currentColor" viewBox="0 0 24 24">
                <path d="M12 2L4.5 20.29l.71.71L12 18l6.79 3 .71-.71z"/>
              </svg>
            </div>
            <h4 class="text-lg font-semibold text-white mb-2 group-hover:text-purple-400 transition-colors">Non-Intrusive</h4>
            <p class="text-gray-400 text-sm group-hover:text-gray-300 transition-colors">Gentle reminders that respect your workflow</p>
          </div>

          <div 
            class="text-center p-6 bg-gray-900/40 backdrop-blur-xl rounded-2xl border border-gray-800/50 hover:border-pink-500/50 transition-all duration-500 group transform hover:-translate-y-2"
            :class="animateIn ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-10'"
            style="transition-delay: 0.8s"
          >
            <div class="w-14 h-14 bg-gradient-to-br from-pink-500 to-pink-600 rounded-2xl flex items-center justify-center mx-auto mb-4 group-hover:scale-110 group-hover:rotate-6 transition-all duration-500 shadow-lg group-hover:shadow-pink-500/50">
              <svg class="w-8 h-8 text-white" fill="currentColor" viewBox="0 0 24 24">
                <path d="M12 22C6.49 22 2 17.51 2 12S6.49 2 12 2s10 4.04 10 9c0 3.31-2.69 6-6 6h-1.77c-.28 0-.5.22-.5.5 0 .12.05.23.13.33.41.47.64 1.06.64 1.67A2.5 2.5 0 0112 22zm0-18c-4.41 0-8 3.59-8 8s3.59 8 8 8c.28 0 .5-.22.5-.5a.54.54 0 00-.14-.35c-.41-.46-.63-1.05-.63-1.65a2.5 2.5 0 012.5-2.5H16c2.21 0 4-1.79 4-4 0-3.86-3.59-7-8-7z M6.5 11.5a1.5 1.5 0 110-3 1.5 1.5 0 010 3zm3-4a1.5 1.5 0 110-3 1.5 1.5 0 010 3zm5 0a1.5 1.5 0 110-3 1.5 1.5 0 010 3zm3 4a1.5 1.5 0 110-3 1.5 1.5 0 010 3z"/>
              </svg>
            </div>
            <h4 class="text-lg font-semibold text-white mb-2 group-hover:text-pink-400 transition-colors">Fully Customizable</h4>
            <p class="text-gray-400 text-sm group-hover:text-gray-300 transition-colors">Tailor every aspect to your preferences</p>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
.video-showcase {
  position: relative;
}

/* Pulsing glow animation */
@keyframes pulse-glow {
  0%, 100% {
    opacity: 0.2;
    transform: scale(1.1);
  }
  50% {
    opacity: 0.4;
    transform: scale(1.15);
  }
}

.animate-pulse-glow {
  animation: pulse-glow 3s ease-in-out infinite;
}

/* Enhanced ping animation */
@keyframes ping {
  75%, 100% {
    transform: scale(2.5);
    opacity: 0;
  }
}

.animate-ping {
  animation: ping 2s cubic-bezier(0, 0, 0.2, 1) infinite;
}

/* Floating animation */
@keyframes float {
  0%, 100% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(-15px);
  }
}

.animate-float {
  animation: float 3s ease-in-out infinite;
}

/* Sound wave animation */
@keyframes sound-wave {
  0%, 100% {
    transform: scaleY(0.5);
  }
  50% {
    transform: scaleY(1.5);
  }
}

.animate-sound-wave {
  animation: sound-wave 1s ease-in-out infinite;
}

/* Slide in from right */
@keyframes slide-in-right {
  from {
    transform: translateX(100px);
    opacity: 0;
  }
  to {
    transform: translateX(0);
    opacity: 1;
  }
}

.animate-slide-in-right {
  animation: slide-in-right 0.5s ease-out;
}

/* Floating particles */
.particle {
  position: absolute;
  width: 4px;
  height: 4px;
  background: radial-gradient(circle, rgba(96, 165, 250, 0.8) 0%, rgba(147, 51, 234, 0) 70%);
  border-radius: 50%;
  pointer-events: none;
  animation: particle-float linear infinite;
}

@keyframes particle-float {
  0% {
    transform: translateY(100vh) translateX(0) scale(0);
    opacity: 0;
  }
  10% {
    opacity: 1;
  }
  90% {
    opacity: 1;
  }
  100% {
    transform: translateY(-100px) translateX(100px) scale(1);
    opacity: 0;
  }
}

/* Custom video controls styling */
video::-webkit-media-controls-panel {
  background: linear-gradient(to bottom, rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.8));
}

video::-webkit-media-controls-play-button,
video::-webkit-media-controls-timeline,
video::-webkit-media-controls-current-time-display,
video::-webkit-media-controls-time-remaining-display,
video::-webkit-media-controls-mute-button,
video::-webkit-media-controls-volume-slider {
  filter: brightness(1.2);
}
</style>
