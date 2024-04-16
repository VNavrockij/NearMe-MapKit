//
//  PlacesTableViewController.swift
//  NearMe
//
//  Created by Vitalii Navrotskyi on 16.04.2024.
//

import Foundation
import UIKit
import MapKit

class PlacesTableViewController: UITableViewController {

    enum CellIdentifier: String {
        case cellInd = "PlaceCell"
    }

    var userLocation: CLLocation
    let places: [PlaceAnnotation]

    init(userLocation: CLLocation, places: [PlaceAnnotation]) {
        self.userLocation = userLocation
        self.places = places
        super.init(nibName: nil, bundle: nil)

        // register cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.cellInd.rawValue)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.cellInd.rawValue, for: indexPath)
        let place = places[indexPath.row]

        // cell config
        var content = cell.defaultContentConfiguration()
        content.text = place.name
        content.secondaryText = "Secondary text"

        cell.contentConfiguration = content
        return cell

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
