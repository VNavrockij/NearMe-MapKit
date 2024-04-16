//
//  ViewController.swift
//  NearMe
//
//  Created by Vitalii Navrotskyi on 28.03.2024.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    // kyiv lat 50,450001 long 30,523333

    var locationManager: CLLocationManager?

    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()

    lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.layer.cornerRadius = 10
        searchTextField.delegate = self
        searchTextField.clipsToBounds = true
        searchTextField.backgroundColor = UIColor.white
        searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        searchTextField.leftViewMode = .always
        searchTextField.placeholder = "Search"
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        return searchTextField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // init location manager
        locationManager = CLLocationManager()
        locationManager?.delegate = self

        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestLocation()

        setupUI()
    }

    private func setupUI() {
        view.addSubview(searchTextField)
        view.addSubview(mapView)

        view.bringSubviewToFront(searchTextField)
        searchTextField.returnKeyType = .go

        NSLayoutConstraint.activate([
            searchTextField.widthAnchor.constraint(equalToConstant: view.bounds.size.width / 1.2),
            searchTextField.heightAnchor.constraint(equalToConstant: 44),
            searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
        ])

        NSLayoutConstraint.activate([
            mapView.widthAnchor.constraint(equalTo: view.widthAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor),
            mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func checkLocationAuthorization() {
        guard let locationManager = locationManager,
              let location = locationManager.location else { return }

        switch locationManager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                let region = MKCoordinateRegion(
                    center: location.coordinate,
                    latitudinalMeters: 5000,
                    longitudinalMeters: 5000)
                mapView.setRegion(region, animated: true)
            case .denied:
                print("Location services has been denided")
            case .notDetermined, .restricted:
                print("Location cannot be determined or restricted")
            @unknown default:
                print("Unknow error. Unable to get location")
        }
    }

    private func presentPlacesSheet(places: [PlaceAnnotation]) {

        guard let locationManager = locationManager,
              let userLocation = locationManager.location else { return }

        let placesTVC = PlacesTableViewController(userLocation: userLocation, places: places)
        placesTVC.modalPresentationStyle = .pageSheet

        if let sheet = placesTVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            present(placesTVC, animated: true)
        }
    }

    private func findNearByPlaces(by query: String) {
        // clear all annotations
        mapView.removeAnnotations(mapView.annotations)

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = mapView.region

        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in

            guard let response = response, error == nil else { return }

            let places = response.mapItems.map(PlaceAnnotation.init)
            places.forEach { place in
                self?.mapView.addAnnotation(place)
            }

            self?.presentPlacesSheet(places: places)
        }
    }
}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text ?? ""
        if !text.isEmpty {
            textField.resignFirstResponder()
            // Find nearby places
            findNearByPlaces(by: text)
        }

        return true
    }
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        NSLog(error.localizedDescription)
    }
}
