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
                viewModel.loadRaceWinners()
            }
        }
    }
    
    private var seasonHeader: some View {
        let teamColor = F1Colors.teamColor(for: season.constructor)
        let teamGradient = F1Colors.teamGradient(for: season.constructor)
        
        return VStack(alignment: .leading, spacing: F1Layout.spacing20) {
            ZStack {
                RoundedRectangle(cornerRadius: F1Layout.cornerRadiusLarge)
                    .fill(F1Colors.cardBackground)
                    .f1ShadowHeavy()
                
                RoundedRectangle(cornerRadius: F1Layout.cornerRadiusLarge)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                teamColor.opacity(0.15),
                                teamColor.opacity(0.05)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                VStack(alignment: .leading, spacing: F1Layout.spacing16) {
                    // Champion badge
                    HStack {
                        HStack(spacing: F1Layout.spacing6) {
                            Image(systemName: "crown.fill")
                                .font(.system(size: F1Layout.iconSmall))
                                .foregroundColor(F1Colors.f1White)
                            
                            Text("World Champion")
                                .f1TextStyle(F1Typography.caption1, color: F1Colors.f1White)
                                .fontWeight(.bold)
                                .lineLimit(1)
                        }
                        .padding(.horizontal, F1Layout.spacing12)
                        .padding(.vertical, F1Layout.spacing6)
                        .background(
                            RoundedRectangle(cornerRadius: F1Layout.cornerRadiusSmall)
                                .fill(teamGradient)
                        )
                        .f1ShadowLight()
                        
                        Spacer()
                    }
                    
                    // Driver info
                    VStack(alignment: .leading, spacing: F1Layout.spacing8) {
                        Text(season.driver)
                            .f1TextStyle(F1Typography.title2, color: F1Colors.textPrimary)
                            .fontWeight(.bold)
                        
                        HStack(spacing: F1Layout.spacing8) {
                            RoundedRectangle(cornerRadius: F1Layout.spacing2)
                                .fill(teamColor)
                                .frame(width: 4, height: 24)
                            
                            Text(season.constructor)
                                .f1TextStyle(F1Typography.headline, color: F1Colors.textPrimary)
                                .fontWeight(.medium)
                        }
                    }
                }
                .f1Padding(F1Layout.cardInsets)
                
                // Premium border
                RoundedRectangle(cornerRadius: F1Layout.cornerRadiusLarge)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                teamColor.opacity(0.4),
                                teamColor.opacity(0.1)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: F1Layout.borderWidth
                    )
            }
            
            F1Components.SectionHeader(title: "Race Winners")
        }
        .f1Padding(EdgeInsets(
            top: F1Layout.spacing16,
            leading: F1Layout.spacing20,
            bottom: F1Layout.spacing8,
            trailing: F1Layout.spacing20
        ))
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
                        .animation(F1Animations.staggered(index: index, baseDelay: 0.05), value: isAppeared)
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
            return .success([.init(driver: "driver", season: "2024", constructor: "constructor")])
        }
    }
    
    class MockRaceWinnerLoader: RaceWinnerLoader {
        func fetch(from url: URL) async -> Result<[RaceWinner], any Error> {
            return .success([.init(seasonDriverId: nil, seasonConstructorId: "seasonConstructorId", constructorName: "constructorName", driver: .init(driverId: "driverId", familyName: "familyName", givenName: "givenName"), round: "round", seasonName: "seasonName", champion: true)])
        }
    }
    
    let container = DependencyContainer(networkService: MockNetworkService(), localStorage: nil, seasonLoader: MockSeasonLoader(), raceWinnerLoader: MockRaceWinnerLoader())
    let viewModel = container.makeRaceWinnerViewModel(for: "2020")
    let mockSeason = Season(driver: "Max Verstappen", season: "2024", constructor: "Red Bull Racing")
    
    return RaceWinnerView(viewModel: viewModel, season: mockSeason)
}
