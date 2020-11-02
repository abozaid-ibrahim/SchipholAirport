//
//  AirportsViewModel.swift
//  SchipholApp
//
//  Created by abuzeid on 30.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

protocol AirportsMapViewModelType {
    var airportsList: Observable<[Airport]> { get }
    var error: Observable<String?> { get }
    func loadData()
}

final class AirportsMapViewModel: AirportsMapViewModelType {
    private let dataLoader: AirportsDataSource
    let airportsList: Observable<[Airport]> = .init([])
    let error: Observable<String?> = .init(nil)

    init(loader: AirportsDataSource = AirportsLocalLoader()) {
        dataLoader = loader
    }

    func loadData() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.dataLoader.loadAirports { data in
                switch data {
                case let .success(response):
                    self.airportsList.next(response)
                case let .failure(error):
                    self.error.next(error.localizedDescription)
                }
            }
        }
    }
}
