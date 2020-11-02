//
//  SchipholAppTests.swift
//  SchipholAppTests
//
//  Created by abuzeid on 30.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

@testable import SchipholApp
import XCTest

final class AirlinesViewModelTests: XCTestCase {
    func testLoadingAirlinesFromSchAirport() throws {
        let viewModel = AirlinesViewModel()
        let exp = expectation(description: "Wait for data loading")
        viewModel.loadData()
        var initialCall = true
        let id = viewModel.airlinesList.subscribe(on: .global(), { value in
            if initialCall {
                XCTAssertEqual(value.count, 0)
                initialCall = false
            } else {
                XCTAssertEqual(value.count, 73)
                exp.fulfill()
            }
        })
        defer { viewModel.airlinesList.unsubscribe(id: id) }
        waitForExpectations(timeout: 0.01, handler: nil)
    }
}
