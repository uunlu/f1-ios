import SwiftUI

struct SeasonDetailsView: View {
    let season: Season
    
    var body: some View {
        List {
            Section("Champion") {
                VStack(alignment: .leading, spacing: 8) {
                    Text(season.champion)
                        .font(.headline)
                    Text(season.constructor)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Section("Races") {
                ForEach(season.races) { race in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(race.name)
                            .font(.headline)
                        Text(race.date)
                            .font(.subheadline)
                        Text("Winner: \(race.winner)")
                            .font(.subheadline)
                        Text("Constructor: \(race.constructor)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("\(season.year) Season")
    }
} 