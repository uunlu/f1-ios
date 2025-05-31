//
//  F1Layout.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import SwiftUI

/// Layout definitions and spacing constants
public enum F1Layout {
    // Standard spacing
    public static let spacing3: CGFloat = 3
    public static let spacing4: CGFloat = 4
    public static let spacing8: CGFloat = 8
    public static let spacing12: CGFloat = 12
    public static let spacing16: CGFloat = 16
    public static let spacing20: CGFloat = 20
    public static let spacing24: CGFloat = 24
    public static let spacing32: CGFloat = 32
    public static let spacing40: CGFloat = 40
    public static let spacing48: CGFloat = 48
    
    // Content insets
    public static let contentInsets = EdgeInsets(
        top: spacing16,
        leading: spacing16,
        bottom: spacing16,
        trailing: spacing16
    )
    
    public static let tightInsets = EdgeInsets(
        top: spacing8,
        leading: spacing12,
        bottom: spacing8,
        trailing: spacing12
    )
    
    public static let wideInsets = EdgeInsets(
        top: spacing24,
        leading: spacing20,
        bottom: spacing24,
        trailing: spacing20
    )
    
    // Corner radius
    public static let cornerRadiusSmall: CGFloat = 6
    public static let cornerRadiusMedium: CGFloat = 12
    public static let cornerRadiusLarge: CGFloat = 16
    
    // Border & shadow
    public static let borderWidth: CGFloat = 1.5
    public static let shadowRadius: CGFloat = 4
    public static let shadowOpacity: CGFloat = 0.15
    public static let shadowOffset = CGSize(width: 0, height: 2)
    
    // Screen dimensions
    public static var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    public static var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    // Responsive scaling
    public static func responsiveScale(for size: CGFloat) -> CGFloat {
        let baseWidth: CGFloat = 390 // iPhone 14 width
        let scaleFactor = min(max(screenWidth / baseWidth, 0.9), 1.1)
        return size * scaleFactor
    }
    
    // Responsive font scaling
    public static func responsiveFontSize(_ size: CGFloat) -> CGFloat {
        let baseWidth: CGFloat = 390 // iPhone 14 width
        let scaleFactor = min(max(screenWidth / baseWidth, 0.94), 1.06)
        return size * scaleFactor
    }
}

/// Standard padding modifier
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

extension View {
    /// Apply standard F1 padding to view
    public func f1Padding(_ padding: EdgeInsets = F1Layout.contentInsets) -> some View {
        self.modifier(F1Padding(padding))
    }
} 