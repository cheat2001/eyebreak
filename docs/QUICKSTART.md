# Quick Start Guide

Get EyeBreak up and running in 5 minutes! ⚡️

## Prerequisites

- macOS 14.0 (Sonoma) or later
- Xcode 15.0 or later
- 10 minutes of your time

## Step 1: Clone the Repository

```bash
git clone https://github.com/cheat2001/eyebreak.git
cd eyebreak
```

## Step 2: Open in Xcode

```bash
open EyeBreak.xcodeproj
```

Or double-click `EyeBreak.xcodeproj` in Finder.

## Step 3: Configure Signing

1. In Xcode, select the **EyeBreak** project in the navigator
2. Select the **EyeBreak** target
3. Go to **Signing & Capabilities** tab
4. Select your **Team** from the dropdown (your Apple ID)

> **Note**: If you don't have a team, sign in with your Apple ID in Xcode Preferences > Accounts

## Step 4: Build and Run

Press **⌘R** or click the Play button in Xcode.

The app will build and launch. You'll see an eye icon (👁️) in your menu bar!

## Step 5: Complete Onboarding

1. Click the eye icon in the menu bar
2. Follow the 4-page onboarding:
   - Welcome screen
   - Learn about the 20-20-20 rule
   - Feature overview
   - Grant permissions

## Step 6: Grant Permissions

### Notifications (Recommended)
- Click "Allow" when prompted
- Or go to **System Settings** > **Notifications** > **EyeBreak**

### Screen Recording (Required for Blur)
1. Go to **System Settings** > **Privacy & Security**
2. Click **Screen Recording**
3. Enable the checkbox next to **EyeBreak**
4. Restart the app

> **Note**: If you skip this, the app will use "Notification Only" mode

## Step 7: Start Your First Break Session

1. Click the eye icon in your menu bar
2. Click **"Start Timer"**
3. Work for 20 minutes
4. Take a 20-second break when prompted!

## Customization

Want to change the intervals? Click the eye icon and select **Settings**:

- **Work Interval**: 10-60 minutes
- **Break Duration**: 10-60 seconds
- **Break Style**: Blur Screen / Notification Only / Eye Exercise
- **Session Type**: 20-20-20 / Pomodoro (25/5) / Custom

## Tips for First-Time Users

### Start with Defaults
The default 20-20-20 settings are scientifically recommended. Try them first!

### Enable Sound
Audio cues help you know when breaks are coming. Toggle in Settings.

### Check Your Stats
Click the eye icon > **View Stats** to see your break history and daily progress.

### Use Pomodoro Mode
If you prefer 25-minute work intervals, enable Pomodoro mode in Settings.

## Troubleshooting

### App Not in Menu Bar?
- Check that menu bar items aren't hidden (macOS can hide icons when space is limited)
- Try quitting other menu bar apps temporarily

### Screen Not Blurring?
- Grant Screen Recording permission (see Step 6)
- Restart the app after granting permission

### Notifications Not Showing?
- Check System Settings > Notifications > EyeBreak
- Try "Alerts" instead of "Banners" for more persistent notifications

### Timer Not Starting?
- Check Console.app for errors (filter by "EyeBreak")
- Try building a clean build: **⌘⇧K** then **⌘R**

## Next Steps

- 📖 Read the [Full Documentation](../README.md)
- 🏗️ Learn about [Architecture](ARCHITECTURE.md)
- 🧪 See [Testing Guide](TESTING.md)
- 💡 Check out [FAQ](FAQ.md)
- 🤝 Read [Contributing Guidelines](../CONTRIBUTING.md)

## Support

Having issues? 
- Check the [FAQ](FAQ.md)
- Open an [Issue](https://github.com/cheat2001/eyebreak/issues)
- Review [Common Problems](FAQ.md#troubleshooting)

---

**Congratulations! You're all set.** 🎉

Remember: Every 20 minutes, look 20 feet away for 20 seconds. Your eyes will thank you! 👁️✨
