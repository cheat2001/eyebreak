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
            Text("Today's Statistics")
                .font(.title2)
                .fontWeight(.bold)
            
            let todayStats = settings.getTodayStats()
            
            HStack(spacing: 32) {
                StatBox(
                    title: "Breaks Taken",
                    value: "\(todayStats.breaksCompleted)",
                    icon: "checkmark.circle.fill",
                    color: .green
                )
                
                StatBox(
                    title: "Breaks Skipped",
                    value: "\(todayStats.breaksSkipped)",
                    icon: "xmark.circle.fill",
                    color: .red
                )
                
                StatBox(
                    title: "Total Break Time",
                    value: formatDuration(todayStats.totalBreakTime),
                    icon: "clock.fill",
                    color: .blue
                )
            }
            
            // Progress bar
            VStack(spacing: 8) {
                HStack {
                    Text("Daily Goal Progress")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(todayStats.breaksCompleted) / \(settings.dailyBreakGoal)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                
                ProgressView(
                    value: Double(todayStats.breaksCompleted),
                    total: Double(settings.dailyBreakGoal)
                )
                .tint(todayStats.breaksCompleted >= settings.dailyBreakGoal ? .green : .blue)
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(12)
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
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(color)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}
