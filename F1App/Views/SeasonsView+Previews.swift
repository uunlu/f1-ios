//
//  SeasonsView+Previews.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import SwiftUI

#Preview("Default - Dark Mode") {
    SeasonsView(
        viewModel: DependencyContainer
            .createForPreviews()
            .makeSeasonsViewModel()
    )
    .environmentObject(AppCoordinator(dependencyContainer: DependencyContainer.createForPreviews()))
    .preferredColorScheme(.dark)
}

#Preview("Loading State") {
    SeasonsView(
        viewModel: SeasonsViewModel(seasonLoader: PreviewLoadingSeasonLoader())
    )
    .environmentObject(AppCoordinator(dependencyContainer: DependencyContainer.createForPreviews()))
    .preferredColorScheme(.light)
}

#Preview("With Mock Data") {
    let mockLoader = MockSeasonLoader()
    mockLoader.setSuccessResponse([
        Season(driver: "Max Verstappen", season: "2023", constructor: "Red Bull Racing"),
        Season(driver: "Max Verstappen", season: "2022", constructor: "Red Bull Racing"),
        Season(driver: "Max Verstappen", season: "2021", constructor: "Red Bull Racing")
    ])
    
    return SeasonsView(
        viewModel: SeasonsViewModel(seasonLoader: mockLoader)
    )
    .environmentObject(AppCoordinator(dependencyContainer: DependencyContainer.createForPreviews()))
    .preferredColorScheme(.dark)
}
