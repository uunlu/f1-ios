//
//  LocalWithRemoteRaceWinnerLoader.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation

/// A simple decorator that tries local first, then remote for race winners
class LocalWithRemoteRaceWinnerLoader: RaceWinnerLoader {
    private let localLoader: LocalRaceWinnerLoader
    private let remoteLoader: RemoteRaceWinnerLoader
    
    init(localLoader: LocalRaceWinnerLoader, remoteLoader: RemoteRaceWinnerLoader) {
        self.localLoader = localLoader
        self.remoteLoader = remoteLoader
    }
    
    func fetch(from url: URL) async -> Result<[RaceWinner], Error> {
        // Try local first
        let localResult = await localLoader.fetch(from: url)
        
        switch localResult {
        case .success(let raceWinners):
            return .success(raceWinners)
        case .failure:
            // If local fails, try remote
            let remoteResult = await remoteLoader.fetch(from: url)
            
            // If remote succeeds, cache the data
            if case .success(let raceWinners) = remoteResult {
                do {
                    try localLoader.save(raceWinners, for: url)
                } catch {
                    // Don't fail if caching fails
                    AppLogger.logError("Failed to cache race winners", error: error)
                }
            }
            
            return remoteResult
        }
    }
} 
