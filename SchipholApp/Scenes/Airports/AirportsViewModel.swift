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
        isLoading.next(true)
        let dispatchGroup = DispatchGroup()

        var airports: AirportsList = []
        dispatchGroup.enter()
        getAirports {
            airports = $0
            dispatchGroup.leave()
        }

        var flights: [String: String] = [:]
        dispatchGroup.enter()
        getFlights {
            flights = $0
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: DispatchQueue.global()) { [weak self] in
            guard let self = self else { return }
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

private extension AirportsViewModel {
    func getAirports(callback: @escaping ([Airport]) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.airportsLoader.loadAirports { data in
                switch data {
                case let .success(response):
                    callback(response)
                case let .failure(error):
                    self.error.next(error.localizedDescription)
                    callback([])
                }
            }
        }
    }

    func getFlights(callback: @escaping ([String: String]) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.flightsLoader.loadFlights { data in
                switch data {
                case let .success(response):
                    var flights: [String: String] = [:]
                    for flight in response {
                        flights[flight.arrivalAirportID] = flight.departureAirportID
                    }
                    callback(flights)
                case let .failure(error):
                    self.error.next(error.localizedDescription)
                    callback([:])
                }
            }
        }
    }
}
