//
//  CLLocationDistance+Formatter.swift
//  SchipholApp
//
//  Created by abuzeid on 02.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationDistance {
    var formatted: String {
        let lengthFormatter = LengthFormatter()
        lengthFormatter.numberFormatter.maximumFractionDigits = 1

        if NSLocale.current.usesMetricSystem {
            return lengthFormatter.string(fromValue: self / 1000, unit: .kilometer)
        } else {
            return lengthFormatter.string(fromValue: self / 1609.34, unit: .mile)
        }
    }
}
