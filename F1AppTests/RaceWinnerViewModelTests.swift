//
//  RaceWinnerViewModelTests.swift
//  F1AppTests
//
//  Created by Ugur Unlu on 31/05/2025.
//

@testable import F1App
import XCTest

final class RaceWinnerViewModelTests: XCTestCase {
    
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
} 