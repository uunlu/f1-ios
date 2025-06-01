//
//  LocalRaceWinnerLoader.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation
import UIKit

/// Local loader for race winner data with caching support
public class LocalRaceWinnerLoader: RaceWinnerLoader {
    public enum LocalError: Error, LocalizedError {
        case storageNotAvailable
        case dataNotFound
        case dataCorrupted
        case invalidationRequired
        
        public var errorDescription: String? {
            switch self {
            case .storageNotAvailable:
                return LocalizedStrings.cacheError
            case .dataNotFound:
                return LocalizedStrings.noRaceWinnersFound
            case .dataCorrupted:
                return LocalizedStrings.dataError
            case .invalidationRequired:
                return "Cache invalidation required"
            }
        }
    }
    
    internal let localStorage: LocalStorage
    private let invalidationStrategy: CacheInvalidationStrategy
    
    // Singleton storage instances to prevent memory leaks
    private static var sharedFileStorage: FileBasedLocalStorage?
    private static var sharedUserDefaultsStorage: UserDefaultsLocalStorage?
    
    public init(
        localStorage: LocalStorage? = nil,
        invalidationStrategy: CacheInvalidationStrategy = TimeBased(timeInterval: 1800)
    ) {
        // Use provided storage or create/reuse shared instance
        if let localStorage = localStorage {
            self.localStorage = localStorage
        } else {
            // Try to reuse existing instance or create new one safely
            if LocalRaceWinnerLoader.sharedFileStorage == nil {
                do {
                    LocalRaceWinnerLoader.sharedFileStorage = try FileBasedLocalStorage()
                } catch {
                    AppLogger.logError("Failed to create file storage, falling back to UserDefaults", error: error)
                    if LocalRaceWinnerLoader.sharedUserDefaultsStorage == nil {
                        LocalRaceWinnerLoader.sharedUserDefaultsStorage = UserDefaultsLocalStorage()
                    }
                }
            }
            
            self.localStorage = LocalRaceWinnerLoader.sharedFileStorage ?? LocalRaceWinnerLoader.sharedUserDefaultsStorage ?? UserDefaultsLocalStorage()
        }
        
        self.invalidationStrategy = invalidationStrategy
        
        // Setup memory pressure handling
        setupMemoryWarningHandler()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupMemoryWarningHandler() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.handleMemoryWarning()
        }
    }
    
    private func handleMemoryWarning() {
        // Clear storage instances on memory pressure
        LocalRaceWinnerLoader.sharedFileStorage = nil
        LocalRaceWinnerLoader.sharedUserDefaultsStorage = nil
    }
    
    public func fetch(from url: URL) async -> Result<[RaceWinner], Error> {
        let cacheKey = cacheKeyFor(url: url)
        
        do {
            // Try to load cached data
            guard let cachedData = try localStorage.load([RaceWinner].self, forKey: cacheKey) else {
                return .failure(LocalError.dataNotFound)
            }
            
            // Check if cache should be invalidated
            if invalidationStrategy.shouldInvalidateCache(for: cacheKey, cachedDate: cachedData.timestamp) {
                return .failure(LocalError.invalidationRequired)
            }
            
            AppLogger.logDataLoading(type: "race winners", source: "local cache", count: cachedData.data.count)
            AppLogger.debug("Cache timestamp: \(cachedData.timestamp)")
            return .success(cachedData.data)
            
        } catch {
            if error is FileBasedLocalStorage.StorageError {
                return .failure(LocalError.storageNotAvailable)
            } else if error is UserDefaultsLocalStorage.StorageError {
                return .failure(LocalError.storageNotAvailable)
            } else {
                return .failure(LocalError.dataCorrupted)
            }
        }
    }
    
    /// Save race winners to local cache
    public func save(_ raceWinners: [RaceWinner], for url: URL) throws {
        let cacheKey = cacheKeyFor(url: url)
        try localStorage.save(raceWinners, forKey: cacheKey)
        AppLogger.logCacheOperation(operation: "Saved", key: cacheKey, success: true, itemCount: raceWinners.count)
    }
    
    /// Clear cached race winners for specific URL
    public func clearCache(for url: URL) throws {
        let cacheKey = cacheKeyFor(url: url)
        try localStorage.remove(forKey: cacheKey)
        AppLogger.logCacheOperation(operation: "Cleared", key: cacheKey, success: true)
    }
    
    /// Clear all cached race winners
    public func clearAllCache() throws {
        try localStorage.clearAll()
        AppLogger.logCache("Cleared all race winners cache")
    }
    
    /// Check if valid cached data exists for URL
    public func hasCachedData(for url: URL) -> Bool {
        let cacheKey = cacheKeyFor(url: url)
        
        do {
            guard let cachedData = try localStorage.load([RaceWinner].self, forKey: cacheKey) else {
                return false
            }
            
            return !invalidationStrategy.shouldInvalidateCache(for: cacheKey, cachedDate: cachedData.timestamp)
        } catch {
            return false
        }
    }
    
    /// Get cache timestamp for URL
    public func getCacheTimestamp(for url: URL) -> Date? {
        let cacheKey = cacheKeyFor(url: url)
        
        do {
            let cachedData = try localStorage.load([RaceWinner].self, forKey: cacheKey)
            return cachedData?.timestamp
        } catch {
            return nil
        }
    }
    
    // MARK: - Private
    
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
