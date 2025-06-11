//
//  DependencyContainer.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation

// MARK: - Service Protocols

protocol DependencyProvider {
    var networkService: NetworkService { get }
    var localStorage: LocalStorage { get }
    var seasonLoader: SeasonLoader { get }
    var raceWinnerLoader: RaceWinnerLoader { get }
}

// MARK: - Container Implementation

class DependencyContainer: DependencyProvider {
    // MARK: Properties
    private(set) var networkService: NetworkService
    private(set) var localStorage: LocalStorage
    private(set) var seasonLoader: SeasonLoader
    private(set) var raceWinnerLoader: RaceWinnerLoader
    private(set) var networkMonitor: NetworkMonitor
    
    // MARK: Initialization
    init(
        networkService: NetworkService? = nil,
        localStorage: LocalStorage? = nil,
        seasonLoader: SeasonLoader? = nil,
        raceWinnerLoader: RaceWinnerLoader? = nil,
        networkMonitor: NetworkMonitor = NetworkMonitor.shared
    ) {
        AppLogger.logViewModel("Initializing DependencyContainer")
        
        // Initialize or use provided network service
        self.networkService = networkService ?? URLSessionNetworkService()
        
        // Initialize or use provided network monitor
        self.networkMonitor = networkMonitor
        
        // Initialize or use provided local storage
        if let storage = localStorage {
            self.localStorage = storage
        } else {
            do {
                self.localStorage = try FileBasedLocalStorage()
                AppLogger.logCache("Initialized FileBasedLocalStorage")
            } catch {
                self.localStorage = UserDefaultsLocalStorage()
                AppLogger.logError("Failed to create FileBasedLocalStorage, using UserDefaults", error: error)
            }
        }
        
        // Initialize or use provided season loader
        if let loader = seasonLoader {
            self.seasonLoader = loader
        } else {
            let localLoader = LocalSeasonLoader(localStorage: self.localStorage)
            let remoteLoader = RemoteSeasonLoader(networkService: self.networkService)
            self.seasonLoader = NetworkAwareSeasonLoader(
                localLoader: localLoader,
                remoteLoader: remoteLoader
            )
            AppLogger.logViewModel("Initialized NetworkAwareSeasonLoader with network monitoring")
        }
        
        // Initialize or use provided race winner loader
        if let loader = raceWinnerLoader {
            self.raceWinnerLoader = loader
        } else {
            let localLoader = LocalRaceWinnerLoader(localStorage: self.localStorage)
            let remoteLoader = RemoteRaceWinnerLoader(networkService: self.networkService)
            self.raceWinnerLoader = LocalWithRemoteRaceWinnerLoader(
                localLoader: localLoader,
                remoteLoader: remoteLoader
            )
            AppLogger.logViewModel("Initialized RaceWinnerLoader with Local+Remote decorator pattern")
        }
    }
    
    // MARK: Factory Methods - UI Components
    
    // These methods can be on the main actor since they create UI components
    @MainActor
    func makeAppCoordinator() -> AppCoordinator {
        AppLogger.logNavigation("Creating AppCoordinator")
        return AppCoordinator(dependencyContainer: self)
    }
    
    @MainActor
    func makeSeasonsViewModel() -> SeasonsViewModel {
        AppLogger.logViewModel("Creating SeasonsViewModel")
        return SeasonsViewModel(seasonLoader: seasonLoader)
    }
    
    @MainActor
    func makeRaceWinnerViewModel(for seasonYear: String) -> RaceWinnerViewModel {
        AppLogger.logViewModel("Creating RaceWinnerViewModel for season $seasonYear)")
        return RaceWinnerViewModel(raceWinnerLoader: raceWinnerLoader, for: seasonYear)
    }
    
    // MARK: Factory Methods - Container Creation
    
    static func createDefault() -> DependencyContainer {
        DependencyContainer()
    }
}

// MARK: - Debug-Only Preview Support

#if DEBUG
extension DependencyContainer {
    /// Creates a dependency container with mock implementations for SwiftUI previews
    /// Only available in DEBUG builds - not shipped to production
    static func createForPreviews() -> DependencyContainer {
        let networkService = PreviewMockNetworkService()
        let localStorage = PreviewInMemoryLocalStorage()
        return DependencyContainer(
            networkService: networkService,
            localStorage: localStorage
        )
    }
    
    /// Creates a dependency container with mock implementations for testing
    /// Only available in DEBUG builds - not shipped to production
    static func createForTesting() -> DependencyContainer {
        let networkService = MockNetworkService()
        let localStorage = InMemoryLocalStorage()
        return DependencyContainer(
            networkService: networkService,
            localStorage: localStorage
        )
    }
}
#endif
