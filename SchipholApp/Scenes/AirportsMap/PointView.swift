//
//  PointView.swift
//  SchipholApp
//
//  Created by abuzeid on 31.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import MapKit
import UIKit

final class PointView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = String(describing: PointView.self)
        displayPriority = .defaultHigh
        image = UIImage(named: "pin")
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
}

final class PointAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let airport: Airport
    init(airport: Airport) {
        self.airport = airport
        coordinate = CLLocationCoordinate2D(latitude: airport.latitude, longitude: airport.longitude)
        super.init()
    }
}
