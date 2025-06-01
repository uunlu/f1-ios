//
//  LocalStorage.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation

/// Local storage protocol for caching data
public protocol LocalStorage {
    func save<T: Codable>(_ data: T, forKey key: String) throws
    func load<T: Codable>(_ type: T.Type, forKey key: String) throws -> CachedData<T>?
    func remove(forKey key: String) throws
    func clearAll() throws
}

/// Wrapper for cached data with metadata
public struct CachedData<T: Codable>: Codable {
    public let data: T
    public let timestamp: Date
    public let version: String?
    
    public init(data: T, timestamp: Date = Date(), version: String? = nil) {
        self.data = data
        self.timestamp = timestamp
        self.version = version
    }
}

/// File-based local storage implementation
public class FileBasedLocalStorage: LocalStorage {
    public enum StorageError: Error {
        case invalidURL
        case encodingFailed
        case decodingFailed
        case fileNotFound
        case writeFailed
        case deleteFailed
    }
    
    private let fileManager: FileManager
    private let baseURL: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    public init(fileManager: FileManager = .default) throws {
        self.fileManager = fileManager
        
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw StorageError.invalidURL
        }
        
        self.baseURL = documentsURL.appendingPathComponent("F1Cache")
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
        
        // Create cache directory if it doesn't exist
        try fileManager.createDirectory(at: baseURL, withIntermediateDirectories: true)
    }
    
    public func save<T: Codable>(_ data: T, forKey key: String) throws {
        let cachedData = CachedData(data: data)
        let fileURL = baseURL.appendingPathComponent("\(key).json")
        
        do {
            let encodedData = try encoder.encode(cachedData)
            try encodedData.write(to: fileURL)
        } catch {
            throw StorageError.encodingFailed
        }
    }
    
    public func load<T: Codable>(_ type: T.Type, forKey key: String) throws -> CachedData<T>? {
        let fileURL = baseURL.appendingPathComponent("\(key).json")
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let cachedData = try decoder.decode(CachedData<T>.self, from: data)
            return cachedData
        } catch {
            throw StorageError.decodingFailed
        }
    }
    
    public func remove(forKey key: String) throws {
        let fileURL = baseURL.appendingPathComponent("\(key).json")
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return // File doesn't exist, nothing to remove
        }
        
        do {
            try fileManager.removeItem(at: fileURL)
        } catch {
            throw StorageError.deleteFailed
        }
    }
    
    public func clearAll() throws {
        do {
            let contents = try fileManager.contentsOfDirectory(at: baseURL, includingPropertiesForKeys: nil)
            for url in contents {
                try fileManager.removeItem(at: url)
            }
        } catch {
            throw StorageError.deleteFailed
        }
    }
}

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