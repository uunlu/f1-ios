//
//  Season.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation

public struct Season: Codable, Identifiable, Hashable {
    public var id: String { UUID().uuidString }
    public let driver: String
    public let season: String
    public let constructor: String
}
