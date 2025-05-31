import Foundation

@MainActor
class SeasonsViewModel: ObservableObject {
    @Published var seasons: [Season] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let seasonLoader = RemoteSeasonLoader(networkService: URLSessionNetworkService())
    //    private let mockService = MockDataService.shared
    
    func loadSeasons() async {
        isLoading = true
        error = nil
        
        // Temporarily use mock data
        //        seasons = mockService.getMockSeasons()
        //        isLoading = false
        
        
        switch await seasonLoader.fetch(from: APIConfig.seasonChampionsURL()!) {
        case .success(let seasons):
            self.seasons = seasons
            self.isLoading = false
        case .failure(let error):
            self.seasons = []
            self.error = error.localizedDescription
            self.isLoading = false
        }
    }
} 
