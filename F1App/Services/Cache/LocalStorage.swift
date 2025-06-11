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
