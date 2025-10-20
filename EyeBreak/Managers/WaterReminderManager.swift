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
        case .blurScreen:
            showBlurScreenReminder(message: message)
        case .ambient:
            showAmbientReminder(message: message)
        }
    }
    
    private func showBlurScreenReminder(message: WaterMessage) {
        // Play sound if enabled
        if AppSettings.shared.soundEnabled {
            NSSound(named: "Glass")?.play()
        }
        
        // Create blur screen overlay on active screen only
        DispatchQueue.main.async {
            // Get the screen with mouse cursor (the active screen user is on)
            let mouseLocation = NSEvent.mouseLocation
            let activeScreen = NSScreen.screens.first(where: { NSMouseInRect(mouseLocation, $0.frame, false) }) ?? NSScreen.main ?? NSScreen.screens[0]
            let screenFrame = activeScreen.frame
            
            // Create overlay window for the active screen only
            let window = NSWindow(
                contentRect: screenFrame,
                styleMask: [.borderless, .fullSizeContentView],
                backing: .buffered,
                defer: false,
                screen: activeScreen
            )
            
            window.isOpaque = false
            window.backgroundColor = .clear
            window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.maximumWindow)))
            window.collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAuxiliary]
            
            // Create the content view with water reminder
            let contentView = WaterBlurOverlayView(
                message: message,
                onDismiss: { [weak window] in
                    window?.orderOut(nil)
                }
            )
            
            window.contentView = NSHostingView(rootView: contentView)
            window.makeKeyAndOrderFront(nil)
            
            // No auto-dismiss - user must click the button to acknowledge
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
            // Glass morphism background with theme colors - using backgroundGradient() for proper opacity
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(message.theme.backgroundGradient())
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.ultraThinMaterial)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(
                            message.theme.borderGradient(),
                            lineWidth: 1.5
                        )
                )
                .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 5)
                .shadow(color: message.theme.accentColor.opacity(0.25), radius: 20, x: 0, y: 8)
            
            HStack(spacing: 16) {
                // Water icon - using SF Symbol with theme colors
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    message.theme.backgroundColor.opacity(message.theme.backgroundOpacity * 0.4),
                                    message.theme.accentColor.opacity(message.theme.accentOpacity * 0.3)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: message.icon)
                        .font(.system(size: 24))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    message.theme.backgroundColor,
                                    message.theme.accentColor
                                ],
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

// MARK: - Water Blur Overlay View

/// Full screen blur overlay for water reminder (similar to break overlay)
struct WaterBlurOverlayView: View {
    let message: WaterMessage
    let onDismiss: () -> Void
    
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            // Blur background
            VisualEffectBlur()
                .ignoresSafeArea()
            
            // Gradient overlay with theme colors
            LinearGradient(
                colors: [
                    message.theme.backgroundColor.opacity(message.theme.backgroundOpacity * 0.6),
                    message.theme.backgroundColor.opacity(message.theme.backgroundOpacity * 0.4),
                    message.theme.accentColor.opacity(message.theme.accentOpacity * 0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 32) {
                // Water icon with animation
                ZStack {
                    // Outer glow
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    message.theme.accentColor.opacity(message.theme.accentOpacity * 0.4),
                                    message.theme.accentColor.opacity(0)
                                ],
                                center: .center,
                                startRadius: 40,
                                endRadius: 100
                            )
                        )
                        .frame(width: 200, height: 200)
                    
                    // Icon background circle
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    message.theme.backgroundColor.opacity(message.theme.backgroundOpacity * 0.8),
                                    message.theme.accentColor.opacity(message.theme.accentOpacity * 0.6)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .overlay(
                            Circle()
                                .stroke(
                                    message.theme.borderGradient(),
                                    lineWidth: 2
                                )
                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
                    
                    // Water icon
                    Image(systemName: message.icon)
                        .font(.system(size: 56, weight: .light, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    Color.white,
                                    message.theme.textColor.opacity(message.theme.textOpacity)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .symbolRenderingMode(.hierarchical)
                }
                .scaleEffect(scale)
                
                // Message content
                VStack(spacing: 16) {
                    Text(message.title)
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(message.theme.textColor.opacity(message.theme.textOpacity))
                        .multilineTextAlignment(.center)
                    
                    Text(message.message)
                        .font(.system(size: 20, weight: .regular, design: .rounded))
                        .foregroundColor(message.theme.secondaryTextColor.opacity(message.theme.secondaryTextOpacity))
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 60)
                
                // Gentle dismiss button - no countdown, user chooses when to dismiss
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        scale = 0.5
                        opacity = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        onDismiss()
                    }
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: "hand.tap.fill")
                            .font(.system(size: 18))
                        Text("Thanks, I'll drink water now")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        message.theme.backgroundColor,
                                        message.theme.accentColor
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
                    .shadow(color: message.theme.accentColor.opacity(0.4), radius: 15, x: 0, y: 8)
                }
                .buttonStyle(.plain)
                .padding(.top, 16)
            }
        }
        .opacity(opacity)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}

// MARK: - Visual Effect Blur Helper

/// Helper view for creating blur effect background
struct VisualEffectBlur: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.blendingMode = .behindWindow
        view.state = .active
        view.material = .hudWindow
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
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
