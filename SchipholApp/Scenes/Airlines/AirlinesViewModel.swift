//
//  AirportsViewModel.swift
//  SchipholApp
//
//  Created by abuzeid on 30.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

protocol AirlinesViewModelType {
    var reloadData: Observable<[Airport]> { get }
    var error: Observable<String?> { get }
    func loadData()
}

final class AirlinesViewModel: AirlinesViewModelType {
    private let dataLoader: AirlineDataSource
    let reloadData: Observable<[Airport]> = .init([])
    let error: Observable<String?> = .init(nil)

    init(loader: AirlineDataSource = LocalAirlinesLoader()) {
        dataLoader = loader
    }

    func loadData() {
        dataLoader.loadAirports { [weak self] data in
            guard let self = self else { return }
            switch data {
            case let .success(response):
                self.reloadData.next(response)
            case let .failure(error):
                self.error.next(error.localizedDescription)
            }
        }
    }
}
