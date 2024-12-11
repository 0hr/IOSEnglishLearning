////
////  DataService.swift
////  SmartEnglishLearning
////
////  Created by Harun Rasit Pekacar on 12/3/24.
////
//
//import Foundation
//import Alamofire
//
//class DataService {
//    private let baseURL: String
//    private let token: String? = nil
//    
//    init() {
//        guard let url = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
//            fatalError("BASE_URL not found in Info.plist")
//        }
//        
//        
//        self.baseURL = url
//    }
//    
//    
//    func makeRequest(endpoint: String, parameters: [String: Any], completion: @escaping (Result<Data, Error>) -> Void) {
//        let fullURL = "\(baseURL)\(endpoint)"
//        AF.request(fullURL, parameters: parameters)
//            .validate()
//            .responseData { response in
//                switch response.result {
//                case .success(let data):
//                    completion(.success(data))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//    }
//}
