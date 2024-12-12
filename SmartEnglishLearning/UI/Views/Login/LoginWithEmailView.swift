import SwiftUI

struct LoginWithEmailView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isAnimating = false
    @State private var showPassword = false
    @State private var isLoading = false
    
    @State private var showError = false
    @State private var errorMessage = ""
    @Binding public var navigationPath: NavigationPath
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.main.edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack(spacing: 0) {
                        LogoTitleSection(
                            geometry: geometry,
                            isAnimating: isAnimating,
                            caption: "Welcome Back!",
                            description: "Sign in to continue"
                        )
                        
                        LoginWithEmailSection(
                            geometry: geometry,
                            handleLogin: handleLogin,
                            onForgotPassword: {
                                navigationPath.append(Routes.forgotPassword)
                            },
                            onSignUp: {
                                navigationPath.append(Routes.chooseLevel)
                            },
                            email: $email,
                            password: $password,
                            isLoading: $isLoading
                        )
                    }
                    .padding(.horizontal, geometry.size.width * 0.08)
                    
                    Alert(geometry: geometry, message: errorMessage, showError: $showError)
                }.navigationBarBackButtonHidden()
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
    

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func handleLogin() {
        showError = false
        
        guard !email.isEmpty, !password.isEmpty else {
            showError = true
            errorMessage = "Please fill in all fields"
            return
        }
         
        if !isValidEmail(email) {
            showError = true
            errorMessage = "Please enter a valid email address"
            return
        }
        
        
        isLoading = true
        
        // Simulate network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
            // Handle actual login logic here
        }
    }
}


#Preview {
    @Previewable @State var previewNavigationPath = NavigationPath()
    return LoginWithEmailView(navigationPath: $previewNavigationPath)
}
