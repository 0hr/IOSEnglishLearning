//
//  Onboarding.swift
//  SmartEnglishLearning
//
//  Created by Harun Rasit Pekacar on 12/3/24.
//

import Foundation

struct OnboardingStep: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let imageURL: String
}
