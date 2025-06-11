//
//  MockSeasonLoader.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

#if DEBUG
import Foundation

/// Mock season loader for testing and previews
/// Only available in DEBUG builds - not shipped to production
class MockSeasonLoader: SeasonLoader {
    var result: Result<[Season], Error> = .failure(NSError(domain: "MockNotConfigured", code: 0))
    var capturedURL: URL?
    
    func fetch(from url: URL) async -> Result<[Season], Error> {
        capturedURL = url
        return result
    }
    
    func setSuccessResponse(_ seasons: [Season]) {
        result = .success(seasons)
    }
    
    func setErrorResponse(_ error: Error) {
        result = .failure(error)
    }
}
#endif
