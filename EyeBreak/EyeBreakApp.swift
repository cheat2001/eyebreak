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
        // Settings window - not shown by default, only via menu
        Window("EyeBreak Settings", id: "settings") {
            SettingsView()
                .environmentObject(BreakTimerManager.shared)
                .environmentObject(AppSettings.shared)
                .frame(minWidth: 600, minHeight: 500)
        }
        .defaultSize(width: 700, height: 600)
        .defaultPosition(.center)
        // CRITICAL: Don't show window on launch - this prevents app from being tied to a specific Space
        .windowStyle(.hiddenTitleBar)
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
            }
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBar: StatusBarController?
    var eventMonitors: [Any] = []
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // CRITICAL: Use .accessory policy so app doesn't "own" any space
        // This prevents the app from being tied to a specific desktop
        NSApp.setActivationPolicy(.accessory)
        
        // Hide all windows on launch - Settings can be opened via menu only
        for window in NSApplication.shared.windows {
            window.orderOut(nil)
        }
        
        // Initialize status bar
        statusBar = StatusBarController()
        
        // Setup global keyboard shortcuts
        setupGlobalKeyboardShortcuts()
        
        // Start ambient reminders if enabled
        if AppSettings.shared.ambientRemindersEnabled {
            AmbientReminderManager.shared.startAmbientReminders()
        }
        
        print("✅ App launched successfully!")
        print("👀 EyeBreak running in background (accessory mode)")
        print("   - No Settings window shown by default")
        print("   - Open Settings from menubar or Dock if needed")
        print("")
        print("⌨️  Keyboard Shortcuts:")
        print("   ⌘⇧S - Start timer")
        print("   ⌘⇧B - Take break now")
        print("   ⌘⇧X - Stop timer")
        print("   ⌘⇧R - Show ambient reminder")
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        // Clean up event monitors
        for monitor in eventMonitors {
            NSEvent.removeMonitor(monitor)
        }
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
            return event
        }
        
        if let monitor = localMonitor {
            eventMonitors.append(monitor)
        }
    }
}
