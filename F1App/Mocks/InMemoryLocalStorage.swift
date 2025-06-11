//
//  InMemoryLocalStorage.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

#if DEBUG
import Foundation

/// Mock in-memory local storage for testing and previews
/// Only available in DEBUG builds - not shipped to production
class InMemoryLocalStorage: LocalStorage {
    private var storage: [String: Data] = [:]
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func save<T: Codable>(_ data: T, forKey key: String) throws {
        let cachedData = CachedData(data: data)
        let encodedData = try encoder.encode(cachedData)
        storage[key] = encodedData
    }
    
    func load<T: Codable>(_ type: T.Type, forKey key: String) throws -> CachedData<T>? {
        guard let data = storage[key] else {
            return nil
        }
        
        return try decoder.decode(CachedData<T>.self, from: data)
    }
    
    func remove(forKey key: String) throws {
        storage.removeValue(forKey: key)
    }
    
    func clearAll() throws {
        storage.removeAll()
    }
}
#endif 
