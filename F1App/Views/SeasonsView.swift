import SwiftUI

struct SeasonsView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var viewModel: SeasonsViewModel
    @State private var isAppeared = false
    
    init(viewModel: SeasonsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            F1Colors.background
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header
                F1Components.SectionHeader(
                    title: "F1 World Champions",
                    subtitle: "Formula 1 Championship History"
                )
                .f1Padding()
                .fadeScaleTransition(isActive: isAppeared)
                
                if viewModel.isLoading {
                    loadingView
                } else if let error = viewModel.error {
                    errorView(error)
                } else {
                    seasonsList
                }
            }
        }
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            withAnimation(F1Animations.standardSpring.delay(0.2)) {
                isAppeared = true
            }
            
            if viewModel.seasons.isEmpty && !viewModel.isLoading {
                Task {
                    await viewModel.loadSeasons()
                }
            }
        }
    }
    
    // Loading view with racing stripe animation
    private var loadingView: some View {
        ScrollView {
            LazyVStack(spacing: F1Layout.spacing12) {
                ForEach(0..<6, id: \.self) { index in
                    F1Components.LoadingListItem()
                        .padding(.horizontal, F1Layout.spacing16)
                        .fadeScaleTransition(isActive: isAppeared)
                        .animation(F1Animations.staggered(index: index), value: isAppeared)
                }
            }
            .padding(.vertical, F1Layout.spacing16)
        }
    }
    
    // Error view
    private func errorView(_ message: String) -> some View {
        F1Components.ErrorView(message: message) {
            Task {
                await viewModel.loadSeasons()
            }
        }
        .fadeScaleTransition(isActive: isAppeared)
    }
    
    // Seasons list with beautiful animations
    private var seasonsList: some View {
        ScrollView {
            LazyVStack(spacing: F1Layout.spacing12) {
                ForEach(Array(viewModel.seasons.enumerated()), id: \.element.id) { index, season in
                    F1Components.SeasonListItem(season: season) {
                        coordinator.showRaceWinners(for: season)
                    }
                    .padding(.horizontal, F1Layout.spacing16)
                    .fadeScaleTransition(isActive: isAppeared)
                    .animation(F1Animations.staggered(index: index, baseDelay: 0.05), value: isAppeared)
                }
            }
            .padding(.vertical, F1Layout.spacing16)
        }
        .navigationDestination(for: Season.self) { season in
            coordinator.makeSeasonDetailsView(for: season)
        }
        .navigationDestination(for: RaceWinnerDestination.self) { destination in
            coordinator.makeRaceWinnerView(for: destination.season)
        }
    }
} 
