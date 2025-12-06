<div align="center">

# 👁️ EyeBreak

### Your Eyes Deserve a Break

*A simple, minimalistic, distraction-free macOS app that helps reduce digital eye strain by following the scientifically-backed 20-20-20 rule.*

[![macOS](https://img.shields.io/badge/macOS-14.0+-blue.svg)](https://www.apple.com/macos)
[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Version](https://img.shields.io/badge/version-2.3.0-brightgreen.svg)](https://github.com/cheat2001/eyebreak/releases)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

[Features](#-features) • [Installation](#-installation) • [Quick Start](QUICK_START.md) • [Contributing](#-contributing) • [License](#-license)

<img src="EyeBreak/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon-256.png" width="128" height="128" alt="EyeBreak Icon">

</div>

</div>

---

## 🌟 The 20-20-20 Rule

Digital eye strain affects millions of people who spend hours in front of screens. The **20-20-20 rule** is a simple, scientifically-backed method to reduce eye fatigue:

> **Every 20 minutes** of screen time  
> Look at something **20 feet** away (about 6 meters)  
> For **20 seconds**

This gives your eye muscles a chance to relax and reduces the risk of eye strain, headaches, dry eyes, and neck pain.

## ✨ Features

### Core Functionality
- 🎯 **Menu Bar Integration** - Lightweight app that lives in your menu bar, never intrusive
- ⏰ **Smart Timer System** - Customizable work/break intervals with intelligent pausing
- 🌫️ **Screen Blur During Breaks** - Gentle enforcement to help you actually take breaks
- 🔔 **Pre-Break Notifications** - 30-second warning before breaks start
- 😴 **Automatic Idle Detection** - Pauses when you're away from your Mac
- 🎨 **Beautiful UI** - Clean, modern SwiftUI interface

### Customization
- 🍅 **Pomodoro Mode** - Built-in 25/5 work/break cycles
- 🎵 **Sound Effects** - Optional audio cues for breaks
- 🎭 **Multiple Break Styles** - Blur screen, notification only, or guided eye exercises
- ⚙️ **Flexible Settings** - Adjust intervals from 10-60 minutes
- 🎨 **Theme Customization** (v2.0) - Personalize colors with Default, Random, or Custom themes
- 🎯 **Custom Icons** (v2.0) - Choose from 16 professional SF Symbols for reminders
- ⏰ **Smart Schedule** (v2.1) - Set work hours and active days for intelligent reminder management
- 🚀 **Auto-Start Timer** (v2.1) - Automatically begin timer when app launches
- 💧 **Water Reminders** (v2.1) - Smart hydration reminders with blur screen or ambient pop-up styles
- 🚀 **Launch at Login** (v2.1) - Automatic startup when you log into your Mac
- 🔒 **Screen Lock Pause** (v2.2) - All timers automatically pause when Mac screen locks
- ⏱️ **Unified Dashboard** (v2.2) - See all timer countdowns in real-time at a glance

### Insights & Analytics
- 📊 **Daily Statistics** - Track your break history with beautiful charts
- 🏆 **Streak Tracking** - See how many consecutive days you've maintained healthy habits
- 💡 **Smart Insights** - Get personalized recommendations based on your usage

### Privacy & Accessibility
- 🔒 **Privacy-First** - Zero data collection, everything stays on your Mac
- ♿️ **Accessibility Support** - Full VoiceOver, Dynamic Type, and Reduced Motion support
- 🌐 **No Internet Required** - Works completely offline

## 🎨 What's New in v2.3.0

### 📊 Menu Bar Timer Display (NEW!)
- **Live Countdown** - See remaining time directly in the menu bar
- **Dynamic State Icons** - Eye icons change based on timer state (active, paused, break)
- **Monospaced Digits** - Clean, stable display that doesn't shift
- **Smart Tooltips** - Hover for detailed status information

### 🪟 Enhanced Floating Break Window
- **Improved Header** - Gradient icon badge with shadow effects
- **Better Close Button** - Enhanced visibility with visible border
- **Polished Skip Button** - Stronger border and shadow for clarity
- **Visual Separation** - Increased divider visibility

### 🎨 Polished UI Throughout
- **Gradient Styling** - Linear and angular gradients across all views
- **Spring Animations** - Smooth, natural-feeling transitions
- **Hover Effects** - Unified hover behavior on interactive elements
- **Rounded Design** - Friendly, modern typography

### ⚙️ Refined Settings Views
- **Hidden Scrollbar** - Cleaner About section appearance
- **Compact Layout** - Optimized spacing throughout
- **Consistent Headers** - New SectionHeaderView component
- **Enhanced Stat Boxes** - Gradient backgrounds for visual interest

---

<details>
<summary><b>📋 Previous Release: v2.1.0</b></summary>

## 🎨 What's New in v2.1.0

### ⏰ Smart Schedule System (NEW!)
- **Work Hours Management** - Set custom work hours (e.g., 9 AM - 5 PM)
- **Active Days Selection** - Choose which days to receive reminders (Mon-Fri, weekends, custom)
- **5 Quick Presets** - Standard Work, Flexible, Early Bird, Night Owl, 24/7
- **Manual Override** - "Show Anyway" option for breaks outside work hours
- **Real-Time Status** - See if schedule is "Active" or "Paused"
- **Work-Life Balance** - All reminders (breaks, ambient, water) respect your schedule

### 🚀 Auto-Start Timer (NEW!)
- **Automatic Start** - Timer begins automatically when app launches
- **One-Click Toggle** - Enable/disable in General Settings
- **Smart Integration** - Works perfectly with Launch at Login
- **No Setup Required** - Just enable and forget!

### 🚀 Launch at Login (NEW!)
- **One-Click Setup** - Toggle in Settings to start automatically on login
- **SMAppService** - Modern macOS 13+ technology for reliable startup
- **Easy Control** - Enable or disable anytime from General Settings

### 💧 Water Reminder System (NEW!)
- **Blur Screen** - Full-screen immersive hydration reminders with beautiful animations
- **Ambient Pop-up** - Gentle floating reminders at top of screen
- **Smart Timing** - Choose from 30min to 2 hour intervals
- **8 Preset Messages** - Encouraging hydration prompts
- **16 Water Icons** - Beautiful SF Symbol icons (drops, bottles, nature)
- **Custom Messages** - Personalize your hydration reminders
- **Full Theme Support** - Customize colors, opacity, and effects
- **Keyboard Shortcut** - ⌘⇧W to trigger reminder manually

</details>

---

### ⌨️ Enhanced Keyboard Shortcuts
- **⌘⇧S** - Start timer
- **⌘⇧X** - Stop timer  
- **⌘⇧B** - Take break now (with Smart Schedule override)
- **⌘⇧R** - Show ambient reminder (with Smart Schedule override)
- **⌘⇧W** - Show water reminder (with Smart Schedule override)

[See Full v2.3.0 Release Notes](docs/releases/RELEASE_NOTES_v2.3.0.md) | [v2.2.0 Release Notes](docs/releases/RELEASE_NOTES_v2.2.0.md) | [Water Reminder Guide](docs/WATER_REMINDER_FEATURE.md)

### Previous: v2.0.0 Theme Customization
- **Default Theme** - Classic vibrant style
- **Random Color** - 20 curated palettes, fresh colors each session
- **Custom Theme** - Full control over all colors and effects
- **Professional Icons** - SF Symbol picker replaces emoji input

[See v2.0.0 Release Notes](docs/releases/RELEASE_NOTES_v2.0.0.md)

## 📋 Requirements

- **macOS**: 14.0 (Sonoma) or later
- **Xcode**: 15.0 or later (for building from source)
- **Swift**: 5.9+

## 🚀 Installation

### Download the App (Recommended) ⭐️

1. **[Download EyeBreak-v2.3.0.dmg](https://github.com/cheat2001/eyebreak/releases/latest)**
2. **Remove quarantine** (required for unsigned apps):
   ```bash
   cd ~/Downloads
   xattr -cr EyeBreak-v2.3.0.dmg
   ```
3. **Open** the DMG file
4. **Drag** `EyeBreak.app` to your `Applications` folder
5. **Launch**: 
   ```bash
   open /Applications/EyeBreak.app
   ```
6. Look for the **eye icon 👁️** in your menu bar!

> **⚠️ Why the terminal command?** The app isn't signed with an Apple Developer certificate ($99/year).  
> macOS blocks unsigned downloads, so you must remove the quarantine flag first.

### Quick One-Line Install

```bash
curl -L https://github.com/cheat2001/eyebreak/releases/download/v2.3.0/EyeBreak-v2.3.0.dmg -o ~/Downloads/EyeBreak.dmg && xattr -cr ~/Downloads/EyeBreak.dmg && open ~/Downloads/EyeBreak.dmg
```

Then just drag to Applications!

### For Developers: Build from Source

```bash
git clone https://github.com/cheat2001/eyebreak.git
cd eyebreak
open EyeBreak.xcodeproj
# Press ⌘R to build and run
```

See [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md) for detailed build instructions.

## 🎯 Usage

### First Launch

1. Launch EyeBreak - you'll see an eye icon 👁️ in your menu bar
2. Complete the onboarding to learn about the 20-20-20 rule
3. Grant required permissions when prompted
4. Click **"Start Timer"** to begin your first session

### Menu Bar Controls

Click the eye icon to access:
- **Start/Stop** - Begin or pause your break timer
- **Take Break Now** - Trigger an immediate break
- **Settings** - Customize your experience
- **View Stats** - See your break history and progress

### During a Break

- Your screen will blur and show a break overlay
- Follow the on-screen instructions to rest your eyes
- Press **ESC** or click anywhere to end early (not recommended!)
- The break automatically ends after the configured duration

### Customization

Access **Settings** to customize:

| Setting | Range | Default | Description |
|---------|-------|---------|-------------|
| Work Interval | 10-60 min | 20 min | Time between breaks |
| Break Duration | 10-60 sec | 20 sec | Length of each break |
| Pre-Break Warning | 0-60 sec | 30 sec | Warning before break starts |
| Break Style | 3 options | Blur | Blur, notification, or exercise |
| Session Type | 3 presets | 20-20-20 | Choose 20-20-20, Pomodoro, or Custom |
| Smart Schedule | ON/OFF | OFF | Enable work hours management |
| Work Hours | Custom | 9AM-5PM | Set your working schedule |
| Auto-Start Timer | ON/OFF | ON | Start timer on app launch |
| Launch at Login | ON/OFF | OFF | Start app when you log in |
| Water Reminders | 30min-2hr | 1 hour | Hydration reminder interval |

## 🔐 Permissions

EyeBreak requires the following permissions:

### Screen Recording (Required for Blur Mode)
1. Go to **System Settings** > **Privacy & Security** > **Screen Recording**
2. Enable the checkbox next to **EyeBreak**
3. Restart the app

*If denied, the app automatically switches to "Notification Only" mode.*

### Notifications (Recommended)
- Allow notifications to receive break reminders
- The app will request permission on first launch

## 📊 Statistics & Insights

Track your progress with comprehensive statistics:

- **Daily Breaks**: See how many breaks you've completed today
- **Break History**: 7-day and 30-day charts showing your consistency
- **Completion Rate**: Percentage of breaks taken vs. skipped
- **Streak Counter**: Consecutive days of healthy break habits
- **Smart Insights**: Personalized tips based on your usage patterns

All data is stored locally on your Mac. No cloud sync, no analytics, no tracking.

## 🏗️ Project Structure

```
EyeBreak/
├── EyeBreakApp.swift              # Main app entry point
├── Models/
│   ├── TimerState.swift           # State management
│   └── Settings.swift             # User preferences
├── Managers/
│   ├── BreakTimerManager.swift    # Core timer logic
│   ├── IdleDetector.swift         # Activity monitoring
│   ├── NotificationManager.swift  # Notification handling
│   └── ScreenBlurManager.swift    # Screen blur overlay
├── Views/
│   ├── MenuBarView.swift          # Main menu bar UI
│   ├── SettingsView.swift         # Preferences panel
│   ├── BreakOverlayView.swift     # Break screen overlay
│   ├── OnboardingView.swift       # Welcome flow
│   └── StatsView.swift            # Statistics dashboard
└── Resources/
    └── Assets.xcassets            # App icons and colors
```

**Architecture**: Built using MVVM pattern with SwiftUI and Combine. See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for details.

## 🧪 Testing

Run tests before submitting contributions:

```bash
# Manual testing checklist
- [ ] Timer starts and counts down
- [ ] Break overlay appears
- [ ] Notifications work
- [ ] Idle detection pauses timer
- [ ] Settings persist across launches
- [ ] Stats update correctly
```

See [docs/TESTING.md](docs/TESTING.md) for comprehensive testing guide.

## 🤝 Contributing

Contributions are welcome! We love pull requests from everyone.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

### Ways to Contribute

- 🐛 Report bugs
- 💡 Suggest new features
- 📝 Improve documentation
- 🎨 Design UI/UX improvements
- 🌍 Add translations (future)
- ⭐️ Star the project

## 📚 Documentation

- [Development Guide](docs/DEVELOPMENT.md) - Build and run from source
- [Architecture](docs/ARCHITECTURE.md) - Technical design and structure
- [Installation Guide](docs/INSTALLATION.md) - Detailed installation instructions
- [Distribution Guide](docs/DISTRIBUTION.md) - Release and distribution process
- [Publishing Guide](docs/PUBLISHING.md) - How to publish releases on GitHub
- [Testing Guide](docs/TESTING.md) - How to test the app
- [FAQ](docs/FAQ.md) - Frequently asked questions

## 🐛 Troubleshooting

### Common Issues

**Screen blur not working?**
- Grant Screen Recording permission in System Settings
- Restart the app after granting permission

**Notifications not appearing?**
- Check System Settings > Notifications > EyeBreak
- Enable "Allow Notifications"

**Timer not pausing when idle?**
- Enable idle detection in Settings
- Adjust the idle threshold if needed

See [docs/FAQ.md](docs/FAQ.md) for more troubleshooting help.

## 🗺️ Roadmap

### Recently Completed ✅
- [x] Smart Schedule with work hours management (v2.1.0)
- [x] Auto-start timer (v2.1.0)
- [x] Launch at login (v2.1.0)
- [x] Water reminder system (v2.1.0)
- [x] Keyboard shortcuts (v2.1.0)
- [x] Custom break messages (v2.0.0)
- [x] Theme customization (v2.0.0)

### Upcoming Features
- [ ] Multiple language support
- [ ] Break exercise animations with guided movements
- [ ] Weekly/monthly detailed reports
- [ ] Export statistics to CSV
- [ ] Focus mode integration with Do Not Disturb
- [ ] Customizable ambient reminder messages

### Future Ideas
- [ ] Team sync (optional, privacy-first)
- [ ] Break reminders for calendar meetings
- [ ] Integration with calendar apps
- [ ] Stretching exercise videos
- [ ] Dark mode theme variants

See [issues](https://github.com/cheat2001/eyebreak/issues) for planned features and vote on what you'd like to see!

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

**TL;DR**: You can use, modify, and distribute this software freely, even commercially. Just include the license notice.

## 🙏 Acknowledgments

- Inspired by [LookAway.app](https://lookaway.app)
- Icons by [SF Symbols](https://developer.apple.com/sf-symbols/)
- Built with ❤️ for healthier screen time habits
- Thanks to all [contributors](https://github.com/cheat2001/eyebreak/graphs/contributors)

## 📞 Support

- 📖 [Read the docs](docs/)
- 💬 [Open an issue](https://github.com/cheat2001/eyebreak/issues)
- ⭐️ [Star the project](https://github.com/cheat2001/eyebreak)
- 🐛 [Report a bug](https://github.com/cheat2001/eyebreak/issues/new?template=bug_report.md)
- 💡 [Request a feature](https://github.com/cheat2001/eyebreak/issues/new?template=feature_request.md)

## ⭐️ Show Your Support

If EyeBreak helps you maintain healthier screen habits, please consider:

- ⭐️ Starring this repository
- 🐦 Sharing it on social media
- 📝 Writing a blog post about it
- 🤝 Contributing code or documentation

---

<div align="center">

**Remember: Every 20 minutes, look 20 feet away for 20 seconds.**

Your eyes will thank you! 👁️✨

Made with 💚 for your eye health

[⬆ Back to top](#-eyebreak)

</div>
