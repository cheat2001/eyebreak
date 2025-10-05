//
//  BreakOverlayView.swift
//  EyeBreak
//
//  Created on October 5, 2025.
//

import SwiftUI

struct BreakOverlayView: View {
    let duration: Int
    let style: ScreenBlurManager.OverlayStyle
    let onSkip: () -> Void
    
    @State private var remainingSeconds: Int
    @State private var timer: Timer?
    @State private var opacity: Double = 0
    @State private var scale: CGFloat = 0.8
    @State private var eventMonitor: Any?
    @AccessibilityFocusState private var isMessageFocused: Bool
    
    init(duration: Int, style: ScreenBlurManager.OverlayStyle, onSkip: @escaping () -> Void) {
        self.duration = duration
        self.style = style
        self.onSkip = onSkip
        _remainingSeconds = State(initialValue: duration)
    }
    
    var body: some View {
        ZStack {
            // Background blur
            VisualEffectView(material: .hudWindow, blendingMode: .behindWindow)
                .ignoresSafeArea()
            
            // Dimming overlay
            Color.black.opacity(0.6)
                .ignoresSafeArea()
            
            // Content
            VStack(spacing: 40) {
                Spacer()
                
                // Main content based on style
                switch style {
                case .blur:
                    standardBreakContent
                case .exercise:
                    eyeExerciseContent
                }
                
                Spacer()
                
                // Skip hint
                skipHint
            }
            .padding(40)
            .opacity(opacity)
            .scaleEffect(scale)
        }
        .onAppear {
            startAnimation()
            startTimer()
            isMessageFocused = true
            
            // Add ESC key monitoring safely
            eventMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [onSkip] event in
                if event.keyCode == 53 { // ESC key
                    DispatchQueue.main.async {
                        onSkip()
                    }
                    return nil // Consume the event
                }
                return event
            }
        }
        .onDisappear {
            stopTimer()
            // Remove event monitor to prevent leaks
            if let monitor = eventMonitor {
                NSEvent.removeMonitor(monitor)
                eventMonitor = nil
            }
        }
        .onTapGesture {
            DispatchQueue.main.async {
                onSkip()
            }
        }
    }
    
    // MARK: - Standard Break Content
    
    private var standardBreakContent: some View {
        VStack(spacing: 32) {
            // Icon
            Image(systemName: "eye.slash.fill")
                .font(.system(size: 80))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.3), radius: 10)
            
            // Title
            Text("Time for a Break")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: 10)
                .accessibilityFocused($isMessageFocused)
            
            // Instruction
            Text("Look at something 20 feet away")
                .font(.system(size: 24, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .shadow(color: .black.opacity(0.3), radius: 5)
            
            // Timer display
            timerDisplay
        }
    }
    
    // MARK: - Eye Exercise Content
    
    private var eyeExerciseContent: some View {
        VStack(spacing: 32) {
            // Icon
            Image(systemName: "figure.walk")
                .font(.system(size: 80))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.3), radius: 10)
            
            // Title
            Text("Eye Exercise")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: 10)
                .accessibilityFocused($isMessageFocused)
            
            // Exercise instructions
            VStack(spacing: 20) {
                ExerciseStep(number: 1, text: "Blink slowly 10 times")
                ExerciseStep(number: 2, text: "Roll your eyes clockwise, then counterclockwise")
                ExerciseStep(number: 3, text: "Focus on something far away")
                ExerciseStep(number: 4, text: "Look up, down, left, and right")
            }
            .padding(24)
            .background(Color.white.opacity(0.1))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.3), radius: 10)
            
            // Timer display
            timerDisplay
        }
    }
    
    // MARK: - Timer Display
    
    private var timerDisplay: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(Color.white.opacity(0.3), lineWidth: 8)
                .frame(width: 120, height: 120)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.white,
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .frame(width: 120, height: 120)
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1), value: progress)
            
            // Countdown text
            Text("\(remainingSeconds)")
                .font(.system(size: 48, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
        }
        .shadow(color: .black.opacity(0.3), radius: 10)
    }
    
    // MARK: - Skip Hint
    
    private var skipHint: some View {
        VStack(spacing: 12) {
            Text("Press ESC or click anywhere to skip")
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(.white.opacity(0.6))
            
            Text("(Not recommended—your eyes need this!)")
                .font(.system(size: 12, design: .rounded))
                .foregroundColor(.white.opacity(0.4))
        }
    }
    
    // MARK: - Computed Properties
    
    private var progress: CGFloat {
        CGFloat(remainingSeconds) / CGFloat(duration)
    }
    
    // MARK: - Methods
    
    private func startAnimation() {
        withAnimation(.easeOut(duration: 0.3)) {
            opacity = 1
            scale = 1
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if remainingSeconds > 0 {
                remainingSeconds -= 1
            } else {
                stopTimer()
                onSkip()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - Exercise Step Component

struct ExerciseStep: View {
    let number: Int
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Text("\(number)")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Color.white.opacity(0.2))
                .clipShape(Circle())
            
            Text(text)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - Visual Effect View (for blur)

struct VisualEffectView: NSViewRepresentable {
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
