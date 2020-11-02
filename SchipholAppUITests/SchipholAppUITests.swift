//
//  SchipholAppUITests.swift
//  SchipholAppUITests
//
//  Created by abuzeid on 02.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import XCTest

final class SchipholAppUITests: XCTestCase {
    func testNavigationToDetailsScreenProperly() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons[AccessibilityId.airportsTab].tap()
        let cellNameText = app.tables.cells.firstMatch.staticTexts
            .element(matching: .any, identifier: AccessibilityId.cellNameLabel).label
        app.tables.cells.firstMatch.tap()
        XCTAssert(app.staticTexts[AccessibilityId.airportNameLabel].exists)
        let detailsNameText = app.staticTexts
            .element(matching: .any, identifier: AccessibilityId.airportNameLabel).label
        XCTAssertEqual(cellNameText, detailsNameText)
    }

    func testLaunchPerformanceInLessThan1350MilliSecond() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
