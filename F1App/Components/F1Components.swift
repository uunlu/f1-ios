//
//  F1Components.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import SwiftUI

/// Reusable UI components for the Formula 1 app following iOS best practices
public enum F1Components {
    
    // MARK: - Atomic Components
    
    /// Reusable champion badge with configuration options
    public struct ChampionBadge: View {
        public enum Size { case small, standard }
        
        public var size: Size = .standard
        public var text: String = "CHAMPION"
        public var icon: String = "crown.fill"
        public var gradientColors: [Color] = [F1Colors.f1Red, F1Colors.f1RedDark]
        public var animateOnAppear: Bool = false
        
        private var dimensions: (width: CGFloat, height: CGFloat, fontSize: CGFloat, iconSize: CGFloat, padding: CGFloat) {
            switch size {
            case .small:
                return (70, 20, 9, 8, 4)
            case .standard:
                return (90, 28, 10, 10, 8)
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
    
    /// Reusable gradient card container
    public struct GradientCard<Content: View>: View {
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
            size: Size = .standard,
            accentColor: Color,
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
    
    /// Reusable circular icon component
    public struct CircleIcon: View {
        public enum Size { case small, standard, large }
        
        public var size: Size = .standard
        public var icon: String
        public var color: Color
        public var backgroundColor: Color?
        
        private var dimensions: (diameter: CGFloat, iconSize: CGFloat) {
            switch size {
            case .small: return (32, F1Layout.iconSmall)
            case .standard: return (50, F1Layout.iconMedium)
            case .large: return (60, F1Layout.iconLarge)
            }
        }
        
        public init(
            size: Size = .standard,
            icon: String,
            color: Color,
            backgroundColor: Color? = nil
        ) {
            self.size = size
            self.icon = icon
            self.color = color
            self.backgroundColor = backgroundColor
        }
        
        public var body: some View {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                backgroundColor ?? color,
                                (backgroundColor ?? color).opacity(0.7)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: dimensions.diameter, height: dimensions.diameter)
                
                Image(systemName: icon)
                    .font(.system(size: dimensions.iconSize, weight: .medium))
                    .foregroundColor(F1Colors.f1White)
            }
            .f1ShadowLight()
            .accessibilityLabel("\(icon.replacingOccurrences(of: ".", with: " ")) icon")
        }
    }
    
    /// Reusable gradient divider
    public struct GradientDivider: View {
        public var height: CGFloat = 1
        public var opacity: Double = 1.0
        
        public init(height: CGFloat = 1, opacity: Double = 1.0) {
            self.height = height
            self.opacity = opacity
        }
        
        public var body: some View {
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.clear,
                            F1Colors.separator.opacity(opacity),
                            Color.clear
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: height)
                .accessibilityHidden(true)
        }
    }
    
    /// Reusable labeled content component
    public struct LabeledContent<Content: View>: View {
        public var label: String
        public var spacing: CGFloat = F1Layout.spacing12
        public var content: Content
        
        public init(
            label: String,
            spacing: CGFloat = F1Layout.spacing12,
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
                    .accessibilityAddTraits(.isHeader)
                
                content
            }
        }
    }
    
    /// Team color accent bar
    public struct TeamColorBar: View {
        public var color: Color
        public var width: CGFloat = 6
        public var height: CGFloat = 32
        
        public init(color: Color, width: CGFloat = 6, height: CGFloat = 32) {
            self.color = color
            self.width = width
            self.height = height
        }
        
        public var body: some View {
            RoundedRectangle(cornerRadius: F1Layout.spacing3)
                .fill(F1Colors.teamGradient(for: color))
                .frame(width: width, height: height)
                .f1ShadowLight()
                .accessibilityHidden(true)
        }
    }
    
    // MARK: - Composite Components
    
    /// Optimized season list item for better performance
    public struct SeasonListItem: View {
        private let season: Season
        private let action: () -> Void
        @State private var isPressed = false
        
        // Pre-compute expensive values to avoid recalculation
        private let constructorColor: Color
        private let constructorColorString: String
        
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
            }) {
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
            }
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
    public struct RaceWinnerItem: View {
        private let race: RaceWinnerDomainModel
        @State private var showDetails = false
        
        public init(race: RaceWinnerDomainModel) {
            self.race = race
        }
        
        public var body: some View {
            let constructorColor = F1Colors.teamColor(for: race.constructor.name)
            let teamGradient = F1Colors.teamGradient(for: race.constructor.name)
            
            GradientCard(accentColor: race.isChampion ? F1Colors.f1Red : constructorColor) {
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
                            ChampionBadge()
                        }
                    }
                    
                    // Expandable details section
                    if showDetails {
                        VStack(spacing: F1Layout.spacing16) {
                            GradientDivider()
                            
                            // Details grid
                            HStack(spacing: F1Layout.spacing24) {
                                LabeledContent(label: "Constructor") {
                                    HStack(spacing: F1Layout.spacing8) {
                                        TeamColorBar(color: constructorColor, width: 3, height: 20)
                                        
                                        Text(race.constructor.name)
                                            .f1TextStyle(F1Typography.callout, color: F1Colors.textPrimary)
                                            .fontWeight(.medium)
                                    }
                                }
                                
                                Spacer()
                                
                                LabeledContent(label: "Season") {
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
                    .accessibilityLabel(showDetails ? "Hide details" : "Show details")
                    .accessibilityAddTraits(.isButton)
                }
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Round \(race.round), \(race.driver.fullName), \(race.constructor.name)")
        }
    }
    
    // MARK: - Headers and Utility Components
    
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
                            .accessibilityAddTraits(.isHeader)
                        
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
            .accessibilityLabel("Loading content")
        }
    }
    
    /// Premium error view with sophisticated styling
    public struct ErrorView: View {
        private let message: String
        private let retryAction: (() -> Void)?
        
        public init(message: String, retryAction: (() -> Void)? = nil) {
            self.message = message
            self.retryAction = retryAction
        }
        
        public var body: some View {
            GradientCard(accentColor: F1Colors.error) {
                VStack(spacing: F1Layout.spacing20) {
                    // Error icon with gradient background
                    CircleIcon(
                        size: .large,
                        icon: "exclamationmark.triangle.fill",
                        color: F1Colors.error
                    )
                    
                    VStack(spacing: F1Layout.spacing12) {
                        Text("Something went wrong")
                            .f1TextStyle(F1Typography.title3, color: F1Colors.textPrimary)
                            .fontWeight(.semibold)
                            .accessibilityAddTraits(.isHeader)
                        
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
                        .accessibilityHint("Tap to retry the operation")
                    }
                }
            }
        }
    }
}

// MARK: - Helper Extensions

extension View {
    /// Conditional view modifier
    @ViewBuilder func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
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
