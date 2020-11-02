//
//  Flight.swift
//  SchipholApp
//
//  Created by abuzeid on 30.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

struct Flight: Codable {
    let airlineID: String
    let flightNumber: Int?
    let departureAirportID: String
    let arrivalAirportID: String

    enum CodingKeys: String, CodingKey {
        case airlineID = "airlineId"
        case flightNumber
        case departureAirportID = "departureAirportId"
        case arrivalAirportID = "arrivalAirportId"
    }
}
typealias FlightsList = [Flight]
