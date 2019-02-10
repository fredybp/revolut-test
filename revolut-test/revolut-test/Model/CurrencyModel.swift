//
//  CurrencyModel.swift
//  revolut-test
//
//  Created by Frederico Bechara De Paola on 07/02/19.
//  Copyright © 2019 Frederico Bechara De Paola. All rights reserved.
//

struct CurrencyModel: Decodable {
	var base: String
	var rates: [String: Double]
	var rateArray: [Rates] {
		mutating get {
			return orderedRates()
		}
	}
	
	mutating func orderedRates() -> [Rates] {
		var ratesAsArray = [Rates]()
		
		ratesAsArray.append(Rates(currency: base, value: 1))
		for (_, dict) in rates.enumerated() {
			ratesAsArray.append(Rates(currency: dict.key, value: dict.value))
		}
		
		return ratesAsArray
	}
}

struct Rates {
	let currency: String
	let value: Double
}
