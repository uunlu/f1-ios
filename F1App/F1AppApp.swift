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
    
    init() {
        // Initialize F1 styling
        F1Style.configureAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                coordinator.makeSeasonsView()
                    .environmentObject(coordinator)
                    .navigationDestination(for: Season.self) { season in
                        coordinator.makeRaceWinnerView(for: season)
                    }
                    .navigationDestination(for: RaceWinnerDestination.self) { destination in
                        coordinator.makeRaceWinnerView(for: destination.season)
                    }
            }
            .preferredColorScheme(nil) // Allows system dark/light mode switching
        }
    }
}
