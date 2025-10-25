# 🌐 EyeBreak Website

Official website for EyeBreak - A minimalistic macOS app for healthy screen time habits.

## 🚀 Tech Stack

- **Framework:** Vue 3 with TypeScript
- **Build Tool:** Vite
- **Styling:** Tailwind CSS
- **Animations:** Custom CSS animations
- **Icons:** Professional SVG icons
- **Hosting:** Firebase Hosting
- **CI/CD:** GitHub Actions

## 📦 Quick Start

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

## 🔥 Firebase Deployment

This website is configured for automatic deployment to Firebase Hosting.

### Initial Setup

1. Run the setup script:
```bash
./firebase-setup.sh
```

2. Follow the prompts to select or create a Firebase project

3. Set up GitHub secrets (see [Firebase Deployment Guide](../docs/FIREBASE_DEPLOYMENT.md))

### Manual Deployment

```bash
npm run build
firebase deploy --only hosting
```

### Automatic Deployment

Every push to the `main` branch that modifies files in the `website/` directory will automatically:
1. Build the website
2. Deploy to Firebase Hosting
3. Make it live at your Firebase Hosting URL

See the GitHub Actions workflow at `.github/workflows/deploy-website.yml`

## 🎨 Features

- ✨ Modern, professional dark theme design
- 🎯 Professional SVG icons throughout
- 📱 Fully responsive for all screen sizes
- ⚡️ Fast loading with Vite optimization
- ♿️ Accessible with semantic HTML
- 🔍 SEO optimized with proper meta tags
- 🎨 Smooth animations and transitions
- 🌐 Auto-deployment with GitHub Actions

## 📁 Project Structure

```
website/
├── src/
│   ├── components/     # Vue components
│   │   ├── Navbar.vue
│   │   ├── Hero.vue
│   │   ├── Features.vue
│   │   ├── Screenshots.vue
│   │   ├── Installation.vue
│   │   ├── Documentation.vue
│   │   └── Footer.vue
│   ├── App.vue        # Root component
│   ├── main.ts        # Entry point
│   └── style.css      # Global styles
├── public/            # Static assets
├── firebase.json      # Firebase configuration
├── .firebaserc        # Firebase project ID
└── package.json       # Dependencies

```

## 🛠️ Development

- Hot module replacement (HMR) enabled
- TypeScript for type safety
- Tailwind CSS for utility-first styling
- Component-based architecture

## 📚 Documentation

- [Firebase Deployment Guide](../docs/FIREBASE_DEPLOYMENT.md)
- [Project Architecture](../docs/ARCHITECTURE.md)

Built with ❤️ for the EyeBreak project
