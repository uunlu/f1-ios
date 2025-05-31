//
//  NetworkService.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation

protocol NetworkService {
    func fetch(from request: URLRequest) async -> Result<Data, Error>
}


final class URLSessionNetworkService: NetworkService {
    enum Error: Swift.Error {
        case invalidStatusCode
        case invalidConnection
    }
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetch(from request: URLRequest) async -> Result<Data, Swift.Error> {
        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return .failure(Error.invalidStatusCode)
            }
            
            return .success(data)
        }catch {
            return .failure(Error.invalidConnection)
        }
    }
}

