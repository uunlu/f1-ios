//
//  LocalizedStrings.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Foundation

/// Type-safe localization helper for F1App
public enum LocalizedStrings {
    
    // MARK: - Navigation
    public static let seasonsTitle = NSLocalizedString("seasons_title", comment: "Main seasons view title")
    public static let seasonDetailsTitle = NSLocalizedString("season_details_title", comment: "Season details view title")
    public static let raceWinnersTitle = NSLocalizedString("race_winners_title", comment: "Race winners view title")
    public static let backToSeasons = NSLocalizedString("back_to_seasons", comment: "Back button text to seasons")
    
    // MARK: - Headers and Labels
    public static let f1WorldChampions = NSLocalizedString("f1_world_champions", comment: "F1 World Champions header")
    public static let formula1History = NSLocalizedString("formula_1_history", comment: "Formula 1 history subtitle")
    public static let worldChampion = NSLocalizedString("world_champion", comment: "World Champion label")
    public static let championship = NSLocalizedString("championship", comment: "Championship label")
    public static let formula1WorldChampionship = NSLocalizedString("formula_1_world_championship", comment: "Formula 1 World Championship")
    public static let driversChampionshipWinner = NSLocalizedString("drivers_championship_winner", comment: "Drivers Championship Winner")
    
    // MARK: - Content Labels
    public static let season = NSLocalizedString("season", comment: "Season label")
    public static let driver = NSLocalizedString("driver", comment: "Driver label")
    public static let constructor = NSLocalizedString("constructor", comment: "Constructor label")
    public static let round = NSLocalizedString("round", comment: "Round label")
    public static let champion = NSLocalizedString("champion", comment: "Champion badge text")
    
    // MARK: - States
    public static let loading = NSLocalizedString("loading", comment: "Loading text")
    public static let loadingContent = NSLocalizedString("loading_content", comment: "Loading content accessibility")
    public static let pullToRefresh = NSLocalizedString("pull_to_refresh", comment: "Pull to refresh instruction")
    
    public static func lastUpdated(_ date: String) -> String {
        return String(format: NSLocalizedString("last_updated", comment: "Last updated timestamp"), date)
    }
    
    // MARK: - Empty States
    public static let noRaceWinnersFound = NSLocalizedString("no_race_winners_found", comment: "No race winners empty state")
    public static let noSeasonsFound = NSLocalizedString("no_seasons_found", comment: "No seasons empty state")
    public static let noDataAvailable = NSLocalizedString("no_data_available", comment: "No data available")
    
    // MARK: - Error States
    public static let errorTitle = NSLocalizedString("error_title", comment: "Error view title")
    public static let tryAgain = NSLocalizedString("try_again", comment: "Try again button")
    public static let networkError = NSLocalizedString("network_error", comment: "Network error message")
    public static let dataError = NSLocalizedString("data_error", comment: "Data loading error")
    public static let cacheError = NSLocalizedString("cache_error", comment: "Cache error message")
    
    // MARK: - Actions
    public static let tapToViewWinners = NSLocalizedString("tap_to_view_winners", comment: "Tap to view winners action")
    public static let tapToRetry = NSLocalizedString("tap_to_retry", comment: "Tap to retry action")
    public static let showDetails = NSLocalizedString("show_details", comment: "Show details action")
    public static let hideDetails = NSLocalizedString("hide_details", comment: "Hide details action")
    
    // MARK: - Accessibility
    public static let seasonButtonHint = NSLocalizedString("season_button_hint", comment: "Season button accessibility hint")
    public static let championBadge = NSLocalizedString("champion_badge", comment: "Champion badge accessibility")
    public static let teamColorIndicator = NSLocalizedString("team_color_indicator", comment: "Team color accessibility")
    public static let expandDetails = NSLocalizedString("expand_details", comment: "Expand details accessibility")
    public static let collapseDetails = NSLocalizedString("collapse_details", comment: "Collapse details accessibility")
} 