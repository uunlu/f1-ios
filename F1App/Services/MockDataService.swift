import Foundation

class MockDataService {
    static let shared = MockDataService()
    
    private init() {}
    
    func getMockSeasons() -> [Season] {
        return [
            Season(
                id: 1,
                year: 2023,
                champion: "Max Verstappen",
                constructor: "Red Bull Racing",
                races: [
                    Season.Race(
                        id: 1,
                        name: "Bahrain Grand Prix",
                        date: "2023-03-05",
                        winner: "Max Verstappen",
                        constructor: "Red Bull Racing"
                    ),
                    Season.Race(
                        id: 2,
                        name: "Saudi Arabian Grand Prix",
                        date: "2023-03-19",
                        winner: "Sergio Perez",
                        constructor: "Red Bull Racing"
                    )
                ]
            ),
            Season(
                id: 2,
                year: 2022,
                champion: "Max Verstappen",
                constructor: "Red Bull Racing",
                races: [
                    Season.Race(
                        id: 1,
                        name: "Bahrain Grand Prix",
                        date: "2022-03-20",
                        winner: "Charles Leclerc",
                        constructor: "Ferrari"
                    ),
                    Season.Race(
                        id: 2,
                        name: "Saudi Arabian Grand Prix",
                        date: "2022-03-27",
                        winner: "Max Verstappen",
                        constructor: "Red Bull Racing"
                    )
                ]
            )
        ]
    }
} 