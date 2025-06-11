//
//  SeasonModelTests.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

@testable import F1App
import XCTest

final class SeasonModelTests: XCTestCase {
    func testSeasonCodableConformance() throws {
        // Given
        let season = Season(driver: "Lewis Hamilton", season: "2020", constructor: "Mercedes")
        
        // When
        let encoded = try JSONEncoder().encode(season)
        let decoded = try JSONDecoder().decode(Season.self, from: encoded)
        
        // Then
        XCTAssertEqual(decoded.driver, season.driver)
        XCTAssertEqual(decoded.season, season.season)
        XCTAssertEqual(decoded.constructor, season.constructor)
    }
    
    func testSeasonHashable() {
        // Given
        let season1 = Season(driver: "Max Verstappen", season: "2023", constructor: "Red Bull")
        let season2 = Season(driver: "Max Verstappen", season: "2023", constructor: "Red Bull")
        let season3 = Season(driver: "Lewis Hamilton", season: "2020", constructor: "Mercedes")
        
        // When & Then
        XCTAssertEqual(season1, season2)
        XCTAssertNotEqual(season1, season3)
        
        let set = Set([season1, season2, season3])
        XCTAssertEqual(set.count, 2) // season1 and season2 should be considered equal
    }
}
