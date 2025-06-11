//
//  F1GradientCard.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import SwiftUI

// MARK: - Card Components

/// Reusable gradient card container
public struct F1GradientCard<Content: View>: View {
    public enum Size { case small, standard, large }
    
    public var size: Size = .standard
    public var accentColor: Color
    public var showBorder: Bool = true
    public var animateOnAppear: Bool = false
    public var content: Content
    
    private var cornerRadius: CGFloat {
        switch size {
        case .small: return F1Layout.cornerRadiusMedium
        case .standard: return F1Layout.cornerRadiusLarge
        case .large: return F1Layout.cornerRadiusXLarge
        }
    }
    
    private var padding: EdgeInsets {
        switch size {
        case .small: return F1Layout.compactInsets
        case .standard: return F1Layout.cardInsets
        case .large: return F1Layout.wideInsets
        }
    }
    
    public init(
        accentColor: Color,
        size: Size = .standard,
        showBorder: Bool = true,
        animateOnAppear: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.size = size
        self.accentColor = accentColor
        self.showBorder = showBorder
        self.animateOnAppear = animateOnAppear
        self.content = content()
    }
    
    public var body: some View {
        ZStack {
            // Base background
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(F1Colors.cardBackground)
                .f1ShadowHeavy()
            
            // Gradient overlay
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            accentColor.opacity(0.12),
                            accentColor.opacity(0.04)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Content
            content
                .f1Padding(padding)
            
            // Border
            if showBorder {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                accentColor.opacity(0.4),
                                accentColor.opacity(0.1)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: F1Layout.borderWidth
                    )
            }
        }
        .if(animateOnAppear) { view in
            view.fadeScaleTransition(isActive: true)
        }
    }
}

/// Labeled content container
public struct F1LabeledContent<Content: View>: View {
    public var label: String
    public var spacing: CGFloat = F1Layout.spacing8
    public var content: Content
    
    public init(
        label: String,
        spacing: CGFloat = F1Layout.spacing8,
        @ViewBuilder content: () -> Content
    ) {
        self.label = label
        self.spacing = spacing
        self.content = content()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            Text(label)
                .f1TextStyle(F1Typography.caption1, color: F1Colors.textTertiary)
                .fontWeight(.medium)
            
            content
        }
    }
}

/// Section header component
public struct F1SectionHeader: View {
    public var title: String
    public var subtitle: String?
    
    public init(title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: F1Layout.spacing4) {
            HStack {
                VStack(alignment: .leading, spacing: F1Layout.spacing2) {
                    Text(title)
                        .f1TextStyle(F1Typography.title3, color: F1Colors.textPrimary)
                        .fontWeight(.bold)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .f1TextStyle(F1Typography.caption1, color: F1Colors.textSecondary)
                    }
                }
                
                Spacer()
            }
            
            F1GradientDivider()
        }
    }
} 
