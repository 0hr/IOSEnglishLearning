//
//  LoginButtons.swift
//  smartlanguagelearning
//
//  Created by Harun Rasit Pekacar on 11/10/24.
//
import SwiftUI

import SwiftUI

struct SocialLoginSection: View {
    let geometry: GeometryProxy
    let isAnimating: Bool
    
    let onAppleLogin: () -> Void
    let onGoogleLogin: () -> Void
    let onFacebookLogin: () -> Void
    let onEmailLogin: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Social Login Buttons Group
            VStack(spacing: geometry.size.height * 0.02) {
                // Apple Login
                SocialLoginButton(
                    action: onAppleLogin,
                    text: "Continue with Apple",
                    icon: "apple.logo",
                    backgroundColor: .black,
                    delay: 0.3,
                    geometry: geometry
                )
                
                // Google Login
                SocialLoginButton(
                    action: onGoogleLogin,
                    text: "Continue with Google",
                    icon: "Google",
                    backgroundColor: .white,
                    textColor: .black,
                    borderColor: .gray.opacity(0.3),
                    delay: 0.4,
                    geometry: geometry
                )
                
                // Facebook Login
                SocialLoginButton(
                    action: onFacebookLogin,
                    text: "Continue with Facebook",
                    icon: "Fb",
                    backgroundColor: Color(red: 66/255, green: 103/255, blue: 178/255),
                    delay: 0.5,
                    geometry: geometry
                )
            }
            .offset(y: isAnimating ? 0 : 50)
            .opacity(isAnimating ? 1 : 0)
            
            // Divider
            DividerWithText(text: "OR", geometry: geometry)
                .offset(y: isAnimating ? 0 : 50)
                .opacity(isAnimating ? 1 : 0)
                .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.6), value: isAnimating)
                .padding(.vertical, geometry.size.height * 0.02)
            
            // Email Login
            SocialLoginButton(
                action: onEmailLogin,
                text: "Continue with Email",
                icon: "envelope.fill",
                backgroundColor: .white,
                textColor: .black,
                borderColor: .gray.opacity(0.3),
                delay: 0.7,
                geometry: geometry
            )
        }
    }
}


#Preview {
    GeometryReader { geometry in
        SocialLoginSection(geometry: geometry, isAnimating: true, onAppleLogin: {}, onGoogleLogin: {}, onFacebookLogin: {}, onEmailLogin: {})
    }
    
}
