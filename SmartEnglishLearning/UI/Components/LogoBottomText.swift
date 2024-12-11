//
//  LogoBottomText.swift
//  smartlanguagelearning
//
//  Created by Harun Rasit Pekacar on 11/10/24.
//

import SwiftUI


public struct LogoBottomText: View {
    let geometry: GeometryProxy
    let caption: String
    let description: String
    public var body: some View {
        VStack(spacing: geometry.size.height * 0.01) {
            Text(caption)
                .font(.system(size: min(34, geometry.size.width * 0.08)))
                .bold()
            Text(description)
                .font(.system(size: min(17, geometry.size.width * 0.04)))
                .foregroundColor(.secondary)
        }
    }
}
