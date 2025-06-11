//
//  F1ChampionBadge.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import SwiftUI

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
