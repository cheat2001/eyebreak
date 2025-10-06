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
    @State private var glowPulse: Bool = false
    @State private var shimmer: Bool = false
    
    var body: some View {
        HStack(spacing: 20) {
            // Enhanced animated emoji with multi-ring progress
            ZStack {
                // Outer glow ring
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [reminderType.color.opacity(0.3), Color.clear],
                            center: .center,
                            startRadius: 20,
                            endRadius: 45
                        )
                    )
                    .frame(width: 90, height: 90)
                    .scaleEffect(glowPulse ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: glowPulse)
                
                // Background ring with gradient
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [reminderType.color.opacity(0.3), reminderType.color.opacity(0.15)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 68, height: 68)
                
                // Animated progress ring with gradient
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        AngularGradient(
                            colors: [
                                reminderType.color.opacity(0.8),
                                reminderType.color,
                                reminderType.secondaryColor,
                                reminderType.color.opacity(0.8)
                            ],
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 68, height: 68)
                    .rotationEffect(.degrees(-90))
                    .shadow(color: reminderType.color.opacity(0.5), radius: 4)
                    .animation(.linear(duration: 0.5), value: progress)
                
                // Inner circle background
                Circle()
                    .fill(reminderType.color.opacity(0.2))
                    .frame(width: 56, height: 56)
                
                // Emoji in center with enhanced animation
                Text(reminderType.emoji)
                    .font(.system(size: 40))
                    .scaleEffect(scale)
                    .rotationEffect(.degrees(rotation))
                    .offset(y: bounce)
                    .shadow(color: .black.opacity(0.1), radius: 2)
            }
            
            // Message section with better typography
            VStack(alignment: .leading, spacing: 6) {
                Text(reminderType.message)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .white.opacity(0.95)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .black.opacity(0.2), radius: 1, y: 1)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(reminderType.subtitle)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            VStack(spacing: 8) {
                // Enhanced countdown display
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 36, height: 36)
                    
                    Text("\(remainingSeconds)")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .contentTransition(.numericText())
                }
                
                // Close button with better design
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        onDismiss()
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.25))
                            .frame(width: 28, height: 28)
                        
                        Image(systemName: "xmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .buttonStyle(.plain)
                .opacity(opacity)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .background(
            ZStack {
                // Animated gradient background
                RoundedRectangle(cornerRadius: 32)
                    .fill(
                        LinearGradient(
                            colors: [
                                reminderType.color,
                                reminderType.secondaryColor,
                                reminderType.color.opacity(0.9)
                            ],
                            startPoint: shimmer ? .topLeading : .bottomLeading,
                            endPoint: shimmer ? .bottomTrailing : .topTrailing
                        )
                    )
                    .animation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true), value: shimmer)
                
                // Glossy overlay
                RoundedRectangle(cornerRadius: 32)
                    .fill(
                        LinearGradient(
                            colors: [.white.opacity(0.2), .clear],
                            startPoint: .topLeading,
                            endPoint: .center
                        )
                    )
                
                // Border glow
                RoundedRectangle(cornerRadius: 32)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.4), .white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            }
            .shadow(color: reminderType.color.opacity(0.4), radius: 20, y: 8)
            .shadow(color: .black.opacity(0.15), radius: 5, y: 2)
        )
        .scaleEffect(scale)
        .opacity(opacity)
        .onAppear {
            playSound()
            startAnimations()
            startCountdown()
            glowPulse = true
            shimmer = true
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
