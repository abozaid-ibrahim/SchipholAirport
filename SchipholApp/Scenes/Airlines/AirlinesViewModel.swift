//
//  AirportsViewModel.swift
//  SchipholApp
//
//  Created by abuzeid on 30.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

protocol AirlinesViewModelType {
    var reloadData: Observable<Bool> { get }
    var error: Observable<String?> { get }
    var isLoading: Observable<Bool> { get }
    var dataList: [Airline] { get }
    func loadData()
}

final class AirlinesViewModel: AirlinesViewModelType {
    private let airlinesLoader: AirlinesDataSource
    private let flightsLoader: FlightsDataSource
    let reloadData: Observable<Bool> = .init(false)
    let isLoading: Observable<Bool> = .init(false)
    let error: Observable<String?> = .init(nil)
    private(set) var dataList: [Airline] = []

    init(airportsLoader: AirlinesDataSource = AirlinesLocalLoader(),
         flightsLoader: FlightsDataSource = FlightsLocalLoader()) {
        airlinesLoader = airportsLoader
        self.flightsLoader = flightsLoader
    }

    func loadData() {
        let dispatchGroup = DispatchGroup()
        var airlines: [Airline] = []
        var flights: [String: Double] = [:]
        isLoading.next(true)
        dispatchGroup.enter()
        airlinesLoader.loadAirlines { [weak self] data in
            guard let self = self else { return }
            switch data {
            case let .success(response):
                airlines = response
            case let .failure(error):
                self.error.next(error.localizedDescription)
            }
            self.isLoading.next(false)
            dispatchGroup.leave()
        }
        dispatchGroup.enter()

        flightsLoader.loadFlights { [weak self] data in
            guard let self = self else { return }
            switch data {
            case let .success(response):
                for flight in response where flight.departureAirportID == Airport.schipholAirport.id {
                    flights[flight.airlineID] = flights[flight.airlineID] ?? 0 + 5
                }
            case let .failure(error):
                self.error.next(error.localizedDescription)
            }

            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            let airlinesList = airlines.filter { flights[$0.id] ?? 0 > 0 }
                .sorted(by: {
                    $0.totalDistance ?? 0 < $1.totalDistance ?? 0
                })
            self.dataList = airlinesList
            self.reloadData.next(true)
            self.isLoading.next(false)
        }
    }
}
