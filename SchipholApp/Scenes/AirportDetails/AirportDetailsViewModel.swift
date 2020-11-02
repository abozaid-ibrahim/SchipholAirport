//
//  AirportDetailsViewModel.swift
//  SchipholApp
//
//  Created by abuzeid on 31.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import CoreLocation
import Foundation

protocol AirportDetailsViewModelType {
    var airport: Airport { get }
    var nearestAirport: Observable<String?> { get }
    func loadData()
}

final class AirportDetailsViewModel: AirportDetailsViewModelType {
    let airport: Airport
    private let dataLoader: AirportsDataSource
    let nearestAirport: Observable<String?> = .init(nil)
    let error: Observable<String?> = .init(nil)

    init(loader: AirportsDataSource = AirportsLocalLoader(),
         airport: Airport) {
        self.airport = airport
        dataLoader = loader
    }

    func loadData() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.dataLoader.loadAirports { data in
                switch data {
                case let .success(response):
                    self.nearestAirport(of: response)
                case let .failure(error):
                    self.error.next(error.localizedDescription)
                }
            }
        }
    }

    private func nearestAirport(of airports: [Airport]) {
        var nearest: Airport?
        var minDistance = Double.infinity
        for value in airports {
            let dest = airport.distance(to: value)
            if dest < minDistance, dest > 0 {
                nearest = value
                minDistance = dest
            }
        }
        guard let airport = nearest else { return }
        let text = "\(airport.name)\n\(airport.address)\n\(minDistance.formatted)"

        nearestAirport.next(text)
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
