//
//  FlightsLocalLoader.swift
//  SchipholApp
//
//  Created by abuzeid on 30.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

protocol FlightsDataSource {
    func loadFlights(compeletion: @escaping (Result<FlightsList, NetworkError>) -> Void)
}

final class FlightsLocalLoader: FlightsDataSource {
    func loadFlights(compeletion: @escaping (Result<FlightsList, NetworkError>) -> Void) {
        do {
            let response = try Bundle.main.decode(FlightsList.self, from: "FlightsData.json")
            compeletion(.success(response))
        } catch {
            compeletion(.failure(.noData))
        }
    }
}
