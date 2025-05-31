import SwiftUI

class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    func showSeasonDetails(_ season: Season) {
        path.append(season)
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
} 