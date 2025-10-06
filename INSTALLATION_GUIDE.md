# 📦 EyeBreak Installation Guide

## How to Install EyeBreak from DMG (User Experience)

This guide will walk you through installing EyeBreak just like a real user downloading it from GitHub.

## Step 1: Locate the DMG File

Your installer is here:
```
/Users/chansocheat.sok/Desktop/vibe-coding/eyebreak/Build/EyeBreak-v1.0.0.dmg
```

## Step 2: Open the DMG

1. **Double-click** `EyeBreak-v1.0.0.dmg` in Finder
2. A new Finder window will open showing the DMG contents
3. You should see the `EyeBreak.app` file

## Step 3: Install the App

### Option A: Drag to Applications (Recommended)
1. Open a **new Finder window** (⌘N)
2. Go to **Applications** folder in the sidebar
3. **Drag** `EyeBreak.app` from the DMG window to the **Applications** folder
4. Wait for the copy to complete

### Option B: Quick Access (Testing Only)
- You can run the app directly from the DMG without installing
- However, this is not recommended for permanent use

## Step 4: Eject the DMG

1. After copying, right-click the mounted DMG in Finder sidebar
2. Select **"Eject"**
3. Or drag it to the Trash

## Step 5: Launch EyeBreak

### First Launch Steps:

1. **Open Applications folder** (⌘ + Shift + A)
2. **Find EyeBreak.app**
3. **Right-click** (or Control + Click) on `EyeBreak.app`
4. Select **"Open"** from the menu

⚠️ **Important First Launch Note:**
Since the app isn't signed with an Apple Developer certificate, you'll see a security warning:

> "EyeBreak.app can't be opened because it is from an unidentified developer"

### To Open Unsigned App:

1. Click **"Cancel"**
2. Open **System Settings** (⌘ + Space, type "System Settings")
3. Go to **Privacy & Security**
4. Scroll down to the **Security** section
5. You should see: _"EyeBreak.app was blocked from use because it is not from an identified developer"_
6. Click **"Open Anyway"**
7. Click **"Open"** in the confirmation dialog

Alternatively, use this command in Terminal:
```bash
xattr -cr /Applications/EyeBreak.app
open /Applications/EyeBreak.app
```

## Step 6: Grant Permissions

When EyeBreak launches for the first time:

### 1. Notifications Permission
- **Dialog appears**: "EyeBreak would like to send you notifications"
- Click **"Allow"**
- This enables break reminders

### 2. Screen Recording Permission (for Blur Feature)
- EyeBreak will request this automatically
- Or manually grant it:
  1. Go to **System Settings** > **Privacy & Security**
  2. Click **Screen Recording** on the left
  3. Toggle **ON** for EyeBreak
  4. **Restart** EyeBreak after granting permission

## Step 7: Complete Onboarding

1. The onboarding screen will appear
2. Learn about the 20-20-20 rule
3. Explore features
4. Grant permissions when prompted

## Step 8: Start Using EyeBreak

1. Look for the **eye icon (👁️)** in your **menu bar** (top-right corner)
2. Click it to open the menu
3. Click **"Start Timer"**
4. Customize settings as needed

## 🧹 Uninstall Instructions

If you want to remove EyeBreak:

1. **Quit EyeBreak** (click menu bar icon > Quit)
2. **Delete from Applications**:
   ```bash
   rm -rf /Applications/EyeBreak.app
   ```
3. **Remove preferences** (optional):
   ```bash
   rm -rf ~/Library/Preferences/com.eyebreak.app.plist
   rm -rf ~/Library/Application\ Support/EyeBreak
   ```

## 🔧 Troubleshooting

### App Won't Open
- Make sure you used "Open Anyway" in System Settings
- Or run: `xattr -cr /Applications/EyeBreak.app`

### Menu Bar Icon Not Appearing
- Check System Settings > General > Login Items & Extensions
- Make sure EyeBreak is allowed

### Blur Not Working
- Grant Screen Recording permission in System Settings
- Restart the app after granting

### Permissions Keep Asking
- Make sure you're running from /Applications folder, not the DMG

## 📝 Testing as a Real User

To fully test the user experience:

1. **Delete current installed version** (if any):
   ```bash
   pkill -9 EyeBreak
   rm -rf /Applications/EyeBreak.app
   rm -rf ~/Library/Preferences/com.eyebreak.app.plist
   ```

2. **Mount the DMG**:
   ```bash
   open ~/Desktop/vibe-coding/eyebreak/Build/EyeBreak-v1.0.0.dmg
   ```

3. **Drag EyeBreak.app to Applications folder**

4. **Launch from Applications** and go through onboarding

## 🚀 For GitHub Release

When you're ready to share this with users:

1. Upload `EyeBreak-v1.0.0.dmg` to GitHub Releases
2. Add installation instructions in the release notes
3. Users download and follow these steps

---

**Questions or Issues?**
- GitHub Issues: https://github.com/cheat2001/eyebreak/issues
- Email: chansocheatsok2001@gmail.com

**Remember:** Every 20 minutes, look 20 feet away for 20 seconds! 👁️✨
