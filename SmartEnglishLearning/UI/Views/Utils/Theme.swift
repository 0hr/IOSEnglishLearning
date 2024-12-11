//
//  Theme.swift
//  SmartEnglishLearning
//
//  Created by Harun Rasit Pekacar on 12/7/24.
//

import SwiftUI


struct Theme {
    static let purple = Color(hex: "7C6BFF")
    static let lightPurple = Color(hex: "F0EEFF")
    static let green = Color(hex: "4CD964")
    static let lightGreen = Color(hex: "E8F9EA")
    static let orange = Color(hex: "FF9F0A")
    static let lightOrange = Color(hex: "FFF4E5")
    static let pink = Color(hex: "FF7AA2")
    static let lightPink = Color(hex: "FFF0F4")
    static let blue = Color(hex: "54C5F8")
    static let lightBlue = Color(hex: "EBF8FF")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (0, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
