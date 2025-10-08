//
//  ColorTheme.swift
//  EyeBreak
//
//  Created on October 8, 2025.
//  Color theme system for customizable UI appearance
//

import SwiftUI

// MARK: - Color Theme Type

/// Defines the available color theme options
enum ColorThemeType: String, Codable, CaseIterable, Identifiable {
    case defaultTheme = "Default"
    case liquidGlass = "Liquid Glass"
    case custom = "Custom"
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .defaultTheme:
            return "Classic vibrant style with rich colors"
        case .liquidGlass:
            return "Elegant frosted glass with soft tones"
        case .custom:
            return "Create your own personalized theme"
        }
    }
    
    var icon: String {
        switch self {
        case .defaultTheme:
            return "paintpalette.fill"
        case .liquidGlass:
            return "drop.fill"
        case .custom:
            return "slider.horizontal.3"
        }
    }
}

// MARK: - Color Theme Model

/// Represents a complete color theme with all customization options
struct ColorTheme: Codable, Equatable {
    var themeType: ColorThemeType
    
    // Background colors (stored as hex for UserDefaults compatibility)
    var backgroundColorHex: String
    var backgroundOpacity: Double
    
    // Text colors
    var textColorHex: String
    var textOpacity: Double
    
    // Secondary text colors
    var secondaryTextColorHex: String
    var secondaryTextOpacity: Double
    
    // Accent colors
    var accentColorHex: String
    var accentOpacity: Double
    
    // Glass effect properties
    var glassBlurRadius: Double
    var glassHighlightOpacity: Double
    
    // Computed Color properties for easy use
    var backgroundColor: Color {
        Color(hex: backgroundColorHex) ?? .blue
    }
    
    var textColor: Color {
        Color(hex: textColorHex) ?? .white
    }
    
    var secondaryTextColor: Color {
        Color(hex: secondaryTextColorHex) ?? .white
    }
    
    var accentColor: Color {
        Color(hex: accentColorHex) ?? .cyan
    }
    
    // MARK: - Presets
    
    /// Default vibrant theme (current style)
    static let defaultTheme = ColorTheme(
        themeType: .defaultTheme,
        backgroundColorHex: "#5B7FCF",  // Soft slate blue
        backgroundOpacity: 0.75,
        textColorHex: "#FFFFFF",
        textOpacity: 0.95,
        secondaryTextColorHex: "#FFFFFF",
        secondaryTextOpacity: 0.75,
        accentColorHex: "#5DADE2",  // Cyan
        accentOpacity: 0.8,
        glassBlurRadius: 0.5,
        glassHighlightOpacity: 0.25
    )
    
    /// Liquid glass theme with elegant frosted appearance
    static let liquidGlassTheme = ColorTheme(
        themeType: .liquidGlass,
        backgroundColorHex: "#E8F4F8",  // Very light blue/white
        backgroundOpacity: 0.25,
        textColorHex: "#2C3E50",  // Dark blue-gray
        textOpacity: 0.9,
        secondaryTextColorHex: "#34495E",  // Medium gray
        secondaryTextOpacity: 0.7,
        accentColorHex: "#3498DB",  // Bright blue
        accentOpacity: 0.6,
        glassBlurRadius: 12.0,
        glassHighlightOpacity: 0.4
    )
    
    /// Default custom theme (user can modify)
    static let customTheme = ColorTheme(
        themeType: .custom,
        backgroundColorHex: "#8E44AD",  // Purple
        backgroundOpacity: 0.7,
        textColorHex: "#FFFFFF",
        textOpacity: 0.95,
        secondaryTextColorHex: "#FFFFFF",
        secondaryTextOpacity: 0.75,
        accentColorHex: "#F39C12",  // Orange
        accentOpacity: 0.8,
        glassBlurRadius: 2.0,
        glassHighlightOpacity: 0.3
    )
    
    // MARK: - Factory Method
    
    static func theme(for type: ColorThemeType, customTheme: ColorTheme? = nil) -> ColorTheme {
        switch type {
        case .defaultTheme:
            return defaultTheme
        case .liquidGlass:
            return liquidGlassTheme
        case .custom:
            return customTheme ?? ColorTheme.customTheme
        }
    }
}

// MARK: - Color Extension for Hex Support

extension Color {
    /// Initialize Color from hex string
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    /// Convert Color to hex string
    func toHex() -> String? {
        guard let components = NSColor(self).cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        
        return String(format: "#%02lX%02lX%02lX",
                     lroundf(r * 255),
                     lroundf(g * 255),
                     lroundf(b * 255))
    }
}

// MARK: - Theme Configuration for Different UI Elements

extension ColorTheme {
    /// Apply background gradient based on theme
    func backgroundGradient() -> LinearGradient {
        switch themeType {
        case .defaultTheme:
            return LinearGradient(
                colors: [
                    backgroundColor.opacity(backgroundOpacity),
                    backgroundColor.opacity(backgroundOpacity * 0.85),
                    backgroundColor.opacity(backgroundOpacity * 0.9)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .liquidGlass:
            return LinearGradient(
                colors: [
                    backgroundColor.opacity(backgroundOpacity),
                    backgroundColor.opacity(backgroundOpacity * 0.6),
                    backgroundColor.opacity(backgroundOpacity * 0.4)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .custom:
            return LinearGradient(
                colors: [
                    backgroundColor.opacity(backgroundOpacity),
                    backgroundColor.opacity(backgroundOpacity * 0.85),
                    backgroundColor.opacity(backgroundOpacity * 0.9)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    /// Apply text gradient based on theme
    func textGradient() -> LinearGradient {
        LinearGradient(
            colors: [
                textColor.opacity(textOpacity),
                textColor.opacity(textOpacity * 0.95)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// Apply border gradient based on theme
    func borderGradient() -> LinearGradient {
        switch themeType {
        case .liquidGlass:
            return LinearGradient(
                colors: [
                    Color.white.opacity(0.5),
                    Color.white.opacity(0.2),
                    Color.white.opacity(0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default:
            return LinearGradient(
                colors: [
                    Color.white.opacity(0.35),
                    Color.white.opacity(0.1),
                    Color.white.opacity(0.2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}
