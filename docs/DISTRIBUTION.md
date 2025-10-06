# Distribution Guide for EyeBreak

This guide explains how to distribute EyeBreak so others can easily install and use it.

## 📋 Prerequisites

1. **GitHub Account**: Create a repository at `https://github.com/YOUR_USERNAME/lookaway`
2. **macOS Development**: Xcode installed on your Mac
3. **(Optional) Apple Developer Account**: For code signing and notarization ($99/year)

## 🚀 Quick Distribution Setup

### Step 1: Push Your Code to GitHub

```bash
# Initialize git if not already done
cd /Users/chansocheat.sok/Desktop/vibe-coding/lookaway
git init
git add .
git commit -m "Initial release of EyeBreak v1.0.0"

# Create GitHub repo and push
# (Replace YOUR_USERNAME with your actual GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/lookaway.git
git branch -M main
git push -u origin main
```

### Step 2: Build Release Version

```bash
# Run the build script
./build_release.sh

# This creates:
# - Build/Export/EyeBreak.app (the application)
# - Build/EyeBreak-v1.0.0.dmg (installer)
# - Build/EyeBreak.zip (for Homebrew)
```

### Step 3: Create GitHub Release

1. Go to your GitHub repository
2. Click "Releases" → "Create a new release"
3. Tag: `v1.0.0`
4. Title: `EyeBreak v1.0.0`
5. Description: Copy from CHANGELOG.md
6. Upload files:
   - `Build/EyeBreak-v1.0.0.dmg`
   - `Build/EyeBreak.zip`
7. Click "Publish release"

### Step 4: Update Installation Instructions

1. Edit `INSTALLATION.md` and replace `YOUR_USERNAME` with your GitHub username
2. Edit `Casks/eyebreak.rb` and replace `YOUR_USERNAME` with your GitHub username
3. Commit and push changes

## 📦 Distribution Methods

### Method 1: Direct Download (Easiest for Users)

**What users do:**
1. Go to your releases page: `https://github.com/YOUR_USERNAME/lookaway/releases`
2. Download `EyeBreak-v1.0.0.dmg`
3. Open DMG, drag app to Applications
4. Done! ✅

**Pros:**
- No technical knowledge required
- Works immediately
- Most familiar to Mac users

**Cons:**
- Manual updates (users must check for new versions)

### Method 2: Homebrew Cask (For Tech-Savvy Users)

**Setup (One-time):**

1. Create a Homebrew tap repository:
   ```bash
   # Create new repo on GitHub: homebrew-eyebreak
   git clone https://github.com/YOUR_USERNAME/homebrew-eyebreak.git
   cd homebrew-eyebreak
   mkdir Casks
   cp /path/to/lookaway/Casks/eyebreak.rb Casks/
   git add Casks/eyebreak.rb
   git commit -m "Add EyeBreak cask"
   git push
   ```

2. Users can now install with:
   ```bash
   brew tap YOUR_USERNAME/eyebreak
   brew install --cask eyebreak
   ```

**Pros:**
- Easy updates: `brew upgrade eyebreak`
- Automated installation
- Popular among developers

**Cons:**
- Requires Homebrew installed
- More setup work for you

### Method 3: Mac App Store (Advanced)

**Requirements:**
- Apple Developer Program ($99/year)
- App notarization and code signing
- App Store review process

**Not recommended for free open-source apps** due to cost and complexity.

## 🔐 Code Signing (Optional but Recommended)

Without code signing, users will see a warning: "EyeBreak is from an unidentified developer"

### Free Option: Ad-hoc Signing

The build script already does this automatically. Users can still open the app by:
1. Right-click → Open
2. Or System Settings → Privacy & Security → "Open Anyway"

### Paid Option: Apple Developer Account

If you want to remove warnings completely:

1. Join Apple Developer Program ($99/year)
2. Get a Developer ID certificate
3. Update build script with your certificate:
   ```bash
   CODE_SIGN_IDENTITY="Developer ID Application: Your Name (TEAMID)"
   ```
4. Notarize the app (required for macOS 10.15+)

## 📝 Version Updates

When releasing a new version:

1. Update version in `Info.plist`
2. Update `CHANGELOG.md`
3. Run `./build_release.sh`
4. Create new GitHub release with new tag (e.g., `v1.0.1`)
5. Upload new DMG and ZIP
6. Update Homebrew cask with new version and SHA256:
   ```bash
   shasum -a 256 Build/EyeBreak.zip
   ```

## 📊 Recommended Distribution Strategy

### For Maximum Reach (Free, Open Source):

1. **Primary**: GitHub Releases with DMG file
   - Most users can download and use immediately
   - Include clear instructions in README.md

2. **Secondary**: Homebrew Cask
   - For developer users who prefer CLI
   - Easy to set up and maintain

3. **Optional**: Build from source
   - For advanced users and contributors
   - Include clear build instructions

### Files to Include in Your Repository:

```
lookaway/
├── README.md                 (Overview, features, quick start)
├── INSTALLATION.md           (Detailed installation guide)
├── CHANGELOG.md             (Version history)
├── DISTRIBUTION.md          (This file)
├── LICENSE                  (MIT or similar open-source license)
├── build_release.sh         (Build script)
├── Casks/
│   └── eyebreak.rb         (Homebrew formula)
└── .github/
    └── workflows/
        └── release.yml     (Optional: Auto-build on release)
```

## 🎯 Example README.md Structure

```markdown
# EyeBreak 👁️

A free, open-source macOS app to help you take care of your eyes.

## ✨ Features
- 20-20-20 rule reminders
- Animated eye exercises
- Ambient reminders while working
- Customizable schedules

## 📥 Installation

### Download (Recommended)
1. Download [EyeBreak.dmg](releases/latest)
2. Open and drag to Applications
3. Open EyeBreak and grant permissions

### Homebrew
\`\`\`bash
brew tap YOUR_USERNAME/eyebreak
brew install --cask eyebreak
\`\`\`

See [INSTALLATION.md](INSTALLATION.md) for more options.

## 🖼️ Screenshots
[Add screenshots here]

## ⌨️ Keyboard Shortcuts
- ⌘⇧S - Start timer
- ⌘⇧B - Take break now
- ⌘⇧R - Show reminder

## 🤝 Contributing
Pull requests are welcome!

## 📄 License
MIT License - Free to use and modify

## ❤️ Support
If you like EyeBreak, please star ⭐ the repo!
```

## 🔧 Troubleshooting

### Common Issues:

**"cannot be opened because the developer cannot be verified"**
- This is normal for unsigned apps
- Users can right-click → Open, or go to System Settings → Privacy & Security

**Homebrew cask fails**
- Make sure the ZIP file is publicly accessible
- Update SHA256 hash in `eyebreak.rb`
- Test with `brew install --cask --debug eyebreak`

**Build fails**
- Ensure Xcode Command Line Tools are installed: `xcode-select --install`
- Check macOS version compatibility

## 📞 Getting Help

- Create GitHub Issues for bug reports
- Add Discussions for questions
- Include System Info: macOS version, EyeBreak version

## 🎉 You're Ready!

Your app is now ready for the world to use for free! 🚀
