//
//  IdleDetector.swift
//  EyeBreak
//
//  Created on October 5, 2025.
//

import Foundation
import IOKit
import AppKit

/// Detects user idle time using IOKit
class IdleDetector {
    
    // MARK: - Properties
    
    private var timer: Timer?
    private let threshold: TimeInterval
    private var isIdle = false
    
    var onIdleStateChanged: ((Bool) -> Void)?
    
    // MARK: - Initialization
    
    init(threshold: TimeInterval = 300) { // Default 5 minutes
        self.threshold = threshold
    }
    
    deinit {
        stop()
    }
    
    // MARK: - Public Methods
    
    func start() {
        stop()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.checkIdleTime()
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Private Methods
    
    private func checkIdleTime() {
        let idleTime = getSystemIdleTime()
        let shouldBeIdle = idleTime >= threshold
        
        if shouldBeIdle != isIdle {
            isIdle = shouldBeIdle
            onIdleStateChanged?(isIdle)
        }
    }
    
    private func getSystemIdleTime() -> TimeInterval {
        var idleTime: TimeInterval = 0
        
        let service = IOServiceGetMatchingService(
            kIOMainPortDefault,
            IOServiceMatching("IOHIDSystem")
        )
        
        if service != 0 {
            let property = IORegistryEntryCreateCFProperty(
                service,
                "HIDIdleTime" as CFString,
                kCFAllocatorDefault,
                0
            )
            
            IOObjectRelease(service)
            
            if let property = property?.takeRetainedValue() {
                var idleNanos: Int64 = 0
                CFNumberGetValue(property as! CFNumber, .sInt64Type, &idleNanos)
                idleTime = TimeInterval(idleNanos) / TimeInterval(NSEC_PER_SEC)
            }
        }
        
        return idleTime
    }
}

// MARK: - Alternative Implementation Using CGEventSource

/// Backup idle detector using CGEventSource (requires accessibility permissions)
class CGEventIdleDetector {
    
    static func getIdleTime() -> TimeInterval {
        let idleTimeNanos = CGEventSource.secondsSinceLastEventType(
            .combinedSessionState,
            eventType: .mouseMoved
        )
        return TimeInterval(idleTimeNanos)
    }
}
