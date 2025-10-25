# Water Reminder Feature Documentation

## Overview
The Water Reminder feature adds gentle, customizable hydration reminders to help users stay healthy during work sessions. This feature integrates seamlessly with EyeBreak's existing reminder system.

## ✨ Features Implemented

### 1. **Professional SF Symbols Icons**
- ✅ Replaced emojis with professional SF Symbol icons
- ✅ 8 curated water-related icons (drop.fill, waterbottle.fill, etc.)
- ✅ Hierarchical rendering mode for modern appearance
- ✅ Consistent with app's design language

### 2. **Sound Support**
- ✅ Plays "Glass" sound effect when reminder appears
- ✅ Respects global sound settings
- ✅ Works for both notification and ambient styles

### 3. **Three Reminder Styles**
1. **Notification** - System notification banner
2. **Ambient Pop-up** - Floating glass-morphism window
3. **Both** - Notification + pop-up for maximum visibility

### 4. **Full Customization**
- ✅ Custom icon picker with 16 water-themed SF Symbols
- ✅ Custom message input
- ✅ Live preview of custom reminder
- ✅ Toggle between random and custom reminders
- ✅ Blue/cyan color theme (water-inspired)

### 5. **Flexible Timing**
- 30 minutes
- 45 minutes
- 1 hour (default)
- 1.5 hours
- 2 hours

## 🎨 UI Components

### Settings Section Location
**Settings → Breaks Tab → 💧 Water Reminders**

### Components Added
1. **Toggle Card** - Enable/disable with gradient animation
2. **Interval Picker** - Segmented control for timing
3. **Style Picker** - Choose notification, ambient, or both
4. **Test Button** - Preview reminder instantly
5. **Customization Section** - Icon picker + message input
6. **Preview Card** - See custom reminder before using

### Custom Icon Picker
Curated water-related SF Symbols:
- drop.fill
- waterbottle.fill
- drop.circle.fill
- drop.triangle.fill
- cup.and.saucer.fill
- mug.fill
- figure.water.fitness
- sparkles
- leaf.fill
- heart.fill
- hands.and.sparkles.fill
- sun.max.fill
- moon.stars.fill
- clock.fill
- bell.fill
- hand.raised.fill

## 🔧 Technical Implementation

### Files Modified
1. **WaterReminderManager.swift** (New)
   - Timer management
   - Sound playback
   - Notification scheduling
   - Ambient window display
   - Custom message support

2. **Settings.swift**
   - `waterReminderEnabled: Bool`
   - `waterReminderInterval: TimeInterval`
   - `waterReminderStyle: WaterReminderStyle`
   - `customWaterReminderIcon: String`
   - `customWaterReminderMessage: String`
   - `useCustomWaterReminder: Bool`

3. **TimerState.swift**
   - Added `WaterReminderStyle` enum

4. **SettingsView.swift**
   - Water reminder section UI
   - CustomWaterIconPickerView component
   - WaterIconOptionButton component

5. **EyeBreakApp.swift**
   - Auto-start on launch
   - Keyboard shortcut: `⌘⇧W`
   - Menu bar command

### Architecture
```
WaterReminderManager (Singleton)
├── Timer scheduling
├── Message randomization
├── Custom message support
├── Sound playback
└── Display methods
    ├── showNotificationReminder()
    └── showAmbientReminder()
        └── WaterReminderView (SwiftUI)
```

## ⌨️ Keyboard Shortcuts
- `⌘⇧W` - Show water reminder immediately (global & local)

## 🎯 User Experience

### Default Messages (8 variations)
1. "Time for Water! - Stay hydrated! Take a sip of water."
2. "Hydration Check - Don't forget to drink some water!"
3. "Water Break - Your body needs water. Take a quick sip!"
4. "Stay Hydrated - Grab a glass of water and refresh yourself."
5. "Quick Reminder - Have you had water recently? Time to hydrate!"
6. "Drink Up! - Keep your energy up with some water."
7. "Hydration Time - A sip of water helps you stay focused!"
8. "Wellness Check - Take a moment to drink some water."

### Custom Reminder Flow
1. User enables "Use Custom Reminder"
2. User selects icon from grid picker
3. User types custom message
4. Preview shows live update
5. Test button to verify appearance
6. Reminder uses custom content

### Visual Design
- **Color Theme**: Blue/Cyan gradients (water-inspired)
- **Icon Style**: Hierarchical SF Symbols
- **Animation**: Spring animations for smooth transitions
- **Layout**: Glass-morphism with rounded corners
- **Shadow**: Soft blue shadow for depth

## 📊 Settings Persistence
All settings stored in UserDefaults:
- `waterReminderEnabled`
- `waterReminderInterval`
- `waterReminderStyle`
- `customWaterReminderIcon`
- `customWaterReminderMessage`
- `useCustomWaterReminder`

## 🔄 Integration with Existing Features

### Works Alongside
- ✅ Eye break reminders (independent timer)
- ✅ Ambient reminders (different purpose)
- ✅ Sound settings (respects global toggle)
- ✅ Notification permissions (uses same system)

### Similar Pattern To
- Ambient Reminders (customization UI)
- Break Overlays (glass-morphism design)
- Settings Structure (consistent layout)

## 🚀 Next Steps for User

### To Use the Feature:
1. Open Xcode project
2. Add `WaterReminderManager.swift` to the project:
   - Right-click **Managers** folder
   - Select **"Add Files to 'EyeBreak'..."**
   - Navigate to `EyeBreak/Managers/WaterReminderManager.swift`
   - Ensure **EyeBreak target is checked**
   - Click **Add**
3. Build and run the project
4. Open Settings → Breaks tab
5. Find **💧 Water Reminders** section
6. Enable and configure!

## 💡 Usage Tips

### Recommended Settings
- **Interval**: 1 hour (for typical office work)
- **Style**: Ambient (non-intrusive but visible)
- **Custom**: Use for personal motivation messages

### Best Practices
- Don't set interval too short (< 30 min can be annoying)
- Test with `⌘⇧W` before committing to schedule
- Use custom messages that resonate with you
- Combine with ambient reminders for full wellness

## 🎨 Design Philosophy

### Professional & Consistent
- SF Symbols instead of emojis
- Matches app's existing design language
- Blue/cyan theme (distinct from orange ambient reminders)

### User-Friendly
- Clear labeling and descriptions
- Live previews
- Helpful suggestions
- Test button for immediate feedback

### Flexible
- Multiple timing options
- Three reminder styles
- Full customization capability
- Easy to enable/disable

## 🐛 Error Handling
- Gracefully handles missing sound files
- Falls back to default icon if custom is empty
- Handles notification permission denial
- Timer cleanup on disable

## 🎉 Success Metrics
- Non-intrusive but effective
- Customizable to personal preferences
- Integrates seamlessly with existing features
- Maintains app's professional aesthetic
- Encourages healthy habits

---

**Version**: 1.0.0  
**Date**: October 18, 2025  
**Status**: Ready for testing
