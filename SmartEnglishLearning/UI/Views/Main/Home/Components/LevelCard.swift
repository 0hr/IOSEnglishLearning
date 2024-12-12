//
//  LevelCard.swift
//  SmartEnglishLearning
//
//  Created by Harun Rasit Pekacar on 12/7/24.
//

import SwiftUI

struct LevelCard: View {
    let level: CEFRLevel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(level.title)
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                Text(level.text)
                    .font(.headline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(level.color)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
            
            Text(level.description)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadiusWithBorder(radius: 16, borderLineWidth: 1, borderColor: level.color.opacity(0.2))
        .shadow(color: level.color.opacity(0.2), radius: 7)
        .padding(.horizontal)
    }
}
