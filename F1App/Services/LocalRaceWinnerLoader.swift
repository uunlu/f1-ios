//
//  LocalRaceWinnerLoader.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation
import UIKit

/// Local loader for race winner data with caching support
class LocalRaceWinnerLoader: RaceWinnerLoader {
    private let localStorage: LocalStorage
    
    init(localStorage: LocalStorage) {
        self.localStorage = localStorage
    }
    
    /// Creates a safe cache key from URL
    private func cacheKey(for url: URL) -> String {
        // Generate a consistent hash value from the entire URL
        let urlString = url.absoluteString
        return urlString.data(using: .utf8)?
            .base64EncodedString()
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "+", with: "-")
            .trimmingCharacters(in: .punctuationCharacters) ?? urlString
    }
    
    func fetch(from url: URL) async -> Result<[RaceWinner], Error> {
        do {
            let key = cacheKey(for: url)
            guard let cachedData = try localStorage.load([RaceWinner].self, forKey: key) else {
                return .failure(NSError(
                    domain: "Cache",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "No cached data found"]
                ))
            }
            
            AppLogger.logCache("Loaded \(cachedData.data.count) race winners from cache")
            return .success(cachedData.data)
        } catch {
            AppLogger.logError("Failed to load from cache", error: error)
            return .failure(error)
        }
    }
    
    /// Save race winners to local cache using URL as key (for consistency with fetch)
    func save(_ raceWinners: [RaceWinner], for url: URL) throws {
        let key = cacheKey(for: url)
        try localStorage.save(raceWinners, forKey: key)
        AppLogger.logCache("Saved \(raceWinners.count) race winners to cache for \(url.absoluteString)")
    }
    
    /// Save race winners to local cache with custom key
    func save(_ raceWinners: [RaceWinner], cacheKey: String) throws {
        try localStorage.save(raceWinners, forKey: cacheKey)
        AppLogger.logCache("Saved \(raceWinners.count) race winners to cache with key: \(cacheKey)")
    }
    
    /// Clear cached race winners for URL
    func clearCache(for url: URL) throws {
        let key = cacheKey(for: url)
        try localStorage.remove(forKey: key)
        AppLogger.logCache("Cleared race winners cache for \(url.absoluteString)")
    }
    
    /// Clear cached race winners with custom key
    func clearCache(cacheKey: String) throws {
        try localStorage.remove(forKey: cacheKey)
        AppLogger.logCache("Cleared race winners cache for key: \(cacheKey)")
    }
} 
