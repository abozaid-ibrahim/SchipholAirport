//
//  AirportTableCell+Airline.swift
//  SchipholApp
//
//  Created by abuzeid on 01.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
extension AirportTableCell {
    func setData(for airline: Airline) {
        nameLabel.text = airline.name
        cityLabel.text = airline.distance
    }
}
