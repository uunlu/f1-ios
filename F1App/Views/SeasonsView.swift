//
//  SeasonsView.swift
//  F1App
//
//  Created by Ugur Unlu on 31/05/2025.
//

import Combine
import SwiftUI

struct SeasonsView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var viewModel: SeasonsViewModel
    @State private var isAppeared = false
    
    init(viewModel: SeasonsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Simple header
                Text("F1 World Champions")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if viewModel.isLoading && viewModel.seasons.isEmpty {
                    loadingView
                } else if let error = viewModel.error, viewModel.seasons.isEmpty {
                    errorView(error)
                } else if viewModel.seasons.isEmpty {
                    emptyStateView
                } else {
                    seasonsList
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
            .onAppear {
                isAppeared = true
                viewModel.loadSeasons()
            }
            .onDisappear {
                viewModel.cancelLoading()
            }
        }
    }
    
    // Optimized loading view
    private var loadingView: some View {
        VStack {
            ProgressView("Loading seasons...")
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.2)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // Simplified error view
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.orange)
            
            Text("Error Loading Data")
                .font(.headline)
            
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Button("Retry") {
                viewModel.loadSeasons()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // Simple empty state
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "list.bullet")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            
            Text("No seasons available")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // Optimized seasons list with better performance and proper pull-to-refresh
    private var seasonsList: some View {
        List {
            // Show refresh error at the top if there's an error during refresh
            if let error = viewModel.error, viewModel.isRefreshing {
                refreshErrorBanner(error)
            }
            
            ForEach(viewModel.seasons, id: \.id) { season in
                F1Components.SeasonListItem(season: season) {
                    coordinator.showRaceWinners(for: season)
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .refreshable {
            await performRefresh()
        }
    }
    
    // Error banner for refresh failures
    private func refreshErrorBanner(_ message: String) -> some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Refresh Failed")
                    .font(.caption)
                    .fontWeight(.semibold)
                Text(message)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button("Dismiss") {
                viewModel.error = nil
            }
            .font(.caption)
            .foregroundColor(.blue)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemYellow).opacity(0.1))
        .cornerRadius(8)
        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
    
    private func performRefresh() async {
        viewModel.refreshSeasons()
        
        for await isRefreshing in viewModel.$isRefreshing.values where !isRefreshing {
            return  // Exit when refresh completes
        }
    }
}
