//
//  ProgressBar.swift
//  SmartEnglishLearning
//
//  Created by Harun Rasit Pekacar on 12/7/24.
//
import SwiftUI


struct ProgressBar: View {
    let progress: Double
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 8)
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(color)
                    .frame(width: geometry.size.width * progress, height: 8)
            }
        }
        .frame(height: 8)
    }
}
