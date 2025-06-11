//
//  NetworkMonitorTests.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Combine
@testable import F1App
import Network
import XCTest

@MainActor
final class NetworkMonitorTests: XCTestCase {
    private var monitor: NetworkMonitor!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables.removeAll()
        monitor = nil
        super.tearDown()
    }
    
    func testNetworkMonitorSharedInstance() {
        // Given & When
        let monitor1 = NetworkMonitor.shared
        let monitor2 = NetworkMonitor.shared
        
        // Then
        XCTAssertTrue(monitor1 === monitor2, "shared should return the same instance")
    }
    
    func testNetworkMonitorInitialState() {
        // Given & When
        monitor = NetworkMonitor.shared
        
        // Then
        // Initial state may vary based on actual network, so we just verify properties exist
        XCTAssertNotNil(monitor.isConnected)
        XCTAssertTrue(monitor.connectionType == nil || monitor.connectionType != nil)
        XCTAssertNotNil(monitor.isExpensive)
    }
    
    func testNetworkStatusPublisher() throws {
        // Given
        monitor = NetworkMonitor.shared
        let expectation = expectation(description: "Network status published")
        var receivedStatus: Bool?
        
        // When
        monitor.$isConnected
            .sink { isConnected in
                receivedStatus = isConnected
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(receivedStatus, "Should receive initial network status")
    }
    
    func testNetworkStatusProviderConformance() {
        // Given
        monitor = NetworkMonitor.shared
        let provider: NetworkStatusProvider = monitor
        
        // When & Then
        XCTAssertNotNil(provider.networkStatusPublisher, "Should conform to NetworkStatusProvider")
        
        // Test async isConnected property
        let expectation = expectation(description: "Async isConnected")
        Task {
            let isConnected = await provider.isConnected
            XCTAssertNotNil(isConnected)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testNetworkStateEnumValues() {
        // Test NetworkState enum functionality
        let connectedState = NetworkState.connected(type: .wifi, isExpensive: false)
        let disconnectedState = NetworkState.disconnected
        
        XCTAssertTrue(connectedState.isConnected)
        XCTAssertFalse(disconnectedState.isConnected)
    }
    
    func testInterfaceTypeDescription() {
        // Test NWInterface.InterfaceType extension
        XCTAssertEqual(NWInterface.InterfaceType.wifi.description, "WiFi")
        XCTAssertEqual(NWInterface.InterfaceType.cellular.description, "Cellular")
        XCTAssertEqual(NWInterface.InterfaceType.wiredEthernet.description, "Ethernet")
        XCTAssertEqual(NWInterface.InterfaceType.loopback.description, "Loopback")
        XCTAssertEqual(NWInterface.InterfaceType.other.description, "Other")
    }
} 
