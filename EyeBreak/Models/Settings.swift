//
//  Settings.swift
//  EyeBreak
//
//  Created on October 5, 2025.
//

import Foundation
import SwiftUI

/// App settings stored in UserDefaults
class AppSettings: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = AppSettings()
    
    // MARK: - Published Properties
    
    @AppStorage("workIntervalMinutes") var workIntervalMinutes: Int = 20
    @AppStorage("breakDurationSeconds") var breakDurationSeconds: Int = 20
    @AppStorage("preBreakWarningSeconds") var preBreakWarningSeconds: Int = 30
    @AppStorage("breakStyle") private var breakStyleRaw: String = BreakStyle.blurScreen.rawValue
    @AppStorage("soundEnabled") var soundEnabled: Bool = true
    @AppStorage("sessionType") private var sessionTypeRaw: String = SessionType.standard.rawValue
    @AppStorage("idleDetectionEnabled") var idleDetectionEnabled: Bool = true
    @AppStorage("idleThresholdMinutes") var idleThresholdMinutes: Int = 5
    @AppStorage("hasLaunchedBefore") var hasLaunchedBefore: Bool = false
    @AppStorage("dailyBreakGoal") var dailyBreakGoal: Int = 24 // Roughly every 20 min for 8 hours
    @AppStorage("eyeExerciseDurationSeconds") var eyeExerciseDurationSeconds: Int = 300 // 5 minutes default
    @AppStorage("exerciseIntervalSeconds") var exerciseIntervalSeconds: Int = 3 // Change direction every 3 seconds
    
    // Ambient reminders
    @AppStorage("ambientRemindersEnabled") var ambientRemindersEnabled: Bool = false
    @AppStorage("ambientReminderIntervalMinutes") var ambientReminderIntervalMinutes: Int = 5 // Pop up every 5 minutes
    @AppStorage("ambientReminderDurationSeconds") var ambientReminderDurationSeconds: Int = 8 // Stay for 8 seconds
    @AppStorage("customReminderEmoji") var customReminderEmoji: String = "" // Custom emoji
    @AppStorage("customReminderMessage") var customReminderMessage: String = "" // Custom message
    @AppStorage("useCustomReminder") var useCustomReminder: Bool = false // Use custom instead of random
    
    // Water reminders
    @AppStorage("waterReminderEnabled") var waterReminderEnabled: Bool = false
    @AppStorage("waterReminderInterval") var waterReminderInterval: TimeInterval = 3600 // 1 hour default (in seconds)
    @AppStorage("waterReminderStyle") private var waterReminderStyleRaw: String = WaterReminderStyle.notification.rawValue
    @AppStorage("customWaterReminderIcon") var customWaterReminderIcon: String = "" // Custom SF Symbol icon
    @AppStorage("customWaterReminderMessage") var customWaterReminderMessage: String = "" // Custom message
    @AppStorage("useCustomWaterReminder") var useCustomWaterReminder: Bool = false // Use custom instead of random
    
    // Color Theme Settings
    @AppStorage("ambientReminderThemeType") private var ambientReminderThemeTypeRaw: String = ColorThemeType.defaultTheme.rawValue
    @AppStorage("ambientReminderCustomTheme") private var ambientReminderCustomThemeData: Data?
    @AppStorage("breakOverlayThemeType") private var breakOverlayThemeTypeRaw: String = ColorThemeType.defaultTheme.rawValue
    @AppStorage("breakOverlayCustomTheme") private var breakOverlayCustomThemeData: Data?
    @AppStorage("waterReminderThemeType") private var waterReminderThemeTypeRaw: String = ColorThemeType.defaultTheme.rawValue
    @AppStorage("waterReminderCustomTheme") private var waterReminderCustomThemeData: Data?
    
    // Cached random themes (regenerated each time a new overlay/reminder appears)
    private var cachedAmbientReminderRandomTheme: ColorTheme?
    private var cachedBreakOverlayRandomTheme: ColorTheme?
    private var cachedWaterReminderRandomTheme: ColorTheme?
    
    // MARK: - Computed Properties
    
    var breakStyle: BreakStyle {
        get { BreakStyle(rawValue: breakStyleRaw) ?? .blurScreen }
        set { breakStyleRaw = newValue.rawValue }
    }
    
    var sessionType: SessionType {
        get { SessionType(rawValue: sessionTypeRaw) ?? .standard }
        set {
            sessionTypeRaw = newValue.rawValue
            // Update intervals based on session type
            if newValue != .custom {
                workIntervalMinutes = newValue.workMinutes
                breakDurationSeconds = newValue.breakSeconds
            }
        }
    }
    
    var waterReminderStyle: WaterReminderStyle {
        get { WaterReminderStyle(rawValue: waterReminderStyleRaw) ?? .notification }
        set { waterReminderStyleRaw = newValue.rawValue }
    }
    
    var workIntervalSeconds: Int {
        workIntervalMinutes * 60
    }
    
    var idleThresholdSeconds: Int {
        idleThresholdMinutes * 60
    }
    
    // MARK: - Color Theme Computed Properties
    
    /// Theme type for ambient reminders
    var ambientReminderThemeType: ColorThemeType {
        get { ColorThemeType(rawValue: ambientReminderThemeTypeRaw) ?? .defaultTheme }
        set { ambientReminderThemeTypeRaw = newValue.rawValue }
    }
    
    /// Get the active theme for ambient reminders
    var ambientReminderTheme: ColorTheme {
        get {
            switch ambientReminderThemeType {
            case .defaultTheme:
                return .defaultTheme
            case .randomColor:
                // Return cached theme if available, otherwise generate new one
                if let cached = cachedAmbientReminderRandomTheme {
                    return cached
                }
                let newTheme = ColorTheme.randomColorTheme()
                cachedAmbientReminderRandomTheme = newTheme
                return newTheme
            case .custom:
                if let data = ambientReminderCustomThemeData,
                   let theme = try? JSONDecoder().decode(ColorTheme.self, from: data) {
                    return theme
                }
                return .customTheme
            }
        }
        set {
            if newValue.themeType == .custom,
               let data = try? JSONEncoder().encode(newValue) {
                ambientReminderCustomThemeData = data
            }
        }
    }
    
    /// Generate a new random theme for ambient reminders
    func regenerateAmbientReminderRandomTheme() {
        if ambientReminderThemeType == .randomColor {
            cachedAmbientReminderRandomTheme = ColorTheme.randomColorTheme()
            objectWillChange.send()
        }
    }
    
    /// Theme type for break overlay
    var breakOverlayThemeType: ColorThemeType {
        get { ColorThemeType(rawValue: breakOverlayThemeTypeRaw) ?? .defaultTheme }
        set { breakOverlayThemeTypeRaw = newValue.rawValue }
    }
    
    /// Get the active theme for break overlay
    var breakOverlayTheme: ColorTheme {
        get {
            switch breakOverlayThemeType {
            case .defaultTheme:
                return .defaultTheme
            case .randomColor:
                // Return cached theme if available, otherwise generate new one
                if let cached = cachedBreakOverlayRandomTheme {
                    return cached
                }
                let newTheme = ColorTheme.randomColorTheme()
                cachedBreakOverlayRandomTheme = newTheme
                return newTheme
            case .custom:
                if let data = breakOverlayCustomThemeData,
                   let theme = try? JSONDecoder().decode(ColorTheme.self, from: data) {
                    return theme
                }
                return .customTheme
            }
        }
        set {
            if newValue.themeType == .custom,
               let data = try? JSONEncoder().encode(newValue) {
                breakOverlayCustomThemeData = data
            }
        }
    }
    
    /// Generate a new random theme for break overlay
    func regenerateBreakOverlayRandomTheme() {
        if breakOverlayThemeType == .randomColor {
            cachedBreakOverlayRandomTheme = ColorTheme.randomColorTheme()
            objectWillChange.send()
        }
    }
    
    // MARK: - Water Reminder Theme Properties
    
    /// Theme type for water reminders
    var waterReminderThemeType: ColorThemeType {
        get { ColorThemeType(rawValue: waterReminderThemeTypeRaw) ?? .defaultTheme }
        set { waterReminderThemeTypeRaw = newValue.rawValue }
    }
    
    /// Get the active theme for water reminders
    var waterReminderTheme: ColorTheme {
        get {
            switch waterReminderThemeType {
            case .defaultTheme:
                // Water-themed blue/cyan gradient
                return ColorTheme(
                    themeType: .defaultTheme,
                    backgroundColorHex: "#4D99CC",  // Ocean blue
                    backgroundOpacity: 0.75,
                    textColorHex: "#FFFFFF",
                    textOpacity: 0.95,
                    secondaryTextColorHex: "#FFFFFF",
                    secondaryTextOpacity: 0.75,
                    accentColorHex: "#66CCFF",  // Light cyan
                    accentOpacity: 0.85,
                    glassBlurRadius: 1.0,
                    glassHighlightOpacity: 0.25
                )
            case .randomColor:
                // Return cached theme if available, otherwise generate new one
                if let cached = cachedWaterReminderRandomTheme {
                    return cached
                }
                let newTheme = ColorTheme.randomColorTheme()
                cachedWaterReminderRandomTheme = newTheme
                return newTheme
            case .custom:
                if let data = waterReminderCustomThemeData,
                   let theme = try? JSONDecoder().decode(ColorTheme.self, from: data) {
                    return theme
                }
                return .customTheme
            }
        }
        set {
            if newValue.themeType == .custom,
               let data = try? JSONEncoder().encode(newValue) {
                waterReminderCustomThemeData = data
            }
        }
    }
    
    /// Generate a new random theme for water reminders
    func regenerateWaterReminderRandomTheme() {
        if waterReminderThemeType == .randomColor {
            cachedWaterReminderRandomTheme = ColorTheme.randomColorTheme()
            objectWillChange.send()
        }
    }
    
    // MARK: - Statistics Management
    
    private let statsKey = "breakStatistics"
    
    func getTodayStats() -> BreakStats {
        let allStats = getAllStats()
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let todayStats = allStats.first(where: { calendar.isDate($0.date, inSameDayAs: today) }) {
            return todayStats
        } else {
            return BreakStats(date: today)
        }
    }
    
    func updateStats(breaksCompleted: Int = 0, breaksSkipped: Int = 0, breakTime: Int = 0) {
        var allStats = getAllStats()
        var todayStats = getTodayStats()
        
        todayStats.breaksCompleted += breaksCompleted
        todayStats.breaksSkipped += breaksSkipped
        todayStats.totalBreakTime += breakTime
        
        // Remove old entry for today if exists
        let calendar = Calendar.current
        allStats.removeAll { calendar.isDate($0.date, inSameDayAs: todayStats.date) }
        
        // Add updated stats
        allStats.append(todayStats)
        
        // Keep only last 30 days
        allStats.sort { $0.date > $1.date }
        if allStats.count > 30 {
            allStats = Array(allStats.prefix(30))
        }
        
        saveStats(allStats)
        objectWillChange.send()
    }
    
    func getAllStats() -> [BreakStats] {
        guard let data = UserDefaults.standard.data(forKey: statsKey),
              let stats = try? JSONDecoder().decode([BreakStats].self, from: data) else {
            return []
        }
        return stats
    }
    
    private func saveStats(_ stats: [BreakStats]) {
        if let data = try? JSONEncoder().encode(stats) {
            UserDefaults.standard.set(data, forKey: statsKey)
        }
    }
    
    func resetStats() {
        UserDefaults.standard.removeObject(forKey: statsKey)
        objectWillChange.send()
    }
    
    // MARK: - Helper Methods
    
    func resetToDefaults() {
        workIntervalMinutes = 20
        breakDurationSeconds = 20
        preBreakWarningSeconds = 30
        breakStyle = .blurScreen
        soundEnabled = true
        sessionType = .standard
        idleDetectionEnabled = true
        idleThresholdMinutes = 5
        dailyBreakGoal = 24
    }
    
    func completeOnboarding() {
        hasLaunchedBefore = true
    }
}
