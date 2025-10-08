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
        
        // Optimize: Execute on main thread directly if already on main thread
        if Thread.isMainThread {
            self.showOverlayOnMainThread(duration: duration, style: style, onSkip: onSkip)
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.showOverlayOnMainThread(duration: duration, style: style, onSkip: onSkip)
            }
        }
    }
    
    private func showOverlayOnMainThread(duration: Int, style: OverlayStyle, onSkip: @escaping () -> Void) {
        // Generate a new random color theme for this break overlay (if using random color theme)
        AppSettings.shared.regenerateBreakOverlayRandomTheme()
        
        // Close existing windows
        for window in self.overlayWindows {
            window.orderOut(nil)
        }
        self.overlayWindows.removeAll()
        self.hostingControllers.removeAll()
        
        print("🟢 Cleared old windows, creating new ones")
        
        // Get the screen with mouse cursor (the active screen user is on)
        let mouseLocation = NSEvent.mouseLocation
        let activeScreen = NSScreen.screens.first(where: { NSMouseInRect(mouseLocation, $0.frame, false) }) ?? NSScreen.main ?? NSScreen.screens[0]
        
        print("🟢 Mouse location: \(mouseLocation)")
        print("🟢 Active screen: \(activeScreen.frame)")
        print("🟢 Creating overlay window for active screen")
        
        // Create overlay ONLY for the active screen where user is working
        let window = self.createOverlayWindow(for: activeScreen)
        print("🟢 Window created: \(window)")
        
        // CRITICAL: Force window frame to the active screen
        window.setFrame(activeScreen.frame, display: true, animate: false)
        
        // Create the beautiful SwiftUI overlay view
        let overlayView = BreakOverlayView(
            duration: duration,
            style: style,
            onSkip: { [weak self] in
                // Ensure onSkip is called on main thread safely
                if Thread.isMainThread {
                    onSkip()
                } else {
                    DispatchQueue.main.async {
                        onSkip()
                    }
                }
            }
        )
        
        let hostingController = NSHostingController(rootView: overlayView)
        hostingController.view.frame = activeScreen.frame
        
        window.contentView = hostingController.view
        print("🟢 Before showing window - window visible: \(window.isVisible)")
        print("🟢 Window frame: \(window.frame), Screen frame: \(activeScreen.frame)")
        
        // CRITICAL: Show window WITHOUT activating the app
        // This prevents desktop switching but still shows the overlay
        window.orderFrontRegardless()
        
        print("🟢 After orderFrontRegardless - window level=\(window.level.rawValue), key=\(window.isKeyWindow), visible=\(window.isVisible), alpha=\(window.alphaValue)")
        print("🟢 Window on screen: \(window.screen != nil), frame: \(window.frame)")
        print("🟢 Window content view: \(window.contentView != nil)")
        
        self.overlayWindows.append(window)
        self.hostingControllers.append(hostingController)
        
        print("🟢 Total windows created: 1 (active screen only)")
    }
    
    func hideOverlay() {
        print("🔴 hideOverlay() called - closing \(overlayWindows.count) window(s)")
        
        // Optimize: Execute on main thread directly if already on main thread
        if Thread.isMainThread {
            self.hideOverlayOnMainThread()
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.hideOverlayOnMainThread()
            }
        }
    }
    
    private func hideOverlayOnMainThread() {
        print("🔴 Inside hideOverlay - window count: \(self.overlayWindows.count)")
        
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
    
    // MARK: - Private Methods
    
    private func createOverlayWindow(for screen: NSScreen) -> NSWindow {
        let window = BreakOverlayWindow(
            contentRect: screen.frame,
            styleMask: [.borderless, .fullSizeContentView],
            backing: .buffered,
            defer: false,
            screen: screen
        )
        
        window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.maximumWindow)))  // Highest possible level - above everything
        window.backgroundColor = .clear  // Clear background for blur effect
        window.isOpaque = false  // Allow transparency
        window.hasShadow = false
        window.ignoresMouseEvents = false
        // CRITICAL: Use .canJoinAllSpaces to show on ALL desktops simultaneously
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary, .transient]
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
