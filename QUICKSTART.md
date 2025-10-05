# EyeBreak - Quick Start Guide

## 🚀 Get Started in 5 Minutes

This guide will help you build and run EyeBreak immediately.

### Step 1: Verify Setup

Run the setup script to verify all files are in place:

```bash
cd /Users/chansocheat.sok/Desktop/vibe-coding/lookaway
./setup.sh
```

### Step 2: Open in Xcode

```bash
open EyeBreak.xcodeproj
```

Or open Xcode and use File > Open, then select `EyeBreak.xcodeproj`

### Step 3: Configure Signing

1. In Xcode, select the **EyeBreak** target (blue icon at the top of the file navigator)
2. Click the **Signing & Capabilities** tab
3. Under **Signing**, select your **Team** from the dropdown
   - If you don't have a team, select "Add an Account..." and sign in with your Apple ID
   - Free Apple IDs work fine for local development!

### Step 4: Build and Run

Press **⌘R** or click the ▶️ button in Xcode

That's it! The app should build and appear in your menu bar.

## 👁️ First Use

1. **Grant Permissions**
   - The app will request notification permission - click "Allow"
   - For screen blur, go to System Settings > Privacy & Security > Screen Recording
   - Enable EyeBreak, then restart the app

2. **Start Your First Timer**
   - Click the eye icon in your menu bar
   - Click "Start Timer"
   - Work for 20 minutes, then take your first break!

3. **Customize Settings**
   - Click the eye icon > Settings
   - Adjust work intervals, break duration, and break style
   - Try Pomodoro mode (25/5) or create custom intervals

## ⚙️ Troubleshooting

### "No Signing Certificate Found"
- Select your Team in Signing & Capabilities
- If no team exists, create a free Apple ID account

### "App Icon Missing" Warning
- This is normal for development
- The app uses SF Symbols for the menu bar icon
- See ICON_GUIDE.md to add proper app icons (optional)

### Screen Blur Not Working
- Grant Screen Recording permission in System Settings
- Restart the app after granting permission
- Alternative: Use "Notification Only" break style

### Timer Not Appearing in Menu Bar
- Check that the app is running (look in Activity Monitor)
- Try quitting and restarting the app
- Verify LSUIElement is set in Info.plist

## 🎯 Testing the App

### Test Break Cycle (Quick Test)
1. Temporarily change work interval to 1 minute in Settings
2. Start the timer
3. Wait 30 seconds - you should see a pre-break notification
4. Wait 1 minute total - break overlay should appear
5. Press ESC or wait 20 seconds for break to end
6. Reset your intervals to normal

### Test Idle Detection
1. Enable idle detection in Settings
2. Set threshold to 3 minutes
3. Start the timer
4. Leave your Mac idle for 3+ minutes
5. Timer should automatically pause
6. Move your mouse - timer should resume

### Test Multiple Displays
- If you have multiple monitors, start a break
- The blur overlay should appear on all screens

## 📚 Learn More

- **README.md** - Full feature documentation
- **BUILD.md** - Detailed build and distribution instructions
- **ICON_GUIDE.md** - How to create custom app icons

## 🎨 Customization Ideas

Try these customization options in Settings:

- **Pomodoro Mode**: 25 minutes work, 5 minutes break
- **Short Breaks**: 15 minutes work, 15 seconds break  
- **Long Breaks**: 50 minutes work, 10 minutes break
- **Notification Only**: No screen blur, just reminders
- **Eye Exercises**: Guided eye movement instructions

## 🐛 Known Issues

1. **First break might not blur screen** - Grant Screen Recording permission
2. **Stats not showing** - Take your first break to populate data
3. **Onboarding shows every time** - The app resets UserDefaults in debug mode

## 💡 Pro Tips

1. **Keyboard Shortcuts**
   - ESC during break = Skip break (not recommended!)
   - ⌘, in settings = Quick access to preferences

2. **Optimal Settings**
   - Start with 20-20-20 rule (default)
   - Enable idle detection to avoid false breaks
   - Use sound effects for subtle audio cues

3. **Staying Consistent**
   - Set a daily break goal (default: 24 breaks)
   - Check your statistics regularly
   - Aim for a streak of consecutive days

## 🤝 Contributing

Found a bug? Have a feature idea? 

1. Check the Issues page
2. Create a new issue with details
3. Or fork the repo and submit a pull request!

## 📞 Need Help?

If you encounter issues:

1. Check the Troubleshooting section above
2. Review BUILD.md for detailed build instructions
3. Open an issue on GitHub with:
   - Your macOS version
   - Xcode version
   - Error messages or screenshots
   - Steps to reproduce the problem

---

**Remember**: Your eyes are precious. Take those breaks! 👁️✨

Now go build something amazing with healthy eyes!
