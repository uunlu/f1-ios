import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
}


class StandardNetworkService {
    static let shared = StandardNetworkService()
    private let baseURL = APIConfig.baseURL
    
    private init() {}
    
    func fetchSeasons() async throws -> [Season] {
        guard let url1 = URL(string: "\(baseURL)/seasons") else {
            throw NetworkError.invalidURL
        }
        
//        var url = URL(string: "https://89ee-128-77-59-67.ngrok-free.app/api/f1/seasons")!
//        let (data, response) = try await URLSession.shared.data(from: url)
        
        let session = URLSession(configuration: .default)
//        var request = URLRequest(url: URL(string: "https://89ee-128-77-59-67.ngrok-free.app/api/f1/seasons")!)
        var request = URLRequest(url: URL(string: "https://google.com")!)
        request.timeoutInterval = 30
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError("Invalid response")
        }
        
        do {
            let seasons = try JSONDecoder().decode([Season].self, from: data)
            return seasons
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func fetchSeasonDetails(year: Int) async throws -> Season {
        guard let url = URL(string: "\(baseURL)/seasons/\(year)") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError("Invalid response")
        }
        
        do {
            let season = try JSONDecoder().decode(Season.self, from: data)
            return season
        } catch {
            throw NetworkError.decodingError
        }
    }
} 
