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
        // Settings window - shown by default on first launch
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
            }
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBar: StatusBarController?
    var eventMonitors: [Any] = []
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("🚀 App launching...")
        
        // Prevent automatic termination
        NSApp.disableRelaunchOnLogin()
        
        // CRITICAL: Create status bar FIRST, while still in default mode
        print("📍 Creating status bar BEFORE changing activation policy...")
        statusBar = StatusBarController()
        print("✅ StatusBar initialized")
        
        // Force a small delay to ensure status bar is fully registered
        // THEN change to accessory mode
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            print("📍 Now switching to accessory mode...")
            NSApp.setActivationPolicy(.accessory)
            print("✅ Set to accessory mode (overlays appear on current workspace)")
            
            // Verify status bar is still visible after mode change
            if let bar = self.statusBar, let item = bar.statusItem {
                print("📍 After mode change - Status bar still exists: \(item.isVisible)")
            }
        }
        
        // Setup global keyboard shortcuts
        setupGlobalKeyboardShortcuts()
        
        // Start ambient reminders if enabled
        if AppSettings.shared.ambientRemindersEnabled {
            AmbientReminderManager.shared.startAmbientReminders()
        }
        
        print("✅ App launched successfully!")
        print("👀 EyeBreak running in ACCESSORY mode")
        print("   ✓ No Dock icon (prevents Space/desktop switching)")
        print("   ✓ Overlays appear on YOUR CURRENT workspace")
        print("   ✓ Menu bar icon should be visible (look for 👁️)")
        print("")
        print("⌨️  If menu bar icon not visible, use keyboard shortcuts:")
        print("   ⌘⇧O - Open Settings")
        print("   ⌘⇧S - Start timer")
        print("   ⌘⇧B - Take break now")
        print("   ⌘⇧X - Stop timer")
        print("   ⌘⇧R - Show ambient reminder (test overlay on current screen)")
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
            // Check for Command+Shift+O (Open Settings)
            else if event.modifierFlags.contains([.command, .shift]) && event.charactersIgnoringModifiers == "o" {
                DispatchQueue.main.async {
                    self.openSettings()
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
            // Check for Command+Shift+O (Open Settings)
            else if event.modifierFlags.contains([.command, .shift]) && event.charactersIgnoringModifiers == "o" {
                DispatchQueue.main.async {
                    self.openSettings()
                }
                return nil
            }
            return event
        }
        
        if let monitor = localMonitor {
            eventMonitors.append(monitor)
        }
    }
    
    private func openSettings() {
        print("🔧 Opening Settings via keyboard shortcut")
        
        // Create Settings window
        let settingsView = SettingsView()
            .environmentObject(BreakTimerManager.shared)
            .environmentObject(AppSettings.shared)
        
        let hostingController = NSHostingController(rootView: settingsView)
        let window = NSWindow(contentViewController: hostingController)
        window.title = "EyeBreak Settings"
        window.setContentSize(NSSize(width: 700, height: 600))
        window.styleMask = [.titled, .closable, .miniaturizable, .resizable]
        window.center()
        window.makeKeyAndOrderFront(nil)
        
        NSApp.activate(ignoringOtherApps: true)
        print("✅ Settings window opened")
    }
}
