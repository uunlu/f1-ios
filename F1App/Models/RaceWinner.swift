//
//  RaceWinner.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation

public struct RaceWinner: Codable {
    public let seasonDriverId: String?
    public let seasonConstructorId: String
    public let constructorName: String
    public let driver: Driver
    public let round: String
    public let seasonName: String
    public let champion: Bool
}

public struct Driver: Codable {
    public let driverId: String
    public let familyName: String
    public let givenName: String
}
