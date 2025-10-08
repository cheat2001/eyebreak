//
//  AmbientReminderView.swift
//  EyeBreak
//
//  Created on October 5, 2025.
//  Redesigned with professional Apple-inspired liquid glass aesthetic
//

import SwiftUI

/// Professional ambient reminder with liquid glass design
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
    @State private var glassShimmer: Double = 0
    
    // Get the color theme from settings
    @ObservedObject private var settings = AppSettings.shared
    
    private var currentTheme: ColorTheme {
        settings.ambientReminderTheme
    }
    
    var body: some View {
        HStack(spacing: 18) {
            // Optimized: Simplified icon with minimal animation
            ZStack {
                // Optimized: Removed outer ethereal glow to reduce CPU usage
                
                // Liquid glass background circle
                ZStack {
                    // Base glass layer
                    Circle()
                        .fill(currentTheme.backgroundGradient())
                        .frame(width: 72, height: 72)
                        .overlay(
                            Circle()
                                .stroke(
                                    currentTheme.borderGradient(),
                                    lineWidth: 1
                                )
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                        .shadow(color: currentTheme.accentColor.opacity(0.2), radius: 15, x: 0, y: 0)
                    
                    // Optimized: Removed animated shimmer overlay to reduce CPU usage
                    
                    // Progress ring with refined styling
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            currentTheme.accentColor.opacity(currentTheme.accentOpacity),
                            style: StrokeStyle(lineWidth: 2.5, lineCap: .round)
                        )
                        .frame(width: 76, height: 76)
                        .rotationEffect(.degrees(-90))
                        .shadow(color: currentTheme.accentColor.opacity(0.3), radius: 4)
                        .animation(.linear(duration: 0.5), value: progress)
                }
                
                // SF Symbol icon with professional styling
                Image(systemName: reminderType.iconName)
                    .font(.system(size: 32, weight: .light, design: .rounded))
                    .foregroundStyle(currentTheme.textGradient())
                    .scaleEffect(scale)
                    .rotationEffect(.degrees(rotation))
                    .offset(y: bounce)
                    .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
                    // Optimized: Removed symbolEffect to reduce CPU usage
            }
            
            // Content section with refined typography
            VStack(alignment: .leading, spacing: 5) {
                Text(reminderType.message)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(currentTheme.textColor.opacity(currentTheme.textOpacity))
                    .tracking(0.2)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(reminderType.subtitle)
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(currentTheme.secondaryTextColor.opacity(currentTheme.secondaryTextOpacity))
                    .tracking(0.3)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            // Countdown and close controls
            VStack(spacing: 10) {
                // Minimalist countdown
                ZStack {
                    Circle()
                        .fill(currentTheme.backgroundColor.opacity(0.2))
                        .frame(width: 34, height: 34)
                        .overlay(
                            Circle()
                                .stroke(currentTheme.textColor.opacity(0.3), lineWidth: 1)
                        )
                    
                    Text("\(remainingSeconds)")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundColor(currentTheme.textColor.opacity(currentTheme.textOpacity))
                        .contentTransition(.numericText())
                }
                
                // Refined close button
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        onDismiss()
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(currentTheme.backgroundColor.opacity(0.2))
                            .frame(width: 30, height: 30)
                            .overlay(
                                Circle()
                                    .stroke(currentTheme.textColor.opacity(0.3), lineWidth: 1)
                            )
                        
                        Image(systemName: "xmark")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(currentTheme.textColor.opacity(0.9))
                    }
                }
                .buttonStyle(.plain)
                .opacity(opacity)
                .scaleEffect(1.0)
                .animation(.spring(response: 0.3), value: opacity)
            }
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 18)
        .background(
            ZStack {
                // Professional frosted glass background with enhanced depth
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(currentTheme.backgroundGradient())
                    .blur(radius: currentTheme.glassBlurRadius)
                
                // Top highlight for glass effect
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(currentTheme.glassHighlightOpacity),
                                Color.clear
                            ],
                            startPoint: .top,
                            endPoint: .center
                        )
                    )
                
                // Border with subtle gradient
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(
                        currentTheme.borderGradient(),
                        lineWidth: 1.5
                    )
            }
            .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 5)
            .shadow(color: currentTheme.accentColor.opacity(0.25), radius: 25, x: 0, y: 8)
        )
        .scaleEffect(scale)
        .opacity(opacity)
        .onAppear {
            playSound()
            startAnimations()
            startCountdown()
            // Optimized: Removed glowPulse animation
            // Optimized: Removed glassShimmer animation to reduce CPU usage
        }
        .onDisappear {
            countdownTimer?.invalidate()
            countdownTimer = nil
        }
    }
    
    private func playSound() {
        // Play the same sound as break start (Glass) for consistency
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
        
        // Smooth entrance animation
        withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) {
            scale = 1.0
            opacity = 1.0
        }
        
        // Countdown progress animation
        withAnimation(.linear(duration: duration)) {
            progress = 0.0
        }
        
        // Optimized: Removed floating animation to reduce CPU usage
        
        // Type-specific animations - simplified
        switch reminderType {
        case .lookAround:
            withAnimation(
                .linear(duration: 4.0)
                .repeatForever(autoreverses: false)
            ) {
                rotation = 360
            }
        case .lookLeft:
            rotation = -15
        case .lookRight:
            rotation = 15
        case .blink:
            // Optimized: Simplified blink animation
            withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                scale = 0.95
            }
        default:
            break
        }
    }
}

#Preview {
    AmbientReminderView(reminderType: .blink, onDismiss: {})
}
