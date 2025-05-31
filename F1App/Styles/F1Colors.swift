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
    
    // Team colors
    public static let mercedesColor = Color(red: 0.0, green: 0.82, blue: 0.75) // #00D2BE
    public static let ferrariColor = Color(red: 0.86, green: 0.0, blue: 0.0) // #DC0000
    public static let redBullColor = Color(red: 0.024, green: 0.0, blue: 0.94) // #0600EF
    public static let mclarenColor = Color(red: 1.0, green: 0.53, blue: 0.0) // #FF8700
    public static let alpineColor = Color(red: 0.0, green: 0.56, blue: 1.0) // #0090FF
    public static let astonMartinColor = Color(red: 0.0, green: 0.44, blue: 0.38) // #006F62
    
    // App theme colors - adapts to light/dark mode
    public static let primary = f1Red
    public static let secondary = f1Grey
    
    // Dynamic colors for light/dark mode
    public static let background = Color(
        light: Color(red: 0.98, green: 0.98, blue: 0.98),
        dark: Color(red: 0.05, green: 0.05, blue: 0.05)
    )
    
    public static let cardBackground = Color(
        light: f1White,
        dark: Color(red: 0.11, green: 0.11, blue: 0.12)
    )
    
    public static let navBackground = Color(
        light: f1White,
        dark: Color(red: 0.08, green: 0.08, blue: 0.09)
    )
    
    public static let textPrimary = Color(
        light: f1Black,
        dark: f1White
    )
    
    public static let textSecondary = Color(
        light: Color(red: 0.44, green: 0.44, blue: 0.46),
        dark: Color(red: 0.76, green: 0.76, blue: 0.78)
    )
    
    public static let textTertiary = Color(
        light: Color(red: 0.68, green: 0.68, blue: 0.70),
        dark: Color(red: 0.54, green: 0.54, blue: 0.56)
    )
    
    public static let separator = Color(
        light: Color(red: 0.92, green: 0.92, blue: 0.94),
        dark: Color(red: 0.22, green: 0.22, blue: 0.23)
    )
    
    public static let shadow = Color(
        light: f1Black.opacity(0.15),
        dark: f1Black.opacity(0.3)
    )
    
    // Status colors
    public static let success = Color(red: 0.20, green: 0.78, blue: 0.35)
    public static let warning = Color(red: 1.0, green: 0.58, blue: 0.0)
    public static let error = Color(red: 1.0, green: 0.23, blue: 0.19)
    
    // Gradient colors
    public static let f1Gradient = LinearGradient(
        gradient: Gradient(colors: [f1Red, f1Red.opacity(0.7)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    public static let darkGradient = LinearGradient(
        gradient: Gradient(colors: [f1Black, f1Grey]),
        startPoint: .top,
        endPoint: .bottom
    )
}

extension F1Colors {
    // Helper for generating team color from constructor name
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
        
        // Default color for other teams
        return f1Grey
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