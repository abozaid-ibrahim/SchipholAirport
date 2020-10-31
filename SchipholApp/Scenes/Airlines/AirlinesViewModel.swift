//
//  AirportsViewModel.swift
//  SchipholApp
//
//  Created by abuzeid on 30.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

protocol AirlinesViewModelType {
    var reloadData: Observable< [Airport]> { get }
    var error: Observable<String?> { get }
    var isLoading: Observable<Bool> { get }
    var dataList: [Airline] { get }
    func loadData()
}

final class AirlinesViewModel: AirlinesViewModelType {
    private let dataLoader: AirlineDataSource
    private let days: Int = 5
    let reloadData: Observable< [Airport]> = .init([])
    let isLoading: Observable<Bool> = .init(false)
    let error: Observable<String?> = .init(nil)
    private(set) var dataList: [Airline] = []

    init(loader: AirlineDataSource = LocalAirlinesLoader()) {
        dataLoader = loader
    }

    func loadData() {
        isLoading.next(true)
        dataLoader.loadAirports { [weak self] data in
            guard let self = self else { return }
            switch data {
            case let .success(response):
//                self.dataList = response
                self.reloadData.next(response)
            case let .failure(error):
                self.error.next(error.localizedDescription)
            }
            self.isLoading.next(false)
        }
    }
}
