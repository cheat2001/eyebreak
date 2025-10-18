//
//  SettingsView.swift
//  EyeBreak
//
//  Created on October 5, 2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var timerManager: BreakTimerManager
    @EnvironmentObject var settings: AppSettings
    @Environment(\.openWindow) var openWindow
    
    @State private var selectedTab: Tab = .general
    
    enum Tab: String, CaseIterable {
        case general = "General"
        case breaks = "Breaks"
        case statistics = "Statistics"
        case about = "About"
        
        var icon: String {
            switch self {
            case .general: return "gearshape.fill"
            case .breaks: return "timer"
            case .statistics: return "chart.bar.fill"
            case .about: return "info.circle.fill"
            }
        }
    }
    
    var body: some View {
        NavigationSplitView {
            List(Tab.allCases, id: \.self, selection: $selectedTab) { tab in
                Label(tab.rawValue, systemImage: tab.icon)
                    .tag(tab)
            }
            .navigationSplitViewColumnWidth(150)
        } detail: {
            VStack(spacing: 0) {
                // Large Countdown Timer Display at the top
                TimerStatusBanner()
                    .environmentObject(timerManager)
                    .environmentObject(settings)
                
                Divider()
                
                // Main content
                Group {
                    switch selectedTab {
                    case .general:
                        GeneralSettingsView()
                    case .breaks:
                        BreakSettingsView()
                    case .statistics:
                        StatsView()
                    case .about:
                        AboutView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle("EyeBreak Settings")
    }
}

// MARK: - General Settings

struct GeneralSettingsView: View {
    @EnvironmentObject var settings: AppSettings
    
    var body: some View {
        Form {
            Section {
                Toggle("Launch at Login", isOn: .constant(false))
                    .disabled(true)
                    .help("Coming soon")
                
                Toggle("Enable Sound Effects", isOn: $settings.soundEnabled)
                
                Toggle("Idle Detection", isOn: $settings.idleDetectionEnabled)
                
                if settings.idleDetectionEnabled {
                    Picker("Idle Threshold", selection: $settings.idleThresholdMinutes) {
                        Text("3 minutes").tag(3)
                        Text("5 minutes").tag(5)
                        Text("10 minutes").tag(10)
                        Text("15 minutes").tag(15)
                    }
                }
            } header: {
                Text("General")
            }
            
            Section {
                Picker("Session Type", selection: $settings.sessionType) {
                    ForEach(SessionType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .onChange(of: settings.sessionType) { _, _ in
                    // Session type change will automatically update intervals
                }
            } header: {
                Text("Session Type")
            } footer: {
                Text(sessionTypeDescription)
            }
            
            Section {
                Button("Reset to Defaults") {
                    settings.resetToDefaults()
                }
                .foregroundColor(.red)
            }
        }
        .formStyle(.grouped)
        .padding()
    }
    
    private var sessionTypeDescription: String {
        switch settings.sessionType {
        case .standard:
            return "20-20-20 rule: Every 20 minutes, look 20 feet away for 20 seconds"
        case .pomodoro:
            return "Pomodoro technique: 25 minutes of work, 5 minutes break"
        case .custom:
            return "Customize your own work and break intervals"
        }
    }
}

// MARK: - Break Settings

struct BreakSettingsView: View {
    @EnvironmentObject var settings: AppSettings
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Work Interval: \(settings.workIntervalMinutes) minutes")
                        .font(.headline)
                    
                    Slider(
                        value: Binding(
                            get: { Double(settings.workIntervalMinutes) },
                            set: { settings.workIntervalMinutes = Int($0) }
                        ),
                        in: 10...60,
                        step: 5
                    )
                    
                    Text("How long to work before taking a break")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Break Duration: \(settings.breakDurationSeconds) seconds")
                        .font(.headline)
                    
                    Slider(
                        value: Binding(
                            get: { Double(settings.breakDurationSeconds) },
                            set: { settings.breakDurationSeconds = Int($0) }
                        ),
                        in: 10...60,
                        step: 5
                    )
                    
                    Text("How long each break should last")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Pre-Break Warning: \(settings.preBreakWarningSeconds) seconds")
                        .font(.headline)
                    
                    Slider(
                        value: Binding(
                            get: { Double(settings.preBreakWarningSeconds) },
                            set: { settings.preBreakWarningSeconds = Int($0) }
                        ),
                        in: 10...60,
                        step: 10
                    )
                    
                    Text("Advance notice before break starts")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            } header: {
                Text("Timing")
            }
            
            Section {
                Picker("Break Style", selection: $settings.breakStyle) {
                    ForEach(BreakStyle.allCases) { style in
                        Label(style.rawValue, systemImage: style.icon)
                            .tag(style)
                    }
                }
                .pickerStyle(.inline)
                
                Text(settings.breakStyle.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                // Preview button for testing break styles
                Button(action: previewBreakStyle) {
                    Label("Preview Break Style", systemImage: "eye.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .help("Test how your selected break style will look")
            } header: {
                Text("Break Style")
            }
            
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Exercise Interval: \(settings.exerciseIntervalSeconds) seconds")
                        .font(.headline)
                    
                    Slider(
                        value: Binding(
                            get: { Double(settings.exerciseIntervalSeconds) },
                            set: { settings.exerciseIntervalSeconds = Int($0) }
                        ),
                        in: 2...10,
                        step: 1
                    )
                }
                
                Text("How long to hold each eye position during exercise")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Eye Exercise Duration: \(settings.eyeExerciseDurationSeconds / 60) minutes")
                        .font(.headline)
                    
                    Slider(
                        value: Binding(
                            get: { Double(settings.eyeExerciseDurationSeconds) },
                            set: { settings.eyeExerciseDurationSeconds = Int($0) }
                        ),
                        in: 60...1800,
                        step: 60
                    )
                }
                
                Text("Duration for dedicated eye exercise breaks (1-30 minutes)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } header: {
                Text("Eye Exercise Settings")
            }
            
            Section {
                VStack(alignment: .leading, spacing: 16) {
                    // Enhanced toggle with icon
                    HStack {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.orange.opacity(0.3), Color.yellow.opacity(0.2)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 36, height: 36)
                            
                            Image(systemName: "sparkles")
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.orange, .yellow],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Enable Ambient Reminders")
                                .font(.headline)
                            Text("Cute periodic reminders while you work")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: Binding(
                            get: { settings.ambientRemindersEnabled },
                            set: { newValue in
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    settings.ambientRemindersEnabled = newValue
                                }
                                if newValue {
                                    AmbientReminderManager.shared.startAmbientReminders()
                                } else {
                                    AmbientReminderManager.shared.stopAmbientReminders()
                                }
                            }
                        ))
                        .toggleStyle(.switch)
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(settings.ambientRemindersEnabled ? Color.orange.opacity(0.08) : Color.secondary.opacity(0.05))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        settings.ambientRemindersEnabled ? 
                                            LinearGradient(
                                                colors: [Color.orange.opacity(0.3), Color.yellow.opacity(0.2)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ) : 
                                            LinearGradient(colors: [Color.clear], startPoint: .top, endPoint: .bottom),
                                        lineWidth: 1
                                    )
                            )
                    )
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: settings.ambientRemindersEnabled)
                }
                
                if settings.ambientRemindersEnabled {
                    VStack(alignment: .leading, spacing: 16) {
                        // Enhanced interval slider
                        EnhancedSliderCard(
                            title: "Reminder Interval",
                            value: settings.ambientReminderIntervalMinutes,
                            unit: "min",
                            icon: "clock.fill",
                            color: .blue,
                            range: 1...15
                        ) { newValue in
                            settings.ambientReminderIntervalMinutes = Int(newValue)
                        }
                        
                        // Enhanced duration slider
                        EnhancedSliderCard(
                            title: "Display Duration",
                            value: settings.ambientReminderDurationSeconds,
                            unit: "sec",
                            icon: "timer",
                            color: .green,
                            range: 3...15
                        ) { newValue in
                            settings.ambientReminderDurationSeconds = Int(newValue)
                        }
                        
                        // Enhanced test button
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                AmbientReminderManager.shared.showAmbientReminder()
                            }
                        }) {
                            HStack {
                                Image(systemName: "sparkles")
                                    .symbolEffect(.pulse)
                                Text("Show Reminder Now")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                LinearGradient(
                                    colors: [.blue, .blue.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .buttonStyle(.plain)
                        
                        HStack {
                            Image(systemName: "keyboard")
                                .foregroundColor(.secondary)
                            Text("Press ⌘⇧R to test anytime")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 4)
                        
                        Divider()
                        
                        // Professional custom reminder section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "wand.and.stars")
                                    .foregroundColor(.purple)
                                Text("Customize Your Reminder")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            
                            Toggle("Use Custom Reminder", isOn: $settings.useCustomReminder)
                                .toggleStyle(.switch)
                                .padding(.horizontal, 4)
                            
                            if settings.useCustomReminder {
                                VStack(alignment: .leading, spacing: 16) {
                                    // Professional SF Symbol picker
                                    VStack(alignment: .leading, spacing: 12) {
                                        Label("Choose Icon", systemImage: "star.circle")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.secondary)
                                        
                                        // Icon grid selector
                                        CustomIconPickerView(selectedIcon: $settings.customReminderEmoji)
                                    }
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.purple.opacity(0.06))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.purple.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                                    
                                    // Custom message input - refined
                                    VStack(alignment: .leading, spacing: 12) {
                                        Label("Reminder Message", systemImage: "text.bubble")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.secondary)
                                        
                                        TextField("e.g., \"Take a deep breath\" or \"Look away\"", text: $settings.customReminderMessage)
                                            .textFieldStyle(.roundedBorder)
                                            .font(.system(size: 14))
                                        
                                        // Preview
                                        if !settings.customReminderMessage.isEmpty {
                                            HStack(spacing: 12) {
                                                ZStack {
                                                    Circle()
                                                        .fill(Color.purple.opacity(0.15))
                                                        .frame(width: 40, height: 40)
                                                    
                                                    Image(systemName: settings.customReminderEmoji.isEmpty ? "eye" : settings.customReminderEmoji)
                                                        .font(.system(size: 20))
                                                        .foregroundColor(.purple)
                                                }
                                                
                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text(settings.customReminderMessage)
                                                        .font(.system(size: 13, weight: .semibold))
                                                        .foregroundColor(.primary)
                                                    Text("Preview")
                                                        .font(.caption2)
                                                        .foregroundColor(.secondary)
                                                }
                                                
                                                Spacer()
                                            }
                                            .padding(12)
                                            .background(Color.purple.opacity(0.08))
                                            .cornerRadius(10)
                                        }
                                    }
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.purple.opacity(0.06))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.purple.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                                    
                                    // Helpful examples
                                    HStack(spacing: 8) {
                                        Image(systemName: "lightbulb.fill")
                                            .foregroundColor(.orange)
                                            .font(.caption)
                                        Text("Suggestions: \"Stretch your neck\" • \"Blink slowly\" • \"Hydrate yourself\"")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.horizontal, 8)
                                }
                            }
                        }
                    }
                }
                
                Text(settings.ambientRemindersEnabled 
                    ? "Cute animated reminders will pop up on your screen while you work (blink, look left/right, etc.)"
                    : "Enable to show quick eye exercise reminders while working - separate from scheduled breaks")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } header: {
                Text("🎯 Ambient Reminders (While Working)")
            } footer: {
                Text("These fun emoji reminders appear randomly while you work, without interrupting. They're different from scheduled break overlays.")
                    .font(.caption)
            }
            
            // Water Reminder Section
            Section {
                VStack(alignment: .leading, spacing: 16) {
                    // Water reminder toggle card
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.blue.opacity(0.2), Color.cyan.opacity(0.15)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 36, height: 36)
                            
                            Image(systemName: "drop.fill")
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.blue, .cyan],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Enable Water Reminders")
                                .font(.headline)
                            Text("Stay hydrated with gentle reminders")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: Binding(
                            get: { settings.waterReminderEnabled },
                            set: { newValue in
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    settings.waterReminderEnabled = newValue
                                }
                                if newValue {
                                    WaterReminderManager.shared.startWaterReminders()
                                } else {
                                    WaterReminderManager.shared.stopWaterReminders()
                                }
                            }
                        ))
                        .toggleStyle(.switch)
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(settings.waterReminderEnabled ? Color.blue.opacity(0.08) : Color.secondary.opacity(0.05))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        settings.waterReminderEnabled ? 
                                            LinearGradient(
                                                colors: [Color.blue.opacity(0.3), Color.cyan.opacity(0.2)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ) : 
                                            LinearGradient(colors: [Color.clear], startPoint: .top, endPoint: .bottom),
                                        lineWidth: 1
                                    )
                            )
                    )
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: settings.waterReminderEnabled)
                }
                
                if settings.waterReminderEnabled {
                    VStack(alignment: .leading, spacing: 16) {
                        // Reminder interval picker
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(.blue)
                                Text("Reminder Interval")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            
                            Picker("Interval", selection: $settings.waterReminderInterval) {
                                Text("30 minutes").tag(TimeInterval(1800))
                                Text("45 minutes").tag(TimeInterval(2700))
                                Text("1 hour").tag(TimeInterval(3600))
                                Text("1.5 hours").tag(TimeInterval(5400))
                                Text("2 hours").tag(TimeInterval(7200))
                            }
                            .pickerStyle(.segmented)
                            .onChange(of: settings.waterReminderInterval) { _, _ in
                                // Restart reminders with new interval
                                if settings.waterReminderEnabled {
                                    WaterReminderManager.shared.stopWaterReminders()
                                    WaterReminderManager.shared.startWaterReminders()
                                }
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue.opacity(0.06))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                                )
                        )
                        
                        // Reminder style picker
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "bell.badge.fill")
                                    .foregroundColor(.cyan)
                                Text("Reminder Style")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            
                            Picker("Style", selection: $settings.waterReminderStyle) {
                                ForEach(WaterReminderStyle.allCases) { style in
                                    Text(style.rawValue).tag(style)
                                }
                            }
                            .pickerStyle(.segmented)
                            
                            Text(settings.waterReminderStyle.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.top, 4)
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.cyan.opacity(0.06))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.cyan.opacity(0.2), lineWidth: 1)
                                )
                        )
                        
                        // Test button
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                WaterReminderManager.shared.showWaterReminderNow()
                            }
                        }) {
                            HStack {
                                Image(systemName: "drop.fill")
                                    .symbolEffect(.pulse)
                                Text("Show Water Reminder Now")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                LinearGradient(
                                    colors: [.blue, .cyan],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .buttonStyle(.plain)
                        
                        HStack {
                            Image(systemName: "keyboard")
                                .foregroundColor(.secondary)
                            Text("Press ⌘⇧W to test anytime")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 4)
                        
                        Divider()
                        
                        // Custom water reminder section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "wand.and.stars")
                                    .foregroundColor(.blue)
                                Text("Customize Your Water Reminder")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            
                            Toggle("Use Custom Reminder", isOn: $settings.useCustomWaterReminder)
                                .toggleStyle(.switch)
                                .padding(.horizontal, 4)
                            
                            if settings.useCustomWaterReminder {
                                VStack(alignment: .leading, spacing: 16) {
                                    // SF Symbol picker for water reminder
                                    VStack(alignment: .leading, spacing: 12) {
                                        Label("Choose Icon", systemImage: "star.circle")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.secondary)
                                        
                                        // Icon grid selector - water-related icons
                                        CustomWaterIconPickerView(selectedIcon: $settings.customWaterReminderIcon)
                                    }
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.blue.opacity(0.06))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                                    
                                    // Custom message input
                                    VStack(alignment: .leading, spacing: 12) {
                                        Label("Reminder Message", systemImage: "text.bubble")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.secondary)
                                        
                                        TextField("e.g., \"Time to hydrate\" or \"Drink water\"", text: $settings.customWaterReminderMessage)
                                            .textFieldStyle(.roundedBorder)
                                            .font(.system(size: 14))
                                        
                                        // Preview
                                        if !settings.customWaterReminderMessage.isEmpty {
                                            HStack(spacing: 12) {
                                                ZStack {
                                                    Circle()
                                                        .fill(Color.blue.opacity(0.15))
                                                        .frame(width: 40, height: 40)
                                                    
                                                    Image(systemName: settings.customWaterReminderIcon.isEmpty ? "drop.fill" : settings.customWaterReminderIcon)
                                                        .font(.system(size: 18))
                                                        .foregroundColor(.blue)
                                                        .symbolRenderingMode(.hierarchical)
                                                }
                                                
                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text(settings.customWaterReminderMessage)
                                                        .font(.system(size: 13, weight: .semibold))
                                                        .foregroundColor(.primary)
                                                    Text("Preview")
                                                        .font(.caption2)
                                                        .foregroundColor(.secondary)
                                                }
                                                
                                                Spacer()
                                            }
                                            .padding(12)
                                            .background(Color.blue.opacity(0.08))
                                            .cornerRadius(10)
                                        }
                                    }
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.blue.opacity(0.06))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                                    
                                    // Helpful examples
                                    HStack(spacing: 8) {
                                        Image(systemName: "lightbulb.fill")
                                            .foregroundColor(.orange)
                                            .font(.caption)
                                        Text("Suggestions: \"Time to hydrate\" • \"Drink some water\" • \"Stay refreshed\"")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.horizontal, 8)
                                }
                            }
                        }
                    }
                }
                
                Text(settings.waterReminderEnabled 
                    ? "Gentle reminders will help you stay hydrated throughout your work sessions 💧"
                    : "Enable to receive periodic reminders to drink water and stay hydrated")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } header: {
                Text("💧 Water Reminders")
            } footer: {
                Text("Staying hydrated is essential for focus and health. These gentle reminders help you remember to drink water regularly.")
                    .font(.caption)
            }
            
            // Color Theme Settings Section
            Section {
                VStack(spacing: 20) {
                    // Ambient Reminder Theme
                    ThemeSettingsCard(
                        title: "Ambient Reminder Theme",
                        icon: "sparkles",
                        selectedThemeType: Binding(
                            get: { settings.ambientReminderThemeType },
                            set: { settings.ambientReminderThemeType = $0 }
                        ),
                        customTheme: Binding(
                            get: { settings.ambientReminderTheme },
                            set: { settings.ambientReminderTheme = $0 }
                        ),
                        onThemeChange: {
                            settings.objectWillChange.send()
                        }
                    )
                    
                    Divider()
                    
                    // Break Overlay Theme
                    ThemeSettingsCard(
                        title: "Break Overlay Theme",
                        icon: "moon.stars.fill",
                        selectedThemeType: Binding(
                            get: { settings.breakOverlayThemeType },
                            set: { settings.breakOverlayThemeType = $0 }
                        ),
                        customTheme: Binding(
                            get: { settings.breakOverlayTheme },
                            set: { settings.breakOverlayTheme = $0 }
                        ),
                        onThemeChange: {
                            settings.objectWillChange.send()
                        }
                    )
                    
                    Divider()
                    
                    // Water Reminder Theme
                    ThemeSettingsCard(
                        title: "Water Reminder Theme",
                        icon: "drop.fill",
                        selectedThemeType: Binding(
                            get: { settings.waterReminderThemeType },
                            set: { settings.waterReminderThemeType = $0 }
                        ),
                        customTheme: Binding(
                            get: { settings.waterReminderTheme },
                            set: { settings.waterReminderTheme = $0 }
                        ),
                        onThemeChange: {
                            settings.objectWillChange.send()
                        }
                    )
                    
                    // Quick presets for custom themes
                    if settings.ambientReminderThemeType == .custom || 
                       settings.breakOverlayThemeType == .custom || 
                       settings.waterReminderThemeType == .custom {
                        QuickPresetsView(
                            customTheme: Binding(
                                get: {
                                    // Use whichever is custom, prioritize in order
                                    if settings.ambientReminderThemeType == .custom {
                                        return settings.ambientReminderTheme
                                    } else if settings.breakOverlayThemeType == .custom {
                                        return settings.breakOverlayTheme
                                    } else {
                                        return settings.waterReminderTheme
                                    }
                                },
                                set: { newTheme in
                                    // Apply to whichever is custom
                                    if settings.ambientReminderThemeType == .custom {
                                        settings.ambientReminderTheme = newTheme
                                    }
                                    if settings.breakOverlayThemeType == .custom {
                                        settings.breakOverlayTheme = newTheme
                                    }
                                    if settings.waterReminderThemeType == .custom {
                                        settings.waterReminderTheme = newTheme
                                    }
                                }
                            ),
                            onThemeChange: {
                                settings.objectWillChange.send()
                            }
                        )
                    }
                }
            } header: {
                Text("🎨 Color Themes")
            } footer: {
                Text("Customize the appearance of ambient reminders, break overlays, and water reminders. Choose from preset themes or create your own custom color scheme.")
                    .font(.caption)
            }
            
            Section {
                Stepper(
                    "Daily Break Goal: \(settings.dailyBreakGoal)",
                    value: $settings.dailyBreakGoal,
                    in: 1...100
                )
                
                Text("Set a target for breaks to take each day")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } header: {
                Text("Goals")
            }
        }
        .formStyle(.grouped)
        .padding()
    }
    
    // MARK: - Preview Function
    
    private func previewBreakStyle() {
        switch settings.breakStyle {
        case .blurScreen:
            // Show 5-second preview of blur with proper cleanup
            ScreenBlurManager.shared.showBreakOverlay(
                duration: 5,
                style: .blur
            ) {
                // When user clicks skip, hide the overlay
                ScreenBlurManager.shared.hideOverlay()
            }
            
            // Auto-hide after 5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                ScreenBlurManager.shared.hideOverlay()
            }
            
        case .notificationOnly:
            // Show 5-second preview of floating window
            let window = FloatingBreakWindow()
            window.show(
                duration: 5,
                onSkip: { 
                    window.hide()
                },
                onComplete: { 
                    window.hide()
                }
            )
            
        case .eyeExercise:
            // Show 5-second preview of exercise with proper cleanup
            ScreenBlurManager.shared.showBreakOverlay(
                duration: 5,
                style: .exercise
            ) {
                // When user clicks skip, hide the overlay
                ScreenBlurManager.shared.hideOverlay()
            }
            
            // Auto-hide after 5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                ScreenBlurManager.shared.hideOverlay()
            }
        }
    }
}

// MARK: - About View

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // App Icon
                Image(systemName: "eye.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.blue)
                    .padding(.top, 40)
                
                VStack(spacing: 8) {
                    Text("EyeBreak")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Version 1.0.0")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Description
                VStack(alignment: .leading, spacing: 12) {
                    Text("About EyeBreak")
                        .font(.headline)
                    
                    Text("""
                    EyeBreak helps you reduce digital eye strain by following the 20-20-20 rule: \
                    Every 20 minutes, look at something 20 feet away for 20 seconds.
                    
                    Built with privacy in mind, all your data stays on your Mac. \
                    No analytics, no tracking, no internet connection required.
                    """)
                    .font(.body)
                    .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(12)
                
                // Features
                VStack(alignment: .leading, spacing: 16) {
                    Text("Key Features")
                        .font(.headline)
                    
                    FeatureRow(icon: "eye.fill", title: "20-20-20 Rule", description: "Scientifically-backed eye care")
                    FeatureRow(icon: "timer", title: "Smart Timer", description: "Automatic break reminders")
                    FeatureRow(icon: "bell.fill", title: "Notifications", description: "Gentle pre-break warnings")
                    FeatureRow(icon: "chart.bar.fill", title: "Statistics", description: "Track your progress")
                    FeatureRow(icon: "lock.fill", title: "Privacy First", description: "All data stays local")
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(12)
                
                // Links
                VStack(spacing: 12) {
                    Link(destination: URL(string: "https://github.com/cheat2001/eyebreak")!) {
                        Label("GitHub Repository", systemImage: "link")
                    }
                    
                    Link(destination: URL(string: "https://github.com")!) {
                        Label("Report an Issue", systemImage: "exclamationmark.triangle")
                    }
                }
                
                // Copyright
                Text("© 2025 EyeBreak. All rights reserved.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 40)
            }
            .padding(.horizontal, 40)
            .frame(maxWidth: 600)
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - Timer Status Banner

struct TimerStatusBanner: View {
    @EnvironmentObject var timerManager: BreakTimerManager
    @EnvironmentObject var settings: AppSettings
    @State private var pulseAnimation = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 24) {
                // Enhanced status indicator with animation
                ZStack {
                    // Outer pulse
                    Circle()
                        .fill(statusColor.opacity(0.2))
                        .frame(width: 40, height: 40)
                        .scaleEffect(pulseAnimation && timerManager.state.isActive ? 1.3 : 1.0)
                        .animation(
                            timerManager.state.isActive ?
                            .easeInOut(duration: 1.5).repeatForever(autoreverses: true) : .default,
                            value: pulseAnimation
                        )
                    
                    // Middle ring
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [statusColor, statusColor.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                        .frame(width: 24, height: 24)
                    
                    // Core indicator
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [statusColor, statusColor.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 12, height: 12)
                        .shadow(color: statusColor.opacity(0.5), radius: 4)
                }
                .onAppear { pulseAnimation = true }
                
                // Enhanced timer display
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(statusText)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(statusColor)
                        
                        if case .working(let seconds) = timerManager.state {
                            Text("\(formatTime(seconds)) remaining")
                                .font(.system(.subheadline, design: .monospaced))
                                .foregroundColor(.secondary)
                                .contentTransition(.numericText())
                        } else if case .breaking(let seconds) = timerManager.state {
                            Text("\(seconds) seconds")
                                .font(.system(.subheadline, design: .monospaced))
                                .foregroundColor(.secondary)
                                .contentTransition(.numericText())
                        } else if case .preBreak(let seconds) = timerManager.state {
                            Text("Break in \(seconds)s")
                                .font(.system(.subheadline, design: .monospaced))
                                .foregroundColor(.orange)
                                .contentTransition(.numericText())
                        } else {
                            Text("Start your healthy eye habit")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Visual icon based on state
                    if timerManager.state.isActive {
                        Image(systemName: statusIcon)
                            .font(.title2)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [statusColor, statusColor.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .symbolEffect(.pulse.byLayer, options: .repeating)
                    }
                }
                
                Spacer()
                
                // Enhanced control buttons
                controlButtons
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            
            // Enhanced progress bar
            if case .working(let remaining) = timerManager.state {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(height: 4)
                    
                    GeometryReader { geometry in
                        let progress = 1.0 - (Double(remaining) / Double(settings.workIntervalSeconds))
                        
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.blue, Color.cyan],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * progress, height: 4)
                            .shadow(color: Color.blue.opacity(0.3), radius: 2)
                            .animation(.linear(duration: 1), value: progress)
                    }
                    .frame(height: 4)
                }
                .transition(.opacity)
                
            } else if case .breaking(let remaining) = timerManager.state {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.green.opacity(0.1))
                        .frame(height: 4)
                    
                    GeometryReader { geometry in
                        let progress = 1.0 - (Double(remaining) / Double(settings.breakDurationSeconds))
                        
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.green, Color.mint],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * progress, height: 4)
                            .shadow(color: Color.green.opacity(0.3), radius: 2)
                            .animation(.linear(duration: 1), value: progress)
                    }
                    .frame(height: 4)
                }
                .transition(.opacity)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 0)
                .fill(Color(NSColor.controlBackgroundColor))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
    
    private var statusIcon: String {
        switch timerManager.state {
        case .working: return "desktopcomputer"
        case .breaking: return "eye.slash.fill"
        case .preBreak: return "bell.fill"
        default: return "timer"
        }
    }
    
    private var statusColor: Color {
        switch timerManager.state {
        case .idle:
            return .gray
        case .working:
            return .blue
        case .preBreak:
            return .orange
        case .breaking:
            return .green
        case .paused:
            return .yellow
        }
    }
    
    private var timerDisplay: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(statusText)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(timeText)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .monospacedDigit()
        }
    }
    
    private var statusText: String {
        switch timerManager.state {
        case .idle:
            return "Idle"
        case .working:
            return "Next break in:"
        case .preBreak:
            return "Break starting soon:"
        case .breaking:
            return "Break time remaining:"
        case .paused:
            return "Paused"
        }
    }
    
    private var timeText: String {
        switch timerManager.state {
        case .idle:
            return "--:--"
        case .working(let remainingSeconds), .preBreak(let remainingSeconds), .breaking(let remainingSeconds):
            let minutes = remainingSeconds / 60
            let seconds = remainingSeconds % 60
            return String(format: "%02d:%02d", minutes, seconds)
        case .paused:
            return "--:--"
        }
    }
    
    private var controlButtons: some View {
        HStack(spacing: 12) {
            switch timerManager.state {
            case .idle:
                Button {
                    timerManager.start()
                } label: {
                    Label("Start", systemImage: "play.fill")
                }
                .buttonStyle(.borderedProminent)
                .keyboardShortcut("s", modifiers: [.command, .shift])
                
            case .working, .preBreak:
                Button {
                    timerManager.takeBreakNow()
                } label: {
                    Label("Break Now", systemImage: "pause.fill")
                }
                .buttonStyle(.bordered)
                .keyboardShortcut("b", modifiers: [.command, .shift])
                
                Button {
                    timerManager.stop()
                } label: {
                    Label("Stop", systemImage: "stop.fill")
                }
                .buttonStyle(.bordered)
                .keyboardShortcut("x", modifiers: [.command, .shift])
                
            case .breaking:
                Button {
                    timerManager.skipBreak()
                } label: {
                    Label("Skip Break", systemImage: "forward.fill")
                }
                .buttonStyle(.bordered)
                
            case .paused:
                Button {
                    timerManager.resume()
                } label: {
                    Label("Resume", systemImage: "play.fill")
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
    
    private func formatTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - Enhanced Slider Card Component

struct EnhancedSliderCard: View {
    let title: String
    let value: Int
    let unit: String
    let icon: String
    let color: Color
    let range: ClosedRange<Double>
    let onChange: (Double) -> Void
    
    @State private var animateValue = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // Icon with gradient background
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [color.opacity(0.3), color.opacity(0.15)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [color, color.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .font(.system(size: 14))
                }
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                // Value display with animation
                HStack(spacing: 4) {
                    Text("\(value)")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [color, color.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .contentTransition(.numericText())
                    
                    Text(unit)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fontWeight(.medium)
                }
                .scaleEffect(animateValue ? 1.1 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: animateValue)
            }
            
            // Custom styled slider
            Slider(
                value: Binding(
                    get: { Double(value) },
                    set: { newValue in
                        onChange(newValue)
                        animateValue = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            animateValue = false
                        }
                    }
                ),
                in: range,
                step: 1
            )
            .tint(color)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            LinearGradient(
                                colors: [color.opacity(0.2), color.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
    }
}

// MARK: - Custom Icon Picker View

struct CustomIconPickerView: View {
    @Binding var selectedIcon: String
    
    // Curated professional SF Symbols for eye care reminders
    let iconOptions: [(name: String, symbol: String)] = [
        ("Eye", "eye"),
        ("Eye Fill", "eye.fill"),
        ("Sparkle", "sparkles"),
        ("Star", "star.fill"),
        ("Heart", "heart.fill"),
        ("Drop", "drop.fill"),
        ("Leaf", "leaf.fill"),
        ("Moon", "moon.stars.fill"),
        ("Sun", "sun.max.fill"),
        ("Clock", "clock.fill"),
        ("Bell", "bell.fill"),
        ("Hand Raised", "hand.raised.fill"),
        ("Figure Walk", "figure.walk"),
        ("Lungs", "lungs.fill"),
        ("Headphones", "headphones"),
        ("Cup", "cup.and.saucer.fill")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 60, maximum: 70), spacing: 12)
            ], spacing: 12) {
                ForEach(iconOptions, id: \.symbol) { option in
                    IconOptionButton(
                        symbol: option.symbol,
                        isSelected: selectedIcon == option.symbol,
                        onSelect: {
                            selectedIcon = option.symbol
                        }
                    )
                }
            }
            
            if selectedIcon.isEmpty {
                Text("Select an icon for your custom reminder")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
            }
        }
    }
}

// MARK: - Icon Option Button

struct IconOptionButton: View {
    let symbol: String
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? 
                          LinearGradient(colors: [.purple, .purple.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing) :
                          LinearGradient(colors: [Color(NSColor.controlBackgroundColor)], startPoint: .top, endPoint: .bottom))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.purple : Color.gray.opacity(0.3), lineWidth: isSelected ? 2 : 1)
                    )
                    .shadow(color: isSelected ? Color.purple.opacity(0.3) : Color.clear, radius: 8, x: 0, y: 2)
                
                Image(systemName: symbol)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? .white : .secondary)
            }
            .frame(height: 60)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Custom Water Icon Picker View

struct CustomWaterIconPickerView: View {
    @Binding var selectedIcon: String
    
    // Curated water-related SF Symbols
    let iconOptions: [(name: String, symbol: String)] = [
        ("Drop", "drop.fill"),
        ("Water Bottle", "waterbottle.fill"),
        ("Drop Circle", "drop.circle.fill"),
        ("Drop Triangle", "drop.triangle.fill"),
        ("Cup", "cup.and.saucer.fill"),
        ("Mug", "mug.fill"),
        ("Figure Water", "figure.water.fitness"),
        ("Sparkles", "sparkles"),
        ("Leaf", "leaf.fill"),
        ("Heart", "heart.fill"),
        ("Hands", "hands.and.sparkles.fill"),
        ("Sun", "sun.max.fill"),
        ("Moon", "moon.stars.fill"),
        ("Clock", "clock.fill"),
        ("Bell", "bell.fill"),
        ("Hand Raised", "hand.raised.fill")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 60, maximum: 70), spacing: 12)
            ], spacing: 12) {
                ForEach(iconOptions, id: \.symbol) { option in
                    WaterIconOptionButton(
                        symbol: option.symbol,
                        isSelected: selectedIcon == option.symbol,
                        onSelect: {
                            selectedIcon = option.symbol
                        }
                    )
                }
            }
            
            if selectedIcon.isEmpty {
                Text("Select an icon for your water reminder")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
            }
        }
    }
}

// MARK: - Water Icon Option Button

struct WaterIconOptionButton: View {
    let symbol: String
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? 
                          LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing) :
                          LinearGradient(colors: [Color(NSColor.controlBackgroundColor)], startPoint: .top, endPoint: .bottom))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: isSelected ? 2 : 1)
                    )
                    .shadow(color: isSelected ? Color.blue.opacity(0.3) : Color.clear, radius: 8, x: 0, y: 2)
                
                Image(systemName: symbol)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? .white : .secondary)
                    .symbolRenderingMode(.hierarchical)
            }
            .frame(height: 60)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}
