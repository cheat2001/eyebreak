<!-- This file can be used on GitHub Pages or as a simple installation guide -->

# 📥 Install EyeBreak

> **A minimalistic macOS menu bar app that helps reduce digital eye strain**

---

## ⚡️ Quick Install

### Method 1: Download DMG (Easiest)

<a href="https://github.com/cheat2001/eyebreak/releases/latest/download/EyeBreak-v1.0.0.dmg" style="display: inline-block; padding: 12px 24px; background-color: #0366d6; color: white; text-decoration: none; border-radius: 6px; font-weight: bold;">
📦 Download EyeBreak DMG
</a>

**After downloading:**
1. Open the DMG file
2. Drag `EyeBreak.app` to Applications
3. Right-click the app and select "Open"
4. Look for the 👁️ icon in your menu bar!

---

### Method 2: One-Line Install (Terminal)

```bash
curl -fsSL https://raw.githubusercontent.com/cheat2001/eyebreak/main/scripts/install.sh | bash
```

This automatically downloads and installs the latest version.

---

### Method 3: Homebrew (Coming Soon)

```bash
brew install --cask eyebreak
```

---

## ⚠️ First Launch (Important!)

Since EyeBreak is not signed with an Apple Developer certificate:

1. **Right-click** `EyeBreak.app` in Applications
2. Select **"Open"**
3. Click **"Open"** in the security dialog

**Or** use this Terminal command:
```bash
xattr -cr /Applications/EyeBreak.app && open /Applications/EyeBreak.app
```

---

## 🔐 Required Permissions

EyeBreak will ask for:

### 1. Notifications (Recommended)
- Allows break reminders
- Enable in: **System Settings → Notifications → EyeBreak**

### 2. Screen Recording (Optional, for Blur Mode)
- Enables screen blur during breaks
- Enable in: **System Settings → Privacy & Security → Screen Recording**
- Without this, EyeBreak uses "Notification Only" mode

---

## 📋 System Requirements

- **macOS**: 14.0 (Sonoma) or later
- **Architecture**: Apple Silicon (M1/M2/M3) or Intel
- **Storage**: ~3 MB

---

## ✨ What You Get

- 🎯 Menu bar integration
- ⏰ Smart 20-20-20 timer
- 🌫️ Screen blur during breaks
- 🔔 Break notifications
- 😴 Automatic idle detection
- 📊 Daily statistics
- 🍅 Pomodoro mode
- 🔒 100% private (no data collection)

---

## 🚀 Quick Start

1. Look for the **eye icon 👁️** in your menu bar
2. Click it and select **"Start Timer"**
3. Work for 20 minutes
4. Take a 20-second break when prompted
5. Your eyes will thank you! 😊

---

## 📚 Need Help?

- 📖 [Documentation](https://github.com/cheat2001/eyebreak/blob/main/docs/README.md)
- 🚀 [Quick Start Guide](https://github.com/cheat2001/eyebreak/blob/main/docs/QUICKSTART.md)
- ❓ [FAQ](https://github.com/cheat2001/eyebreak/blob/main/docs/FAQ.md)
- 🐛 [Report a Bug](https://github.com/cheat2001/eyebreak/issues/new?template=bug_report.md)
- 💡 [Request a Feature](https://github.com/cheat2001/eyebreak/issues/new?template=feature_request.md)

---

## 🤝 Open Source

EyeBreak is open source under the MIT License.

- 🌟 [View on GitHub](https://github.com/cheat2001/eyebreak)
- 🐛 [Report Issues](https://github.com/cheat2001/eyebreak/issues)
- 🤝 [Contribute](https://github.com/cheat2001/eyebreak/blob/main/CONTRIBUTING.md)

---

## 💚 Show Your Support

If EyeBreak helps you:
- ⭐️ [Star on GitHub](https://github.com/cheat2001/eyebreak)
- 🐦 Share on social media
- 🤝 [Contribute](https://github.com/cheat2001/eyebreak/blob/main/CONTRIBUTING.md)

---

<p align="center">
  <strong>Remember: Every 20 minutes, look 20 feet away for 20 seconds!</strong> 👁️✨
</p>

<p align="center">
  Made with 💚 for your eye health
</p>
