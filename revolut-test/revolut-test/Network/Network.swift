//
//  Network.swift
//  revolut-test
//
//  Created by Frederico Bechara De Paola on 07/02/19.
//  Copyright © 2019 Frederico Bechara De Paola. All rights reserved.
//

import Foundation

enum Result<T, U> where T: Decodable, U: Error {
    case success(T)
    case failure(U)
}

enum APIError: Error {
    case notFound
    case noInternet
    case incorrectResponse
    case requestFailed
    case wrongBase
}

enum HTTPStatusCode: Int {
    case success = 200
    case notFound = 404
}

class Requester {
    let urlStringWithoutBase = "https://revolut.duckdns.org/latest?base="
    var base = "EUR"
    
    func request(completion: @escaping (Decodable?, APIError?) -> Void) {
        
        let url = urlStringWithoutBase + base
        guard let urlRequest = URL(string: url) else {
            completion(nil, .wrongBase)
            return
        }
        
        _ = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if error != nil {
                completion(nil, .requestFailed)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            if httpResponse.statusCode != HTTPStatusCode.success.rawValue {
                completion(nil, .notFound)
            }
            guard let data = data else { return }
            
            do {
                let jsonDecoder = JSONDecoder()
                let currency = try jsonDecoder.decode(CurrencyModel.self, from: data)
                completion(currency, nil)
            } catch {
                completion(nil, APIError.incorrectResponse)
            }
        }.resume()
    }
}
