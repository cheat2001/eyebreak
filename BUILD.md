# EyeBreak Build Instructions

## Prerequisites

- macOS 14.0 (Sonoma) or later
- Xcode 15.0 or later
- An Apple Developer account (for distribution)

## Building the Project

### 1. Open in Xcode

```bash
cd /Users/chansocheat.sok/Desktop/vibe-coding/lookaway
open EyeBreak.xcodeproj
```

### 2. Configure Signing

1. Select the EyeBreak target in Xcode
2. Go to "Signing & Capabilities"
3. Select your development team
4. Xcode will automatically generate a bundle identifier

### 3. Build and Run

- Press ⌘R to build and run
- Or use Product > Run from the menu

## Project Structure

```
EyeBreak/
├── EyeBreakApp.swift              # Main app entry point
├── Models/
│   ├── TimerState.swift           # Timer state management
│   └── Settings.swift             # User settings
├── Managers/
│   ├── BreakTimerManager.swift    # Core timer logic
│   ├── IdleDetector.swift         # Activity monitoring
│   ├── NotificationManager.swift  # Notification handling
│   └── ScreenBlurManager.swift    # Screen overlay management
├── Views/
│   ├── MenuBarView.swift          # Menu bar popover
│   ├── SettingsView.swift         # Settings panel
│   ├── BreakOverlayView.swift     # Break screen overlay
│   ├── OnboardingView.swift       # First launch experience
│   └── StatsView.swift            # Statistics display
├── Info.plist                     # App configuration
└── EyeBreak.entitlements         # App capabilities
```

## Permissions

The app requires these permissions to function:

### Notifications (Required)
- Requested automatically on first launch
- Used for break reminders

### Screen Recording (Optional)
- Required for screen blur feature
- Can be granted in System Settings > Privacy & Security > Screen Recording
- If denied, the app will show notification-only breaks

## Development Notes

### Testing

- Test on multiple displays to ensure overlay works correctly
- Test idle detection by leaving the Mac idle for >5 minutes
- Test sleep/wake cycle behavior
- Verify notification permissions work correctly

### Debugging

Enable verbose logging by adding to `EyeBreakApp.swift`:

```swift
init() {
    print("EyeBreak starting...")
    #if DEBUG
    UserDefaults.standard.set(true, forKey: "debugMode")
    #endif
}
```

## Distribution

### For Testing (Debug Build)

```bash
xcodebuild -project EyeBreak.xcodeproj -scheme EyeBreak -configuration Debug
```

### For App Store

1. Archive the app (Product > Archive)
2. In Organizer, select your archive
3. Click "Distribute App"
4. Choose "App Store Connect"
5. Follow the prompts to upload

### For Direct Distribution

1. Archive the app
2. Choose "Developer ID" distribution
3. Export the app
4. Notarize with Apple:

```bash
xcrun notarytool submit EyeBreak.zip \
  --apple-id your@email.com \
  --team-id TEAMID \
  --password your-app-specific-password
```

5. Staple the notarization:

```bash
xcrun stapler staple EyeBreak.app
```

## Troubleshooting

### Menu Bar Icon Not Appearing

- Check that `LSUIElement` is set to `true` in Info.plist
- Verify the app is running (check Activity Monitor)

### Screen Blur Not Working

- Grant Screen Recording permission in System Settings
- Restart the app after granting permission

### Timer Not Pausing on Idle

- Ensure idle detection is enabled in Settings
- Check that IOKit framework is properly linked

### Build Errors

- Clean build folder (⌘⇧K)
- Delete DerivedData: `rm -rf ~/Library/Developer/Xcode/DerivedData`
- Restart Xcode

## License

MIT License - See LICENSE file for details
