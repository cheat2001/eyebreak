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
    
    func showTestReminder() {
        print("🧪 Showing test ambient reminder")
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
        
        // Get screen dimensions
        guard let screen = NSScreen.main else { return }
        let screenFrame = screen.visibleFrame
        
        // Center horizontally, position at top
        let windowWidth: CGFloat = 350
        let windowHeight: CGFloat = 220
        let x = screenFrame.midX - (windowWidth / 2)
        let y = screenFrame.maxY - windowHeight - 80  // 80pt from top
        
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
        window.level = .floating
        window.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
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
        window.makeKeyAndOrderFront(nil)
        
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
    
    var color: Color {
        switch self {
        case .blink: return .blue
        case .lookLeft: return .purple
        case .lookRight: return .purple
        case .lookUp: return .green
        case .lookDown: return .green
        case .lookAround: return .orange
        case .custom: return .pink
        }
    }
}
