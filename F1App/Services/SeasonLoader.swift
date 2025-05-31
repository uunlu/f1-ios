//
//  SeasonLoader.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation

protocol SeasonLoader {
    func fetch(from url: URL) async -> Result<[Season], Error>
}

class RemoteSeasonLoader: SeasonLoader {
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetch(from url: URL) async -> Result<[Season], Swift.Error> {
        let request = URLRequest(url: url)
        let result = await networkService.fetch(from: request)
        
        switch result {
        case .success(let data):
            print(data)
            do {
                let seasons = try JSONDecoder().decode([Season].self, from: data)
                return .success(seasons)
            }catch {
                print(error.localizedDescription)
                return .failure(error)
            }
        case .failure(let error):
            print(error.localizedDescription)
            return .failure(error)
        }
    }
    
    
}
