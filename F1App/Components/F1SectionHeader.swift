//
//  F1SectionHeader.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import SwiftUI

/// Section header component
public struct F1SectionHeader: View {
    public var title: String
    public var subtitle: String?
    
    public init(title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: F1Layout.spacing4) {
            HStack {
                VStack(alignment: .leading, spacing: F1Layout.spacing2) {
                    Text(title)
                        .f1TextStyle(F1Typography.title3, color: F1Colors.textPrimary)
                        .fontWeight(.bold)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .f1TextStyle(F1Typography.caption1, color: F1Colors.textSecondary)
                    }
                }
                
                Spacer()
            }
            
            F1GradientDivider()
        }
    }
}
