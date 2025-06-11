//
//  MockNetworkService.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

#if DEBUG
import Foundation

/// Mock network service for testing and previews
/// Only available in DEBUG builds - not shipped to production
class MockNetworkService: NetworkService {
    var responseData: Result<Data, Error> = .failure(NSError(domain: "MockNotConfigured", code: 0))
    var capturedRequest: URLRequest?
    
    func fetch(from request: URLRequest) async -> Result<Data, Error> {
        capturedRequest = request
        return responseData
    }
    
    // Helper methods to configure the mock
    func setSuccessResponse(_ data: Data) {
        responseData = .success(data)
    }
    
    func setErrorResponse(_ error: Error) {
        responseData = .failure(error)
    }
}
#endif
