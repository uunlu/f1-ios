//
//  RaceWinnerView.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import SwiftUI

struct RaceWinnerView: View {
    @StateObject private var viewModel: RaceWinnerViewModel
    private let season: Season
    
    init(viewModel: RaceWinnerViewModel, season: Season) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.season = season
    }

    var body: some View {
        List(viewModel.raceWinners, id: \.round) { raceWinner in
            RaceWinnerItemView(raceWinner: raceWinner)
        }
        .navigationTitle("Race Winners - \(season.season)")
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .alert("Error", isPresented: .constant(viewModel.error != nil)) {
            Button("OK") {
                viewModel.error = nil
            }
        } message: {
            Text(viewModel.error ?? "")
        }
        .task {
            await viewModel.loadRaceWinners()
        }
    }
}

struct RaceWinnerItemView: View {
    let raceWinner: RaceWinner

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Driver: \(raceWinner.driver.givenName) \(raceWinner.driver.familyName)")
                .font(.headline)
                .foregroundColor(.primary)

            Text("Constructor: \(raceWinner.constructorName)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text("Season: \(raceWinner.seasonName)")
                .font(.subheadline)

            Text("Round: \(raceWinner.round)")
                .font(.subheadline)

            if raceWinner.champion {
                Text("🏆 Champion")
                    .font(.subheadline)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

#Preview {
    let container = DependencyContainer.shared
    let viewModel = container.makeRaceWinnerViewModel()
    let mockSeason = Season(driver: "Mock Driver", season: "2024", constructor: "Mock Team")
    
    return RaceWinnerView(viewModel: viewModel, season: mockSeason)
}
