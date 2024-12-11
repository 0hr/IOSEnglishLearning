//
//  SkillCard.swift
//  SmartEnglishLearning
//
//  Created by Harun Rasit Pekacar on 12/7/24.
//
import SwiftUI

struct SkillCard: View {
    let title: String
    let progress: Double
    let color: Color
    let backgroundColor: Color
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.headline)
                    .foregroundColor(color)
            }
            
            Text(title)
                .font(.headline)
            
            ProgressBar(progress: progress, color: color)
        }
        .padding()
        .background(backgroundColor)
        .cornerRadiusWithBorder(radius: 16, borderLineWidth: 1, borderColor: color.opacity(0.2))
    }
}
