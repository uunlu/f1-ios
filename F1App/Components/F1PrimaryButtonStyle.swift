//
//  F1PrimaryButtonStyle.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import SwiftUI

// MARK: - Button Styles

/// Primary F1 button style with gradient background
public struct F1PrimaryButtonStyle: ButtonStyle {
    public var isFullWidth: Bool = false
    
    public init(isFullWidth: Bool = false) {
        self.isFullWidth = isFullWidth
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(F1Colors.f1White)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .padding(.horizontal, F1Layout.spacing20)
            .padding(.vertical, F1Layout.spacing12)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [F1Colors.f1Red, F1Colors.f1RedDark]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: F1Layout.cornerRadiusMedium))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            .f1ShadowLight()
    }
}

/// Secondary F1 button style with outline design
public struct F1SecondaryButtonStyle: ButtonStyle {
    public var isFullWidth: Bool = false
    
    public init(isFullWidth: Bool = false) {
        self.isFullWidth = isFullWidth
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(F1Colors.f1Red)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .padding(.horizontal, F1Layout.spacing20)
            .padding(.vertical, F1Layout.spacing12)
            .background(
                RoundedRectangle(cornerRadius: F1Layout.cornerRadiusMedium)
                    .fill(F1Colors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: F1Layout.cornerRadiusMedium)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [F1Colors.f1Red, F1Colors.f1RedDark]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: F1Layout.borderWidth
                            )
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            .f1ShadowLight()
    }
}

// MARK: - Button Style Extensions

public extension ButtonStyle where Self == F1PrimaryButtonStyle {
    static var f1Primary: F1PrimaryButtonStyle {
        F1PrimaryButtonStyle()
    }
    
    static var f1PrimaryFullWidth: F1PrimaryButtonStyle {
        F1PrimaryButtonStyle(isFullWidth: true)
    }
}

public extension ButtonStyle where Self == F1SecondaryButtonStyle {
    static var f1Secondary: F1SecondaryButtonStyle {
        F1SecondaryButtonStyle()
    }
    
    static var f1SecondaryFullWidth: F1SecondaryButtonStyle {
        F1SecondaryButtonStyle(isFullWidth: true)
    }
}
