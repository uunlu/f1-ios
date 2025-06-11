//
//  F1GradientDivider.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import SwiftUI

/// Reusable gradient divider
public struct F1GradientDivider: View {
    public var height: CGFloat = 1
    public var opacity: Double = 0.3
    
    public init(height: CGFloat = 1, opacity: Double = 0.3) {
        self.height = height
        self.opacity = opacity
    }
    
    public var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        F1Colors.separator.opacity(0),
                        F1Colors.separator.opacity(opacity),
                        F1Colors.separator.opacity(0)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(height: height)
    }
}
