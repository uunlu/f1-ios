//
//  MapperTests.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

@testable import F1App
import XCTest

final class MapperTests: XCTestCase {
    func testRaceWinnerMapperConvertsToDomain() {
        // Given
        let driver = Driver(driverId: "verstappen", familyName: "Verstappen", givenName: "Max")
        let dto = RaceWinner(
            seasonDriverId: "verstappen_2023",
            seasonConstructorId: "redbull_2023",
            constructorName: "Red Bull Racing",
            driver: driver,
            round: "5",
            seasonName: "2023",
            isChampion: true,
            raceCompletionTime: "1:32:15.456"
        )
        
        // When
        let domainModel = RaceWinnerMapper.toDomain(dto)
        
        // Then
        XCTAssertEqual(domainModel.season, "2023")
        XCTAssertEqual(domainModel.round, "5")
        XCTAssertEqual(domainModel.driver.fullName, "Verstappen")
        XCTAssertEqual(domainModel.constructor.name, "Red Bull Racing")
        XCTAssertTrue(domainModel.isChampion)
        XCTAssertEqual(domainModel.raceCompletionTime, "1:32:15.456")
    }
}
