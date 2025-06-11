//
//  F1LabeledContent.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import SwiftUI

/// Labeled content container
public struct F1LabeledContent<Content: View>: View {
    public var label: String
    public var spacing: CGFloat = F1Layout.spacing8
    public var content: Content
    
    public init(
        label: String,
        spacing: CGFloat = F1Layout.spacing8,
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
            
            content
        }
    }
}
