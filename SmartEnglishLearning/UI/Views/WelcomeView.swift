import SwiftUI


struct WelcomeView: View {
    @State private var navigationPath = NavigationPath()
    
    @State private var level: String = ""
    @StateObject private var welcomeViewModel = WelcomeViewModel()
    
    var body: some View {
        ZStack {
            if welcomeViewModel.isLoading {
                LoadingView()
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                              withAnimation {
                                  welcomeViewModel.checkAccessTokenAndFetchQuestions()
                              }
                          }
                    }
            } else {
                
                    if welcomeViewModel.isLoggedIn {
                        ContentView()
                    } else {
                        NavigationStack(path: $navigationPath) {
                            VStack {
                                OnboardingView(navigationPath: $navigationPath)
                            }
                            .navigationDestination(for: Routes.self) { route in
                                switch route {
                                case .chooseLevel:
                                    LevelChooseView(navigationPath: $navigationPath, level: $level)
                                case .login:
                                    LoginView(navigationPath: $navigationPath)
                                case .quiz:
                                    QuizView(navigationPath: $navigationPath, questions: $welcomeViewModel.questions,  level: $level)
                                case .email:
                                    LoginWithEmailView(navigationPath: $navigationPath)
                                case .forgotPassword:
                                    ForgotPasswordView(navigationPath: $navigationPath)
                                case .signup:
                                    SignUpView(navigationPath: $navigationPath, level: $level)
                                }
                            }
                            .toolbarBackground(Color.blue, for: .navigationBar)
                        }
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
}
