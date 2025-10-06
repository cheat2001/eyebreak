//
//  StatsView.swift
//  EyeBreak
//
//  Created on October 5, 2025.
//

import SwiftUI
import Charts

struct StatsView: View {
    @EnvironmentObject var settings: AppSettings
    @State private var selectedTimeRange: TimeRange = .week
    
    enum TimeRange: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        
        var days: Int {
            switch self {
            case .week: return 7
            case .month: return 30
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Today's Summary
                todaySummarySection
                
                Divider()
                    .padding(.vertical)
                
                // Historical Chart
                historicalChartSection
                
                Divider()
                    .padding(.vertical)
                
                // Insights
                insightsSection
                
                // Reset Button
                Button(role: .destructive, action: {
                    settings.resetStats()
                }) {
                    Label("Reset Statistics", systemImage: "trash")
                }
                .padding(.top)
            }
            .padding(40)
        }
    }
    
    // MARK: - Today's Summary
    
    private var todaySummarySection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .font(.title2)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .cyan],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text("Today's Statistics")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
            }
            
            let todayStats = settings.getTodayStats()
            
            HStack(spacing: 20) {
                EnhancedStatBox(
                    title: "Breaks Taken",
                    value: "\(todayStats.breaksCompleted)",
                    icon: "checkmark.seal.fill",
                    color: .green,
                    trend: .up
                )
                
                EnhancedStatBox(
                    title: "Breaks Skipped",
                    value: "\(todayStats.breaksSkipped)",
                    icon: "xmark.seal.fill",
                    color: .red,
                    trend: .down
                )
                
                EnhancedStatBox(
                    title: "Total Break Time",
                    value: formatDuration(todayStats.totalBreakTime),
                    icon: "clock.badge.fill",
                    color: .blue,
                    trend: .neutral
                )
            }
            
            // Enhanced progress bar with animation
            VStack(spacing: 8) {
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "target")
                            .foregroundStyle(.blue)
                        Text("Daily Goal Progress")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Text("\(todayStats.breaksCompleted)")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                        Text("/")
                            .foregroundColor(.secondary)
                        Text("\(settings.dailyBreakGoal)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                    }
                }
                
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.secondary.opacity(0.15))
                        .frame(height: 12)
                    
                    // Progress with gradient
                    GeometryReader { geometry in
                        let progress = min(Double(todayStats.breaksCompleted) / Double(settings.dailyBreakGoal), 1.0)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: todayStats.breaksCompleted >= settings.dailyBreakGoal ? 
                                        [Color.green, Color.mint] : [Color.blue, Color.cyan],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * progress)
                            .shadow(color: (todayStats.breaksCompleted >= settings.dailyBreakGoal ? Color.green : Color.blue).opacity(0.3), radius: 4)
                            .animation(.spring(response: 0.6, dampingFraction: 0.7), value: progress)
                    }
                    .frame(height: 12)
                    
                    // Sparkle effect when goal reached
                    if todayStats.breaksCompleted >= settings.dailyBreakGoal {
                        HStack(spacing: 4) {
                            Spacer()
                            Image(systemName: "sparkles")
                                .foregroundColor(.yellow)
                                .font(.caption)
                            Text("Goal Reached!")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.green)
                            Spacer()
                        }
                        .offset(y: -20)
                    }
                }
                .frame(height: 12)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.secondary.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    colors: [.blue.opacity(0.3), .cyan.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
        }
    }
    
    // MARK: - Historical Chart
    
    private var historicalChartSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Break History")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Picker("Time Range", selection: $selectedTimeRange) {
                    ForEach(TimeRange.allCases, id: \.self) { range in
                        Text(range.rawValue).tag(range)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 200)
            }
            
            if #available(macOS 13.0, *) {
                chartView
                    .frame(height: 250)
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(12)
            } else {
                Text("Charts require macOS 13.0 or later")
                    .foregroundColor(.secondary)
                    .frame(height: 250)
                    .frame(maxWidth: .infinity)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(12)
            }
        }
    }
    
    @available(macOS 13.0, *)
    private var chartView: some View {
        let data = getChartData()
        
        return Chart(data) { item in
            BarMark(
                x: .value("Date", item.date, unit: .day),
                y: .value("Breaks", item.breaks)
            )
            .foregroundStyle(item.breaks >= settings.dailyBreakGoal ? Color.green : Color.blue)
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { _ in
                AxisValueLabel(format: .dateTime.month().day())
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
    }
    
    // MARK: - Insights
    
    private var insightsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Insights")
                .font(.title2)
                .fontWeight(.bold)
            
            let stats = settings.getAllStats()
            let insights = generateInsights(from: stats)
            
            ForEach(insights, id: \.title) { insight in
                InsightCard(
                    icon: insight.icon,
                    title: insight.title,
                    description: insight.description,
                    color: insight.color
                )
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func formatDuration(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        
        if minutes > 0 {
            return "\(minutes)m \(secs)s"
        } else {
            return "\(secs)s"
        }
    }
    
    private func getChartData() -> [ChartDataPoint] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let allStats = settings.getAllStats()
        
        var data: [ChartDataPoint] = []
        
        for i in 0..<selectedTimeRange.days {
            let date = calendar.date(byAdding: .day, value: -i, to: today)!
            let stats = allStats.first { calendar.isDate($0.date, inSameDayAs: date) }
            
            data.append(ChartDataPoint(
                date: date,
                breaks: stats?.breaksCompleted ?? 0
            ))
        }
        
        return data.reversed()
    }
    
    private func generateInsights(from stats: [BreakStats]) -> [Insight] {
        var insights: [Insight] = []
        
        // Calculate weekly average
        let recentStats = stats.prefix(7)
        let weeklyAverage = recentStats.map { $0.breaksCompleted }.reduce(0, +) / max(recentStats.count, 1)
        
        if weeklyAverage >= settings.dailyBreakGoal {
            insights.append(Insight(
                icon: "star.fill",
                title: "Excellent Progress!",
                description: "You're consistently meeting your daily break goal. Keep it up!",
                color: .green
            ))
        } else {
            insights.append(Insight(
                icon: "chart.line.uptrend.xyaxis",
                title: "Room for Improvement",
                description: "Try to increase your break frequency to meet your daily goal.",
                color: .orange
            ))
        }
        
        // Check skip rate
        let totalBreaks = recentStats.map { $0.breaksCompleted }.reduce(0, +)
        let totalSkips = recentStats.map { $0.breaksSkipped }.reduce(0, +)
        
        if totalSkips > totalBreaks / 4 {
            insights.append(Insight(
                icon: "exclamationmark.triangle.fill",
                title: "High Skip Rate",
                description: "You're skipping \(Int(Double(totalSkips) / Double(totalBreaks + totalSkips) * 100))% of breaks. Your eyes need rest!",
                color: .red
            ))
        }
        
        // Streak
        let currentStreak = calculateStreak(from: stats)
        if currentStreak >= 3 {
            insights.append(Insight(
                icon: "flame.fill",
                title: "\(currentStreak) Day Streak!",
                description: "You've taken breaks every day for \(currentStreak) days. Amazing!",
                color: .orange
            ))
        }
        
        return insights
    }
    
    private func calculateStreak(from stats: [BreakStats]) -> Int {
        let calendar = Calendar.current
        let sortedStats = stats.sorted { $0.date > $1.date }
        
        var streak = 0
        var currentDate = calendar.startOfDay(for: Date())
        
        for stat in sortedStats {
            if calendar.isDate(stat.date, inSameDayAs: currentDate) && stat.breaksCompleted > 0 {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            } else {
                break
            }
        }
        
        return streak
    }
}

// MARK: - Supporting Types

struct ChartDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let breaks: Int
}

struct Insight {
    let icon: String
    let title: String
    let description: String
    let color: Color
}

// MARK: - Supporting Views

struct StatBox: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title)
                .foregroundStyle(color)
            
            Text(value)
                .font(.system(size: 32, weight: .bold, design: .rounded))
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
}

struct InsightCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [color, color.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(color.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: color.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Enhanced Stat Box

struct EnhancedStatBox: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let trend: Trend
    
    enum Trend {
        case up, down, neutral
        
        var icon: String {
            switch self {
            case .up: return "arrow.up.right"
            case .down: return "arrow.down.right"
            case .neutral: return "minus"
            }
        }
        
        var color: Color {
            switch self {
            case .up: return .green
            case .down: return .red
            case .neutral: return .gray
            }
        }
    }
    
    @State private var animateValue = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Icon with gradient background
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [color.opacity(0.3), color.opacity(0.15)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 56, height: 56)
                    .shadow(color: color.opacity(0.2), radius: 8)
                
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [color, color.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .scaleEffect(animateValue ? 1.0 : 0.8)
            .animation(.spring(response: 0.5, dampingFraction: 0.6), value: animateValue)
            
            VStack(spacing: 6) {
                Text(value)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [color, color.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .contentTransition(.numericText())
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Trend indicator
            HStack(spacing: 4) {
                Image(systemName: trend.icon)
                    .font(.caption2)
                Text("Trend")
                    .font(.caption2)
            }
            .foregroundColor(trend.color.opacity(0.8))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(trend.color.opacity(0.1))
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.secondary.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [color.opacity(0.3), color.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
        )
        .shadow(color: color.opacity(0.1), radius: 10, x: 0, y: 5)
        .onAppear {
            animateValue = true
        }
    }
}
