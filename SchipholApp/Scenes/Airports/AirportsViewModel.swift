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
    private let dataLoader: AirportsDataSource
    private let days: Int = 5
    let reloadData: Observable<Bool> = .init(false)
    let isLoading: Observable<Bool> = .init(false)
    let error: Observable<String?> = .init(nil)
    private(set) var dataList: [Airport] = []

    init(loader: AirportsDataSource = LocalAirportsLoader()) {
        dataLoader = loader
    }

    func loadData() {
        isLoading.next(true)
        dataLoader.loadAirports(city: "cityName", days: days, compeletion: { [weak self] data in
            guard let self = self else { return }
            switch data {
            case let .success(response):
                self.dataList = response
                self.reloadData.next(true)
            case let .failure(error):
                self.error.next(error.localizedDescription)
            }
            self.isLoading.next(false)
        })
    }

    private func reset() {
        dataList.removeAll()
        reloadData.next(true)
    }
}
