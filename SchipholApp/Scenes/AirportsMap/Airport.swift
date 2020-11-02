//
//  Airport.swift
//  SchipholApp
//
//  Created by abuzeid on 30.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

struct Airport: Codable {
    let id: String
    let latitude, longitude: Double
    let name: String
    let city: String?
    let countryID: String?

    enum CodingKeys: String, CodingKey {
        case id
        case latitude, longitude
        case name
        case city
        case countryID = "countryId"
    }
}

import CoreLocation
extension Airport {
    func distance(to airport: Airport) -> Double {
        let fromCoordinate = CLLocation(latitude: latitude, longitude: longitude)
        let toCoordinate = CLLocation(latitude: airport.latitude, longitude: airport.longitude)
        return toCoordinate.distance(from: fromCoordinate)
    }

    static var schipholAirport = Airport(id: "AMS",
                                     latitude: 52.30907,
                                     longitude: 4.763385,
                                     name: "Amsterdam-Schiphol Airport",
                                     city: "Amsterdam",
                                     countryID: "NL")
}
