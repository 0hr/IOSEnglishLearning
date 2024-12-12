//
//  ProfileView.swift
//  SmartEnglishLearning
//
//  Created by Harun Rasit Pekacar on 12/7/24.
//

import SwiftUI

import SwiftUI
import AVFoundation

struct ProfileView: View {
    @State private var userName: String = "John Doe"
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("User Profile")
                .font(.largeTitle)
                .bold()
            
            Text(userName)
                .font(.title)
            
            Button(action: {
                speakText(userName)
            }) {
                Text("Speak Name")
                    .fontWeight(.semibold)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
    
    private func speakText(_ text: String) {
        // Stop any ongoing speech before starting new utterance
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: "Hi I'm \(text).")
  
        utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.voice.compact.it-IT.Alice")

        
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.pitchMultiplier = 0.7 // Adjust if needed for naturalness
        
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.prefersAssistiveTechnologySettings = true
        speechSynthesizer.speak(utterance)
    }
}


#Preview {
    ProfileView()
}
