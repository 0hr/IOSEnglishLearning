//
//  Logo.swift
//  smartlanguagelearning
//
//  Created by Harun Rasit Pekacar on 11/10/24.
//

import SwiftUI

struct Logo: View {
    let geometry: GeometryProxy
    var body: some View {
        Image("Logo")
            .resizable()
            .scaledToFit()
            .frame(width: min(120, geometry.size.width * 0.3),
                   height: min(120, geometry.size.width * 0.3))
    }
}
