//
//  NetworkMonitor.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation
import Network
import Combine

/// Modern network monitoring service for iOS 16+
public final class NetworkMonitor: ObservableObject {
    nonisolated public static let shared = NetworkMonitor()
    
    @Published public private(set) var isConnected = false
    @Published public private(set) var connectionType: NWInterface.InterfaceType?
    @Published public private(set) var isExpensive = false
    
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitor", qos: .utility)
    
    private init() {
        monitor = NWPathMonitor()
        startMonitoring()
    }
    
    deinit {
        stopMonitoring()
    }
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                self?.updateNetworkStatus(path)
            }
        }
        monitor.start(queue: queue)
    }
    
    nonisolated private func stopMonitoring() {
        monitor.cancel()
    }
    
    private func updateNetworkStatus(_ path: NWPath) {
        let wasConnected = isConnected
        isConnected = path.status == .satisfied
        isExpensive = path.isExpensive
        
        // Determine connection type
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .wiredEthernet
        } else {
            connectionType = nil
        }
        
        // Log connection changes
        if wasConnected != isConnected {
            let status = isConnected ? "Connected" : "Disconnected"
            AppLogger.debug("Network status changed: \(status)")
        }
    }
}

// MARK: - Connection Type Extension
extension NWInterface.InterfaceType {
    var description: String {
        switch self {
        case .wifi: return "WiFi"
        case .cellular: return "Cellular"
        case .wiredEthernet: return "Ethernet"
        case .loopback: return "Loopback"
        case .other: return "Other"
        @unknown default: return "Unknown"
        }
    }
}

// MARK: - Network State
public enum NetworkState {
    case connected(type: NWInterface.InterfaceType?, isExpensive: Bool)
    case disconnected
    
    var isConnected: Bool {
        switch self {
        case .connected: return true
        case .disconnected: return false
        }
    }
} 
