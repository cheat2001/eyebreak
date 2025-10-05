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
            Image(systemName: "eye.fill")
                .font(.title2)
                .foregroundStyle(.blue)
            
            Text("EyeBreak")
                .font(.headline)
            
            Spacer()
            
            statusIndicator
        }
        .padding()
    }
    
    private var statusIndicator: some View {
        Circle()
            .fill(timerManager.state.isActive ? Color.green : Color.gray)
            .frame(width: 8, height: 8)
            .overlay(
                Circle()
                    .fill(timerManager.state.isActive ? Color.green.opacity(0.3) : Color.clear)
                    .frame(width: 16, height: 16)
                    .scaleEffect(timerManager.state.isActive ? 1.5 : 1.0)
                    .animation(
                        timerManager.state.isActive ?
                        .easeInOut(duration: 1.0).repeatForever(autoreverses: true) : .default,
                        value: timerManager.state.isActive
                    )
            )
    }
    
    // MARK: - Status Section
    
    private var statusSection: some View {
        VStack(spacing: 8) {
            Text(timerManager.state.displayText)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.secondary)
            
            if case .working(let seconds) = timerManager.state {
                ProgressView(value: progressValue, total: 1.0)
                    .tint(.blue)
                
                Text(formatTime(seconds))
                    .font(.system(.title, design: .monospaced))
                    .fontWeight(.bold)
            } else if case .breaking(let seconds) = timerManager.state {
                ProgressView(value: progressValue, total: 1.0)
                    .tint(.green)
                
                Text("\(seconds)s")
                    .font(.system(.title, design: .monospaced))
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            } else if case .preBreak(let seconds) = timerManager.state {
                Text("\(seconds)s until break")
                    .font(.system(.title2, design: .monospaced))
                    .fontWeight(.semibold)
                    .foregroundColor(.orange)
            }
        }
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
                Button(action: timerManager.start) {
                    Label("Start Timer", systemImage: "play.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            } else if timerManager.state.isActive {
                HStack(spacing: 8) {
                    Button(action: timerManager.stop) {
                        Label("Stop", systemImage: "stop.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    
                    Button(action: timerManager.takeBreakNow) {
                        Label("Break Now", systemImage: "eye.slash.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
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
