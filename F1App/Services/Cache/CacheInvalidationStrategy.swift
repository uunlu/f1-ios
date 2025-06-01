//
//  CacheInvalidationStrategy.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation

/// Cache invalidation strategy protocol
public protocol CacheInvalidationStrategy {
    func shouldInvalidateCache(for key: String, cachedDate: Date) -> Bool
}

/// Time-based cache invalidation (expire after specified duration)
public struct TimeBased: CacheInvalidationStrategy {
    private let timeInterval: TimeInterval
    
    public init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    public func shouldInvalidateCache(for key: String, cachedDate: Date) -> Bool {
        return Date().timeIntervalSince(cachedDate) > timeInterval
    }
}

/// Version-based cache invalidation
public struct VersionBased: CacheInvalidationStrategy {
    private let currentVersion: String
    private let cacheVersionKey: String
    
    public init(currentVersion: String, cacheVersionKey: String = "cache_version") {
        self.currentVersion = currentVersion
        self.cacheVersionKey = cacheVersionKey
    }
    
    public func shouldInvalidateCache(for key: String, cachedDate: Date) -> Bool {
        let cachedVersion = UserDefaults.standard.string(forKey: "\(key)_\(cacheVersionKey)")
        return cachedVersion != currentVersion
    }
}

/// Manual invalidation strategy
public struct Manual: CacheInvalidationStrategy {
    private let shouldInvalidate: Bool
    
    public init(shouldInvalidate: Bool = false) {
        self.shouldInvalidate = shouldInvalidate
    }
    
    public func shouldInvalidateCache(for key: String, cachedDate: Date) -> Bool {
        return shouldInvalidate
    }
}

/// Composite strategy that combines multiple strategies
public struct Composite: CacheInvalidationStrategy {
    private let strategies: [CacheInvalidationStrategy]
    private let logic: CompositeLogic
    
    public enum CompositeLogic {
        case any  // Invalidate if ANY strategy says to invalidate
        case all  // Invalidate only if ALL strategies say to invalidate
    }
    
    public init(strategies: [CacheInvalidationStrategy], logic: CompositeLogic = .any) {
        self.strategies = strategies
        self.logic = logic
    }
    
    public func shouldInvalidateCache(for key: String, cachedDate: Date) -> Bool {
        switch logic {
        case .any:
            return strategies.contains { $0.shouldInvalidateCache(for: key, cachedDate: cachedDate) }
        case .all:
            return strategies.allSatisfy { $0.shouldInvalidateCache(for: key, cachedDate: cachedDate) }
        }
    }
}

// MARK: - Convenience Extensions

extension CacheInvalidationStrategy {
    /// Default time-based strategy: 1 hour
    public static func oneHour() -> CacheInvalidationStrategy {
        return TimeBased(timeInterval: 3600)
    }
    
    /// Default time-based strategy: 30 minutes
    public static func thirtyMinutes() -> CacheInvalidationStrategy {
        return TimeBased(timeInterval: 1800)
    }
    
    /// Default time-based strategy: 5 minutes
    public static func fiveMinutes() -> CacheInvalidationStrategy {
        return TimeBased(timeInterval: 300)
    }
    
    /// Never invalidate (useful for permanent data)
    public static func never() -> CacheInvalidationStrategy {
        return TimeBased(timeInterval: .greatestFiniteMagnitude)
    }
    
    /// Always invalidate (useful for force refresh)
    public static func always() -> CacheInvalidationStrategy {
        return Manual(shouldInvalidate: true)
    }
} 