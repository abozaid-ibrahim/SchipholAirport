//
//  AirportsTableController.swift
//  SchipholApp
//
//  Created by abuzeid on 30.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import UIKit

final class AirlinesTableController: UITableViewController {
    private let viewModel: AirlinesViewModelType
    private var dataList: [Airline] = []

    init(with viewModel: AirlinesViewModelType = AirlinesViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: Bundle(for: AirportsTableController.self))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = ActivityIndicatorFooterView()
        tableView.register(AirportTableCell.self, forCellReuseIdentifier: AirportTableCell.identifier)
        bindToViewModel()
        viewModel.loadData()
    }
}

// MARK: - Table view data source

extension AirlinesTableController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: AirportTableCell.self, for: indexPath)
        cell.setData(for: dataList[indexPath.row])
        return cell
    }
}

// MARK: - Private

private extension AirlinesTableController {
    var indicator: ActivityIndicatorFooterView? {
        return tableView.tableFooterView as? ActivityIndicatorFooterView
    }

    func bindToViewModel() {
        viewModel.airlinesList.subscribe { [weak self] data in
            self?.dataList = data
            self?.tableView.reloadData()
        }
        viewModel.isLoading.subscribe { [weak self] isLoading in
            guard let self = self else { return }
            self.tableView.sectionFooterHeight = isLoading ? 80 : 0
            self.indicator?.set(isLoading: isLoading)
        }
        viewModel.error.subscribe { [weak self] error in
            guard let self = self, let msg = error else { return }
            self.show(error: msg)
        }
    }
}
