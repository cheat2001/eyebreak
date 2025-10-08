//
//  ColorThemeSettingsView.swift
//  EyeBreak
//
//  Created on October 8, 2025.
//  UI for customizing color themes for ambient reminders and break overlays
//

import SwiftUI

// MARK: - Theme Settings Card

struct ThemeSettingsCard: View {
    let title: String
    let icon: String
    @Binding var selectedThemeType: ColorThemeType
    @Binding var customTheme: ColorTheme
    let onThemeChange: () -> Void
    
    @State private var showingCustomEditor = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            headerView
            
            // Theme Type Picker - Custom Button Style for Better Visual Feedback
            themePickerView
            
            // Description with visual indicator
            descriptionView
            
            // Preview
            ThemePreviewCard(theme: selectedThemeType == .custom ? customTheme : ColorTheme.theme(for: selectedThemeType))
            
            // Custom theme editor
            if selectedThemeType == .custom {
                customEditorSection
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(NSColor.controlBackgroundColor))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
        )
    }
    
    private var headerView: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            Text(title)
                .font(.headline)
            Spacer()
        }
    }
    
    private var themePickerView: some View {
        HStack(spacing: 12) {
            ForEach(ColorThemeType.allCases) { type in
                ThemeTypeButton(
                    type: type,
                    isSelected: selectedThemeType == type,
                    onSelect: {
                        selectedThemeType = type
                        onThemeChange()
                    }
                )
            }
        }
    }
    
    private var descriptionView: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.caption)
            
            Text(selectedThemeType.description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 4)
    }
    
    private var customEditorSection: some View {
        VStack(spacing: 0) {
            Button(action: {
                showingCustomEditor.toggle()
            }) {
                HStack {
                    Image(systemName: "paintbrush.fill")
                    Text(showingCustomEditor ? "Hide Customization" : "Customize Colors")
                        .fontWeight(.medium)
                    Spacer()
                    Image(systemName: showingCustomEditor ? "chevron.up" : "chevron.down")
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
            .buttonStyle(.plain)
            
            if showingCustomEditor {
                CustomThemeEditor(theme: $customTheme, onThemeChange: onThemeChange)
                    .padding(.top, 12)
            }
        }
    }
}

// MARK: - Theme Preview Card

struct ThemePreviewCard: View {
    let theme: ColorTheme
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon preview
            ZStack {
                Circle()
                    .fill(theme.backgroundGradient())
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle()
                            .stroke(theme.borderGradient(), lineWidth: 1)
                    )
                
                Image(systemName: "eye")
                    .foregroundStyle(theme.textGradient())
                    .font(.title3)
            }
            
            // Text preview
            VStack(alignment: .leading, spacing: 4) {
                Text("Preview")
                    .font(.headline)
                    .foregroundColor(theme.textColor.opacity(theme.textOpacity))
                
                Text("This is how it will look")
                    .font(.caption)
                    .foregroundColor(theme.secondaryTextColor.opacity(theme.secondaryTextOpacity))
            }
            
            Spacer()
            
            // Accent color indicator
            Circle()
                .fill(theme.accentColor.opacity(theme.accentOpacity))
                .frame(width: 24, height: 24)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                )
        }
        .padding()
        .background(theme.backgroundColor.opacity(theme.backgroundOpacity * 0.3))
        .cornerRadius(10)
    }
}

// MARK: - Custom Theme Editor

struct CustomThemeEditor: View {
    @Binding var theme: ColorTheme
    let onThemeChange: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Background Color
            ColorPickerRow(
                title: "Background Color",
                color: Binding(
                    get: { theme.backgroundColor },
                    set: { newColor in
                        if let hex = newColor.toHex() {
                            theme.backgroundColorHex = hex
                            onThemeChange()
                        }
                    }
                ),
                opacity: $theme.backgroundOpacity,
                onOpacityChange: onThemeChange
            )
            
            Divider()
            
            // Text Color
            ColorPickerRow(
                title: "Text Color",
                color: Binding(
                    get: { theme.textColor },
                    set: { newColor in
                        if let hex = newColor.toHex() {
                            theme.textColorHex = hex
                            onThemeChange()
                        }
                    }
                ),
                opacity: $theme.textOpacity,
                onOpacityChange: onThemeChange
            )
            
            Divider()
            
            // Secondary Text Color
            ColorPickerRow(
                title: "Secondary Text",
                color: Binding(
                    get: { theme.secondaryTextColor },
                    set: { newColor in
                        if let hex = newColor.toHex() {
                            theme.secondaryTextColorHex = hex
                            onThemeChange()
                        }
                    }
                ),
                opacity: $theme.secondaryTextOpacity,
                onOpacityChange: onThemeChange
            )
            
            Divider()
            
            // Accent Color
            ColorPickerRow(
                title: "Accent Color",
                color: Binding(
                    get: { theme.accentColor },
                    set: { newColor in
                        if let hex = newColor.toHex() {
                            theme.accentColorHex = hex
                            onThemeChange()
                        }
                    }
                ),
                opacity: $theme.accentOpacity,
                onOpacityChange: onThemeChange
            )
            
            Divider()
            
            // Glass Effect Settings
            VStack(alignment: .leading, spacing: 12) {
                Text("Glass Effect")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text("Blur Radius")
                        .frame(width: 120, alignment: .leading)
                    Slider(value: $theme.glassBlurRadius, in: 0...20) {
                        Text("Blur")
                    } onEditingChanged: { _ in
                        onThemeChange()
                    }
                    Text(String(format: "%.1f", theme.glassBlurRadius))
                        .frame(width: 40)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Highlight")
                        .frame(width: 120, alignment: .leading)
                    Slider(value: $theme.glassHighlightOpacity, in: 0...1) {
                        Text("Highlight")
                    } onEditingChanged: { _ in
                        onThemeChange()
                    }
                    Text(String(format: "%.0f%%", theme.glassHighlightOpacity * 100))
                        .frame(width: 40)
                        .foregroundColor(.secondary)
                }
            }
            
            // Reset button
            HStack {
                Spacer()
                Button(action: {
                    theme = .customTheme
                    onThemeChange()
                }) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Reset to Default")
                    }
                    .foregroundColor(.orange)
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
        .cornerRadius(8)
    }
}

// MARK: - Color Picker Row

struct ColorPickerRow: View {
    let title: String
    @Binding var color: Color
    @Binding var opacity: Double
    let onOpacityChange: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 12) {
                ColorPicker("", selection: $color, supportsOpacity: false)
                    .labelsHidden()
                    .frame(width: 50)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Opacity")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(String(format: "%.0f%%", opacity * 100))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Slider(value: $opacity, in: 0...1) {
                        Text("Opacity")
                    } onEditingChanged: { _ in
                        onOpacityChange()
                    }
                }
            }
        }
    }
}

// MARK: - Quick Presets

struct QuickPresetsView: View {
    @Binding var customTheme: ColorTheme
    let onThemeChange: () -> Void
    
    let presets: [(name: String, theme: ColorTheme)] = [
        ("Ocean Blue", ColorTheme(
            themeType: .custom,
            backgroundColorHex: "#2980B9",
            backgroundOpacity: 0.7,
            textColorHex: "#FFFFFF",
            textOpacity: 0.95,
            secondaryTextColorHex: "#ECF0F1",
            secondaryTextOpacity: 0.75,
            accentColorHex: "#3498DB",
            accentOpacity: 0.8,
            glassBlurRadius: 2.0,
            glassHighlightOpacity: 0.3
        )),
        ("Forest Green", ColorTheme(
            themeType: .custom,
            backgroundColorHex: "#27AE60",
            backgroundOpacity: 0.7,
            textColorHex: "#FFFFFF",
            textOpacity: 0.95,
            secondaryTextColorHex: "#E8F8F5",
            secondaryTextOpacity: 0.75,
            accentColorHex: "#2ECC71",
            accentOpacity: 0.8,
            glassBlurRadius: 2.0,
            glassHighlightOpacity: 0.3
        )),
        ("Sunset Orange", ColorTheme(
            themeType: .custom,
            backgroundColorHex: "#E67E22",
            backgroundOpacity: 0.7,
            textColorHex: "#FFFFFF",
            textOpacity: 0.95,
            secondaryTextColorHex: "#FEF5E7",
            secondaryTextOpacity: 0.75,
            accentColorHex: "#F39C12",
            accentOpacity: 0.8,
            glassBlurRadius: 2.0,
            glassHighlightOpacity: 0.3
        )),
        ("Royal Purple", ColorTheme(
            themeType: .custom,
            backgroundColorHex: "#8E44AD",
            backgroundOpacity: 0.7,
            textColorHex: "#FFFFFF",
            textOpacity: 0.95,
            secondaryTextColorHex: "#F4ECF7",
            secondaryTextOpacity: 0.75,
            accentColorHex: "#9B59B6",
            accentOpacity: 0.8,
            glassBlurRadius: 2.0,
            glassHighlightOpacity: 0.3
        ))
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Presets")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 12) {
                ForEach(presets, id: \.name) { preset in
                    Button(action: {
                        customTheme = preset.theme
                        onThemeChange()
                    }) {
                        VStack(spacing: 8) {
                            Circle()
                                .fill(preset.theme.backgroundGradient())
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Circle()
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                            
                            Text(preset.name)
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
        .cornerRadius(10)
    }
}

// MARK: - Theme Type Button Component

struct ThemeTypeButton: View {
    let type: ColorThemeType
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 8) {
                iconCircle
                
                Text(type.rawValue)
                    .font(.caption)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundColor(isSelected ? .blue : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(backgroundColor)
            .overlay(borderOverlay)
        }
        .buttonStyle(.plain)
    }
    
    private var iconCircle: some View {
        ZStack {
            Circle()
                .fill(circleFill)
                .frame(width: 50, height: 50)
                .overlay(
                    Circle()
                        .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
                )
            
            Image(systemName: type.icon)
                .font(.title3)
                .foregroundColor(isSelected ? .white : .secondary)
        }
    }
    
    private var circleFill: LinearGradient {
        if isSelected {
            return LinearGradient(
                colors: [.blue, .blue.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                colors: [Color(NSColor.controlBackgroundColor)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    private var backgroundColor: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(isSelected ? Color.blue.opacity(0.1) : Color(NSColor.controlBackgroundColor).opacity(0.5))
    }
    
    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(isSelected ? Color.blue.opacity(0.5) : Color.clear, lineWidth: 2)
    }
}
