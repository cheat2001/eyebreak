//
//  StatusBarController.swift
//  EyeBreak
//
//  Created on October 5, 2025.
//

import AppKit
import SwiftUI
import Combine

class StatusBarController: NSObject, ObservableObject {
    private(set) var statusItem: NSStatusItem?
    private var cancellables = Set<AnyCancellable>()
    private var timerManager = BreakTimerManager.shared

    override init() {
        super.init()
        // Setup status bar synchronously on main thread
        if Thread.isMainThread {
            self.setupStatusBar()
        } else {
            DispatchQueue.main.sync {
                self.setupStatusBar()
            }
        }

        // Subscribe to timer state changes to update menu bar text
        setupTimerObserver()
    }

    // MARK: - Timer Observer

    private func setupTimerObserver() {
        timerManager.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.updateMenuBarText(for: state)
            }
            .store(in: &cancellables)
    }

    private func updateMenuBarText(for state: TimerState) {
        guard let button = statusItem?.button else { return }

        // Get the icon
        let icon: NSImage?
        let iconName: String

        switch state {
        case .idle:
            iconName = "eye"
        case .working, .preBreak:
            iconName = "eye.fill"
        case .breaking:
            iconName = "eye.slash.fill"
        case .paused:
            iconName = "pause.circle"
        }

        icon = NSImage(systemSymbolName: iconName, accessibilityDescription: "EyeBreak")
        icon?.isTemplate = true

        // Apply configuration for menu bar appropriate sizing
        let config = NSImage.SymbolConfiguration(pointSize: 14, weight: .medium, scale: .small)
        let configuredIcon = icon?.withSymbolConfiguration(config)

        // Format the time text
        let timeText: String
        switch state {
        case .idle:
            timeText = ""
        case .working(let seconds), .preBreak(let seconds):
            timeText = formatTimeCompact(seconds)
        case .breaking(let seconds):
            timeText = formatTimeCompact(seconds)
        case .paused(_, let seconds):
            timeText = formatTimeCompact(seconds)
        }

        // Update button
        button.image = configuredIcon

        if timeText.isEmpty {
            button.imagePosition = .imageOnly
            button.title = ""
        } else {
            button.imagePosition = .imageLeading
            button.title = " \(timeText)"

            // Style the title
            let attributes: [NSAttributedString.Key: Any] = [
                .font: NSFont.monospacedDigitSystemFont(ofSize: 12, weight: .medium),
                .foregroundColor: NSColor.labelColor
            ]
            button.attributedTitle = NSAttributedString(string: " \(timeText)", attributes: attributes)
        }

        // Update tooltip
        button.toolTip = tooltipText(for: state)
    }

    private func formatTimeCompact(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60

        if minutes > 0 {
            return "\(minutes):\(String(format: "%02d", secs))"
        } else {
            return "0:\(String(format: "%02d", secs))"
        }
    }

    private func tooltipText(for state: TimerState) -> String {
        switch state {
        case .idle:
            return "EyeBreak - Click to start"
        case .working(let seconds):
            return "Working - Break in \(formatTimeCompact(seconds))"
        case .preBreak(let seconds):
            return "Break starting in \(seconds) seconds"
        case .breaking(let seconds):
            return "On break - \(seconds) seconds remaining"
        case .paused:
            return "Timer paused"
        }
    }
    
    private func setupStatusBar() {
        
        // Create status bar item - try VARIABLE length first
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        guard let item = statusItem else {
            return
        }
        
        
        guard let button = item.button else {
            return
        }
        
        // Set clean, simple icon
        if let icon = NSImage(systemSymbolName: "eye.fill", accessibilityDescription: "EyeBreak") {
            icon.isTemplate = true
            
            // Apply configuration for menu bar appropriate sizing
            let config = NSImage.SymbolConfiguration(pointSize: 16, weight: .regular, scale: .small)
            let configuredIcon = icon.withSymbolConfiguration(config)
            
            button.image = configuredIcon
            button.imagePosition = .imageOnly
        }
        
        button.toolTip = "EyeBreak - Eye Care Reminders"
        button.appearsDisabled = false
        
        // Force button to be visible
        button.isHidden = false
        
        
        // Make status item visible and persistent
        item.isVisible = true
        item.behavior = []  // Empty behavior = non-removable by user
        item.autosaveName = "EyeBreakStatusItem" // Persist across launches
        
        
        // Create menu
        let menu = NSMenu()
        menu.autoenablesItems = true
        
        // Settings
        let settingsItem = NSMenuItem(title: "Open Settings...", action: #selector(openSettings), keyEquivalent: ",")
        settingsItem.target = self
        menu.addItem(settingsItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Timer controls
        let startItem = NSMenuItem(title: "Start Timer", action: #selector(startTimer), keyEquivalent: "s")
        startItem.keyEquivalentModifierMask = [.command, .shift]
        startItem.target = self
        menu.addItem(startItem)
        
        let breakItem = NSMenuItem(title: "Take Break Now", action: #selector(takeBreak), keyEquivalent: "b")
        breakItem.keyEquivalentModifierMask = [.command, .shift]
        breakItem.target = self
        menu.addItem(breakItem)
        
        let stopItem = NSMenuItem(title: "Stop Timer", action: #selector(stopTimer), keyEquivalent: "x")
        stopItem.keyEquivalentModifierMask = [.command, .shift]
        stopItem.target = self
        menu.addItem(stopItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Reminder
        let reminderItem = NSMenuItem(title: "Show Reminder", action: #selector(showReminder), keyEquivalent: "r")
        reminderItem.keyEquivalentModifierMask = [.command, .shift]
        reminderItem.target = self
        menu.addItem(reminderItem)
        
        menu.addItem(NSMenuItem.separator())

        // Water Reminder
        let waterReminderItem = NSMenuItem(title: "Show Water Reminder", action: #selector(showWaterReminder), keyEquivalent: "w")
        waterReminderItem.keyEquivalentModifierMask = [.command, .shift]
        waterReminderItem.target = self
        menu.addItem(waterReminderItem)

        // Quit
        let quitItem = NSMenuItem(title: "Quit EyeBreak", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        // Assign menu to status item
        item.menu = menu
        
    }
    
    @objc func openSettings() {
        
        // Check if settings window already exists
        var settingsWindowExists = false
        for window in NSApp.windows {
            if window.title == "EyeBreak Settings" {
                // Window exists, just bring it to front
                window.makeKeyAndOrderFront(nil)
                NSApp.activate(ignoringOtherApps: true)
                settingsWindowExists = true
                break
            }
        }
        
        // If no settings window exists, open a new one using the SwiftUI Window API
        if !settingsWindowExists {
            // Use NSWorkspace to open the window via the app's URL scheme or environment
            // This will trigger the SwiftUI Window("settings") to open
            NSApp.activate(ignoringOtherApps: true)
            
            // Create the settings window through SwiftUI Window scene
            let settingsView = SettingsView()
                .environmentObject(BreakTimerManager.shared)
                .environmentObject(AppSettings.shared)
            
            let hostingController = NSHostingController(rootView: settingsView)
            let window = NSWindow(contentViewController: hostingController)
            window.title = "EyeBreak Settings"
            window.setContentSize(NSSize(width: 700, height: 600))
            window.styleMask = [.titled, .closable, .miniaturizable, .resizable]
            window.center()
            window.isReleasedWhenClosed = false
            
            window.makeKeyAndOrderFront(nil)
        }
    }
    
    @objc private func startTimer() {
        BreakTimerManager.shared.start()
    }
    
    @objc private func takeBreak() {
        BreakTimerManager.shared.takeBreakNow()
    }
    
    @objc private func stopTimer() {
        BreakTimerManager.shared.stop()
    }
    
    @objc private func showReminder() {
        AmbientReminderManager.shared.showAmbientReminder()
    }
    
    @objc private func showWaterReminder() {
        WaterReminderManager.shared.showWaterReminderNow()
    }
    
    @objc private func quit() {
        NSApplication.shared.terminate(nil)
    }
}
