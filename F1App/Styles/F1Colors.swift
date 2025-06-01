//
//  F1Colors.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import SwiftUI

/// Official Formula 1 color palette and theme colors
public enum F1Colors {
    // Official Formula 1 brand colors
    public static let f1Red = Color(red: 1.0, green: 0.0, blue: 0.0) // #FF0000
    public static let f1Black = Color(red: 0.0, green: 0.0, blue: 0.0) // #000000
    public static let f1White = Color(red: 1.0, green: 1.0, blue: 1.0) // #FFFFFF
    public static let f1Grey = Color(red: 0.22, green: 0.22, blue: 0.25) // #38383F
    
    // Enhanced F1 Red variants
    public static let f1RedLight = Color(red: 1.0, green: 0.2, blue: 0.2)
    public static let f1RedDark = Color(red: 0.8, green: 0.0, blue: 0.0)
    
    // Team colors with enhanced variants
    public static let mercedesColor = Color(red: 0.0, green: 0.82, blue: 0.75) // #00D2BE
    public static let mercedesLight = Color(red: 0.2, green: 0.9, blue: 0.85)
    public static let mercededDark = Color(red: 0.0, green: 0.6, blue: 0.55)
    
    public static let ferrariColor = Color(red: 0.86, green: 0.0, blue: 0.0) // #DC0000
    public static let ferrariLight = Color(red: 1.0, green: 0.2, blue: 0.2)
    public static let ferrariDark = Color(red: 0.6, green: 0.0, blue: 0.0)
    
    public static let redBullColor = Color(red: 0.024, green: 0.0, blue: 0.94) // #0600EF
    public static let redBullLight = Color(red: 0.3, green: 0.2, blue: 1.0)
    public static let redBullDark = Color(red: 0.0, green: 0.0, blue: 0.7)
    
    public static let mclarenColor = Color(red: 1.0, green: 0.53, blue: 0.0) // #FF8700
    public static let mclarenLight = Color(red: 1.0, green: 0.7, blue: 0.2)
    public static let mclarenDark = Color(red: 0.8, green: 0.4, blue: 0.0)
    
    public static let alpineColor = Color(red: 0.0, green: 0.56, blue: 1.0) // #0090FF
    public static let alpineLight = Color(red: 0.2, green: 0.7, blue: 1.0)
    public static let alpineDark = Color(red: 0.0, green: 0.4, blue: 0.8)
    
    public static let astonMartinColor = Color(red: 0.0, green: 0.44, blue: 0.38) // #006F62
    public static let astonMartinLight = Color(red: 0.2, green: 0.6, blue: 0.55)
    public static let astonMartinDark = Color(red: 0.0, green: 0.3, blue: 0.25)
    
    // App theme colors - adapts to light/dark mode
    public static let primary = f1Red
    public static let secondary = f1Grey
    
    // Enhanced dynamic colors for light/dark mode
    public static let background = Color(
        light: Color(red: 0.96, green: 0.96, blue: 0.98),
        dark: Color(red: 0.02, green: 0.02, blue: 0.02)
    )
    
    public static let cardBackground = Color(
        light: f1White,
        dark: Color(red: 0.08, green: 0.08, blue: 0.09)
    )
    
    public static let navBackground = Color(
        light: f1White.opacity(0.95),
        dark: Color(red: 0.05, green: 0.05, blue: 0.06)
    )
    
    public static let textPrimary = Color(
        light: Color(red: 0.05, green: 0.05, blue: 0.05),
        dark: Color(red: 0.98, green: 0.98, blue: 0.98)
    )
    
    public static let textSecondary = Color(
        light: Color(red: 0.45, green: 0.45, blue: 0.47),
        dark: Color(red: 0.78, green: 0.78, blue: 0.80)
    )
    
    public static let textTertiary = Color(
        light: Color(red: 0.68, green: 0.68, blue: 0.70),
        dark: Color(red: 0.56, green: 0.56, blue: 0.58)
    )
    
    public static let separator = Color(
        light: Color(red: 0.94, green: 0.94, blue: 0.96),
        dark: Color(red: 0.18, green: 0.18, blue: 0.19)
    )
    
    public static let shadow = Color(
        light: f1Black.opacity(0.08),
        dark: f1Black.opacity(0.4)
    )
    
    public static let shadowHeavy = Color(
        light: f1Black.opacity(0.15),
        dark: f1Black.opacity(0.6)
    )
    
    // Status colors
    public static let success = Color(red: 0.20, green: 0.78, blue: 0.35)
    public static let warning = Color(red: 1.0, green: 0.58, blue: 0.0)
    public static let error = Color(red: 1.0, green: 0.23, blue: 0.19)
    
    // Enhanced gradient colors
    public static let f1Gradient = LinearGradient(
        gradient: Gradient(colors: [f1Red, f1RedDark]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    public static let f1GradientReverse = LinearGradient(
        gradient: Gradient(colors: [f1RedDark, f1Red]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    public static let darkGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.05, green: 0.05, blue: 0.05),
            Color(red: 0.15, green: 0.15, blue: 0.16)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    public static let lightGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.98, green: 0.98, blue: 1.0),
            Color(red: 0.94, green: 0.94, blue: 0.98)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    public static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(
                light: Color(red: 0.98, green: 0.98, blue: 1.0),
                dark: Color(red: 0.02, green: 0.02, blue: 0.02)
            ),
            Color(
                light: Color(red: 0.94, green: 0.94, blue: 0.98),
                dark: Color(red: 0.05, green: 0.05, blue: 0.06)
            )
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    // Overlay colors
    public static let overlayLight = f1White.opacity(0.1)
    public static let overlayMedium = f1White.opacity(0.2)
    public static let overlayHeavy = f1White.opacity(0.3)
    
    public static let overlayDark = f1Black.opacity(0.1)
    public static let overlayDarkMedium = f1Black.opacity(0.2)
    public static let overlayDarkHeavy = f1Black.opacity(0.3)
}

extension F1Colors {
    // Enhanced helper for generating team colors with variants
    public static func teamColor(for constructor: String) -> Color {
        let normalizedName = constructor.lowercased()
        
        if normalizedName.contains("mercedes") {
            return mercedesColor
        } else if normalizedName.contains("ferrari") {
            return ferrariColor
        } else if normalizedName.contains("red bull") {
            return redBullColor
        } else if normalizedName.contains("mclaren") {
            return mclarenColor
        } else if normalizedName.contains("alpine") {
            return alpineColor
        } else if normalizedName.contains("aston martin") {
            return astonMartinColor
        }
        
        return f1Grey
    }
    
    // Get light variant of team color
    public static func teamColorLight(for constructor: String) -> Color {
        let normalizedName = constructor.lowercased()
        
        if normalizedName.contains("mercedes") {
            return mercedesLight
        } else if normalizedName.contains("ferrari") {
            return ferrariLight
        } else if normalizedName.contains("red bull") {
            return redBullLight
        } else if normalizedName.contains("mclaren") {
            return mclarenLight
        } else if normalizedName.contains("alpine") {
            return alpineLight
        } else if normalizedName.contains("aston martin") {
            return astonMartinLight
        }
        
        return f1Grey.opacity(0.3)
    }
    
    // Get gradient for team color
    public static func teamGradient(for constructor: String) -> LinearGradient {
        let baseColor = teamColor(for: constructor)
        let lightColor = teamColorLight(for: constructor)
        
        return LinearGradient(
            gradient: Gradient(colors: [lightColor, baseColor]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// Helper extension for dynamic colors
extension Color {
    init(light: Color, dark: Color) {
        self.init(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(dark)
            default:
                return UIColor(light)
            }
        })
    }
} 