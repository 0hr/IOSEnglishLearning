//
//  ContentView.swift
//  SmartEnglishLearning
//
//  Created by Harun Rasit Pekacar on 12/7/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "graduationcap")
                    Text("Learn")
                }
                .tag(0)
            FlashCardView()
                .tabItem {
                    Image(systemName: "menucard")
                    Text("Flash Cards")
                }
                .tag(1)
        }
        .onAppear() {
            UITabBar.appearance().barTintColor = .white
        }

    }
}

#Preview {
    ContentView()
}
