//
//  StatusBarController.swift
//  EyeBreak
//
//  Created on October 5, 2025.
//

import AppKit
import SwiftUI

class StatusBarController: ObservableObject {
    private var statusItem: NSStatusItem?
    private var popover: NSPopover?
    
    init() {
        setupStatusBar()
    }
    
    private func setupStatusBar() {
        // Create status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "eye.fill", accessibilityDescription: "EyeBreak")
            button.action = #selector(statusBarButtonClicked)
            button.target = self
        }
        
        // Create popover
        popover = NSPopover()
        popover?.contentSize = NSSize(width: 300, height: 400)
        popover?.behavior = .transient
    }
    
    @objc private func statusBarButtonClicked(_ sender: NSStatusBarButton) {
        guard let popover = popover else { return }
        
        if popover.isShown {
            popover.performClose(sender)
        } else {
            // Show popover below status bar button
            popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .minY)
        }
    }
    
    func setContentView(_ view: AnyView) {
        let hostingController = NSHostingController(rootView: view)
        popover?.contentViewController = hostingController
    }
    
    func updateIcon(breaking: Bool) {
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: breaking ? "eye.fill" : "eye", accessibilityDescription: "EyeBreak")
        }
    }
}
