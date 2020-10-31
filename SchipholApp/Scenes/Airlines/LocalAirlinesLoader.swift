//
//  AirlineDataSource.swift
//  SchipholApp
//
//  Created by abuzeid on 30.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
typealias AirportsList = [Airport]
protocol AirlineDataSource {
    func loadAirports(compeletion: @escaping (Result<AirportsList, NetworkError>) -> Void)
}

final class LocalAirlinesLoader: AirlineDataSource {
    func loadAirports(compeletion: @escaping (Result<AirportsList, NetworkError>) -> Void) {
        do {
            let response = try Bundle.main.decode(AirportsList.self, from: "AirportsData.json")
            compeletion(.success(response))
        } catch {
            compeletion(.failure(.noData))
        }
    }
}
