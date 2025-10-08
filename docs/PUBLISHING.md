# 📦 GitHub Release Guide for v2.0.0

This guide will walk you through creating and publishing the v2.0.0 release on GitHub.

## Prerequisites

- [ ] All code changes committed and pushed to `main` branch
- [ ] Version updated to 2.0.0 in `Info.plist`
- [ ] CHANGELOG.md updated with v2.0.0 entry
- [ ] RELEASE_NOTES_v2.0.0.md created
- [ ] README.md updated with v2.0.0 references
- [ ] Build artifacts created (DMG and ZIP)

## Step 1: Build the Release

Run the build script to create distribution files:

```bash
cd /Users/chansocheat.sok/Desktop/vibe-coding/eyebreak
./scripts/build_v2_release.sh
```

This will create:
- `Build/EyeBreak.xcarchive` - Archive for distribution
- `Build/Export/EyeBreak.app` - Unsigned app bundle
- `Build/EyeBreak.zip` - ZIP archive for direct download
- `Build/EyeBreak-v2.0.0.dmg` - DMG installer
- `Build/*.sha256` - Checksum files

## Step 2: Test the Build

Before releasing, test both distribution formats:

### Test the DMG:
```bash
open Build/EyeBreak-v2.0.0.dmg
# Drag app to Applications, then launch
open /Applications/EyeBreak.app
```

### Test the ZIP:
```bash
unzip Build/EyeBreak.zip -d /tmp/
open /tmp/EyeBreak.app
```

### Verify Features:
- [ ] App launches successfully
- [ ] Menu bar icon appears
- [ ] Settings open correctly
- [ ] Color theme options are visible
- [ ] Default theme works
- [ ] Random Color theme generates colors
- [ ] Custom theme allows customization
- [ ] SF Symbol icon picker appears
- [ ] Ambient reminders display with themes
- [ ] Break overlay displays with themes
- [ ] Theme persistence works (quit and relaunch)

## Step 3: Commit and Tag

```bash
cd /Users/chansocheat.sok/Desktop/vibe-coding/eyebreak

# Add all changes
git add .

# Commit release files
git commit -m "Release v2.0.0 - Theme Customization System

- Complete theme customization with Default, Random, and Custom options
- 20 curated color palettes for Random Color theme
- Professional SF Symbol icon picker
- Independent theme settings for reminders and overlays
- Smart theme caching for consistent display
- Updated documentation and release notes"

# Create and push tag
git tag -a v2.0.0 -m "Version 2.0.0 - Theme Customization Release

Major Features:
- Complete theme customization system
- 20 curated random color palettes
- Custom theme editor with full control
- Professional SF Symbol icon picker
- Smart theme caching
- Independent theme settings

See RELEASE_NOTES_v2.0.0.md for full details"

# Push commits and tags
git push origin main
git push origin v2.0.0
```

## Step 4: Create GitHub Release

### Via GitHub Web Interface:

1. **Navigate to Releases:**
   - Go to: https://github.com/cheat2001/eyebreak/releases
   - Click "Draft a new release"

2. **Fill in Release Details:**

   **Choose a tag:** `v2.0.0` (should appear in dropdown after push)
   
   **Release title:** `🎨 v2.0.0 - Theme Customization Release`
   
   **Description:** Copy from RELEASE_NOTES_v2.0.0.md

   ```markdown
   # 🎨 EyeBreak v2.0.0 - Theme Customization Release

   We're excited to announce EyeBreak v2.0.0, a major update that brings powerful theme customization capabilities!

   ## 🌟 Highlights

   ### Complete Theme Customization System
   - **Default Theme** - Classic vibrant colors
   - **Random Color** - 20 curated palettes, fresh each time
   - **Custom Theme** - Full control over all colors and effects

   ### Enhanced Customization
   - Professional SF Symbol icon picker (16 icons)
   - Independent themes for reminders and overlays
   - Smart caching for consistent display
   - Live preview of theme changes

   ## 📦 Installation

   ### macOS (14.0+)

   **DMG Installer (Recommended):**
   1. Download `EyeBreak-v2.0.0.dmg`
   2. Remove quarantine: `xattr -cr EyeBreak-v2.0.0.dmg`
   3. Open DMG and drag to Applications
   4. Launch EyeBreak

   **ZIP Archive:**
   1. Download `EyeBreak.zip`
   2. Extract and move to Applications
   3. Launch EyeBreak

   ## 🔐 Checksums

   Verify your download integrity:

   **DMG SHA-256:**
   ```
   [SHA256 will be here after build]
   ```

   **ZIP SHA-256:**
   ```
   [SHA256 will be here after build]
   ```

   ## 📋 Full Changelog

   See [CHANGELOG.md](https://github.com/cheat2001/eyebreak/blob/main/CHANGELOG.md) for complete details.

   ### Added ✨
   - Complete color theme customization system
   - 20 curated random color palettes
   - Custom theme editor with live preview
   - Professional SF Symbol icon picker
   - Quick preset palettes
   - Theme caching for consistency
   - Independent theme settings

   ### Changed 🔄
   - Replaced emoji input with SF Symbol picker
   - Simplified theme rendering
   - Enhanced settings UI

   ### Fixed 🐛
   - Theme flickering during display
   - Color inconsistency issues
   - Theme switching stability

   ## 🆕 Coming from v1.0.0?

   Your settings will be preserved! Just replace the app and enjoy the new theme options.

   ## 📞 Support

   - Issues: [GitHub Issues](https://github.com/cheat2001/eyebreak/issues)
   - Discussions: [GitHub Discussions](https://github.com/cheat2001/eyebreak/discussions)

   ---

   **Full Diff:** [v1.0.0...v2.0.0](https://github.com/cheat2001/eyebreak/compare/v1.0.0...v2.0.0)
   ```

3. **Upload Assets:**
   - Drag and drop from `Build/` folder:
     - `EyeBreak-v2.0.0.dmg`
     - `EyeBreak.zip`
     - `EyeBreak-v2.0.0.dmg.sha256`
     - `EyeBreak.zip.sha256`

4. **Set as Latest Release:**
   - ✅ Check "Set as the latest release"
   - ✅ Check "Create a discussion for this release" (optional)

5. **Publish:**
   - Click "Publish release" 🚀

### Via GitHub CLI (Alternative):

```bash
# Install GitHub CLI if needed
# brew install gh

# Authenticate
gh auth login

# Create release
gh release create v2.0.0 \
  --title "🎨 v2.0.0 - Theme Customization Release" \
  --notes-file RELEASE_NOTES_v2.0.0.md \
  Build/EyeBreak-v2.0.0.dmg \
  Build/EyeBreak.zip \
  Build/EyeBreak-v2.0.0.dmg.sha256 \
  Build/EyeBreak.zip.sha256
```

## Step 5: Update Release Notes with Checksums

After uploading, add the actual SHA-256 checksums to the release description:

```bash
# Get checksums
cat Build/EyeBreak-v2.0.0.dmg.sha256
cat Build/EyeBreak.zip.sha256
```

Edit the release and paste the checksums in the appropriate sections.

## Step 6: Post-Release Actions

### Update Documentation

1. **Update README badges:**
   - Verify version badge shows v2.0.0
   - Check download links point to v2.0.0

2. **Announce the Release:**
   - Create discussion post in GitHub Discussions
   - Share on social media (if applicable)
   - Update project website (if any)

### Monitor and Respond

- [ ] Watch for issues related to the new release
- [ ] Respond to questions in Discussions
- [ ] Track download statistics
- [ ] Collect feedback for v2.1.0

## Rollback Plan (If Needed)

If critical issues are discovered:

1. **Mark release as pre-release:**
   - Edit release on GitHub
   - Check "This is a pre-release"

2. **Create hotfix:**
   ```bash
   git checkout -b hotfix/v2.0.1
   # Fix issues
   git commit -m "Hotfix: [description]"
   git tag v2.0.1
   git push origin hotfix/v2.0.1
   git push origin v2.0.1
   ```

3. **Create new release with fixes**

## Release Checklist

- [ ] Build script executed successfully
- [ ] DMG and ZIP tested on clean macOS system
- [ ] All features verified working
- [ ] Code committed and pushed
- [ ] Tag created and pushed
- [ ] GitHub release created
- [ ] Assets uploaded
- [ ] Checksums added to release notes
- [ ] Release published
- [ ] README updated
- [ ] Announcement posted

## Success Criteria

✅ Release is published on GitHub  
✅ DMG and ZIP are downloadable  
✅ Checksums match downloaded files  
✅ App launches and works correctly  
✅ All v2.0.0 features are functional  
✅ Documentation is accurate and complete  

---

**Congratulations on releasing v2.0.0! 🎉**
