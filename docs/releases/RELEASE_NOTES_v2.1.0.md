# 💧 EyeBreak v2.1.0 - Health & Productivity Update

**Release Date:** October 25, 2025

We're thrilled to announce EyeBreak v2.1.0, featuring Smart Schedule for work-life balance, comprehensive hydration reminders, auto-start convenience, and launch at login support for seamless daily use!

## 🌟 What's New

### ⏰ Smart Schedule System (NEW!)

Take control of when EyeBreak reminds you with intelligent work hours management!

- **Customizable Work Hours:** Set your working schedule (e.g., 9 AM - 5 PM)
- **Active Days Selection:** Choose which days to enable reminders (work days only, 24/7, or custom)
- **5 Quick Presets:**
  - 🏢 **Standard Work** (9 AM - 5 PM, Mon-Fri)
  - 🌐 **Flexible Hours** (8 AM - 6 PM, Mon-Fri)
  - 🌅 **Early Bird** (7 AM - 3 PM, Mon-Fri)
  - 🌙 **Night Owl** (12 PM - 8 PM, Mon-Fri)
  - 🔄 **24/7 Active** (Always on, all days)
- **Manual Override:** Force show any reminder with "Show Anyway" option when outside work hours
- **Real-Time Status:** See if Smart Schedule is "Active" or "Paused" based on current time
- **Professional Alerts:** Get notified when trying to trigger reminders outside work hours

**How It Works:**
- When enabled, all reminders (eye breaks, ambient, water) respect your schedule
- During off-hours, automatic reminders are paused
- Manual triggers show a confirmation dialog with override option
- Perfect for maintaining work-life balance!

### 🚀 Auto-Start Timer (NEW!)

Never forget to start your eye care routine!

- **Automatic Timer Start:** EyeBreak timer starts automatically when app launches
- **One-Click Toggle:** Enable/disable in General Settings
- **Smart Integration:** Works seamlessly with Launch at Login
- **0.5s Delay:** Gives app time to fully initialize before starting

**How to Enable:**
1. Open EyeBreak Settings → General
2. Toggle "Auto-Start Timer" ON
3. Next time EyeBreak launches, timer starts automatically!

### 🚀 Launch at Login

EyeBreak now starts automatically when you log into your Mac!

- **One-Click Setup:** Simply toggle in General Settings
- **SMAppService Integration:** Uses modern macOS 13+ technology
- **Seamless Experience:** EyeBreak ready when you need it
- **Easy Control:** Enable or disable anytime from settings
- **No Manual Startup:** Never forget to start your eye care routine

**How to Enable:**
1. Open EyeBreak Settings → General
2. Toggle "Launch at Login" ON
3. That's it! EyeBreak will start automatically on next login

### 💧 Complete Water Reminder System

Stay hydrated with our new intelligent water reminder feature that goes beyond simple notifications!

#### Two Display Styles:

1. **Blur Screen Overlay** 🌫️
   - Full-screen immersive reminder
   - Large animated water icon with glow effects
   - Manual acknowledgment - no auto-dismiss pressure
   - Single monitor display (shows on active screen only)

2. **Ambient Pop-up** 💧
   - Gentle floating window at top of screen
   - Glass morphism with theme colors
   - Auto-dismisses after 8 seconds
   - Perfect for quick, non-intrusive reminders

#### Smart Features:

- **8 Preset Messages** with 16 professional water-themed SF Symbol icons
- **Custom Messages & Icons:** Create personalized reminders
- **Full Theme Integration:** Default, Random Color, or Custom themes
- **Flexible Timing:** 30 min, 45 min, 1 hour (recommended), 90 min, or 2 hours
- **Sound Integration:** Optional "Glass" sound effect

#### Keyboard Shortcuts & Access:

- **⌘⇧W** - Show water reminder immediately
- Menu bar "Show Water Reminder" option
- "Test now" button in settings

## 🚀 Getting Started

### Smart Schedule Setup:
1. Open EyeBreak Settings → Smart Schedule
2. Toggle "Smart Schedule" ON
3. Choose a preset or customize work hours
4. Select active days (e.g., Mon-Fri for weekdays only)
5. Watch real-time status indicator show "Active" or "Paused"

### Auto-Start Timer Setup:
1. Open EyeBreak Settings → General
2. Toggle "Auto-Start Timer" ON
3. Timer automatically starts on next app launch!

### Launch at Login Setup:
1. Open EyeBreak Settings → General
2. Toggle "Launch at Login" ON
3. EyeBreak starts automatically on next login!

### Water Reminder Setup:
1. Open Settings → Breaks → Water Reminder
2. Toggle ON and select interval (recommended: 1 hour)
3. Choose style (Blur Screen or Ambient Pop-up)
4. Customize theme and messages (optional)
5. Test with **⌘⇧W** keyboard shortcut
6. If Smart Schedule is enabled, reminders respect your work hours

## ⌨️ Keyboard Shortcuts

- **⌘⇧S** - Start timer
- **⌘⇧X** - Stop timer
- **⌘⇧B** - Force break now (with Smart Schedule override option)
- **⌘⇧R** - Show ambient reminder (with Smart Schedule override option)
- **⌘⇧W** - Show water reminder (with Smart Schedule override option)

## 📦 Installation

Download `EyeBreak-v2.1.0.dmg` and drag to Applications folder. Your existing settings will be preserved when upgrading.

**System Requirements:** macOS 14.0+ (Universal Binary for Apple Silicon & Intel)

## 📝 What's Changed Since v2.0.0

### Added ✨

#### Smart Schedule System:
- **Work hours customization** (start time, end time)
- **Active days selection** (Mon-Sun toggles)
- **5 quick preset schedules** for common work patterns
- **Real-time status indicator** (Active/Paused)
- **Professional alert dialogs** for out-of-hours manual triggers
- **"Show Anyway" override option** for all reminders
- **Applies to all features:** Eye breaks, ambient reminders, and water reminders
- **Settings persistence** with @AppStorage

#### Auto-Start Timer:
- **Automatic timer start** on app launch
- **One-click toggle** in General Settings
- **0.5s initialization delay** for smooth startup
- **Perfect companion** to Launch at Login feature

#### Launch at Login:
- **SMAppService integration** for modern macOS 13+ launch at login
- **LaunchAtLoginManager** singleton for state management
- **One-click toggle** in General Settings
- **Automatic startup** when you log into your Mac
- **Easy enable/disable** control

#### Water Reminder System:
- Complete water reminder with timer management
- Two display styles: Blur Screen and Ambient Pop-up
- 8 preset hydration messages + custom message support
- 16 professional water-themed SF Symbol icons
- 5 flexible timing intervals (30min - 2 hours)
- Full theme integration (Default, Random, Custom)
- Keyboard shortcut: **⌘⇧W** for manual trigger
- Menu bar integration
- Sound effects with "Glass" tone

### Changed 🔄
- Simplified display style options (removed redundant "Both" option)
- Enhanced settings UI organization with Smart Schedule section
- Improved keyboard shortcut documentation
- Better work-life balance with schedule-aware reminders
- More intuitive General Settings layout

### Technical 🔧
- Smart Schedule computation with `shouldShowBreaksNow` property
- Time/day validation logic for schedule checking
- Alert system with manual override capabilities
- WaterReminderManager singleton
- WaterBlurOverlayView SwiftUI component
- LaunchAtLoginManager with SMAppService
- Auto-start timer with delayed initialization
- Enhanced multi-screen window management
- @AppStorage persistence for all settings including schedule preferences

## 🙏 Thank You

Thank you to our community for requesting these features! This release focuses on work-life balance, convenience, and holistic health during computer work. The Smart Schedule system ensures EyeBreak supports your productivity without interrupting your personal time.

## 🆚 Comparison: v2.0.0 → v2.1.0

| Feature | v2.0.0 | v2.1.0 |
|---------|--------|--------|
| Smart Schedule | ❌ | ✅ **NEW** |
| Work Hours Management | ❌ | ✅ **NEW** |
| Auto-Start Timer | ❌ | ✅ **NEW** |
| Launch at Login | ❌ | ✅ **NEW** |
| Eye Break Reminders | ✅ | ✅ (Schedule-aware) |
| Ambient Reminders | ✅ | ✅ (Schedule-aware) |
| Theme Customization | ✅ | ✅ |
| Water Reminders | ❌ | ✅ **NEW** |
| Manual Override | ❌ | ✅ **NEW** |
| Keyboard Shortcuts | 3 | 5 (+⌘⇧W, improved) |
| Auto-Start on Login | Manual | Automatic |

---

**Full Changelog:** [v2.0.0...v2.1.0](https://github.com/cheat2001/eyebreak/compare/v2.0.0...v2.1.0)

**Download:** [EyeBreak-v2.1.0.dmg](https://github.com/cheat2001/eyebreak/releases/tag/v2.1.0)

---

*Stay hydrated, protect your eyes, work smarter, and maintain work-life balance with EyeBreak v2.1.0!* 💧👁️⏰✨
