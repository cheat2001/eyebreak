# EyeBreak v2.3.0 - Professional UI Polish Update

**Release Date:** December 6, 2025

This release focuses on delivering a cleaner, more professional user interface across the entire app. Every view has been polished with refined gradients, improved visual hierarchy, and smoother animations.

## What's New

### Menu Bar Timer Display

Your timer is now visible right in the menu bar!

**Features:**
- **Live Countdown:** See remaining time directly in the menu bar (e.g., "19:42")
- **State Icons:** Dynamic icons that change based on timer state
  - Eye icon when idle
  - Filled eye when working
  - Slashed eye during breaks
  - Pause icon when paused
- **Monospaced Digits:** Clean, professional font that doesn't shift as numbers change
- **Smart Tooltips:** Hover for detailed status information

### Enhanced Floating Break Window

The notification-style break window now features improved visual definition:

**Header Improvements:**
- Enhanced icon badge with stronger gradient fill and subtle border
- Added shadow for depth and visual pop
- Close button now has a visible border and better contrast

**Skip Button Enhancements:**
- Increased border visibility (more visible outline)
- Added subtle shadow for a more tactile appearance
- Bolder text weight for better readability

**Divider:**
- Increased opacity for clearer section separation

### Polished Onboarding Experience

First impressions matter. The onboarding flow now features:

**Feature Items:**
- Gradient icon badges with blue-to-cyan styling
- Subtle shadows for depth
- Spring animations on appearance

**Permission Cards:**
- Dynamic color theming based on state (orange for required, green for granted)
- Gradient backgrounds and borders
- Hover effects on action buttons
- Smooth scale animations

### Refined Settings Views

**About Section:**
- Hidden scrollbar for cleaner appearance
- More compact layout with optimized spacing
- Reduced icon and font sizes for better proportions
- Card-based layout with subtle shadows and borders

**Break Settings:**
- New `BreakStyleOptionCard` component with selection highlighting
- `EnhancedSliderCard` for timing controls with icons and colors
- `SectionHeaderView` component for consistent section styling

**Statistics View:**
- Gradient icon badges for all section headers
- Enhanced chart container with card styling and borders
- Color-coded legend for chart data
- `EnhancedStatBox` with gradient backgrounds and animations

### New Reusable Components

**SectionHeaderView:**
- Consistent header styling across all settings sections
- Icon + text with customizable colors
- Used throughout General, Breaks, and Statistics tabs

**ProfessionalButtonStyle:**
- Subtle press animation with scale and brightness effects
- Smooth easing for tactile feedback
- Applied to all action buttons

**HoverEffectModifier:**
- Unified hover behavior across interactive elements
- Background highlight and subtle scale effect
- Configurable corner radius

## Visual Improvements

### Gradients
- **Linear gradients** for icon backgrounds (blue-to-cyan theme)
- **Angular gradients** for progress rings
- **Consistent opacity** across all gradient fills

### Shadows
- Subtle drop shadows on cards and buttons
- Color-matched glow effects (e.g., blue shadow on blue buttons)
- Improved depth perception throughout the UI

### Animations
- **Spring animations** with tuned response and damping
- **Content transitions** for numeric text changes
- **Smooth state transitions** with opacity and scale effects

### Typography
- Rounded design fonts for friendly appearance
- Semibold weights for headings
- Monospaced digits for timer displays
- Consistent sizing hierarchy

## Technical Improvements

### Architecture
- Combine framework integration for reactive UI updates
- Published properties for automatic state propagation
- Efficient timer observers with weak references

### Code Quality
- Modular component design for reusability
- Consistent naming conventions
- Clear separation of concerns
- Comprehensive view modifiers

## Files Modified

### Views
- `FloatingBreakWindow.swift` - Header, skip button, divider enhancements
- `OnboardingView.swift` - FeatureItem, PermissionCard components
- `SettingsView.swift` - AboutView, SectionHeaderView, BreakStyleOptionCard, EnhancedSliderCard
- `StatsView.swift` - Section headers, chart styling, EnhancedStatBox
- `MenuBarView.swift` - ProfessionalButtonStyle, HoverEffectModifier

### Managers
- `StatusBarController.swift` - Menu bar timer display with live countdown

## Upgrade Notes

This is a UI-only update. No configuration changes are required:
- All your settings are preserved
- Statistics and history remain intact
- Timers continue to work as before

Simply update and enjoy the refreshed interface!

## Known Issues

None reported.

## Future Plans

- Additional theme customization options
- More animation refinements
- Accessibility improvements
- Localization support

---

**Upgrade today for a cleaner, more professional EyeBreak experience!**

## Version Info
- **Version:** 2.3.0
- **Build:** 2025.12.06
- **Release Date:** December 6, 2025
- **Compatibility:** macOS 14.0 (Sonoma) or later
- **Size:** ~5 MB
- **Language:** English
- **License:** MIT (Open Source)

---

*EyeBreak - Your Eyes Deserve a Break*
