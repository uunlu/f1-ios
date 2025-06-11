//
//  SeasonsViewModelOfflineTests.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Combine
@testable import F1App
import XCTest

@MainActor
final class SeasonsViewModelOfflineTests: XCTestCase {
    private var viewModel: SeasonsViewModel!
    private var mockNetworkAwareLoader: MockNetworkAwareSeasonLoader!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockNetworkAwareLoader = MockNetworkAwareSeasonLoader()
        viewModel = SeasonsViewModel(seasonLoader: mockNetworkAwareLoader)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables.removeAll()
        viewModel = nil
        mockNetworkAwareLoader = nil
        super.tearDown()
    }
    
    // MARK: - Network State Transition Tests
    
    func testNetworkStateChangeFromConnectedToOfflineWithoutCache() async {
        // Given
        mockNetworkAwareLoader.hasCachedDataResult = false
        let expectation = expectation(description: "Network state changes")
        
        // When
        viewModel.$showOfflineBanner
            .dropFirst() // Skip initial value
            .sink { showBanner in
                if showBanner {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Simulate going offline without cache
        mockNetworkAwareLoader.publishNetworkState(.offlineWithoutCache)
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertTrue(viewModel.showOfflineBanner)
        XCTAssertEqual(viewModel.networkState, .offlineWithoutCache)
    }
    
    func testNetworkStateChangeFromConnectedToOfflineWithCache() async {
        // Given
        mockNetworkAwareLoader.hasCachedDataResult = true
        let expectation = expectation(description: "Network state changes")
        
        // When
        viewModel.$networkState
            .dropFirst() // Skip initial value
            .sink { networkState in
                if networkState == .offlineWithCache {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Simulate going offline with cache
        mockNetworkAwareLoader.publishNetworkState(.offlineWithCache)
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertFalse(viewModel.showOfflineBanner) // Should not show banner when cache available
        XCTAssertEqual(viewModel.networkState, .offlineWithCache)
    }
    
    func testAutoRetryWhenConnectionReturns() async {
        // Given
        let mockSeasons = [Season.mockSeason()]
        mockNetworkAwareLoader.mockResult = .success(mockSeasons)
        
        // Start in disconnected state with empty seasons
        mockNetworkAwareLoader.publishNetworkState(.offlineWithoutCache)
        XCTAssertTrue(viewModel.seasons.isEmpty)
        
        let expectation = expectation(description: "Auto-retry loads data")
        
        // When
        viewModel.$seasons
            .dropFirst() // Skip initial empty value
            .sink { seasons in
                if !seasons.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Simulate connection returning
        mockNetworkAwareLoader.publishNetworkState(.connected)
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertFalse(viewModel.seasons.isEmpty)
        XCTAssertTrue(mockNetworkAwareLoader.fetchCalled)
    }
    
    func testNoAutoRetryWhenConnectionReturnsButDataExists() async {
        // Given
        let existingSeasons = [Season.mockSeason()]
        viewModel.seasons = existingSeasons // Pre-populate with data
        mockNetworkAwareLoader.resetCallTracking()
        
        // When
        mockNetworkAwareLoader.publishNetworkState(.offlineWithoutCache)
        mockNetworkAwareLoader.publishNetworkState(.connected)
        
        // Give time for any potential auto-retry
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertFalse(mockNetworkAwareLoader.fetchCalled) // Should not auto-retry if data exists
        XCTAssertEqual(viewModel.seasons.count, 1)
    }
    
    // MARK: - Offline Banner Tests
    
    func testOfflineBannerShowsOnlyWhenOfflineWithoutCache() async {
        // Start with some data to prevent auto-retry from triggering
        let testSeasons = [Season.mockSeason()]
        viewModel.seasons = testSeasons
        
        // Test: Connected state - no banner
        mockNetworkAwareLoader.publishNetworkState(.connected)
        
        // Wait a moment for state to process
        try? await Task.sleep(nanoseconds: 50_000_000) // 0.05 seconds
        XCTAssertFalse(viewModel.showOfflineBanner)
        
        // Test: Offline with cache - no banner
        mockNetworkAwareLoader.publishNetworkState(.offlineWithCache)
        
        try? await Task.sleep(nanoseconds: 50_000_000) // 0.05 seconds
        XCTAssertFalse(viewModel.showOfflineBanner)
        
        // Test: Offline without cache - show banner
        let bannerExpectation = expectation(description: "Banner shows for offline without cache")
        
        viewModel.$showOfflineBanner
            .dropFirst() // Skip current value
            .sink { showBanner in
                if showBanner {
                    bannerExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        mockNetworkAwareLoader.publishNetworkState(.offlineWithoutCache)
        
        await fulfillment(of: [bannerExpectation], timeout: 1.0)
        XCTAssertTrue(viewModel.showOfflineBanner)
        
        // Test: Back to connected - hide banner
        let hideBannerExpectation = expectation(description: "Banner hides when back to connected")
        
        viewModel.$showOfflineBanner
            .dropFirst() // Skip current value
            .sink { showBanner in
                if !showBanner {
                    hideBannerExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        mockNetworkAwareLoader.publishNetworkState(.connected)
        
        await fulfillment(of: [hideBannerExpectation], timeout: 1.0)
        XCTAssertFalse(viewModel.showOfflineBanner)
    }
    
    // MARK: - Force Refresh Tests
    
    func testRefreshSeasonsWithNetworkAwareLoader() async {
        // Given
        let mockSeasons = [Season.mockSeason()]
        mockNetworkAwareLoader.forceRefreshResult = .success(mockSeasons)
        
        let expectation = expectation(description: "Refresh completes")
        
        // When
        viewModel.$isRefreshing
            .dropFirst() // Skip initial value
            .sink { isRefreshing in
                if !isRefreshing {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.refreshSeasons()
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertTrue(mockNetworkAwareLoader.forceRefreshCalled)
        XCTAssertEqual(viewModel.seasons.count, 1)
    }
    
    // MARK: - Cache Status Tests
    
    func testUpdateLocalDataStatusWithNetworkAwareLoader() {
        // Given
        let testDate = Date()
        mockNetworkAwareLoader.hasCachedDataResult = true
        mockNetworkAwareLoader.getCacheTimestampResult = testDate
        
        // When
        viewModel.loadSeasons()
        
        // Give time for updateLocalDataStatus to be called
        let expectation = expectation(description: "Local data status updated")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        // Then
        XCTAssertTrue(viewModel.hasLocalData)
        XCTAssertEqual(viewModel.lastUpdated, testDate)
    }
    
    // MARK: - Error Handling Tests
    
    func testNetworkAwareErrorHandling() async {
        // Given
        mockNetworkAwareLoader.mockResult = .failure(NetworkAwareError.noInternetAndNoCache(""))
        
        // Set network state to offline without cache first
        mockNetworkAwareLoader.publishNetworkState(.offlineWithoutCache)
        
        // Wait for network state to be processed
        try? await Task.sleep(nanoseconds: 50_000_000) // 0.05 seconds
        
        let expectation = expectation(description: "Error handled")
        
        // When
        viewModel.$error
            .dropFirst() // Skip initial nil value
            .sink { error in
                if error != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.loadSeasons()
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertNotNil(viewModel.error)
        XCTAssertTrue(viewModel.showOfflineBanner)
    }
}

// Test helpers are available through NetworkLoadingStateTests 
