//
//  NetworkError.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation

enum NetworkError: Error {
    case serverError(String)
    case parsingError(String)
    case invalidURL
}
