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
} 