//
//  LocationManager.swift
//  SchipholApp
//
//  Created by abuzeid on 31.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import MapKit
import UIKit

protocol LocationManagerType {
    func stopTracking()
    func getCurrentLocation()
    var error: Observable<LocationError?> { get }
    var location: Observable<CLLocation?> { get }
}

struct LocationError {
    let message: String?
    let actions: [AlertAction]
    init(with message: String, _ actions: [AlertAction] = []) {
        self.message = message
        self.actions = actions
    }
}

final class LocationManager: NSObject, LocationManagerType {
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    }()

    let error: Observable<LocationError?> = .init(.none)
    let location: Observable<CLLocation?> = .init(.none)

    func getCurrentLocation() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .denied, .restricted:
            showLocationPermissionIsRequiredError()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            if CLLocationManager.locationServicesEnabled() {
                locationManager.requestLocation()
            } else {
                showLocationPermissionIsRequiredError()
            }
        }
    }

    func stopTracking() {
        locationManager.stopUpdatingLocation()
    }

    private func showLocationPermissionIsRequiredError() {
        let message = "To determine the location, enable 'Location Services' in the settings of your phone."
        let openSettings: AnyAction = {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                UIApplication.shared.canOpenURL(settingsUrl) else {
                return
            }

            UIApplication.shared.open(settingsUrl)
        }
        let error = LocationError(with: message, [(title: "Settings", openSettings)])
        self.error.next(error)
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        var errorMessage: String?
        switch (error as NSError).code {
        case CLError.network.rawValue:
            errorMessage = "Location network error"
        case CLError.denied.rawValue:
            showLocationPermissionIsRequiredError()
        default:
            errorMessage = "Location unknown"
        }
        guard let message = errorMessage else { return }
        self.error.next(.init(with: message))
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        self.location.next(location)
        manager.stopUpdatingLocation()
    }
}
