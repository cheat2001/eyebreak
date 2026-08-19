//
//  SettingsWindowHost.swift
//  EyeBreak
//
//  Keeps the settings UI out of the render loop while its window is hidden.
//
//  SwiftUI instantiates the settings Window scene at launch and keeps it alive
//  after it is closed. SettingsView observes BreakTimerManager, whose state
//  publishes once a second, so the whole settings tree was being laid out and
//  GPU-rendered every second into a window nobody could see. That accounted for
//  roughly 24 percentage points of idle CPU on its own.
//
//  Building the real view only while the window is on screen removes that cost
//  entirely, and costs nothing when the window is open.
//

import SwiftUI
import AppKit

struct SettingsWindowHost: View {
    @State private var isWindowVisible = false

    var body: some View {
        ZStack {
            if isWindowVisible {
                SettingsView()
                    .environmentObject(BreakTimerManager.shared)
                    .environmentObject(AppSettings.shared)
            } else {
                // Placeholder keeps the window sized correctly without
                // subscribing to anything.
                Color(nsColor: .windowBackgroundColor)
            }
        }
        .frame(minWidth: 600, minHeight: 500)
        .background(WindowVisibilityReader(isVisible: $isWindowVisible))
    }
}

/// Reports whether the hosting window is actually on screen.
private struct WindowVisibilityReader: NSViewRepresentable {
    @Binding var isVisible: Bool

    func makeNSView(context: Context) -> NSView {
        let view = TrackingView()
        view.onVisibilityChange = { visible in
            // Avoid publishing during view update.
            DispatchQueue.main.async {
                if isVisible != visible { isVisible = visible }
            }
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}

    final class TrackingView: NSView {
        var onVisibilityChange: ((Bool) -> Void)?
        private var observers: [NSObjectProtocol] = []

        deinit {
            observers.forEach { NotificationCenter.default.removeObserver($0) }
        }

        override func viewDidMoveToWindow() {
            super.viewDidMoveToWindow()
            observers.forEach { NotificationCenter.default.removeObserver($0) }
            observers.removeAll()

            guard let window else {
                onVisibilityChange?(false)
                return
            }

            let center = NotificationCenter.default
            for name in [
                NSWindow.didChangeOcclusionStateNotification,
                NSWindow.willCloseNotification,
                NSWindow.didBecomeKeyNotification,
                NSWindow.didMiniaturizeNotification,
                NSWindow.didDeminiaturizeNotification,
            ] {
                observers.append(
                    center.addObserver(forName: name, object: window, queue: .main) { [weak self] note in
                        // willClose fires before isVisible flips, so treat it as hidden.
                        if note.name == NSWindow.willCloseNotification {
                            self?.onVisibilityChange?(false)
                        } else {
                            self?.report()
                        }
                    }
                )
            }
            report()
        }

        private func report() {
            guard let window else { onVisibilityChange?(false); return }
            // Deliberately not checking occlusionState: a settings window sitting
            // behind another app is still "open" from the user's point of view,
            // and tearing the view down there would blank it on every switch.
            // isVisible is false for a closed window, which is the case that
            // actually costs us anything.
            let visible = window.isVisible && !window.isMiniaturized
            onVisibilityChange?(visible)
        }
    }
}
