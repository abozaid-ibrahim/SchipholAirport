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
    private static let userLocationDistanceMeters: CLLocationDistance = 5000
    private static let viewPresentationAnimationTime = 0.2

    static let bundle = Bundle(for: AirlinesViewController.self)

    lazy var mapView: MKMapView = {
        let map = MKMapView()

        return map
    }()

    private var locationManager = CLLocationManager()

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
        view.addSubview(mapView)
        mapView.setConstrainsEqualToParentEdges()
        mapView.register(PointView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(PointsClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)

        locationManager.delegate = self
        bindToViewModel()
        viewModel.loadData()
//        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

//    func bind(to viewModel: ShipmentPointPickerViewModel) {
//        viewModel.route.observe(on: self) { [weak self] route in
//            self?.handle(route)
//        }
//        viewModel.error.observe(on: self) { [weak self] error in
//            self?.showError(description: error)
//        }
//        viewModel.isLoading.observeAndFire(on: self) { [weak self] isLoading in
//            if isLoading {
//                self?.showLoading()
//            } else {
//                self?.removeLoading()
//            }
//        }
//        viewModel.centeredOnRegion.observeAndFire(on: self) { [weak self] region in
//            self?.mapView.setRegion(MKCoordinateRegion(region: region), animated: true)
//        }
//
//        viewModel.userLocation.observeAndFire(on: self) { [weak self] userLocation in
//            guard let userLocation = userLocation else { return }
//            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(location: userLocation),
//                                            latitudinalMeters: ShipmentPointPickerViewController.userLocationDistanceMeters,
//                                            longitudinalMeters: ShipmentPointPickerViewController.userLocationDistanceMeters)
//            self?.mapView.setRegion(region, animated: true)
//        }
//
//        viewModel.servicePoints.observeAndFire(on: self) { [weak self] points in
//            let annotations = points.compactMap(PointAnnotation.init)
//            self?.mapView.addAnnotations(annotations)
//        }
//    }
//
//    @IBAction func getCurrentLocationTapped(_ sender: Any) {
//        viewModel.didSetUserLocation(userLocation: nil)
//        retriveCurrentLocation()
//    }

    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }

    private func retriveCurrentLocation() {
        let status = CLLocationManager.authorizationStatus()

        if status == .denied || status == .restricted || !CLLocationManager.locationServicesEnabled() {
            showLocationPermissionIsRequiredError()
            return
        }

        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        setLocation(isUpdating: true)
        locationManager.requestLocation()
    }

    private func showLocationPermissionIsRequiredError() {
        let alertController = UIAlertController(title: "error",
                                                message: "To determine the location, enable 'Location Services' in the settings of your phone.",
                                                preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl) { _ in }
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "cancel_button", style: .default, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    private func showServicePointDetailsView(for servicePoint: Airline) {
    }

    private func hideServicePointDetailsView(animated: Bool = true) {
    }

    private func setLocation(isUpdating: Bool) {
//        locationUpdateLoaderView.isHidden = !isUpdating
//        locationUpdateButton.isEnabled = !isUpdating
    }

    @IBAction func hideServicePointDetailsView(_ sender: Any) {
        hideServicePointDetailsView()
    }

    @IBAction func selectServicePoint(_ sender: Any) {
    }
}

extension AirlinesViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }

        var annotationView: MKAnnotationView?

        if let annotation = annotation as? MKClusterAnnotation {
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier, for: annotation)
            annotationView?.image = .none
        } else if let annotation = annotation as? PointAnnotation {
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier, for: annotation)
            annotationView?.clusteringIdentifier = String(describing: PointView.self)
//            annotationView?.image = image(for: annotation.viewModelServicePoint.servicePoint.shipmentOperatorFromID)
        }

        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? PointAnnotation else { return }

        hideServicePointDetailsView()
//        viewModel.didSelect(servicePoint: annotation.viewModelServicePoint)
        mapView.deselectAnnotation(annotation, animated: false)
    }
}

extension AirlinesViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        setLocation(isUpdating: false)

        manager.stopUpdatingLocation()
        var errorMessage: String!
        switch (error as NSError).code {
        case CLError.network.rawValue: errorMessage = "mv_location_network_error"
        case CLError.denied.rawValue: showLocationPermissionIsRequiredError()
        default: errorMessage = "mv_location_unknown_error"
        }

//        showError(description: errorMessage)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        setLocation(isUpdating: false)
        guard let location = locations.first else {
            return
        }

        manager.stopUpdatingLocation()
//        viewModel.didSetUserLocation(userLocation: ShipmentPointPickerLocationViewModel(location: location))
    }
}

private extension AirlinesViewController {
    func bindToViewModel() {
        viewModel.reloadData.subscribe { [weak self] reload in
            DispatchQueue.main.async {
                let annotations = reload.compactMap(PointAnnotation.init)

                self?.mapView.addAnnotations(annotations)
            }
        }
        viewModel.isLoading.subscribe { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
            }
        }
        viewModel.error.subscribe { [weak self] error in
            guard let self = self, let msg = error else { return }
            DispatchQueue.main.async { self.show(error: msg) }
        }
    }
}
