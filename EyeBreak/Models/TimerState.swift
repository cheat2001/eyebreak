//
//  TimerState.swift
//  EyeBreak
//
//  Created on October 5, 2025.
//

import Foundation

/// Represents the current state of the break timer
enum TimerState: Equatable {
    case idle              // Timer not started
    case working(remainingSeconds: Int)  // Working period
    case preBreak(remainingSeconds: Int) // Warning period before break
    case breaking(remainingSeconds: Int) // Break period
    case paused(wasWorking: Bool, remainingSeconds: Int) // Paused; see BreakTimerManager.pauseReasons
    
    var isActive: Bool {
        switch self {
        case .idle, .paused:
            return false
        case .working, .preBreak, .breaking:
            return true
        }
    }
    
    var displayText: String {
        switch self {
        case .idle:
            return "Ready to start"
        case .working(let seconds):
            return "Next break in \(formatTime(seconds))"
        case .preBreak(let seconds):
            return "Break starting in \(seconds)s"
        case .breaking(let seconds):
            return "Break time! \(seconds)s remaining"
        case .paused(_, let seconds):
            return "Paused - \(formatTime(seconds)) remaining"
        }
    }
    
    private func formatTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

/// Why the timer is currently paused.
///
/// Several independent sources can pause the timer — the user, going idle,
/// the screen locking, a meeting starting. They overlap constantly in practice
/// (you present, then step away, then come back), so the timer tracks the set
/// of active reasons and only resumes once every one of them has cleared.
/// Resuming on the first reason to clear would, for example, pop a break
/// overlay up mid-presentation just because the screen had been unlocked.
enum PauseReason: String, CaseIterable {
    case manual
    case idle
    case systemSleep
    case screenLocked
    case screenSaver
    case meeting

    /// Whether the user should be able to override this by pressing Resume.
    /// Automatic reasons re-assert themselves on the next poll, so only a
    /// manual pause is meaningfully user-clearable.
    var isUserClearable: Bool { self == .manual }

    var displayText: String {
        switch self {
        case .manual:       return "Paused"
        case .idle:         return "Paused - you're away"
        case .systemSleep:  return "Paused - Mac was asleep"
        case .screenLocked: return "Paused - screen locked"
        case .screenSaver:  return "Paused - screen saver"
        case .meeting:      return "Paused - you're in a meeting"
        }
    }
}

/// Break style options
enum BreakStyle: String, CaseIterable, Identifiable {
    case blurScreen = "Blur Screen"
    case notificationOnly = "Floating Window"
    case eyeExercise = "Eye Exercise"
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .blurScreen:
            return "Blur your screen during breaks"
        case .notificationOnly:
            return "Show a small floating reminder window"
        case .eyeExercise:
            return "Guided eye exercise instructions"
        }
    }
    
    var icon: String {
        switch self {
        case .blurScreen:
            return "eye.slash.fill"
        case .notificationOnly:
            return "rectangle.inset.filled.and.person.filled"
        case .eyeExercise:
            return "figure.walk"
        }
    }
}

/// Statistics for tracking break history
struct BreakStats: Codable {
    var date: Date
    var breaksCompleted: Int
    var breaksSkipped: Int
    var totalBreakTime: Int // in seconds
    
    init(date: Date = Date(), breaksCompleted: Int = 0, breaksSkipped: Int = 0, totalBreakTime: Int = 0) {
        self.date = date
        self.breaksCompleted = breaksCompleted
        self.breaksSkipped = breaksSkipped
        self.totalBreakTime = totalBreakTime
    }
}

/// Session type for different work patterns
enum SessionType: String, CaseIterable, Identifiable {
    case standard = "20-20-20"
    case pomodoro = "Pomodoro (25/5)"
    case custom = "Custom"
    
    var id: String { rawValue }
    
    var workMinutes: Int {
        switch self {
        case .standard:
            return 20
        case .pomodoro:
            return 25
        case .custom:
            return 20 // Default, will be overridden by user settings
        }
    }
    
    var breakSeconds: Int {
        switch self {
        case .standard:
            return 20
        case .pomodoro:
            return 300 // 5 minutes
        case .custom:
            return 20 // Default, will be overridden by user settings
        }
    }
}

/// Water reminder style options
enum WaterReminderStyle: String, CaseIterable, Identifiable {
    case blurScreen = "Blur Screen"
    case ambient = "Ambient Pop-up"
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .blurScreen:
            return "Full screen blur overlay with water reminder"
        case .ambient:
            return "Gentle floating reminder window at top of screen"
        }
    }
}
