# EyeBreak Architecture

This document describes the architecture and technical design of EyeBreak.

## Table of Contents
- [Overview](#overview)
- [Design Patterns](#design-patterns)
- [Core Components](#core-components)
- [Data Flow](#data-flow)
- [State Management](#state-management)
- [Permissions](#permissions)

## Overview

EyeBreak is built using modern macOS development practices:
- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI
- **Architecture**: MVVM (Model-View-ViewModel)
- **Reactive Programming**: Combine framework
- **Minimum Target**: macOS 14.0 (Sonoma)

## Design Patterns

### MVVM (Model-View-ViewModel)

```
┌─────────────┐         ┌──────────────────┐         ┌─────────────┐
│    Views    │────────▶│    Managers      │────────▶│   Models    │
│  (SwiftUI)  │◀────────│  (ViewModel)     │◀────────│   (Data)    │
└─────────────┘         └──────────────────┘         └─────────────┘
     │                          │                          │
     │                          │                          │
  User Input            Business Logic              State & Data
```

- **Views**: Pure SwiftUI views that observe state changes
- **Managers**: Business logic and state management (ViewModels)
- **Models**: Simple data structures and enums

### Observable Pattern

All managers conform to `ObservableObject` and use `@Published` properties to notify views of changes:

```swift
class BreakTimerManager: ObservableObject {
    @Published var state: TimerState = .idle
    @Published var secondsRemaining: Int = 0
}
```

## Core Components

### 1. App Entry Point

**File**: `EyeBreakApp.swift`

```swift
@main
struct EyeBreakApp: App {
    @StateObject private var timerManager = BreakTimerManager()
    @StateObject private var idleDetector = IdleDetector()
    
    var body: some Scene {
        MenuBarExtra("EyeBreak", systemImage: "eye") {
            MenuBarView()
        }
        .menuBarExtraStyle(.window)
    }
}
```

- Uses `MenuBarExtra` for menu bar integration
- Creates and injects managers into the environment
- Manages app lifecycle

### 2. Managers (Business Logic)

#### BreakTimerManager
**Purpose**: Core timer logic and state management

**Key Responsibilities**:
- Start/stop/pause timer
- Countdown logic
- State transitions (idle → working → preBreak → break)
- Coordinate with other managers
- Persist statistics

**Key Properties**:
```swift
@Published var state: TimerState
@Published var secondsRemaining: Int
@Published var totalBreaks: Int
@Published var breakHistory: [BreakRecord]
```

#### IdleDetector
**Purpose**: Monitor user activity and pause timer when idle

**Key Responsibilities**:
- Use IOKit to track system idle time
- Detect when user goes idle (>5 min default)
- Auto-resume on activity return
- Handle sleep/wake events

**Implementation**:
```swift
func checkIdleTime() {
    let idleTime = CGEventSource.secondsSinceLastEventType(
        .combinedSessionState, 
        eventType: .mouseMoved
    )
    if idleTime > threshold {
        pauseTimer()
    }
}
```

#### NotificationManager
**Purpose**: Handle all notification logic

**Key Responsibilities**:
- Request notification permissions
- Schedule pre-break warnings
- Send break notifications
- Handle notification actions

#### ScreenBlurManager
**Purpose**: Manage full-screen blur overlay

**Key Responsibilities**:
- Create and manage NSWindow overlays
- Apply blur effects
- Handle multi-display setups
- Capture user input to dismiss

### 3. Models

#### TimerState
```swift
enum TimerState: String {
    case idle
    case working
    case preBreak
    case onBreak
    case paused
}
```

#### Settings
```swift
struct AppSettings {
    var workInterval: Int = 20
    var breakDuration: Int = 20
    var preBreakWarning: Int = 30
    var breakStyle: BreakStyle = .blurScreen
    var soundEnabled: Bool = true
    // ... more settings
}
```

#### BreakRecord
```swift
struct BreakRecord: Codable {
    let timestamp: Date
    let completed: Bool
    let duration: Int
}
```

### 4. Views

#### MenuBarView
- Main popover interface
- Shows timer state and controls
- Displays quick stats
- Access to settings and stats views

#### BreakOverlayView
- Full-screen overlay during breaks
- Circular progress indicator
- Break instructions
- Early dismissal option

#### SettingsView
- Comprehensive settings interface
- Real-time preview of changes
- Preset configurations
- Reset to defaults

#### OnboardingView
- 4-page welcome flow
- Educational content
- Permission requests
- Only shown on first launch

#### StatsView
- Daily/weekly/monthly statistics
- Charts and graphs (macOS 13+)
- Insights and recommendations
- History management

## Data Flow

### Timer Flow

```
User clicks Start
       │
       ▼
BreakTimerManager.startTimer()
       │
       ▼
State: idle → working
       │
       ▼
Timer ticks every second
       │
       ▼
secondsRemaining decreases
       │
       ▼
Views auto-update (@Published)
       │
       ▼
When secondsRemaining == 30
       │
       ▼
State: working → preBreak
       │
       ▼
NotificationManager sends warning
       │
       ▼
When secondsRemaining == 0
       │
       ▼
State: preBreak → onBreak
       │
       ▼
ScreenBlurManager shows overlay
       │
       ▼
After break duration
       │
       ▼
State: onBreak → working
       │
       ▼
Cycle repeats
```

### Idle Detection Flow

```
IdleDetector polls every 5 seconds
       │
       ▼
Check CGEventSource idle time
       │
       ├──▶ Idle > threshold
       │    │
       │    ▼
       │    timerManager.pause()
       │    │
       │    ▼
       │    Show notification
       │
       └──▶ Activity detected
            │
            ▼
            timerManager.resume()
            │
            ▼
            Show notification
```

## State Management

### @StateObject vs @ObservedObject

- **@StateObject**: Used when creating the manager (owns the lifecycle)
  ```swift
  @StateObject private var timerManager = BreakTimerManager()
  ```

- **@ObservedObject**: Used when receiving from environment
  ```swift
  @ObservedObject var timerManager: BreakTimerManager
  ```

### @AppStorage for Persistence

Settings are persisted using `@AppStorage`:
```swift
@AppStorage("workInterval") var workInterval: Int = 20
@AppStorage("breakDuration") var breakDuration: Int = 20
```

### UserDefaults for Complex Data

Statistics and history use `UserDefaults`:
```swift
let encoder = JSONEncoder()
let data = try encoder.encode(breakHistory)
UserDefaults.standard.set(data, forKey: "breakHistory")
```

## Permissions

### Screen Recording

Required for screen blur overlay.

**Request**:
```swift
CGRequestScreenRecordingPermission()
```

**Check**:
```swift
CGPreflightScreenCaptureAccess()
```

**Fallback**: Use notification-only mode if denied

### Notifications

Required for break reminders.

**Request**:
```swift
UNUserNotificationCenter.current()
    .requestAuthorization(options: [.alert, .sound])
```

**Graceful Degradation**: App works without, but less effective

## Threading Model

### Main Thread
- All UI updates
- Timer callbacks
- State changes

### Background Threads
- None (app is lightweight enough for main thread)
- Future: Could move statistics calculations to background

## Performance Considerations

### Timer Optimization
- Uses `Timer.publish()` from Combine (efficient)
- Cancels timer when app is idle
- No unnecessary updates

### Memory Management
- Weak references where appropriate
- No retain cycles
- Proper cleanup in `deinit`

### Window Management
- Break overlay windows created on-demand
- Released immediately after break
- One window per display (multi-monitor support)

## Testing Strategy

### Manual Testing
- Core functionality tests in `TESTING.md`
- Permission scenarios
- Edge cases (sleep, multiple displays, etc.)

### Future: Unit Tests
- Test timer logic in isolation
- Test state transitions
- Mock managers for view testing

### Future: UI Tests
- Test user flows
- Test accessibility
- Automated smoke tests

## Future Enhancements

### Planned Architecture Improvements
1. **Dependency Injection**: Use a proper DI container
2. **Repository Pattern**: Abstract data persistence
3. **Coordinator Pattern**: Improve navigation
4. **Unit Tests**: Add comprehensive test coverage
5. **Analytics**: Optional, privacy-respecting usage metrics

### Scalability Considerations
- App is designed to be lightweight and simple
- Architecture supports adding new break styles
- Easy to add new reminder types
- Extensible settings system

---

For implementation details, see the source code in `/EyeBreak/`.
