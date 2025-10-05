//
//  AmbientReminderView.swift
//  EyeBreak
//
//  Created on October 5, 2025.
//

import SwiftUI

/// Cute animated reminder that pops up while working
struct AmbientReminderView: View {
    let reminderType: ReminderType
    let onDismiss: () -> Void
    
    @State private var scale: CGFloat = 0.1
    @State private var opacity: Double = 0
    @State private var rotation: Double = 0
    @State private var bounce: CGFloat = 0
    @State private var progress: Double = 1.0  // Countdown progress (1.0 to 0.0)
    @State private var remainingSeconds: Int = 8  // Countdown number display
    @State private var countdownTimer: Timer?
    
    var body: some View {
        HStack(spacing: 16) {
            // Animated emoji with circular progress ring
            ZStack {
                // Progress ring background
                Circle()
                    .stroke(
                        reminderType.color.opacity(0.3),
                        style: StrokeStyle(lineWidth: 3, lineCap: .round)
                    )
                    .frame(width: 64, height: 64)
                
                // Progress ring foreground (animated countdown)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        reminderType.color,
                        style: StrokeStyle(lineWidth: 3, lineCap: .round)
                    )
                    .frame(width: 64, height: 64)
                    .rotationEffect(.degrees(-90))  // Start from top
                    .animation(.linear(duration: 0.5), value: progress)
                
                // Emoji in center
                Text(reminderType.emoji)
                    .font(.system(size: 36))
                    .scaleEffect(scale)
                    .rotationEffect(.degrees(rotation))
                    .offset(y: bounce)
            }
            
            // Message
            Text(reminderType.message)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
            
            Spacer()
            
            // Countdown seconds display
            Text("\(remainingSeconds)s")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(.white.opacity(0.2))
                )
            
            // Close button (X)
            Button(action: onDismiss) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(.white.opacity(0.6))
            }
            .buttonStyle(.plain)
            .opacity(opacity)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(
            Capsule()
                .fill(reminderType.color.gradient)
                .shadow(color: reminderType.color.opacity(0.4), radius: 15, y: 5)
        )
        .scaleEffect(scale)
        .opacity(opacity)
        .onAppear {
            playSound()
            startAnimations()
            startCountdown()
        }
        .onDisappear {
            countdownTimer?.invalidate()
            countdownTimer = nil
        }
    }
    
    private func playSound() {
        // Play system sound for notification
        NSSound(named: "Glass")?.play()
    }
    
    private func startCountdown() {
        // Initialize remaining seconds from settings
        remainingSeconds = AppSettings.shared.ambientReminderDurationSeconds
        
        // Start countdown timer (update every second)
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] _ in
            if remainingSeconds > 0 {
                remainingSeconds -= 1
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
            }
        }
    }
    
    private func startAnimations() {
        // Get duration from settings
        let duration = TimeInterval(AppSettings.shared.ambientReminderDurationSeconds)
        
        // Initial pop-in animation
        withAnimation(.spring(response: 0.5, dampingFraction: 0.65)) {
            scale = 1.0
            opacity = 1.0
        }
        
        // Start countdown progress animation
        withAnimation(.linear(duration: duration)) {
            progress = 0.0
        }
        
        // Continuous bounce animation for emoji
        withAnimation(
            .easeInOut(duration: 0.8)
            .repeatForever(autoreverses: true)
        ) {
            bounce = -8
        }
        
        // Rotation animation for some emojis
        if reminderType == .lookAround {
            withAnimation(
                .linear(duration: 2.0)
                .repeatForever(autoreverses: false)
            ) {
                rotation = 360
            }
        } else if reminderType == .lookLeft {
            withAnimation(
                .easeInOut(duration: 1.0)
                .repeatForever(autoreverses: true)
            ) {
                rotation = -15
            }
        } else if reminderType == .lookRight {
            withAnimation(
                .easeInOut(duration: 1.0)
                .repeatForever(autoreverses: true)
            ) {
                rotation = 15
            }
        } else if reminderType == .blink {
            // Simulate blinking with scale
            Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { _ in
                withAnimation(.easeInOut(duration: 0.15)) {
                    scale = 0.85
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        scale = 1.0
                    }
                }
            }
        }
    }
}

#Preview {
    AmbientReminderView(reminderType: .blink, onDismiss: {})
}
