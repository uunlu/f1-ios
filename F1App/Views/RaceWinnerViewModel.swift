//
//  RaceWinnerViewModel.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation

class RaceWinnerViewModel: ObservableObject {
    @Published var raceWinners: [RaceWinner] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let raceWinnerLoader = RemoteRaceWinnerLoader(networkService: URLSessionNetworkService())
    
    @MainActor
    func loadRaceWinners() async {
        isLoading = true
        error = nil
        
        switch await raceWinnerLoader.fetch(from: APIConfig.raceWinnersURL(for: "2024")!) {
        case .success(let raceWinners):
            self.raceWinners = raceWinners
            self.isLoading = false
        case .failure(let failure):
            self.raceWinners = []
            self.error = error?.localizedLowercase
            self.isLoading = false
        }
    }
}
