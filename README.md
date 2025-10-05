# EyeBreak - Your Eyes Deserve a Break 👁️

A minimalistic, distraction-free macOS app that helps reduce digital eye strain by following the 20-20-20 rule: Every 20 minutes, look 20 feet away for 20 seconds.

## Features

- 🎯 **Menu Bar Integration** - Lightweight app that lives in your menu bar
- ⏰ **Smart Timer System** - Customizable work/break intervals with intelligent pausing
- 🌫️ **Screen Blur During Breaks** - Gentle enforcement to help you actually take breaks
- 🔔 **Pre-Break Notifications** - 30-second warning before breaks start
- 😴 **Automatic Idle Detection** - Pauses when you're away from your Mac
- 🎨 **Customizable Settings** - Adjust intervals, break styles, and sounds
- 🍅 **Pomodoro Mode** - Built-in 25/5 work/break cycles
- 📊 **Daily Stats** - Track your break history (stored locally only)
- ♿️ **Accessibility Support** - VoiceOver, Dynamic Type, and Reduced Motion
- 🔒 **Privacy-Focused** - Zero data collection, everything stays on your Mac

## Requirements

- macOS 14.0 (Sonoma) or later
- Xcode 15.0 or later (for building)
- Swift 5.9+

## Installation

### Option 1: Build from Source

1. Clone this repository
2. Open `EyeBreak.xcodeproj` in Xcode
3. Select your development team in Signing & Capabilities
4. Build and run (⌘R)

### Option 2: Download Release (Coming Soon)

Download the latest release from the Releases page.

## Permissions

EyeBreak requires the following permissions to function properly:

### Screen Recording Permission (Required for Screen Blur)
- Go to **System Settings** > **Privacy & Security** > **Screen Recording**
- Enable the checkbox next to **EyeBreak**
- Restart the app

### Notifications Permission (Optional but Recommended)
- The app will request notification permission on first launch
- Allow notifications to receive break reminders

## Usage

### First Launch
1. Launch EyeBreak - you'll see an eye icon in your menu bar
2. Complete the onboarding to learn about the 20-20-20 rule
3. Grant required permissions when prompted
4. Click "Start Timer" to begin your first session

### Menu Bar Controls
- Click the eye icon to open the control popover
- **Start/Stop** - Begin or pause your break timer
- **Take Break Now** - Trigger an immediate break
- **Settings** - Customize your experience

### During a Break
- Your screen will blur and show a break overlay
- Follow the on-screen instructions to rest your eyes
- Press **ESC** or click anywhere to end the break early (not recommended!)
- The break will automatically end after the configured duration

### Customization
Access settings from the menu bar popover:

- **Work Interval**: 10-60 minutes (default: 20)
- **Break Duration**: 10-60 seconds (default: 20)
- **Break Style**: Blur Screen, Notification Only, or Eye Exercise
- **Sound**: Enable/disable audio cues
- **Pomodoro Mode**: Use 25/5 work/break cycles
- **Idle Pause**: Automatically pause after 5 minutes of inactivity

## The 20-20-20 Rule

Digital eye strain affects millions of people who spend hours in front of screens. The 20-20-20 rule is a simple, scientifically-backed method to reduce eye fatigue:

- Every **20 minutes** of screen time
- Look at something **20 feet** away (about 6 meters)
- For **20 seconds**

This gives your eye muscles a chance to relax and reduces the risk of:
- Eye strain and fatigue
- Headaches
- Dry eyes
- Blurred vision
- Neck and shoulder pain

## Privacy

EyeBreak is designed with privacy as a core principle:

- ✅ All data stays on your Mac
- ✅ No analytics or tracking
- ✅ No internet connection required
- ✅ No data collection whatsoever
- ✅ Open source - verify for yourself

## Troubleshooting

### Screen Blur Not Working
- Ensure Screen Recording permission is granted
- Restart the app after granting permission
- Check System Settings > Privacy & Security > Screen Recording

### Notifications Not Appearing
- Check System Settings > Notifications > EyeBreak
- Ensure "Allow Notifications" is enabled
- Try different alert styles (Banners or Alerts)

### Timer Not Pausing During Idle
- Check that idle detection is enabled in Settings
- Ensure the idle threshold (5 minutes) is appropriate for your workflow

### App Not Appearing in Menu Bar
- Check that menu bar icons are not hidden (macOS can hide icons when space is limited)
- Try expanding the menu bar or reducing other menu bar apps

## Building for Distribution

### For App Store Submission

1. Configure signing with your Apple Developer account
2. Set up App Sandbox entitlements (already configured)
3. Archive the project (Product > Archive)
4. Validate and upload to App Store Connect

### For Direct Distribution

1. Archive the project
2. Export as a Developer ID-signed application
3. Notarize with Apple (required for macOS 10.14+)
4. Distribute the .app bundle or create a DMG

## Architecture

### Project Structure
```
EyeBreak/
├── EyeBreakApp.swift          # Main app entry point
├── Models/
│   ├── TimerState.swift       # Timer state management
│   └── Settings.swift         # App settings model
├── Views/
│   ├── MenuBarView.swift      # Menu bar popover UI
│   ├── SettingsView.swift     # Settings panel
│   ├── BreakOverlayView.swift # Full-screen break overlay
│   ├── OnboardingView.swift   # First-launch onboarding
│   └── StatsView.swift        # Break statistics
├── Managers/
│   ├── BreakTimerManager.swift # Core timer logic
│   ├── IdleDetector.swift      # User activity monitoring
│   ├── NotificationManager.swift # Notification handling
│   └── ScreenBlurManager.swift # Screen blur overlay
└── Resources/
    └── Assets.xcassets        # App icons and images
```

### Key Technologies
- **SwiftUI** - Modern, declarative UI framework
- **Combine** - Reactive state management
- **UserNotifications** - Local notifications
- **AppKit** - NSWindow management for overlays
- **IOKit** - Idle time detection
- **AVFoundation** - Audio playback

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

## License

MIT License - see LICENSE file for details

## Acknowledgments

- Inspired by [LookAway.app](https://lookaway.app)
- Built with ❤️ for healthier screen time habits
- Thanks to the macOS development community

## Support

If you find EyeBreak helpful, please consider:
- ⭐️ Starring this repository
- 🐛 Reporting bugs or suggesting features
- 📢 Sharing with others who need eye strain relief

---

**Remember**: Your eyes are precious. Take regular breaks! 👁️✨
