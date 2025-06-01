//
//  SeasonsViewModel.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation

class SeasonsViewModel: ObservableObject {
    @Published var seasons: [Season] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let seasonLoader: SeasonLoader
    private var loadTask: Task<Void, Never>?
    
    init(seasonLoader: SeasonLoader) {
        self.seasonLoader = seasonLoader
    }
    
    deinit {
        loadTask?.cancel()
    }
    
    func loadSeasons() {
        // Cancel any existing load task
        loadTask?.cancel()
        
        // Update UI state on main thread
        Task { @MainActor in
            self.isLoading = true
            self.error = nil
        }
        
        AppLogger.logViewModel("Loading seasons data")
        
        // Create and store the task
        loadTask = Task {
            guard let url = APIConfig.seasonChampionsURL() else {
                await updateState(error: "Invalid URL configuration", seasons: [])
                AppLogger.logError("Invalid URL configuration for seasons")
                return
            }
            
            // Perform network operation off the main thread
            let result = await seasonLoader.fetch(from: url)
            
            // Only update if this task hasn't been cancelled
            guard !Task.isCancelled else {
                AppLogger.debug("Seasons loading task cancelled")
                return
            }
            
            // Process results and update UI on main thread
            switch result {
            case .success(let seasons):
                AppLogger.logViewModel("Successfully loaded $seasons.count) seasons")
                await updateState(error: nil, seasons: seasons)
            case .failure(let error):
                AppLogger.logError("Failed to load seasons", error: error)
                await updateState(error: error.localizedDescription, seasons: [])
            }
        }
    }
    
    func cancelLoading() {
        loadTask?.cancel()
        
        Task { @MainActor in
            self.isLoading = false
        }
    }
    
    // Helper method to update UI state on the main thread
    @MainActor
    private func updateState(error: String?, seasons: [Season]) {
        self.error = error
        self.seasons = seasons
        self.isLoading = false
    }
}
