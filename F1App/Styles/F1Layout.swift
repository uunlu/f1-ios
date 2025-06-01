//
//  F1Layout.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import SwiftUI

/// Layout definitions and spacing constants
public enum F1Layout {
    // Enhanced spacing scale
    public static let spacing2: CGFloat = 2
    public static let spacing3: CGFloat = 3
    public static let spacing4: CGFloat = 4
    public static let spacing6: CGFloat = 6
    public static let spacing8: CGFloat = 8
    public static let spacing10: CGFloat = 10
    public static let spacing12: CGFloat = 12
    public static let spacing16: CGFloat = 16
    public static let spacing20: CGFloat = 20
    public static let spacing24: CGFloat = 24
    public static let spacing28: CGFloat = 28
    public static let spacing32: CGFloat = 32
    public static let spacing40: CGFloat = 40
    public static let spacing48: CGFloat = 48
    public static let spacing56: CGFloat = 56
    public static let spacing64: CGFloat = 64
    
    // Premium content insets
    public static let contentInsets = EdgeInsets(
        top: spacing20,
        leading: spacing20,
        bottom: spacing20,
        trailing: spacing20
    )
    
    public static let tightInsets = EdgeInsets(
        top: spacing12,
        leading: spacing16,
        bottom: spacing12,
        trailing: spacing16
    )
    
    public static let wideInsets = EdgeInsets(
        top: spacing32,
        leading: spacing24,
        bottom: spacing32,
        trailing: spacing24
    )
    
    public static let cardInsets = EdgeInsets(
        top: spacing24,
        leading: spacing20,
        bottom: spacing24,
        trailing: spacing20
    )
    
    public static let buttonInsets = EdgeInsets(
        top: spacing16,
        leading: spacing24,
        bottom: spacing16,
        trailing: spacing24
    )
    
    // Enhanced corner radius
    public static let cornerRadiusSmall: CGFloat = 8
    public static let cornerRadiusMedium: CGFloat = 16
    public static let cornerRadiusLarge: CGFloat = 24
    public static let cornerRadiusXLarge: CGFloat = 32
    
    // Enhanced border & shadow
    public static let borderWidth: CGFloat = 1.5
    public static let borderWidthThick: CGFloat = 2.0
    public static let borderWidthThin: CGFloat = 0.5
    
    // Sophisticated shadow system
    public static let shadowRadius: CGFloat = 8
    public static let shadowRadiusLight: CGFloat = 4
    public static let shadowRadiusHeavy: CGFloat = 16
    public static let shadowRadiusXHeavy: CGFloat = 24
    
    public static let shadowOpacity: CGFloat = 0.1
    public static let shadowOpacityMedium: CGFloat = 0.15
    public static let shadowOpacityHeavy: CGFloat = 0.25
    
    public static let shadowOffset = CGSize(width: 0, height: 4)
    public static let shadowOffsetLight = CGSize(width: 0, height: 2)
    public static let shadowOffsetHeavy = CGSize(width: 0, height: 8)
    
    // Screen dimensions
    public static var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    public static var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    // Enhanced responsive scaling
    public static func responsiveScale(for size: CGFloat) -> CGFloat {
        let baseWidth: CGFloat = 390 // iPhone 14 width
        let scaleFactor = min(max(screenWidth / baseWidth, 0.85), 1.15)
        return size * scaleFactor
    }
    
    // Enhanced responsive font scaling
    public static func responsiveFontSize(_ size: CGFloat) -> CGFloat {
        let baseWidth: CGFloat = 390 // iPhone 14 width
        let scaleFactor = min(max(screenWidth / baseWidth, 0.92), 1.08)
        return size * scaleFactor
    }
    
    // Card dimensions
    public static let cardMinHeight: CGFloat = 80
    public static let cardStandardHeight: CGFloat = 120
    public static let cardLargeHeight: CGFloat = 160
    
    // Icon sizes
    public static let iconSmall: CGFloat = 16
    public static let iconMedium: CGFloat = 24
    public static let iconLarge: CGFloat = 32
    public static let iconXLarge: CGFloat = 48
}

/// Enhanced padding modifier with premium spacing
public struct F1Padding: ViewModifier {
    let padding: EdgeInsets
    
    public init(_ padding: EdgeInsets = F1Layout.contentInsets) {
        self.padding = padding
    }
    
    public func body(content: Content) -> some View {
        content
            .padding(.top, padding.top)
            .padding(.leading, padding.leading)
            .padding(.bottom, padding.bottom)
            .padding(.trailing, padding.trailing)
    }
}

/// Premium shadow modifier
public struct F1Shadow: ViewModifier {
    let radius: CGFloat
    let opacity: CGFloat
    let offset: CGSize
    let color: Color
    
    public init(
        radius: CGFloat = F1Layout.shadowRadius,
        opacity: CGFloat = F1Layout.shadowOpacity,
        offset: CGSize = F1Layout.shadowOffset,
        color: Color = F1Colors.shadow
    ) {
        self.radius = radius
        self.opacity = opacity
        self.offset = offset
        self.color = color
    }
    
    public func body(content: Content) -> some View {
        content
            .shadow(
                color: color.opacity(opacity),
                radius: radius,
                x: offset.width,
                y: offset.height
            )
    }
}

/// Glassmorphism effect modifier
public struct F1Glassmorphism: ViewModifier {
    let intensity: Double
    
    public init(intensity: Double = 0.1) {
        self.intensity = intensity
    }
    
    public func body(content: Content) -> some View {
        content
            .background(
                F1Colors.cardBackground
                    .opacity(0.8)
                    .blur(radius: 0.5)
            )
            .overlay(
                F1Colors.overlayLight
            )
    }
}

extension View {
    /// Apply standard F1 padding to view
    public func f1Padding(_ padding: EdgeInsets = F1Layout.contentInsets) -> some View {
        self.modifier(F1Padding(padding))
    }
    
    /// Apply premium F1 shadow
    public func f1Shadow(
        radius: CGFloat = F1Layout.shadowRadius,
        opacity: CGFloat = F1Layout.shadowOpacity,
        offset: CGSize = F1Layout.shadowOffset,
        color: Color = F1Colors.shadow
    ) -> some View {
        self.modifier(F1Shadow(radius: radius, opacity: opacity, offset: offset, color: color))
    }
    
    /// Apply light shadow
    public func f1ShadowLight() -> some View {
        self.f1Shadow(
            radius: F1Layout.shadowRadiusLight,
            opacity: F1Layout.shadowOpacity,
            offset: F1Layout.shadowOffsetLight
        )
    }
    
    /// Apply heavy shadow
    public func f1ShadowHeavy() -> some View {
        self.f1Shadow(
            radius: F1Layout.shadowRadiusHeavy,
            opacity: F1Layout.shadowOpacityHeavy,
            offset: F1Layout.shadowOffsetHeavy
        )
    }
    
    /// Apply glassmorphism effect
    public func f1Glassmorphism(intensity: Double = 0.1) -> some View {
        self.modifier(F1Glassmorphism(intensity: intensity))
    }
} 