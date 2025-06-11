//
//  LocalStorageTests.swift
//  F1AppTests
//
//  Created by Ugur Unlu on 31/05/2025.
//

@testable import F1App
import XCTest

final class LocalStorageTests: XCTestCase {
    
    func testInMemoryLocalStorageSaveAndLoad() throws {
        // Given
        let storage = InMemoryLocalStorage()
        let testSeasons = [
            Season(driver: "Test Driver", season: "2023", constructor: "Test Team")
        ]
        
        // When
        try storage.save(testSeasons, forKey: "test_seasons")
        let loaded = try storage.load([Season].self, forKey: "test_seasons")
        
        // Then
        XCTAssertNotNil(loaded)
        XCTAssertEqual(loaded?.data.count, 1)
        XCTAssertEqual(loaded?.data.first?.driver, "Test Driver")
        XCTAssertNotNil(loaded?.timestamp)
    }
    
    func testLocalStorageReturnsNilForMissingKey() throws {
        // Given
        let storage = InMemoryLocalStorage()
        
        // When
        let loaded = try storage.load([Season].self, forKey: "nonexistent_key")
        
        // Then
        XCTAssertNil(loaded)
    }
} 