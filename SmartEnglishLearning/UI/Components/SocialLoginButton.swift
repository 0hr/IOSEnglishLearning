//
//  SocialLoginButton.swift
//  smartlanguagelearning
//
//  Created by Harun Rasit Pekacar on 11/10/24.
//

import SwiftUI

import SwiftUI

struct SocialLoginButton: View {
    let action: () -> Void
    let text: String
    let icon: String
    let backgroundColor: Color
    var textColor: Color = .white
    var borderColor: Color = .clear
    let delay: Double
    let geometry: GeometryProxy
    
    @State private var isAnimating = false
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            // Add slight delay before executing action to allow animation to complete
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                action()
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
        }) {
            HStack(spacing: geometry.size.width * 0.03) {
                if icon.contains(".") {
                    Image(systemName: icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.05)
                } else {
                    Image(icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.05)
                }
                
                Text(text)
                    .font(.system(size: geometry.size.width * 0.04, weight: .medium))
            }
            .foregroundColor(textColor)
            .frame(maxWidth: .infinity)
            .frame(height: geometry.size.height * 0.06)
            .background(backgroundColor)
            .cornerRadius(geometry.size.width * 0.02)
            .overlay(
                RoundedRectangle(cornerRadius: geometry.size.width * 0.02)
                    .stroke(borderColor, lineWidth: 1)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .offset(y: isAnimating ? 0 : 50)
            .opacity(isAnimating ? 1 : 0)
        }
        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(delay), value: isAnimating)
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    GeometryReader { geometry in
        VStack {
            SocialLoginButton(
                action: {},
                text: "Continue with Google",
                icon: "Google",
                backgroundColor: .white,
                textColor: .black,
                borderColor: .gray.opacity(0.3),
                delay: 0.4,
                geometry: geometry
            )
            SocialLoginButton(
                action: {},
                text: "Continue with Google",
                icon: "apple.logo",
                backgroundColor: .white,
                textColor: .black,
                borderColor: .gray.opacity(0.3),
                delay: 0.4,
                geometry: geometry
            )
        }
    }
}

