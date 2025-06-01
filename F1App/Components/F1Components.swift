//
//  F1Components.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import SwiftUI

/// Reusable UI components for the Formula 1 app
public enum F1Components {
    
    // MARK: - Card Views
    
    /// Premium F1 card with sophisticated styling
    public struct F1Card<Content: View>: View {
        private let content: Content
        private let cornerRadius: CGFloat
        private let useShadow: Bool
        private let teamColor: Color?
        private let useGradient: Bool
        
        public init(
            cornerRadius: CGFloat = F1Layout.cornerRadiusMedium,
            useShadow: Bool = true,
            teamColor: Color? = nil,
            useGradient: Bool = false,
            @ViewBuilder content: () -> Content
        ) {
            self.content = content()
            self.cornerRadius = cornerRadius
            self.useShadow = useShadow
            self.teamColor = teamColor
            self.useGradient = useGradient
        }
        
        public var body: some View {
            content
                .f1Padding(F1Layout.cardInsets)
                .background(
                    ZStack {
                        // Base background
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(F1Colors.cardBackground)
                        
                        // Gradient overlay if team color provided
                        if let teamColor = teamColor, useGradient {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            teamColor.opacity(0.1),
                                            teamColor.opacity(0.05)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                        
                        // Subtle inner glow
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        F1Colors.overlayLight,
                                        Color.clear
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                lineWidth: 1
                            )
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            teamColor ?? F1Colors.separator.opacity(0.3),
                            lineWidth: teamColor != nil ? F1Layout.borderWidth : F1Layout.borderWidthThin
                        )
                )
                .f1ShadowHeavy()
                .accessibilityElement(children: .contain)
        }
    }
    
    // MARK: - List Items
    
    /// Premium season list item with sophisticated styling
    public struct SeasonListItem: View {
        private let season: Season
        private let action: () -> Void
        @State private var isPressed = false
        @State private var isHovered = false
        
        public init(season: Season, action: @escaping () -> Void) {
            self.season = season
            self.action = action
        }
        
        public var body: some View {
            let constructorColor = F1Colors.teamColor(for: season.constructor)
            let teamGradient = F1Colors.teamGradient(for: season.constructor)
            
            Button(action: {
                print("Button tapped for season: \(season.season)") // Debug print
                action()
            }) {
                ZStack {
                    // Background card
                    RoundedRectangle(cornerRadius: F1Layout.cornerRadiusLarge)
                        .fill(F1Colors.cardBackground)
                        .f1ShadowHeavy()
                    
                    // Team color gradient overlay
                    RoundedRectangle(cornerRadius: F1Layout.cornerRadiusLarge)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    constructorColor.opacity(0.15),
                                    constructorColor.opacity(0.05),
                                    Color.clear
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // Content
                    HStack(alignment: .center, spacing: F1Layout.spacing16) {
                        // Year badge with gradient
                        ZStack {
                            RoundedRectangle(cornerRadius: F1Layout.cornerRadiusSmall)
                                .fill(teamGradient)
                                .frame(width: 80, height: 50)
                            
                            Text(season.season)
                                .f1TextStyle(F1Typography.title3, color: F1Colors.f1White)
                                .fontWeight(.bold)
                        }
                        .f1ShadowLight()
                        
                        // Team color accent bar
                        RoundedRectangle(cornerRadius: F1Layout.spacing2)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [constructorColor, constructorColor.opacity(0.6)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 4, height: 60)
                        
                        // Driver and constructor info
                        VStack(alignment: .leading, spacing: F1Layout.spacing6) {
                            Text(season.driver)
                                .f1TextStyle(F1Typography.headline, color: F1Colors.textPrimary)
                                .lineLimit(1)
                            
                            Text(season.constructor)
                                .f1TextStyle(F1Typography.subheadline, color: F1Colors.textSecondary)
                                .lineLimit(1)
                            
                            // World Champion badge
                            HStack(spacing: F1Layout.spacing4) {
                                Image(systemName: "crown.fill")
                                    .font(.system(size: F1Layout.iconSmall))
                                    .foregroundColor(constructorColor)
                                
                                Text("World Champion")
                                    .f1TextStyle(F1Typography.caption1, color: constructorColor)
                                    .fontWeight(.medium)
                            }
                        }
                        
                        Spacer()
                        
                        // Chevron with subtle background
                        ZStack {
                            Circle()
                                .fill(F1Colors.separator.opacity(0.3))
                                .frame(width: 32, height: 32)
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(F1Colors.textSecondary)
                        }
                    }
                    .f1Padding(F1Layout.cardInsets)
                    
                    // Border highlight
                    RoundedRectangle(cornerRadius: F1Layout.cornerRadiusLarge)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    constructorColor.opacity(0.4),
                                    constructorColor.opacity(0.1)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: F1Layout.borderWidth
                        )
                }
                .scaleEffect(isPressed ? 0.98 : 1.0)
                .animation(F1Animations.quickSpring, value: isPressed)
            }
            .buttonStyle(PlainButtonStyle())
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !isPressed {
                            withAnimation(F1Animations.quickSpring) {
                                isPressed = true
                            }
                        }
                    }
                    .onEnded { _ in
                        withAnimation(F1Animations.quickSpring) {
                            isPressed = false
                        }
                    }
            )
        }
    }
    
    /// Premium race winner item with expandable details
    public struct RaceWinnerItem: View {
        private let race: RaceWinner
        @State private var showDetails = false
        @State private var isExpanded = false
        
        public init(race: RaceWinner) {
            self.race = race
        }
        
        public var body: some View {
            let constructorColor = F1Colors.teamColor(for: race.constructorName)
            let teamGradient = F1Colors.teamGradient(for: race.constructorName)
            
            ZStack {
                // Background with team gradient
                RoundedRectangle(cornerRadius: F1Layout.cornerRadiusLarge)
                    .fill(F1Colors.cardBackground)
                    .f1ShadowHeavy()
                
                // Team color accent
                RoundedRectangle(cornerRadius: F1Layout.cornerRadiusLarge)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                (race.champion ? F1Colors.f1Red : constructorColor).opacity(0.1),
                                (race.champion ? F1Colors.f1Red : constructorColor).opacity(0.03)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
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
                            Text("Round \(race.round)")
                                .f1TextStyle(F1Typography.caption1, color: F1Colors.textTertiary)
                            
                            Text("\(race.driver.givenName) \(race.driver.familyName)")
                                .f1TextStyle(F1Typography.title3, color: F1Colors.textPrimary)
                                .fontWeight(.semibold)
                            
                            Text(race.constructorName)
                                .f1TextStyle(F1Typography.subheadline, color: constructorColor)
                                .fontWeight(.medium)
                        }
                        
                        Spacer()
                        
                        // Champion badge
                        if race.champion {
                            ZStack {
                                RoundedRectangle(cornerRadius: F1Layout.cornerRadiusSmall)
                                    .fill(F1Colors.f1Gradient)
                                    .frame(width: 90, height: 28)
                                
                                HStack(spacing: F1Layout.spacing4) {
                                    Image(systemName: "crown.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(F1Colors.f1White)
                                    
                                    Text("CHAMPION")
                                        .f1TextStyle(F1Typography.caption1, color: F1Colors.f1White)
                                        .fontWeight(.bold)
                                }
                            }
                            .f1ShadowLight()
                        }
                    }
                    
                    // Expandable details section
                    if showDetails {
                        VStack(spacing: F1Layout.spacing16) {
                            // Elegant divider
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.clear,
                                            F1Colors.separator,
                                            Color.clear
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(height: 1)
                            
                            // Details grid
                            HStack(spacing: F1Layout.spacing24) {
                                VStack(alignment: .leading, spacing: F1Layout.spacing6) {
                                    Text("Constructor")
                                        .f1TextStyle(F1Typography.caption2, color: F1Colors.textTertiary)
                                        .fontWeight(.medium)
                                    
                                    HStack(spacing: F1Layout.spacing8) {
                                        RoundedRectangle(cornerRadius: F1Layout.spacing2)
                                            .fill(constructorColor)
                                            .frame(width: 3, height: 20)
                                        
                                        Text(race.constructorName)
                                            .f1TextStyle(F1Typography.callout, color: F1Colors.textPrimary)
                                            .fontWeight(.medium)
                                    }
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: F1Layout.spacing6) {
                                    Text("Season")
                                        .f1TextStyle(F1Typography.caption2, color: F1Colors.textTertiary)
                                        .fontWeight(.medium)
                                    
                                    Text(race.seasonName)
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
                    }) {
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
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .f1Padding(F1Layout.cardInsets)
                
                // Premium border
                RoundedRectangle(cornerRadius: F1Layout.cornerRadiusLarge)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                (race.champion ? F1Colors.f1Red : constructorColor).opacity(0.3),
                                (race.champion ? F1Colors.f1Red : constructorColor).opacity(0.1)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: F1Layout.borderWidth
                    )
            }
        }
    }
    
    // MARK: - Headers
    
    /// Elegant section header with sophisticated styling
    public struct SectionHeader: View {
        private let title: String
        private let subtitle: String?
        
        public init(title: String, subtitle: String? = nil) {
            self.title = title
            self.subtitle = subtitle
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: F1Layout.spacing8) {
                HStack {
                    // Accent line
                    RoundedRectangle(cornerRadius: F1Layout.spacing2)
                        .fill(F1Colors.f1Gradient)
                        .frame(width: 4, height: 32)
                    
                    VStack(alignment: .leading, spacing: F1Layout.spacing4) {
                        Text(title)
                            .f1TextStyle(F1Typography.title2, color: F1Colors.textPrimary)
                            .fontWeight(.bold)
                        
                        if let subtitle = subtitle {
                            Text(subtitle)
                                .f1TextStyle(F1Typography.subheadline, color: F1Colors.textSecondary)
                        }
                    }
                    
                    Spacer()
                }
            }
            .f1Padding(EdgeInsets(
                top: F1Layout.spacing16,
                leading: 0,
                bottom: F1Layout.spacing8,
                trailing: 0
            ))
        }
    }
    
    // MARK: - Loading Views
    
    /// Premium loading placeholder with sophisticated animation
    public struct LoadingListItem: View {
        @State private var shimmerOffset: CGFloat = -300
        
        public init() {}
        
        public var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: F1Layout.cornerRadiusLarge)
                    .fill(F1Colors.cardBackground)
                    .f1ShadowLight()
                
                HStack(spacing: F1Layout.spacing16) {
                    // Animated circle
                    Circle()
                        .fill(F1Colors.separator.opacity(0.3))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.clear,
                                            F1Colors.overlayLight,
                                            Color.clear
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .offset(x: shimmerOffset)
                                .clipped()
                        )
                    
                    VStack(alignment: .leading, spacing: F1Layout.spacing8) {
                        // Animated rectangles
                        RoundedRectangle(cornerRadius: F1Layout.cornerRadiusSmall)
                            .fill(F1Colors.separator.opacity(0.3))
                            .frame(height: 20)
                            .overlay(
                                RoundedRectangle(cornerRadius: F1Layout.cornerRadiusSmall)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.clear,
                                                F1Colors.overlayLight,
                                                Color.clear
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .offset(x: shimmerOffset)
                                    .clipped()
                            )
                        
                        RoundedRectangle(cornerRadius: F1Layout.cornerRadiusSmall)
                            .fill(F1Colors.separator.opacity(0.2))
                            .frame(height: 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .overlay(
                                RoundedRectangle(cornerRadius: F1Layout.cornerRadiusSmall)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.clear,
                                                F1Colors.overlayLight,
                                                Color.clear
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .offset(x: shimmerOffset)
                                    .clipped()
                            )
                    }
                    
                    Spacer()
                }
                .f1Padding(F1Layout.cardInsets)
            }
            .frame(height: F1Layout.cardStandardHeight)
            .onAppear {
                withAnimation(
                    Animation.linear(duration: 1.5)
                        .repeatForever(autoreverses: false)
                ) {
                    shimmerOffset = 300
                }
            }
        }
    }
    
    // MARK: - Error Views
    
    /// Premium error view with sophisticated styling
    public struct ErrorView: View {
        private let message: String
        private let retryAction: (() -> Void)?
        
        public init(message: String, retryAction: (() -> Void)? = nil) {
            self.message = message
            self.retryAction = retryAction
        }
        
        public var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: F1Layout.cornerRadiusLarge)
                    .fill(F1Colors.cardBackground)
                    .f1ShadowHeavy()
                
                VStack(spacing: F1Layout.spacing20) {
                    // Error icon with gradient background
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        F1Colors.error.opacity(0.1),
                                        F1Colors.error.opacity(0.05)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: F1Layout.iconLarge, weight: .medium))
                            .foregroundColor(F1Colors.error)
                    }
                    
                    VStack(spacing: F1Layout.spacing12) {
                        Text("Something went wrong")
                            .f1TextStyle(F1Typography.title3, color: F1Colors.textPrimary)
                            .fontWeight(.semibold)
                        
                        Text(message)
                            .f1TextStyle(F1Typography.body, color: F1Colors.textSecondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                    }
                    
                    if let retryAction = retryAction {
                        Button("Try Again") {
                            retryAction()
                        }
                        .buttonStyle(F1PrimaryButtonStyle())
                    }
                }
                .f1Padding(F1Layout.wideInsets)
            }
        }
    }
}

// MARK: - Enhanced Button Styles

/// Premium F1 Primary button style
public struct F1PrimaryButtonStyle: ButtonStyle {
    private let isFullWidth: Bool
    
    public init(isFullWidth: Bool = false) {
        self.isFullWidth = isFullWidth
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            if isFullWidth { Spacer() }
            
            configuration.label
                .f1TextStyle(F1Typography.headline, color: F1Colors.f1White)
                .fontWeight(.semibold)
            
            if isFullWidth { Spacer() }
        }
        .f1Padding(F1Layout.buttonInsets)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: F1Layout.cornerRadiusMedium)
                    .fill(F1Colors.f1Gradient)
                
                if configuration.isPressed {
                    RoundedRectangle(cornerRadius: F1Layout.cornerRadiusMedium)
                        .fill(F1Colors.overlayDark)
                }
            }
        )
        .f1ShadowHeavy()
        .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
        .animation(F1Animations.quick, value: configuration.isPressed)
    }
}

/// Premium F1 Secondary button style
public struct F1SecondaryButtonStyle: ButtonStyle {
    private let isFullWidth: Bool
    
    public init(isFullWidth: Bool = false) {
        self.isFullWidth = isFullWidth
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            if isFullWidth { Spacer() }
            
            configuration.label
                .f1TextStyle(F1Typography.headline, color: F1Colors.textPrimary)
                .fontWeight(.semibold)
            
            if isFullWidth { Spacer() }
        }
        .f1Padding(F1Layout.buttonInsets)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: F1Layout.cornerRadiusMedium)
                    .fill(F1Colors.cardBackground)
                
                RoundedRectangle(cornerRadius: F1Layout.cornerRadiusMedium)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                F1Colors.separator.opacity(0.5),
                                F1Colors.separator.opacity(0.2)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: F1Layout.borderWidth
                    )
                
                if configuration.isPressed {
                    RoundedRectangle(cornerRadius: F1Layout.cornerRadiusMedium)
                        .fill(F1Colors.overlayDark.opacity(0.1))
                }
            }
        )
        .f1ShadowLight()
        .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
        .animation(F1Animations.quick, value: configuration.isPressed)
    }
}

// Extension for button styles
extension ButtonStyle where Self == F1PrimaryButtonStyle {
    public static var f1Primary: F1PrimaryButtonStyle { 
        F1PrimaryButtonStyle()
    }
    
    public static var f1PrimaryFullWidth: F1PrimaryButtonStyle { 
        F1PrimaryButtonStyle(isFullWidth: true)
    }
}

extension ButtonStyle where Self == F1SecondaryButtonStyle {
    public static var f1Secondary: F1SecondaryButtonStyle { 
        F1SecondaryButtonStyle()
    }
    
    public static var f1SecondaryFullWidth: F1SecondaryButtonStyle { 
        F1SecondaryButtonStyle(isFullWidth: true)
    }
} 