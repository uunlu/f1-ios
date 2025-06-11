//
//  CachedData.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation

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