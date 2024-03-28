//
//  ViewController.swift
//  NearMe
//
//  Created by Vitalii Navrotskyi on 28.03.2024.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    lazy var mapView: MKMapView = {
        let map = MKMapView()
//        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()

    lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.layer.cornerRadius = 10
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

}

