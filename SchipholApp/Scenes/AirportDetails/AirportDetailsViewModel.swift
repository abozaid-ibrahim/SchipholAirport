//
//  AirportDetailsViewModel.swift
//  SchipholApp
//
//  Created by abuzeid on 31.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import CoreLocation
import Foundation

final class AirportDetailsViewModel {
    let airport: Airport

    init(airport: Airport) {
        self.airport = airport
    }

    var nearestAirport: String {
        return Airport.schipholAirport.distance(to: airport).formatted
    }
}

extension Airport {
    var address: String {
        "\(city ?? ""), \(countryID ?? "")"
    }
}

extension CLLocationDistance {
    var formatted: String {
        let lengthFormatter = LengthFormatter()
        lengthFormatter.numberFormatter.maximumFractionDigits = 1

        if NSLocale.current.usesMetricSystem {
            return lengthFormatter.string(fromValue: self / 1000, unit: .kilometer)
        } else {
            return lengthFormatter.string(fromValue: self / 1609.34, unit: .mile)
        }
    }
}
