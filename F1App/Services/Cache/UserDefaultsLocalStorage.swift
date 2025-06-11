//
//  UserDefaultsLocalStorage.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation

/// UserDefaults-based local storage (for smaller data)
public class UserDefaultsLocalStorage: LocalStorage {
    public enum StorageError: Error {
        case encodingFailed
        case decodingFailed
    }
    
    private let userDefaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let keyPrefix: String
    
    public init(userDefaults: UserDefaults = .standard, keyPrefix: String = "F1Cache_") {
        self.userDefaults = userDefaults
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
        self.keyPrefix = keyPrefix
    }
    
    public func save<T: Codable>(_ data: T, forKey key: String) throws {
        let cachedData = CachedData(data: data)
        let prefixedKey = keyPrefix + key
        
        do {
            let encodedData = try encoder.encode(cachedData)
            userDefaults.set(encodedData, forKey: prefixedKey)
        } catch {
            throw StorageError.encodingFailed
        }
    }
    
    public func load<T: Codable>(_ type: T.Type, forKey key: String) throws -> CachedData<T>? {
        let prefixedKey = keyPrefix + key
        
        guard let data = userDefaults.data(forKey: prefixedKey) else {
            return nil
        }
        
        do {
            let cachedData = try decoder.decode(CachedData<T>.self, from: data)
            return cachedData
        } catch {
            throw StorageError.decodingFailed
        }
    }
    
    public func remove(forKey key: String) throws {
        let prefixedKey = keyPrefix + key
        userDefaults.removeObject(forKey: prefixedKey)
    }
    
    public func clearAll() throws {
        let keys = userDefaults.dictionaryRepresentation().keys
        for key in keys where key.hasPrefix(keyPrefix) {
            userDefaults.removeObject(forKey: key)
        }
    }
}
