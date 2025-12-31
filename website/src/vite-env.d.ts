/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_APP_NAME: string
  readonly VITE_APP_VERSION: string
  readonly VITE_GITHUB_OWNER: string
  readonly VITE_GITHUB_REPO: string
  readonly VITE_GITHUB_URL: string
  readonly VITE_SITE_URL: string
  readonly VITE_DOWNLOAD_URL: string
  readonly VITE_MIN_MACOS_VERSION: string
  readonly VITE_PAYPAL_URL: string
  readonly VITE_KHQR_URL: string
  readonly VITE_GROQ_API_KEY: string
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}
