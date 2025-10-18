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
    case paused(wasWorking: Bool, remainingSeconds: Int) // Paused due to idle
    
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
    case notification = "Notification"
    case ambient = "Ambient Pop-up"
    case both = "Both"
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .notification:
            return "Show notification banner"
        case .ambient:
            return "Show floating reminder window"
        case .both:
            return "Show both notification and pop-up"
        }
    }
}
