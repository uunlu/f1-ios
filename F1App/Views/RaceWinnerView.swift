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
            F1Colors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: F1Layout.spacing8) {
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
        .navigationTitle(String(format: NSLocalizedString("race_winners_navigation_title", comment: "Navigation title for race winners with season"), season.season))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            withAnimation(F1Animations.standardSpring.delay(F1Animations.standardDelay)) {
                isAppeared = true
            }
            
            if viewModel.raceWinners.isEmpty && !viewModel.isLoading {
                viewModel.loadRaceWinners()
            }
        }
    }
    
    private var seasonHeader: some View {
        let teamColor = F1Colors.teamColor(for: season.constructor)
        let teamGradient = F1Colors.teamGradient(for: season.constructor)
        
        return VStack(alignment: .leading, spacing: F1Layout.spacing12) {
            ZStack {
                RoundedRectangle(cornerRadius: F1Layout.cornerRadiusMedium)
                    .fill(F1Colors.cardBackground)
                    .f1ShadowLight()
                
                RoundedRectangle(cornerRadius: F1Layout.cornerRadiusMedium)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                teamColor.opacity(0.1),
                                teamColor.opacity(0.03)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                HStack(spacing: F1Layout.spacing12) {
                    // Champion badge - more compact
                    HStack(spacing: F1Layout.spacing4) {
                        Image(systemName: "crown.fill")
                            .font(F1Typography.caption1)
                            .foregroundColor(F1Colors.f1White)
                        
                        if viewModel.hasChampion {
                            Text(NSLocalizedString("world_champion", comment: "World Champion badge text"))
                                .f1TextStyle(F1Typography.caption1, color: F1Colors.f1White)
                                .fontWeight(.bold)
                                .lineLimit(1)
                        }
                    }
                    .padding(.horizontal, F1Layout.spacing8)
                    .padding(.vertical, F1Layout.spacing4)
                    .background(
                        RoundedRectangle(cornerRadius: F1Layout.cornerRadiusSmall)
                            .fill(teamGradient)
                    )
                    
                    Spacer()
                    
                    // Driver and constructor info - more compact layout
                    VStack(alignment: .trailing, spacing: F1Layout.spacing2) {
                        Text(season.driver)
                            .f1TextStyle(F1Typography.headline, color: F1Colors.textPrimary)
                            .fontWeight(.bold)
                        
                        HStack(spacing: F1Layout.spacing4) {
                            RoundedRectangle(cornerRadius: 1)
                                .fill(teamColor)
                                .frame(width: 3, height: 16)
                            
                            Text(season.constructor)
                                .f1TextStyle(F1Typography.subheadline, color: F1Colors.textSecondary)
                                .fontWeight(.medium)
                        }
                    }
                }
                .padding(.horizontal, F1Layout.spacing16)
                .padding(.vertical, F1Layout.spacing12)
                
                // Subtle border
                RoundedRectangle(cornerRadius: F1Layout.cornerRadiusMedium)
                    .stroke(teamColor.opacity(0.2), lineWidth: 1)
            }
            .frame(height: 80) // Fixed compact height
            
            F1Components.SectionHeader(title: NSLocalizedString("race_winners", comment: "Section header for race winners list"))
        }
        .padding(.horizontal, F1Layout.spacing16)
        .padding(.top, F1Layout.spacing8)
        .padding(.bottom, F1Layout.spacing4)
        .fadeScaleTransition(isActive: isAppeared)
    }
    
    private var loadingView: some View {
        ScrollView {
            LazyVStack(spacing: F1Layout.spacing16) {
                ForEach(0..<5, id: \.self) { index in
                    F1Components.LoadingListItem()
                        .padding(.horizontal, F1Layout.spacing20)
                        .fadeScaleTransition(isActive: isAppeared)
                        .animation(F1Animations.staggered(index: index), value: isAppeared)
                }
            }
            .padding(.vertical, F1Layout.spacing8)
        }
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize)
    }
    
    private func errorView(_ message: String) -> some View {
        VStack {
            Spacer()
            
            F1Components.ErrorView(message: message, retryAction: viewModel.loadRaceWinners)
                .padding(.horizontal, F1Layout.spacing20)
                .fadeScaleTransition(isActive: isAppeared)
            
            Spacer()
        }
    }
    
    private var raceWinnersList: some View {
        ScrollView {
            LazyVStack(spacing: F1Layout.spacing16) {
                ForEach(Array(viewModel.raceWinners.enumerated()), id: \.offset) { index, race in
                    F1Components.RaceWinnerItem(race: race)
                        .padding(.horizontal, F1Layout.spacing20)
                        .fadeScaleTransition(isActive: isAppeared)
                        .animation(F1Animations.staggered(index: index, baseDelay: F1Animations.staggerDelay), value: isAppeared)
                }
            }
            .padding(.vertical, F1Layout.spacing8)
        }
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize)
    }
}

#Preview {
    class MockSeasonLoader: SeasonLoader {
        func fetch(from url: URL) async -> Result<[Season], any Error> {
            .success([.init(driver: "driver", season: "2024", constructor: "constructor")])
        }
    }
    
    class MockRaceWinnerLoader: RaceWinnerLoader {
        func fetch(from url: URL) async -> Result<[RaceWinner], any Error> {
            .success([
                .init(
                    seasonDriverId: "seasonDriverId",
                    seasonConstructorId: "seasonConstructorId",
                    constructorName: "constructorName",
                    driver: .init(
                        driverId: "driverId",
                        familyName: "familyName",
                        givenName: "givenName"
                    ),
                    round: "round",
                    seasonName: "seasonName",
                    isChampion: true,
                    raceCompletionTime: "raceCompletionTime"
                )
            ])
        }
    }
    
    let container = DependencyContainer(
        networkService: MockNetworkService(),
        localStorage: nil,
        seasonLoader: MockSeasonLoader(),
        raceWinnerLoader: MockRaceWinnerLoader()
    )
    let viewModel = container.makeRaceWinnerViewModel(for: "2020")
    let mockSeason = Season(
        driver: "Max Verstappen",
        season: "2024",
        constructor: "Red Bull Racing"
    )
    
    return RaceWinnerView(viewModel: viewModel, season: mockSeason)
}
