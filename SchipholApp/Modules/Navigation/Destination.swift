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
            if haveTab {
                let mapItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 0)
                mapvc.tabBarItem = mapItem
            }
            return mapvc
        case let .airports(haveTab):
            let airports = AirportsTableController()
            if haveTab {
                let tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
                airports.tabBarItem = tabBarItem
            }
            return airports

        case let .airlines(haveTab):
            let airline = AirlinesTableController()
            if haveTab {
                let tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
                airline.tabBarItem = tabBarItem
            }
            return airline
        }
    }
}
