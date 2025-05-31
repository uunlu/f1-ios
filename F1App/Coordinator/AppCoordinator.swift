import SwiftUI

@MainActor
class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    private let dependencyContainer: DependencyContainer
    
    init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
    }
    
    // MARK: - Navigation Actions
    func showSeasonDetails(_ season: Season) {
        path.append(season)
    }
    
    func showRaceWinners(for season: Season) {
        path.append(RaceWinnerDestination(season: season))
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func goBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    // MARK: - View Factory Methods
    func makeSeasonsView() -> AnyView {
        let viewModel = dependencyContainer.makeSeasonsViewModel()
        return SeasonsView(viewModel: viewModel)
            .eraseToAnyView()
    }
    
    func makeRaceWinnerView(for season: Season) -> AnyView {
        let viewModel = dependencyContainer.makeRaceWinnerViewModel()
        return RaceWinnerView(viewModel: viewModel, season: season)
            .eraseToAnyView()
    }
    
    func makeSeasonDetailsView(for season: Season) -> AnyView {
        return SeasonDetailsView(season: season)
            .eraseToAnyView()
    }
}

// MARK: - Navigation Destinations
struct RaceWinnerDestination: Hashable {
    let season: Season
} 
