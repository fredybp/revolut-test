//
//  revolut_testTests.swift
//  revolut-testTests
//
//  Created by Frederico Bechara De Paola on 06/02/19.
//  Copyright © 2019 Frederico Bechara De Paola. All rights reserved.
//

import XCTest
@testable import revolut

class RevolutTestTests: XCTestCase {

    var mockBusiness = Business(requester: ProviderMock())
    
    override func setUp() {
        super.setUp()
    }

    func testBaseEURAndStatusCode200ForValidModel() {
        mockBusiness.getRates(base: "baseEUR200") { (model, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(model)
            XCTAssert(model!.base == "EUR")
            XCTAssert(model!.rateArray.count > 0)
        }
    }

    func testBaseBRLAndStatusCode200ForValidModel() {
        mockBusiness.getRates(base: "baseBRL200") { (model, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(model)
            XCTAssert(model!.base == "BRL")
            XCTAssert(model!.rateArray.count > 0)
        }
    }
    
}
