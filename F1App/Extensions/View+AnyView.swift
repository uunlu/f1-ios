//
//  View+AnyView.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import SwiftUI

extension View {
    /// Wraps the view in AnyView for type erasure
    /// Useful for factory methods that return different view types
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
} 
