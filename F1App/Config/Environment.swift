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
            return "https://89ee-128-77-59-67.ngrok-free.app/api/f1"
//            return "http://localhost:8080/api/f1"
//            return "http://192.168.2.9:8080/api/f1"
        case .development:
            return "http://dev-api.example.com/api"
        case .production:
            return "https://api.example.com/api"
        }
    }
}
