//
//  F1ChampionBadge.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import SwiftUI

// MARK: - Basic UI Components

/// Championship badge component
public struct F1ChampionBadge: View {
    public enum Size { case small, standard }
    
    public var size: Size = .standard
    public var text: String = "CHAMPION"
    public var icon: String = "crown.fill"
    public var gradientColors: [Color] = [F1Colors.f1Red, F1Colors.f1RedDark]
    public var animateOnAppear: Bool = false
    
    private struct Dimensions {
        let width: CGFloat
        let height: CGFloat
        let fontSize: CGFloat
        let iconSize: CGFloat
        let padding: CGFloat
    }
    
    private var dimensions: Dimensions {
        switch size {
        case .small:
            return Dimensions(width: 70, height: 20, fontSize: 9, iconSize: 8, padding: 4)
        case .standard:
            return Dimensions(width: 90, height: 28, fontSize: 10, iconSize: 10, padding: 8)
        }
    }
    
    public init(
        size: Size = .standard,
        text: String = "CHAMPION",
        icon: String = "crown.fill",
        gradientColors: [Color] = [F1Colors.f1Red, F1Colors.f1RedDark],
        animateOnAppear: Bool = false
    ) {
        self.size = size
        self.text = text
        self.icon = icon
        self.gradientColors = gradientColors
        self.animateOnAppear = animateOnAppear
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: F1Layout.cornerRadiusSmall)
                .fill(LinearGradient(
                    colors: gradientColors,
                    startPoint: .leading,
                    endPoint: .trailing
                ))
                .frame(width: dimensions.width, height: dimensions.height)
            
            HStack(spacing: F1Layout.spacing4) {
                Image(systemName: icon)
                    .font(.system(size: dimensions.iconSize, weight: .bold))
                    .foregroundColor(F1Colors.f1White)
                
                Text(text)
                    .font(.system(size: dimensions.fontSize, weight: .bold))
                    .foregroundColor(F1Colors.f1White)
            }
            .padding(.horizontal, dimensions.padding)
        }
        .f1ShadowLight()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(text) badge")
        .accessibilityAddTraits(.isHeader)
        .if(animateOnAppear) { view in
            view.fadeScaleTransition(isActive: true)
        }
    }
}

/// Reusable circular icon component
public struct F1CircleIcon: View {
    public enum Size { case small, standard, large }
    
    public var size: Size = .standard
    public var icon: String
    public var color: Color
    public var backgroundColor: Color?
    
    private var dimensions: (diameter: CGFloat, iconSize: CGFloat) {
        switch size {
        case .small: return (32, F1Layout.iconSmall)
        case .standard: return (50, F1Layout.iconMedium)
        case .large: return (60, F1Layout.iconLarge)
        }
    }
    
    public init(
        icon: String,
        color: Color,
        size: Size = .standard,
        backgroundColor: Color? = nil
    ) {
        self.size = size
        self.icon = icon
        self.color = color
        self.backgroundColor = backgroundColor
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            backgroundColor ?? color,
                            (backgroundColor ?? color).opacity(0.7)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: dimensions.diameter, height: dimensions.diameter)
            
            Image(systemName: icon)
                .font(.system(size: dimensions.iconSize, weight: .medium))
                .foregroundColor(F1Colors.f1White)
        }
        .f1ShadowLight()
        .accessibilityLabel("\(icon.replacingOccurrences(of: ".", with: " ")) icon")
    }
}

/// Reusable gradient divider
public struct F1GradientDivider: View {
    public var height: CGFloat = 1
    public var opacity: Double = 0.3
    
    public init(height: CGFloat = 1, opacity: Double = 0.3) {
        self.height = height
        self.opacity = opacity
    }
    
    public var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        F1Colors.separator.opacity(0),
                        F1Colors.separator.opacity(opacity),
                        F1Colors.separator.opacity(0)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(height: height)
    }
}

/// Team color bar indicator
public struct F1TeamColorBar: View {
    public var color: Color
    public var width: CGFloat = 4
    public var height: CGFloat = 24
    
    public init(color: Color, width: CGFloat = 4, height: CGFloat = 24) {
        self.color = color
        self.width = width
        self.height = height
    }
    
    public var body: some View {
        RoundedRectangle(cornerRadius: width / 2)
            .fill(color)
            .frame(width: width, height: height)
    }
} 
