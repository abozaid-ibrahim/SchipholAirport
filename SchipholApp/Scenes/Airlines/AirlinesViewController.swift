//
//  AirlinesViewController.swift
//  SchipholApp
//
//  Created by abuzeid on 31.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import MapKit
import UIKit

final class AirlinesViewController: UIViewController {
    private let userLocationDistanceMeters: CLLocationDistance = 5000000
    private let locationManager = LocationManager()
    private let mapView = MKMapView()

    private let viewModel: AirlinesViewModelType
    init(with viewModel: AirlinesViewModelType = AirlinesViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: Bundle(for: AirlinesViewController.self))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        binding()
        viewModel.loadData()
        locationManager.getCurrentLocation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopTracking()
        super.viewWillDisappear(animated)
    }
}

extension AirlinesViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
        case is PointAnnotation:
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier,
                                                             for: annotation)
            view.clusteringIdentifier = String(describing: PointView.self)
            return view
        case is MKClusterAnnotation:
            return mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier,
                                                         for: annotation)
        default:
            return nil
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? PointAnnotation else { return }
        AppNavigator.shared.push(.airportDetails(annotation.airport))
        mapView.deselectAnnotation(annotation, animated: false)
    }
}

// MARK: location manager

private extension AirlinesViewController {
    func setup() {
        view.addSubview(mapView)
        mapView.setConstrainsEqualToParentEdges()
        mapView.delegate = self
        mapView.register(PointView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
//        mapView.register(PointsClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }

    func binding() {
        viewModel.reloadData.subscribe { [weak self] reload in
            let annotations = reload.compactMap(PointAnnotation.init)
            self?.mapView.addAnnotations(annotations)
        }

        viewModel.error.subscribe { [weak self] error in
            guard let self = self, let msg = error else { return }
            self.show(error: msg)
        }
        locationManager.error.subscribe { [weak self] error in
            guard let self = self, let error = error else { return }
            self.show(error: error.message, actions: error.actions)
        }
        locationManager.location.subscribe { [weak self] location in
            guard let self = self,
                let loc = location else { return }
            self.mapView.setRegion(.init(center: loc.coordinate,
                                         latitudinalMeters: self.userLocationDistanceMeters,
                                         longitudinalMeters: self.userLocationDistanceMeters),
                                   animated: true)
        }
    }
}
