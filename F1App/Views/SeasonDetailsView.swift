import SwiftUI

struct SeasonDetailsView: View {
    let season: Season
    @State private var isAppeared = false
    
    var body: some View {
        ZStack {
            // Premium background gradient
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
    
    // Premium season header
    private var seasonHeader: some View {
        let teamColor = F1Colors.teamColor(for: season.constructor)
        
        return ZStack {
            RoundedRectangle(cornerRadius: F1Layout.cornerRadiusLarge)
                .fill(F1Colors.cardBackground)
                .f1ShadowHeavy()
            
            RoundedRectangle(cornerRadius: F1Layout.cornerRadiusLarge)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            teamColor.opacity(0.1),
                            teamColor.opacity(0.03)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(alignment: .leading, spacing: F1Layout.spacing20) {
                // Year display with team accent
                HStack {
                    VStack(alignment: .leading, spacing: F1Layout.spacing8) {
                        Text("Season")
                            .f1TextStyle(F1Typography.caption1, color: F1Colors.textTertiary)
                            .fontWeight(.medium)
                        
                        Text(season.season)
                            .f1TextStyle(F1Typography.largeTitle, color: F1Colors.textPrimary)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    // Team color accent circle
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        teamColor,
                                        teamColor.opacity(0.7)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "trophy.fill")
                            .font(.system(size: F1Layout.iconLarge))
                            .foregroundColor(F1Colors.f1White)
                    }
                    .f1ShadowLight()
                }
            }
            .f1Padding(F1Layout.cardInsets)
            
            // Premium border
            RoundedRectangle(cornerRadius: F1Layout.cornerRadiusLarge)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            teamColor.opacity(0.3),
                            teamColor.opacity(0.1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: F1Layout.borderWidth
                )
        }
        .fadeScaleTransition(isActive: isAppeared)
    }
    
    // Premium champion details with sophisticated styling
    private var championDetails: some View {
        let teamColor = F1Colors.teamColor(for: season.constructor)
        let teamGradient = F1Colors.teamGradient(for: season.constructor)
        
        return VStack(alignment: .leading, spacing: F1Layout.spacing24) {
            F1Components.SectionHeader(title: "World Champion")
                .fadeScaleTransition(isActive: isAppeared)
            
            ZStack {
                RoundedRectangle(cornerRadius: F1Layout.cornerRadiusLarge)
                    .fill(F1Colors.cardBackground)
                    .f1ShadowHeavy()
                
                RoundedRectangle(cornerRadius: F1Layout.cornerRadiusLarge)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                teamColor.opacity(0.12),
                                teamColor.opacity(0.04)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                VStack(alignment: .leading, spacing: F1Layout.spacing24) {
                    // Driver section with premium styling
                    VStack(alignment: .leading, spacing: F1Layout.spacing12) {
                        HStack {
                            Text("Driver")
                                .f1TextStyle(F1Typography.caption1, color: F1Colors.textTertiary)
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            // Champion badge
                            ZStack {
                                RoundedRectangle(cornerRadius: F1Layout.cornerRadiusSmall)
                                    .fill(F1Colors.f1Gradient)
                                    .frame(width: 80, height: 24)
                                
                                HStack(spacing: F1Layout.spacing4) {
                                    Image(systemName: "crown.fill")
                                        .font(.system(size: 10))
                                        .foregroundColor(F1Colors.f1White)
                                    
                                    Text("CHAMPION")
                                        .f1TextStyle(F1Typography.caption2, color: F1Colors.f1White)
                                        .fontWeight(.bold)
                                }
                            }
                            .f1ShadowLight()
                        }
                        
                        Text(season.driver)
                            .f1TextStyle(F1Typography.title2, color: F1Colors.textPrimary)
                            .fontWeight(.bold)
                    }
                    
                    // Elegant divider
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.clear,
                                    F1Colors.separator,
                                    Color.clear
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 1)
                    
                    // Constructor section with team branding
                    VStack(alignment: .leading, spacing: F1Layout.spacing12) {
                        Text("Constructor")
                            .f1TextStyle(F1Typography.caption1, color: F1Colors.textTertiary)
                            .fontWeight(.medium)
                        
                        HStack(spacing: F1Layout.spacing12) {
                            // Team color accent
                            RoundedRectangle(cornerRadius: F1Layout.spacing3)
                                .fill(teamGradient)
                                .frame(width: 6, height: 32)
                                .f1ShadowLight()
                            
                            Text(season.constructor)
                                .f1TextStyle(F1Typography.headline, color: F1Colors.textPrimary)
                                .fontWeight(.semibold)
                        }
                    }
                    
                    // Another elegant divider
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.clear,
                                    F1Colors.separator,
                                    Color.clear
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 1)
                    
                    // Championship info with premium styling
                    VStack(alignment: .leading, spacing: F1Layout.spacing12) {
                        Text("Championship")
                            .f1TextStyle(F1Typography.caption1, color: F1Colors.textTertiary)
                            .fontWeight(.medium)
                        
                        HStack(spacing: F1Layout.spacing12) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                F1Colors.f1Red.opacity(0.2),
                                                F1Colors.f1Red.opacity(0.1)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 32, height: 32)
                                
                                Image(systemName: "trophy.fill")
                                    .foregroundColor(F1Colors.f1Red)
                                    .font(.system(size: F1Layout.iconSmall))
                            }
                            
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
                .f1Padding(F1Layout.cardInsets)
                
                // Premium border with team color
                RoundedRectangle(cornerRadius: F1Layout.cornerRadiusLarge)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                teamColor.opacity(0.4),
                                teamColor.opacity(0.1)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: F1Layout.borderWidth
                    )
            }
            .fadeScaleTransition(isActive: isAppeared)
            .animation(F1Animations.standardSpring.delay(0.3), value: isAppeared)
        }
    }
} 
