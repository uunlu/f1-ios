//
//  SeasonLoaderTests.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

@testable import F1App
import XCTest

final class SeasonLoaderTests: XCTestCase {
    func testLocalSeasonLoaderSuccess() async {
        // Given
        let localStorage = InMemoryLocalStorage()
        let testSeasons = [Season(driver: "Test Driver", season: "2023", constructor: "Test Team", completed: true)]
        // swiftlint:disable:next force_try
        try! localStorage.save(testSeasons, forKey: "seasons")
        
        let loader = LocalSeasonLoader(localStorage: localStorage)
        // swiftlint:disable:next force_unwrapping
        let testURL = URL(string: "http://test.com")!
        
        // When
        let result = await loader.fetch(from: testURL)
        
        // Then
        switch result {
        case .success(let seasons):
            XCTAssertEqual(seasons.count, 1)
            XCTAssertEqual(seasons.first?.driver, "Test Driver")
        case .failure:
            XCTFail("Expected success but got failure")
        }
    }
    
    func testLocalSeasonLoaderDataNotFound() async {
        // Given
        let localStorage = InMemoryLocalStorage()
        let loader = LocalSeasonLoader(localStorage: localStorage)
        // swiftlint:disable:next force_unwrapping
        let testURL = URL(string: "http://test.com")!
        
        // When
        let result = await loader.fetch(from: testURL)
        
        // Then
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertTrue(error is LocalSeasonLoader.LocalError)
        }
    }
    
    func testRemoteSeasonLoaderSuccess() async {
        // Given
        let mockNetwork = MockNetworkService()
        let testSeasons = [Season(driver: "Remote Driver", season: "2023", constructor: "Remote Team", completed: true)]
        // swiftlint:disable:next force_try
        let jsonData = try! JSONEncoder().encode(testSeasons)
        mockNetwork.setSuccessResponse(jsonData)
        
        let loader = RemoteSeasonLoader(networkService: mockNetwork)
        // swiftlint:disable:next force_unwrapping
        let testURL = URL(string: "http://test.com")!
        
        // When
        let result = await loader.fetch(from: testURL)
        
        // Then
        switch result {
        case .success(let seasons):
            XCTAssertEqual(seasons.count, 1)
            XCTAssertEqual(seasons.first?.driver, "Remote Driver")
        case .failure:
            XCTFail("Expected success but got failure")
        }
    }
    
    func testRemoteSeasonLoaderNetworkError() async {
        // Given
        let mockNetwork = MockNetworkService()
        let networkError = NSError(domain: "NetworkError", code: 500)
        mockNetwork.setErrorResponse(networkError)
        
        let loader = RemoteSeasonLoader(networkService: mockNetwork)
        // swiftlint:disable:next force_unwrapping
        let testURL = URL(string: "http://test.com")!
        
        // When
        let result = await loader.fetch(from: testURL)
        
        // Then
        switch result {
        case .success(let seasons):
            // Should fallback to mock data
            XCTAssertFalse(seasons.isEmpty)
        case .failure:
            XCTFail("Should fallback to mock data on network error")
        }
    }
}
