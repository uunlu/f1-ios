//
//  LocalizedStrings.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation

public enum LocalizedStrings {
    // MARK: - Navigation & Titles
    public static let seasonsTitle = "Seasons"
    public static let seasonDetailsTitle = "Season Details"
    public static let raceWinnersTitle = "Race Winners"
    public static let backToSeasons = "Back to Seasons"
    
    public static func raceWinnersNavigationTitle(_ season: String) -> String {
        "Race Winners - \(season)"
    }
    
    // MARK: - Main Content
    public static let f1WorldChampions = "F1 World Champions"
    public static let formula1History = "Formula 1 History"
    public static let worldChampion = "World Champion"
    public static let championship = "Championship"
    public static let formula1WorldChampionship = "Formula 1 World Championship"
    public static let driversChampionshipWinner = "Drivers Championship Winner"
    public static let raceWinners = "Race Winners"
    public static let ongoingChampionship = "Ongoing Championship"
    
    // MARK: - Data Labels
    public static let season = "Season"
    public static let driver = "Driver"
    public static let constructor = "Constructor"
    public static let round = "Round"
    public static let champion = "Champion"
    
    // MARK: - Loading States
    public static let loading = "Loading"
    public static let loadingContent = "Loading content"
    public static let loadingSeasons = "Loading seasons..."
    public static let pullToRefresh = "Pull to refresh"
    
    public static func lastUpdated(_ date: String) -> String {
        "Last updated: \(date)"
    }
    
    // MARK: - Empty States
    public static let noRaceWinnersFound = "No race winners found"
    public static let noSeasonsFound = "No seasons found"
    public static let noSeasonsAvailable = "No seasons available"
    public static let noDataAvailable = "No data available"
    
    // MARK: - Error States
    public static let errorTitle = "Error"
    public static let errorLoadingData = "Error loading data"
    public static let refreshFailed = "Refresh failed"
    public static let tryAgain = "Try again"
    public static let retry = "Retry"
    public static let dismiss = "Dismiss"
    public static let networkError = "Network connection error"
    public static let dataError = "Data loading error"
    public static let cacheError = "Cache loading error"
    public static let cacheInvalidationRequired = "Cache invalidation required"
    
    // MARK: - Actions
    public static let tapToViewWinners = "Tap to view race winners"
    public static let tapToRetry = "Tap to retry"
    public static let showDetails = "Show details"
    public static let hideDetails = "Hide details"
    
    // MARK: - Accessibility
    public static let seasonButtonHint = "Double tap to view race winners"
    public static let championBadge = "Champion badge"
    public static let teamColorIndicator = "Team color indicator"
    public static let expandDetails = "Expand details"
    public static let collapseDetails = "Collapse details"
    
    // MARK: - Race Details
    public static func roundLabel(_ round: String) -> String {
        "Round \(round)"
    }
    
    public static func raceTime(_ time: String) -> String {
        "Time: \(time)"
    }
    
    // MARK: - Offline & Network
    public static let noInternetConnection = "No Internet Connection"
    public static let connectToInternet = "Connect to the internet to load F1 data"
    public static let noInternetAndNoCache = "No internet connection and no cached data available"
} 
