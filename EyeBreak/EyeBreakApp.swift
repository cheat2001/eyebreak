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
        Window("EyeBreak Settings", id: "settings") {
            SettingsView()
                .environmentObject(BreakTimerManager.shared)
                .environmentObject(AppSettings.shared)
                .frame(minWidth: 600, minHeight: 500)
        }
        .defaultSize(width: 700, height: 600)
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
            }
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBar: StatusBarController?
    var eventMonitors: [Any] = []
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Set activation policy to regular so app appears in Dock
        NSApp.setActivationPolicy(.regular)
        
        // Initialize status bar
        statusBar = StatusBarController()
        
        // Setup global keyboard shortcuts
        setupGlobalKeyboardShortcuts()
        
        // Start ambient reminders if enabled
        if AppSettings.shared.ambientRemindersEnabled {
            AmbientReminderManager.shared.startAmbientReminders()
        }
        
        print("✅ App launched successfully!")
        print("👀 Look for EyeBreak in:")
        print("   1. Menu bar (top-right, near clock)")
        print("   2. Dock (bottom of screen)")
        print("   3. Press ⌘⇧S to start timer")
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
            return event
        }
        
        if let monitor = localMonitor {
            eventMonitors.append(monitor)
        }
    }
}
