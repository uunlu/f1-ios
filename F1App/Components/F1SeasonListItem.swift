//
//  F1SeasonListItem.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import SwiftUI

// MARK: - List Item Components

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
                        
                        Text("World Champion")
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
        .accessibilityHint("Tap to view race winners")
        .accessibilityAddTraits(.isButton)
    }
}

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

/// Loading list item placeholder
public struct F1LoadingListItem: View {
    @State private var shimmerOffset: CGFloat = -200
    
    public init() {}
    
    public var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // Loading badge placeholder
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 60, height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.clear,
                                    Color.white.opacity(0.4),
                                    Color.clear
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .offset(x: shimmerOffset)
                        .animation(
                            Animation.linear(duration: 1.5)
                                .repeatForever(autoreverses: false),
                            value: shimmerOffset
                        )
                )
            
            // Loading color bar
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 4, height: 50)
            
            // Loading text placeholders
            VStack(alignment: .leading, spacing: 4) {
                // Driver name placeholder
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 120, height: 16)
                
                // Constructor placeholder
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 14)
                
                // Champion indicator placeholder
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 10, height: 10)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 90, height: 11)
                }
            }
            
            Spacer()
            
            // Chevron placeholder
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray.opacity(0.3))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onAppear {
            shimmerOffset = 200
        }
    }
}

/// Error view component
public struct F1ErrorView: View {
    public var message: String
    public var retryAction: () -> Void
    
    public init(message: String, retryAction: @escaping () -> Void) {
        self.message = message
        self.retryAction = retryAction
    }
    
    public var body: some View {
        VStack(spacing: F1Layout.spacing24) {
            VStack(spacing: F1Layout.spacing16) {
                F1CircleIcon(
                    icon: "exclamationmark.triangle.fill",
                    color: F1Colors.f1Red,
                    size: .large
                )
                
                VStack(spacing: F1Layout.spacing8) {
                    Text("Something went wrong")
                        .f1TextStyle(F1Typography.title3, color: F1Colors.textPrimary)
                        .fontWeight(.bold)
                    
                    Text(message)
                        .f1TextStyle(F1Typography.body, color: F1Colors.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
            
            Button(action: retryAction) {
                Text("Try Again")
                    .f1TextStyle(F1Typography.body, color: F1Colors.f1White)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, F1Layout.spacing12)
                    .background(F1Colors.f1Red)
                    .clipShape(RoundedRectangle(cornerRadius: F1Layout.cornerRadiusMedium))
            }
            .buttonStyle(.f1Primary)
        }
        .f1Padding(F1Layout.cardInsets)
    }
} 
