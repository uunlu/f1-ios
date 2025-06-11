//
//  RaceWinner.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation

public struct RaceWinner: Codable {
    public let seasonDriverId: String?
    public let seasonConstructorId: String?
    public let constructorName: String
    public let driver: Driver
    public let round: String
    public let seasonName: String
    public let isChampion: Bool
    public let raceCompletionTime: String
    
    private enum CodingKeys: String, CodingKey {
        case seasonDriverId = "season_driver_id"
        case seasonConstructorId = "season_constructor_id"
        case constructorName = "constructor_name"
        case driver
        case round
        case seasonName = "season_name"
        case isChampion = "champion"
        case raceCompletionTime = "time"
    }
}

public struct Driver: Codable {
    public let driverId: String
    public let familyName: String
    public let givenName: String
    
    private enum CodingKeys: String, CodingKey {
        case driverId = "driver_id"
        case familyName = "family_name"
        case givenName = "given_name"
    }
}
