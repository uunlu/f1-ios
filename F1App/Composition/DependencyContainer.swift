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
    private lazy var networkService: NetworkService = {
        URLSessionNetworkService()
    }()
    
    // MARK: - Data Loaders
    private lazy var seasonLoader: SeasonLoader = {
        RemoteSeasonLoader(networkService: networkService)
    }()
    
    private lazy var raceWinnerLoader: RaceWinnerLoader = {
        RemoteRaceWinnerLoader(networkService: networkService)
    }()
    
    // MARK: - ViewModel Factory Methods
    func makeSeasonsViewModel() -> SeasonsViewModel {
        SeasonsViewModel(seasonLoader: seasonLoader)
    }
    
    func makeRaceWinnerViewModel() -> RaceWinnerViewModel {
        RaceWinnerViewModel(raceWinnerLoader: raceWinnerLoader)
    }
    
    func makeAppCoordinator() -> AppCoordinator {
        AppCoordinator(dependencyContainer: self)
    }
} 
