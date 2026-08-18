//
//  AccessibilityPermission.swift
//  EyeBreak
//
//  Watches the Accessibility (input monitoring) permission that the global
//  keyboard shortcuts depend on.
//
//  This matters more than it looks. EyeBreak is distributed with an ad-hoc code
//  signature, which means its designated requirement is pinned to the build's
//  cdhash:
//
//      designated => cdhash H"e39f52e1…"
//
//  Every build produces a different cdhash, so macOS treats each update as a
//  different program and drops any Accessibility grant the user had given. The
//  global shortcuts (Cmd+Shift+B and friends) then stop working with no error
//  and no prompt, which reads as "the update broke the app".
//
//  Rather than leave people guessing, we detect the missing grant and offer to
//  open the right settings pane. A Developer ID signature would make the grant
//  survive updates and render this unnecessary.
//

import Foundation
import AppKit
import ApplicationServices

@MainActor
final class AccessibilityPermission: ObservableObject {

    static let shared = AccessibilityPermission()

    /// Whether the process is currently trusted for accessibility/input monitoring.
    @Published private(set) var isTrusted: Bool = AXIsProcessTrusted()

    /// Set once the user has dismissed the prompt for this version, so we ask at
    /// most once per update rather than on every launch.
    private static let promptedVersionKey = "accessibilityPromptedForVersion"

    private var pollTimer: Timer?

    private var currentVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0"
    }

    private init() {}

    // MARK: - Monitoring

    /// Begins watching the permission. There is no notification for TCC changes,
    /// so a low-frequency poll is the only reliable option; it stops as soon as
    /// the grant appears.
    func startMonitoring() {
        refresh()
        guard pollTimer == nil else { return }

        pollTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.refresh() }
        }
    }

    func stopMonitoring() {
        pollTimer?.invalidate()
        pollTimer = nil
    }

    private func refresh() {
        let trusted = AXIsProcessTrusted()
        if trusted != isTrusted {
            isTrusted = trusted
        }
        if trusted {
            // Nothing left to watch, and a granted permission cannot silently
            // revoke itself while the app keeps running.
            stopMonitoring()
        }
    }

    // MARK: - Prompting

    /// Called at launch. Stays quiet when the permission is present, or when the
    /// user has already been asked about this particular version.
    func promptIfNeededOnLaunch() {
        startMonitoring()
        guard !isTrusted else { return }

        let alreadyAsked = UserDefaults.standard.string(forKey: Self.promptedVersionKey)
        guard alreadyAsked != currentVersion else { return }

        UserDefaults.standard.set(currentVersion, forKey: Self.promptedVersionKey)

        // Give the menu bar time to settle before putting an alert on screen.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self, !self.isTrusted else { return }
            self.presentPrompt(afterUpdate: alreadyAsked != nil)
        }
    }

    /// Explicit request, e.g. from a button in Settings. Always shows something.
    func requestAccess() {
        refresh()
        if isTrusted {
            presentAlreadyGrantedAlert()
        } else {
            presentPrompt(afterUpdate: false)
        }
    }

    private func presentPrompt(afterUpdate: Bool) {
        NSApp.activate(ignoringOtherApps: true)

        let alert = NSAlert()
        alert.alertStyle = .informational
        alert.messageText = "Keyboard shortcuts need permission"

        if afterUpdate {
            alert.informativeText = """
            macOS reset EyeBreak's Accessibility permission when it updated, so the \
            keyboard shortcuts (⌘⇧B and the others) have stopped working.

            Re-enabling EyeBreak under Accessibility restores them. Everything else — \
            timers, break reminders and the menu bar — works normally either way.
            """
        } else {
            alert.informativeText = """
            EyeBreak needs Accessibility permission to use its keyboard shortcuts \
            (⌘⇧B to take a break, ⌘⇧S to start, and the rest).

            Everything else — timers, break reminders and the menu bar — works \
            normally without it.
            """
        }

        alert.addButton(withTitle: "Open Settings")
        alert.addButton(withTitle: "Not Now")

        if alert.runModal() == .alertFirstButtonReturn {
            openAccessibilitySettings()
        }
    }

    private func presentAlreadyGrantedAlert() {
        NSApp.activate(ignoringOtherApps: true)
        let alert = NSAlert()
        alert.alertStyle = .informational
        alert.messageText = "Keyboard shortcuts are enabled"
        alert.informativeText = "EyeBreak already has Accessibility permission."
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }

    /// Opens System Settings directly on Privacy & Security › Accessibility.
    func openAccessibilitySettings() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
        NSWorkspace.shared.open(url)
    }
}
