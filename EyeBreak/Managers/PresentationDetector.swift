//
//  PresentationDetector.swift
//  EyeBreak
//
//  Created on March 18, 2026.
//

import Foundation
import AppKit
import CoreGraphics
import IOKit.pwr_mgt
import OSLog

private let log = Logger(subsystem: "com.eyebreak.app", category: "PresentationDetector")

/// Detects when the user is sharing their screen (pauseWhenSharing)
/// or actively playing media that prevents display sleep (pauseWhenWatchingMedia).
class PresentationDetector {

    // MARK: - Properties

    private var timer: Timer?
    private var isPresenting = false

    var onPresentationStateChanged: ((Bool) -> Void)?

    // Conferencing apps that create high-level overlay windows when screen-sharing
    private static let conferencingBundleIds: Set<String> = [
        "com.microsoft.teams2",          // Microsoft Teams (new)
        "com.microsoft.teams",           // Microsoft Teams (classic)
        "us.zoom.xos",                   // Zoom
        "com.cisco.webexmeetings",       // Cisco WebEx
        "com.loom.desktop",              // Loom
        "com.slack.slackApp",            // Slack
    ]

    // MARK: - Lifecycle

    deinit {
        stop()
    }

    // MARK: - Public Methods

    func start() {
        stop()
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.checkPresentationState()
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Private Methods

    private func checkPresentationState() {
        let presenting = detectShouldPause()
        if presenting != isPresenting {
            isPresenting = presenting
            log.info("Presentation state changed: \(presenting ? "started" : "ended")")
            onPresentationStateChanged?(isPresenting)
        }
    }

    private func detectShouldPause() -> Bool {
        let settings = AppSettings.shared

        if settings.pauseWhenSharing {
            if isDisplayMirrored() {
                log.info("Pause triggered: display mirroring active")
                return true
            }
            if hasScreenShareIndicatorWindow() {
                log.info("Pause triggered: screen-share indicator window found")
                return true
            }
        }

        if settings.pauseWhenWatchingMedia {
            if isDisplaySleepPrevented() {
                log.info("Pause triggered: display sleep prevented (media playing)")
                return true
            }
        }

        return false
    }

    // MARK: - Screen Sharing Detection

    /// Returns true when any display is part of a mirror set (e.g. projector connected)
    private func isDisplayMirrored() -> Bool {
        for screen in NSScreen.screens {
            guard let displayID = screen.deviceDescription[
                NSDeviceDescriptionKey("NSScreenNumber")
            ] as? CGDirectDisplayID else { continue }

            if CGDisplayIsInMirrorSet(displayID) != 0 {
                return true
            }
        }
        return false
    }

    /// Returns true when a conferencing app has a high-level indicator window on screen.
    /// Screen-sharing toolbars and capture borders from Teams, Zoom, etc. appear at
    /// elevated window levels (above normal app windows at level 0).
    private func hasScreenShareIndicatorWindow() -> Bool {
        let runningApps = NSWorkspace.shared.runningApplications
        let conferencingApps = runningApps.filter {
            guard let bundleId = $0.bundleIdentifier else { return false }
            return Self.conferencingBundleIds.contains(bundleId)
        }
        guard !conferencingApps.isEmpty else { return false }

        let conferencingPIDs = Set(conferencingApps.map { $0.processIdentifier })

        guard let windowList = CGWindowListCopyWindowInfo(
            [.optionOnScreenOnly, .excludeDesktopElements],
            kCGNullWindowID
        ) as? [[String: Any]] else { return false }

        // macOS window layers: normal=0, floating=3, status=25, pop-up menus=101.
        // Regular meeting UI (floating bars, PiP) sits at 3–25.
        // Screen-share indicator borders (the red/orange overlay) are at 500+.
        let indicatorWindowLayer = 500

        for window in windowList {
            guard
                let ownerPID = window[kCGWindowOwnerPID as String] as? Int32,
                conferencingPIDs.contains(ownerPID),
                let layer = window[kCGWindowLayer as String] as? Int,
                layer >= indicatorWindowLayer
            else { continue }

            let ownerName = window[kCGWindowOwnerName as String] as? String ?? "unknown"
            let windowName = window[kCGWindowName as String] as? String ?? ""
            log.info("Share indicator matched — app: \(ownerName), layer: \(layer), window: \(windowName)")
            return true
        }

        return false
    }

    // MARK: - Media Playback Detection

    /// Returns true when any non-conferencing process holds a "PreventUserIdleDisplaySleep"
    /// IOKit power assertion — the standard mechanism used by video players (AVFoundation,
    /// VLC, browsers playing fullscreen video) to keep the display awake during playback.
    /// Conferencing apps are excluded because their assertions indicate a call is active,
    /// not media playback; screen sharing from those apps is caught by hasScreenShareIndicatorWindow().
    private func isDisplaySleepPrevented() -> Bool {
        var assertionsRef: Unmanaged<CFDictionary>?
        guard IOPMCopyAssertionsByProcess(&assertionsRef) == kIOReturnSuccess,
              let dict = assertionsRef?.takeRetainedValue() as NSDictionary? else {
            return false
        }

        // PIDs of conferencing apps — exclude them from media detection
        let runningApps = NSWorkspace.shared.runningApplications
        let conferencingPIDs: Set<Int32> = Set(
            runningApps.compactMap { app -> Int32? in
                guard let id = app.bundleIdentifier,
                      Self.conferencingBundleIds.contains(id) else { return nil }
                return app.processIdentifier
            }
        )

        for (key, value) in dict {
            guard
                let pid = (key as? NSNumber).map({ Int32($0.intValue) }),
                !conferencingPIDs.contains(pid),
                let assertionList = value as? [[String: Any]]
            else { continue }

            for assertion in assertionList {
                // Use string literals to avoid Swift/C bridging issues with IOKit constants
                guard
                    let type = assertion["AssertionType"] as? String,
                    let level = assertion["AssertionLevel"] as? Int,
                    level > 0,
                    type == "PreventUserIdleDisplaySleep"
                else { continue }

                let appName = runningApps.first(where: { $0.processIdentifier == pid })?.localizedName ?? "PID \(pid)"
                log.info("Media assertion matched — app: \(appName)")
                return true
            }
        }
        return false
    }
}
