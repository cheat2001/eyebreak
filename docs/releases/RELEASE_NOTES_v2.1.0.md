# 💧 EyeBreak v2.1.0 - Health & Convenience Update

**Release Date:** October 25, 2025

We're thrilled to announce EyeBreak v2.1.0, featuring a comprehensive hydration reminder system and launch at login support for seamless daily use!

## 🌟 What's New

### 🚀 Launch at Login (NEW!)

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

## 📦 Installation

Download `EyeBreak-v2.1.0.dmg` and drag to Applications folder. Your existing settings will be preserved when upgrading.

**System Requirements:** macOS 14.0+ (Universal Binary for Apple Silicon & Intel)

## 📝 What's Changed Since v2.0.0

### Added ✨

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
- Enhanced settings UI organization
- Improved keyboard shortcut documentation

### Technical 🔧
- WaterReminderManager singleton
- WaterBlurOverlayView SwiftUI component
- LaunchAtLoginManager with SMAppService
- Enhanced multi-screen window management
- @AppStorage persistence for all settings

## 🙏 Thank You

Thank you to our community for requesting these features! This release focuses on convenience and holistic health during computer work.

## 🆚 Comparison: v2.0.0 → v2.1.0

| Feature | v2.0.0 | v2.1.0 |
|---------|--------|--------|
| Launch at Login | ❌ | ✅ **NEW** |
| Eye Break Reminders | ✅ | ✅ |
| Ambient Reminders | ✅ | ✅ |
| Theme Customization | ✅ | ✅ |
| Water Reminders | ❌ | ✅ **NEW** |
| Keyboard Shortcuts | 3 | 4 (+⌘⇧W) |
| Auto-Start on Login | Manual | Automatic |

---

**Full Changelog:** [v2.0.0...v2.1.0](https://github.com/cheat2001/eyebreak/compare/v2.0.0...v2.1.0)

**Download:** [EyeBreak-v2.1.0.dmg](https://github.com/cheat2001/eyebreak/releases/tag/v2.1.0)

---

*Stay hydrated, protect your eyes, and work healthier with EyeBreak v2.1.0!* 💧👁️✨
