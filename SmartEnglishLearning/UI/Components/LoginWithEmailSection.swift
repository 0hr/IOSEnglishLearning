//
//  LoginButtons.swift
//  smartlanguagelearning
//
//  Created by Harun Rasit Pekacar on 11/10/24.
//
import SwiftUI

import SwiftUI

struct LoginWithEmailSection: View {
    let geometry: GeometryProxy
    let handleLogin: () -> Void
    let onForgotPassword: () -> Void
    let onSignUp: () -> Void
    @Binding public var email: String
    @Binding public var password: String
    @State private var showPassword = false
    @Binding public var isLoading: Bool
    @State var isAnimating: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: geometry.size.height * 0.025) {
                // Email Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.secondary)
                        TextField("Enter your email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                
                // Password Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.secondary)
                        if showPassword {
                            TextField("Enter your password", text: $password)
                        } else {
                            SecureField("Enter your password", text: $password)
                        }
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                
                // Forgot Password
                HStack {
                    Spacer()
                    Button("Forgot Password?") {
                        onForgotPassword()
                    }
                    .foregroundColor(.blue)
                }
            }
            .offset(y: isAnimating ? 0 : 100)
            .opacity(isAnimating ? 1 : 0)
            .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.3),
                     value: isAnimating)
            
            Spacer()
                .frame(height: geometry.size.height * 0.05)
            
            // Login Button
            Button(action: {
                handleLogin()
            }) {
                ZStack {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Sign In")
                            .fontWeight(.bold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Theme.purple)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(isLoading)
            .offset(y: isAnimating ? 0 : 100)
            .opacity(isAnimating ? 1 : 0)
            .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.4),
                     value: isAnimating)
            
            // Sign Up Link
            HStack {
                Text("Don't have an account?")
                    .foregroundColor(.secondary)
                Button("Sign Up") {
                    onSignUp()
                }
                .foregroundColor(.blue)
            }
            .padding(.top, geometry.size.height * 0.02)
            .offset(y: isAnimating ? 0 : 100)
            .opacity(isAnimating ? 1 : 0)
            .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.5),
                     value: isAnimating)
            
            Spacer()
                .frame(height: geometry.size.height * 0.05)
        }
        .onAppear {
            isAnimating = true
        }
    }
}


#Preview {
    @Previewable @State var isLoading: Bool = true
    @Previewable @State var email: String = ""
    @Previewable @State var password: String = ""
    GeometryReader { geometry in
        LoginWithEmailSection(
            geometry: geometry,
            handleLogin: {},
            onForgotPassword: {},
            onSignUp: {},
            email: $email,
            password: $password,
            isLoading: $isLoading
        )
    }
    
}

