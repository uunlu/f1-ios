//
//  DependencyContainer.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation

/// Composition root that manages the dependency injection and object graph creation
@MainActor
class DependencyContainer {
    
    // MARK: - Singleton
    static let shared = DependencyContainer()
    private init() {}
    
    // MARK: - Network Services
    private var _networkService: NetworkService?
    private var networkService: NetworkService {
        if _networkService == nil {
            _networkService = URLSessionNetworkService()
            AppLogger.logViewModel("Initialized URLSessionNetworkService")
        }
        return _networkService!
    }
    
    // MARK: - Storage Services
    private var _localStorage: LocalStorage?
    private var localStorage: LocalStorage {
        if _localStorage == nil {
            do {
                _localStorage = try FileBasedLocalStorage()
                AppLogger.logCache("Initialized FileBasedLocalStorage")
            } catch {
                _localStorage = UserDefaultsLocalStorage()
                AppLogger.logError("Failed to create FileBasedLocalStorage, using UserDefaults", error: error)
            }
        }
        return _localStorage!
    }
    
    // MARK: - Data Loaders with Decorator Pattern
    private var _seasonLoader: SeasonLoader?
    private var seasonLoader: SeasonLoader {
        if _seasonLoader == nil {
            // Create local and remote loaders
            let localLoader = LocalSeasonLoader(localStorage: localStorage)
            let remoteLoader = RemoteSeasonLoader(networkService: networkService)
            
            // Use decorator pattern: Local with Remote fallback
            _seasonLoader = LocalWithRemoteSeasonLoader(
                localLoader: localLoader,
                remoteLoader: remoteLoader
            )
            
            AppLogger.logViewModel("Initialized SeasonLoader with Local+Remote decorator pattern")
        }
        return _seasonLoader!
    }
    
    private var _raceWinnerLoader: RaceWinnerLoader?
    private var raceWinnerLoader: RaceWinnerLoader {
        if _raceWinnerLoader == nil {
            // Create local and remote loaders
            let localLoader = LocalRaceWinnerLoader(localStorage: localStorage)
            let remoteLoader = RemoteRaceWinnerLoader(networkService: networkService)
            
            // Use decorator pattern: Local with Remote fallback
            _raceWinnerLoader = LocalWithRemoteRaceWinnerLoader(
                localLoader: localLoader,
                remoteLoader: remoteLoader
            )
            
            AppLogger.logViewModel("Initialized RaceWinnerLoader with Local+Remote decorator pattern")
        }
        return _raceWinnerLoader!
    }
    
    // MARK: - Coordinator
    func makeAppCoordinator() -> AppCoordinator {
        AppLogger.logNavigation("Creating AppCoordinator")
        return AppCoordinator(dependencyContainer: self)
    }
    
    // MARK: - ViewModel Factory Methods
    func makeSeasonsViewModel() -> SeasonsViewModel {
        AppLogger.logViewModel("Creating SeasonsViewModel")
        return SeasonsViewModel(seasonLoader: seasonLoader)
    }
    
    func makeRaceWinnerViewModel(for seasonYear: String) -> RaceWinnerViewModel {
        AppLogger.logViewModel("Creating RaceWinnerViewModel for season \(seasonYear)")
        return RaceWinnerViewModel(raceWinnerLoader: raceWinnerLoader, for: seasonYear)
    }
} 
