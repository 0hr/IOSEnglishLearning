////
////  OnboardingViewModel.swift
////  SmartEnglishLearning
////
////  Created by Harun Rasit Pekacar on 12/3/24.
////
//
//import Foundation
//import Combine
//
//class OnboardingViewModel: ObservableObject {
//    @Published var steps: [OnboardingStep] = []
//    @Published var isLoading: Bool = false
//    @Published var errorMessage: String?
//
//    private var cancellables = Set<AnyCancellable>()
//
//    func loadSteps() {
//        isLoading = true
//        errorMessage = nil
//
//        OnboardingService.shared.fetchOnboardingSteps { [weak self] result in
//            DispatchQueue.main.async {
//                self?.isLoading = false
//                switch result {
//                case .success(let steps):
//                    self?.steps = steps
//                case .failure(let error):
//                    self?.errorMessage = error.localizedDescription
//                }
//            }
//        }
//    }
//}
