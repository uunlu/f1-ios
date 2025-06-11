//
//  Environment.swift
//  F1App
//
//  Created by Ugur Unlu on 29/05/2025.
//

import Foundation

enum Environment {
    case debug
    case development
    case production
    
    var baseURL: String {
        switch self {
        case .debug:
            return "http://localhost:8080/f1"
        case .development:
            return "http://dev-api.example.com/api"
        case .production:
            return "https://api.example.com/api"
        }
    }
}
