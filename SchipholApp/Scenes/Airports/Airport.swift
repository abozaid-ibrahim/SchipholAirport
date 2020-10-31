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
    let name: String?
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

typealias AirportsResponse = [Airport]
