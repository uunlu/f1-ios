import SwiftUI

struct SeasonDetailsView: View {
    let season: Season
    @State private var isAppeared = false
    
    var body: some View {
        ZStack {
            F1Colors.background
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: F1Layout.spacing20) {
                    seasonHeader
                    
                    championDetails
                }
                .f1Padding()
            }
        }
        .navigationTitle("\(season.season) Season")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            withAnimation(F1Animations.standardSpring.delay(0.2)) {
                isAppeared = true
            }
        }
    }
    
    // Season header with large title
    private var seasonHeader: some View {
        VStack(alignment: .leading, spacing: F1Layout.spacing16) {
            Text(season.season)
                .f1TextStyle(F1Typography.largeTitle)
                .fadeScaleTransition(isActive: isAppeared)
        }
    }
    
    // Champion details with team branding
    private var championDetails: some View {
        let teamColor = F1Colors.teamColor(for: season.constructor)
        
        return VStack(alignment: .leading, spacing: F1Layout.spacing16) {
            F1Components.SectionHeader(title: "World Champion")
                .fadeScaleTransition(isActive: isAppeared)
            
            F1Components.F1Card(teamColor: teamColor) {
                VStack(alignment: .leading, spacing: F1Layout.spacing16) {
                    // Driver section
                    VStack(alignment: .leading, spacing: F1Layout.spacing8) {
                        Text("Driver")
                            .f1TextStyle(F1Typography.caption1, color: F1Colors.textSecondary)
                        
                        Text(season.driver)
                            .f1TextStyle(F1Typography.title2)
                    }
                    
                    Divider()
                        .background(F1Colors.separator)
                    
                    // Constructor section
                    VStack(alignment: .leading, spacing: F1Layout.spacing8) {
                        Text("Constructor")
                            .f1TextStyle(F1Typography.caption1, color: F1Colors.textSecondary)
                        
                        HStack {
                            Rectangle()
                                .fill(teamColor)
                                .frame(width: 4, height: 24)
                            
                            Text(season.constructor)
                                .f1TextStyle(F1Typography.headline)
                        }
                    }
                    
                    Divider()
                        .background(F1Colors.separator)
                    
                    // Championship info
                    VStack(alignment: .leading, spacing: F1Layout.spacing8) {
                        Text("Championship")
                            .f1TextStyle(F1Typography.caption1, color: F1Colors.textSecondary)
                        
                        HStack {
                            Image(systemName: "trophy.fill")
                                .foregroundColor(F1Colors.f1Red)
                                .font(.system(size: 20))
                            
                            Text("Formula 1 World Champion")
                                .f1TextStyle(F1Typography.headline)
                        }
                    }
                }
            }
            .fadeScaleTransition(isActive: isAppeared)
            .animation(F1Animations.standardSpring.delay(0.3), value: isAppeared)
        }
    }
} 
