# EyeBreak - Frequently Asked Questions (FAQ)

## General Questions

### What is EyeBreak?
EyeBreak is a macOS menu bar app that helps reduce digital eye strain by reminding you to take regular breaks following the 20-20-20 rule.

### What is the 20-20-20 rule?
Every 20 minutes, look at something 20 feet away for 20 seconds. This simple technique helps reduce eye strain, headaches, and fatigue from prolonged screen use.

### Is EyeBreak free?
Yes! The source code is provided under MIT License. You can use, modify, and distribute it freely.

### Does EyeBreak collect my data?
No. EyeBreak collects zero data. All statistics are stored locally on your Mac. There's no analytics, no tracking, and no internet connection required.

## Installation & Setup

### How do I install EyeBreak?
1. Open the Xcode project
2. Select your development team
3. Press ⌘R to build and run
4. The app will appear in your menu bar

For detailed instructions, see QUICKSTART.md.

### What macOS version do I need?
macOS 14.0 (Sonoma) or later. The app is built with the latest Swift and SwiftUI features.

### Do I need Xcode to run it?
Currently yes, as this is the source code version. You can build it once and then run the .app file without Xcode.

### Can I run this on older macOS versions?
The minimum deployment target is macOS 14.0. To support older versions, you'd need to:
- Change deployment target in Xcode
- Replace MenuBarExtra with NSStatusItem
- Conditionally compile Charts (macOS 13+)

## Permissions

### Why does EyeBreak need permissions?
- **Notifications**: To send break reminders
- **Screen Recording**: To blur your screen during breaks

### Do I have to grant Screen Recording permission?
No. If you don't grant it, the app will use "Notification Only" mode instead of screen blur.

### How do I grant Screen Recording permission?
1. Go to System Settings
2. Privacy & Security > Screen Recording
3. Enable the checkbox next to EyeBreak
4. Restart the app

### Is Screen Recording permission safe?
Yes. EyeBreak only uses this permission to create a blur overlay. It never actually records or saves your screen content.

## Features & Usage

### How do I start using EyeBreak?
1. Click the eye icon in your menu bar
2. Click "Start Timer"
3. Work normally for 20 minutes
4. Take your break when notified

### Can I customize the break intervals?
Yes! Click the eye icon > Settings, then adjust:
- Work interval (10-60 minutes)
- Break duration (10-60 seconds)
- Pre-break warning time

### What is Pomodoro mode?
Pomodoro is a time management technique: 25 minutes of work followed by a 5-minute break. Enable it in Settings > Session Type.

### Can I skip a break?
Yes, press ESC or click anywhere during the break. However, we don't recommend it—your eyes need the rest!

### Does the timer pause when I'm away?
Yes! If idle detection is enabled (default), the timer automatically pauses after 5 minutes of no activity and resumes when you return.

### Can I take a break before the timer ends?
Absolutely! Click the eye icon and press "Take Break Now" anytime.

## Break Styles

### What are the different break styles?

**Blur Screen** (default)
- Blurs your entire screen
- Shows motivational message
- Forces you to look away

**Notification Only**
- Just sends a notification
- No screen blur
- Good for presentations/meetings

**Eye Exercise**
- Guided eye movement instructions
- Helps exercise eye muscles
- Educational approach

### How do I change the break style?
Settings > Break Style > Choose your preference

### Does the blur work on multiple monitors?
Yes! The blur overlay appears on all connected displays.

## Statistics

### What statistics does EyeBreak track?
- Breaks completed today
- Breaks skipped today
- Total break time
- 7-day or 30-day history
- Daily goal progress
- Current streak

### How do I see my statistics?
Click the eye icon > Settings > Statistics tab

### Can I export my statistics?
Not currently, but this could be added as a future feature. All data is stored in UserDefaults.

### How do I reset my statistics?
Settings > Statistics > Reset Statistics button (bottom of the page)

## Technical Questions

### Why is the app not appearing in my Dock?
This is intentional! EyeBreak is a menu bar app only. It's designed to be unobtrusive. The LSUIElement setting in Info.plist hides it from the Dock.

### How much battery does EyeBreak use?
Very little. The app uses minimal CPU (<1% when idle) and has low memory footprint (~30-50MB). Battery impact is negligible.

### Does EyeBreak work with full-screen apps?
The blur overlay should work with most apps. However, some full-screen games or apps with elevated privileges might prevent the overlay from appearing.

### Can I use EyeBreak on multiple Macs?
Yes! Build it on each Mac or copy the .app file. Settings are stored locally on each Mac.

### Does EyeBreak interfere with my work?
No. It only takes action during breaks. The pre-break warning gives you 30 seconds to finish what you're doing.

## Troubleshooting

### The app built successfully but I don't see it in the menu bar
1. Check Activity Monitor - is EyeBreak running?
2. Check if your menu bar is full (macOS hides icons when space is limited)
3. Try quitting and restarting the app

### Break overlay is not showing
1. Grant Screen Recording permission in System Settings
2. Restart the app after granting permission
3. Try "Notification Only" mode if permission issues persist

### Notifications are not appearing
1. Check System Settings > Notifications > EyeBreak
2. Ensure "Allow Notifications" is enabled
3. Try different alert styles (Banners or Alerts)

### Timer is not pausing when I'm idle
1. Check that Idle Detection is enabled in Settings
2. Adjust the idle threshold (default: 5 minutes)
3. Try moving your mouse after being idle

### The app crashes on launch
1. Check Console app for error messages
2. Ensure you're running macOS 14.0 or later
3. Try cleaning build folder (⌘⇧K in Xcode)
4. Delete DerivedData and rebuild

### Statistics are not showing
You need to complete at least one break for statistics to appear. Take your first break to populate the data!

### App icon is showing as generic
This is normal for development builds. App icons are optional for menu bar apps since they primarily show in the menu bar.

## Customization

### Can I change the menu bar icon?
The icon is defined in `MenuBarView.swift`. You can change it to any SF Symbol or custom image.

### Can I customize the break messages?
Currently no, but you can edit them in `BreakOverlayView.swift`. This could be a future settings option.

### Can I add custom sounds?
The app uses system sounds. You could add custom sounds by:
1. Adding sound files to Resources
2. Using AVAudioPlayer instead of NSSound
3. Adding a sound picker in Settings

### Can I change the colors/theme?
Yes! The app uses system colors but you can customize them in the SwiftUI views. Look for `.foregroundStyle()` and `.background()` modifiers.

## Development

### Can I contribute to EyeBreak?
Absolutely! The code is open source under MIT License. Fork it, make improvements, and share back.

### What technologies does EyeBreak use?
- Swift 5.9+
- SwiftUI for UI
- Combine for state management
- IOKit for idle detection
- UserNotifications for alerts
- AppKit for window management

### How can I add a new feature?
1. Fork the repository
2. Create a new branch
3. Implement your feature
4. Test thoroughly
5. Submit a pull request

### Where should I report bugs?
Create an issue on GitHub with:
- macOS version
- Xcode version
- Steps to reproduce
- Expected vs actual behavior
- Screenshots if relevant

### Can I sell apps based on this code?
Yes! The MIT License allows commercial use. You can build upon this code and sell your version.

## Distribution

### How do I distribute EyeBreak to others?
**Option 1**: Share the source code (they build it themselves)
**Option 2**: Archive and export as Developer ID app (requires paid Apple Developer account)
**Option 3**: Submit to App Store (requires icons and Apple Developer account)

### Do I need a paid Apple Developer account?
- **For local use**: No, free Apple ID works
- **For sharing**: Yes, you need Developer ID ($99/year)
- **For App Store**: Yes, required ($99/year)

### How do I prepare for App Store submission?
1. Design proper app icons (see ICON_GUIDE.md)
2. Update bundle identifier to your domain
3. Add screenshots and app description
4. Archive and upload to App Store Connect
5. Submit for review

### Can I monetize EyeBreak?
Yes! The MIT License allows commercial use. Suggested pricing: Free, $2.99, or $4.99.

## Privacy & Security

### Does EyeBreak access my files?
No. The app is sandboxed and only accesses UserDefaults for settings storage.

### Is my break history private?
Yes. All statistics are stored locally in UserDefaults on your Mac. Nothing is sent anywhere.

### Does EyeBreak require internet?
No. The app works completely offline.

### Is EyeBreak safe?
Yes. The code is open source—you can review it yourself. No network calls, no data collection, no hidden features.

## Comparison

### How is EyeBreak different from other break apps?

**vs. Time Out**
- Modern SwiftUI interface
- Open source
- Privacy-focused

**vs. Stretchly**
- Native macOS app (not Electron)
- Better performance
- macOS-specific features

**vs. LookAway**
- Open source alternative
- Free to use and modify
- Active development

## Future Plans

### What features are planned?
Potential future enhancements:
- Launch at login
- iCloud sync for settings
- Customizable break messages
- Break exercise videos
- Calendar integration
- HealthKit integration
- Shortcuts support

### When will version 2.0 be released?
This depends on community feedback and contributions. Focus areas:
- Enhanced statistics
- More break styles
- Better accessibility
- Performance improvements

### Can I request a feature?
Yes! Create an issue on GitHub describing:
- The feature you want
- Why it would be useful
- How it might work

## Support

### Where can I get help?
1. Read the documentation (README, QUICKSTART, BUILD)
2. Check this FAQ
3. Search existing GitHub issues
4. Create a new issue if needed

### How can I support the project?
- ⭐️ Star the repository
- 🐛 Report bugs
- 💡 Suggest features
- 🔀 Contribute code
- 📢 Share with others
- ☕️ Buy the developer a coffee (if donation links provided)

### Is there a community?
Start one! Share your experience, help others, contribute improvements. Open source thrives on community participation.

---

## Still Have Questions?

If your question isn't answered here:
1. Check the comprehensive README.md
2. Review BUILD.md for technical details
3. Look at TESTING.md for feature information
4. Create an issue on GitHub

**Remember: Your eyes deserve regular breaks. Use EyeBreak and stay healthy!** 👁️✨
