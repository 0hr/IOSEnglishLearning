//
//  ForgotPasswordView.swift
//  smartlanguagelearning
//
//  Created by Harun Rasit Pekacar on 11/10/24.
//

import SwiftUI

struct LoginView: View {
    @State private var isAnimating = false
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isEmailView: Bool = false
    
    @Binding public var navigationPath: NavigationPath
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.main.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    LogoTitleSection(
                        geometry: geometry,
                        isAnimating: isAnimating,
                        caption: "Create Account",
                        description: "Sign up get started!"
                    )
                    
                    SocialLoginSection(
                        geometry: geometry,
                        isAnimating: isAnimating,
                        onAppleLogin: {},
                        onGoogleLogin: {},
                        onFacebookLogin: {},
                        onEmailLogin: {
                            navigationPath.append(Routes.email)
                        }
                    )
                    
                }
                .padding(.horizontal, geometry.size.width * 0.08)
                
                Alert(geometry: geometry, message: errorMessage, showError: $showError)
            }
        }.onAppear {
            isAnimating = true
        }.navigationBarBackButtonHidden()
    }
    
    private func handleAppleLogin() {
        // Implement Apple Sign In
    }
    
    private func handleGoogleLogin() {
        // Implement Google Sign In
    }
    
    private func handleFacebookLogin() {
        // Implement Facebook Sign In
    }
    
    private func handleEmailLogin() {
        
    }
}

#Preview {
    @Previewable @State var previewNavigationPath = NavigationPath()
    LoginView(navigationPath: $previewNavigationPath)
}
