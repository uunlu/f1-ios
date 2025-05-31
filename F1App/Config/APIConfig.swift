//
//  APIConfig.swift
//  F1App
//
//  Created by Ugur Unlu on 29/05/2025.
//

import Foundation

struct APIConfig {
    static let environment: Environment = {
        #if DEBUG
        return .debug
        #else
        return .production
        #endif
    }()
    
    static var baseURL: String {
        return environment.baseURL
    }
    
    // New functions to generate specific API endpoint URLs
    
    /// Creates URL for getting results for a specific year
    static func resultsURL(year: Int) -> URL? {
        let urlString = "\(baseURL)/results?year=\(year)"
        return URL(string: urlString)
    }
    
    /// Creates URL for getting season champions for a range of years
    static func seasonChampionsURL(startYear: Int, endYear: Int) -> URL? {
        let urlString = "\(baseURL)/season-champions?startYear=\(startYear)&endYear=\(endYear)"
        return URL(string: urlString)
    }
    
    static func seasonChampionsURL() -> URL? {
        let urlString = "\(baseURL)/seasons"
        return URL(string: urlString)
    }
    
    static func raceWinnersURL(for year: String) -> URL? {
        let urlString = "\(baseURL)/race-winners/\(year)"
        return URL(string: urlString)
    }
}
