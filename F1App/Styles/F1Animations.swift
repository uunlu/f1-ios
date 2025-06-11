//
//  F1Animations.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import SwiftUI

/// Animation definitions for Formula 1 app
public enum F1Animations {
    // Basic duration values
    public static let quickDuration: Double = 0.2
    public static let standardDuration: Double = 0.3
    public static let mediumDuration: Double = 0.4
    public static let slowDuration: Double = 0.6
    
    // Animation delay values
    public static let standardDelay: Double = 0.2
    public static let staggerDelay: Double = 0.05
    public static let quickDelay: Double = 0.1
    
    // Standard animations
    public static let quick = Animation.easeInOut(duration: quickDuration)
    public static let standard = Animation.easeInOut(duration: standardDuration)
    public static let medium = Animation.easeInOut(duration: mediumDuration)
    public static let slow = Animation.easeInOut(duration: slowDuration)
    
    // Spring animations
    public static let quickSpring = Animation.spring(response: 0.3, dampingFraction: 0.7)
    public static let standardSpring = Animation.spring(response: 0.4, dampingFraction: 0.8)
    public static let bouncySpring = Animation.spring(response: 0.5, dampingFraction: 0.65)
    
    // Custom animation curves
    public static let customEaseIn = Animation.timingCurve(0.42, 0, 1.0, 1.0, duration: standardDuration)
    public static let customEaseOut = Animation.timingCurve(0, 0, 0.58, 1.0, duration: standardDuration)
    
    // Staggered animations
    public static func staggered(index: Int, baseDelay: Double = staggerDelay) -> Animation {
        Animation.spring(response: 0.4, dampingFraction: 0.75)
            .delay(Double(index) * baseDelay)
    }
    
    // Transitions
    public static let slideTransition = AnyTransition.asymmetric(
        insertion: .move(edge: .trailing).combined(with: .opacity),
        removal: .move(edge: .leading).combined(with: .opacity)
    )
    
    public static let fadeTransition = AnyTransition.opacity
        .combined(with: .scale(scale: 0.95, anchor: .center))
        .animation(.easeInOut(duration: standardDuration))
    
    // Loading animation
    public static let pulsingOpacity = Animation
        .easeInOut(duration: 1.0)
        .repeatForever(autoreverses: true)
}

// Animation view modifiers
public extension View {
    /// Apply fade scale transition to view
    func fadeScaleTransition(isActive: Bool) -> some View {
        self.modifier(FadeScaleTransition(isActive: isActive))
    }
    
    /// Apply pulsing animation to view
    func pulsingAnimation(pulsing: Bool = true) -> some View {
        self.modifier(PulsingAnimationModifier(pulsing: pulsing))
    }
    
    /// Apply racing stripe animation to view
    func racingStripeAnimation(isActive: Bool = true) -> some View {
        self.modifier(RacingStripeAnimationModifier(isActive: isActive))
    }
}

/// Fade scale transition modifier
public struct FadeScaleTransition: ViewModifier {
    let isActive: Bool
    
    public func body(content: Content) -> some View {
        content
            .opacity(isActive ? 1 : 0)
            .scaleEffect(isActive ? 1 : 0.95)
            .animation(F1Animations.standard, value: isActive)
    }
}

/// Pulsing animation modifier
public struct PulsingAnimationModifier: ViewModifier {
    let pulsing: Bool
    @State private var scale: CGFloat = 1.0
    
    public func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .onAppear {
                guard pulsing else { return }
                
                withAnimation(Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                    scale = 1.05
                }
            }
    }
}

/// Racing stripe animation modifier
public struct RacingStripeAnimationModifier: ViewModifier {
    let isActive: Bool
    @State private var offset: CGFloat = -200
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                ZStack {
                    if isActive {
                        Color.white.opacity(0.3)
                            .frame(width: 60, height: 1000)
                            .rotationEffect(.degrees(45))
                            .offset(x: offset)
                            .blur(radius: 8)
                            .onAppear {
                                withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                                    offset = 500
                                }
                            }
                    }
                }
                .clipped()
            )
    }
} 
