//
//  SeasonsViewModelTests.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

@testable import F1App
import XCTest

final class SeasonsViewModelTests: XCTestCase {
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
}
