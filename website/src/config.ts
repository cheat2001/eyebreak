/**
 * Application Configuration
 * Uses environment variables from .env file
 */

export const config = {
  app: {
    name: import.meta.env.VITE_APP_NAME || 'EyeBreak',
    version: import.meta.env.VITE_APP_VERSION || '2.4.0',
  },
  github: {
    owner: import.meta.env.VITE_GITHUB_OWNER || 'cheat2001',
    repo: import.meta.env.VITE_GITHUB_REPO || 'eyebreak',
    url: import.meta.env.VITE_GITHUB_URL || 'https://github.com/cheat2001/eyebreak',
  },
  site: {
    url: import.meta.env.VITE_SITE_URL || 'https://eyebreak.app',
    downloadUrl: import.meta.env.VITE_DOWNLOAD_URL || 'https://github.com/cheat2001/eyebreak/releases/latest',
  },
  requirements: {
    macOSVersion: import.meta.env.VITE_MIN_MACOS_VERSION || '14.0+',
  },
  donation: {
    paypalUrl: import.meta.env.VITE_PAYPAL_URL || 'https://www.paypal.com/donate/?hosted_button_id=KSQCFH8HU6DZN',
    khqrUrl: import.meta.env.VITE_KHQR_URL || 'https://pay.ababank.com/oRF8/fnuxbuun',
  },
} as const

export type Config = typeof config
