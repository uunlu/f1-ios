import Foundation

struct Season: Codable, Identifiable, Hashable {
    let id: Int
    let year: Int
    let champion: String
    let constructor: String
    let races: [Race]
    
    struct Race: Codable, Identifiable, Hashable {
        let id: Int
        let name: String
        let date: String
        let winner: String
        let constructor: String
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Season, rhs: Season) -> Bool {
        lhs.id == rhs.id
    }
} 