//
//  LocalAirportsLoader.swift
//  SchipholApp
//
//  Created by abuzeid on 30.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

protocol AirportsDataSource {
    func loadAirports(city: String, days: Int, compeletion: @escaping (Result<[Airport], NetworkError>) -> Void)
}

final class LocalAirportsLoader: AirportsDataSource {

    func loadAirports(city: String, days: Int, compeletion: @escaping (Result<[Airport], NetworkError>) -> Void) {
        do {
            let response = try Bundle.main.decode([Airport].self, from: "AirportsData.json")
            compeletion(.success(response))
        } catch {
            compeletion(.failure(.noData))
        }
    }
}
