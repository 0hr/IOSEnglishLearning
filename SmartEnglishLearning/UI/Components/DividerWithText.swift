//
//  DividerWithText.swift
//  smartlanguagelearning
//
//  Created by Harun Rasit Pekacar on 11/10/24.
//
import SwiftUI

struct DividerWithText: View {
    let text: String
    let geometry: GeometryProxy
    
    var body: some View {
        HStack {
            VStack { Divider() }.padding(.horizontal, 8)
            Text(text)
                .font(.system(size: min(14, geometry.size.width * 0.035)))
                .foregroundColor(.secondary)
            VStack { Divider() }.padding(.horizontal, 8)
        }
    }
}
