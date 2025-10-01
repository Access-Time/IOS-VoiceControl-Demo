//
//  ContentView.swift
//  VoiceControlDemo
//
//  Created by Bogdan Sikora on 01.10.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn: Bool = false

    var body: some View {
        if isLoggedIn {
            MainTabView()
        } else {
            LoginView(isLoggedIn: $isLoggedIn)
        }
    }
}

#Preview {
    ContentView()
}
