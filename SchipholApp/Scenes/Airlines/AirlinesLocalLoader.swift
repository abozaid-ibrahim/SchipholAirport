//
//  AirlineDataSource.swift
//  SchipholApp
//
//  Created by abuzeid on 30.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
typealias AirportsList = [Airport]
protocol AirlinesDataSource {
    func loadAirlines(compeletion: @escaping (Result<[Airline], NetworkError>) -> Void)
}

final class AirlinesLocalLoader: AirlinesDataSource {
    func loadAirlines(compeletion: @escaping (Result<[Airline], NetworkError>) -> Void) {
        do {
            let response = try Bundle.main.decode([Airline].self, from: "AirlinesData.json")
            compeletion(.success(response))
        } catch {
            compeletion(.failure(.noData))
        }
    }
}
