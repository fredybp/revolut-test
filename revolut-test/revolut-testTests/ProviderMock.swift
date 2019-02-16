//
//  ProviderMock.swift
//  revolut-testTests
//
//  Created by Frederico Bechara De Paola on 14/02/19.
//  Copyright © 2019 Frederico Bechara De Paola. All rights reserved.
//

import Foundation

@testable import revolut

class ProviderMock: ProviderAPI {
    func request(urlString: String, completion: @escaping (Result<Data, APIError>) -> Void) {
        if let path = Bundle.main.path(forResource: urlString, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                completion(.success(data))
            } catch {
                completion(.failure(APIError.wrongMock))
            }
        }
    }
}
