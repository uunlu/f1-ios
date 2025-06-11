//
//  LocalizedStrings.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation

/// Modern String Catalog localization helper for F1App (iOS 15+)
public enum LocalizedStrings {
    // MARK: - Navigation
    public static let seasonsTitle = String(localized: "seasons_title", comment: "Main seasons view title")
    public static let seasonDetailsTitle = String(localized: "season_details_title", comment: "Season details view title")
    public static let raceWinnersTitle = String(localized: "race_winners_title", comment: "Race winners view title")
    public static let backToSeasons = String(localized: "back_to_seasons", comment: "Back button text to seasons")
    
    public static func raceWinnersNavigationTitle(_ season: String) -> String {
        String(localized: "race_winners_navigation_title", defaultValue: "Race Winners - \(season)", comment: "Navigation title for race winners with season")
    }
    
    // MARK: - Headers and Labels
    public static let f1WorldChampions = String(localized: "f1_world_champions", comment: "F1 World Champions header")
    public static let formula1History = String(localized: "formula_1_history", comment: "Formula 1 history subtitle")
    public static let worldChampion = String(localized: "world_champion", comment: "World Champion label")
    public static let championship = String(localized: "championship", comment: "Championship label")
    public static let formula1WorldChampionship = String(localized: "formula_1_world_championship", comment: "Formula 1 World Championship")
    public static let driversChampionshipWinner = String(localized: "drivers_championship_winner", comment: "Drivers Championship Winner")
    public static let raceWinners = String(localized: "race_winners", comment: "Race Winners section header")
    
    // MARK: - Content Labels
    public static let season = String(localized: "season", comment: "Season label")
    public static let driver = String(localized: "driver", comment: "Driver label")
    public static let constructor = String(localized: "constructor", comment: "Constructor label")
    public static let round = String(localized: "round", comment: "Round label")
    public static let champion = String(localized: "champion", comment: "Champion badge text")
    
    // MARK: - States
    public static let loading = String(localized: "loading", comment: "Loading text")
    public static let loadingContent = String(localized: "loading_content", comment: "Loading content accessibility")
    public static let loadingSeasons = String(localized: "loading_seasons", comment: "Loading seasons message")
    public static let pullToRefresh = String(localized: "pull_to_refresh", comment: "Pull to refresh instruction")
    
    public static func lastUpdated(_ date: String) -> String {
        String(localized: "last_updated", defaultValue: "Last updated: \(date)", comment: "Last updated timestamp")
    }
    
    // MARK: - Empty States
    public static let noRaceWinnersFound = String(localized: "no_race_winners_found", comment: "No race winners empty state")
    public static let noSeasonsFound = String(localized: "no_seasons_found", comment: "No seasons empty state")
    public static let noSeasonsAvailable = String(localized: "no_seasons_available", comment: "No seasons available message")
    public static let noDataAvailable = String(localized: "no_data_available", comment: "No data available")
    
    // MARK: - Error States
    public static let errorTitle = String(localized: "error_title", comment: "Error view title")
    public static let errorLoadingData = String(localized: "error_loading_data", comment: "Error loading data title")
    public static let refreshFailed = String(localized: "refresh_failed", comment: "Refresh failed message")
    public static let tryAgain = String(localized: "try_again", comment: "Try again button")
    public static let retry = String(localized: "retry", comment: "Retry button text")
    public static let dismiss = String(localized: "dismiss", comment: "Dismiss button text")
    public static let networkError = String(localized: "network_error", comment: "Network error message")
    public static let dataError = String(localized: "data_error", comment: "Data loading error")
    public static let cacheError = String(localized: "cache_error", comment: "Cache error message")
    
    // MARK: - Actions
    public static let tapToViewWinners = String(localized: "tap_to_view_winners", comment: "Tap to view winners action")
    public static let tapToRetry = String(localized: "tap_to_retry", comment: "Tap to retry action")
    public static let showDetails = String(localized: "show_details", comment: "Show details action")
    public static let hideDetails = String(localized: "hide_details", comment: "Hide details action")
    
    // MARK: - Accessibility
    public static let seasonButtonHint = String(localized: "season_button_hint", comment: "Season button accessibility hint")
    public static let championBadge = String(localized: "champion_badge", comment: "Champion badge accessibility")
    public static let teamColorIndicator = String(localized: "team_color_indicator", comment: "Team color accessibility")
    public static let expandDetails = String(localized: "expand_details", comment: "Expand details accessibility")
    public static let collapseDetails = String(localized: "collapse_details", comment: "Collapse details accessibility")
    
    // MARK: - Race Winner Strings
    public static func roundLabel(_ round: String) -> String {
        String(localized: "round_label", defaultValue: "Round \(round)", comment: "Round label with number")
    }
    
    public static func raceTime(_ time: String) -> String {
        String(localized: "race_time", defaultValue: "Time: \(time)", comment: "Race completion time label")
    }
    
    // MARK: - Network & Offline Strings
    public static let noInternetConnection = String(localized: "no_internet_connection", defaultValue: "No Internet Connection", comment: "No internet banner title")
    public static let connectToInternet = String(localized: "connect_to_internet", defaultValue: "Connect to the internet to load F1 data", comment: "Connect to internet message")
    public static let noInternetAndNoCache = String(localized: "no_internet_and_no_cache", defaultValue: "No internet connection and no cached data available", comment: "Error when offline with no cache")
} 
