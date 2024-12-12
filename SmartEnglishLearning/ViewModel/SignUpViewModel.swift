import Foundation
import Combine
import SwiftUI

class SignUpViewModel: ObservableObject {
    private let requestService = RequestService.shared
    
    @Published var level: String = ""
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var error: String = "Error occurred. Please try again later"
    
    @AppStorage("accessToken") private var accessToken: String?
    @AppStorage("userName") private var userName: String?
    @AppStorage("userEmail") private var userEmail: String?
    @AppStorage("userLevel") private var userLevel: String?
    
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    public func signUp(completion: @escaping (Bool) -> Void) {
        let body: [String: Any] = [
            "name": self.name,
            "email": self.email,
            "password": self.password,
            "level": self.level
        ]

        requestService.post(endpoint: "user/register", parameters: body) { result in
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
                                self.isLoggedIn = true
                                completion(true)
                            } else {
                                print("Failed to decode token response.")
                                if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
                                    self.error = errorResponse.detail
                                }
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
}
