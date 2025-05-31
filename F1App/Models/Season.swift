import Foundation

struct Season: Codable, Identifiable, Hashable {
    var id: String { UUID.init().uuidString }
    let driver: String
    let season: String
    let constructor: String
}
