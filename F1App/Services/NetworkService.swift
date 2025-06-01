//
//  NetworkService.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation

public protocol NetworkService {
    func fetch(from request: URLRequest) async -> Result<Data, Error>
}

public class URLSessionNetworkService: NetworkService {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func fetch(from request: URLRequest) async -> Result<Data, Error> {
        print("🌐 Making request to: \(request.url?.absoluteString ?? "unknown")")
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid response type")
                return .failure(NetworkError.serverError("Invalid response"))
            }
            
            print("📡 HTTP Response: \(httpResponse.statusCode)")
            
            guard 200...299 ~= httpResponse.statusCode else {
                print("❌ HTTP Error: \(httpResponse.statusCode)")
                return .failure(NetworkError.serverError("HTTP \(httpResponse.statusCode)"))
            }
            
            print("✅ Received \(data.count) bytes of data")
            return .success(data)
        } catch {
            print("❌ Network error: \(error.localizedDescription)")
            return .failure(NetworkError.serverError(error.localizedDescription))
        }
    }
}

