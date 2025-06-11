//
//  LocalSeasonLoader.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation
import UIKit

/// Local loader for season data with caching support
public class LocalSeasonLoader: SeasonLoader {
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
                return LocalizedStrings.noSeasonsFound
            case .dataCorrupted:
                return LocalizedStrings.dataError
            case .invalidationRequired:
                return "Cache invalidation required"
            }
        }
    }
    
    internal let localStorage: LocalStorage
    private let invalidationStrategy: CacheInvalidationStrategy
    internal let cacheKey: String
    
    // Singleton storage instances to prevent memory leaks
    private static var sharedFileStorage: FileBasedLocalStorage?
    private static var sharedUserDefaultsStorage: UserDefaultsLocalStorage?
    
    public init(
        localStorage: LocalStorage? = nil,
        invalidationStrategy: CacheInvalidationStrategy = TimeBased(timeInterval: 1800),
        cacheKey: String = "seasons"
    ) {
        // Use provided storage or create/reuse shared instance
        if let localStorage = localStorage {
            self.localStorage = localStorage
        } else {
            // Try to reuse existing instance or create new one safely
            if LocalSeasonLoader.sharedFileStorage == nil {
                do {
                    LocalSeasonLoader.sharedFileStorage = try FileBasedLocalStorage()
                } catch {
                    AppLogger.debug("Failed to create file storage, falling back to UserDefaults: \(error)")
                    if LocalSeasonLoader.sharedUserDefaultsStorage == nil {
                        LocalSeasonLoader.sharedUserDefaultsStorage = UserDefaultsLocalStorage()
                    }
                }
            }
            
            self.localStorage = LocalSeasonLoader.sharedFileStorage ??
            LocalSeasonLoader.sharedUserDefaultsStorage ?? UserDefaultsLocalStorage()
        }
        
        self.invalidationStrategy = invalidationStrategy
        self.cacheKey = cacheKey
        
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
        LocalSeasonLoader.sharedFileStorage = nil
        LocalSeasonLoader.sharedUserDefaultsStorage = nil
    }
    
    public func fetch(from url: URL) async -> Result<[Season], Error> {
        do {
            // Try to load cached data
            guard let cachedData = try localStorage.load([Season].self, forKey: cacheKey) else {
                return .failure(LocalError.dataNotFound)
            }
            
            // Check if cache should be invalidated
            if invalidationStrategy.shouldInvalidateCache(for: cacheKey, cachedDate: cachedData.timestamp) {
                return .failure(LocalError.invalidationRequired)
            }
            
            AppLogger.debug("✅ Loaded seasons from local cache (cached: \(cachedData.timestamp))")
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
    
    /// Save seasons to local cache
    public func save(_ seasons: [Season]) throws {
        try localStorage.save(seasons, forKey: cacheKey)
        AppLogger.debug("💾 Saved \(seasons.count) seasons to local cache")
    }
    
    /// Clear cached seasons
    public func clearCache() throws {
        try localStorage.remove(forKey: cacheKey)
        AppLogger.debug("🗑️ Cleared seasons cache")
    }
    
    /// Check if valid cached data exists
    public func hasCachedData() -> Bool {
        do {
            guard let cachedData = try localStorage.load([Season].self, forKey: cacheKey) else {
                return false
            }
            
            return !invalidationStrategy.shouldInvalidateCache(for: cacheKey, cachedDate: cachedData.timestamp)
        } catch {
            return false
        }
    }
    
    /// Get cache timestamp
    public func getCacheTimestamp() -> Date? {
        do {
            let cachedData = try localStorage.load([Season].self, forKey: cacheKey)
            return cachedData?.timestamp
        } catch {
            return nil
        }
    }
} 
