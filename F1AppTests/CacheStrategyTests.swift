//
//  CacheStrategyTests.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

@testable import F1App
import XCTest

final class CacheStrategyTests: XCTestCase {
    func testTimeBasedCacheInvalidation() {
        // Given
        let strategy = TimeBased(timeInterval: 3600) // 1 hour
        let recentDate = Date().addingTimeInterval(-1800) // 30 minutes ago
        let oldDate = Date().addingTimeInterval(-7200) // 2 hours ago
        
        // When & Then
        XCTAssertFalse(strategy.shouldInvalidateCache(for: "test", cachedDate: recentDate))
        XCTAssertTrue(strategy.shouldInvalidateCache(for: "test", cachedDate: oldDate))
    }
    
    func testManualCacheInvalidation() {
        // Given
        let invalidateStrategy = Manual(shouldInvalidate: true)
        let dontInvalidateStrategy = Manual(shouldInvalidate: false)
        let testDate = Date()
        
        // When & Then
        XCTAssertTrue(invalidateStrategy.shouldInvalidateCache(for: "test", cachedDate: testDate))
        XCTAssertFalse(dontInvalidateStrategy.shouldInvalidateCache(for: "test", cachedDate: testDate))
    }
}
