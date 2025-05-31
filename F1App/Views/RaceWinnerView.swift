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
    @State private var isAppeared = false
    
    init(viewModel: RaceWinnerViewModel, season: Season) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.season = season
    }

    var body: some View {
        ZStack {
            F1Colors.background
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                seasonHeader
                
                if viewModel.isLoading {
                    loadingView
                } else if let error = viewModel.error {
                    errorView(error)
                } else {
                    raceWinnersList
                }
            }
        }
        .navigationTitle("Race Winners - \(season.season)")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            withAnimation(F1Animations.standardSpring.delay(0.2)) {
                isAppeared = true
            }
            
            if viewModel.raceWinners.isEmpty && !viewModel.isLoading {
                Task {
                    await viewModel.loadRaceWinners()
                }
            }
        }
    }
    
    // Season header with team branding
    private var seasonHeader: some View {
        let teamColor = F1Colors.teamColor(for: season.constructor)
        
        return VStack(alignment: .leading, spacing: F1Layout.spacing16) {
            F1Components.F1Card(teamColor: teamColor) {
                VStack(alignment: .leading, spacing: F1Layout.spacing12) {
                    Text("World Champion")
                        .f1TextStyle(F1Typography.caption1, color: F1Colors.textSecondary)
                    
                    Text(season.driver)
                        .f1TextStyle(F1Typography.title2)
                    
                    Divider().background(F1Colors.separator)
                    
                    Text("Constructor")
                        .f1TextStyle(F1Typography.caption1, color: F1Colors.textSecondary)
                    
                    Text(season.constructor)
                        .f1TextStyle(F1Typography.headline)
                }
            }
            
            F1Components.SectionHeader(title: "Race Winners")
                .padding(.top, F1Layout.spacing8)
        }
        .f1Padding()
        .fadeScaleTransition(isActive: isAppeared)
    }
    
    // Loading view with racing stripe animation
    private var loadingView: some View {
        ScrollView {
            LazyVStack(spacing: F1Layout.spacing12) {
                ForEach(0..<5, id: \.self) { index in
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
                await viewModel.loadRaceWinners()
            }
        }
        .fadeScaleTransition(isActive: isAppeared)
    }
    
    // Race winners list with beautiful animations
    private var raceWinnersList: some View {
        ScrollView {
            LazyVStack(spacing: F1Layout.spacing12) {
                ForEach(Array(viewModel.raceWinners.enumerated()), id: \.offset) { index, race in
                    F1Components.RaceWinnerItem(race: race)
                        .padding(.horizontal, F1Layout.spacing16)
                        .fadeScaleTransition(isActive: isAppeared)
                        .animation(F1Animations.staggered(index: index, baseDelay: 0.05), value: isAppeared)
                }
            }
            .padding(.vertical, F1Layout.spacing16)
        }
    }
}

#Preview {
    let container = DependencyContainer.shared
    let viewModel = container.makeRaceWinnerViewModel()
    let mockSeason = Season(driver: "Max Verstappen", season: "2024", constructor: "Red Bull Racing")
    
    return RaceWinnerView(viewModel: viewModel, season: mockSeason)
}
