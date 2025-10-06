# Menu Bar Icon Troubleshooting

## Issue
On some macOS versions (especially Sonoma/Sequoia), menu bar icons for `.accessory` mode apps may not appear immediately or at all.

## Why `.accessory` Mode?
EyeBreak uses `.accessory` activation policy to ensure:
- ✅ **Break overlays appear on YOUR CURRENT workspace** (not switching desktops)
- ✅ **No Dock icon** (prevents the app from "owning" a specific Space/desktop)
- ✅ **Overlays follow your mouse cursor** to the correct screen

This is ESSENTIAL for the app to work correctly across multiple workspaces.

## Workaround: Keyboard Shortcuts

Even if the menu bar icon isn't visible, the app is fully functional via keyboard shortcuts:

### Essential Shortcuts:
- **⌘⇧O** - Open Settings window
- **⌘⇧S** - Start timer
- **⌘⇧B** - Take break now
- **⌘⇧X** - Stop timer
- **⌘⇧R** - Show ambient reminder (test overlay)

### How to Use:
1. Launch EyeBreak app
2. Press **⌘⇧O** to open Settings
3. Configure your preferences (break intervals, ambient reminders, etc.)
4. Press **⌘⇧S** to start the timer
5. The app will automatically show break overlays on your current workspace

## Verifying It Works:
1. Open the app
2. Go to a different workspace/desktop
3. Press **⌘⇧R** 
4. A reminder should appear on YOUR CURRENT screen (not switch desktops)
5. This confirms the app is working correctly!

## Alternative: Check System Menu Bar
On newer macOS versions, menu bar items might be hidden by default:
1. Hold **⌘ (Command)** key
2. Drag menu bar icons to rearrange them
3. Look for the 👁️ eye icon - it might be collapsed/hidden

## If Menu Bar Icon Shows:
If you see the eye icon (👁️) in the menu bar, you can:
- Click it to see the full menu
- Access all features without keyboard shortcuts
- Same functionality as keyboard shortcuts

## Technical Details:
The `.accessory` mode is required because:
- `.regular` mode ties the app to a specific Space/desktop
- When you switch workspaces, overlays would appear on the wrong desktop
- `.accessory` apps have no Space affinity, so overlays can appear anywhere
- Trade-off: menu bar icons may not show on all macOS versions

This is a macOS limitation, not a bug in EyeBreak.
