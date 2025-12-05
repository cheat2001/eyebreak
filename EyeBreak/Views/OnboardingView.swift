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
    @State private var animateIcon = false
    @State private var animateGlow = false
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            ZStack {
                // Animated glow rings
                ForEach(0..<3) { index in
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.blue.opacity(0.3), .cyan.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                        .frame(width: CGFloat(120 + index * 40), height: CGFloat(120 + index * 40))
                        .scaleEffect(animateGlow ? 1.2 : 1.0)
                        .opacity(0.5 - Double(index) * 0.15)
                        .animation(
                            .easeInOut(duration: 2.0 + Double(index) * 0.5)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.3),
                            value: animateGlow
                        )
                }
                
                // Main icon with gradient
                Image(systemName: "eye.fill")
                    .font(.system(size: 100))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .cyan, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .blue.opacity(0.3), radius: 20)
                    .scaleEffect(animateIcon ? 1.0 : 0.8)
                    .rotationEffect(.degrees(animateIcon ? 0 : -10))
            }
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                    animateIcon = true
                }
                animateGlow = true
            }
            
            VStack(spacing: 12) {
                Text("Welcome to EyeBreak")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.primary, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .foregroundColor(.yellow)
                    Text("Your eyes deserve a break")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    Image(systemName: "sparkles")
                        .foregroundColor(.yellow)
                }
            }
            
            Text("""
            Spending hours in front of a screen can cause eye strain, headaches, \
            and fatigue. EyeBreak helps you take regular breaks to keep your eyes healthy.
            """)
            .font(.body)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .frame(maxWidth: 400)
            .padding(.horizontal)
            
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
    
    @State private var animate = false
    
    var body: some View {
        HStack(spacing: 20) {
            // Enhanced icon with gradient background
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [color.opacity(0.2), color.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 64, height: 64)
                    .shadow(color: color.opacity(0.2), radius: 8)
                
                Image(systemName: icon)
                    .font(.title)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [color, color.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .scaleEffect(animate ? 1.0 : 0.8)
            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.2), value: animate)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text(number)
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [color, color.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text(unit)
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .fontWeight(.medium)
                }
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(color.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [color.opacity(0.3), color.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
        )
        .shadow(color: color.opacity(0.1), radius: 8, x: 0, y: 4)
        .onAppear {
            animate = true
        }
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

    @State private var animate = false

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            // Enhanced icon with gradient background
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.2), Color.cyan.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                    .shadow(color: .blue.opacity(0.15), radius: 6)

                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .cyan],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .scaleEffect(animate ? 1.0 : 0.8)
            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.1), value: animate)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)

                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .onAppear {
            animate = true
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

    @State private var animate = false
    @State private var isHovered = false

    private var cardColor: Color {
        granted ? .green : (required ? .orange : .blue)
    }

    var body: some View {
        HStack(spacing: 20) {
            // Enhanced icon with gradient background
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [cardColor.opacity(0.2), cardColor.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 56, height: 56)
                    .shadow(color: cardColor.opacity(0.2), radius: 8)

                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [cardColor, cardColor.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .scaleEffect(animate ? 1.0 : 0.8)
            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.1), value: animate)

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)

                    if required && !granted {
                        Text("Required")
                            .font(.system(size: 11, weight: .semibold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(
                                Capsule()
                                    .fill(Color.red.opacity(0.15))
                            )
                            .foregroundColor(.red)
                    }
                }

                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }

            Spacer()

            if granted {
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.15))
                        .frame(width: 40, height: 40)

                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.green, .mint],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .transition(.scale.combined(with: .opacity))
            } else {
                Button(action: action) {
                    Text("Grant")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            LinearGradient(
                                colors: [cardColor, cardColor.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(Capsule())
                        .shadow(color: cardColor.opacity(0.3), radius: 6, x: 0, y: 3)
                }
                .buttonStyle(.plain)
                .scaleEffect(isHovered ? 1.05 : 1.0)
                .animation(.easeOut(duration: 0.15), value: isHovered)
                .onHover { isHovered = $0 }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(cardColor.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [cardColor.opacity(0.3), cardColor.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
        )
        .shadow(color: cardColor.opacity(0.1), radius: 8, x: 0, y: 4)
        .onAppear {
            animate = true
        }
    }
}
