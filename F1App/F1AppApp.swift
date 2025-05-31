//
//  F1AppApp.swift
//  F1App
//
//  Created by Ugur Unlu on 29/05/2025.
//

import SwiftUI

@main
struct F1AppApp: App {
    @StateObject private var coordinator = AppCoordinator()
    @StateObject private var seasonsViewModel = SeasonsViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                SeasonsView()
                    .environmentObject(coordinator)
                    .environmentObject(seasonsViewModel)
            }
        }
    }
}
