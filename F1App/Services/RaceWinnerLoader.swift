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

public struct RaceWinnerDomainModel: Identifiable {
    public var id: String { "$season)-$round)" }
    public let season: String
    public let round: String
    public let driver: Driver
    public let constructor: Constructor
    public let time: String?
    public let isChampion: Bool
    
    /// Domain model for drivers
    public struct Driver {
        public let id: String
        public let fullName: String
    }
    
    /// Domain model for constructors
    public struct Constructor {
        public let id: String
        public let name: String
    }
}

public struct RaceWinnerMapper {
    /// Convert a DTO to a domain model
    static func toDomain(_ dto: RaceWinner) -> RaceWinnerDomainModel {
        return RaceWinnerDomainModel(
            season: dto.seasonName,
            round: dto.round,
            driver: RaceWinnerDomainModel.Driver(
                id: dto.driver.driverId,
                fullName: dto.driver.familyName
            ),
            constructor: RaceWinnerDomainModel.Constructor(
                id: dto.seasonConstructorId,
                name: dto.constructorName
            ),
            time: "",
            isChampion: dto.champion
        )
    }
    
    /// Convert multiple DTOs to domain models
    static func toDomain(_ dtos: [RaceWinner]) -> [RaceWinnerDomainModel] {
        return dtos.map(toDomain)
    }
}
