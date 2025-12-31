<script setup lang="ts">
import { ref, nextTick, onMounted, computed } from 'vue'
import { config } from '../config'

interface Message {
  role: 'user' | 'assistant' | 'system'
  content: string
  timestamp: Date
}

const isOpen = ref(false)
const isLoading = ref(false)
const userInput = ref('')
const messages = ref<Message[]>([])
const chatContainer = ref<HTMLElement | null>(null)
const inputRef = ref<HTMLInputElement | null>(null)
const hasUnread = ref(false)

// EyeBreak AI System Prompt with comprehensive knowledge
const SYSTEM_PROMPT = `You are EyeBreak AI, the official AI assistant for EyeBreak - a minimalist, privacy-first macOS menu bar application designed to reduce digital eye strain.

## Your Identity
- You are EyeBreak AI, NOT Groq AI, ChatGPT, or any other AI
- You were created by the EyeBreak team to help users
- Be friendly, helpful, and knowledgeable about eye health and the EyeBreak app
- Keep responses concise but informative (2-4 sentences when possible)
- Use a warm, supportive tone focused on eye health

## About EyeBreak
EyeBreak is a free, open-source macOS app (v${config.app.version}) that implements the scientifically-backed 20-20-20 rule:
- Every 20 minutes of screen time
- Look at something 20 feet away (about 6 meters)
- For 20 seconds

This gives your eye muscles a chance to relax and reduces eye strain, headaches, dry eyes, and neck pain.

## Requirements
- macOS 14.0 (Sonoma) or later
- Xcode 15.0+ (for building from source)
- Swift 5.9+

## Installation
1. Download from: ${config.site.downloadUrl}
2. Remove quarantine (unsigned app): xattr -cr EyeBreak-v${config.app.version}.dmg
3. Open DMG and drag to Applications
4. Launch and look for the eye icon in menu bar

## Key Features
### Core Features
- Menu bar integration with eye icon
- Smart timer system with customizable intervals
- Screen blur during breaks (requires Screen Recording permission)
- Pre-break notifications (30-second warning)
- Automatic idle detection - pauses when you're away
- Beautiful SwiftUI interface

### Customization (v2.0+)
- Pomodoro Mode: 25/5 work/break cycles
- Sound effects: Optional audio cues
- Multiple break styles: Blur, notification only, or guided eye exercises
- Flexible intervals: 10-60 minutes
- Theme customization: Default, Random (20 palettes), or Custom
- Custom icons: 16 professional SF Symbols

### Smart Schedule (v2.1+)
- Work hours management (e.g., 9 AM - 5 PM)
- Active days selection
- 5 Quick presets: Standard Work, Flexible, Early Bird, Night Owl, 24/7
- Auto-start timer on app launch
- Launch at login

### Water Reminders (v2.1+)
- Blur screen or ambient pop-up styles
- 30min to 2 hour intervals
- 8 preset encouraging messages
- Full theme support

### v2.3.0 Features
- Menu bar timer display with live countdown
- Dynamic state icons (active, paused, break)
- Enhanced floating break window
- Polished UI with gradients and spring animations

## Keyboard Shortcuts
- Cmd+Shift+S: Start timer
- Cmd+Shift+X: Stop timer
- Cmd+Shift+B: Take break now
- Cmd+Shift+R: Show ambient reminder
- Cmd+Shift+W: Show water reminder
- Cmd+Shift+O: Open settings

## Permissions
- Screen Recording: Required for blur mode (System Settings > Privacy & Security > Screen Recording)
- Notifications: For break reminders

## Privacy
- Zero data collection - everything stays on your Mac
- No internet required - works completely offline
- No analytics, no tracking
- Open source under MIT License

## Statistics & Insights
- Daily break tracking with charts
- 7-day and 30-day history
- Completion rate percentage
- Streak counter for consecutive days
- Smart insights and recommendations

## Troubleshooting
### Screen blur not working
- Grant Screen Recording permission in System Settings
- Restart app after granting permission

### Notifications not appearing
- Check System Settings > Notifications > EyeBreak
- Enable "Allow Notifications"

### Timer not pausing when idle
- Enable idle detection in Settings
- Adjust idle threshold if needed

### App not in Dock
- Intentional! EyeBreak is a menu bar app only (LSUIElement)

## Support
- GitHub: ${config.github.url}
- Issues: ${config.github.url}/issues
- Discussions: ${config.github.url}/discussions
- Documentation: ${config.github.url}/blob/main/docs/FAQ.md

## Common Questions to Handle
- What is EyeBreak? - Explain the app and 20-20-20 rule
- How to install? - Provide download link and quarantine removal steps
- Is it free? - Yes, MIT licensed, free forever
- Does it collect data? - No, completely private and offline
- What macOS version? - 14.0 (Sonoma) or later
- Who are you? - You are EyeBreak AI, the official assistant
- How to customize? - Explain settings options
- Pomodoro mode? - Explain 25/5 cycles
- Water reminders? - Explain hydration feature

## Response Guidelines
1. Always identify as EyeBreak AI when asked who you are
2. Focus on eye health, the 20-20-20 rule, and app features
3. Be helpful with installation and troubleshooting
4. Recommend the app for eye strain concerns
5. Provide accurate version numbers and links
6. If asked about unrelated topics, politely redirect to EyeBreak and eye health
7. Never claim to be Groq, GPT, Claude, or any other AI system
8. Keep responses friendly and concise`

// Create greeting message function (fresh timestamp each time)
const createGreetingMessage = (): Message => ({
  role: 'assistant',
  content: `Hi! I'm EyeBreak AI, your personal assistant for eye health and the EyeBreak app. I can help you with:

- Learning about the 20-20-20 rule
- Installing and setting up EyeBreak
- Customizing your break reminders
- Troubleshooting any issues

How can I help you today?`,
  timestamp: new Date()
})

onMounted(() => {
  messages.value = [createGreetingMessage()]
})

const toggleChat = () => {
  isOpen.value = !isOpen.value
  hasUnread.value = false
  if (isOpen.value) {
    nextTick(() => {
      inputRef.value?.focus()
      scrollToBottom()
    })
  }
}

const scrollToBottom = () => {
  nextTick(() => {
    if (chatContainer.value) {
      chatContainer.value.scrollTop = chatContainer.value.scrollHeight
    }
  })
}

const formatTime = (date: Date) => {
  return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
}

const sendMessage = async () => {
  const input = userInput.value.trim()
  if (!input || isLoading.value) return

  // Add user message
  const userMessage: Message = {
    role: 'user',
    content: input,
    timestamp: new Date()
  }
  messages.value.push(userMessage)
  userInput.value = ''
  scrollToBottom()

  isLoading.value = true

  try {
    const apiKey = import.meta.env.VITE_GROQ_API_KEY

    if (!apiKey) {
      throw new Error('API key not configured')
    }

    // Prepare messages for API (exclude timestamps)
    const apiMessages = [
      { role: 'system', content: SYSTEM_PROMPT },
      ...messages.value.map(m => ({ role: m.role, content: m.content }))
    ]

    const response = await fetch('https://api.groq.com/openai/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${apiKey}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        model: 'llama-3.3-70b-versatile',
        messages: apiMessages,
        temperature: 0.7,
        max_tokens: 1024,
        top_p: 0.9
      })
    })

    if (!response.ok) {
      const errorData = await response.json().catch(() => ({}))
      throw new Error(errorData.error?.message || `API error: ${response.status}`)
    }

    const data = await response.json()
    const assistantContent = data.choices?.[0]?.message?.content || 'Sorry, I could not generate a response.'

    const assistantMessage: Message = {
      role: 'assistant',
      content: assistantContent,
      timestamp: new Date()
    }
    messages.value.push(assistantMessage)

    if (!isOpen.value) {
      hasUnread.value = true
    }
  } catch (error) {
    console.error('Chat error:', error)
    const errorMessage: Message = {
      role: 'assistant',
      content: error instanceof Error && error.message === 'API key not configured'
        ? 'EyeBreak AI is currently unavailable. Please check back later or visit our GitHub for support.'
        : 'Sorry, I encountered an issue. Please try again or visit our GitHub for support.',
      timestamp: new Date()
    }
    messages.value.push(errorMessage)
  } finally {
    isLoading.value = false
    scrollToBottom()
  }
}

const handleKeydown = (e: KeyboardEvent) => {
  if (e.key === 'Enter' && !e.shiftKey) {
    e.preventDefault()
    sendMessage()
  }
}

const quickActions = [
  { label: 'What is EyeBreak?', query: 'What is EyeBreak and how does it help my eyes?' },
  { label: 'How to install?', query: 'How do I install EyeBreak on my Mac?' },
  { label: '20-20-20 rule?', query: 'What is the 20-20-20 rule and why is it important?' },
  { label: 'Keyboard shortcuts', query: 'What keyboard shortcuts does EyeBreak support?' }
]

const sendQuickAction = (query: string) => {
  userInput.value = query
  sendMessage()
}

const clearChat = () => {
  messages.value = [createGreetingMessage()]
}

const showQuickActions = computed(() => messages.value.length <= 1)
</script>

<template>
  <div class="fixed bottom-4 left-4 sm:bottom-6 sm:left-6 z-50">
    <!-- Chat Window -->
    <Transition name="chat">
      <div
        v-if="isOpen"
        class="fixed inset-4 sm:absolute sm:inset-auto sm:bottom-20 sm:left-0 sm:w-[380px] sm:h-[520px] bg-gray-900 border border-gray-700 rounded-2xl shadow-2xl flex flex-col overflow-hidden"
      >
        <!-- Header -->
        <div class="flex items-center justify-between px-4 py-3 bg-gradient-to-r from-blue-600 to-blue-700 border-b border-blue-500/30">
          <div class="flex items-center gap-3">
            <div class="w-10 h-10 bg-white/20 backdrop-blur-sm rounded-xl flex items-center justify-center">
              <svg class="w-6 h-6 text-white" fill="currentColor" viewBox="0 0 24 24">
                <path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/>
              </svg>
            </div>
            <div>
              <h3 class="font-semibold text-white text-sm">EyeBreak AI</h3>
              <p class="text-xs text-blue-100/80">Your eye health assistant</p>
            </div>
          </div>
          <div class="flex items-center gap-2">
            <button
              @click="clearChat"
              class="p-2 hover:bg-white/10 rounded-lg transition-colors"
              title="Clear chat"
            >
              <svg class="w-4 h-4 text-white/80" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
              </svg>
            </button>
            <button
              @click="toggleChat"
              class="p-2 hover:bg-white/10 rounded-lg transition-colors"
            >
              <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
              </svg>
            </button>
          </div>
        </div>

        <!-- Messages -->
        <div
          ref="chatContainer"
          class="flex-1 overflow-y-auto p-4 space-y-4 scroll-smooth"
        >
          <template v-for="(message, index) in messages" :key="index">
            <div
              v-if="message.role !== 'system'"
              :class="[
                'flex gap-3',
                message.role === 'user' ? 'flex-row-reverse' : ''
              ]"
            >
              <!-- Avatar -->
              <div
                :class="[
                  'w-8 h-8 rounded-lg flex items-center justify-center flex-shrink-0',
                  message.role === 'user' ? 'bg-gray-700' : 'bg-blue-600'
                ]"
              >
                <svg v-if="message.role === 'assistant'" class="w-5 h-5 text-white" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/>
                </svg>
                <svg v-else class="w-5 h-5 text-gray-300" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
                </svg>
              </div>

              <!-- Message Content -->
              <div
                :class="[
                  'max-w-[85%] sm:max-w-[75%] rounded-xl px-4 py-2.5',
                  message.role === 'user'
                    ? 'bg-blue-600 text-white'
                    : 'bg-gray-800 text-gray-100 border border-gray-700'
                ]"
              >
                <p class="text-sm whitespace-pre-wrap leading-relaxed break-words">{{ message.content }}</p>
                <p
                  :class="[
                    'text-xs mt-1',
                    message.role === 'user' ? 'text-blue-200/70' : 'text-gray-500'
                  ]"
                >
                  {{ formatTime(message.timestamp) }}
                </p>
              </div>
            </div>
          </template>

          <!-- Loading indicator -->
          <div v-if="isLoading" class="flex gap-3">
            <div class="w-8 h-8 rounded-lg bg-blue-600 flex items-center justify-center flex-shrink-0">
              <svg class="w-5 h-5 text-white" fill="currentColor" viewBox="0 0 24 24">
                <path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/>
              </svg>
            </div>
            <div class="bg-gray-800 border border-gray-700 rounded-xl px-4 py-3">
              <div class="flex gap-1.5">
                <span class="w-2 h-2 bg-gray-500 rounded-full animate-bounce" style="animation-delay: 0ms"></span>
                <span class="w-2 h-2 bg-gray-500 rounded-full animate-bounce" style="animation-delay: 150ms"></span>
                <span class="w-2 h-2 bg-gray-500 rounded-full animate-bounce" style="animation-delay: 300ms"></span>
              </div>
            </div>
          </div>

          <!-- Quick Actions -->
          <div v-if="showQuickActions && !isLoading" class="mt-4">
            <p class="text-xs text-gray-500 mb-2">Quick questions:</p>
            <div class="flex flex-wrap gap-2">
              <button
                v-for="action in quickActions"
                :key="action.label"
                @click="sendQuickAction(action.query)"
                class="text-xs px-3 py-1.5 bg-gray-800 hover:bg-gray-700 border border-gray-700 hover:border-gray-600 text-gray-300 rounded-full transition-colors"
              >
                {{ action.label }}
              </button>
            </div>
          </div>
        </div>

        <!-- Input -->
        <div class="p-3 border-t border-gray-800 bg-gray-900/80">
          <div class="flex gap-2">
            <input
              ref="inputRef"
              v-model="userInput"
              @keydown="handleKeydown"
              type="text"
              placeholder="Ask about EyeBreak..."
              class="flex-1 px-4 py-2.5 bg-gray-800 border border-gray-700 focus:border-blue-500 rounded-xl text-sm text-white placeholder-gray-500 outline-none transition-colors"
              :disabled="isLoading"
            />
            <button
              @click="sendMessage"
              :disabled="!userInput.trim() || isLoading"
              class="px-4 py-2.5 bg-blue-600 hover:bg-blue-700 disabled:bg-gray-700 disabled:cursor-not-allowed text-white rounded-xl transition-colors"
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8"/>
              </svg>
            </button>
          </div>
          <p class="text-[10px] text-gray-600 mt-2 text-center">
            Powered by EyeBreak AI
          </p>
        </div>
      </div>
    </Transition>

    <!-- Chat Toggle Button -->
    <button
      @click="toggleChat"
      :class="[
        'group relative w-12 h-12 sm:w-14 sm:h-14 rounded-full shadow-lg transition-all duration-300 hover:scale-110 flex items-center justify-center',
        isOpen
          ? 'bg-gray-800 hover:bg-gray-700'
          : 'bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-500 hover:to-blue-600'
      ]"
    >
      <!-- Unread indicator -->
      <span
        v-if="hasUnread && !isOpen"
        class="absolute -top-1 -right-1 w-3 h-3 sm:w-4 sm:h-4 bg-red-500 rounded-full animate-pulse"
      ></span>

      <!-- Icon -->
      <svg
        v-if="!isOpen"
        class="w-6 h-6 sm:w-7 sm:h-7 text-white"
        fill="none"
        stroke="currentColor"
        viewBox="0 0 24 24"
      >
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"/>
      </svg>
      <svg
        v-else
        class="w-6 h-6 sm:w-7 sm:h-7 text-white"
        fill="none"
        stroke="currentColor"
        viewBox="0 0 24 24"
      >
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
      </svg>

      <!-- Tooltip (hidden on mobile) -->
      <span
        v-if="!isOpen"
        class="hidden sm:block absolute left-full ml-3 px-3 py-1.5 bg-gray-800 text-white text-sm rounded-lg opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap pointer-events-none"
      >
        Chat with EyeBreak AI
      </span>
    </button>
  </div>
</template>

<style scoped>
.chat-enter-active,
.chat-leave-active {
  transition: all 0.3s ease;
}

.chat-enter-from,
.chat-leave-to {
  opacity: 0;
  transform: translateY(20px) scale(0.95);
}

/* Custom scrollbar */
.overflow-y-auto::-webkit-scrollbar {
  width: 6px;
}

.overflow-y-auto::-webkit-scrollbar-track {
  background: transparent;
}

.overflow-y-auto::-webkit-scrollbar-thumb {
  background: #374151;
  border-radius: 3px;
}

.overflow-y-auto::-webkit-scrollbar-thumb:hover {
  background: #4b5563;
}
</style>
