//
//  BreakTimerManager.swift
//  EyeBreak
//
//  Created on October 5, 2025.
//

import Foundation
import Combine
import AppKit

/// Manages the core timer logic for work/break cycles
class BreakTimerManager: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = BreakTimerManager()
    
    // MARK: - Published Properties
    
    @Published var state: TimerState = .idle
    @Published var settings = AppSettings.shared
    
    // MARK: - Private Properties
    
    private var timer: Timer?
    private var remainingSeconds: Int = 0
    private var idleDetector: IdleDetector?
    private var meetingDetector: MeetingDetector?

    /// Every reason the timer is currently paused for. The timer only resumes
    /// once this is empty, so overlapping sources cannot resume on each other's
    /// behalf (see PauseReason).
    private(set) var pauseReasons: Set<PauseReason> = []
    private var cancellables = Set<AnyCancellable>()
    private var wasWorkingBeforePause = false
    private var isForcedBreak = false // Flag to bypass Smart Schedule during forced breaks
    
    // MARK: - Initialization
    
    private init() {
        setupIdleDetection()
        setupMeetingDetection()
        setupWorkspaceNotifications()
    }
    
    deinit {
        stop()
    }
    
    // MARK: - Public Methods
    
    /// Start the timer from idle state
    func start() {
        guard state == .idle else { return }
        
        remainingSeconds = settings.workIntervalSeconds
        state = .working(remainingSeconds: remainingSeconds)
        startTimer()
        
        if settings.soundEnabled {
            SoundManager.shared.playSound(.start)
        }
    }
    
    /// Stop the timer and return to idle
    func stop() {
        timer?.invalidate()
        timer = nil
        state = .idle
        idleDetector?.stop()
        meetingDetector?.stop()
        pauseReasons.removeAll()
        
        NotificationManager.shared.cancelAllNotifications()
    }
    
    /// Trigger an immediate break
    func takeBreakNow() {
        // Don't start a new break if already breaking
        if case .breaking = state {
            return
        }
        
        // Check if Smart Schedule allows breaks now
        if settings.smartScheduleEnabled && !settings.shouldShowBreaksNow {
            showOutsideWorkHoursAlert()
            return
        }
        
        stop()
        remainingSeconds = settings.breakDurationSeconds
        state = .breaking(remainingSeconds: remainingSeconds)
        startTimer()
        showBreakOverlay()
        
        if settings.soundEnabled {
            SoundManager.shared.playSound(.breakStart)
        }
    }
    
    /// Force a break even if outside work hours (from alert "Take Break Anyway")
    func forceBreakNow() {
        // Don't start a new break if already breaking
        if case .breaking = state {
            return
        }
        
        // Set flag to bypass Smart Schedule checks during this break
        isForcedBreak = true
        
        stop()
        remainingSeconds = settings.breakDurationSeconds
        state = .breaking(remainingSeconds: remainingSeconds)
        startTimer()
        showBreakOverlay()
        
        if settings.soundEnabled {
            SoundManager.shared.playSound(.breakStart)
        }
    }
    
    /// Skip the current break (discouraged!)
    func skipBreak() {
        guard case .breaking = state else { return }
        
        settings.updateStats(breaksSkipped: 1)
        endBreak()
        
        if settings.soundEnabled {
            SoundManager.shared.playSound(.skip)
        }
    }
    
    /// Pause the timer, recording why.
    ///
    /// Safe to call repeatedly and while already paused: the reason is simply
    /// added to the set. That matters because sources overlap — going idle
    /// during a meeting must not discard the meeting reason.
    func pause(reason: PauseReason = .manual) {
        pauseReasons.insert(reason)

        guard state.isActive else { return }

        let wasWorking: Bool
        switch state {
        case .working, .preBreak:
            wasWorking = true
        case .breaking:
            wasWorking = false
        default:
            wasWorking = true
        }

        timer?.invalidate()
        timer = nil
        state = .paused(wasWorking: wasWorking, remainingSeconds: remainingSeconds)
        wasWorkingBeforePause = wasWorking
    }

    /// Clear one reason. The timer resumes only when no reasons remain, so
    /// unlocking the screen cannot restart the timer while a meeting is still
    /// in progress.
    func resume(reason: PauseReason = .manual) {
        pauseReasons.remove(reason)

        // A manual Resume is an explicit instruction, so it also clears any
        // automatic reason that is no longer true. Reasons that still hold
        // will re-assert themselves on the next poll.
        if reason == .manual {
            pauseReasons.removeAll()
        }

        guard pauseReasons.isEmpty else { return }
        guard case .paused(let wasWorking, let seconds) = state else { return }

        remainingSeconds = seconds
        if wasWorking {
            state = .working(remainingSeconds: remainingSeconds)
        } else {
            state = .breaking(remainingSeconds: remainingSeconds)
        }
        startTimer()
    }

    /// The most relevant reason to show the user, when paused for several.
    var primaryPauseReason: PauseReason? {
        for reason in [PauseReason.meeting, .manual, .screenLocked, .screenSaver, .systemSleep, .idle]
        where pauseReasons.contains(reason) {
            return reason
        }
        return pauseReasons.first
    }
    
    // MARK: - Private Methods
    
    private func startTimer() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
        
        // Optimize: Use default run loop mode instead of common to reduce CPU usage
        // This prevents timer from firing during UI interactions
        if let timer = timer {
            RunLoop.main.add(timer, forMode: .default)
        }
        
        // Start idle detection if enabled
        if settings.idleDetectionEnabled {
            idleDetector?.start()
        }

        syncMeetingDetection()
    }
    
    private func tick() {
        remainingSeconds -= 1
        
        // Check smart schedule - pause if outside work hours (UNLESS it's a forced break)
        if !isForcedBreak && !settings.shouldShowBreaksNow {
            if state.isActive && state != .paused(wasWorking: wasWorkingBeforePause, remainingSeconds: remainingSeconds) {
                pause()
                return
            }
        }
        
        switch state {
        case .working(let seconds):
            if remainingSeconds <= settings.preBreakWarningSeconds && seconds > settings.preBreakWarningSeconds {
                // Transition to pre-break warning
                state = .preBreak(remainingSeconds: remainingSeconds)
                NotificationManager.shared.sendPreBreakNotification(seconds: remainingSeconds)
            } else if remainingSeconds <= 0 {
                // Start break
                startBreak()
            } else {
                state = .working(remainingSeconds: remainingSeconds)
            }
            
        case .preBreak:
            if remainingSeconds <= 0 {
                startBreak()
            } else {
                state = .preBreak(remainingSeconds: remainingSeconds)
            }
            
        case .breaking:
            if remainingSeconds <= 0 {
                endBreak()
            } else {
                state = .breaking(remainingSeconds: remainingSeconds)
            }
            
        default:
            break
        }
    }
    
    private func startBreak() {
        // Check if Smart Schedule allows breaks now
        if settings.smartScheduleEnabled && !settings.shouldShowBreaksNow {
            // Skip to next work session instead of showing break
            remainingSeconds = settings.workIntervalSeconds
            state = .working(remainingSeconds: remainingSeconds)
            return
        }
        
        remainingSeconds = settings.breakDurationSeconds
        state = .breaking(remainingSeconds: remainingSeconds)
        
        showBreakOverlay()
        
        if settings.soundEnabled {
            SoundManager.shared.playSound(.breakStart)
        }
        
        NotificationManager.shared.sendBreakStartNotification()
    }
    
    private func endBreak() {
        // Reset forced break flag
        isForcedBreak = false
        
        // Update statistics
        settings.updateStats(breaksCompleted: 1, breakTime: settings.breakDurationSeconds)
        
        ScreenBlurManager.shared.hideOverlay()
        
        // Start next work session
        remainingSeconds = settings.workIntervalSeconds
        state = .working(remainingSeconds: remainingSeconds)
        
        if settings.soundEnabled {
            SoundManager.shared.playSound(.breakEnd)
        }
        
        NotificationManager.shared.sendBreakCompleteNotification()
    }
    
    private func showBreakOverlay() {
        switch settings.breakStyle {
        case .blurScreen:
            ScreenBlurManager.shared.showBreakOverlay(
                duration: settings.breakDurationSeconds,
                style: .blur
            ) { [weak self] in
                self?.skipBreak()
            }
        case .eyeExercise:
            ScreenBlurManager.shared.showBreakOverlay(
                duration: settings.breakDurationSeconds,
                style: .exercise
            ) { [weak self] in
                self?.skipBreak()
            }
        case .notificationOnly:
            // Show floating window instead of notification only
            let window = FloatingBreakWindow()
            window.show(
                duration: settings.breakDurationSeconds,
                onSkip: { [weak self] in
                    self?.skipBreak()
                },
                onComplete: { [weak self] in
                    self?.endBreak()
                }
            )
        }
    }
    
    // MARK: - Idle Detection Setup
    
    private func setupIdleDetection() {
        idleDetector = IdleDetector(threshold: TimeInterval(settings.idleThresholdSeconds))
        
        idleDetector?.onIdleStateChanged = { [weak self] isIdle in
            guard let self = self else { return }
            
            if isIdle && self.state.isActive {
                // User went idle, pause timer
                self.pause(reason: .idle)
                NotificationManager.shared.sendIdlePausedNotification()
            } else if !isIdle {
                // User returned; only lifts the idle reason
                self.resume(reason: .idle)
            }
        }
    }
    
    // MARK: - Meeting Detection Setup

    private func setupMeetingDetection() {
        meetingDetector = MeetingDetector()
        meetingDetector?.onMeetingStateChanged = { [weak self] isInMeeting in
            guard let self else { return }
            if isInMeeting {
                self.pause(reason: .meeting)
            } else {
                self.resume(reason: .meeting)
            }
        }
    }

    /// Starts or stops meeting detection to match the current setting. Called
    /// when the timer starts and whenever the setting is toggled, so enabling it
    /// mid-session takes effect immediately.
    func syncMeetingDetection() {
        guard let detector = meetingDetector else { return }
        if settings.pauseDuringMeetings {
            if !detector.isRunning { detector.start() }
        } else if detector.isRunning {
            detector.stop()
        }
    }

    // MARK: - Screen Lock and Sleep Handling
    
    /// Sets up system notifications to automatically pause/resume timer during sleep and screen lock
    private func setupWorkspaceNotifications() {
        // Mac sleep events
        NotificationCenter.default.publisher(for: NSWorkspace.willSleepNotification)
            .sink { [weak self] _ in
                self?.pause(reason: .systemSleep)
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: NSWorkspace.didWakeNotification)
            .sink { [weak self] _ in
                self?.resume(reason: .systemSleep)
            }
            .store(in: &cancellables)
        
        // Screen lock events
        let notificationCenter = DistributedNotificationCenter.default()
        
        notificationCenter.addObserver(
            forName: NSNotification.Name("com.apple.screenIsLocked"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.pause(reason: .screenLocked)
        }
        
        notificationCenter.addObserver(
            forName: NSNotification.Name("com.apple.screenIsUnlocked"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.resume(reason: .screenLocked)
        }
        
        // Screen saver events (treated same as screen lock)
        notificationCenter.addObserver(
            forName: NSNotification.Name("com.apple.screensaver.didstart"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.pause(reason: .screenSaver)
        }
        
        notificationCenter.addObserver(
            forName: NSNotification.Name("com.apple.screensaver.didstop"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.resume(reason: .screenSaver)
        }
    }
    
    // MARK: - Smart Schedule Alert
    
    private func showOutsideWorkHoursAlert() {
        let alert = NSAlert()
        alert.messageText = "Outside Work Hours"
        alert.informativeText = "Your Smart Schedule is active and breaks are currently paused.\n\nWork Hours: \(settings.timeString(from: settings.workHoursStart)) - \(settings.timeString(from: settings.workHoursEnd))\n\nWould you like to take a break anyway or adjust your schedule?"
        alert.alertStyle = .informational
        alert.icon = NSImage(systemSymbolName: "clock.badge.exclamationmark", accessibilityDescription: "Schedule")
        
        alert.addButton(withTitle: "Take Break Anyway")
        alert.addButton(withTitle: "Open Settings")
        alert.addButton(withTitle: "Cancel")
        
        let response = alert.runModal()
        
        switch response {
        case .alertFirstButtonReturn:
            // Take break anyway - use forceBreakNow method
            forceBreakNow()
        case .alertSecondButtonReturn:
            // Open settings
            NotificationCenter.default.post(name: NSNotification.Name("OpenSettings"), object: nil)
        default:
            break
        }
    }
}
