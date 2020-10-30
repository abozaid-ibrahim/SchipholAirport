//
//  Navigator.swift
//  SchipholApp
//
//  Created by abuzeid on 30.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//
import Foundation
import UIKit

final class AppNavigator {
    static let shared = AppNavigator()
    private static var homeNavigationController: UINavigationController!

    private init() {}

    func set(window: UIWindow) {
        AppNavigator.homeNavigationController = UINavigationController(rootViewController: Destination.mainTab.controller)
        window.rootViewController = AppNavigator.homeNavigationController
        window.makeKeyAndVisible()
    }

    func push(_ dest: Destination) {
        AppNavigator.homeNavigationController.pushViewController(dest.controller, animated: true)
    }
}
