//
//  RaceWinnerView.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import SwiftUI


struct RaceWinnerView: View {
    @StateObject var raceWinnerViewModel = RaceWinnerViewModel()
    
    @State private var raceWinners: [RaceWinner] = [
        RaceWinner(
            seasonDriverId: nil,
            seasonConstructorId: "mclaren",
            constructorName: "McLaren",
            driver: Driver(driverId: "piastri", familyName: "Piastri", givenName: "Oscar"),
            round: "17",
            seasonName: "2024",
            champion: false
        ),
        RaceWinner(
            seasonDriverId: "hamilton2023",
            seasonConstructorId: "mercedes",
            constructorName: "Mercedes",
            driver: Driver(driverId: "hamilton", familyName: "Hamilton", givenName: "Lewis"),
            round: "16",
            seasonName: "2023",
            champion: true
        )
    ]

    var body: some View {
        NavigationView {
            List(raceWinnerViewModel.raceWinners, id: \.round) { raceWinner in
                RaceWinnerItemView(raceWinner: raceWinner)
            }
            .navigationTitle("Race Winners")
        }.task {
            await raceWinnerViewModel.loadRaceWinners()
        }
    }
}

struct RaceWinnerItemView: View {
    let raceWinner: RaceWinner

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Driver: \(raceWinner.driver.givenName) \(raceWinner.driver.familyName)")
                .font(.headline)
                .foregroundColor(.primary)

            Text("Constructor: \(raceWinner.constructorName)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text("Season: \(raceWinner.seasonName)")
                .font(.subheadline)

            Text("Round: \(raceWinner.round)")
                .font(.subheadline)

            if raceWinner.champion {
                Text("🏆 Champion")
                    .font(.subheadline)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}


#Preview {
    RaceWinnerView()
}
