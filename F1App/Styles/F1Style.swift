//
//  F1Style.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import SwiftUI

/// Formula 1 Style Guide - Main entry point for styling components
public enum F1Style {
    /// Initializes all global styling for the app
    public static func configureAppearance() {
        configureNavigationBar()
        configureTabBar()
        configureListAppearance()
    }
    
    /// Configure navigation bar appearance
    private static func configureNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(F1Colors.navBackground)
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor(F1Colors.textPrimary),
            .font: UIFont.systemFont(ofSize: 18, weight: .bold)
        ]
        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(F1Colors.textPrimary),
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().tintColor = UIColor(F1Colors.primary)
    }
    
    /// Configure tab bar appearance
    private static func configureTabBar() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(F1Colors.navBackground)
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
        
        UITabBar.appearance().tintColor = UIColor(F1Colors.primary)
        UITabBar.appearance().unselectedItemTintColor = UIColor(F1Colors.textSecondary)
    }
    
    /// Configure list appearance
    private static func configureListAppearance() {
        UITableView.appearance().backgroundColor = UIColor(F1Colors.background)
        UITableViewCell.appearance().backgroundColor = UIColor.clear
    }
} 