//
//  RequestService.swift
//  SmartEnglishLearning
//
//  Created by Harun Rasit Pekacar on 12/10/24.
//
import Foundation

class RequestService {
    static let shared = RequestService()
    
    private var configService: ConfigService = ConfigService.shared
    
    public init() {} // Private initializer to enforce singleton
    
    public func initialize(configService: ConfigService) {
        self.configService = configService
    }
    
    public func getConfigService() -> ConfigService {
        return configService
    }
    
    public func request(method: String, endpoint: String, parameters: [String: Any]? = nil, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let baseURL = configService.get(forKey: "BASE_URL"),
              let url = URL(string: "\(baseURL)\(endpoint)") else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid BASE_URL or endpoint"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method

        if let parameters = parameters, method == "POST" || method == "PUT" {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                completion(.failure(NSError(domain: "SerializationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to serialize request parameters"])))
                return
            }
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "InvalidResponse", code: 0, userInfo: [NSLocalizedDescriptionKey: "Response was not HTTPURLResponse"])))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                let statusError = NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: [
                    NSLocalizedDescriptionKey: "Server returned status code \(httpResponse.statusCode)"
                ])
                completion(.failure(statusError))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received from server"])))
                return
            }

            completion(.success(data))
        }

        task.resume()
    }

    public func post(endpoint: String, parameters: [String: Any], completion: @escaping (Result<Data, Error>) -> Void) {
        request(method: "POST", endpoint: endpoint, parameters: parameters, completion: completion)
    }

    public func get(endpoint: String, completion: @escaping (Result<Data, Error>) -> Void) {
        request(method: "GET", endpoint: endpoint, completion: completion)
    }

    public func delete(endpoint: String, completion: @escaping (Result<Data, Error>) -> Void) {
        request(method: "DELETE", endpoint: endpoint, completion: completion)
    }

}
