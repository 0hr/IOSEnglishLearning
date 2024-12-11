//
//  PracticeCard.swift
//  SmartEnglishLearning
//
//  Created by Harun Rasit Pekacar on 12/7/24.
//
import SwiftUI

struct PracticeCard: View {
    let title: String
    let subtitle: String
    let progress: Double
    let color: Color
    let backgroundColor: Color
    let icon: String
    var onNext: () -> Void = {}
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(backgroundColor)
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: onNext) {
               Image(systemName: "chevron.right")
                   .font(.title2)
                   .foregroundColor(.white)
                   .padding(12)
                   .background(color)
                   .clipShape(Circle())
           }
            
            
        }
        .padding()
        .background(Color.white)
        .cornerRadiusWithBorder(radius: 16, borderLineWidth: 1, borderColor: color.opacity(0.2))
        .shadow(color: Color.black.opacity(0.05), radius: 10)
    }
}
