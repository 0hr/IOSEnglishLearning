//
//  SignUpView.swift
//  smartlanguagelearning
//
//  Created by Harun Rasit Pekacar on 11/10/24.
//

import SwiftUI

struct SignUpView: View {
    
    // Form Fields
    @StateObject private var signUpViewModel = SignUpViewModel()
    @State private var confirmPassword = ""
    
    // UI States
    @State private var isAnimating = false
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var acceptedTerms = false
    @Binding public var navigationPath: NavigationPath

    @Binding public var level: String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color.main
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Logo
                        Logo(geometry: geometry)
                            .offset(y: isAnimating ? 0 : -50)
                            .opacity(isAnimating ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1), value: isAnimating)

                        // Welcome Text
                        LogoBottomText(
                            geometry: geometry,
                            caption: "Create Account",
                            description: "Sign up get started!"
                        )
                            .offset(y: isAnimating ? 0 : 50)
                            .opacity(isAnimating ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2), value: isAnimating)
                        
                        // Sign Up Form
                        VStack(spacing: 20) {
                            // Full Name Field
                            FormField(icon: "person.fill",
                                      title: "Full Name",
                                      placeholder: "Enter your full name",
                                      text: $signUpViewModel.name
                            )
                            
                            // Email Field
                            FormField(icon: "envelope.fill",
                                      title: "Email",
                                      placeholder: "Enter your email",
                                      text: $signUpViewModel.email,
                                      keyboardType: .emailAddress
                            )
                            
                            // Password Field
                            PasswordField(title: "Password",
                                          placeholder: "Create password",
                                          password: $signUpViewModel.password,
                                          showPassword: $showPassword
                            )
                            
                            // Confirm Password Field
                            PasswordField(title: "Confirm Password",
                                          placeholder: "Confirm password",
                                          password: $confirmPassword,
                                          showPassword: $showConfirmPassword)
                            
                            // Password Requirements
                            if !signUpViewModel.password.isEmpty {
                                PasswordRequirements(password: signUpViewModel.password)
                                    .transition(.opacity)
                            }
                            
                            // Terms and Conditions
                            HStack {
                                Button(action: { acceptedTerms.toggle() }) {
                                    Image(systemName: acceptedTerms ? "checkmark.square.fill" : "square")
                                        .foregroundColor(acceptedTerms ? .blue : .gray)
                                }
                                
                                Text("I agree to the ")
                                    .foregroundColor(.secondary)
                                +
                                Text("Terms & Conditions")
                                    .foregroundColor(.blue)
                            }
                            .font(.subheadline)
                        }
                        .offset(y: isAnimating ? 0 : 100)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.3), value: isAnimating)
                        
                        // Sign Up Button
                        Button(action: handleSignUp) {
                            ZStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Create Account")
                                        .fontWeight(.bold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.secondaryColor1)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .disabled(isLoading || !isFormValid)
                        .opacity(isFormValid ? 1 : 0.6)
                        .offset(y: isAnimating ? 0 : 100)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.4), value: isAnimating)
                        
                        // Login Link
                        HStack {
                            Text("Already have an account?")
                                .foregroundColor(.secondary)
                            Button("Sign In") {
                                navigationPath.append(Routes.email)
                            }
                            .foregroundColor(.blue)
                        }
                        .offset(y: isAnimating ? 0 : 100)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.5), value: isAnimating)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                }.toolbarBackground(.main, for: .navigationBar)
            }
            .onAppear {
                isAnimating = true
                print(level)
                signUpViewModel.level = level
                print(signUpViewModel.level)
            }
        }.navigationBarBackButtonHidden()
    }
    
    private var isFormValid: Bool {
        !signUpViewModel.name.isEmpty &&
        !signUpViewModel.email.isEmpty &&
        signUpViewModel.password.count >= 8 &&
        signUpViewModel.password == confirmPassword &&
        acceptedTerms &&
        isValidEmail(signUpViewModel.email)
    }
    
    private func handleSignUp() {
        guard isFormValid else {
            showError = true
            errorMessage = "Please fill in all fields correctly"
            return
        }
        
        isLoading = true
        
        print(level)
        signUpViewModel.signUp { success in
            if success {
                isLoading = false
            } else {
                isLoading = false
                showError = true
                errorMessage = signUpViewModel.error
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

// MARK: - Supporting Views

struct FormField: View {
    let icon: String
    let title: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.secondary)
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .autocapitalization(.none)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
    }
}

struct PasswordField: View {
    let title: String
    let placeholder: String
    @Binding var password: String
    @Binding var showPassword: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: "lock.fill")
                    .foregroundColor(.secondary)
                if showPassword {
                    TextField(placeholder, text: $password)
                } else {
                    SecureField(placeholder, text: $password)
                }
                Button(action: { showPassword.toggle() }) {
                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
    }
}

struct PasswordRequirements: View {
    let password: String
    
    private var hasMinLength: Bool { password.count >= 8 }
    private var hasUppercase: Bool { password.contains(where: { $0.isUppercase }) }
    private var hasNumber: Bool { password.contains(where: { $0.isNumber }) }
    private var hasSpecialCharacter: Bool { password.contains(where: { "!@#$%^&*()_+-=[]{}|;:,.<>?".contains($0) })
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Password Requirements:")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            RequirementRow(text: "At least 8 characters", isMet: hasMinLength)
            RequirementRow(text: "Contains uppercase letter", isMet: hasUppercase)
            RequirementRow(text: "Contains number", isMet: hasNumber)
            RequirementRow(text: "Contains special character", isMet: hasSpecialCharacter)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct RequirementRow: View {
    let text: String
    let isMet: Bool
    
    var body: some View {
        HStack {
            Image(systemName: isMet ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isMet ? .green : .gray)
            Text(text)
                .font(.caption)
                .foregroundColor(isMet ? .primary : .secondary)
        }
    }
}

//#Preview {
//    @Previewable @State var previewNavigationPath = NavigationPath()
//    SignUpView(navigationPath: $previewNavigationPath)
//}
