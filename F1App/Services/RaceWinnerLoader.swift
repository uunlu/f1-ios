//
//  RaceWinnerLoader.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation

protocol RaceWinnerLoader {
    func fetch(from url: URL) async -> Result<[RaceWinner], Error>
}

class RemoteRaceWinnerLoader: RaceWinnerLoader {
    enum Error: Swift.Error {
        case decodingFailure
    }
    let networkService: NetworkService
    
    init(networkService: NetworkService = URLSessionNetworkService()) {
        self.networkService = networkService
    }
    
    func fetch(from url: URL) async -> Result<[RaceWinner], Swift.Error> {
        let request = URLRequest(url: url)
        switch await networkService.fetch(from: request) {
        case .success(let data):
            do {
                let result = try JSONDecoder().decode([RaceWinner].self, from: data)
                print(result)
                return .success(result)
            }catch {
                return .failure(Error.decodingFailure)
            }
        case .failure(let failure):
            print(failure)
            return .failure(failure)
        }
    }
    
    
}
