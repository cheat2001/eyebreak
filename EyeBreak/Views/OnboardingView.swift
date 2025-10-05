//
//  OnboardingView.swift
//  EyeBreak
//
//  Created on October 5, 2025.
//

import SwiftUI
import UserNotifications

struct OnboardingView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var settings: AppSettings
    @Environment(\.dismiss) var dismiss
    
    @State private var currentPage = 0
    private let totalPages = 4
    
    var body: some View {
        VStack(spacing: 0) {
            // Content
            TabView(selection: $currentPage) {
                WelcomePage()
                    .tag(0)
                
                RulePage()
                    .tag(1)
                
                FeaturesPage()
                    .tag(2)
                
                PermissionsPage()
                    .tag(3)
            }
            .tabViewStyle(.automatic)
            
            // Navigation
            HStack {
                if currentPage > 0 {
                    Button("Back") {
                        withAnimation {
                            currentPage -= 1
                        }
                    }
                    .keyboardShortcut(.cancelAction)
                }
                
                Spacer()
                
                // Page indicators
                HStack(spacing: 8) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.accentColor : Color.secondary.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                
                Spacer()
                
                if currentPage < totalPages - 1 {
                    Button("Continue") {
                        withAnimation {
                            currentPage += 1
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .keyboardShortcut(.defaultAction)
                } else {
                    Button("Get Started") {
                        completeOnboarding()
                    }
                    .buttonStyle(.borderedProminent)
                    .keyboardShortcut(.defaultAction)
                }
            }
            .padding()
        }
        .frame(width: 600, height: 500)
    }
    
    private func completeOnboarding() {
        settings.completeOnboarding()
        isPresented = false
        dismiss()
    }
}

// MARK: - Welcome Page

struct WelcomePage: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: "eye.fill")
                .font(.system(size: 100))
                .foregroundStyle(.blue)
            
            VStack(spacing: 12) {
                Text("Welcome to EyeBreak")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                
                Text("Your eyes deserve a break")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            
            Text("""
            Spending hours in front of a screen can cause eye strain, headaches, \
            and fatigue. EyeBreak helps you take regular breaks to keep your eyes healthy.
            """)
            .font(.body)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .frame(maxWidth: 400)
            
            Spacer()
        }
        .padding(40)
    }
}

// MARK: - Rule Page

struct RulePage: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Text("The 20-20-20 Rule")
                .font(.system(size: 36, weight: .bold, design: .rounded))
            
            VStack(spacing: 24) {
                RuleCard(
                    number: "20",
                    unit: "minutes",
                    description: "Work for 20 minutes",
                    icon: "desktopcomputer",
                    color: .blue
                )
                
                RuleCard(
                    number: "20",
                    unit: "feet",
                    description: "Look 20 feet away",
                    icon: "eye",
                    color: .green
                )
                
                RuleCard(
                    number: "20",
                    unit: "seconds",
                    description: "Rest for 20 seconds",
                    icon: "timer",
                    color: .orange
                )
            }
            
            Text("This simple technique reduces eye strain and keeps you productive.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 400)
            
            Spacer()
        }
        .padding(40)
    }
}

struct RuleCard: View {
    let number: String
    let unit: String
    let description: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title)
                .foregroundStyle(color)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(number)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(color)
                    
                    Text(unit)
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
        .frame(width: 350)
    }
}

// MARK: - Features Page

struct FeaturesPage: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Text("What EyeBreak Does")
                .font(.system(size: 36, weight: .bold, design: .rounded))
            
            VStack(alignment: .leading, spacing: 20) {
                FeatureItem(
                    icon: "bell.badge.fill",
                    title: "Gentle Reminders",
                    description: "Get a notification 30 seconds before each break"
                )
                
                FeatureItem(
                    icon: "eye.slash.fill",
                    title: "Screen Blur",
                    description: "Your screen blurs during breaks to encourage rest"
                )
                
                FeatureItem(
                    icon: "moon.zzz.fill",
                    title: "Smart Pausing",
                    description: "Automatically pauses when you're away from your Mac"
                )
                
                FeatureItem(
                    icon: "chart.bar.fill",
                    title: "Track Progress",
                    description: "See how many breaks you've taken each day"
                )
                
                FeatureItem(
                    icon: "lock.fill",
                    title: "Privacy First",
                    description: "All data stays on your Mac—no tracking or analytics"
                )
            }
            .frame(width: 400)
            
            Spacer()
        }
        .padding(40)
    }
}

struct FeatureItem: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - Permissions Page

struct PermissionsPage: View {
    @State private var notificationGranted = false
    @State private var screenRecordingGranted = false
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Text("Permissions Needed")
                .font(.system(size: 36, weight: .bold, design: .rounded))
            
            Text("EyeBreak needs a few permissions to work properly")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 16) {
                PermissionCard(
                    icon: "bell.badge.fill",
                    title: "Notifications",
                    description: "To remind you when it's time for a break",
                    required: true,
                    granted: notificationGranted
                ) {
                    requestNotifications()
                }
                
                PermissionCard(
                    icon: "eye.slash.fill",
                    title: "Screen Recording",
                    description: "To blur your screen during breaks",
                    required: false,
                    granted: screenRecordingGranted
                ) {
                    openScreenRecordingSettings()
                }
            }
            .frame(width: 450)
            
            Text("You can change these permissions anytime in System Settings.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(40)
    }
    
    private func requestNotifications() {
        NotificationManager.shared.requestAuthorization()
        // Give it a moment then check status
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            checkNotificationStatus()
        }
    }
    
    private func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                notificationGranted = settings.authorizationStatus == .authorized
            }
        }
    }
    
    private func openScreenRecordingSettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture") {
            NSWorkspace.shared.open(url)
        }
    }
}

struct PermissionCard: View {
    let icon: String
    let title: String
    let description: String
    let required: Bool
    let granted: Bool
    let action: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title)
                .foregroundStyle(.blue)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .font(.headline)
                    
                    if required {
                        Text("Required")
                            .font(.caption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.red.opacity(0.2))
                            .foregroundColor(.red)
                            .cornerRadius(4)
                    }
                }
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if granted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.title2)
            } else {
                Button("Grant") {
                    action()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
}
