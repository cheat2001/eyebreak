//
//  WaterReminderManager.swift
//  EyeBreak
//
//  Created on October 18, 2025.
//

import SwiftUI
import AppKit
import UserNotifications

/// Manages water drinking reminders to encourage hydration during work
class WaterReminderManager: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = WaterReminderManager()
    
    // MARK: - Properties
    
    private var reminderTimer: Timer?
    @Published var isEnabled: Bool = false
    
    // Preset water message templates (theme will be added at runtime)
    private let waterMessages: [(icon: String, title: String, message: String)] = [
        ("drop.fill", "Time for Water!", "Stay hydrated! Take a sip of water."),
        ("waterbottle.fill", "Hydration Check", "Don't forget to drink some water!"),
        ("drop.circle.fill", "Water Break", "Your body needs water. Take a quick sip!"),
        ("figure.water.fitness", "Stay Hydrated", "Grab a glass of water and refresh yourself."),
        ("drop.triangle.fill", "Quick Reminder", "Have you had water recently? Time to hydrate!"),
        ("cup.and.saucer.fill", "Drink Up!", "Keep your energy up with some water."),
        ("sparkles", "Hydration Time", "A sip of water helps you stay focused!"),
        ("leaf.fill", "Wellness Check", "Take a moment to drink some water.")
    ]    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Public Methods
    
    /// Start water reminders based on settings
    func startWaterReminders() {
        guard !isEnabled else { return }
        isEnabled = true
        
        print("💧 Starting water reminders")
        scheduleNextReminder()
    }
    
    /// Stop water reminders
    func stopWaterReminders() {
        print("🛑 Stopping water reminders")
        isEnabled = false
        reminderTimer?.invalidate()
        reminderTimer = nil
    }
    
    /// Show a water reminder immediately (manual trigger)
    func showWaterReminderNow() {
        print("💧 Showing water reminder on demand")
        showWaterReminder()
    }
    
    // MARK: - Private Methods
    
    private func scheduleNextReminder() {
        guard isEnabled else { return }
        
        let settings = AppSettings.shared
        let interval = settings.waterReminderInterval
        
        reminderTimer?.invalidate()
        reminderTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            self?.showWaterReminder()
            self?.scheduleNextReminder()
        }
        
        print("💧 Next water reminder scheduled in \(Int(interval / 60)) minutes")
    }
    
    private func showWaterReminder() {
        guard isEnabled else { return }
        
        let settings = AppSettings.shared
        
        // Generate a new random color theme for this reminder (if using random color theme)
        settings.regenerateWaterReminderRandomTheme()
        let theme = settings.waterReminderTheme
        
        // Check if using custom reminder
        let message: WaterMessage
        if settings.useCustomWaterReminder && !settings.customWaterReminderMessage.isEmpty {
            message = WaterMessage(
                icon: settings.customWaterReminderIcon.isEmpty ? "drop.fill" : settings.customWaterReminderIcon,
                title: "Water Reminder",
                message: settings.customWaterReminderMessage,
                theme: theme
            )
        } else {
            // Use random preset message with theme
            let preset = waterMessages.randomElement() ?? waterMessages[0]
            message = WaterMessage(
                icon: preset.icon,
                title: preset.title,
                message: preset.message,
                theme: theme
            )
        }
        
        print("💧 Showing water reminder: \(message.title)")
        
        switch settings.waterReminderStyle {
        case .notification:
            showNotificationReminder(message: message)
        case .ambient:
            showAmbientReminder(message: message)
        case .both:
            showNotificationReminder(message: message)
            showAmbientReminder(message: message)
        }
    }
    
    private func showNotificationReminder(message: WaterMessage) {
        let content = UNMutableNotificationContent()
        content.title = message.title
        content.body = message.message
        content.sound = AppSettings.shared.soundEnabled ? .default : nil
        
        let request = UNNotificationRequest(
            identifier: "waterReminder-\(Date().timeIntervalSince1970)",
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error sending water reminder notification: \(error)")
            }
        }
    }
    
    private func showAmbientReminder(message: WaterMessage) {
        // Play sound if enabled
        if AppSettings.shared.soundEnabled {
            NSSound(named: "Glass")?.play()
        }
        
        // Get the screen with mouse cursor (the active screen user is on)
        let mouseLocation = NSEvent.mouseLocation
        let activeScreen = NSScreen.screens.first(where: { NSMouseInRect(mouseLocation, $0.frame, false) }) ?? NSScreen.main ?? NSScreen.screens[0]
        let screenFrame = activeScreen.visibleFrame
        
        // Center horizontally, position at top
        let windowWidth: CGFloat = 420
        let windowHeight: CGFloat = 110
        let x = screenFrame.midX - (windowWidth / 2)
        let y = screenFrame.maxY - windowHeight - 60  // 60pt from top
        
        let windowRect = NSRect(x: x, y: y, width: windowWidth, height: windowHeight)
        
        // Create floating window
        let window = NSWindow(
            contentRect: windowRect,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        window.isOpaque = false
        window.backgroundColor = .clear
        window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.maximumWindow)))
        window.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle, .transient, .fullScreenAuxiliary]
        window.hasShadow = false
        window.isMovable = false
        
        // Create SwiftUI view
        let contentView = WaterReminderView(
            message: message,
            onDismiss: { [weak window] in
                window?.orderOut(nil)
            }
        )
        
        window.contentView = NSHostingView(rootView: contentView)
        window.setFrame(windowRect, display: true, animate: false)
        window.orderFrontRegardless()
        
        // Auto-dismiss after 8 seconds (same as ambient reminders)
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) { [weak window] in
            window?.orderOut(nil)
        }
    }
}

// MARK: - Water Message Model

struct WaterMessage {
    let icon: String  // SF Symbol name
    let title: String
    let message: String
    let theme: ColorTheme  // Theme for coloring
    
    var glassColor: Color {
        // Use background color from theme
        return theme.backgroundColor
    }
    
    var accentColor: Color {
        // Use accent color from theme
        return theme.accentColor
    }
}

// MARK: - Water Reminder View

struct WaterReminderView: View {
    let message: WaterMessage
    let onDismiss: () -> Void
    
    @State private var isVisible = false
    
    var body: some View {
        ZStack {
            // Glass morphism background with theme colors
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    message.glassColor.opacity(message.theme.backgroundOpacity)
                )
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [message.glassColor.opacity(0.6), message.accentColor.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
                .shadow(color: message.glassColor.opacity(0.3), radius: 20, x: 0, y: 10)
            
            HStack(spacing: 16) {
                // Water icon - using SF Symbol with theme colors
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [message.glassColor.opacity(0.25), message.accentColor.opacity(0.15)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: message.icon)
                        .font(.system(size: 24))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [message.glassColor, message.accentColor],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .symbolRenderingMode(.hierarchical)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(message.title)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(message.theme.textColor.opacity(message.theme.textOpacity))
                    
                    Text(message.message)
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundColor(message.theme.secondaryTextColor.opacity(message.theme.secondaryTextOpacity))
                        .lineLimit(2)
                }
                
                Spacer()
                
                // Dismiss button
                Button(action: onDismiss) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.secondary)
                        .opacity(0.6)
                }
                .buttonStyle(.plain)
                .help("Dismiss")
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .frame(width: 420, height: 110)
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : -20)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                isVisible = true
            }
        }
    }
}

// MARK: - Preview

#Preview {
    WaterReminderView(
        message: WaterMessage(
            icon: "drop.fill",
            title: "Time for Water!",
            message: "Stay hydrated! Take a sip of water.",
            theme: ColorTheme(
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
        ),
        onDismiss: {}
    )
    .frame(width: 500, height: 200)
    .background(Color.black.opacity(0.1))
}
