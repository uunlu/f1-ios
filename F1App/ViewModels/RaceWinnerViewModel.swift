//
//  RaceWinnerViewModel.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation

//class RaceWinnerViewModel: ObservableObject {
//    @Published var raceWinners: [RaceWinner] = []
//    @Published var isLoading = false
//    @Published var error: String?
//    
//    private let raceWinnerLoader: RaceWinnerLoader
//    private let seasonYear: String
//    private var loadTask: Task<Void, Never>?
//    
//    init(raceWinnerLoader: RaceWinnerLoader, for seasonYear: String) {
//        self.raceWinnerLoader = raceWinnerLoader
//        self.seasonYear = seasonYear
//    }
//    
//    deinit {
//        loadTask?.cancel()
//    }
//    
//    func loadRaceWinners() {
//        // Cancel any existing load task
//        loadTask?.cancel()
//        
//        Task { @MainActor in
//            self.isLoading = true
//            self.error = nil
//        }
//        
//        AppLogger.logViewModel("Loading race winners for season $seasonYear)")
//        
//        loadTask = Task {
//            guard let url = APIConfig.raceWinnersURL(for: seasonYear) else {
//                await updateState(error: "Invalid URL configuration", winners: [])
//                AppLogger.logError("Invalid URL configuration for race winners season $seasonYear)")
//                return
//            }
//            
//            // Perform network operation off the main thread
//            let result = await raceWinnerLoader.fetch(from: url)
//            
//            // Check if cancelled before updating UI
//            guard !Task.isCancelled else {
//                AppLogger.debug("Race winners loading task cancelled for season $seasonYear)")
//                return
//            }
//            
//            switch result {
//            case .success(let raceWinners):
//                AppLogger.logViewModel("Successfully loaded $raceWinners.count) race winners for season $seasonYear)")
//                await updateState(error: nil, winners: raceWinners)
//            case .failure(let failure):
//                AppLogger.logError("Failed to load race winners for season $seasonYear)", error: failure)
//                await updateState(error: failure.localizedDescription, winners: [])
//            }
//        }
//    }
//    
//    func cancelLoading() {
//        loadTask?.cancel()
//        
//        Task { @MainActor in
//            self.isLoading = false
//        }
//    }
//    
//    @MainActor
//    private func updateState(error: String?, winners: [RaceWinner]) {
//        self.error = error
//        self.raceWinners = winners
//        self.isLoading = false
//    }
//}

class RaceWinnerViewModel: ObservableObject {
    @Published var raceWinners: [RaceWinnerDomainModel] = []
    @Published var isLoading = false
    @Published var error: String?
    @Published var hasChampion: Bool = true
    
    private let raceWinnerLoader: RaceWinnerLoader
    private let seasonYear: String
    private var loadTask: Task<Void, Never>?
    
    init(raceWinnerLoader: RaceWinnerLoader, for seasonYear: String) {
        self.raceWinnerLoader = raceWinnerLoader
        self.seasonYear = seasonYear
    }
    
    deinit {
        loadTask?.cancel()
    }
    
    func loadRaceWinners() {
        // Cancel any existing load task
        loadTask?.cancel()
        
        Task { @MainActor in
            self.isLoading = true
            self.error = nil
        }
        
        AppLogger.logViewModel("Loading race winners for season $seasonYear)")
        
        loadTask = Task {
            guard let url = APIConfig.raceWinnersURL(for: seasonYear) else {
                await updateState(error: "Invalid URL configuration", winners: [])
                AppLogger.logError("Invalid URL configuration for race winners season $seasonYear)")
                return
            }
            
            // Perform network operation off the main thread
            let result = await raceWinnerLoader.fetch(from: url)
            
            // Check if cancelled before updating UI
            guard !Task.isCancelled else {
                AppLogger.debug("Race winners loading task cancelled for season $seasonYear)")
                return
            }
            
            switch result {
            case .success(let dtos):
                AppLogger.logViewModel("Successfully loaded $dtos.count) race winners for season $seasonYear)")
                // Convert DTOs to domain models
                let domainModels = RaceWinnerMapper.toDomain(dtos)
                await updateState(error: nil, winners: domainModels)
                
            case .failure(let failure):
                AppLogger.logError("Failed to load race winners for season $seasonYear)", error: failure)
                await updateState(error: failure.localizedDescription, winners: [])
            }
        }
    }
    
    func cancelLoading() {
        loadTask?.cancel()
        
        Task { @MainActor in
            self.isLoading = false
        }
    }
    
    @MainActor
    private func updateState(error: String?, winners: [RaceWinnerDomainModel]) {
        self.hasChampion = winners.contains(where: { $0.isChampion })
        self.error = error
        self.raceWinners = winners
        self.isLoading = false
    }
}
