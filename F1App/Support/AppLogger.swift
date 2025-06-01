import Foundation
import os.log

/// Centralized logging system for the F1 app using Apple's unified logging
/// This provides proper logging that respects production vs debug builds
public enum AppLogger {
    
    // MARK: - Log Categories
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.f1app"
    
    public static let network = Logger(subsystem: subsystem, category: "Network")
    public static let cache = Logger(subsystem: subsystem, category: "Cache")
    public static let viewModel = Logger(subsystem: subsystem, category: "ViewModel")
    public static let navigation = Logger(subsystem: subsystem, category: "Navigation")
    public static let performance = Logger(subsystem: subsystem, category: "Performance")
    public static let error = Logger(subsystem: subsystem, category: "Error")
    public static let ui = Logger(subsystem: subsystem, category: "UI")
    
    // MARK: - Convenience Methods
    
    /// Log network requests and responses
    public static func logNetwork(_ message: String, level: OSLogType = .info) {
        network.log(level: level, "\(message)")
    }
    
    /// Log cache operations
    public static func logCache(_ message: String, level: OSLogType = .info) {
        cache.log(level: level, "\(message)")
    }
    
    /// Log ViewModel state changes
    public static func logViewModel(_ message: String, level: OSLogType = .info) {
        viewModel.log(level: level, "\(message)")
    }
    
    /// Log navigation events
    public static func logNavigation(_ message: String, level: OSLogType = .info) {
        navigation.log(level: level, "\(message)")
    }
    
    /// Log performance metrics
    public static func logPerformance(_ message: String, level: OSLogType = .info) {
        performance.log(level: level, "\(message)")
    }
    
    /// Log errors
    public static func logError(_ message: String, error: Error? = nil) {
        if let error = error {
            self.error.log(level: .error, "\(message): \(error.localizedDescription)")
        } else {
            self.error.log(level: .error, "\(message)")
        }
    }
    
    /// Log UI events and state changes
    public static func logUI(_ message: String, level: OSLogType = .info) {
        ui.log(level: level, "\(message)")
    }
    
    // MARK: - Development Only Logging
    
    /// Debug logs that only appear in debug builds
    public static func debug(_ message: String, category: String = "Debug") {
        #if DEBUG
        let logger = Logger(subsystem: subsystem, category: category)
        logger.log(level: .debug, "\(message)")
        #endif
    }
    
    /// Verbose logs for detailed debugging
    public static func verbose(_ message: String, category: String = "Verbose") {
        #if DEBUG
        let logger = Logger(subsystem: subsystem, category: category)
        logger.log(level: .debug, "[VERBOSE] \(message)")
        #endif
    }
}

// MARK: - Extensions for Common Use Cases

extension AppLogger {
    
    /// Log data loading operations with standardized format
    public static func logDataLoading(
        type: String,
        source: String,
        count: Int? = nil,
        duration: TimeInterval? = nil
    ) {
        var message = "Loaded \(type) from \(source)"
        
        if let count = count {
            message += " (\(count) items)"
        }
        
        if let duration = duration {
            message += " in \(String(format: "%.3f", duration))s"
        }
        
        logViewModel(message)
    }
    
    /// Log cache operations with standardized format
    public static func logCacheOperation(
        operation: String,
        key: String,
        success: Bool,
        itemCount: Int? = nil
    ) {
        let statusEmoji = success ? "✅" : "❌"
        var message = "\(statusEmoji) \(operation) cache for \(key)"
        
        if let itemCount = itemCount {
            message += " (\(itemCount) items)"
        }
        
        logCache(message, level: success ? .info : .error)
    }
    
    /// Log network requests with standardized format
    public static func logNetworkRequest(
        url: URL,
        method: String = "GET",
        success: Bool,
        statusCode: Int? = nil,
        duration: TimeInterval? = nil,
        dataSize: Int? = nil
    ) {
        let statusEmoji = success ? "🌐" : "🚫"
        var message = "\(statusEmoji) \(method) \(url.absoluteString)"
        
        if let statusCode = statusCode {
            message += " -> \(statusCode)"
        }
        
        if let duration = duration {
            message += " (\(String(format: "%.3f", duration))s"
            
            if let dataSize = dataSize {
                message += ", \(dataSize) bytes)"
            } else {
                message += ")"
            }
        }
        
        logNetwork(message, level: success ? .info : .error)
    }
} 