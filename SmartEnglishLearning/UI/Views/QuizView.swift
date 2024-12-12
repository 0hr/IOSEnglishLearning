import SwiftUI
import ConfettiSwiftUI

struct QuizView: View {
    @State private var currentIndex: Int = 0
    @State private var correctAnswersCount: Int = 0
    
    @State private var showResult: Bool = false
    @State private var selectedAnswerIndex: Int? = nil
    @State private var isAnswerCorrect: Bool? = nil
    @State private var isTransitioning: Bool = false
    @State private var showNextButton: Bool = false
    
    @Binding public var navigationPath: NavigationPath
    
    @Binding public var questions: [Question]
    
    @Binding public var level: String
    
    @State private var counter: Int = 0
    
    var body: some View {
        ZStack {
            Color.main.edgesIgnoringSafeArea(.all)
            
            if showResult {
                resultOverlay
                    .transition(.opacity)
            } else {
                VStack(spacing: 20) {
                    HStack {
                  
                        ProgressView(value: Double(currentIndex), total: Double(questions.count))
                            .tint(Theme.purple)
                        
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
                    Text(questions[currentIndex].questionText)
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
        }
        .navigationBarHidden(true)
    }


    func answerButton(for index: Int) -> some View {
        let option = questions[currentIndex].options[index]
        let isSelected = index == selectedAnswerIndex
        let isCorrectOption = index == questions[currentIndex].correctOptionIndex
        
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
        let correctIndex = questions[currentIndex].correctOptionIndex
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
            ConfettiCannon(counter: $counter, num: 50, radius: 300.0)
            
           
            Text("Quiz Completed!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("You got \(correctAnswersCount) out of \(questions.count) correct.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text("Your level is \(CEFRLevel(rawValue: level) ?? CEFRLevel.a1)")
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
        }.onAppear()
        {
            level = getLevel()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                counter += 1
            }
        }
        .padding()
    }
    
    func getLevel() -> String {
        switch correctAnswersCount {
            case 0..<5:
                return "a1"
            case 5..<10:
                return "a2"
            case 10..<15:
                return "b1"
            case 15..<20:
                return "b2"
            default:
                return "c1"
        }
    }
}

#Preview {
    @Previewable @State var previewNavigationPath = NavigationPath()
    @Previewable @State var questions: [Question] = Question.mockQuestions()
    @Previewable @State var level: String = ""
    QuizView(navigationPath: $previewNavigationPath, questions: $questions, level: $level)
}
