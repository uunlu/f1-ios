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
                // Header with title and timestamp
                headerView
                
                // Offline banner (when no internet and no cache)
                if viewModel.showOfflineBanner {
                    offlineBanner
                }
                
                if viewModel.isLoading && viewModel.seasons.isEmpty {
                    loadingView
                } else if let error = viewModel.error, viewModel.seasons.isEmpty && !viewModel.showOfflineBanner {
                    errorView(error)
                } else if viewModel.seasons.isEmpty && !viewModel.showOfflineBanner {
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
    
    // Enhanced header with timestamp
    private var headerView: some View {
        VStack(alignment: .leading, spacing: F1Layout.spacing4) {
            // Main title
            Text(LocalizedStrings.f1WorldChampions)
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Last updated timestamp
            if let lastUpdated = viewModel.lastUpdated, viewModel.hasLocalData {
                HStack(spacing: F1Layout.spacing4) {
                    Image(systemName: viewModel.networkState == .connected ? "checkmark.circle.fill" : "wifi.slash")
                        .font(.caption)
                        .foregroundColor(viewModel.networkState == .connected ? .green : .orange)
                    
                    Text(LocalizedStrings.lastUpdated(formatRelativeTime(lastUpdated)))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, F1Layout.spacing8)
    }
    
    // Offline banner
    private var offlineBanner: some View {
        F1Components.OfflineBanner(
            message: LocalizedStrings.connectToInternet,
            retryAction: {
                viewModel.loadSeasons()
            }
        )
        .padding(.horizontal)
        .padding(.bottom, F1Layout.spacing8)
        .transition(.move(edge: .top).combined(with: .opacity))
        .animation(.easeInOut(duration: 0.3), value: viewModel.showOfflineBanner)
    }
    
    // Optimized loading view
    private var loadingView: some View {
        VStack {
            ProgressView(LocalizedStrings.loadingSeasons)
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
            
            Text(LocalizedStrings.errorLoadingData)
                .font(.headline)
            
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Button(LocalizedStrings.retry) {
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
            
            Text(LocalizedStrings.noSeasonsAvailable)
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
                Text(LocalizedStrings.refreshFailed)
                    .font(.caption)
                    .fontWeight(.semibold)
                Text(message)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(LocalizedStrings.dismiss) {
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
    
    // Helper to format relative time
    private func formatRelativeTime(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
