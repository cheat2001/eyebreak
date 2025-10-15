//
//  FloatingBreakWindow.swift
//  EyeBreak
//
//  Created on October 14, 2025.
//

import SwiftUI
import AppKit

/// A small, elegant floating window that appears during "Notification Only" breaks
class FloatingBreakWindow: NSWindow {
    
    static var shared: FloatingBreakWindow?
    
    init() {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 340, height: 280),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        
        self.isOpaque = false
        self.backgroundColor = .clear
        self.level = .floating
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        self.hasShadow = true
        self.isMovableByWindowBackground = true
        
        // Position in bottom-right corner with padding
        if let screen = NSScreen.main {
            let screenFrame = screen.visibleFrame
            let x = screenFrame.maxX - 360  // 20px padding (340 + 20)
            let y = screenFrame.minY + 40   // 40px from bottom for better visibility
            self.setFrameOrigin(NSPoint(x: x, y: y))
        }
    }
    
    func show(duration: Int, onSkip: @escaping () -> Void, onComplete: @escaping () -> Void) {
        let contentView = FloatingBreakContentView(
            duration: duration,
            onSkip: onSkip,
            onComplete: onComplete,
            window: self
        )
        
        self.contentView = NSHostingView(rootView: contentView)
        self.makeKeyAndOrderFront(nil)
        
        // Play notification sound
        NSSound.beep()
        
        // Animate in
        self.alphaValue = 0
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.3
            self.animator().alphaValue = 1
        })
        
        FloatingBreakWindow.shared = self
    }
    
    func hide() {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.3
            self.animator().alphaValue = 0
        }, completionHandler: {
            self.orderOut(nil)
            FloatingBreakWindow.shared = nil
        })
    }
    
    // Prevent window from becoming key (so it doesn't steal focus)
    override var canBecomeKey: Bool { false }
    override var canBecomeMain: Bool { false }
}

// MARK: - Content View

struct FloatingBreakContentView: View {
    let duration: Int
    let onSkip: () -> Void
    let onComplete: () -> Void
    weak var window: FloatingBreakWindow?
    
    @State private var remainingSeconds: Int
    @State private var timer: Timer?
    @State private var progress: Double = 1.0
    @State private var isHovered: Bool = false
    
    init(duration: Int, onSkip: @escaping () -> Void, onComplete: @escaping () -> Void, window: FloatingBreakWindow?) {
        self.duration = duration
        self.onSkip = onSkip
        self.onComplete = onComplete
        self.window = window
        self._remainingSeconds = State(initialValue: duration)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with close button
            HStack {
                // App indicator
                HStack(spacing: 8) {
                    Image(systemName: "eye.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.blue)
                    
                    Text("EyeBreak")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Subtle close button
                Button(action: handleSkip) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                        .frame(width: 20, height: 20)
                        .background(Color.secondary.opacity(0.1))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                .opacity(isHovered ? 1 : 0.6)
                .help("Close (or press ESC)")
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 8)
            
            Divider()
                .opacity(0.3)
            
            // Main content with better spacing
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text("Take a Break")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text("Look 20 feet away for 20 seconds")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 8)
                
                // Circular progress timer - larger and more prominent
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.15), lineWidth: 6)
                        .frame(width: 100, height: 100)
                    
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            LinearGradient(
                                colors: [.blue, .cyan],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 1), value: progress)
                    
                    VStack(spacing: 2) {
                        Text("\(remainingSeconds)")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        Text("seconds")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
                
                // Subtle skip button
                Button(action: handleSkip) {
                    Text("Skip Break")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.blue)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 20)
                        .background(Color.blue.opacity(0.08))
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .help("Skip this break")
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(width: 340, height: 280)
        .background(
            ZStack {
                // Background with blur effect
                FloatingWindowBlurView(material: .hudWindow, blendingMode: .behindWindow)
                
                // Subtle border for definition
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.15), lineWidth: 1)
            }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        )
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
        .onAppear(perform: startTimer)
        .onDisappear(perform: stopTimer)
        .onHover { hovering in
            isHovered = hovering
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if remainingSeconds > 0 {
                remainingSeconds -= 1
                progress = Double(remainingSeconds) / Double(duration)
            } else {
                stopTimer()
                window?.hide()
                onComplete()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func handleSkip() {
        print("🔵 FloatingBreakWindow: Skip button clicked!")
        stopTimer()
        window?.hide()
        onSkip()
    }
}

// MARK: - Floating Window Blur View (for macOS blur)

struct FloatingWindowBlurView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}
