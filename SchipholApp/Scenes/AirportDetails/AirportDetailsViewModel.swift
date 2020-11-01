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
        let distanceInMeters = Airport.schipholAirport.distance(to: airport)
        return formatted(distance: distanceInMeters)
    }

    private func formatted(distance: CLLocationDistance) -> String {
        let lengthFormatter = LengthFormatter()
        lengthFormatter.numberFormatter.maximumFractionDigits = 1

        if NSLocale.current.usesMetricSystem {
            return lengthFormatter.string(fromValue: distance / 1000, unit: .kilometer)
        } else {
            return lengthFormatter.string(fromValue: distance / 1609.34, unit: .mile)
        }
    }
}

extension Airport {
    var address: String {
        "\(city ?? ""), \(countryID ?? "")"
    }
}
