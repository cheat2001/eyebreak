 //
//  LaunchAtLoginManager.swift
//  EyeBreak
//
//  Created on October 25, 2025.
//

import Foundation
import ServiceManagement

/// Manager for handling launch at login functionality using SMAppService
class LaunchAtLoginManager {
    
    // MARK: - Singleton
    
    static let shared = LaunchAtLoginManager()
    
    private init() {}
    
    // MARK: - Properties
    
    /// The app service identifier for launch at login
    private var appService: SMAppService {
        return SMAppService.mainApp
    }
    
    // MARK: - Public Methods
    
    /// Check if launch at login is currently enabled
    var isEnabled: Bool {
        return appService.status == .enabled
    }
    
    /// Enable or disable launch at login
    /// - Parameter enabled: Whether to enable or disable launch at login
    /// - Returns: Success or failure
    @discardableResult
    func setEnabled(_ enabled: Bool) -> Bool {
        do {
            if enabled {
                // Register the app to launch at login
                if appService.status == .enabled {
                    print("✅ Launch at login already enabled")
                    return true
                }
                
                try appService.register()
                print("✅ Launch at login enabled successfully")
                return true
            } else {
                // Unregister the app from launch at login
                if appService.status == .notRegistered {
                    print("✅ Launch at login already disabled")
                    return true
                }
                
                try appService.unregister()
                print("✅ Launch at login disabled successfully")
                return true
            }
        } catch {
            print("❌ Failed to \(enabled ? "enable" : "disable") launch at login: \(error.localizedDescription)")
            return false
        }
    }
    
    /// Get the current status of the app service
    var statusDescription: String {
        switch appService.status {
        case .notRegistered:
            return "Not registered"
        case .enabled:
            return "Enabled"
        case .requiresApproval:
            return "Requires approval in System Settings"
        case .notFound:
            return "Service not found"
        @unknown default:
            return "Unknown status"
        }
    }
    
    /// Check if the service requires user approval
    var requiresApproval: Bool {
        return appService.status == .requiresApproval
    }
    
    /// Sync the app service status with the user settings
    /// - Parameter settings: The app settings to sync with
    func syncWithSettings(_ settings: AppSettings) {
        let shouldBeEnabled = settings.launchAtLogin
        let isCurrentlyEnabled = isEnabled
        
        // Only make changes if there's a mismatch
        if shouldBeEnabled != isCurrentlyEnabled {
            let success = setEnabled(shouldBeEnabled)
            
            // If the operation failed, update the settings to reflect reality
            if !success {
                settings.launchAtLogin = isCurrentlyEnabled
            }
        }
    }
}
