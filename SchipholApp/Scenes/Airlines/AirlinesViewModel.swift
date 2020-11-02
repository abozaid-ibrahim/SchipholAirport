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
    private let airportsLoader: AirportsDataSource
    let reloadData: Observable<Bool> = .init(false)
    let isLoading: Observable<Bool> = .init(false)
    let error: Observable<String?> = .init(nil)
    private(set) var dataList: [Airline] = []

    init(airlinesLoader: AirlinesDataSource = AirlinesLocalLoader(),
         flightsLoader: FlightsDataSource = FlightsLocalLoader(),
         airportsLoader: AirportsDataSource = AirportsLocalLoader()) {
        self.airlinesLoader = airlinesLoader
        self.flightsLoader = flightsLoader
        self.airportsLoader = airportsLoader
    }

    func loadData() {
        isLoading.next(true)
        let dispatchGroup = DispatchGroup()

        var airlines: [Airline] = []
        dispatchGroup.enter()
        getAirlines {
            airlines = $0
            dispatchGroup.leave()
        }

        var airports: [String: Airport] = [:]
        dispatchGroup.enter()
        getAirports {
            airports = $0
            dispatchGroup.leave()
        }

        var flightsList: [Flight] = []
        dispatchGroup.enter()
        getFlights {
            flightsList = $0
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: DispatchQueue.global()) { [weak self] in
            guard let self = self else { return }
            let flights = self.filter(flightsList, with: airports)
            self.dataList = self.getSortedAirlines(flights: flights, airlines: airlines)
            self.reloadData.next(true)
            self.isLoading.next(false)
        }
    }
}

private extension AirlinesViewModel {
    func filter(_ flightsList: [Flight], with airports: [String: Airport]) -> [String: Double] {
        var flights: [String: Double] = [:]
        for flight in flightsList
            where flight.departureAirportID == Airport.schipholAirport.id {
            let distance = airports[flight.arrivalAirportID]?.distance(to: Airport.schipholAirport) ?? 0
            flights[flight.airlineID] = flights[flight.airlineID] ?? 0 + distance
        }
        return flights
    }

    func getSortedAirlines(flights: [String: Double], airlines: [Airline]) -> [Airline] {
        var selectedAirlines: [Airline] = []
        selectedAirlines.reserveCapacity(min(airlines.capacity, flights.count))

        for airline in airlines {
            guard let distance = flights[airline.id], distance > 0 else { continue }
            var obj = airline
            obj.totalDistance = distance
            selectedAirlines.append(obj)
        }
        return selectedAirlines.sorted(by: {
            $0.totalDistance ?? 0 < $1.totalDistance ?? 0
        })
    }

    func getAirlines(callback: @escaping ([Airline]) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.airlinesLoader.loadAirlines { data in
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

    func getAirports(callback: @escaping ([String: Airport]) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.airportsLoader.loadAirports { data in
                switch data {
                case let .success(response):
                    var airports: [String: Airport] = [:]
                    for airport in response {
                        airports[airport.id] = airport
                    }
                    callback(airports)
                case let .failure(error):
                    self.error.next(error.localizedDescription)
                    callback([:])
                }
            }
        }
    }

    func getFlights(callback: @escaping ([Flight]) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.flightsLoader.loadFlights { data in
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
}
