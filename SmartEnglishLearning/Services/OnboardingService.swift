//
//  OnboardingService.swift
//  SmartEnglishLearning
//
//  Created by Harun Rasit Pekacar on 12/3/24.
//

//import Alamofire
//import Combine

//class OnboardingService {
//    static let shared = OnboardingService()
//
//    private init() {}
//
//    func fetchOnboardingSteps(completion: @escaping (Result<[OnboardingStep], Error>) -> Void) {
//        let url = "https://api.example.com/onboardingSteps"
//
//        AF.request(url, method: .get)
//            .validate()
//            .responseDecodable(of: [OnboardingStep].self) { response in
//                switch response.result {
//                case .success(let steps):
//                    completion(.success(steps))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//    }
//}
