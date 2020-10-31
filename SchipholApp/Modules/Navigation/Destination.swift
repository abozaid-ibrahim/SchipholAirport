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
    case airportDetails(of: Airport)
    var controller: UIViewController {
        switch self {
        case .mainTab:
            let tab = UITabBarController()

            tab.setViewControllers([Destination.map(withTabItem: true).controller,
                                    Destination.airports(withTabItem: true).controller],
                                   animated: true)

            return tab
        case let .airportDetails(airport):
            return UIViewController()
        case let .map(haveTab):

            let mapvc = AirlinesViewController()
            if haveTab {
                let mapItem = UITabBarItem(title: "Map", image: nil, selectedImage: nil)
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
        }
    }
}
