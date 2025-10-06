# 🎉 EyeBreak v1.0.0 - Initial Release

**Your Eyes Deserve a Break** 👁️✨

EyeBreak is a minimalistic macOS menu bar app that helps reduce digital eye strain by following the scientifically-backed 20-20-20 rule.

---

## 📦 Installation

### Method 1: Download DMG (Recommended)

1. **Download** `EyeBreak-v1.0.0.dmg` from the Assets section below
2. **Open** the downloaded DMG file
3. **Drag** `EyeBreak.app` to your Applications folder
4. **Launch** from Applications folder
5. **Right-click** the app and select "Open" (first time only, due to unsigned app)

### Method 2: Homebrew (Coming Soon)

```bash
brew install --cask eyebreak
```

### Method 3: Build from Source

```bash
git clone https://github.com/cheat2001/eyebreak.git
cd eyebreak
open EyeBreak.xcodeproj
# Press ⌘R to build and run
```

---

## ⚠️ Important First Launch Steps

Since this app is not signed with an Apple Developer certificate, you'll need to:

1. **Right-click** (or Control+Click) on `EyeBreak.app`
2. Select **"Open"**
3. Click **"Open"** in the security dialog

**Or** use Terminal:
```bash
xattr -cr /Applications/EyeBreak.app
open /Applications/EyeBreak.app
```

---

## ✨ Features

### Core Functionality
- 🎯 **Menu Bar Integration** - Lives quietly in your menu bar
- ⏰ **Smart Timer System** - 20-20-20 rule with customizable intervals
- 🌫️ **Screen Blur During Breaks** - Gentle enforcement mode
- 🔔 **Pre-Break Notifications** - 30-second warning before breaks
- 😴 **Automatic Idle Detection** - Pauses when you're away
- 🎨 **Beautiful UI** - Clean, modern SwiftUI interface

### Customization
- 🍅 **Pomodoro Mode** - Built-in 25/5 work/break cycles
- 🎵 **Sound Effects** - Optional audio cues
- 🎭 **Multiple Break Styles** - Blur, notification, or guided exercises
- ⚙️ **Flexible Settings** - 10-60 minute intervals

### Privacy & Analytics
- 📊 **Daily Statistics** - Track your break history
- 🏆 **Streak Tracking** - Consecutive days maintained
- 🔒 **Privacy-First** - Zero data collection, everything stays local
- 🌐 **No Internet Required** - Works completely offline

---

## 🔐 Required Permissions

### Notifications (Recommended)
- Allows break reminders
- Enable in: System Settings → Notifications → EyeBreak

### Screen Recording (Required for Blur Mode)
- Enables screen blur during breaks
- Enable in: System Settings → Privacy & Security → Screen Recording
- Check the box next to EyeBreak
- Restart the app

*If you don't grant Screen Recording, the app will use "Notification Only" mode.*

---

## 🚀 Quick Start

1. Look for the **eye icon 👁️** in your menu bar
2. Click it to open the menu
3. Click **"Start Timer"**
4. Work for 20 minutes
5. Take a 20-second break when prompted
6. Repeat!

---

## 📚 Documentation

- 📖 [Full Documentation](https://github.com/cheat2001/eyebreak/blob/main/docs/README.md)
- 🚀 [Quick Start Guide](https://github.com/cheat2001/eyebreak/blob/main/docs/QUICKSTART.md)
- 🏗️ [Architecture](https://github.com/cheat2001/eyebreak/blob/main/docs/ARCHITECTURE.md)
- ❓ [FAQ](https://github.com/cheat2001/eyebreak/blob/main/docs/FAQ.md)
- 🐛 [Troubleshooting](https://github.com/cheat2001/eyebreak/blob/main/docs/FAQ.md#troubleshooting)

---

## 🐛 Known Issues

- First launch requires manual security approval (unsigned app)
- Some icon sizes may show warnings (non-critical)

---

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](https://github.com/cheat2001/eyebreak/blob/main/CONTRIBUTING.md).

---

## 📝 Changelog

### Added
- Initial release with core 20-20-20 timer functionality
- Menu bar integration with real-time updates
- Screen blur overlay during breaks
- Customizable work/break intervals
- Pre-break warning notifications
- Automatic idle detection
- Statistics and streak tracking
- Multiple break styles (blur, notification, guided)
- Pomodoro mode support
- Beautiful onboarding flow
- Comprehensive settings panel
- Daily statistics dashboard
- Privacy-first design (zero telemetry)

---

## 📋 System Requirements

- **macOS**: 14.0 (Sonoma) or later
- **Architecture**: Apple Silicon (M1/M2/M3) & Intel
- **Storage**: ~3 MB
- **RAM**: Minimal impact (~20 MB)

---

## 📞 Support

- 🐛 [Report a Bug](https://github.com/cheat2001/eyebreak/issues/new?template=bug_report.md)
- 💡 [Request a Feature](https://github.com/cheat2001/eyebreak/issues/new?template=feature_request.md)
- 📧 [Email](mailto:chansocheatsok2001@gmail.com)
- 📖 [Documentation](https://github.com/cheat2001/eyebreak/blob/main/docs/README.md)

---

## 🙏 Acknowledgments

- Inspired by the 20-20-20 rule for eye health
- Icons by SF Symbols
- Built with ❤️ for healthier screen time habits

---

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/cheat2001/eyebreak/blob/main/LICENSE) file for details.

---

## ⭐️ Show Your Support

If EyeBreak helps you maintain healthier screen habits:
- ⭐️ Star this repository
- 🐦 Share it on social media
- 🤝 Contribute code or documentation

**Remember: Every 20 minutes, look 20 feet away for 20 seconds!** 👁️✨

---

**Full Changelog**: https://github.com/cheat2001/eyebreak/blob/main/CHANGELOG.md
