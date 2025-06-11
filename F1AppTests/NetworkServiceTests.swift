//
//  NetworkServiceTests.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

@testable import F1App
import XCTest

final class NetworkServiceTests: XCTestCase {
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
}
