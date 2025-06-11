//
//  PreviewMockNetworkService.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

#if DEBUG
import Foundation

// MARK: - Preview-Only Mock Implementations

/// Lightweight mock network service for SwiftUI previews
/// Only included in DEBUG builds
class PreviewMockNetworkService: NetworkService {
    func fetch(from request: URLRequest) async -> Result<Data, Error> {
        // Return sample data for previews
        if request.url?.absoluteString.contains("seasons") == true {
            return .success(PreviewData.seasonsJSON)
        } else if request.url?.absoluteString.contains("winners") == true {
            return .success(PreviewData.raceWinnersJSON)
        }
        return .failure(NetworkError.invalidURL)
    }
}

/// Lightweight in-memory storage for SwiftUI previews
/// Only included in DEBUG builds
class PreviewInMemoryLocalStorage: LocalStorage {
    private var storage: [String: Data] = [:]
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func save<T: Codable>(_ data: T, forKey key: String) throws {
        let cachedData = CachedData(data: data)
        let encodedData = try encoder.encode(cachedData)
        storage[key] = encodedData
    }
    
    func load<T: Codable>(_ type: T.Type, forKey key: String) throws -> CachedData<T>? {
        guard let data = storage[key] else { return nil }
        return try decoder.decode(CachedData<T>.self, from: data)
    }
    
    func remove(forKey key: String) throws {
        storage.removeValue(forKey: key)
    }
    
    func clearAll() throws {
        storage.removeAll()
    }
}

/// Sample data for SwiftUI previews
/// Only included in DEBUG builds
enum PreviewData {
    // swiftlint:disable force_unwrapping
    // swiftlint:disable non_optional_string_data_conversion
    static let seasonsJSON = """
    [
        {
            "season": "2023",
            "driver": "Max Verstappen",
            "constructor": "Red Bull"
        },
        {
            "season": "2022",
            "driver": "Max Verstappen", 
            "constructor": "Red Bull"
        }
    ]
    """.data(using: .utf8)!
    
    static let raceWinnersJSON = """
    [
        {
            "season": "2023",
            "round": "1",
            "driver": {
                "driverId": "max_verstappen",
                "givenName": "Max",
                "familyName": "Verstappen"
            },
            "constructor": {
                "constructorId": "red_bull",
                "name": "Red Bull"
            },
            "time": "1:24:28.968"
        }
    ]
    """.data(using: .utf8)!
}
// swiftlint:enable force_unwrapping
// swiftlint:enable non_optional_string_data_conversion

/// A season loader that simulates loading state for previews
class PreviewLoadingSeasonLoader: SeasonLoader {
    func fetch(from url: URL) async -> Result<[Season], Error> {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        return .success([])
    }
}
#endif 
