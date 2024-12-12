//
//  SignInViewModel.swift
//  SmartEnglishLearning
//
//  Created by Harun Rasit Pekacar on 12/11/24.
//

import Foundation
import Combine
import SwiftUI

class SignInViewModel: ObservableObject {
    private let requestService = RequestService.shared
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var error: String = "Error occurred. Please try again later"
    
    @AppStorage("accessToken") private var accessToken: String?
    @AppStorage("userName") private var userName: String?
    @AppStorage("userEmail") private var userEmail: String?
    @AppStorage("userLevel") private var userLevel: String?
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    public func signIn(completion: @escaping (Bool) -> Void) {
        let body: [String: Any] = [
            "email": self.email,
            "password": self.password,
        ]

        requestService.post(endpoint: "user/login", parameters: body) { result in
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
