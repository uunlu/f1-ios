//
//  F1TeamColorBar.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import SwiftUI

/// Team color bar indicator
public struct F1TeamColorBar: View {
    public var color: Color
    public var width: CGFloat = 4
    public var height: CGFloat = 24
    
    public init(color: Color, width: CGFloat = 4, height: CGFloat = 24) {
        self.color = color
        self.width = width
        self.height = height
    }
    
    public var body: some View {
        RoundedRectangle(cornerRadius: width / 2)
            .fill(color)
            .frame(width: width, height: height)
    }
}
