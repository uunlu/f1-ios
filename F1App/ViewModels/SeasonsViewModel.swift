//
//  SeasonsViewModel.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation
import Combine

@MainActor
class SeasonsViewModel: ObservableObject {
    @Published var seasons: [Season] = []
    @Published var isLoading = false
    @Published var isRefreshing = false
    @Published var error: String?
    
    // Network-aware additions
    @Published var networkState: NetworkLoadingState = .connected
    @Published var showOfflineBanner = false
    @Published var lastUpdated: Date?
    @Published var hasLocalData = false
    
    private let seasonLoader: SeasonLoader
    private var loadTask: Task<Void, Never>?
    private var refreshTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    private var wasOffline = false
    
    init(seasonLoader: SeasonLoader) {
        self.seasonLoader = seasonLoader
        
        setupNetworkMonitoring()
        updateLocalDataStatus()
    }
    
    deinit {
        loadTask?.cancel()
        refreshTask?.cancel()
        cancellables.removeAll()
    }
    
    private func setupNetworkMonitoring() {
        // Only setup network monitoring if loader supports it
        guard let networkAwareLoader = seasonLoader as? NetworkAwareSeasonLoading else {
            return
        }
        
        // Monitor network state changes through the season loader
        networkAwareLoader.networkStatusPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] networkState in
                self?.handleNetworkStateChange(networkState: networkState)
            }
            .store(in: &cancellables)
    }
    
    private func handleNetworkStateChange(networkState: NetworkLoadingState) {
        let wasConnected = self.networkState == .connected
        self.networkState = networkState
        
        // Auto-retry when connection transitions from disconnected to connected
        if !wasConnected && seasons.isEmpty {
            AppLogger.logNetwork("Connection restored (was disconnected), auto-retrying data load")
            loadSeasons()
        }
        
        // Update offline banner state
        showOfflineBanner = (networkState == .offlineWithoutCache)
        
        // Track offline state for auto-retry (backup logic for edge cases)
        if networkState != .connected {
            wasOffline = true
        } else if wasOffline && networkState == .connected {
            wasOffline = false
        }
    }
    
    @MainActor
    private func updateLocalDataStatus() {
        if let networkAwareLoader = seasonLoader as? NetworkAwareSeasonLoading {
            hasLocalData = networkAwareLoader.hasCachedData()
            lastUpdated = networkAwareLoader.getCacheTimestamp()
        } else if seasonLoader is LocalWithRemoteSeasonLoader {
            // Fallback for existing loader - try to access local loader
            // This maintains compatibility with existing code
            hasLocalData = !seasons.isEmpty
        }
    }
    
    func loadSeasons() {
        // Cancel any existing load task
        loadTask?.cancel()
        
        // Update UI state on main thread
        Task { @MainActor in
            self.isLoading = true
            self.error = nil
            self.showOfflineBanner = false
        }
        
        AppLogger.logViewModel("Loading seasons data")
        
        // Create and store the task
        loadTask = Task {
            guard let url = APIConfig.seasonChampionsURL() else {
                updateState(error: "Invalid URL configuration", seasons: [])
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
                updateState(error: nil, seasons: seasons)
            case .failure(let error):
                AppLogger.logError("Failed to load seasons", error: error)
                
                // Handle specific network-aware errors
                if error is NetworkAwareError {
                    updateOfflineState(error: error.localizedDescription)
                } else {
                    updateState(error: error.localizedDescription, seasons: [])
                }
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
                updateRefreshState(error: "Invalid URL configuration", seasons: [])
                AppLogger.logError("Invalid URL configuration for seasons refresh")
                return
            }
            
            // Use force refresh if available, otherwise fallback to regular fetch
            let result: Result<[Season], Error>
            if let networkAwareLoader = seasonLoader as? NetworkAwareSeasonLoading {
                result = await networkAwareLoader.forceRefresh(from: url)
            } else if let localWithRemoteLoader = seasonLoader as? LocalWithRemoteSeasonLoader {
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
                updateRefreshState(error: nil, seasons: seasons)
            case .failure(let error):
                AppLogger.logError("Failed to refresh seasons", error: error)
                // For refresh failures, just update error but keep existing data
                updateRefreshState(error: error.localizedDescription, seasons: nil)
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
        self.showOfflineBanner = false
        updateLocalDataStatus()
    }
    
    // Helper method to update UI state for offline scenarios
    @MainActor
    private func updateOfflineState(error: String) {
        self.error = error
        self.isLoading = false
        self.showOfflineBanner = (networkState == .offlineWithoutCache)
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
        updateLocalDataStatus()
    }
}
