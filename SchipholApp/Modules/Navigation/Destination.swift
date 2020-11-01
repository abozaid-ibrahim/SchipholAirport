//
//  Destination.swift
//  SchipholApp
//
//  Created by abuzeid on 30.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit

enum Destination {
    case mainTab
    case map(withTabItem: Bool)
    case airports(withTabItem: Bool)
    case airlines(withTabItem: Bool)
    case airportDetails(Airport)
    var controller: UIViewController {
        switch self {
        case .mainTab:
            let tab = UITabBarController()
            tab.setViewControllers([
                Destination.airlines(withTabItem: true).controller,
                Destination.airports(withTabItem: true).controller,
                Destination.map(withTabItem: true).controller],
            animated: true)

            return tab
        case let .airportDetails(airport):
            let viewModel = AirportDetailsViewModel(airport: airport)
            let controller = AirportDetailsController(with: viewModel)
            return controller
        case let .map(haveTab):
            let mapvc = AirportsMapController()
            mapvc.tabBarItem = haveTab ? UITabBarItem(title: "Map", image: #imageLiteral(resourceName: "map"), tag: 0) : nil
            return mapvc
        case let .airports(haveTab):
            let airports = AirportsTableController()
            airports.tabBarItem = haveTab ? UITabBarItem(title: "Airports", image: #imageLiteral(resourceName: "plane"), tag: 0) : nil
            return airports

        case let .airlines(haveTab):
            let airline = AirlinesTableController()
            airline.tabBarItem = haveTab ? UITabBarItem(title: "Airlines", image: #imageLiteral(resourceName: "list"), tag: 0) : nil
            return airline
        }
    }
}
