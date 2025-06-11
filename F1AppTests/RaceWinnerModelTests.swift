//
//  RaceWinnerModelTests.swift
//  F1AppTests
//
//  Created by Ugur Unlu on 31/05/2025.
//

@testable import F1App
import XCTest

final class RaceWinnerModelTests: XCTestCase {
    
    func testRaceWinnerCodableConformance() throws {
        // Given
        let driver = Driver(driverId: "hamilton", familyName: "Hamilton", givenName: "Lewis")
        let raceWinner = RaceWinner(
            seasonDriverId: "hamilton_2020",
            seasonConstructorId: "mercedes_2020",
            constructorName: "Mercedes",
            driver: driver,
            round: "1",
            seasonName: "2020",
            isChampion: true,
            raceCompletionTime: "1:34:50.616"
        )
        
        // When
        let encoded = try JSONEncoder().encode(raceWinner)
        let decoded = try JSONDecoder().decode(RaceWinner.self, from: encoded)
        
        // Then
        XCTAssertEqual(decoded.constructorName, raceWinner.constructorName)
        XCTAssertEqual(decoded.driver.familyName, raceWinner.driver.familyName)
        XCTAssertEqual(decoded.isChampion, raceWinner.isChampion)
        XCTAssertEqual(decoded.raceCompletionTime, raceWinner.raceCompletionTime)
    }
    
    func testDriverCodableConformance() throws {
        // Given
        let driver = Driver(driverId: "verstappen", familyName: "Verstappen", givenName: "Max")
        
        // When
        let encoded = try JSONEncoder().encode(driver)
        let decoded = try JSONDecoder().decode(Driver.self, from: encoded)
        
        // Then
        XCTAssertEqual(decoded.driverId, driver.driverId)
        XCTAssertEqual(decoded.familyName, driver.familyName)
        XCTAssertEqual(decoded.givenName, driver.givenName)
    }
} 