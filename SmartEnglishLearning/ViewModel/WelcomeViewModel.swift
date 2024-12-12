import Foundation
import Combine
import SwiftUI

class WelcomeViewModel: ObservableObject {
    private let requestService = RequestService.shared

    @AppStorage("accessToken") private var accessToken: String?
    @AppStorage("userName") private var userName: String?
    @AppStorage("userEmail") private var userEmail: String?
    @AppStorage("userLevel") private var userLevel: String?
    
    @Published var questions: [Question] = []
    @Published var isLoading: Bool = true
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @Published var error: Error?

    func checkAccessTokenAndFetchQuestions() {
         isLoading = true
         defer { isLoading = false }
        
         guard let token = accessToken, !token.isEmpty else {
             print("No valid token found, fetching quiz questions.")
             fetchQuizQuestions()
             return
         }

         refreshToken { [weak self] success in
             guard let self = self else { return }
             if success {
                 print("Token refreshed successfully. Skipping quiz question fetch.")
             } else {
                 print("Token refresh failed. Fetching quiz questions.")
                 self.fetchQuizQuestions()
             }
         }
     }

    private func refreshToken(completion: @escaping (Bool) -> Void) {
        guard let currentToken = accessToken else {
            print("No access token available for refresh.")
            completion(false)
            return
        }

        let body: [String: Any] = ["token": currentToken]
        requestService.post(endpoint: "user/refresh-token", parameters: body) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        do {
                            let decoder = JSONDecoder()
                            if let tokenResponse = try? decoder.decode(UserResponse.self, from: data) {
                                self.accessToken = tokenResponse.accessToken
                                self.userName = tokenResponse.name
                                self.userEmail = tokenResponse.email
                                self.userLevel = tokenResponse.level
                                print("New token received: \(tokenResponse.accessToken)")
                                completion(true)
                                self.isLoggedIn = true
                            } else {
                                print("Failed to decode token response.")
                                completion(false)
                            }
                        } catch {
                            print("Error decoding token response: \(error.localizedDescription)")
                            completion(false)
                        }
                    case .failure(let error):
                        print("Token refresh failed with error: \(error.localizedDescription)")
                        completion(false)
                    }
                }
            }
    }

    func fetchQuizQuestions() {
        isLoading = true
        error = nil
        print("Fetching quiz questions.")
        requestService.get(endpoint: "questions/get-placement-questions") { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(QuizResponse.self, from: data)
                        self?.questions = response.data.map { questionData in
                            Question(
                                id: questionData.id,
                                questionText: questionData.question,
                                options: questionData.options.map { $0.option },
                                correctOptionIndex: questionData.correctOption - 1 
                            )
                        }
                        print("Fetched quiz questions \(self?.questions.count ?? 0) successfully.")
                    } catch {
                        self?.error = error
                        print("Error decoding quiz questions: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    self?.error = error
                    print("Failed to fetch quiz questions: \(error.localizedDescription)")
                }
            }
        }
    }
}
