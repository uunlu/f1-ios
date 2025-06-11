//
//  F1ErrorView.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import SwiftUI

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
                    Text(LocalizedStrings.errorTitle)
                        .f1TextStyle(F1Typography.title3, color: F1Colors.textPrimary)
                        .fontWeight(.bold)
                    
                    Text(message)
                        .f1TextStyle(F1Typography.body, color: F1Colors.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
            
            Button(action: retryAction) {
                Text(LocalizedStrings.tryAgain)
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
