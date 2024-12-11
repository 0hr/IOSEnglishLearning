//
//  CEFRLevel.swift
//  SmartEnglishLearning
//
//  Created by Harun Rasit Pekacar on 12/7/24.
//
import SwiftUI


enum CEFRLevel: String, CaseIterable {
    case a1, a2, b1, b2, c1
    
    var title: String {
        switch self {
        case .a1:
            return "Beginner"
        case .a2:
            return "Pre-Intermediate"
        case .b1:
            return "Intermediate"
        case .b2:
            return "Upper-Intermediate"
        case .c1:
            return "Advanced"
        }
    }
    
    var description: String {
        switch self {
        case .a1:
            return "Use simple phrases for basic needs"
        case .a2:
            return "Use the language for everyday activities"
        case .b1:
            return "Have simple conversations about familiar topics"
        case .b2:
            return "Communicate confidently about many topics"
        case .c1:
            return "Express yourself fluently in any situation"
        }
    }
    
    var text: String {
        switch self {
        case .a1:
            return "A1"
        case .a2:
            return "A2"
        case .b1:
            return "B1"
        case .b2:
            return "B2"
        case .c1:
            return "C1"
        }
    }
    
    var color: Color {
        switch self {
        case .a1, .a2:
            return Theme.pink
        case .b1, .b2:
            return Color.orange
        case .c1:
            return Color.green
        }
    }
}
