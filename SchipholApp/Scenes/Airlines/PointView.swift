//
//  PointView.swift
//  SchipholApp
//
//  Created by abuzeid on 31.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import MapKit
import UIKit

// MARK: Point View

internal final class PointView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = String(describing: PointView.self)
        displayPriority = .defaultHigh
//        image = UIImage(named: "service_point_map_pin", in: AirlinesViewController.bundle, compatibleWith: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Points Cluster View

@available(iOS 11.0, *)
internal final class PointsClusterView: MKMarkerAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        displayPriority = .defaultHigh
        markerTintColor = .red
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()

        guard let annotation = annotation as? MKClusterAnnotation else { return }
        canShowCallout = false
        glyphText = annotation.memberAnnotations.count.description
        subtitleVisibility = .hidden
        markerTintColor = .clear
//        image = UIImage(named: "clusterPin", in: AirlinesViewController.bundle, compatibleWith: nil)
    }
}

// extension MKCoordinateRegion {
//    init(region: LocationViewModel) {
//        self.init(center: CLLocationCoordinate2D(location: region.location),
//                  latitudinalMeters: region.latitudeMeters,
//                  longitudinalMeters: region.longitudeMeters)
//    }
// }

extension CLLocationCoordinate2D {
    init(from: Airport) {
        self.init(latitude: from.latitude, longitude: from.longitude)
    }
}

extension LocationViewModel {
    init(location: CLLocation) {
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
    }
}

final class PointAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let airport: Airport
    init(airport: Airport) {
        self.airport = airport
        coordinate = CLLocationCoordinate2D(from: airport)
        super.init()
    }
}

struct LocationViewModel {
    var latitudeMeters:Double = 0
    let longitudeMeters: Double = 0
    let latitude, longitude: Double
}

extension LocationViewModel {
    var location: CLLocation {
        return .init(latitude: latitude, longitude: longitude)
    }
}
