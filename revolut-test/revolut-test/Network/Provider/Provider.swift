////
////  Provider.swift
////  revolut-test
////
////  Created by Frederico Bechara De Paola on 14/02/19.
////  Copyright © 2019 Frederico Bechara De Paola. All rights reserved.
////

import Foundation

enum Result<Value, E: Error> {
    case success(Value)
    case failure(E)
}

enum APIError: Error {
    case notFound
    case noInternet
    case requestFailed
    case wrongBase
    case wrongMock
}

enum HTTPStatusCode: Int {
    case success = 200
    case notFound = 404
}

protocol ProviderAPI {
    func request(urlString: String, completion: @escaping (Result<Data, APIError>) -> Void)
}

class Provider: ProviderAPI {
    
    func request(urlString: String, completion: @escaping (Result<Data, APIError>) -> Void) {
        
        guard let urlRequest = URL(string: urlString) else {
            completion(.failure(.wrongBase))
            return
        }
        
        _ = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if error != nil {
                completion(.failure(.requestFailed))
            } else if let data = data, let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 422 {
                    completion(.failure(.wrongBase))
                } else if httpResponse.statusCode == 404 {
                    completion(.failure(.notFound))
                } else if httpResponse.statusCode == 200 {
                    completion(.success(data))
                }
            }
        }.resume()
    }
}
