//
//  F1RaceWinnerItem.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import SwiftUI

/// Premium race winner item with expandable details
public struct F1RaceWinnerItem: View {
    private let race: RaceWinnerDomainModel
    @State private var showDetails = false
    
    public init(race: RaceWinnerDomainModel) {
        self.race = race
    }
    
    public var body: some View {
        let constructorColor = F1Colors.teamColor(for: race.constructor.name)
        let teamGradient = F1Colors.teamGradient(for: race.constructor.name)
        
        F1GradientCard(accentColor: race.isChampion ? F1Colors.f1Red : constructorColor) {
            VStack(alignment: .leading, spacing: F1Layout.spacing16) {
                // Header section
                HStack(alignment: .top, spacing: F1Layout.spacing16) {
                    // Round indicator
                    ZStack {
                        Circle()
                            .fill(teamGradient)
                            .frame(width: 50, height: 50)
                        
                        Text(race.round)
                            .f1TextStyle(F1Typography.headline, color: F1Colors.f1White)
                            .fontWeight(.bold)
                    }
                    .f1ShadowLight()
                    
                    // Driver info
                    VStack(alignment: .leading, spacing: F1Layout.spacing4) {
                        HStack {
                            Text("Round \(race.round)")
                                .f1TextStyle(F1Typography.caption1, color: F1Colors.textTertiary)
                            Spacer()
                            Text("Time: \(race.raceCompletionTime)")
                                .f1TextStyle(F1Typography.caption1, color: F1Colors.textTertiary)
                                .bold()
                        }
                        
                        Text("\(race.driver.fullName)")
                            .f1TextStyle(F1Typography.title3, color: F1Colors.textPrimary)
                            .fontWeight(.semibold)
                        
                        Text(race.constructor.name)
                            .f1TextStyle(F1Typography.subheadline, color: constructorColor)
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                    
                    // Champion badge
                    if race.isChampion {
                        F1ChampionBadge()
                    }
                }
                
                // Expandable details section
                if showDetails {
                    VStack(spacing: F1Layout.spacing16) {
                        F1GradientDivider()
                        
                        // Details grid
                        HStack(spacing: F1Layout.spacing24) {
                            F1LabeledContent(label: "Constructor") {
                                HStack(spacing: F1Layout.spacing8) {
                                    F1TeamColorBar(color: constructorColor, width: 3, height: 20)
                                    
                                    Text(race.constructor.name)
                                        .f1TextStyle(F1Typography.callout, color: F1Colors.textPrimary)
                                        .fontWeight(.medium)
                                }
                            }
                            
                            Spacer()
                            
                            F1LabeledContent(label: "Season") {
                                Text(race.season)
                                    .f1TextStyle(F1Typography.callout, color: F1Colors.textPrimary)
                                    .fontWeight(.medium)
                            }
                        }
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }
                
                // Expand/collapse button
                Button(action: {
                    withAnimation(F1Animations.standardSpring) {
                        showDetails.toggle()
                    }
                }, label: {
                    HStack {
                        Spacer()
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: F1Layout.cornerRadiusSmall)
                                .fill(F1Colors.separator.opacity(0.3))
                                .frame(width: 60, height: 32)
                            
                            Image(systemName: showDetails ? "chevron.up" : "chevron.down")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(F1Colors.textSecondary)
                                .rotationEffect(.degrees(showDetails ? 180 : 0))
                                .animation(F1Animations.standard, value: showDetails)
                        }
                        
                        Spacer()
                    }
                })
                .buttonStyle(PlainButtonStyle())
                .accessibilityLabel(showDetails ? "Hide details" : "Show details")
                .accessibilityAddTraits(.isButton)
            }
        }
    }
}
