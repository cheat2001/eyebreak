//
//  MenuBarView.swift
//  EyeBreak
//
//  Created on October 5, 2025.
//

import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject var timerManager: BreakTimerManager
    @EnvironmentObject var settings: AppSettings
    @Environment(\.openWindow) var openWindow
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerSection
            
            Divider()
            
            // Status
            statusSection
                .padding()
            
            Divider()
            
            // Controls
            controlsSection
                .padding()
            
            Divider()
            
            // Quick Stats
            quickStatsSection
                .padding()
            
            Divider()
            
            // Bottom Actions
            bottomActionsSection
        }
        .frame(width: 300)
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        HStack {
            ZStack {
                // Optimized: Simplified background circle without animation
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.3), Color.cyan.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                
                // Eye icon - removed heavy animation
                Image(systemName: timerManager.state.isActive ? "eye.fill" : "eye")
                    .font(.title2)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .cyan],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("EyeBreak")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(statusText)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .transition(.opacity.combined(with: .scale))
            }
            
            Spacer()
            
            statusIndicator
        }
        .padding()
    }
    
    private var statusText: String {
        switch timerManager.state {
        case .idle: return "Ready to start"
        case .working: return "Working"
        case .preBreak: return "Break soon"
        case .breaking: return "On break"
        case .paused: return "Paused"
        }
    }
    
    private var statusIndicator: some View {
        ZStack {
            // Optimized: Simplified pulse rings - reduced animation complexity
            Circle()
                .fill(timerManager.state.isActive ? Color.green.opacity(0.3) : Color.clear)
                .frame(width: 16, height: 16)
            
            // Core indicator with gradient
            Circle()
                .fill(
                    LinearGradient(
                        colors: timerManager.state.isActive ? 
                            [Color.green, Color.green.opacity(0.8)] : 
                            [Color.gray, Color.gray.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 8, height: 8)
                .shadow(color: timerManager.state.isActive ? .green.opacity(0.5) : .clear, radius: 4)
        }
        .animation(.easeInOut(duration: 0.3), value: timerManager.state.isActive)
    }
    
    // MARK: - Status Section
    
    private var statusSection: some View {
        VStack(spacing: 12) {
            Text(timerManager.state.displayText)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.secondary)
                .animation(.easeInOut, value: timerManager.state)
            
            if case .working(let seconds) = timerManager.state {
                VStack(spacing: 12) {
                    // Progress ring with gradient
                    ZStack {
                        Circle()
                            .stroke(Color.blue.opacity(0.2), lineWidth: 6)
                            .frame(width: 100, height: 100)
                        
                        Circle()
                            .trim(from: 0, to: progressValue)
                            .stroke(
                                AngularGradient(
                                    colors: [.blue, .cyan, .blue],
                                    center: .center
                                ),
                                style: StrokeStyle(lineWidth: 6, lineCap: .round)
                            )
                            .frame(width: 100, height: 100)
                            .rotationEffect(.degrees(-90))
                            .animation(.linear(duration: 1), value: progressValue)
                        
                        // Time display
                        VStack(spacing: 4) {
                            Text(formatTime(seconds))
                                .font(.system(.title2, design: .monospaced))
                                .fontWeight(.bold)
                                .contentTransition(.numericText())
                            
                            Text("remaining")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Mini progress bar
                    ProgressView(value: progressValue, total: 1.0)
                        .tint(.blue)
                        .scaleEffect(y: 0.5)
                }
                .transition(.scale.combined(with: .opacity))
                
            } else if case .breaking(let seconds) = timerManager.state {
                VStack(spacing: 12) {
                    // Animated break indicator
                    ZStack {
                        Circle()
                            .stroke(Color.green.opacity(0.2), lineWidth: 6)
                            .frame(width: 100, height: 100)
                        
                        Circle()
                            .trim(from: 0, to: progressValue)
                            .stroke(
                                AngularGradient(
                                    colors: [.green, .mint, .green],
                                    center: .center
                                ),
                                style: StrokeStyle(lineWidth: 6, lineCap: .round)
                            )
                            .frame(width: 100, height: 100)
                            .rotationEffect(.degrees(-90))
                            .animation(.linear(duration: 1), value: progressValue)
                        
                        VStack(spacing: 4) {
                            Text("\(seconds)")
                                .font(.system(.title, design: .monospaced))
                                .fontWeight(.bold)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.green, .mint],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .contentTransition(.numericText())
                            
                            Text("seconds")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Text("👁️ Rest your eyes")
                        .font(.caption)
                        .foregroundColor(.green)
                        .transition(.scale.combined(with: .opacity))
                }
                .transition(.scale.combined(with: .opacity))
                
            } else if case .preBreak(let seconds) = timerManager.state {
                VStack(spacing: 8) {
                    // Warning icon with pulse
                    Image(systemName: "bell.badge.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.orange, .yellow],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .symbolEffect(.bounce.byLayer, options: .repeating)
                    
                    Text("\(seconds)s until break")
                        .font(.system(.title3, design: .monospaced))
                        .fontWeight(.semibold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.orange, .yellow],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .contentTransition(.numericText())
                    
                    Text("Prepare to rest")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.75), value: timerManager.state)
    }
    
    private var progressValue: Double {
        switch timerManager.state {
        case .working(let remaining):
            let total = Double(settings.workIntervalSeconds)
            return 1.0 - (Double(remaining) / total)
        case .breaking(let remaining):
            let total = Double(settings.breakDurationSeconds)
            return 1.0 - (Double(remaining) / total)
        default:
            return 0
        }
    }
    
    // MARK: - Controls Section
    
    private var controlsSection: some View {
        VStack(spacing: 12) {
            if timerManager.state == .idle {
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        timerManager.start()
                    }
                }) {
                    HStack {
                        Image(systemName: "play.circle.fill")
                            .font(.title3)
                        Text("Start Timer")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(
                        LinearGradient(
                            colors: [.blue, .blue.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(.plain)
                .scaleEffect(1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: timerManager.state)
                
            } else if timerManager.state.isActive {
                HStack(spacing: 8) {
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            timerManager.stop()
                        }
                    }) {
                        HStack {
                            Image(systemName: "stop.circle.fill")
                            Text("Stop")
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(Color.red.opacity(0.1))
                        .foregroundColor(.red)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.red.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            timerManager.takeBreakNow()
                        }
                    }) {
                        HStack {
                            Image(systemName: "eye.slash.circle.fill")
                            Text("Break Now")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(
                            LinearGradient(
                                colors: [.green, .green.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: .green.opacity(0.3), radius: 6, x: 0, y: 3)
                    }
                    .buttonStyle(.plain)
                }
            } else if case .paused = timerManager.state {
                Button(action: timerManager.resume) {
                    Label("Resume Timer", systemImage: "play.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
        }
    }
    
    // MARK: - Quick Stats Section
    
    private var quickStatsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Today's Progress")
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack(spacing: 16) {
                StatBadge(
                    icon: "checkmark.circle.fill",
                    value: "\(settings.getTodayStats().breaksCompleted)",
                    label: "Breaks",
                    color: .green
                )
                
                StatBadge(
                    icon: "flame.fill",
                    value: "\(settings.getTodayStats().breaksCompleted)/\(settings.dailyBreakGoal)",
                    label: "Goal",
                    color: .orange
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Bottom Actions Section
    
    private var bottomActionsSection: some View {
        VStack(spacing: 0) {
            Button(action: { openWindow(id: "settings") }) {
                HStack {
                    Label("Settings", systemImage: "gear")
                    Spacer()
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .hoverEffect()
            
            Divider()
            
            Button(action: { NSApplication.shared.terminate(nil) }) {
                HStack {
                    Label("Quit EyeBreak", systemImage: "xmark.circle")
                    Spacer()
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .hoverEffect()
        }
    }
    
    // MARK: - Helper Methods
    
    private func formatTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - Stat Badge Component

struct StatBadge: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .font(.body)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.semibold)
                
                Text(label)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - Hover Effect

extension View {
    func hoverEffect() -> some View {
        self.background(
            Color.accentColor.opacity(0.0001)
        )
        .contentShape(Rectangle())
    }
}
