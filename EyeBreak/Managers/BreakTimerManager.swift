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
    private var cancellables = Set<AnyCancellable>()
    private var wasWorkingBeforePause = false
    
    // MARK: - Initialization
    
    private init() {
        setupIdleDetection()
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
        
        NotificationManager.shared.cancelAllNotifications()
    }
    
    /// Trigger an immediate break
    func takeBreakNow() {
        print("🔵 takeBreakNow() called")
        
        // Don't start a new break if already breaking
        if case .breaking = state {
            print("⚠️ Already breaking, skipping")
            return
        }
        
        stop()
        remainingSeconds = settings.breakDurationSeconds
        state = .breaking(remainingSeconds: remainingSeconds)
        print("✅ State changed to breaking, duration: \(remainingSeconds)s")
        startTimer()
        showBreakOverlay()
        print("✅ Break overlay shown")
        
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
    
    /// Pause the timer
    func pause() {
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
    
    /// Resume from paused state
    func resume() {
        guard case .paused(let wasWorking, let seconds) = state else { return }
        
        remainingSeconds = seconds
        if wasWorking {
            state = .working(remainingSeconds: remainingSeconds)
        } else {
            state = .breaking(remainingSeconds: remainingSeconds)
        }
        startTimer()
    }
    
    // MARK: - Private Methods
    
    private func startTimer() {
        timer?.invalidate()
        
        print("⏰ Starting timer - current remainingSeconds: \(remainingSeconds)")
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
        
        RunLoop.main.add(timer!, forMode: .common)
        
        print("⏰ Timer created and scheduled")
        
        // Start idle detection if enabled
        if settings.idleDetectionEnabled {
            idleDetector?.start()
        }
    }
    
    private func tick() {
        remainingSeconds -= 1
        print("⏱️ Timer tick - remainingSeconds: \(remainingSeconds), state: \(state)")
        
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
            print("⏱️ Breaking state - remainingSeconds: \(remainingSeconds)")
            if remainingSeconds <= 0 {
                print("🛑 Ending break - remainingSeconds reached 0")
                endBreak()
            } else {
                state = .breaking(remainingSeconds: remainingSeconds)
            }
            
        default:
            break
        }
    }
    
    private func startBreak() {
        remainingSeconds = settings.breakDurationSeconds
        state = .breaking(remainingSeconds: remainingSeconds)
        
        showBreakOverlay()
        
        if settings.soundEnabled {
            SoundManager.shared.playSound(.breakStart)
        }
        
        NotificationManager.shared.sendBreakStartNotification()
    }
    
    private func endBreak() {
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
            // Just notification, no overlay
            break
        }
    }
    
    // MARK: - Idle Detection Setup
    
    private func setupIdleDetection() {
        idleDetector = IdleDetector(threshold: TimeInterval(settings.idleThresholdSeconds))
        
        idleDetector?.onIdleStateChanged = { [weak self] isIdle in
            guard let self = self else { return }
            
            if isIdle && self.state.isActive {
                // User went idle, pause timer
                self.pause()
                NotificationManager.shared.sendIdlePausedNotification()
            } else if !isIdle, case .paused = self.state {
                // User returned, resume timer
                self.resume()
            }
        }
    }
    
    private func setupWorkspaceNotifications() {
        NotificationCenter.default.publisher(for: NSWorkspace.willSleepNotification)
            .sink { [weak self] _ in
                self?.pause()
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: NSWorkspace.didWakeNotification)
            .sink { [weak self] _ in
                if case .paused = self?.state {
                    self?.resume()
                }
            }
            .store(in: &cancellables)
    }
}
