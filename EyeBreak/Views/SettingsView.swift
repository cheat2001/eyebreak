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
            } header: {
                Text("Break Style")
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
                    Link(destination: URL(string: "https://github.com")!) {
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
