import SwiftUI

struct SeasonsView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var viewModel: SeasonsViewModel
    
    init(viewModel: SeasonsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List(viewModel.seasons) { season in
            Button {
                coordinator.showRaceWinners(for: season)
            } label: {
                SeasonRow(season: season)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .navigationTitle("F1 World Champions")
        .navigationDestination(for: Season.self) { season in
            coordinator.makeSeasonDetailsView(for: season)
        }
        .navigationDestination(for: RaceWinnerDestination.self) { destination in
            coordinator.makeRaceWinnerView(for: destination.season)
        }
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
            await viewModel.loadSeasons()
        }
    }
}

struct SeasonRow: View {
    let season: Season
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(season.season)")
                .font(.headline)
            Text("Champion: \(season.constructor)")
                .font(.subheadline)
            Text("Constructor: \(season.driver)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
} 
