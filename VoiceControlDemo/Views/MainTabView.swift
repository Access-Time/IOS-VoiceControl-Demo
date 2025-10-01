//
//  MainTabView.swift
//  VoiceControlDemo
//
//  Created by Bogdan Sikora on 01.10.2025.
//

import SwiftUI

struct MainTabView: View {
    @StateObject var viewModel = CatViewModel()

    var body: some View {
        TabView {
            BrowseView(viewModel: viewModel)
                .tabItem {
                    Label("Browse", systemImage: "square.grid.3x3")
                }

            SearchView(viewModel: viewModel)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            SwipeView(viewModel: viewModel)
                .tabItem {
                    Label("Swipe", systemImage: "heart")
                }
        }
        .overlay(
            Group {
                if viewModel.showTimeChallenge {
                    TimeChallengeModal(isPresented: $viewModel.showTimeChallenge)
                }
            }
        )
    }
}

#Preview {
    MainTabView()
}
