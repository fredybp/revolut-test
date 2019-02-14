//
//  revolut_testUITests.swift
//  revolut-testUITests
//
//  Created by Frederico Bechara De Paola on 13/02/19.
//  Copyright © 2019 Frederico Bechara De Paola. All rights reserved.
//

import XCTest

@testable import revolut

class revolut_testUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        app.tables.cells.containing(.staticText, identifier:"BRL").children(matching: .textField).element.tap()
        
        let deleteKey = app.keys["Delete"]
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        app.keys["0"].tap()
        
        
        let tablesQuery = app.tables
        let textFields = tablesQuery.cells.containing(.textField, identifier: nil)
        let cell = cellQuery.children(matching: .staticText)
        let cellElement = cell.element
        cellElement.tap()
        app.tables.cells.textFields()
        
    }

}
