//
//  LocalWithRemoteSeasonLoader.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation

/// Decorator that combines local and remote season loading
public class LocalWithRemoteSeasonLoader: SeasonLoader {
    private let localLoader: LocalSeasonLoader
    private let remoteLoader: RemoteSeasonLoader
    private let forceRemote: Bool
    
    public init(
        localLoader: LocalSeasonLoader,
        remoteLoader: RemoteSeasonLoader,
        forceRemote: Bool = false
    ) {
        self.localLoader = localLoader
        self.remoteLoader = remoteLoader
        self.forceRemote = forceRemote
    }
    
    public func fetch(from url: URL) async -> Result<[Season], Error> {
        // If force remote (e.g., pull-to-refresh), skip cache
        if forceRemote {
            return await fetchFromRemoteAndCache(url: url)
        }
        
        // Try local first
        let localResult = await localLoader.fetch(from: url)
        
        switch localResult {
        case .success(let seasons):
            AppLogger.logDataLoading(type: "seasons", source: "cache", count: seasons.count)
            return .success(seasons)
            
        case .failure(let error):
            // If local fails, try remote
            AppLogger.logCache("Local cache failed, trying remote")
            AppLogger.debug("Cache failure details: \(error.localizedDescription)")
            return await fetchFromRemoteAndCache(url: url)
        }
    }
    
    /// Force refresh from remote (used for pull-to-refresh)
    public func forceRefresh(from url: URL) async -> Result<[Season], Error> {
        AppLogger.logCache("Force refreshing seasons from remote")
        return await fetchFromRemoteAndCache(url: url)
    }
    
    /// Check if cached data is available
    public func hasCachedData() -> Bool {
        return localLoader.hasCachedData()
    }
    
    /// Get last cache update timestamp
    public func getLastUpdated() -> Date? {
        return localLoader.getCacheTimestamp()
    }
    
    /// Clear local cache
    public func clearCache() throws {
        try localLoader.clearCache()
    }
    
    // MARK: - Private
    
    private func fetchFromRemoteAndCache(url: URL) async -> Result<[Season], Error> {
        let remoteResult = await remoteLoader.fetch(from: url)
        
        switch remoteResult {
        case .success(let seasons):
            // Cache the remote data
            do {
                try localLoader.save(seasons)
                print("💾 Cached \(seasons.count) seasons from remote")
            } catch {
                print("⚠️ Failed to cache seasons: \(error.localizedDescription)")
                // Don't fail the request if caching fails
            }
            return .success(seasons)
            
        case .failure(let error):
            // Remote failed, try to use stale cache as fallback
            print("❌ Remote fetch failed: \(error.localizedDescription)")
            
            // Try to get any cached data (even if expired) as fallback
            if let staleData = try? localLoader.localStorage.load([Season].self, forKey: localLoader.cacheKey) {
                print("🕰️ Using stale cache as fallback")
                return .success(staleData.data)
            }
            
            return .failure(error)
        }
    }
}

// MARK: - Convenience Factory

extension LocalWithRemoteSeasonLoader {
    /// Create with default configuration
    public static func makeDefault(networkService: NetworkService) -> LocalWithRemoteSeasonLoader {
        let localStorage = try! FileBasedLocalStorage()
        let localLoader = LocalSeasonLoader(localStorage: localStorage)
        let remoteLoader = RemoteSeasonLoader(networkService: networkService)
        
        return LocalWithRemoteSeasonLoader(
            localLoader: localLoader,
            remoteLoader: remoteLoader
        )
    }
    
    /// Create with force remote configuration (for pull-to-refresh)
    public static func makeForceRemote(networkService: NetworkService) -> LocalWithRemoteSeasonLoader {
        let localStorage = try! FileBasedLocalStorage()
        let localLoader = LocalSeasonLoader(localStorage: localStorage)
        let remoteLoader = RemoteSeasonLoader(networkService: networkService)
        
        return LocalWithRemoteSeasonLoader(
            localLoader: localLoader,
            remoteLoader: remoteLoader,
            forceRemote: true
        )
    }
} 