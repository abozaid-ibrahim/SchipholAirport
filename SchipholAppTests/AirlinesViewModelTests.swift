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
    func testLoadingAirlinesFromMainAirport() throws {
        let viewModel = AirlinesViewModel(airlinesLoader: AirlinesLoaderMocking(),
                                          flightsLoader: FlightsLoaderMocking(),
                                          airportsLoader: AirportsLoaderMocking())
        let exp = expectation(description: "Wait for data loading")
        viewModel.loadAirlinesData(of: AirportsLoaderMocking.main)
        var initialCall = true
        let id = viewModel.airlinesList.subscribe(on: .global(), { value in
            if initialCall {
                XCTAssertEqual(value.count, 0)
                initialCall = false
            } else {
                XCTAssertEqual(value.count, 2)
                guard let neareast = value.first,
                    let farest = value.last else {
                    XCTFail("Airlines are empty")
                    return
                }
                XCTAssertEqual(neareast.id, "A3")
                XCTAssertEqual(farest.id, "A1")
                exp.fulfill()
            }
        })
        defer { viewModel.airlinesList.unsubscribe(id: id) }
        waitForExpectations(timeout: 0.01, handler: nil)
    }
}

final class AirlinesLoaderMocking: AirlinesDataSource {
    func loadAirlines(compeletion: @escaping (Result<[Airline], NetworkError>) -> Void) {
        let line1 = Airline(id: "A1", name: "Airline1")
        let line2 = Airline(id: "A2", name: "Airline2")
        let line3 = Airline(id: "A3", name: "Airline3")
        compeletion(.success([line1, line2, line3]))
    }
}

final class AirportsLoaderMocking: AirportsDataSource {
    static let main: Airport = Airport(id: "P1", latitude: 0, longitude: 0, name: "M Airport", city: nil, countryID: "EG")
    func loadAirports(compeletion: @escaping (Result<AirportsList, NetworkError>) -> Void) {
        let port2 = Airport(id: "P2", latitude: 0.1, longitude: 2.1, name: "Airport", city: nil, countryID: "EG")
        let port3 = Airport(id: "P3", latitude: 0.1, longitude: 1.1, name: "Airport", city: nil, countryID: "EG")
        compeletion(.success([AirportsLoaderMocking.main, port2, port3]))
    }
}

final class FlightsLoaderMocking: FlightsDataSource {
    func loadFlights(compeletion: @escaping (Result<FlightsList, NetworkError>) -> Void) {
        let flight1 = Flight(airlineID: "A1", flightNumber: 1, departureAirportID: "P1", arrivalAirportID: "P2")
        let flight2 = Flight(airlineID: "A2", flightNumber: 1, departureAirportID: "P2", arrivalAirportID: "P1")
        let flight3 = Flight(airlineID: "A3", flightNumber: 1, departureAirportID: "P1", arrivalAirportID: "P3")
        compeletion(.success([flight1, flight2, flight3]))
    }
}
