import Foundation

public struct Season: Codable, Identifiable, Hashable {
    public var id: String { UUID.init().uuidString }
    public let driver: String
    public let season: String
    public let constructor: String
}
