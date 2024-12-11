import SwiftUI

struct Question {
    let text: String
    let options: [String]
    let correctIndex: Int
}

extension Question {
    static let questions: [Question] = [
        Question(
            text: "concerned",
            options: ["familiar", "worried", "careless", "unable"],
            correctIndex: 1
        ),
        Question(
            text: "express",
            options: ["state", "offer", "inspect", "measure"],
            correctIndex: 0
        ),
        Question(
            text: "One huge _____ of working with a personal trainer is getting faster and better results.",
            options: ["conclusion", "prediction", "benefit", "influence"],
            correctIndex: 2
        ),
        Question(
            text: "The team members are expected to actively _____ in the decision making process.",
            options: ["permit", "occur", "persuade", "participate"],
            correctIndex: 3
        ),
        Question(
            text: "widespread",
            options: ["significant", "various", "protective", "common"],
            correctIndex: 3
        ),
        Question(
            text: "perceive",
            options: ["understand", "force", "emphasize", "target"],
            correctIndex: 0
        ),
        Question(
            text: "Increasing plastic use during the pandemic poses a great _____ to the environment.",
            options: ["target", "innovation", "threat", "conflict"],
            correctIndex: 3
        ),
        Question(
            text: "People from many different areas came together to _____ a common goal.",
            options: ["attend", "pursue", "release", "inspire"],
            correctIndex: 1
        ),
        Question(
            text: "a plan or an idea that a person wants to follow",
            options: ["invasion", "rebellion", "intention", "duration"],
            correctIndex: 2
        ),
        Question(
            text: "attain",
            options: ["encounter", "accomplish", "pretend", "exploit"],
            correctIndex: 1
        ),
        Question(
            text: "There was an open _____ between the two groups in the school, which eventually led to a huge fight.",
            options: ["intervention", "privilege", "hostility", "incentive"],
            correctIndex: 2
        ),
    ]
}
struct QuizView: View {
    
    @State private var currentIndex: Int = 0
    @State private var correctAnswersCount: Int = 0
    
    @State private var showResult: Bool = false
    @State private var selectedAnswerIndex: Int? = nil
    @State private var isAnswerCorrect: Bool? = nil
    @State private var isTransitioning: Bool = false
    @State private var showNextButton: Bool = false
    
    @Binding public var navigationPath: NavigationPath
    
    @State private var questions = Question.questions
    
    var body: some View {
        ZStack {
            Color.main.edgesIgnoringSafeArea(.all)
            
            if showResult {
                resultOverlay
                    .transition(.opacity)
            } else {
                VStack(spacing: 20) {
                    HStack {
                  
                        ProgressView(value: Double(currentIndex), total: Double(questions.count)).tint(Theme.purple)
                        
                        Button(action: {
                            navigationPath.append(Routes.chooseLevel)
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.secondary)
                        }
          
                    }
                    .padding([.horizontal, .top])
                    
                    Spacer()
                    Text(Question.questions[currentIndex].text)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top, 20)
                    
                    ForEach(0..<questions[currentIndex].options.count, id: \.self) { i in
                        answerButton(for: i)
                    }
                    
                    if showNextButton {
                        Button(action: {
                            goToNextQuestion()
                        }) {
                            Text("Next")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Theme.purple)
                                .cornerRadius(8)
                        }
                        .padding([.horizontal, .top])
                    }
                    Spacer()
                    
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(.secondary)
                        Button("Sign In") {
                            navigationPath.append(Routes.email)
                        }
                        .foregroundColor(.blue)
                    }
                   
                }
                .opacity(isTransitioning ? 0 : 1)
                .offset(x: isTransitioning ? 50 : 0)
                .animation(.easeInOut(duration: 0.3), value: isTransitioning)
            }
        }.navigationBarHidden(true)
    }


    func answerButton(for index: Int) -> some View {
        let option = Question.questions[currentIndex].options[index]
        let isSelected = index == selectedAnswerIndex
        let isCorrectOption = index == Question.questions[currentIndex].correctIndex
        
        let backgroundColor: Color = {
            if let correct = isAnswerCorrect {
                if correct {
                    return isSelected ? Color.green.opacity(0.3) : Color.secondary.opacity(0.1)
                } else {
                    if isCorrectOption {
                        return Color.green.opacity(0.3)
                    } else if isSelected {
                        return Color.red.opacity(0.3)
                    } else {
                        return Color.secondary.opacity(0.1)
                    }
                }
            } else {
                return Color.secondary.opacity(0.1)
            }
        }()
        
        return Button(action: {
            if isAnswerCorrect == nil {
                selectedAnswerIndex = index
                checkAnswer(selected: index)
            }
        }) {
            HStack {
                Text(option)
                    .font(.body)
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(8)
        }
        .disabled(isAnswerCorrect != nil)
        .padding(.horizontal)
    }
    
    // MARK: - Check Answer
    func checkAnswer(selected index: Int) {
        let correctIndex = questions[currentIndex].correctIndex
        if index == correctIndex {
            isAnswerCorrect = true
            correctAnswersCount += 1 // Increment correct answers count
            showNextButton = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                goToNextQuestion()
            }
        } else {
            isAnswerCorrect = false
            showNextButton = true
        }
    }
    
    // MARK: - Next Question
    func goToNextQuestion() {
        withAnimation {
            isTransitioning = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if currentIndex < questions.count - 1 {
                currentIndex += 1
                selectedAnswerIndex = nil
                isAnswerCorrect = nil
                showNextButton = false
            } else {
                // All questions answered
                showResult = true
            }
            withAnimation {
                isTransitioning = false
            }
        }
    }
    
    var resultOverlay: some View {
        VStack(spacing: 30) {
            Text("Quiz Completed!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("You got \(correctAnswersCount) out of \(questions.count) correct.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: {
                navigationPath.append(Routes.signup)
            }) {
                Text("Close")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: 200)
                    .background(Theme.purple)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

#Preview {
    @Previewable @State var previewNavigationPath = NavigationPath()
    QuizView(navigationPath: $previewNavigationPath)
}
