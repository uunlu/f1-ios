//
//  FileBasedLocalStorage.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation

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
