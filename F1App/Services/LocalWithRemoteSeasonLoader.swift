//
//  LocalWithRemoteSeasonLoader.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation

/// A simple decorator that tries local first, then remote
class LocalWithRemoteSeasonLoader: SeasonLoader {
    private let localLoader: LocalSeasonLoader
    private let remoteLoader: RemoteSeasonLoader
    
    init(localLoader: LocalSeasonLoader, remoteLoader: RemoteSeasonLoader) {
        self.localLoader = localLoader
        self.remoteLoader = remoteLoader
    }
    
    func fetch(from url: URL) async -> Result<[Season], Error> {
        // Try local first
        let localResult = await localLoader.fetch(from: url)
        
        switch localResult {
        case .success(let seasons):
            return .success(seasons)
        case .failure:
            // If local fails, try remote
            return await remoteLoader.fetch(from: url)
        }
    }
    
    /// Force refresh from remote (used for pull-to-refresh)
    func forceRefresh(from url: URL) async -> Result<[Season], Error> {
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
} 
