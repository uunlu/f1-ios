//
//  F1Colors.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import SwiftUI

public enum F1Colors {
    public static let f1Red = Color(hex: "E10600") // Official F1 red
    public static let f1Black = Color(hex: "15151E") // Rich black with hint of blue
    public static let f1White = Color(hex: "FFFFFF")
    public static let f1Grey = Color(hex: "38383F")
    
    public static let f1RedLight = Color(hex: "FF3B36")
    public static let f1RedDark = Color(hex: "BC0603")
    
    public static let mercedesColor = Color(hex: "00A19C")
    public static let mercedesLight = Color(hex: "00BCB6")
    public static let mercededDark = Color(hex: "008681")
    
    public static let ferrariColor = Color(hex: "F91536")
    public static let ferrariLight = Color(hex: "FF4258")
    public static let ferrariDark = Color(hex: "D40016")
    
    public static let redBullColor = Color(hex: "3671C6")
    public static let redBullLight = Color(hex: "5A8BD9")
    public static let redBullDark = Color(hex: "2956A0")
    
    public static let mclarenColor = Color(hex: "FF8000")
    public static let mclarenLight = Color(hex: "FF9A33")
    public static let mclarenDark = Color(hex: "D46A00")
    
    public static let alpineColor = Color(hex: "0090FF")
    public static let alpineLight = Color(hex: "33A7FF")
    public static let alpineDark = Color(hex: "0075D4")
    
    public static let astonMartinColor = Color(hex: "006F62")
    public static let astonMartinLight = Color(hex: "00897A")
    public static let astonMartinDark = Color(hex: "004D43")
    
    // Additional team colors
    public static let williams = Color(hex: "00A3E0")
    public static let alphaTauri = Color(hex: "00293F")
    public static let alfaRomeo = Color(hex: "A50F2D")
    public static let haas = Color(hex: "B6BABD")
    
    // App theme colors - adapts to light/dark mode
    public static let primary = f1Red
    public static let secondary = Color(hex: "1F1F27")
    
    // Enhanced dynamic colors for light/dark mode
    public static let background = Color(
        light: Color(hex: "F8F8FA"),
        dark: Color(hex: "0E0E13")
    )
    
    public static let cardBackground = Color(
        light: f1White,
        dark: Color(hex: "1A1A23")
    )
    
    public static let navBackground = Color(
        light: f1White.opacity(0.95),
        dark: Color(hex: "15151E").opacity(0.95)
    )
    
    public static let textPrimary = Color(
        light: Color(hex: "15151E"),
        dark: Color(hex: "FFFFFF")
    )
    
    public static let textSecondary = Color(
        light: Color(hex: "6E6E78"),
        dark: Color(hex: "C7C7CC")
    )
    
    public static let textTertiary = Color(
        light: Color(hex: "AEAEB2"),
        dark: Color(hex: "8E8E93")
    )
    
    public static let separator = Color(
        light: Color(hex: "EEEEEF"),
        dark: Color(hex: "2C2C35")
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
    public static let success = Color(hex: "34C759")
    public static let warning = Color(hex: "FF9500")
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
            Color(hex: "15151E"),
            Color(hex: "252532")
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    public static let lightGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(hex: "FAFAFC"),
            Color(hex: "F0F0F4")
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    public static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(light: Color(hex: "FAFAFC"), dark: Color(hex: "12121A")),
            Color(light: Color(hex: "F0F0F4"), dark: Color(hex: "1A1A24"))
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
    private static let teamColorMap: [String: Color] = [
        "mercedes": mercedesColor,
        "ferrari": ferrariColor,
        "red bull": redBullColor,
        "mclaren": mclarenColor,
        "alpine": alpineColor,
        "aston martin": astonMartinColor,
        "williams": williams,
        "alphatauri": alphaTauri,
        "alpha tauri": alphaTauri,
        "alfa romeo": alfaRomeo,
        "haas": haas
    ]
    
    private static let teamColorLightMap: [String: Color] = [
        "mercedes": mercedesLight,
        "ferrari": ferrariLight,
        "red bull": redBullLight,
        "mclaren": mclarenLight,
        "alpine": alpineLight,
        "aston martin": astonMartinLight
    ]
    
    public static func teamColor(for constructor: String) -> Color {
        let normalizedName = constructor.lowercased()
        
        for (key, color) in teamColorMap where normalizedName.contains(key) {
            return color
        }
        
        return f1Grey
    }
    
    public static func teamColorLight(for constructor: String) -> Color {
        let normalizedName = constructor.lowercased()
        
        for (key, color) in teamColorLightMap where normalizedName.contains(key) {
            return color
        }
        
        return f1Grey.opacity(0.3)
    }
    
    public static func teamGradient(for constructor: String) -> LinearGradient {
        let baseColor = teamColor(for: constructor)
        let lightColor = teamColorLight(for: constructor)
        
        return LinearGradient(
            gradient: Gradient(colors: [lightColor, baseColor]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    public static func teamGradient(for color: Color) -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [color, color.adjustBrightness(by: -0.15)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3:
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255,
            opacity: Double(alpha) / 255
        )
    }
    
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
    
    func adjustBrightness(by percentage: CGFloat) -> Color {
        let uiColor = UIColor(self)
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        let newBrightness = max(min(brightness + percentage, 1.0), 0.0)
        return Color(UIColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha))
    }
}
