//
//  StatusBarController.swift
//  EyeBreak
//
//  Created on October 5, 2025.
//

import AppKit
import SwiftUI

class StatusBarController: NSObject, ObservableObject {
    private(set) var statusItem: NSStatusItem?  // Changed to private(set) to allow reading
    
    override init() {
        super.init()
        print("🔵 StatusBarController init started")
        // Setup status bar synchronously on main thread
        if Thread.isMainThread {
            self.setupStatusBar()
        } else {
            DispatchQueue.main.sync {
                self.setupStatusBar()
            }
        }
        print("✅ StatusBarController init completed")
    }
    
    private func setupStatusBar() {
        print("📍 Setting up status bar")
        
        // Create status bar item - try VARIABLE length first
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        guard let item = statusItem else {
            print("❌ Failed to create status item")
            return
        }
        
        print("✅ Status item created: \(item)")
        
        guard let button = item.button else {
            print("❌ Failed to get status button")
            return
        }
        
        print("✅ Status button retrieved: \(button)")
        
        // Use ONLY plain text for maximum compatibility
        // Plain text emoji is most reliable across all macOS versions
        button.title = " 👁️ "  // Space before and after for visibility
        button.imagePosition = .noImage  // Don't use image at all
        
        button.toolTip = "EyeBreak - Eye Care Reminders"
        button.appearsDisabled = false
        
        // Force button to be visible
        button.isHidden = false
        
        print("👁️ Set plain text icon: '\(button.title ?? "nil")'")
        
        // Make status item visible and persistent
        item.isVisible = true
        item.behavior = []  // Empty behavior = non-removable by user
        item.autosaveName = "EyeBreakStatusItem" // Persist across launches
        
        print("📍 Status item configured:")
        print("   - Visible: \(item.isVisible)")
        print("   - Button title: '\(button.title ?? "nil")'")
        print("   - Button hidden: \(button.isHidden)")
        print("   - Length: \(item.length)")
        
        // Create menu
        let menu = NSMenu()
        menu.autoenablesItems = true
        
        // Settings
        let settingsItem = NSMenuItem(title: "Open Settings...", action: #selector(openSettings), keyEquivalent: ",")
        settingsItem.target = self
        menu.addItem(settingsItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Timer controls
        let startItem = NSMenuItem(title: "Start Timer", action: #selector(startTimer), keyEquivalent: "")
        startItem.target = self
        menu.addItem(startItem)
        
        let breakItem = NSMenuItem(title: "Take Break Now", action: #selector(takeBreak), keyEquivalent: "")
        breakItem.target = self
        menu.addItem(breakItem)
        
        let stopItem = NSMenuItem(title: "Stop Timer", action: #selector(stopTimer), keyEquivalent: "")
        stopItem.target = self
        menu.addItem(stopItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Reminder
        let reminderItem = NSMenuItem(title: "Show Reminder", action: #selector(showReminder), keyEquivalent: "")
        reminderItem.target = self
        menu.addItem(reminderItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Quit
        let quitItem = NSMenuItem(title: "Quit EyeBreak", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        // Assign menu to status item
        item.menu = menu
        
        print("📋 Menu created with \(menu.items.count) items")
    }
    
    @objc func openSettings() {
        print("🔧 Opening Settings from menu bar")
        
        // Check if settings window already exists
        var settingsWindowExists = false
        for window in NSApp.windows {
            if window.title == "EyeBreak Settings" {
                // Window exists, just bring it to front
                window.makeKeyAndOrderFront(nil)
                NSApp.activate(ignoringOtherApps: true)
                settingsWindowExists = true
                print("✅ Brought existing settings window to front")
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
            print("✅ Created new settings window")
        }
    }
    
    @objc private func startTimer() {
        print("▶️ Start Timer")
        BreakTimerManager.shared.start()
    }
    
    @objc private func takeBreak() {
        print("☕️ Take Break")
        BreakTimerManager.shared.takeBreakNow()
    }
    
    @objc private func stopTimer() {
        print("⏹️ Stop Timer")
        BreakTimerManager.shared.stop()
    }
    
    @objc private func showReminder() {
        print("💡 Show Reminder")
        AmbientReminderManager.shared.showAmbientReminder()
    }
    
    @objc private func quit() {
        print("👋 Quitting")
        NSApplication.shared.terminate(nil)
    }
    
    func updateIcon(breaking: Bool) {
        guard let button = statusItem?.button else { return }
        
        let iconName = breaking ? "eye.trianglebadge.exclamationmark.fill" : "eye.fill"
        if let icon = NSImage(systemSymbolName: iconName, accessibilityDescription: "EyeBreak") {
            icon.isTemplate = true
            button.image = icon
        }
    }
}
