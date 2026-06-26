<script setup lang="ts">
import { ref, nextTick, onMounted, computed } from 'vue'

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
const chatApiUrl = import.meta.env.VITE_CHAT_API_URL

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
    if (!chatApiUrl) {
      throw new Error('Chat API URL not configured')
    }

    const apiMessages = messages.value
      .filter(message => message.role !== 'system')
      .map(message => ({
        role: message.role,
        content: message.content
      }))

    const response = await fetch(chatApiUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        messages: apiMessages
      })
    })

    if (!response.ok) {
      const errorData = await response.json().catch(() => ({}))
      throw new Error(errorData.error?.message || `API error: ${response.status}`)
    }

    const data = await response.json()
    const assistantContent = data.content || 'Sorry, I could not generate a response.'

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
      content: 'Sorry, I encountered an issue. Please try again or visit our GitHub for support.',
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
  <div class="fixed bottom-4 left-4 z-50 sm:bottom-6 sm:left-6">
    <!-- Chat Window -->
    <Transition name="chat">
      <div
        v-if="isOpen"
        class="fixed inset-x-3 bottom-3 top-20 flex flex-col overflow-hidden rounded-[1.5rem] border border-white/10 bg-slate-950 shadow-2xl shadow-black/50 sm:absolute sm:inset-auto sm:bottom-20 sm:left-0 sm:h-[540px] sm:w-[390px]"
      >
        <!-- Header -->
        <div class="flex items-center justify-between border-b border-white/10 bg-slate-900 px-4 py-3">
          <div class="flex items-center gap-3">
            <div class="flex h-11 w-11 items-center justify-center rounded-lg bg-cyan-300 text-slate-950 shadow-lg shadow-cyan-950/30">
              <svg class="h-6 w-6" fill="currentColor" viewBox="0 0 24 24">
                <path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/>
              </svg>
            </div>
            <div>
              <h3 class="text-sm font-black text-white">EyeBreak AI</h3>
              <p class="text-xs font-medium text-slate-400">Eye health assistant</p>
            </div>
          </div>
          <div class="flex items-center gap-2">
            <button
              @click="clearChat"
              class="rounded-lg p-2 text-slate-400 transition-colors hover:bg-white/10 hover:text-white"
              title="Clear chat"
            >
              <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
              </svg>
            </button>
            <button
              @click="toggleChat"
              class="rounded-lg p-2 text-slate-300 transition-colors hover:bg-white/10 hover:text-white"
            >
              <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
              </svg>
            </button>
          </div>
        </div>

        <!-- Messages -->
        <div
          ref="chatContainer"
          class="flex-1 space-y-4 overflow-y-auto bg-slate-950 p-4 scroll-smooth"
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
                  message.role === 'user' ? 'bg-slate-700 text-slate-200' : 'bg-cyan-300 text-slate-950'
                ]"
              >
                <svg v-if="message.role === 'assistant'" class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/>
                </svg>
                <svg v-else class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
                </svg>
              </div>

              <!-- Message Content -->
              <div
                :class="[
                  'max-w-[85%] sm:max-w-[75%] rounded-xl px-4 py-2.5',
                  message.role === 'user'
                    ? 'bg-cyan-300 text-slate-950'
                    : 'border border-white/10 bg-slate-900 text-slate-100'
                ]"
              >
                <p class="text-sm whitespace-pre-wrap leading-relaxed break-words">{{ message.content }}</p>
                <p
                  :class="[
                    'text-xs mt-1',
                    message.role === 'user' ? 'text-slate-700' : 'text-slate-500'
                  ]"
                >
                  {{ formatTime(message.timestamp) }}
                </p>
              </div>
            </div>
          </template>

          <!-- Loading indicator -->
          <div v-if="isLoading" class="flex gap-3">
            <div class="flex h-8 w-8 flex-shrink-0 items-center justify-center rounded-lg bg-cyan-300 text-slate-950">
              <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24">
                <path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/>
              </svg>
            </div>
            <div class="rounded-xl border border-white/10 bg-slate-900 px-4 py-3">
              <div class="flex gap-1.5">
                <span class="h-2 w-2 animate-bounce rounded-full bg-cyan-300" style="animation-delay: 0ms"></span>
                <span class="h-2 w-2 animate-bounce rounded-full bg-cyan-300" style="animation-delay: 150ms"></span>
                <span class="h-2 w-2 animate-bounce rounded-full bg-cyan-300" style="animation-delay: 300ms"></span>
              </div>
            </div>
          </div>

          <!-- Quick Actions -->
          <div v-if="showQuickActions && !isLoading" class="mt-4">
            <p class="mb-2 text-xs font-semibold uppercase tracking-[0.16em] text-slate-500">Quick questions</p>
            <div class="flex flex-wrap gap-2">
              <button
                v-for="action in quickActions"
                :key="action.label"
                @click="sendQuickAction(action.query)"
                class="rounded-full border border-cyan-300/20 bg-cyan-300/10 px-3 py-1.5 text-xs font-semibold text-cyan-100 transition-colors hover:bg-cyan-300/15"
              >
                {{ action.label }}
              </button>
            </div>
          </div>
        </div>

        <!-- Input -->
        <div class="border-t border-white/10 bg-slate-900 p-3">
          <div class="flex gap-2">
            <input
              ref="inputRef"
              v-model="userInput"
              @keydown="handleKeydown"
              type="text"
              placeholder="Ask about EyeBreak..."
              class="min-w-0 flex-1 rounded-xl border border-white/10 bg-slate-950 px-4 py-2.5 text-sm text-white placeholder-slate-500 outline-none transition-colors focus:border-cyan-300/70"
              :disabled="isLoading"
            />
            <button
              @click="sendMessage"
              :disabled="!userInput.trim() || isLoading"
              class="rounded-xl bg-cyan-300 px-4 py-2.5 text-slate-950 transition-colors hover:bg-cyan-200 disabled:cursor-not-allowed disabled:bg-slate-700 disabled:text-slate-400"
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8"/>
              </svg>
            </button>
          </div>
          <p class="mt-2 text-center text-[10px] text-slate-600">
            Powered by EyeBreak AI
          </p>
        </div>
      </div>
    </Transition>

    <!-- Chat Toggle Button -->
    <button
      @click="toggleChat"
      :class="[
        'group relative flex h-12 w-12 items-center justify-center rounded-full shadow-lg transition-all duration-300 hover:scale-110 sm:h-14 sm:w-14',
        isOpen
          ? 'border border-white/10 bg-slate-900 text-white hover:bg-slate-800'
          : 'bg-cyan-300 text-slate-950 hover:bg-cyan-200'
      ]"
      aria-label="Chat with EyeBreak AI"
    >
      <!-- Unread indicator -->
      <span
        v-if="hasUnread && !isOpen"
        class="absolute -right-1 -top-1 h-3 w-3 animate-pulse rounded-full bg-lime-300 sm:h-4 sm:w-4"
      ></span>

      <!-- Icon -->
      <svg
        v-if="!isOpen"
        class="h-6 w-6 sm:h-7 sm:w-7"
        fill="none"
        stroke="currentColor"
        viewBox="0 0 24 24"
      >
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"/>
      </svg>
      <svg
        v-else
        class="h-6 w-6 sm:h-7 sm:w-7"
        fill="none"
        stroke="currentColor"
        viewBox="0 0 24 24"
      >
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
      </svg>

      <!-- Tooltip (hidden on mobile) -->
      <span
        v-if="!isOpen"
        class="pointer-events-none absolute left-full ml-3 hidden whitespace-nowrap rounded-lg border border-white/10 bg-slate-950 px-3 py-1.5 text-sm text-white opacity-0 shadow-xl transition-opacity group-hover:opacity-100 sm:block"
      >
        Chat with EyeBreak AI
      </span>
    </button>
  </div>
</template>

<style scoped>
.chat-enter-active,
.chat-leave-active {
  transition: opacity 0.22s ease, transform 0.22s ease;
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
  background: rgba(34, 211, 238, 0.28);
  border-radius: 3px;
}

.overflow-y-auto::-webkit-scrollbar-thumb:hover {
  background: rgba(34, 211, 238, 0.45);
}
</style>
