//
//  RaceWinnerViewModel.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation

@MainActor
class RaceWinnerViewModel: ObservableObject {
    @Published var raceWinners: [RaceWinner] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let raceWinnerLoader: RaceWinnerLoader
    
    init(raceWinnerLoader: RaceWinnerLoader) {
        self.raceWinnerLoader = raceWinnerLoader
    }
    
    func loadRaceWinners() async {
        isLoading = true
        error = nil
        
        switch await raceWinnerLoader.fetch(from: APIConfig.raceWinnersURL(for: "2024")!) {
        case .success(let raceWinners):
            self.raceWinners = raceWinners
            self.isLoading = false
        case .failure(let failure):
            self.raceWinners = []
            self.error = failure.localizedDescription
            self.isLoading = false
        }
    }
}
