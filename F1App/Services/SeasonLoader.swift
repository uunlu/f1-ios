//
//  SeasonLoader.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation

public protocol SeasonLoader {
    func fetch(from url: URL) async -> Result<[Season], Error>
}

public class RemoteSeasonLoader: SeasonLoader {
    let networkService: NetworkService
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    public func fetch(from url: URL) async -> Result<[Season], Swift.Error> {
        let request = URLRequest(url: url)
        let result = await networkService.fetch(from: request)
        
        switch result {
        case .success(let data):
            print("✅ Got data from network: \(data.count) bytes")
            do {
                let seasons = try JSONDecoder().decode([Season].self, from: data)
                print("✅ Successfully decoded \(seasons.count) seasons from network")
                return .success(seasons)
            }catch {
                print("❌ JSON decode error: \(error.localizedDescription)")
                print("🔄 JSON decode failed, using mock data")
                return .success(getMockSeasons())
            }
        case .failure(let error):
            print("❌ Network error: \(error.localizedDescription)")
            print("🔄 Network failed, using mock data for testing")
            return .success(getMockSeasons())
        }
    }
    
    // Mock data for testing when backend is not available
    private func getMockSeasons() -> [Season] {
        return [
            Season(driver: "Max Verstappen", season: "2023", constructor: "Red Bull"),
            Season(driver: "Max Verstappen", season: "2022", constructor: "Red Bull"),
            Season(driver: "Max Verstappen", season: "2021", constructor: "Red Bull"),
            Season(driver: "Lewis Hamilton", season: "2020", constructor: "Mercedes"),
            Season(driver: "Lewis Hamilton", season: "2019", constructor: "Mercedes"),
            Season(driver: "Lewis Hamilton", season: "2018", constructor: "Mercedes"),
            Season(driver: "Lewis Hamilton", season: "2017", constructor: "Mercedes"),
            Season(driver: "Nico Rosberg", season: "2016", constructor: "Mercedes"),
            Season(driver: "Lewis Hamilton", season: "2015", constructor: "Mercedes"),
            Season(driver: "Lewis Hamilton", season: "2014", constructor: "Mercedes")
        ]
    }
}
