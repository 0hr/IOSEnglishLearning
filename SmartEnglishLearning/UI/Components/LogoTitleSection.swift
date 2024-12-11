//
//  LogoTitleSection.swift
//  smartlanguagelearning
//
//  Created by Harun Rasit Pekacar on 11/10/24.
//

import SwiftUI

struct LogoTitleSection: View {
    let geometry: GeometryProxy
    let isAnimating: Bool
    let caption: String
    let description: String
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: geometry.size.height * 0.05)
            
            Logo(geometry: geometry)
                .offset(y: isAnimating ? 0 : -50)
                .opacity(isAnimating ? 1 : 0)
                .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1), value: isAnimating)
            
            LogoBottomText(
                geometry: geometry,
                caption: caption,
                description: description
            )
            .offset(y: isAnimating ? 0 : 50)
            .opacity(isAnimating ? 1 : 0)
            .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2), value: isAnimating)
            
            Spacer().frame(height: geometry.size.height * 0.04)
        }
    }
}
