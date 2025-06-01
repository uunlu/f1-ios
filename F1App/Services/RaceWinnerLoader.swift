//
//  RaceWinnerLoader.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation

public protocol RaceWinnerLoader {
    func fetch(from url: URL) async -> Result<[RaceWinner], Error>
}

public class RemoteRaceWinnerLoader: RaceWinnerLoader {
    public enum Error: Swift.Error {
        case decodingFailure
    }
    let networkService: NetworkService
    
    public init(networkService: NetworkService = URLSessionNetworkService()) {
        self.networkService = networkService
    }
    
    public func fetch(from url: URL) async -> Result<[RaceWinner], Swift.Error> {
        let startTime = CFAbsoluteTimeGetCurrent()
        let request = URLRequest(url: url)
        
        AppLogger.logNetwork("Fetching race winners from \(url.absoluteString)")
        
        switch await networkService.fetch(from: request) {
        case .success(let data):
            let duration = CFAbsoluteTimeGetCurrent() - startTime
            do {
                let result = try JSONDecoder().decode([RaceWinner].self, from: data)
                AppLogger.logNetworkRequest(
                    url: url,
                    success: true,
                    duration: duration,
                    dataSize: data.count
                )
                AppLogger.logDataLoading(type: "race winners", source: "remote", count: result.count, duration: duration)
                return .success(result)
            } catch {
                AppLogger.logError("Failed to decode race winners data", error: error)
                return .failure(Error.decodingFailure)
            }
        case .failure(let failure):
            let duration = CFAbsoluteTimeGetCurrent() - startTime
            AppLogger.logNetworkRequest(
                url: url,
                success: false,
                duration: duration
            )
            AppLogger.logError("Network request failed for race winners", error: failure)
            return .failure(failure)
        }
    }
}
