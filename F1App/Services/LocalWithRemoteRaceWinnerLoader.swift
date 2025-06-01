//
//  LocalWithRemoteRaceWinnerLoader.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation

/// Decorator that combines local and remote race winner loading
public class LocalWithRemoteRaceWinnerLoader: RaceWinnerLoader {
    private let localLoader: LocalRaceWinnerLoader
    private let remoteLoader: RemoteRaceWinnerLoader
    private let forceRemote: Bool
    
    public init(
        localLoader: LocalRaceWinnerLoader,
        remoteLoader: RemoteRaceWinnerLoader,
        forceRemote: Bool = false
    ) {
        self.localLoader = localLoader
        self.remoteLoader = remoteLoader
        self.forceRemote = forceRemote
    }
    
    public func fetch(from url: URL) async -> Result<[RaceWinner], Error> {
        // If force remote (e.g., pull-to-refresh), skip cache
        if forceRemote {
            return await fetchFromRemoteAndCache(url: url)
        }
        
        // Try local first
        let localResult = await localLoader.fetch(from: url)
        
        switch localResult {
        case .success(let raceWinners):
            AppLogger.logDataLoading(type: "race winners", source: "cache", count: raceWinners.count)
            return .success(raceWinners)
            
        case .failure(let error):
            // If local fails, try remote
            AppLogger.logCache("Local cache failed, trying remote", level: .info)
            AppLogger.debug("Cache failure details: \(error.localizedDescription)")
            return await fetchFromRemoteAndCache(url: url)
        }
    }
    
    /// Force refresh from remote (used for pull-to-refresh)
    public func forceRefresh(from url: URL) async -> Result<[RaceWinner], Error> {
        AppLogger.logCache("Force refreshing race winners from remote for \(url)")
        return await fetchFromRemoteAndCache(url: url)
    }
    
    /// Check if cached data is available for URL
    public func hasCachedData(for url: URL) -> Bool {
        return localLoader.hasCachedData(for: url)
    }
    
    /// Get last cache update timestamp for URL
    public func getLastUpdated(for url: URL) -> Date? {
        return localLoader.getCacheTimestamp(for: url)
    }
    
    /// Clear local cache for URL
    public func clearCache(for url: URL) throws {
        try localLoader.clearCache(for: url)
    }
    
    /// Clear all local cache
    public func clearAllCache() throws {
        try localLoader.clearAllCache()
    }
    
    // MARK: - Private
    
    private func fetchFromRemoteAndCache(url: URL) async -> Result<[RaceWinner], Error> {
        let remoteResult = await remoteLoader.fetch(from: url)
        
        switch remoteResult {
        case .success(let raceWinners):
            // Cache the remote data
            do {
                try localLoader.save(raceWinners, for: url)
                AppLogger.logCacheOperation(operation: "Saved", key: cacheKeyFor(url: url), success: true, itemCount: raceWinners.count)
            } catch {
                AppLogger.logError("Failed to cache race winners", error: error)
                // Don't fail the request if caching fails
            }
            return .success(raceWinners)
            
        case .failure(let error):
            // Remote failed, try to use stale cache as fallback
            AppLogger.logError("Remote fetch failed", error: error)
            
            // Try to get any cached data (even if expired) as fallback
            let cacheKey = cacheKeyFor(url: url)
            if let staleData = try? localLoader.localStorage.load([RaceWinner].self, forKey: cacheKey) {
                AppLogger.logCache("Using stale cache as fallback for \(cacheKey)")
                return .success(staleData.data)
            }
            
            return .failure(error)
        }
    }
    
    private func cacheKeyFor(url: URL) -> String {
        // Extract season from URL for cache key
        let urlString = url.absoluteString
        if let seasonMatch = urlString.range(of: #"seasons/(\d{4})"#, options: .regularExpression) {
            let season = String(urlString[seasonMatch]).replacingOccurrences(of: "seasons/", with: "")
            return "race_winners_\(season)"
        }
        
        // Fallback to URL hash
        return "race_winners_\(url.absoluteString.hashValue)"
    }
}

// MARK: - Convenience Factory

extension LocalWithRemoteRaceWinnerLoader {
    /// Create with default configuration
    public static func makeDefault(networkService: NetworkService? = nil) -> LocalWithRemoteRaceWinnerLoader {
        let localStorage = try! FileBasedLocalStorage()
        let localLoader = LocalRaceWinnerLoader(localStorage: localStorage)
        let remoteLoader = RemoteRaceWinnerLoader(networkService: networkService ?? URLSessionNetworkService())
        
        return LocalWithRemoteRaceWinnerLoader(
            localLoader: localLoader,
            remoteLoader: remoteLoader
        )
    }
    
    /// Create with force remote configuration (for pull-to-refresh)
    public static func makeForceRemote(networkService: NetworkService? = nil) -> LocalWithRemoteRaceWinnerLoader {
        let localStorage = try! FileBasedLocalStorage()
        let localLoader = LocalRaceWinnerLoader(localStorage: localStorage)
        let remoteLoader = RemoteRaceWinnerLoader(networkService: networkService ?? URLSessionNetworkService())
        
        return LocalWithRemoteRaceWinnerLoader(
            localLoader: localLoader,
            remoteLoader: remoteLoader,
            forceRemote: true
        )
    }
} 