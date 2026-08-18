//
//  MeetingDetector.swift
//  EyeBreak
//
//  Detects when the user is in a meeting, so break reminders can hold off.
//
//  Two distinct signals, because "presenting" and "being in a call" are not the
//  same thing and users want different behaviour from each:
//
//  * .screenSharing — the user is actively sharing their screen. Detected from
//    the elevated indicator window that conferencing apps place on screen while
//    sharing. This approach came from @phalox's work in #3.
//
//  * .anyCall — the user is in a call at all, sharing or not. Detected from the
//    microphone or camera being active. This is platform-agnostic on purpose:
//    it catches Google Meet in a browser, Zoom, Teams, Discord and anything
//    else, without needing a hard-coded list of applications to maintain.
//
//  Someone who works remotely may sit in calls for most of the day, which is
//  exactly when they still need break reminders. That is why this is opt-in and
//  defaults to the narrower .screenSharing behaviour when enabled.
//

import Foundation
import AppKit
import CoreGraphics
import CoreAudio
import CoreMediaIO
import OSLog

private let log = Logger(subsystem: "com.eyebreak.app", category: "MeetingDetector")

/// What counts as "in a meeting" for the purposes of pausing.
enum MeetingPauseMode: String, CaseIterable, Identifiable {
    case screenSharing   // only while actually sharing the screen
    case anyCall         // any call: microphone or camera in use

    var id: String { rawValue }

    var title: String {
        switch self {
        case .screenSharing: return "Only when I'm sharing my screen"
        case .anyCall:       return "Whenever I'm in a call"
        }
    }

    var explanation: String {
        switch self {
        case .screenSharing:
            return "Pauses only while you are presenting, so reminders keep working during calls you are just attending."
        case .anyCall:
            return "Pauses whenever your microphone or camera is active. Works with any platform, including Google Meet in a browser."
        }
    }
}

final class MeetingDetector {

    // MARK: - Properties

    private var timer: Timer?
    private(set) var isInMeeting = false

    /// Called on the main thread whenever the meeting state changes.
    var onMeetingStateChanged: ((Bool) -> Void)?

    /// Polling interval. Five seconds is responsive enough for something that
    /// only gates break reminders, and cheap enough to run continuously.
    private let pollInterval: TimeInterval = 5.0

    /// Conferencing apps whose screen-share indicator window we look for.
    /// Only used by .screenSharing — .anyCall deliberately needs no list.
    private static let conferencingBundleIds: Set<String> = [
        "us.zoom.xos",
        "com.microsoft.teams",
        "com.microsoft.teams2",
        "com.cisco.webexmeetings",
        "com.webex.meetingmanager",
        "com.google.Chrome",
        "com.apple.Safari",
        "com.microsoft.edgemac",
        "company.thebrowser.Browser",
        "com.brave.Browser",
        "com.slack.slackApp",
        "com.hnc.Discord",
        "com.loom.desktop",
        "com.gotomeeting.GoToMeeting",
        "com.bluejeansnet.Blue",
    ]

    // MARK: - Lifecycle

    deinit {
        timer?.invalidate()
    }

    func start() {
        stop()
        // Evaluate immediately so enabling the setting takes effect at once.
        check()
        timer = Timer.scheduledTimer(withTimeInterval: pollInterval, repeats: true) { [weak self] _ in
            self?.check()
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        if isInMeeting {
            isInMeeting = false
            onMeetingStateChanged?(false)
        }
    }

    var isRunning: Bool { timer != nil }

    // MARK: - Detection

    private func check() {
        let settings = AppSettings.shared
        guard settings.pauseDuringMeetings else {
            if isInMeeting {
                isInMeeting = false
                onMeetingStateChanged?(false)
            }
            return
        }

        let detected: Bool
        switch settings.meetingPauseMode {
        case .screenSharing:
            detected = isSharingScreen()
        case .anyCall:
            detected = isMicrophoneActive() || isCameraActive()
        }

        guard detected != isInMeeting else { return }
        isInMeeting = detected
        log.info("Meeting state changed: \(detected ? "in meeting" : "ended")")
        onMeetingStateChanged?(detected)
    }

    // MARK: - Screen sharing

    /// True when a conferencing app has an elevated indicator window on screen —
    /// the toolbar or capture border shown while sharing.
    private func isSharingScreen() -> Bool {
        let running = NSWorkspace.shared.runningApplications.filter {
            guard let id = $0.bundleIdentifier else { return false }
            return Self.conferencingBundleIds.contains(id)
        }
        // Cheap early-out: nothing that can share is even running.
        guard !running.isEmpty else { return false }

        let pids = Set(running.map { $0.processIdentifier })

        guard let windows = CGWindowListCopyWindowInfo(
            [.optionOnScreenOnly, .excludeDesktopElements],
            kCGNullWindowID
        ) as? [[String: Any]] else { return false }

        // Normal app windows sit at layer 0 and ordinary floating meeting UI at
        // 3–25. Share indicators are placed far above that.
        let indicatorLayerThreshold = 500

        for window in windows {
            guard
                let pid = window[kCGWindowOwnerPID as String] as? Int32,
                pids.contains(pid),
                let layer = window[kCGWindowLayer as String] as? Int,
                layer >= indicatorLayerThreshold
            else { continue }

            let owner = window[kCGWindowOwnerName as String] as? String ?? "unknown"
            log.info("Share indicator matched — app: \(owner), layer: \(layer)")
            return true
        }
        return false
    }

    // MARK: - Microphone

    /// True when any audio device with input streams is actively running.
    /// Platform-agnostic: it does not matter which app opened the microphone.
    private func isMicrophoneActive() -> Bool {
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDevices,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain)

        var size: UInt32 = 0
        guard AudioObjectGetPropertyDataSize(
            AudioObjectID(kAudioObjectSystemObject), &address, 0, nil, &size) == noErr else { return false }

        let count = Int(size) / MemoryLayout<AudioObjectID>.size
        guard count > 0 else { return false }

        var devices = [AudioObjectID](repeating: 0, count: count)
        guard AudioObjectGetPropertyData(
            AudioObjectID(kAudioObjectSystemObject), &address, 0, nil, &size, &devices) == noErr else { return false }

        for device in devices where deviceHasInput(device) {
            var running: UInt32 = 0
            var runningSize = UInt32(MemoryLayout<UInt32>.size)
            var runningAddress = AudioObjectPropertyAddress(
                mSelector: kAudioDevicePropertyDeviceIsRunningSomewhere,
                mScope: kAudioObjectPropertyScopeGlobal,
                mElement: kAudioObjectPropertyElementMain)

            if AudioObjectGetPropertyData(device, &runningAddress, 0, nil, &runningSize, &running) == noErr,
               running != 0 {
                return true
            }
        }
        return false
    }

    private func deviceHasInput(_ device: AudioObjectID) -> Bool {
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyStreams,
            mScope: kAudioDevicePropertyScopeInput,
            mElement: kAudioObjectPropertyElementMain)
        var size: UInt32 = 0
        return AudioObjectGetPropertyDataSize(device, &address, 0, nil, &size) == noErr && size > 0
    }

    // MARK: - Camera

    /// True when any video capture device is actively running.
    private func isCameraActive() -> Bool {
        var address = CMIOObjectPropertyAddress(
            mSelector: CMIOObjectPropertySelector(kCMIOHardwarePropertyDevices),
            mScope: CMIOObjectPropertyScope(kCMIOObjectPropertyScopeGlobal),
            mElement: CMIOObjectPropertyElement(kCMIOObjectPropertyElementMain))

        var size: UInt32 = 0
        guard CMIOObjectGetPropertyDataSize(
            CMIOObjectID(kCMIOObjectSystemObject), &address, 0, nil, &size) == noErr else { return false }

        let count = Int(size) / MemoryLayout<CMIOObjectID>.size
        guard count > 0 else { return false }

        var devices = [CMIOObjectID](repeating: 0, count: count)
        var used: UInt32 = 0
        guard CMIOObjectGetPropertyData(
            CMIOObjectID(kCMIOObjectSystemObject), &address, 0, nil, size, &used, &devices) == noErr else { return false }

        for device in devices {
            var runningAddress = CMIOObjectPropertyAddress(
                mSelector: CMIOObjectPropertySelector(kCMIODevicePropertyDeviceIsRunningSomewhere),
                mScope: CMIOObjectPropertyScope(kCMIOObjectPropertyScopeGlobal),
                mElement: CMIOObjectPropertyElement(kCMIOObjectPropertyElementMain))

            var running: UInt32 = 0
            var runningUsed: UInt32 = 0
            if CMIOObjectGetPropertyData(
                device, &runningAddress, 0, nil,
                UInt32(MemoryLayout<UInt32>.size), &runningUsed, &running) == noErr,
               running != 0 {
                return true
            }
        }
        return false
    }
}
