//
//  NetworkAwareSeasonLoaderTests.swift
//  F1AppTests
//
//  Created by Ugur Unlu on 31/05/2025.
//

import XCTest
import Combine
@testable import F1App

final class NetworkAwareSeasonLoaderTests: XCTestCase {
    private var networkAwareLoader: NetworkAwareSeasonLoader!
    private var mockLocalLoader: MockLocalSeasonLoader!
    private var mockRemoteLoader: MockRemoteSeasonLoader!
    private var mockNetworkProvider: MockNetworkStatusProvider!
    private var cancellables: Set<AnyCancellable>!
    private var testURL: URL!
    
    override func setUp() {
        super.setUp()
        mockLocalLoader = MockLocalSeasonLoader()
        mockRemoteLoader = MockRemoteSeasonLoader()
        mockNetworkProvider = MockNetworkStatusProvider()
        cancellables = Set<AnyCancellable>()
        testURL = URL(string: "https://test.com/seasons")!
        
        networkAwareLoader = NetworkAwareSeasonLoader(
            localLoader: mockLocalLoader,
            remoteLoader: mockRemoteLoader,
            networkStatusProvider: mockNetworkProvider
        )
    }
    
    override func tearDown() {
        cancellables.removeAll()
        networkAwareLoader = nil
        mockLocalLoader = nil
        mockRemoteLoader = nil
        mockNetworkProvider = nil
        super.tearDown()
    }
    
    // MARK: - Online Scenarios
    
    func testFetchWithLocalDataAvailable() async throws {
        // Given
        let expectedSeasons = [Season.mockSeason()]
        mockLocalLoader.mockResult = .success(expectedSeasons)
        mockNetworkProvider.isConnected = true
        
        // When
        let result = await networkAwareLoader.fetch(from: testURL)
        
        // Then
        switch result {
        case .success(let seasons):
            XCTAssertEqual(seasons.count, expectedSeasons.count)
            XCTAssertEqual(seasons.first?.season, expectedSeasons.first?.season)
        case .failure:
            XCTFail("Expected success but got failure")
        }
        
        // Verify local loader was called but remote was not
        XCTAssertTrue(mockLocalLoader.fetchCalled)
        XCTAssertFalse(mockRemoteLoader.fetchCalled)
    }
    
    func testFetchWithNoLocalDataButOnline() async throws {
        // Given
        let expectedSeasons = [Season.mockSeason()]
        mockLocalLoader.mockResult = .failure(MockError.notFound)
        mockRemoteLoader.mockResult = .success(expectedSeasons)
        mockNetworkProvider.isConnected = true
        
        // When
        let result = await networkAwareLoader.fetch(from: testURL)
        
        // Then
        switch result {
        case .success(let seasons):
            XCTAssertEqual(seasons.count, expectedSeasons.count)
        case .failure:
            XCTFail("Expected success but got failure")
        }
        
        // Verify both local and remote were called
        XCTAssertTrue(mockLocalLoader.fetchCalled)
        XCTAssertTrue(mockRemoteLoader.fetchCalled)
        XCTAssertTrue(mockLocalLoader.saveCalled)
    }
    
    // MARK: - Offline Scenarios
    
    func testFetchOfflineWithNoLocalData() async throws {
        // Given
        mockLocalLoader.mockResult = .failure(MockError.notFound)
        mockNetworkProvider.isConnected = false
        
        // When
        let result = await networkAwareLoader.fetch(from: testURL)
        
        // Then
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertTrue(error is NetworkAwareError)
            if let networkError = error as? NetworkAwareError {
                XCTAssertEqual(networkError, .noInternetAndNoCache)
            }
        }
        
        // Verify local was called but remote was not
        XCTAssertTrue(mockLocalLoader.fetchCalled)
        XCTAssertFalse(mockRemoteLoader.fetchCalled)
    }
    
    func testForceRefreshOffline() async throws {
        // Given
        mockNetworkProvider.isConnected = false
        
        // When
        let result = await networkAwareLoader.forceRefresh(from: testURL)
        
        // Then
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertTrue(error is NetworkAwareError)
            if let networkError = error as? NetworkAwareError {
                XCTAssertEqual(networkError, .noInternetConnection)
            }
        }
        
        // Verify no loaders were called
        XCTAssertFalse(mockLocalLoader.fetchCalled)
        XCTAssertFalse(mockRemoteLoader.fetchCalled)
    }
    
    func testForceRefreshOnline() async throws {
        // Given
        let expectedSeasons = [Season.mockSeason()]
        mockRemoteLoader.mockResult = .success(expectedSeasons)
        mockNetworkProvider.isConnected = true
        
        // When
        let result = await networkAwareLoader.forceRefresh(from: testURL)
        
        // Then
        switch result {
        case .success(let seasons):
            XCTAssertEqual(seasons.count, expectedSeasons.count)
        case .failure:
            XCTFail("Expected success but got failure")
        }
        
        // Verify remote was called and data was saved
        XCTAssertTrue(mockRemoteLoader.fetchCalled)
        XCTAssertTrue(mockLocalLoader.saveCalled)
    }
    
    // MARK: - Network State Publisher Tests
    
    @MainActor
    func testNetworkStatePublisher() async throws {
        // Given
        let expectation = expectation(description: "Network state changes")
        var receivedStates: [NetworkLoadingState] = []
        
        // When
        networkAwareLoader.networkStatusPublisher
            .sink { state in
                receivedStates.append(state)
                if receivedStates.count >= 2 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Simulate network state changes
        mockLocalLoader.hasCachedDataResult = true
        mockNetworkProvider.isConnected = false
        mockNetworkProvider.networkStatusSubject.send(false)
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertGreaterThanOrEqual(receivedStates.count, 1)
    }
    
    // MARK: - Cache Management Tests
    
    func testHasCachedData() {
        // Given
        mockLocalLoader.hasCachedDataResult = true
        
        // When
        let hasCache = networkAwareLoader.hasCachedData()
        
        // Then
        XCTAssertTrue(hasCache)
        XCTAssertTrue(mockLocalLoader.hasCachedDataCalled)
    }
    
    func testGetCacheTimestamp() {
        // Given
        let expectedDate = Date()
        mockLocalLoader.getCacheTimestampResult = expectedDate
        
        // When
        let timestamp = networkAwareLoader.getCacheTimestamp()
        
        // Then
        XCTAssertEqual(timestamp, expectedDate)
        XCTAssertTrue(mockLocalLoader.getCacheTimestampCalled)
    }
}

// MARK: - Mock Error

enum MockError: Error {
    case notFound
    case networkFailure
}

// MARK: - Mock Local Season Loader

class MockLocalSeasonLoader: LocalSeasonLoader {
    var mockResult: Result<[Season], Error> = .success([])
    var fetchCalled = false
    var saveCalled = false
    var hasCachedDataCalled = false
    var getCacheTimestampCalled = false
    var hasCachedDataResult = false
    var getCacheTimestampResult: Date? = nil
    
    init() {
        // Initialize with a mock localStorage to prevent memory issues
        super.init(localStorage: InMemoryLocalStorage())
    }
    
    override func fetch(from url: URL) async -> Result<[Season], Error> {
        fetchCalled = true
        return mockResult
    }
    
    override func save(_ seasons: [Season]) throws {
        saveCalled = true
        // Simulate successful save
    }
    
    override func hasCachedData() -> Bool {
        hasCachedDataCalled = true
        return hasCachedDataResult
    }
    
    override func getCacheTimestamp() -> Date? {
        getCacheTimestampCalled = true
        return getCacheTimestampResult
    }
}

// MARK: - Mock Remote Season Loader

class MockRemoteSeasonLoader: RemoteSeasonLoader {
    var mockResult: Result<[Season], Error> = .success([])
    var fetchCalled = false
    
    init() {
        super.init(networkService: MockNetworkService())
    }
    
    override func fetch(from url: URL) async -> Result<[Season], Error> {
        fetchCalled = true
        return mockResult
    }
}

// MARK: - Test Helpers

extension Season {
    static func mockSeason() -> Season {
        return Season(
            driver: "Max Verstappen",
            season: "2023",
            constructor: "Red Bull Racing Honda RBPT"
        )
    }
} 