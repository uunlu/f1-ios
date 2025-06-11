//
//  NetworkAwareSeasonLoader.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Combine
import Foundation

// MARK: - Network Status Protocol
protocol NetworkStatusProvider {
    var isConnected: Bool { get async }
    var networkStatusPublisher: AnyPublisher<Bool, Never> { get }
}

// MARK: - Season Loading with Network Status
protocol NetworkAwareSeasonLoading: SeasonLoader {
    var networkStatusPublisher: AnyPublisher<NetworkLoadingState, Never> { get }
    func hasCachedData() -> Bool
    func getCacheTimestamp() -> Date?
    func forceRefresh(from url: URL) async -> Result<[Season], Error>
}

// MARK: - Network Loading State
enum NetworkLoadingState {
    case connected
    case disconnected
    case offlineWithCache
    case offlineWithoutCache
}

// MARK: - NetworkMonitor as StatusProvider
extension NetworkMonitor: NetworkStatusProvider {
    var networkStatusPublisher: AnyPublisher<Bool, Never> {
        $isConnected.eraseToAnyPublisher()
    }
}

/// Enhanced season loader that considers network state
/// Uses protocol-based approach without exposing NetworkMonitor to view models
class NetworkAwareSeasonLoader: NetworkAwareSeasonLoading {
    private let localLoader: LocalSeasonLoader
    private let remoteLoader: RemoteSeasonLoader
    private let networkStatusProvider: NetworkStatusProvider
    private let networkStateSubject = CurrentValueSubject<NetworkLoadingState, Never>(.connected)
    
    var networkStatusPublisher: AnyPublisher<NetworkLoadingState, Never> {
        networkStateSubject.eraseToAnyPublisher()
    }
    
    init(localLoader: LocalSeasonLoader, remoteLoader: RemoteSeasonLoader, networkStatusProvider: NetworkStatusProvider = NetworkMonitor.shared) {
        self.localLoader = localLoader
        self.remoteLoader = remoteLoader
        self.networkStatusProvider = networkStatusProvider
        
        // Subscribe to network changes and update our state
        Task {
            await setupNetworkMonitoring()
        }
    }
    
    private func setupNetworkMonitoring() async {
        networkStatusProvider.networkStatusPublisher
            .sink { [weak self] isConnected in
                Task {
                    await self?.updateNetworkState(isConnected: isConnected)
                }
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    @MainActor
    private func updateNetworkState(isConnected: Bool) {
        let hasCache = hasCachedData()
        
        if isConnected {
            networkStateSubject.send(.connected)
        } else if hasCache {
            networkStateSubject.send(.offlineWithCache)
        } else {
            networkStateSubject.send(.offlineWithoutCache)
        }
    }
    
    func fetch(from url: URL) async -> Result<[Season], Error> {
        // Always try local first (same as original behavior)
        let localResult = await localLoader.fetch(from: url)
        
        switch localResult {
        case .success(let seasons):
            AppLogger.logCache("Using cached seasons data")
            return .success(seasons)
        case .failure(let localError):
            AppLogger.logError(localError.localizedDescription)
            // Local failed, check network state
            guard await networkStatusProvider.isConnected else {
                AppLogger.logNetwork("No network connection and no local data available")
                return .failure(NetworkAwareError.noInternetAndNoCache(LocalizedStrings.noInternetAndNoCache))
            }
            
            // Network available, try remote (original behavior)
            AppLogger.logNetwork("Local data not available, fetching from remote")
            let remoteResult = await remoteLoader.fetch(from: url)
            
            // Cache successful remote result (original behavior)
            if case .success(let seasons) = remoteResult {
                do {
                    try localLoader.save(seasons)
                    AppLogger.logCache("Cached \(seasons.count) seasons from remote")
                } catch {
                    AppLogger.logError("Failed to cache remote data", error: error)
                    // Don't fail the operation if caching fails
                }
            }
            
            return remoteResult
        }
    }
    
    /// Force refresh from remote (enhanced with network awareness)
    func forceRefresh(from url: URL) async -> Result<[Season], Error> {
        guard await networkStatusProvider.isConnected else {
            AppLogger.logNetwork("Cannot force refresh - no network connection")
            return .failure(NetworkAwareError.noInternetConnection)
        }
        
        AppLogger.logCache("Force refreshing seasons from remote")
        
        // Always fetch from remote for pull-to-refresh
        let remoteResult = await remoteLoader.fetch(from: url)
        
        // If remote succeeds, try to update local cache
        if case .success(let seasons) = remoteResult {
            do {
                try localLoader.save(seasons)
                AppLogger.logCache("Updated local cache with \(seasons.count) seasons")
            } catch {
                AppLogger.logError("Failed to update cache after refresh", error: error)
                // Don't fail the operation if cache update fails
            }
        }
        
        return remoteResult
    }
    
    /// Check if valid cached data exists
    func hasCachedData() -> Bool {
        localLoader.hasCachedData()
    }
    
    /// Get cache timestamp
    func getCacheTimestamp() -> Date? {
        localLoader.getCacheTimestamp()
    }
}

// MARK: - Network-Aware Errors
enum NetworkAwareError: Error, LocalizedError {
    case noInternetConnection
    case noInternetAndNoCache(String)
    
    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return LocalizedStrings.networkError
        case .noInternetAndNoCache(let message):
            return message
        }
    }
} 
