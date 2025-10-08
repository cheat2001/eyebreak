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
    case randomColor = "Random Color"
    case custom = "Custom"
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .defaultTheme:
            return "Classic vibrant style with rich colors"
        case .randomColor:
            return "Surprise! A fresh color every time"
        case .custom:
            return "Create your own personalized theme"
        }
    }
    
    var icon: String {
        switch self {
        case .defaultTheme:
            return "paintpalette.fill"
        case .randomColor:
            return "shuffle"
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
    
    /// Random color theme - generates a fresh beautiful color scheme each time
    static func randomColorTheme() -> ColorTheme {
        let palette = RandomColorPalette.generate()
        return ColorTheme(
            themeType: .randomColor,
            backgroundColorHex: palette.primary,
            backgroundOpacity: 0.75,
            textColorHex: "#FFFFFF",
            textOpacity: 0.95,
            secondaryTextColorHex: "#FFFFFF",
            secondaryTextOpacity: 0.75,
            accentColorHex: palette.accent,
            accentOpacity: 0.85,
            glassBlurRadius: 1.5,
            glassHighlightOpacity: 0.3
        )
    }
    
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
        case .randomColor:
            return randomColorTheme()
        case .custom:
            return customTheme ?? ColorTheme.customTheme
        }
    }
}

// MARK: - Random Color Palette Generator

struct RandomColorPalette {
    let primary: String
    let accent: String
    
    /// Curated beautiful color palettes that always look good
    private static let beautifulPalettes: [(primary: String, accent: String)] = [
        // Vibrant & Energetic
        ("#FF6B6B", "#4ECDC4"),  // Coral Red & Turquoise
        ("#6C5CE7", "#FD79A8"),  // Purple & Pink
        ("#00B894", "#FDCB6E"),  // Emerald & Gold
        ("#0984E3", "#00CEC9"),  // Blue & Cyan
        ("#E17055", "#74B9FF"),  // Terracotta & Sky Blue
        
        // Warm & Inviting
        ("#FD7272", "#FFA502"),  // Warm Red & Orange
        ("#FF7979", "#FDCB6E"),  // Salmon & Yellow
        ("#FF6348", "#FF9FF3"),  // Tomato & Pink
        ("#FF6B9D", "#FFC312"),  // Rose & Amber
        
        // Cool & Calm
        ("#5F27CD", "#00D2D3"),  // Deep Purple & Aqua
        ("#341F97", "#54A0FF"),  // Dark Purple & Light Blue
        ("#2C3E50", "#3498DB"),  // Dark Blue & Bright Blue
        ("#1B9CFC", "#55E6C1"),  // Ocean Blue & Mint
        
        // Modern & Professional
        ("#6C5CE7", "#A29BFE"),  // Purple Gradient
        ("#00B894", "#55EFC4"),  // Green Gradient
        ("#0984E3", "#74B9FF"),  // Blue Gradient
        ("#FF7675", "#FD79A8"),  // Pink Gradient
        
        // Nature Inspired
        ("#27AE60", "#F39C12"),  // Forest Green & Sunflower
        ("#16A085", "#E67E22"),  // Teal & Carrot
        ("#2ECC71", "#F1C40F"),  // Spring Green & Daffodil
        ("#1ABC9C", "#E74C3C"),  // Turquoise & Alizarin
    ]
    
    static func generate() -> RandomColorPalette {
        let palette = beautifulPalettes.randomElement() ?? beautifulPalettes[0]
        return RandomColorPalette(primary: palette.primary, accent: palette.accent)
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
        case .defaultTheme, .custom:
            return LinearGradient(
                colors: [
                    backgroundColor.opacity(backgroundOpacity),
                    backgroundColor.opacity(backgroundOpacity * 0.85),
                    backgroundColor.opacity(backgroundOpacity * 0.9)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .randomColor:
            // Dynamic gradient for random colors
            return LinearGradient(
                colors: [
                    backgroundColor.opacity(backgroundOpacity),
                    backgroundColor.opacity(backgroundOpacity * 0.8),
                    accentColor.opacity(accentOpacity * 0.3)
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
        // Consistent border for all themes
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
