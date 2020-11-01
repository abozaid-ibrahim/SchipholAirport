//
//  AirportsViewModel.swift
//  SchipholApp
//
//  Created by abuzeid on 30.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

protocol AirportsViewModelType {
    var reloadData: Observable<Bool> { get }
    var error: Observable<String?> { get }
    var isLoading: Observable<Bool> { get }
    var dataList: [Airport] { get }
    func loadData()
}

final class AirportsViewModel: AirportsViewModelType {
    private let airportsLoader: AirportsDataSource
    private let flightsLoader: FlightsDataSource
    let reloadData: Observable<Bool> = .init(false)
    let isLoading: Observable<Bool> = .init(false)
    let error: Observable<String?> = .init(nil)
    private(set) var dataList: [Airport] = []

    init(airportsLoader: AirportsDataSource = AirportsLocalLoader(),
         flightsLoader: FlightsDataSource = FlightsLocalLoader()) {
        self.airportsLoader = airportsLoader
        self.flightsLoader = flightsLoader
    }

    func loadData() {
        let dispatchGroup = DispatchGroup()
        var airports: AirportsList = []
        var flights: [String: String] = [:]
        isLoading.next(true)
        dispatchGroup.enter()
        airportsLoader.loadAirports { [weak self] data in
            guard let self = self else { return }
            switch data {
            case let .success(response):
                airports = response
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
                for flight in response {
                    flights[flight.arrivalAirportID] = flight.departureAirportID
                }
            case let .failure(error):
                self.error.next(error.localizedDescription)
            }

            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            let sources = airports.filter { flights[$0.id] == Airport.schipholAirport.id }
                .sorted(by: {
                    $0.distance(to: Airport.schipholAirport) < $1.distance(to: Airport.schipholAirport)
                })
            self.dataList = sources
            self.reloadData.next(true)
            self.isLoading.next(false)
        }
    }
}
