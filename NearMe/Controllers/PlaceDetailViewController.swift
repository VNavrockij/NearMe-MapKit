//
//  PlaceDetailViewController.swift
//  NearMe
//
//  Created by Vitalii Navrotskyi on 18.04.2024.
//

import UIKit

class PlaceDetailViewController: UIViewController {

    let place: PlaceAnnotation

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()

    lazy var adressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.alpha = 0.4
        return label
    }()

    lazy var direcionsButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Directions", for: .normal)
        return button
    }()

    lazy var callButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Call", for: .normal)
        return button
    }()

    init(place: PlaceAnnotation) {
        self.place = place
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }

    private func setupUI() {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)

        nameLabel.text = place.name
        adressLabel.text = place.address

        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(adressLabel)

        nameLabel.widthAnchor.constraint(equalToConstant: view.bounds.width - 20).isActive = true

        let contactStackView = UIStackView()
        contactStackView.translatesAutoresizingMaskIntoConstraints = false
        contactStackView.axis = .horizontal
        contactStackView.spacing = UIStackView.spacingUseSystem

        direcionsButton.addTarget(self, action: #selector(directionsButtonTapped), for: .touchUpInside)
        callButton.addTarget(self, action: #selector(callButtonTapped), for: .touchUpInside)

        contactStackView.addArrangedSubview(direcionsButton)
        contactStackView.addArrangedSubview(callButton)

        stackView.addArrangedSubview(contactStackView)

        view.addSubview(stackView)
    }

    @objc private func callButtonTapped() {
        // place.phone = (512)-435-2345
        // what we need = 5124352345
        guard let url = URL(string: "tel://\(place.phone.formatPhoneForCall)") else {
            NSLog("something wrong with phone")
            return
            }
        print(url)

        UIApplication.shared.open(url)
    }

    @objc private func directionsButtonTapped() {
        let coordinate = place.location.coordinate
        guard let url = URL(string: "http://maps.apple.com/?daddr=\(coordinate.latitude),\(coordinate.longitude)") else {
            NSLog("someting wrong with url")
            return
        }

        UIApplication.shared.open(url)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
