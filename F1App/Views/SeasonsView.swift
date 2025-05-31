import SwiftUI

struct SeasonsView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var viewModel: SeasonsViewModel
    
    var body: some View {
        List(viewModel.seasons) { season in
            NavigationLink(value: season) {
                SeasonRow(season: season)
            }
        }
        .navigationTitle("F1 World Champions")
        .navigationDestination(for: Season.self) { season in
            RaceWinnerView()
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
