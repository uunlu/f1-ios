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
    @Published var isRefreshing = false
    @Published var error: String?
    
    private let seasonLoader: SeasonLoader
    private var loadTask: Task<Void, Never>?
    private var refreshTask: Task<Void, Never>?
    
    init(seasonLoader: SeasonLoader) {
        self.seasonLoader = seasonLoader
    }
    
    deinit {
        loadTask?.cancel()
        refreshTask?.cancel()
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
                AppLogger.logViewModel("Successfully loaded \(seasons.count) seasons")
                await updateState(error: nil, seasons: seasons)
            case .failure(let error):
                AppLogger.logError("Failed to load seasons", error: error)
                await updateState(error: error.localizedDescription, seasons: [])
            }
        }
    }
    
    func refreshSeasons() {
        // Cancel any existing refresh task
        refreshTask?.cancel()
        
        // Update UI state on main thread
        Task { @MainActor in
            self.isRefreshing = true
        }
        
        AppLogger.logViewModel("Pull-to-refresh triggered for seasons")
        
        // Create and store the refresh task
        refreshTask = Task {
            guard let url = APIConfig.seasonChampionsURL() else {
                await updateRefreshState(error: "Invalid URL configuration", seasons: [])
                AppLogger.logError("Invalid URL configuration for seasons refresh")
                return
            }
            
            // Use force refresh if available, otherwise fallback to regular fetch
            let result: Result<[Season], Error>
            if let localWithRemoteLoader = seasonLoader as? LocalWithRemoteSeasonLoader {
                result = await localWithRemoteLoader.forceRefresh(from: url)
            } else {
                result = await seasonLoader.fetch(from: url)
            }
            
            // Only update if this task hasn't been cancelled
            guard !Task.isCancelled else {
                AppLogger.debug("Seasons refresh task cancelled")
                return
            }
            
            // Process results and update UI on main thread
            switch result {
            case .success(let seasons):
                AppLogger.logViewModel("Successfully refreshed \(seasons.count) seasons")
                await updateRefreshState(error: nil, seasons: seasons)
            case .failure(let error):
                AppLogger.logError("Failed to refresh seasons", error: error)
                // For refresh failures, just update error but keep existing data
                await updateRefreshState(error: error.localizedDescription, seasons: nil)
            }
        }
    }
    
    func cancelLoading() {
        loadTask?.cancel()
        refreshTask?.cancel()
        
        Task { @MainActor in
            self.isLoading = false
            self.isRefreshing = false
        }
    }
    
    // Helper method to update UI state on the main thread for regular loading
    @MainActor
    private func updateState(error: String?, seasons: [Season]) {
        self.error = error
        self.seasons = seasons
        self.isLoading = false
    }
    
    // Helper method to update UI state on the main thread for refresh
    @MainActor
    private func updateRefreshState(error: String?, seasons: [Season]?) {
        if let error = error {
            self.error = error
        } else {
            self.error = nil
        }
        
        // Only update seasons if new data is provided (success case)
        if let seasons = seasons {
            self.seasons = seasons
        }
        
        self.isRefreshing = false
    }
}
