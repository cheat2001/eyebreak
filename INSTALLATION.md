# Installation Guide

EyeBreak is a free, open-source macOS app to help you take care of your eyes while working on your computer.

## 📦 Installation Methods

### Method 1: Download from GitHub Releases (Easiest)

1. Go to the [Releases page](https://github.com/YOUR_USERNAME/lookaway/releases)
2. Download the latest `EyeBreak.dmg` file
3. Open the DMG file
4. Drag `EyeBreak.app` to your Applications folder
5. Open EyeBreak from Applications
6. If you see a security warning, go to **System Settings > Privacy & Security** and click "Open Anyway"

### Method 2: Install via Homebrew (For developers)

```bash
# Add the tap (once the formula is published)
brew tap YOUR_USERNAME/eyebreak

# Install EyeBreak
brew install --cask eyebreak
```

### Method 3: Build from Source

**Requirements:**
- macOS 14.0 or later
- Xcode 15.0 or later
- Command Line Tools for Xcode

**Steps:**

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/lookaway.git
cd lookaway

# Open in Xcode
open EyeBreak.xcodeproj

# Build and run (⌘R in Xcode)
# Or build from command line:
xcodebuild -project EyeBreak.xcodeproj -scheme EyeBreak -configuration Release build

# The app will be in:
# Build/Products/Release/EyeBreak.app
```

## ✅ First Launch Setup

1. **Grant Permissions**: EyeBreak needs accessibility permissions to work properly
   - Go to **System Settings > Privacy & Security > Accessibility**
   - Enable EyeBreak

2. **Configure Settings**: 
   - Open EyeBreak Settings
   - Set your preferred work interval (default: 20 minutes)
   - Set break duration (default: 20 seconds)
   - Enable ambient reminders if desired

3. **Start Timer**: Press `⌘⇧S` or click "Start Timer" in settings

## ⌨️ Keyboard Shortcuts

- `⌘⇧S` - Start timer
- `⌘⇧B` - Take break now
- `⌘⇧X` - Stop timer
- `⌘⇧R` - Show ambient reminder
- `ESC` - Skip current break

## 🆘 Troubleshooting

**App won't open (Security warning)**
- Right-click the app and select "Open"
- Or go to System Settings > Privacy & Security > Security and click "Open Anyway"

**Keyboard shortcuts don't work**
- Grant Accessibility permissions in System Settings

**App crashes on launch**
- Make sure you're running macOS 14.0 or later
- Try deleting the app and reinstalling

## 🔄 Updates

To check for updates, visit the [Releases page](https://github.com/YOUR_USERNAME/lookaway/releases).

If installed via Homebrew:
```bash
brew upgrade eyebreak
```

## 🗑️ Uninstallation

**Manual installation:**
- Drag EyeBreak.app to Trash from Applications folder
- Remove settings: `rm -rf ~/Library/Preferences/com.eyebreak.app.plist`

**Homebrew installation:**
```bash
brew uninstall --cask eyebreak
```
