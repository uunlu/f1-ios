import SwiftUI

@MainActor
class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    private let dependencyContainer: DependencyContainer
    
    init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
        AppLogger.logNavigation("AppCoordinator initialized")
    }
    
    // MARK: - Navigation Actions
    func showSeasonDetails(_ season: Season) {
        AppLogger.logNavigation("Navigating to season details for \(season.season)")
        path.append(season)
    }
    
    func showRaceWinners(for season: Season) {
        AppLogger.logNavigation("Navigating to race winners for \(season.season)")
        path.append(season)  // Use Season directly to match navigationDestination
    }
    
    func popToRoot() {
        AppLogger.logNavigation("Popping to root (removing \(path.count) views)")
        path.removeLast(path.count)
    }
    
    func goBack() {
        if !path.isEmpty {
            AppLogger.logNavigation("Going back one view")
            path.removeLast()
        } else {
            AppLogger.logNavigation("Cannot go back - already at root")
        }
    }
    
    // MARK: - View Factory Methods
    func makeSeasonsView() -> AnyView {
        AppLogger.logNavigation("Creating SeasonsView")
        let viewModel = dependencyContainer.makeSeasonsViewModel()
        return SeasonsView(viewModel: viewModel)
            .eraseToAnyView()
    }
    
    func makeRaceWinnerView(for season: Season) -> AnyView {
        AppLogger.logNavigation("Creating RaceWinnerView for season \(season.season)")
        let viewModel = dependencyContainer.makeRaceWinnerViewModel(for: season.season)
        return RaceWinnerView(viewModel: viewModel, season: season)
            .eraseToAnyView()
    }
}

// MARK: - Navigation Destinations
struct RaceWinnerDestination: Hashable {
    let season: Season
} 
