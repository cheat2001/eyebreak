//
//  ScreenBlurManager.swift
//  EyeBreak
//
//  Created on October 5, 2025.
//

import AppKit
import SwiftUI

/// Manages full-screen blur overlay during breaks
class ScreenBlurManager {
    
    static let shared = ScreenBlurManager()
    
    private var overlayWindows: [NSWindow] = []
    private var hostingControllers: [NSHostingController<BreakOverlayView>] = []
    private let windowQueue = DispatchQueue(label: "com.eyebreak.window", qos: .userInteractive)
    
    enum OverlayStyle {
        case blur
        case exercise
    }
    
    private init() {}
    
    // MARK: - Public Methods
    
    func showBreakOverlay(duration: Int, style: OverlayStyle, onSkip: @escaping () -> Void) {
        print("🟢 ScreenBlurManager.showBreakOverlay() called - duration: \(duration)s, style: \(style)")
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            print("🟢 Creating overlay windows for \(NSScreen.screens.count) screen(s)")
            
            // DON'T call hideOverlay here - it clears the array!
            // self.hideOverlay() // Remove any existing overlays
            
            // Instead, just close existing windows without clearing the array yet
            for window in self.overlayWindows {
                window.orderOut(nil)
            }
            self.overlayWindows.removeAll()
            
            print("🟢 Cleared old windows, creating new ones")
            
            // Create overlay for each screen
            for (index, screen) in NSScreen.screens.enumerated() {
                print("🟢 Creating window for screen \(index + 1): frame=\(screen.frame)")
                
                let window = self.createOverlayWindow(for: screen)
                print("🟢 Window created: \(window)")
                
                // Create the beautiful SwiftUI overlay view
                let overlayView = BreakOverlayView(
                    duration: duration,
                    style: style,
                    onSkip: { [weak self] in
                        // Ensure onSkip is called on main thread safely
                        DispatchQueue.main.async {
                            onSkip()
                        }
                    }
                )
                
                let hostingController = NSHostingController(rootView: overlayView)
                hostingController.view.frame = screen.frame
                
                window.contentView = hostingController.view
                print("🟢 Before makeKeyAndOrderFront - window visible: \(window.isVisible)")
                
                // Set window properties BEFORE showing
                window.level = .floating + 100
                window.alphaValue = 1.0
                window.hidesOnDeactivate = false
                window.canHide = false
                
                window.makeKeyAndOrderFront(nil)
                window.orderFrontRegardless()
                
                // Force window to stay on top and capture all input
                NSApp.activate(ignoringOtherApps: true)
                
                print("🟢 After makeKeyAndOrderFront - window level=\(window.level.rawValue), key=\(window.isKeyWindow), visible=\(window.isVisible), alpha=\(window.alphaValue)")
                print("🟢 Window on screen: \(window.screen != nil), frame: \(window.frame)")
                print("🟢 Window content view: \(window.contentView != nil)")
                print("🟢 Window retainCount check - adding to array")
                
                self.overlayWindows.append(window)
                self.hostingControllers.append(hostingController)
            }
            
            print("🟢 Total windows created: \(self.overlayWindows.count)")
            print("🟢 Windows array: \(self.overlayWindows)")
        }
    }
    
    func hideOverlay() {
        print("🔴 hideOverlay() called - closing \(overlayWindows.count) window(s)")
        print("🔴 Call stack: \(Thread.callStackSymbols)")
        
        // Safely close and cleanup windows
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            print("🔴 Inside hideOverlay async - window count: \(self.overlayWindows.count)")
            
            // First, remove content views to break retain cycles
            for window in self.overlayWindows {
                window.contentView = nil
                window.orderOut(nil)
            }
            
            // Then close windows
            for window in self.overlayWindows {
                window.close()
            }
            
            // Clear arrays
            self.overlayWindows.removeAll()
            self.hostingControllers.removeAll()
        }
    }
    
    // MARK: - Private Methods
    
    private func createOverlayWindow(for screen: NSScreen) -> NSWindow {
        let window = BreakOverlayWindow(
            contentRect: screen.frame,
            styleMask: [.borderless, .fullSizeContentView],
            backing: .buffered,
            defer: false,
            screen: screen
        )
        
        window.level = .floating + 100  // Very high level
        window.backgroundColor = .clear  // Clear background for blur effect
        window.isOpaque = false  // Allow transparency
        window.hasShadow = false
        window.ignoresMouseEvents = false
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
        window.acceptsMouseMovedEvents = true
        window.isReleasedWhenClosed = false
        window.animationBehavior = .none
        window.alphaValue = 1.0  // Full opacity
        window.hidesOnDeactivate = false
        window.canHide = false
        
        return window
    }
}

// MARK: - Custom Window Class

/// Custom NSWindow that can become key window even when borderless
class BreakOverlayWindow: NSWindow {
    override var canBecomeKey: Bool {
        return true
    }
    
    override var canBecomeMain: Bool {
        return true
    }
}

// MARK: - Sound Manager

class SoundManager {
    
    static let shared = SoundManager()
    
    enum SoundType {
        case start
        case breakStart
        case breakEnd
        case skip
    }
    
    private init() {}
    
    func playSound(_ type: SoundType) {
        let soundName: NSSound.Name
        
        switch type {
        case .start:
            soundName = .init("Blow")
        case .breakStart:
            soundName = .init("Glass")
        case .breakEnd:
            soundName = .init("Purr")
        case .skip:
            soundName = .init("Tink")
        }
        
        NSSound(named: soundName)?.play()
    }
}
