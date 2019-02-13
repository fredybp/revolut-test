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
		
		for (_, dict) in rates.enumerated() {
			ratesAsArray.append(Rates(currency: dict.key, value: dict.value))
		}
		
		return ratesAsArray.sorted { $0.currency < $1.currency }
	}
	

}

struct Rates {
	var currency: String
	var value: Double
	
	func getSubtitle() -> String {
		let dict = [
			"AUD": "Australian Dollar",
			"BGN": "Bulgarian Lev",
			"BRL": "Brazilian Real",
			"CAD": "Canadian Dollar",
			"CHF": "Swiss Franc",
			"CNY": "Chinese Yuan",
			"CZK": "Czech Koruna",
			"DKK": "Danish Krone",
			"GBP": "Pound Sterling",
			"HKD": "Hong Kong Dollar",
			"HRK": "Croatian Kuna",
			"HUF": "Hungarian Forint",
			"IDR": "Indonesian Rupiah",
			"ILS": "Israeli New Shekel",
			"INR": "Indian Rupee",
			"ISK": "Icelandic króna",
			"JPY": "Japanese Yen",
			"KRW": "South Korean Won",
			"MXN": "Mexican Peso",
			"MYR": "Malaysian Ringgit",
			"NOK": "Norwegian Krone",
			"NZD": "New Zealand Dollar",
			"PHP": "Philippine Peso",
			"PLN": "Polish Złoty",
			"RON": "Romanian Leu",
			"RUB": "Russian Ruble",
			"SEK": "Swedish Krona",
			"SGD": "Singapore dollar",
			"THB": "Thai Baht",
			"TRY": "Turkish Lira",
			"USD": "United States Dollar",
			"ZAR": "South African Rand",
			"EUR": "Euro"
		]
		
		return dict[currency] ?? ""
	}
}
