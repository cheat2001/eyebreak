//
//  NotificationManager.swift
//  EyeBreak
//
//  Created on October 5, 2025.
//

import Foundation
import UserNotifications

/// Manages local notifications
class NotificationManager: NSObject {
    
    static let shared = NotificationManager()
    
    private let center = UNUserNotificationCenter.current()
    
    override private init() {
        super.init()
        center.delegate = self
    }
    
    // MARK: - Authorization
    
    func requestAuthorization() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("❌ Notification authorization error: \(error)")
            }
            
            if granted {
                print("✅ Notification permission granted")
            } else {
                print("⚠️ Notification permission denied - floating window will be used instead")
            }
        }
    }
    
    /// Check if notifications are authorized
    func checkAuthorizationStatus(completion: @escaping (Bool) -> Void) {
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }
    
    // MARK: - Notification Methods
    
    func sendPreBreakNotification(seconds: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Break Time Soon"
        content.body = "Wrap up your work—break starting in \(seconds) seconds! 🌟"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "preBreak",
            content: content,
            trigger: nil
        )
        
        center.add(request) { error in
            if let error = error {
                print("Error sending pre-break notification: \(error)")
            }
        }
    }
    
    func sendBreakStartNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Time for a Break!"
        content.body = "Look away! Stare at something 20 feet away for 20 seconds. Your eyes will thank you. 👁️"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "breakStart",
            content: content,
            trigger: nil
        )
        
        center.add(request) { error in
            if let error = error {
                print("Error sending break start notification: \(error)")
            }
        }
    }
    
    func sendBreakCompleteNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Great Job!"
        content.body = "Break complete! Back to work. 💪"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "breakComplete",
            content: content,
            trigger: nil
        )
        
        center.add(request) { error in
            if let error = error {
                print("Error sending break complete notification: \(error)")
            }
        }
    }
    
    func sendIdlePausedNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Timer Paused"
        content.body = "You seem to be away. Timer paused—come back when you're ready! 😴"
        content.sound = nil
        
        let request = UNNotificationRequest(
            identifier: "idlePaused",
            content: content,
            trigger: nil
        )
        
        center.add(request) { error in
            if let error = error {
                print("Error sending idle paused notification: \(error)")
            }
        }
    }
    
    func cancelAllNotifications() {
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationManager: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Show notification even when app is in foreground
        completionHandler([.banner, .sound])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // Handle notification tap if needed
        completionHandler()
    }
}
