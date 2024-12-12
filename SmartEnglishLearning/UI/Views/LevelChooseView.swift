//
//  LevelChooseView.swift
//  SmartEnglishLearning
//
//  Created by Harun Rasit Pekacar on 12/8/24.
//

import SwiftUI
import ConfettiSwiftUI

struct LevelChooseView: View {
    private let levels: [CEFRLevel] = [.a1, .a2, .b1, .b2, .c1]
    
    @State private var counter: Int = 0
    @Binding public var navigationPath: NavigationPath
    @State private var selectedLevel: CEFRLevel? = nil
    
    @Binding public var level: String
    
    var body: some View {
        ZStack {
            
            Color.main.edgesIgnoringSafeArea(.all)
            ScrollView {
                
                VStack(spacing: 16) {
                    Spacer()
                    Text("Choose your level")
                        .font(.title)
                    Text("Select the level you want to practice")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if (selectedLevel == nil) {
                        ForEach(levels, id: \.self) { level in
                            Button(action: {
                                selectedLevel = level
                                self.level = level.rawValue
                                counter += 1
                            }) {
                                
                                LevelCard(
                                    level: level
                                )
                                
                            }
                        }
                    }
                    
                    
                    if (selectedLevel == nil) {
                        Button(action: {
                            navigationPath.append(Routes.quiz)
                        }) {
                            Text("Not Sure? Take Placement Test")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                                .bold()
                                .underline()
                        }
                    } else {
                        LevelCard(
                            level: selectedLevel!
                        )
                        
                        Button(action: {
                            navigationPath.append(Routes.signup)
                        }) {
                            Text("Sign up")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Theme.purple)
                                .cornerRadius(8)
                        }
                        .padding([.horizontal, .top])
                        
                        Button(action: {
                            selectedLevel = nil
                        }) {
                            Text("Choose another level")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                                .bold()
                                .underline()
                        }
                    }
                    
                    ConfettiCannon(counter: $counter, num: 50, radius: 300.0)
                    
                }
            }.clipShape(Rectangle())
        }
    }
}

//#Preview {
//    @Previewable @State var previewNavigationPath = NavigationPath()
//    LevelChooseView(navigationPath: $previewNavigationPath)
//}
