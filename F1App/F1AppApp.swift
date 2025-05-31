//
//  F1AppApp.swift
//  F1App
//
//  Created by Ugur Unlu on 29/05/2025.
//

import SwiftUI

@main
struct F1AppApp: App {
    @StateObject private var coordinator = DependencyContainer.shared.makeAppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                coordinator.makeSeasonsView()
                    .environmentObject(coordinator)
            }
        }
    }
}
