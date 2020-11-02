//
//  Strings.swift
//  SchipholApp
//
//  Created by abuzeid on 30.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
struct Str {
    static var nearestAirport: String { "nearest_Airport".localized }
    static var locationError: String { "location_error".localized }
    static var cancel: String { "cancel".localized }
    static var enableLocationPermission: String { "enable_location_permission".localized }
    static var settings: String { "settings".localized }
    static var map: String { "map".localized }
    static var airports: String { "airports".localized }
    static var airlines: String { "airlines".localized }
}

extension String {
    var localized: String { return NSLocalizedString(self, comment: "") }
}
