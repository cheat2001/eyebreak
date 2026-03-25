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
    private var globalEscMonitor: Any?
    private var skipCallback: (() -> Void)?
    private var workspaceObserver: Any?
    
    enum OverlayStyle {
        case blur
        case exercise
    }
    
    private init() {}
    
    // MARK: - Public Methods
    
    func showBreakOverlay(duration: Int, style: OverlayStyle, onSkip: @escaping () -> Void) {
        
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

        // Get the screen with mouse cursor (the active screen user is on)
        let mouseLocation = NSEvent.mouseLocation
        let activeScreen = NSScreen.screens.first(where: { NSMouseInRect(mouseLocation, $0.frame, false) }) ?? NSScreen.main ?? NSScreen.screens[0]

        // Create overlay for the active screen where user is working
        let window = self.createOverlayWindow(for: activeScreen)

        // CRITICAL: Force window frame to the active screen
        window.setFrame(activeScreen.frame, display: true, animate: false)

        // Shared skip callback — ensures main-thread execution and is wired into both
        // the window-level sendEvent override (handles first-click even when not key)
        // and the SwiftUI view (handles tap gestures / timer expiry).
        let skipAction: () -> Void = {
            if Thread.isMainThread {
                onSkip()
            } else {
                DispatchQueue.main.async { onSkip() }
            }
        }
        window.onSkip = skipAction
        self.skipCallback = skipAction

        // Global ESC monitor — fires when the overlay window is not key (e.g. after
        // alt-tab). Managed here on the class rather than inside the SwiftUI view so
        // its lifetime is guaranteed to match the overlay's lifetime exactly.
        if let existing = globalEscMonitor { NSEvent.removeMonitor(existing) }
        globalEscMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard event.keyCode == 53 else { return } // ESC
            DispatchQueue.main.async { self?.skipCallback?() }
        }

        // Workspace observer — reclaims key-window focus after the user releases
        // Cmd+Tab and another app becomes active. This is the reliable path for
        // ESC to work after app switching, because resignKey() cannot reclaim while
        // the Dock (app switcher) still owns the keyboard.
        if let existing = workspaceObserver {
            NSWorkspace.shared.notificationCenter.removeObserver(existing)
        }
        workspaceObserver = NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.didActivateApplicationNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self, !self.overlayWindows.isEmpty else { return }
            let bundleId = (notification.userInfo?[NSWorkspace.applicationUserInfoKey]
                as? NSRunningApplication)?.bundleIdentifier ?? ""
            // Ignore our own activation and the Dock (app-switcher) taking focus.
            guard bundleId != "com.apple.dock",
                  bundleId != Bundle.main.bundleIdentifier else { return }
            // Another app settled as frontmost — reclaim key status so ESC works.
            NSApp.activate(ignoringOtherApps: true)
            self.overlayWindows.first?.makeKey()
        }

        // Create the SwiftUI overlay view
        let overlayView = BreakOverlayView(
            duration: duration,
            style: style,
            onSkip: skipAction
        )
        
        let hostingController = NSHostingController(rootView: overlayView)
        hostingController.view.frame = activeScreen.frame
        
        window.contentView = hostingController.view
        
        // Show window and claim key status so ESC/click-to-skip work immediately.
        // orderFrontRegardless avoids space-switching; makeKey claims keyboard focus
        // without fully activating the app.
        window.orderFrontRegardless()
        window.makeKey()

        self.overlayWindows.append(window)
        self.hostingControllers.append(hostingController)
        
    }
    
    func hideOverlay() {
        
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

        // Remove global ESC monitor first
        if let monitor = globalEscMonitor {
            NSEvent.removeMonitor(monitor)
            globalEscMonitor = nil
        }
        skipCallback = nil

        // Remove workspace observer
        if let observer = workspaceObserver {
            NSWorkspace.shared.notificationCenter.removeObserver(observer)
            workspaceObserver = nil
        }

        // Remove content views (breaks retain cycles), hide, then close
        for window in self.overlayWindows {
            window.contentView = nil
            window.orderOut(nil)
            window.close()
        }

        // Clear arrays
        self.overlayWindows.removeAll()
        self.hostingControllers.removeAll()
    }
    
    // MARK: - Private Methods
    
    private func createOverlayWindow(for screen: NSScreen) -> BreakOverlayWindow {
        let window = BreakOverlayWindow(
            contentRect: screen.frame,
            styleMask: [.borderless, .fullSizeContentView],
            backing: .buffered,
            defer: false,
            screen: screen
        )
        
        window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.maximumWindow)))
        window.backgroundColor = .clear
        window.isOpaque = false
        window.hasShadow = false
        window.ignoresMouseEvents = false
        // .canJoinAllSpaces keeps the overlay visible across all Spaces/desktops.
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary, .transient]
        window.acceptsMouseMovedEvents = true
        window.isReleasedWhenClosed = false
        window.animationBehavior = .none
        window.hidesOnDeactivate = false
        window.canHide = false
        
        return window
    }
}

// MARK: - Custom Window Class

/// Custom NSWindow that can become key window even when borderless.
/// Handles skip via sendEvent so the first click always dismisses even when not key.
class BreakOverlayWindow: NSWindow {
    var onSkip: (() -> Void)?

    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }

    /// Intercept mouse clicks and ESC at the window level, before macOS key-window
    /// logic runs. This means the very first click on a non-key overlay triggers skip
    /// immediately instead of just activating the window (the classic "double-click" bug).
    /// The skip is deferred one run-loop tick to avoid closing the window from within
    /// its own sendEvent (reentrancy).
    override func sendEvent(_ event: NSEvent) {
        switch event.type {
        case .leftMouseDown, .rightMouseDown:
            DispatchQueue.main.async { [weak self] in self?.onSkip?() }
            return
        case .keyDown where event.keyCode == 53: // ESC
            DispatchQueue.main.async { [weak self] in self?.onSkip?() }
            return
        case .cursorUpdate:
            // Force arrow cursor — prevents SwiftUI Text views from showing the I-beam.
            NSCursor.arrow.set()
            return
        default:
            super.sendEvent(event)
        }
    }
    // Reclaim key + active status when another app steals focus.
    // A stacking guard ensures only one reclaim is pending at a time, so rapid
    // Cmd+Tab presses don't queue up a pile of competing makeKey() calls.
    private var keyReclaimPending = false

    override func resignKey() {
        super.resignKey()
        guard !keyReclaimPending else { return }
        keyReclaimPending = true
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.keyReclaimPending = false
            guard self.isVisible else { return }
            // While the Dock's app-switcher is open the Dock owns the keyboard.
            // Attempting to steal focus causes visual glitches and breaks switcher
            // navigation; the workspace observer handles reclaim once the user
            // releases Cmd+Tab and a real app settles as frontmost.
            let frontmost = NSWorkspace.shared.frontmostApplication?.bundleIdentifier ?? ""
            guard frontmost != "com.apple.dock" else { return }
            // Activating the app is required — makeKey() alone does not route
            // keyboard events to a window whose application is not the active one.
            NSApp.activate(ignoringOtherApps: true)
            self.makeKey()
        }
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
