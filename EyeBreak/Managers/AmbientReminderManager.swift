//
//  AmbientReminderManager.swift
//  EyeBreak
//
//  Created on October 5, 2025.
//

import SwiftUI
import AppKit

/// Manages ambient eye exercise reminders that appear while working
class AmbientReminderManager: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = AmbientReminderManager()
    
    // MARK: - Properties
    
    private var reminderTimer: Timer?
    private var activeReminders: [NSWindow] = []
    @Published var isEnabled: Bool = false
    
    private let reminderTypes: [ReminderType] = [
        .blink,
        .lookLeft,
        .lookRight,
        .lookUp,
        .lookDown,
        .lookAround
    ]
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Public Methods
    
    func startAmbientReminders() {
        guard !isEnabled else { return }
        isEnabled = true
        
        print("🟢 Starting ambient reminders")
        scheduleNextReminder()
    }
    
    func stopAmbientReminders() {
        print("🔴 Stopping ambient reminders")
        isEnabled = false
        reminderTimer?.invalidate()
        reminderTimer = nil
        hideAllReminders()
    }
    
    func showAmbientReminder() {
        print("👁️ Showing ambient reminder on demand")
        showRandomReminder()
    }
    
    // MARK: - Private Methods
    
    private func scheduleNextReminder() {
        guard isEnabled else { return }
        
        let settings = AppSettings.shared
        let interval = TimeInterval(settings.ambientReminderIntervalMinutes * 60)
        
        reminderTimer?.invalidate()
        reminderTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            self?.showRandomReminder()
            self?.scheduleNextReminder()
        }
    }
    
    private func showRandomReminder() {
        guard isEnabled else { return }
        
        let settings = AppSettings.shared
        
        // Check if using custom reminder
        let reminderType: ReminderType
        if settings.useCustomReminder && !settings.customReminderEmoji.isEmpty {
            reminderType = .custom
        } else {
            reminderType = reminderTypes.randomElement() ?? .blink
        }
        
        print("👁️ Showing ambient reminder: \(reminderType.rawValue)")
        
        // Get the screen with mouse cursor (the active screen user is on)
        let mouseLocation = NSEvent.mouseLocation
        let activeScreen = NSScreen.screens.first(where: { NSMouseInRect(mouseLocation, $0.frame, false) }) ?? NSScreen.main ?? NSScreen.screens[0]
        let screenFrame = activeScreen.visibleFrame
        
        print("👁️ Mouse location: \(mouseLocation)")
        print("👁️ Active screen: \(activeScreen.frame)")
        
        // Center horizontally, position at top with larger size for full text
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
        window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.maximumWindow)))  // Highest possible level - above everything
        // CRITICAL: Use .canJoinAllSpaces to show on ALL desktops simultaneously
        window.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle, .transient, .fullScreenAuxiliary]
        window.hasShadow = false
        window.isMovable = false
        
        // Create SwiftUI view
        let contentView = AmbientReminderView(
            reminderType: reminderType,
            onDismiss: { [weak self, weak window] in
                self?.dismissReminder(window: window)
            }
        )
        
        window.contentView = NSHostingView(rootView: contentView)
        
        // CRITICAL: Force window to the calculated position on the active screen
        window.setFrame(windowRect, display: true, animate: false)
        
        print("👁️ Window frame: \(window.frame), Calculated rect: \(windowRect)")
        
        // CRITICAL: Show window WITHOUT activating the app
        // This prevents desktop switching but still shows the reminder
        window.orderFrontRegardless()
        
        activeReminders.append(window)
        
        // Auto-dismiss after duration
        let duration = TimeInterval(settings.ambientReminderDurationSeconds)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self, weak window] in
            self?.dismissReminder(window: window)
        }
    }
    
    private func dismissReminder(window: NSWindow?) {
        guard let window = window else { return }
        
        window.orderOut(nil)
        activeReminders.removeAll { $0 == window }
    }
    
    private func hideAllReminders() {
        activeReminders.forEach { $0.orderOut(nil) }
        activeReminders.removeAll()
    }
}

// MARK: - Reminder Type

enum ReminderType: String {
    case blink = "Blink"
    case lookLeft = "Look Left"
    case lookRight = "Look Right"
    case lookUp = "Look Up"
    case lookDown = "Look Down"
    case lookAround = "Look Around"
    case custom = "Custom"
    
    var emoji: String {
        switch self {
        case .blink: return "👁️"
        case .lookLeft: return "👈"
        case .lookRight: return "👉"
        case .lookUp: return "☝️"
        case .lookDown: return "👇"
        case .lookAround: return "🔄"
        case .custom: 
            let emoji = AppSettings.shared.customReminderEmoji
            return emoji.isEmpty ? "💡" : emoji
        }
    }
    
    var message: String {
        switch self {
        case .blink: return "Blink your eyes"
        case .lookLeft: return "Look to the left"
        case .lookRight: return "Look to the right"
        case .lookUp: return "Look up"
        case .lookDown: return "Look down"
        case .lookAround: return "Look around"
        case .custom:
            let message = AppSettings.shared.customReminderMessage
            return message.isEmpty ? "Take care of your eyes" : message
        }
    }
    
    var subtitle: String {
        switch self {
        case .blink: return "Rest for a moment"
        case .lookLeft: return "Shift your focus"
        case .lookRight: return "Shift your focus"
        case .lookUp: return "Change your view"
        case .lookDown: return "Relax your gaze"
        case .lookAround: return "Take a visual break"
        case .custom: return "Eye care reminder"
        }
    }
    
    var color: Color {
        switch self {
        case .blink: return Color(red: 0.2, green: 0.6, blue: 1.0) // Bright blue
        case .lookLeft: return Color(red: 0.7, green: 0.3, blue: 1.0) // Purple
        case .lookRight: return Color(red: 0.7, green: 0.3, blue: 1.0) // Purple
        case .lookUp: return Color(red: 0.2, green: 0.8, blue: 0.5) // Green
        case .lookDown: return Color(red: 0.2, green: 0.8, blue: 0.5) // Green
        case .lookAround: return Color(red: 1.0, green: 0.6, blue: 0.2) // Orange
        case .custom: return Color(red: 1.0, green: 0.4, blue: 0.7) // Pink
        }
    }
    
    var secondaryColor: Color {
        switch self {
        case .blink: return Color(red: 0.4, green: 0.8, blue: 1.0) // Light blue
        case .lookLeft: return Color(red: 0.9, green: 0.5, blue: 1.0) // Light purple
        case .lookRight: return Color(red: 0.9, green: 0.5, blue: 1.0) // Light purple
        case .lookUp: return Color(red: 0.4, green: 1.0, blue: 0.7) // Light green
        case .lookDown: return Color(red: 0.4, green: 1.0, blue: 0.7) // Light green
        case .lookAround: return Color(red: 1.0, green: 0.8, blue: 0.4) // Light orange
        case .custom: return Color(red: 1.0, green: 0.6, blue: 0.9) // Light pink
        }
    }
}
