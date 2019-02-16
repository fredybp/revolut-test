//
//  Network.swift
//  revolut-test
//
//  Created by Frederico Bechara De Paola on 07/02/19.
//  Copyright © 2019 Frederico Bechara De Paola. All rights reserved.
//

import Foundation

enum BusinessError: Error {
    case failedToCast
    case requestFailed
}

class Business {
    let urlStringWithoutBase = "https://revolut.duckdns.org/latest?base="
    var requester: ProviderAPI
    
    init(requester: ProviderAPI) {
        self.requester = requester
    }
    
    func getRates(base: String = "EUR", completion: @escaping (CurrencyModel?, BusinessError?) -> Void) {
        let urlForRequest = urlStringWithoutBase + base
        requester.request(urlString: urlForRequest) { (result) in
            switch result {
            case .success(let data):
                do {
                    let jsonDecoder = JSONDecoder()
                    let currency = try jsonDecoder.decode(CurrencyModel.self, from: data)
                    completion(currency, nil)
                } catch {
                    completion(nil, .failedToCast)
                }
            case .failure:
                completion(nil, .requestFailed)
            }
        }
    }
}
