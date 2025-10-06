# 🚀 How to Create a GitHub Release

This guide will help you publish EyeBreak v1.0.0 on GitHub.

## Prerequisites

✅ You have already:
- Built the DMG: `Build/EyeBreak-v1.0.0.dmg`
- Created ZIP: `Build/EyeBreak.zip`
- All changes committed and pushed to GitHub

## Step-by-Step Release Process

### 1. Navigate to GitHub Releases

1. Go to: https://github.com/cheat2001/eyebreak
2. Click on **"Releases"** in the right sidebar
3. Click the **"Create a new release"** button

### 2. Create a New Tag

1. In the **"Choose a tag"** dropdown, type: `v1.0.0`
2. Click **"Create new tag: v1.0.0 on publish"**
3. **Target**: Leave as `main` (default)

### 3. Fill in Release Details

**Release Title:**
```
EyeBreak v1.0.0 - Initial Release
```

**Release Description:**

Copy the entire contents of `RELEASE_NOTES_v1.0.0.md` file, or use this template:

```markdown
# 🎉 EyeBreak v1.0.0 - Initial Release

**Your Eyes Deserve a Break** 👁️✨

EyeBreak is a minimalistic macOS menu bar app that helps reduce digital eye strain by following the scientifically-backed 20-20-20 rule.

---

## 📦 Installation

### Quick Install (Recommended)

1. Download `EyeBreak-v1.0.0.dmg` below
2. Open the DMG file
3. Drag `EyeBreak.app` to Applications
4. Right-click the app and select "Open"

### One-Line Install Script

```bash
curl -fsSL https://raw.githubusercontent.com/cheat2001/eyebreak/main/scripts/install.sh | bash
```

---

## ⚠️ Security Note

This app is not signed with an Apple Developer certificate. On first launch:
1. Right-click (or Control+Click) `EyeBreak.app`
2. Select "Open"
3. Click "Open" in the dialog

Or use Terminal:
```bash
xattr -cr /Applications/EyeBreak.app
open /Applications/EyeBreak.app
```

---

## ✨ Features

- 🎯 Menu Bar Integration - Lives quietly in your menu bar
- ⏰ Smart Timer System - 20-20-20 rule with customization
- 🌫️ Screen Blur During Breaks - Gentle enforcement
- 🔔 Pre-Break Notifications - 30-second warnings
- 😴 Automatic Idle Detection - Pauses when you're away
- 📊 Daily Statistics - Track your progress
- 🍅 Pomodoro Mode - 25/5 work/break cycles
- 🔒 Privacy-First - Zero data collection

---

## 📚 Documentation

- [Quick Start Guide](https://github.com/cheat2001/eyebreak/blob/main/docs/QUICKSTART.md)
- [Installation Guide](https://github.com/cheat2001/eyebreak/blob/main/INSTALLATION_GUIDE.md)
- [Full Documentation](https://github.com/cheat2001/eyebreak/blob/main/docs/README.md)
- [FAQ](https://github.com/cheat2001/eyebreak/blob/main/docs/FAQ.md)

---

## 🐛 Report Issues

Found a bug? [Open an issue](https://github.com/cheat2001/eyebreak/issues/new?template=bug_report.md)

---

## 📋 System Requirements

- macOS 14.0 (Sonoma) or later
- Apple Silicon (M1/M2/M3) or Intel

---

**Remember: Every 20 minutes, look 20 feet away for 20 seconds!** 👁️✨
```

### 4. Upload Release Assets

Scroll down to the **"Attach binaries"** section and upload:

1. **`EyeBreak-v1.0.0.dmg`** (Primary installer)
   - File location: `~/Desktop/vibe-coding/eyebreak/Build/EyeBreak-v1.0.0.dmg`
   - Description: "DMG installer for macOS"

2. **`EyeBreak.zip`** (Alternative/Homebrew)
   - File location: `~/Desktop/vibe-coding/eyebreak/Build/EyeBreak.zip`
   - Description: "Zip archive of EyeBreak.app"

### 5. Additional Settings

- ✅ Check **"Set as the latest release"**
- ⬜ Leave **"Set as a pre-release"** unchecked
- ⬜ Leave **"Create a discussion"** unchecked (optional)

### 6. Publish Release

Click the **"Publish release"** button!

---

## 🎉 After Publishing

### Update Your README Badges

Add a release badge to your README.md:

```markdown
[![Release](https://img.shields.io/github/v/release/cheat2001/eyebreak)](https://github.com/cheat2001/eyebreak/releases/latest)
[![Downloads](https://img.shields.io/github/downloads/cheat2001/eyebreak/total)](https://github.com/cheat2001/eyebreak/releases)
```

### Test the Installation

1. Test the direct download link works
2. Test the install script:
   ```bash
   curl -fsSL https://raw.githubusercontent.com/cheat2001/eyebreak/main/scripts/install.sh | bash
   ```
3. Verify the app launches correctly

### Share Your Release

- 🐦 Tweet about it
- 📝 Post on Reddit (r/macapps, r/productivity)
- 💬 Share in relevant communities
- 📧 Email to interested users

---

## 📝 For Future Releases

### Version Numbering

Follow Semantic Versioning (semver):
- `v1.0.0` → `v1.0.1` (bug fixes)
- `v1.0.0` → `v1.1.0` (new features)
- `v1.0.0` → `v2.0.0` (breaking changes)

### Release Checklist

- [ ] Update version in `Info.plist`
- [ ] Update `CHANGELOG.md`
- [ ] Create release notes
- [ ] Build and test DMG
- [ ] Commit all changes
- [ ] Create and push tag
- [ ] Create GitHub release
- [ ] Upload binaries
- [ ] Test installation methods
- [ ] Announce release

---

## 🛠️ Quick Commands

### Build Release
```bash
./scripts/build_release.sh
```

### Upload Files (using gh CLI)
```bash
gh release create v1.0.0 \
  Build/EyeBreak-v1.0.0.dmg \
  Build/EyeBreak.zip \
  --title "EyeBreak v1.0.0 - Initial Release" \
  --notes-file RELEASE_NOTES_v1.0.0.md
```

### Check Release
```bash
gh release view v1.0.0
```

---

## 🎊 You're Done!

Your app is now available for the world to use! 🌍

**Release URL**: `https://github.com/cheat2001/eyebreak/releases/tag/v1.0.0`

---

**Questions?** Open an issue or email: chansocheatsok2001@gmail.com
