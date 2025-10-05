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
    
    var body: some View {
        HStack(spacing: 16) {
            // Animated emoji
            Text(reminderType.emoji)
                .font(.system(size: 50))
                .scaleEffect(scale)
                .rotationEffect(.degrees(rotation))
                .offset(y: bounce)
            
            // Message
            Text(reminderType.message)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
            
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
        }
    }
    
    private func playSound() {
        // Play system sound for notification
        NSSound(named: "Glass")?.play()
    }
    
    private func startAnimations() {
        // Initial pop-in animation
        withAnimation(.spring(response: 0.5, dampingFraction: 0.65)) {
            scale = 1.0
            opacity = 1.0
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
