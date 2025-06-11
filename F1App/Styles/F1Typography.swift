//
//  F1Typography.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import SwiftUI

/// Typography definitions for Formula 1 app
public enum F1Typography {
    // Title styles
    public static let largeTitle = Font.system(size: 34, weight: .bold, design: .default)
    public static let title1 = Font.system(size: 28, weight: .bold, design: .default)
    public static let title2 = Font.system(size: 22, weight: .bold, design: .default)
    public static let title3 = Font.system(size: 20, weight: .semibold, design: .default)
    
    // Body styles
    public static let headline = Font.system(size: 17, weight: .semibold, design: .default)
    public static let body = Font.system(size: 17, weight: .regular, design: .default)
    public static let callout = Font.system(size: 16, weight: .regular, design: .default)
    public static let subheadline = Font.system(size: 15, weight: .regular, design: .default)
    
    // Detail styles
    public static let footnote = Font.system(size: 13, weight: .regular, design: .default)
    public static let caption1 = Font.system(size: 12, weight: .regular, design: .default)
    public static let caption2 = Font.system(size: 11, weight: .regular, design: .default)
    
    // Line heights
    public static let tightLineHeight: CGFloat = 1.1
    public static let standardLineHeight: CGFloat = 1.2
    public static let relaxedLineHeight: CGFloat = 1.3
}

/// Text style modifier for consistent text styling
public struct F1TextStyle: ViewModifier {
    let font: Font
    let color: Color
    let lineSpacing: CGFloat
    
    public init(
        font: Font = F1Typography.body,
        color: Color = F1Colors.textPrimary,
        lineSpacing: CGFloat = F1Typography.standardLineHeight
    ) {
        self.font = font
        self.color = color
        self.lineSpacing = lineSpacing
    }
    
    public func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
            .lineSpacing(lineSpacing - 1.0)
    }
}

/// Extension to add F1 text style functionality to Text views
public extension View {
    /// Apply F1 text style to view
    func f1TextStyle(
        _ font: Font = F1Typography.body,
        color: Color = F1Colors.textPrimary,
        lineSpacing: CGFloat = F1Typography.standardLineHeight
    ) -> some View {
        self.modifier(F1TextStyle(font: font, color: color, lineSpacing: lineSpacing))
    }
}
