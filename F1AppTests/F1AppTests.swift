//
//  F1AppTests.swift
//  F1AppTests
//
//  Created by Ugur Unlu on 29/05/2025.
//

@testable import F1App
import XCTest

final class F1AppTests: XCTestCase {
    // MARK: - SeasonsViewModel Tests
    
    @MainActor
    func testSeasonsViewModelInitialization() {
        // Given
        let mockSeasonLoader = MockSeasonLoader()
        
        // When
        let viewModel = SeasonsViewModel(seasonLoader: mockSeasonLoader)
        
        // Then
        XCTAssertTrue(viewModel.seasons.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
    }
    
    @MainActor
    func testSeasonsViewModelLoadSeasonsSuccess() async {
        // Given
        let mockSeasonLoader = MockSeasonLoader()
        let testSeasons = [
            Season(driver: "Max Verstappen", season: "2023", constructor: "Red Bull"),
            Season(driver: "Lewis Hamilton", season: "2022", constructor: "Mercedes")
        ]
        mockSeasonLoader.setSuccessResponse(testSeasons)
        
        let viewModel = SeasonsViewModel(seasonLoader: mockSeasonLoader)
        
        // When
        viewModel.loadSeasons()
        
        // Give time for async operation
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertEqual(viewModel.seasons.count, 2)
        XCTAssertEqual(viewModel.seasons.first?.driver, "Max Verstappen")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
    }
    
    @MainActor
    func testSeasonsViewModelLoadSeasonsError() async {
        // Given
        let mockSeasonLoader = MockSeasonLoader()
        let testError = NSError(domain: "TestError", code: 123, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        mockSeasonLoader.setErrorResponse(testError)
        
        let viewModel = SeasonsViewModel(seasonLoader: mockSeasonLoader)
        
        // When
        viewModel.loadSeasons()
        
        // Give time for async operation
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertTrue(viewModel.seasons.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.error)
    }
    
    // MARK: - RaceWinnerViewModel Tests
    
    @MainActor
    func testRaceWinnerViewModelInitialization() {
        // Given
        let mockRaceWinnerLoader = MockRaceWinnerLoader()
        
        // When
        let viewModel = RaceWinnerViewModel(raceWinnerLoader: mockRaceWinnerLoader, for: "2023")
        
        // Then
        XCTAssertTrue(viewModel.raceWinners.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
    }
    
    @MainActor
    func testRaceWinnerViewModelLoadRaceWinnersSuccess() async {
        // Given
        let mockRaceWinnerLoader = MockRaceWinnerLoader()
        let mockRaceWinners = [
            RaceWinner(
                seasonDriverId: "verstappen_2023",
                seasonConstructorId: "redbull_2023",
                constructorName: "Red Bull Racing",
                driver: Driver(driverId: "verstappen", familyName: "Verstappen", givenName: "Max"),
                round: "1",
                seasonName: "2023",
                isChampion: true,
                raceCompletionTime: "1:30:45.123"
            )
        ]
        mockRaceWinnerLoader.setSuccessResponse(mockRaceWinners)
        
        let viewModel = RaceWinnerViewModel(raceWinnerLoader: mockRaceWinnerLoader, for: "2023")
        
        // When
        viewModel.loadRaceWinners()
        
        // Give time for async operation
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertEqual(viewModel.raceWinners.count, 1)
        XCTAssertEqual(viewModel.raceWinners.first?.driver.fullName, "Verstappen")
        XCTAssertTrue(viewModel.hasChampion)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
    }
    
    // MARK: - LocalStorage Tests
    
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
    
    // MARK: - NetworkService Tests
    
    func testMockNetworkServiceSuccess() async {
        // Given
        let mockNetwork = MockNetworkService()
        let testData = Data("Test response".utf8)
        mockNetwork.setSuccessResponse(testData)
        
        // swiftlint:disable:next force_unwrapping
        let request = URLRequest(url: URL(string: "https://test.com")!)
        
        // When
        let result = await mockNetwork.fetch(from: request)
        
        // Then
        switch result {
        case .success(let data):
            XCTAssertEqual(data, testData)
        case .failure:
            XCTFail("Expected success but got failure")
        }
    }
    
    func testMockNetworkServiceError() async {
        // Given
        let mockNetwork = MockNetworkService()
        let testError = NSError(domain: "NetworkError", code: 500)
        mockNetwork.setErrorResponse(testError)
        
        // swiftlint:disable:next force_unwrapping
        let request = URLRequest(url: URL(string: "https://test.com")!)
        
        // When
        let result = await mockNetwork.fetch(from: request)
        
        // Then
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertEqual((error as NSError).code, 500)
        }
    }
    
    // MARK: - Season Model Tests
    
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
    
    // MARK: - RaceWinner Model Tests
    
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
    
    // MARK: - RaceWinnerMapper Tests
    
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
    
    // MARK: - Cache Strategy Tests
    
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
    
    // MARK: - LocalSeasonLoader Tests
    
    func testLocalSeasonLoaderSuccess() async {
        // Given
        let localStorage = InMemoryLocalStorage()
        let testSeasons = [Season(driver: "Test Driver", season: "2023", constructor: "Test Team")]
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
    
    // MARK: - RemoteSeasonLoader Tests
    
    func testRemoteSeasonLoaderSuccess() async {
        // Given
        let mockNetwork = MockNetworkService()
        let testSeasons = [Season(driver: "Remote Driver", season: "2023", constructor: "Remote Team")]
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
