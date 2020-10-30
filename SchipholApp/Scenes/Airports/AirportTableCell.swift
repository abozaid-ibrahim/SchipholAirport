//
//  AirportTableCell.swift
//  SchipholApp
//
//  Created by abuzeid on 30.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import UIKit

final class AirportTableCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!

    func setData(for airport: Airport) {
        nameLabel.text = airport.name
    }
}
