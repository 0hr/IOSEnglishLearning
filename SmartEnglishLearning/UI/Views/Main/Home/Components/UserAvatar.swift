//
//  UserAvatar.swift
//  SmartEnglishLearning
//
//  Created by Harun Rasit Pekacar on 12/7/24.
//

import SwiftUI

struct UserAvatar: View {
    var body: some View {
        Image(systemName: "person.circle.fill")
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(Theme.purple)
            .background(Circle().fill(.white))
            .overlay(Circle().stroke(Theme.purple.opacity(0.2), lineWidth: 2))
    }
}
