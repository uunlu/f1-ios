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
    private let cacheKey: String
    
    init(localStorage: LocalStorage, cacheKey: String = "race_winners") {
        self.localStorage = localStorage
        self.cacheKey = cacheKey
    }
    
    func fetch(from url: URL) async -> Result<[RaceWinner], Error> {
        do {
            guard let cachedData = try localStorage.load([RaceWinner].self, forKey: cacheKey) else {
                return .failure(NSError(domain: "Cache", code: 404, userInfo: [NSLocalizedDescriptionKey: "No cached data found"]))
            }
            
            return .success(cachedData.data)
        } catch {
            return .failure(error)
        }
    }
    
    /// Save race winners to local cache
    func save(_ raceWinners: [RaceWinner]) throws {
        try localStorage.save(raceWinners, forKey: cacheKey)
    }
    
    /// Clear cached race winners
    func clearCache() throws {
        try localStorage.remove(forKey: cacheKey)
    }
} 
