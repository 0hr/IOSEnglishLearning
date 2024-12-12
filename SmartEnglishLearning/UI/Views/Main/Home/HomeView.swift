//
//  HomeView.swift
//  SmartEnglishLearning
//
//  Created by Harun Rasit Pekacar on 12/7/24.
//

import SwiftUI
import Charts

struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14, pinnedViews: [.sectionHeaders]) {
                Section {
                    LevelCard(
                        level: CEFRLevel(rawValue: viewModel.userLevel?.lowercased() ?? "a1") ?? CEFRLevel.a1
                    )
                    
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Practice")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        PracticeCard(
                            title: "Vocabulary",
                            subtitle: "0 words studied",
                            progress: 0,
                            color: Theme.green,
                            backgroundColor: Theme.lightGreen,
                            icon: "textformat"
                        )
                        
                        
                        PracticeCard(
                            title: "Reading",
                            subtitle: "0 exercises studied",
                            progress: 0,
                            color: Theme.pink,
                            backgroundColor: Theme.lightPink,
                            icon: "pencil"
                        )
                        
                        PracticeCard(
                            title: "Grammar",
                            subtitle: "0 topics studied",
                            progress: 0,
                            color: Theme.orange,
                            backgroundColor: Theme.lightOrange,
                            icon: "book"
                        )
                        
                        PracticeCard(
                            title: "Pronunciation",
                            subtitle: "0 words practiced",
                            progress: 0,
                            color: Theme.purple,
                            backgroundColor: Theme.lightPurple,
                            icon: "mic"
                        )
                    }
                    .padding()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Your Skills")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                        ], spacing: 16) {
                            SkillCard(
                                title: "Vocabulary",
                                progress: 0,
                                color: Theme.green,
                                backgroundColor: Theme.lightGreen,
                                icon: "textformat"
                            )
                            
                            
                            SkillCard(
                                title: "Reading",
                                progress: 0,
                                color: Theme.pink,
                                backgroundColor: Theme.lightPink,
                                icon: "pencil"
                            )
                            
                            
                            SkillCard(
                                title: "Grammar",
                                progress: 0,
                                color: Theme.orange,
                                backgroundColor: Theme.lightOrange,
                                icon: "book"
                            )
                            
                            SkillCard(
                                title: "Pronunciation",
                                progress: 0,
                                color: Theme.purple,
                                backgroundColor: Theme.lightPurple,
                                icon: "book"
                            )
                        }
                        .padding(.horizontal)
                    }
                } header: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Harun!")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("What do we learn today?")
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        UserAvatar()
                    }
                    .padding()
                    // Change background color when pinned
                    .background(Color.white)
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.gray.opacity(0.2))
                            .alignmentGuide(.bottom) { $0[.bottom] }, // Align to bottom
                        alignment: .bottom
                    )
                }
            }
        }.clipShape(Rectangle())
        
    }
}


#Preview {
    HomeView()
}
