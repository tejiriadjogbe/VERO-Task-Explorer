//
//  BasicHTTPService.swift
//  VEROTask
//
//  Created by Adjogbe  Tejiri on 09/06/2024.
//

import UIKit

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

public enum ClientType: String {
    case basic, bearer
}

class HTTPClient {

    static let shared = HTTPClient()
    
    private init() { }

    func fetchData<T: Codable>(
        url: String,
        data: Codable? = nil,
        method: HTTPMethod = .get,
        type: ClientType = .basic,
        completion: @escaping (Result<T, ErrorResponse>) -> Void) {
        // Create a URLRequest with the desired URL
        guard let url = URL(string: url) else {
            // Handle invalid URL
            completion(.failure(ErrorResponse(message: "Invalid Url")))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let token = type == .basic ? "Basic QVBJX0V4cGxvcmVyOjEyMzQ1NmlzQUxhbWVQYXNz" : AppStorage.token ?? ""
        request.addValue(token, forHTTPHeaderField: "Authorization")

        // Encode the data and set the request body
        if method == .post, let data = data {
            do {
                let encoder = JSONEncoder()
                request.httpBody = try encoder.encode(data)
            } catch {
                completion(.failure(ErrorResponse(message: "Network error: \(error.localizedDescription)")))
                return
            }
        }
      
        // Perform the network request
        URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                if let error = error {
                    completion(.failure(ErrorResponse(message: error.localizedDescription)))
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(ErrorResponse(message: "Invalid Response")))
                    return
                }
                
                guard let data = data else {
                    // Handle nil Data
                    completion(.failure(ErrorResponse(message: "Invalid Response")))
                    return
                }
                //print(httpResponse.allHeaderFields)
                switch httpResponse.statusCode {
                case 200...299:
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(T.self, from: data)
                    completion(.success(result))
                default:
                    completion(.failure(ErrorResponse(httpStatusCode: httpResponse.statusCode, message: "Request failed with status code: \(httpResponse.statusCode)")))
                }
            } catch {
                completion(.failure(ErrorResponse(message: "Network error: \(error.localizedDescription)")))
            }
        }.resume()
    }
}

