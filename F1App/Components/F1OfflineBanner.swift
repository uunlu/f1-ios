//
//  F1OfflineBanner.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import SwiftUI

/// Top banner component for offline states
public struct F1OfflineBanner: View {
    let message: String
    let retryAction: (() -> Void)?
    
    public init(message: String, retryAction: (() -> Void)? = nil) {
        self.message = message
        self.retryAction = retryAction
    }
    
    public var body: some View {
        HStack(spacing: F1Layout.spacing12) {
            // Offline icon
            Image(systemName: "wifi.slash")
                .font(F1Typography.body)
                .foregroundColor(F1Colors.f1White)
            
            // Message
            VStack(alignment: .leading, spacing: F1Layout.spacing2) {
                Text(LocalizedStrings.noInternetConnection)
                    .f1TextStyle(F1Typography.caption1, color: F1Colors.f1White)
                    .fontWeight(.semibold)
                
                Text(message)
                    .f1TextStyle(F1Typography.caption2, color: F1Colors.f1White.opacity(0.9))
                    .lineLimit(2)
            }
            
            Spacer()
            
            // Retry button (if provided)
            if let retryAction = retryAction {
                Button(action: retryAction) {
                    Text(LocalizedStrings.retry)
                        .f1TextStyle(F1Typography.caption1, color: F1Colors.f1White)
                        .fontWeight(.medium)
                        .padding(.horizontal, F1Layout.spacing8)
                        .padding(.vertical, F1Layout.spacing4)
                        .background(
                            RoundedRectangle(cornerRadius: F1Layout.cornerRadiusSmall)
                                .fill(F1Colors.f1White.opacity(0.2))
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, F1Layout.spacing16)
        .padding(.vertical, F1Layout.spacing12)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    F1Colors.f1Red,
                    F1Colors.f1Red.opacity(0.8)
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: F1Layout.cornerRadiusMedium))
        .shadow(color: F1Colors.f1Red.opacity(0.3), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    VStack(spacing: 16) {
        F1OfflineBanner(
            message: "Connect to the internet to load F1 data"
        ) {
            print("Retry tapped")
        }
        
        F1OfflineBanner(
            message: "No internet connection and no cached data available"
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
} 
