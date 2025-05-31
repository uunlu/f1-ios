//
//  RaceWinner.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation

struct RaceWinner: Codable {
    let seasonDriverId: String?
    let seasonConstructorId: String
    let constructorName: String
    let driver: Driver
    let round: String
    let seasonName: String
    let champion: Bool
}

struct Driver: Codable {
    let driverId: String
    let familyName: String
    let givenName: String
}
