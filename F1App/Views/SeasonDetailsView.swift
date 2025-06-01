import SwiftUI

struct SeasonDetailsView: View {
    let season: Season
    @State private var isAppeared = false
    
    var body: some View {
        ZStack {
            F1Colors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: F1Layout.spacing32) {
                    seasonHeader
                    championDetails
                }
                .f1Padding(EdgeInsets(
                    top: F1Layout.spacing24,
                    leading: F1Layout.spacing20,
                    bottom: F1Layout.spacing32,
                    trailing: F1Layout.spacing20
                ))
            }
            .scrollIndicators(.hidden)
            .scrollBounceBehavior(.basedOnSize)
        }
        .navigationTitle("\(season.season) Season")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            withAnimation(F1Animations.standardSpring.delay(0.2)) {
                isAppeared = true
            }
        }
    }
    
    // Premium season header using reusable components
    private var seasonHeader: some View {
        let teamColor = F1Colors.teamColor(for: season.constructor)
        
        return F1Components.GradientCard(accentColor: teamColor, animateOnAppear: isAppeared) {
            HStack {
                F1Components.LabeledContent(label: "Season") {
                    Text(season.season)
                        .f1TextStyle(F1Typography.largeTitle, color: F1Colors.textPrimary)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                F1Components.CircleIcon(
                    size: .large,
                    icon: "trophy.fill",
                    color: teamColor
                )
            }
        }
    }
    
    // Premium champion details with reusable components
    private var championDetails: some View {
        let teamColor = F1Colors.teamColor(for: season.constructor)
        
        return VStack(alignment: .leading, spacing: F1Layout.spacing24) {
            F1Components.SectionHeader(title: "World Champion")
                .fadeScaleTransition(isActive: isAppeared)
            
            F1Components.GradientCard(accentColor: teamColor, animateOnAppear: isAppeared) {
                VStack(alignment: .leading, spacing: F1Layout.spacing24) {
                    // Driver section with champion badge
                    F1Components.LabeledContent(label: "Driver") {
                        HStack {
                            Text(season.driver)
                                .f1TextStyle(F1Typography.title2, color: F1Colors.textPrimary)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            F1Components.ChampionBadge()
                        }
                    }
                    
                    F1Components.GradientDivider()
                    
                    // Constructor section with team color bar
                    F1Components.LabeledContent(label: "Constructor") {
                        HStack(spacing: F1Layout.spacing12) {
                            F1Components.TeamColorBar(color: teamColor, height: 32)
                            
                            Text(season.constructor)
                                .f1TextStyle(F1Typography.headline, color: F1Colors.textPrimary)
                                .fontWeight(.semibold)
                        }
                    }
                    
                    F1Components.GradientDivider()
                    
                    // Championship info
                    F1Components.LabeledContent(label: "Championship") {
                        HStack(spacing: F1Layout.spacing12) {
                            F1Components.CircleIcon(
                                size: .small,
                                icon: "trophy.fill",
                                color: F1Colors.f1Red,
                                backgroundColor: F1Colors.f1Red.opacity(0.2)
                            )
                            
                            VStack(alignment: .leading, spacing: F1Layout.spacing2) {
                                Text("Formula 1 World Championship")
                                    .f1TextStyle(F1Typography.headline, color: F1Colors.textPrimary)
                                    .fontWeight(.semibold)
                                
                                Text("Drivers' Championship Winner")
                                    .f1TextStyle(F1Typography.subheadline, color: F1Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            .animation(F1Animations.standardSpring.delay(0.3), value: isAppeared)
        }
    }
} 
