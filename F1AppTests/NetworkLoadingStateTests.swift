//
//  NetworkLoadingStateTests.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Combine
@testable import F1App
import XCTest

final class NetworkLoadingStateTests: XCTestCase {
    
    func testNetworkLoadingStateValues() {
        // Test all enum cases exist and are distinct
        let connected: NetworkLoadingState = .connected
        let disconnected: NetworkLoadingState = .disconnected
        let offlineWithCache: NetworkLoadingState = .offlineWithCache
        let offlineWithoutCache: NetworkLoadingState = .offlineWithoutCache
        
        XCTAssertNotEqual(connected, disconnected)
        XCTAssertNotEqual(connected, offlineWithCache)
        XCTAssertNotEqual(connected, offlineWithoutCache)
        XCTAssertNotEqual(disconnected, offlineWithCache)
        XCTAssertNotEqual(disconnected, offlineWithoutCache)
        XCTAssertNotEqual(offlineWithCache, offlineWithoutCache)
    }
    
    func testNetworkAwareErrorCases() {
        // Test NetworkAwareError enum
        let noInternet = NetworkAwareError.noInternetConnection
        let noInternetAndCache = NetworkAwareError.noInternetAndNoCache
        
        // Test error descriptions
        XCTAssertNotNil(noInternet.errorDescription)
        XCTAssertNotNil(noInternetAndCache)
    }
    
    func testNetworkStatusProviderProtocol() {
        // Test that our mock conforms to the protocol
        let mockProvider = MockNetworkStatusProvider()
        let provider: NetworkStatusProvider = mockProvider
        
        // Test async isConnected property
        let expectation = expectation(description: "Async property access")
        Task {
            let isConnected = await provider.isConnected
            XCTAssertNotNil(isConnected)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        // Test publisher
        XCTAssertNotNil(provider.networkStatusPublisher)
    }
    
    func testNetworkAwareSeasonLoadingProtocol() {
        // Test that our mock conforms to the protocol
        let mockLoader = MockNetworkAwareSeasonLoader()
        let loader: NetworkAwareSeasonLoading = mockLoader
        
        // Test protocol methods
        XCTAssertNotNil(loader.networkStatusPublisher)
        XCTAssertFalse(loader.hasCachedData()) // Default mock value
        XCTAssertNil(loader.getCacheTimestamp()) // Default mock value
    }
}

// MARK: - Test Support Mocks

class MockNetworkStatusProvider: NetworkStatusProvider {
    var isConnected: Bool = true
    let networkStatusSubject = CurrentValueSubject<Bool, Never>(true)
    
    var networkStatusPublisher: AnyPublisher<Bool, Never> {
        networkStatusSubject.eraseToAnyPublisher()
    }
}

class MockNetworkAwareSeasonLoader: NetworkAwareSeasonLoading {
    private let networkStateSubject = CurrentValueSubject<NetworkLoadingState, Never>(.connected)
    
    var networkStatusPublisher: AnyPublisher<NetworkLoadingState, Never> {
        networkStateSubject.eraseToAnyPublisher()
    }
    
    // Call tracking
    var fetchCalled = false
    var forceRefreshCalled = false
    var hasCachedDataCalled = false
    var getCacheTimestampCalled = false
    
    // Mock results
    var mockResult: Result<[Season], Swift.Error> = .success([])
    var forceRefreshResult: Result<[Season], Error> = .success([])
    var hasCachedDataResult = false
    var getCacheTimestampResult: Date?
    
    func fetch(from url: URL) async -> Result<[Season], Error> {
        fetchCalled = true
        return mockResult
    }
    
    func forceRefresh(from url: URL) async -> Result<[Season], Error> {
        forceRefreshCalled = true
        return forceRefreshResult
    }
    
    func hasCachedData() -> Bool {
        hasCachedDataCalled = true
        return hasCachedDataResult
    }
    
    func getCacheTimestamp() -> Date? {
        getCacheTimestampCalled = true
        return getCacheTimestampResult
    }
    
    // Test helpers
    func publishNetworkState(_ state: NetworkLoadingState) {
        networkStateSubject.send(state)
    }
    
    func resetCallTracking() {
        fetchCalled = false
        forceRefreshCalled = false
        hasCachedDataCalled = false
        getCacheTimestampCalled = false
    }
} 
