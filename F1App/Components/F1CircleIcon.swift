//
//  F1CircleIcon.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import SwiftUI

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
