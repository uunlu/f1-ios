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
    
    /// Standard card view for items
    public struct F1Card<Content: View>: View {
        private let content: Content
        private let cornerRadius: CGFloat
        private let useShadow: Bool
        private let teamColor: Color?
        
        public init(
            cornerRadius: CGFloat = F1Layout.cornerRadiusMedium,
            useShadow: Bool = true,
            teamColor: Color? = nil,
            @ViewBuilder content: () -> Content
        ) {
            self.content = content()
            self.cornerRadius = cornerRadius
            self.useShadow = useShadow
            self.teamColor = teamColor
        }
        
        public var body: some View {
            content
                .f1Padding(F1Layout.contentInsets)
                .background(F1Colors.cardBackground)
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            teamColor ?? F1Colors.separator,
                            lineWidth: teamColor != nil ? F1Layout.borderWidth : 0.5
                        )
                )
                .shadow(
                    color: useShadow ? F1Colors.shadow : Color.clear,
                    radius: F1Layout.shadowRadius,
                    x: F1Layout.shadowOffset.width,
                    y: F1Layout.shadowOffset.height
                )
                .accessibilityElement(children: .contain)
        }
    }
    
    // MARK: - List Items
    
    /// Season list item component
    public struct SeasonListItem: View {
        private let season: Season
        private let action: () -> Void
        @State private var isPressed = false
        
        public init(season: Season, action: @escaping () -> Void) {
            self.season = season
            self.action = action
        }
        
        public var body: some View {
            let constructorColor = F1Colors.teamColor(for: season.constructor)
            
            Button(action: {
                withAnimation(F1Animations.quickSpring) {
                    isPressed = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    action()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isPressed = false
                    }
                }
            }) {
                F1Card(teamColor: constructorColor.opacity(0.7)) {
                    HStack(alignment: .center) {
                        // Season indicator
                        Text(season.season)
                            .f1TextStyle(F1Typography.title2)
                            .frame(width: 70, alignment: .leading)
                        
                        Rectangle()
                            .fill(constructorColor)
                            .frame(width: 4, height: 40)
                        
                        VStack(alignment: .leading, spacing: F1Layout.spacing3) {
                            Text(season.driver)
                                .f1TextStyle(F1Typography.headline)
                                .lineLimit(1)
                            
                            Text(season.constructor)
                                .f1TextStyle(F1Typography.footnote, color: F1Colors.textSecondary)
                                .lineLimit(1)
                        }
                        .padding(.leading, F1Layout.spacing8)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(F1Colors.textSecondary)
                            .padding(.trailing, F1Layout.spacing4)
                    }
                }
                .scaleEffect(isPressed ? 0.98 : 1.0)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    /// Race winner item component
    public struct RaceWinnerItem: View {
        private let race: RaceWinner
        @State private var showDetails = false
        
        public init(race: RaceWinner) {
            self.race = race
        }
        
        public var body: some View {
            let constructorColor = F1Colors.teamColor(for: race.constructorName)
            
            F1Card(teamColor: race.champion ? F1Colors.f1Red : constructorColor.opacity(0.7)) {
                VStack(alignment: .leading, spacing: F1Layout.spacing12) {
                    HStack {
                        VStack(alignment: .leading, spacing: F1Layout.spacing3) {
                            Text("Round \(race.round)")
                                .f1TextStyle(F1Typography.caption1, color: F1Colors.textSecondary)
                                .padding(.bottom, 2)
                            
                            Text("\(race.driver.givenName) \(race.driver.familyName)")
                                .f1TextStyle(F1Typography.headline)
                        }
                        
                        Spacer()
                        
                        if race.champion {
                            VStack {
                                Text("CHAMPION")
                                    .f1TextStyle(F1Typography.caption1, color: F1Colors.f1White)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(F1Colors.f1Red)
                                    .cornerRadius(F1Layout.cornerRadiusSmall)
                            }
                        }
                    }
                    
                    if showDetails {
                        Divider()
                            .background(F1Colors.separator)
                        
                        HStack(alignment: .center, spacing: F1Layout.spacing16) {
                            VStack(alignment: .leading, spacing: F1Layout.spacing4) {
                                Text("Constructor")
                                    .f1TextStyle(F1Typography.caption2, color: F1Colors.textTertiary)
                                
                                Text(race.constructorName)
                                    .f1TextStyle(F1Typography.subheadline)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: F1Layout.spacing4) {
                                Text("Season")
                                    .f1TextStyle(F1Typography.caption2, color: F1Colors.textTertiary)
                                
                                Text(race.seasonName)
                                    .f1TextStyle(F1Typography.subheadline)
                            }
                        }
                    }
                    
                    Button(action: {
                        withAnimation(F1Animations.standardSpring) {
                            showDetails.toggle()
                        }
                    }) {
                        HStack {
                            Spacer()
                            
                            Image(systemName: showDetails ? "chevron.up" : "chevron.down")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(F1Colors.textSecondary)
                                .padding(F1Layout.spacing4)
                            
                            Spacer()
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    // MARK: - Headers
    
    /// Section header component
    public struct SectionHeader: View {
        private let title: String
        private let subtitle: String?
        
        public init(title: String, subtitle: String? = nil) {
            self.title = title
            self.subtitle = subtitle
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: F1Layout.spacing4) {
                Text(title)
                    .f1TextStyle(F1Typography.title2)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .f1TextStyle(F1Typography.footnote, color: F1Colors.textSecondary)
                }
            }
            .padding(.vertical, F1Layout.spacing8)
        }
    }
    
    // MARK: - Loading Views
    
    /// Loading placeholder for list items
    public struct LoadingListItem: View {
        public init() {}
        
        public var body: some View {
            F1Card {
                HStack {
                    RoundedRectangle(cornerRadius: F1Layout.cornerRadiusSmall)
                        .fill(F1Colors.separator)
                        .frame(width: 60, height: 20)
                    
                    VStack(alignment: .leading, spacing: F1Layout.spacing4) {
                        RoundedRectangle(cornerRadius: F1Layout.cornerRadiusSmall)
                            .fill(F1Colors.separator)
                            .frame(height: 16)
                        
                        RoundedRectangle(cornerRadius: F1Layout.cornerRadiusSmall)
                            .fill(F1Colors.separator)
                            .frame(height: 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Spacer()
                }
                .frame(height: 50)
            }
            .racingStripeAnimation()
            .opacity(0.7)
        }
    }
    
    // MARK: - Error Views
    
    /// Error view component
    public struct ErrorView: View {
        private let message: String
        private let retryAction: (() -> Void)?
        
        public init(message: String, retryAction: (() -> Void)? = nil) {
            self.message = message
            self.retryAction = retryAction
        }
        
        public var body: some View {
            VStack(spacing: F1Layout.spacing16) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(F1Colors.error)
                
                Text("Error")
                    .f1TextStyle(F1Typography.title2)
                
                Text(message)
                    .f1TextStyle(F1Typography.body, color: F1Colors.textSecondary)
                    .multilineTextAlignment(.center)
                
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

// MARK: - Button Styles

/// F1 Primary button style
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
            
            if isFullWidth { Spacer() }
        }
        .f1Padding(F1Layout.tightInsets)
        .background(
            RoundedRectangle(cornerRadius: F1Layout.cornerRadiusMedium)
                .fill(configuration.isPressed ? F1Colors.f1Red.opacity(0.8) : F1Colors.f1Red)
        )
        .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
        .animation(F1Animations.quick, value: configuration.isPressed)
    }
}

/// F1 Secondary button style
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
            
            if isFullWidth { Spacer() }
        }
        .f1Padding(F1Layout.tightInsets)
        .background(
            RoundedRectangle(cornerRadius: F1Layout.cornerRadiusMedium)
                .fill(F1Colors.cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: F1Layout.cornerRadiusMedium)
                .stroke(F1Colors.separator, lineWidth: F1Layout.borderWidth)
        )
        .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
        .animation(F1Animations.quick, value: configuration.isPressed)
    }
}

// Extension for button styles
extension ButtonStyle where Self == F1PrimaryButtonStyle {
    /// F1 primary button style
    public static var f1Primary: F1PrimaryButtonStyle { 
        F1PrimaryButtonStyle()
    }
    
    /// F1 primary button style (full width)
    public static var f1PrimaryFullWidth: F1PrimaryButtonStyle { 
        F1PrimaryButtonStyle(isFullWidth: true)
    }
}

extension ButtonStyle where Self == F1SecondaryButtonStyle {
    /// F1 secondary button style
    public static var f1Secondary: F1SecondaryButtonStyle { 
        F1SecondaryButtonStyle()
    }
    
    /// F1 secondary button style (full width)
    public static var f1SecondaryFullWidth: F1SecondaryButtonStyle { 
        F1SecondaryButtonStyle(isFullWidth: true)
    }
} 