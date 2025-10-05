# 🚀 Quick Start Guide - Publishing EyeBreak

This is your step-by-step guide to make EyeBreak available for free to everyone!

## ✅ Step 1: Prepare Your Repository

```bash
cd /Users/chansocheat.sok/Desktop/vibe-coding/lookaway

# Create a GitHub repository first at:
# https://github.com/new
# Name it: lookaway or eyebreak

# Then connect your local code to GitHub:
git init
git add .
git commit -m "Initial release: EyeBreak v1.0.0 - Eye care reminder app"

# Replace YOUR_USERNAME with your GitHub username
git remote add origin https://github.com/YOUR_USERNAME/lookaway.git
git branch -M main
git push -u origin main
```

## 📦 Step 2: Build Release Version

```bash
# Make the build script executable (if not already done)
chmod +x build_release.sh

# Run the build script
./build_release.sh

# This creates:
# ✅ Build/Export/EyeBreak.app - The application
# ✅ Build/EyeBreak-v1.0.0.dmg - Installer for users  
# ✅ Build/EyeBreak.zip - For Homebrew distribution
```

## 🎉 Step 3: Create GitHub Release

1. **Go to your repository on GitHub**
   - Navigate to: `https://github.com/YOUR_USERNAME/lookaway`

2. **Click "Releases"** (right sidebar)
   - Click "Create a new release"

3. **Fill in release details:**
   - **Tag**: `v1.0.0`
   - **Title**: `EyeBreak v1.0.0 - Initial Release`
   - **Description**: 
     ```markdown
     🎉 First release of EyeBreak - Free eye care reminder app!

     ## ✨ What's New
     - Smart 20-20-20 rule reminders
     - Animated eye exercises with guided movements
     - Ambient reminders that pop up while you work
     - Custom emoji reminders
     - Keyboard shortcuts for everything
     - Sound notifications
     - Fully customizable settings

     ## 📥 Installation
     
     **Option 1: Download DMG (Recommended)**
     1. Download `EyeBreak-v1.0.0.dmg` below
     2. Open the DMG file
     3. Drag EyeBreak to Applications
     4. Open from Applications folder
     
     **Option 2: Homebrew** (coming soon)
     ```bash
     brew tap YOUR_USERNAME/eyebreak
     brew install --cask eyebreak
     ```

     **First Launch:**
     If you see a security warning, right-click the app and select "Open", 
     or go to System Settings > Privacy & Security and click "Open Anyway"

     ## ⌨️ Keyboard Shortcuts
     - ⌘⇧S - Start timer
     - ⌘⇧B - Take break now
     - ⌘⇧X - Stop timer
     - ⌘⇧R - Show ambient reminder

     ## 📖 Full Documentation
     See [INSTALLATION.md](INSTALLATION.md) for detailed instructions
     ```

4. **Upload files:**
   - Drag and drop `Build/EyeBreak-v1.0.0.dmg`
   - Drag and drop `Build/EyeBreak.zip`

5. **Publish!**
   - Click "Publish release"

## 🍺 Step 4: Setup Homebrew (Optional)

If you want users to install via `brew`:

1. **Create a new GitHub repository**:
   - Name: `homebrew-eyebreak` (must start with "homebrew-")
   - Make it public

2. **Add the Homebrew formula**:
   ```bash
   # Clone your new tap repository
   git clone https://github.com/YOUR_USERNAME/homebrew-eyebreak.git
   cd homebrew-eyebreak
   
   # Copy the cask formula
   mkdir -p Casks
   cp /path/to/lookaway/Casks/eyebreak.rb Casks/
   
   # Update with actual values
   # Edit Casks/eyebreak.rb and replace YOUR_USERNAME
   
   # Get SHA256 of your zip file
   shasum -a 256 /path/to/Build/EyeBreak.zip
   # Copy this hash and update it in eyebreak.rb
   
   # Commit and push
   git add Casks/eyebreak.rb
   git commit -m "Add EyeBreak cask v1.0.0"
   git push
   ```

3. **Users can now install with**:
   ```bash
   brew tap YOUR_USERNAME/eyebreak
   brew install --cask eyebreak
   ```

## 📝 Step 5: Update README

Replace `YOUR_USERNAME` in these files:
- `README.md`
- `INSTALLATION.md`
- `DISTRIBUTION.md`
- `Casks/eyebreak.rb`

Add installation instructions at the top of your README:

```markdown
## 📥 Installation

### Download (Easiest)
1. Go to [Releases](https://github.com/YOUR_USERNAME/lookaway/releases)
2. Download `EyeBreak-v1.0.0.dmg`
3. Open DMG and drag to Applications
4. Launch EyeBreak!

### Homebrew
```bash
brew tap YOUR_USERNAME/eyebreak
brew install --cask eyebreak
```

See [INSTALLATION.md](INSTALLATION.md) for more options.
```

## 🎯 Step 6: Promote Your App

### Add to your README:
- ✅ Screenshots/GIFs of the app in action
- ✅ Feature list with emojis
- ✅ Clear installation instructions
- ✅ Keyboard shortcuts reference
- ✅ "Star ⭐ if you like it!"

### Optional - Share on:
- Reddit: r/macapps, r/productivity
- Hacker News: Show HN
- Product Hunt
- Twitter/X with #macOS #opensource
- macOS communities

## 🔄 Updating to New Versions

When you release v1.0.1:

1. **Update version numbers**:
   - `EyeBreak/Info.plist` - CFBundleShortVersionString
   - `build_release.sh` - DMG_NAME variable

2. **Run build again**:
   ```bash
   ./build_release.sh
   ```

3. **Create new GitHub release**:
   - Tag: `v1.0.1`
   - Upload new DMG and ZIP

4. **Update Homebrew cask**:
   ```bash
   cd homebrew-eyebreak
   # Edit Casks/eyebreak.rb
   # Update version and SHA256
   git commit -am "Update to v1.0.1"
   git push
   ```

## ✨ Making It Production-Ready

### Essential:
- ✅ Test on a clean Mac (or ask a friend to test)
- ✅ Add LICENSE file (MIT recommended for open source)
- ✅ Add screenshots to README
- ✅ Clear installation instructions
- ✅ Test all keyboard shortcuts
- ✅ Verify permissions requests work

### Nice to Have:
- ✅ App icon (already done!)
- ✅ Code signing (requires Apple Developer account - $99/year)
- ✅ Notarization (also requires Apple Developer account)
- ✅ Auto-update mechanism
- ✅ Crash reporting (optional)

## 🎨 Tips for Success

### Good README = More Users
- Use emojis for visual appeal
- Add GIFs showing features
- Keep installation simple
- Showcase unique features
- Add "Star if you like" reminder

### Handle Issues Well
- Enable GitHub Issues
- Respond to user questions
- Label bugs vs features
- Thank contributors

### Keep It Simple
- Don't over-complicate distribution
- DMG + GitHub Releases = most users covered
- Homebrew = bonus for tech users
- Mac App Store = expensive, not worth it for free apps

## 🆘 Common Problems

**"App can't be opened because it's from an unidentified developer"**
- This is normal without code signing
- Users: Right-click → Open, or System Settings → Privacy & Security → Open Anyway
- Solution: Get Apple Developer account and sign the app

**Homebrew install fails**
- Check SHA256 hash matches
- Ensure ZIP file is publicly accessible
- Test with: `brew install --cask --debug eyebreak`

**App crashes on launch**
- Test on macOS 14.0+
- Check entitlements are correct
- Verify all required files are bundled

## 🎊 You're Ready!

Your app is now ready to be used by anyone, anywhere, for FREE! 🚀

**Next steps:**
1. Run `./build_release.sh`
2. Create GitHub release with DMG
3. Share the link!

**Need help?**
- Check DISTRIBUTION.md for detailed guide
- Ask in GitHub Discussions
- Open an issue if stuck

**Remember:**
Making your app free and open-source is amazing! 
You're helping people take care of their eyes! 👁️❤️
