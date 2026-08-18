//
//  UpdateChecker.swift
//  EyeBreak
//
//  One-click automatic updates, powered by Sparkle.
//
//  The user presses a single button (or answers the automatic prompt) and
//  Sparkle downloads the new build, replaces EyeBreak.app in place, and
//  relaunches it. There is no DMG to mount and nothing to drag.
//
//  Updates are authenticated with an EdDSA signature: the public key lives in
//  Info.plist as SUPublicEDKey and the matching private key never leaves the
//  release pipeline's secret store. An archive that isn't signed by that key is
//  refused, so this stays safe even though builds are only ad-hoc code signed.
//

import Foundation
import AppKit
import Combine
import Sparkle

@MainActor
final class UpdateChecker: NSObject, ObservableObject {

    static let shared = UpdateChecker()

    /// Sparkle's standard controller: owns the updater and the built-in UI.
    private let controller: SPUStandardUpdaterController

    /// False while a check is already running, so the button can disable itself.
    @Published private(set) var canCheckForUpdates: Bool = false

    /// Mirrors Sparkle's own preference so SwiftUI can bind a toggle to it.
    @Published var automaticallyChecksForUpdates: Bool {
        didSet {
            guard controller.updater.automaticallyChecksForUpdates != automaticallyChecksForUpdates else { return }
            controller.updater.automaticallyChecksForUpdates = automaticallyChecksForUpdates
        }
    }

    private var cancellables = Set<AnyCancellable>()

    private override init() {
        // startingUpdater: true kicks off the scheduled background check.
        controller = SPUStandardUpdaterController(
            startingUpdater: true,
            updaterDelegate: nil,
            userDriverDelegate: nil
        )
        automaticallyChecksForUpdates = controller.updater.automaticallyChecksForUpdates

        super.init()

        controller.updater
            .publisher(for: \.canCheckForUpdates)
            .receive(on: RunLoop.main)
            .sink { [weak self] value in self?.canCheckForUpdates = value }
            .store(in: &cancellables)
    }

    // MARK: - Version

    /// The running app's version, read from the bundle so it can't drift.
    var currentVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "—"
    }

    /// When Sparkle last completed a check, if it ever has.
    var lastUpdateCheckDate: Date? {
        controller.updater.lastUpdateCheckDate
    }

    // MARK: - Actions

    /// Explicit "Check for Updates" — always reports back, including when the
    /// app is already current.
    func checkForUpdates() {
        NSApp.activate(ignoringOtherApps: true)
        controller.checkForUpdates(nil)
    }
}
