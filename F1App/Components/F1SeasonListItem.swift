//
//  F1SeasonListItem.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import SwiftUI

/// Season list item component
public struct F1SeasonListItem: View {
    private let season: Season
    private let action: () -> Void
    private let constructorColor: Color
    private let constructorColorString: String
    @State private var isPressed = false
    
    public init(season: Season, action: @escaping () -> Void) {
        self.season = season
        self.action = action
        // Pre-compute team color to avoid repeated string processing
        self.constructorColor = F1Colors.teamColor(for: season.constructor)
        self.constructorColorString = season.constructor
    }
    
    public var body: some View {
        Button(action: {
            action()
        }, label: {
            // Simplified card with reduced complexity
            HStack(alignment: .center, spacing: 12) {
                // Simple year badge
                Text(season.season)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 40)
                    .background(constructorColor)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                // Simplified color indicator
                Rectangle()
                    .fill(constructorColor)
                    .frame(width: 4, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                
                // Driver and constructor info - simplified
                VStack(alignment: .leading, spacing: 4) {
                    Text(season.driver)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text(season.constructor)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    
                    // Simple champion indicator
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundColor(constructorColor)
                        
                        Text(LocalizedStrings.worldChampion)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(constructorColor)
                    }
                }
                
                Spacer()
                
                // Simple chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        })
        .buttonStyle(PlainButtonStyle())
        .onTapGesture {
            // Simple press feedback
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
            action()
        }
        .accessibilityElement()
        .accessibilityLabel("Season \(season.season), \(season.driver), \(season.constructor)")
        .accessibilityHint(LocalizedStrings.tapToViewWinners)
        .accessibilityAddTraits(.isButton)
    }
}
