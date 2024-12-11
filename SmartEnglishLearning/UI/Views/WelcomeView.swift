import SwiftUI


struct WelcomeView: View {
    @State private var loaded = false
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        ZStack {
            if !loaded {
                LoadingView()
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            withAnimation {
                                loaded = true
                            }
                        }
                    }
            } else {
                NavigationStack(path: $navigationPath) {
                    VStack {
                        OnboardingView(navigationPath: $navigationPath)
                    }
                    .navigationDestination(for: Routes.self) { route in
                        switch route {
                        case .chooseLevel:
                            LevelChooseView(navigationPath: $navigationPath)
                        case .login:
                            LoginView(navigationPath: $navigationPath)
                        case .quiz:
                            QuizView(navigationPath: $navigationPath)
                        case .email:
                            LoginWithEmailView(navigationPath: $navigationPath)
                        case .forgotPassword:
                            ForgotPasswordView(navigationPath: $navigationPath)
                        case .signup:
                            SignUpView(navigationPath: $navigationPath)
                        }
                    }
                    .toolbarBackground(Color.blue, for: .navigationBar)
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
}
