//
//  EyeBreakApp.swift
//  EyeBreak
//
//  Created on October 5, 2025.
//

import SwiftUI

@main
struct EyeBreakApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        // Settings window - shown on first launch
        Window("EyeBreak Settings", id: "settings") {
            SettingsView()
                .environmentObject(BreakTimerManager.shared)
                .environmentObject(AppSettings.shared)
                .frame(minWidth: 600, minHeight: 500)
        }
        .defaultSize(width: 700, height: 600)
        .defaultPosition(.center)
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button("About EyeBreak") {
                    NSApplication.shared.orderFrontStandardAboutPanel()
                }
            }
            
            CommandGroup(after: .appSettings) {
                Button("Start Timer") {
                    BreakTimerManager.shared.start()
                }
                .keyboardShortcut("s", modifiers: [.command, .shift])
                
                Button("Take Break Now") {
                    BreakTimerManager.shared.takeBreakNow()
                }
                .keyboardShortcut("b", modifiers: [.command, .shift])
                
                Button("Stop Timer") {
                    BreakTimerManager.shared.stop()
                }
                .keyboardShortcut("x", modifiers: [.command, .shift])
                
                Divider()
                
                Button("Show Ambient Reminder") {
                    AmbientReminderManager.shared.showAmbientReminder()
                }
                .keyboardShortcut("r", modifiers: [.command, .shift])
                
                Button("Show Water Reminder") {
                    WaterReminderManager.shared.showWaterReminderNow()
                }
                .keyboardShortcut("w", modifiers: [.command, .shift])
            }
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBar: StatusBarController?
    var eventMonitors: [Any] = []
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        // Prevent automatic termination
        NSApp.disableRelaunchOnLogin()
        
        // CRITICAL: Create status bar FIRST, while still in default mode
        statusBar = StatusBarController()
        
        // Force a small delay to ensure status bar is fully registered
        // THEN change to accessory mode
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            NSApp.setActivationPolicy(.accessory)
            
            // Verify status bar is still visible after mode change
            if let bar = self.statusBar, let item = bar.statusItem {
            }
        }
        
        // Setup global keyboard shortcuts
        setupGlobalKeyboardShortcuts()
        
        // Sync launch at login status with settings
        LaunchAtLoginManager.shared.syncWithSettings(AppSettings.shared)
        
        // Start ambient reminders if enabled
        if AppSettings.shared.ambientRemindersEnabled {
            AmbientReminderManager.shared.startAmbientReminders()
        }
        
        // Start water reminders if enabled
        if AppSettings.shared.waterReminderEnabled {
            WaterReminderManager.shared.startWaterReminders()
        }
        
        // Auto-start timer if enabled
        if AppSettings.shared.autoStartTimer {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                BreakTimerManager.shared.start()
            }
        } else {
        }
        
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        // Clean up event monitors
        for monitor in eventMonitors {
            NSEvent.removeMonitor(monitor)
        }
    }
    
    // Prevent app from quitting when last window closes
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    
    private func setupGlobalKeyboardShortcuts() {
        // Monitor for Command+Shift+B (Take Break Now)
        let breakNowMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
            // Check for Command+Shift+B
            if event.modifierFlags.contains([.command, .shift]) && event.charactersIgnoringModifiers == "b" {
                DispatchQueue.main.async {
                    BreakTimerManager.shared.takeBreakNow()
                }
            }
            // Check for Command+Shift+S (Start Timer)
            else if event.modifierFlags.contains([.command, .shift]) && event.charactersIgnoringModifiers == "s" {
                DispatchQueue.main.async {
                    BreakTimerManager.shared.start()
                }
            }
            // Check for Command+Shift+X (Stop Timer)
            else if event.modifierFlags.contains([.command, .shift]) && event.charactersIgnoringModifiers == "x" {
                DispatchQueue.main.async {
                    BreakTimerManager.shared.stop()
                }
            }
            // Check for Command+Shift+R (Show Ambient Reminder)
            else if event.modifierFlags.contains([.command, .shift]) && event.charactersIgnoringModifiers == "r" {
                DispatchQueue.main.async {
                    AmbientReminderManager.shared.showAmbientReminder()
                }
            }
            // Check for Command+Shift+W (Show Water Reminder)
            else if event.modifierFlags.contains([.command, .shift]) && event.charactersIgnoringModifiers == "w" {
                DispatchQueue.main.async {
                    WaterReminderManager.shared.showWaterReminderNow()
                }
            }
            // Check for Command+Shift+O (Open Settings)
            else if event.modifierFlags.contains([.command, .shift]) && event.charactersIgnoringModifiers == "o" {
                DispatchQueue.main.async {
                    NSApp.sendAction(#selector(StatusBarController.openSettings), to: nil, from: nil)
                }
            }
        }
        
        if let monitor = breakNowMonitor {
            eventMonitors.append(monitor)
        }
        
        // Also add local monitor for when app is focused
        let localMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            // Check for Command+Shift+B
            if event.modifierFlags.contains([.command, .shift]) && event.charactersIgnoringModifiers == "b" {
                DispatchQueue.main.async {
                    BreakTimerManager.shared.takeBreakNow()
                }
                return nil
            }
            // Check for Command+Shift+S
            else if event.modifierFlags.contains([.command, .shift]) && event.charactersIgnoringModifiers == "s" {
                DispatchQueue.main.async {
                    BreakTimerManager.shared.start()
                }
                return nil
            }
            // Check for Command+Shift+X
            else if event.modifierFlags.contains([.command, .shift]) && event.charactersIgnoringModifiers == "x" {
                DispatchQueue.main.async {
                    BreakTimerManager.shared.stop()
                }
                return nil
            }
            // Check for Command+Shift+R
            else if event.modifierFlags.contains([.command, .shift]) && event.charactersIgnoringModifiers == "r" {
                DispatchQueue.main.async {
                    AmbientReminderManager.shared.showAmbientReminder()
                }
                return nil
            }
            // Check for Command+Shift+W (Water Reminder)
            else if event.modifierFlags.contains([.command, .shift]) && event.charactersIgnoringModifiers == "w" {
                DispatchQueue.main.async {
                    WaterReminderManager.shared.showWaterReminderNow()
                }
                return nil
            }
            // Check for Command+Shift+O (Open Settings)
            else if event.modifierFlags.contains([.command, .shift]) && event.charactersIgnoringModifiers == "o" {
                DispatchQueue.main.async {
                    NSApp.sendAction(#selector(StatusBarController.openSettings), to: nil, from: nil)
                }
                return nil
            }
            return event
        }
        
        if let monitor = localMonitor {
            eventMonitors.append(monitor)
        }
    }
}
