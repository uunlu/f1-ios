//
//  MockRaceWinnerLoader.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

#if DEBUG
import Foundation

/// Mock race winner loader for testing and previews
/// Only available in DEBUG builds - not shipped to production
class MockRaceWinnerLoader: RaceWinnerLoader {
    var result: Result<[RaceWinner], Error> = .failure(NSError(domain: "MockNotConfigured", code: 0))
    var capturedURL: URL?
    
    func fetch(from url: URL) async -> Result<[RaceWinner], Error> {
        capturedURL = url
        return result
    }
    
    func setSuccessResponse(_ raceWinners: [RaceWinner]) {
        result = .success(raceWinners)
    }
    
    func setErrorResponse(_ error: Error) {
        result = .failure(error)
    }
}
#endif
