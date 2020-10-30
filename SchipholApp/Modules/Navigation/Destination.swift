//
//  Destination.swift
//  SchipholApp
//
//  Created by abuzeid on 30.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit

typealias Airport = String
enum Destination {
    case mainTab
    case airportDetails(of: Airport?)
    var controller: UIViewController {
        switch self {
        case .mainTab:
            let tab = UITabBarController()
            tab.setViewControllers([AirportsTableController(), AirportsTableController()], animated: true)
            return tab
        case let .airportDetails(contact):
            return UIViewController()
        }
    }
}
