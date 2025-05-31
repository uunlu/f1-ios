import Foundation

@MainActor
class SeasonsViewModel: ObservableObject {
    @Published var seasons: [Season] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let networkService = NetworkService.shared
    private let mockService = MockDataService.shared
    
    func loadSeasons() {
        isLoading = true
        error = nil
        
        // Temporarily use mock data
//        seasons = mockService.getMockSeasons()
//        isLoading = false
        
        // Uncomment this when backend is ready
        Task {
            do {
                seasons = try await networkService.fetchSeasons()
            } catch {
                self.error = error.localizedDescription
            }
            isLoading = false
        }
    }
} 
