//
//  ForgotPasswordView.swift
//  smartlanguagelearning
//
//  Created by Harun Rasit Pekacar on 11/10/24.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var email = ""
    @State private var verificationCode = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    
    @State private var currentStep = 0
    @State private var isAnimating = false
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var resendEnabled = false
    @State private var timeRemaining = 60
    
    @Binding public var navigationPath: NavigationPath
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.main.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 25) {
                        
                        Logo(geometry: geometry)
                            .offset(y: isAnimating ? 0 : -50)
                            .opacity(isAnimating ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1), value: isAnimating)
                        
                            .offset(y: isAnimating ? 0 : 50)
                            .opacity(isAnimating ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2), value: isAnimating)
                        
                        HStack(spacing: 4) {
                            ForEach(0..<3) { step in
                                Circle()
                                    .fill(step <= currentStep ? Color.blue : Color.gray.opacity(0.3))
                                    .frame(width: 8, height: 8)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.blue, lineWidth: step == currentStep ? 2 : 0)
                                            .padding(-2)
                                    )
                            }
                        }
                        
                        LogoBottomText(
                            geometry: geometry,
                            caption: stepTitle,
                            description: stepDescription
                        )
                        .offset(y: isAnimating ? 0 : 50)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.3), value: isAnimating)
                        
                        // Form Content
                        VStack(spacing: 20) {
                            switch currentStep {
                            case 0:
                                emailStep
                            case 1:
                                verificationStep
                            case 2:
                                newPasswordStep
                            default:
                                EmptyView()
                            }
                        }
                        .offset(y: isAnimating ? 0 : 100)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.4), value: isAnimating)
                        
                        Button(action: handleAction) {
                            ZStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text(actionButtonTitle)
                                        .fontWeight(.bold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isFormValid ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .disabled(!isFormValid || isLoading)
                        
                        // Back to Login
                        Button("Back to Login") {
                            dismiss()
                        }
                        .foregroundColor(.blue)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                }
                .onAppear {
                    isAnimating = true
                }
                .onReceive(timer) { _ in
                    if timeRemaining > 0 && !resendEnabled {
                        timeRemaining -= 1
                        if timeRemaining == 0 {
                            resendEnabled = true
                        }
                    }
                }
            }.toolbarBackground(.main, for: .navigationBar)
            
            if showError {
                VStack {
                    Spacer()
                    Text(errorMessage)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red.opacity(0.9))
                        .cornerRadius(10)
                        .padding(.bottom, 20)
                        .transition(.move(edge: .bottom))
                }
                .animation(.spring(), value: showError)
            }
        }.navigationBarBackButtonHidden()
    }
    
    // MARK: - Step Views
    
    private var emailStep: some View {
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
    }
    
    private var verificationStep: some View {
        VStack(spacing: 20) {
            // Verification Code Input
            VStack(alignment: .leading, spacing: 8) {
                Text("Verification Code")
                    .foregroundColor(.secondary)
                
                HStack {
                    Image(systemName: "key.fill")
                        .foregroundColor(.secondary)
                    TextField("Enter 6-digit code", text: $verificationCode)
                        .keyboardType(.numberPad)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
            
            // Resend Code Button
            HStack {
                Spacer()
                Button(action: resendCode) {
                    Text(resendEnabled ? "Resend Code" : "Resend in \(timeRemaining)s")
                }
                .foregroundColor(resendEnabled ? .blue : .gray)
                .disabled(!resendEnabled)
            }
        }
    }
    
    private var newPasswordStep: some View {
        VStack(spacing: 20) {
            // New Password
            PasswordField(title: "New Password",
                         placeholder: "Enter new password",
                         password: $newPassword,
                         showPassword: $showPassword)
            
            // Confirm Password
            PasswordField(title: "Confirm Password",
                         placeholder: "Confirm new password",
                         password: $confirmPassword,
                         showPassword: $showConfirmPassword)
            
            // Password Requirements
            if !newPassword.isEmpty {
                PasswordRequirements(password: newPassword)
            }
        }
    }
    
    private var stepTitle: String {
        switch currentStep {
        case 0:
            return "Forgot Password"
        case 1:
            return "Verify Email"
        case 2:
            return "Reset Password"
        default:
            return ""
        }
    }
    
    private var stepDescription: String {
        switch currentStep {
        case 0:
            return "Enter your email address to receive a verification code"
        case 1:
            return "Enter the 6-digit code sent to your email"
        case 2:
            return "Create a new password for your account"
        default:
            return ""
        }
    }
    
    private var actionButtonTitle: String {
        switch currentStep {
        case 0:
            return "Send Code"
        case 1:
            return "Verify Code"
        case 2:
            return "Reset Password"
        default:
            return ""
        }
    }
    
    private var isFormValid: Bool {
        switch currentStep {
        case 0:
            return isValidEmail(email)
        case 1:
            return verificationCode.count == 6
        case 2:
            return isValidPassword(newPassword) && newPassword == confirmPassword
        default:
            return false
        }
    }
    
    private func handleAction() {
        isLoading = true
        
        // Simulate network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            
            switch currentStep {
            case 0:
                // Handle email verification
                currentStep = 1
            case 1:
                // Handle code verification
                currentStep = 2
            case 2:
                // Handle password reset
                // Show success and dismiss
                dismiss()
            default:
                break
            }
        }
    }
    
    private func resendCode() {
        resendEnabled = false
        timeRemaining = 60
        // Handle resend code logic
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        password.count >= 8 &&
        password.contains(where: { $0.isUppercase }) &&
        password.contains(where: { $0.isNumber }) &&
        password.contains(where: { "!@#$%^&*()_+-=[]{}|;:,.<>?".contains($0) })
    }
}

#Preview {
    @Previewable @State var previewNavigationPath = NavigationPath()
    ForgotPasswordView(navigationPath: $previewNavigationPath)
}
