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
    // MARK: - Services
    private(set) var networkService: NetworkService
    private(set) var localStorage: LocalStorage
    private(set) var seasonLoader: SeasonLoader
    private(set) var raceWinnerLoader: RaceWinnerLoader
    
    // MARK: - Initialization
    init(
        networkService: NetworkService? = nil,
        localStorage: LocalStorage? = nil,
        seasonLoader: SeasonLoader? = nil,
        raceWinnerLoader: RaceWinnerLoader? = nil
    ) {
        AppLogger.logViewModel("Initializing DependencyContainer")
        
        // Initialize or use provided network service
        self.networkService = networkService ?? URLSessionNetworkService()
        
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
            self.seasonLoader = LocalWithRemoteSeasonLoader(
                localLoader: localLoader,
                remoteLoader: remoteLoader
            )
            AppLogger.logViewModel("Initialized SeasonLoader with Local+Remote decorator pattern")
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
    
    // MARK: - Factory Methods for App Components
    
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
        AppLogger.logViewModel("Creating RaceWinnerViewModel for season \(seasonYear)")
        return RaceWinnerViewModel(raceWinnerLoader: raceWinnerLoader, for: seasonYear)
    }
    
    // MARK: - Factory for creating container instances
    static func createDefault() -> DependencyContainer {
        return DependencyContainer()
    }
    
    static func createForTesting() -> DependencyContainer {
        // Create a container with mock implementations for testing
        let networkService = MockNetworkService()
        let localStorage = InMemoryLocalStorage()
        return DependencyContainer(
            networkService: networkService,
            localStorage: localStorage
        )
    }
}

// MARK: - Mock implementations for testing

class MockNetworkService: NetworkService {
    var responseData: Result<Data, Error> = .failure(NSError(domain: "MockNotConfigured", code: 0))
    var capturedRequest: URLRequest?
    
    func fetch(from request: URLRequest) async -> Result<Data, Error> {
        capturedRequest = request
        return responseData
    }
    
    // Helper methods to configure the mock
    func setSuccessResponse(_ data: Data) {
        responseData = .success(data)
    }
    
    func setErrorResponse(_ error: Error) {
        responseData = .failure(error)
    }
}

class InMemoryLocalStorage: LocalStorage {
    private var storage: [String: Data] = [:]
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func save<T: Codable>(_ data: T, forKey key: String) throws {
        let cachedData = CachedData(data: data)
        let encodedData = try encoder.encode(cachedData)
        storage[key] = encodedData
    }
    
    func load<T: Codable>(_ type: T.Type, forKey key: String) throws -> CachedData<T>? {
        guard let data = storage[key] else {
            return nil
        }
        
        return try decoder.decode(CachedData<T>.self, from: data)
    }
    
    func remove(forKey key: String) throws {
        storage.removeValue(forKey: key)
    }
    
    func clearAll() throws {
        storage.removeAll()
    }
}

class MockSeasonLoader: SeasonLoader {
    var result: Result<[Season], Error> = .failure(NSError(domain: "MockNotConfigured", code: 0))
    var capturedURL: URL?
    
    func fetch(from url: URL) async -> Result<[Season], Error> {
        capturedURL = url
        return result
    }
    
    func setSuccessResponse(_ seasons: [Season]) {
        result = .success(seasons)
    }
    
    func setErrorResponse(_ error: Error) {
        result = .failure(error)
    }
}

class MockRaceWinnerLoader: RaceWinnerLoader {
    var result: Result<[RaceWinner], Error> = .failure(NSError(domain: "MockNotConfigured", code: 0))
    var capturedURL: URL?
    
    func fetch(from url: URL) async -> Result<[RaceWinner], Error> {
        capturedURL = url
        return result
    }
    
    func setSuccessResponse(_ raceWinners: [RaceWinner]) {
        result = .success(raceWinners)
    }
    
    func setErrorResponse(_ error: Error) {
        result = .failure(error)
    }
}


