//
//  AirportDetailsController.swift
//  SchipholApp
//
//  Created by abuzeid on 31.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import UIKit

final class AirportDetailsController: UIViewController {
    private let viewModel: AirportDetailsViewModelType

    init(with viewModel: AirportDetailsViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    private var airport: Airport { viewModel.airport }

    lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        stack.axis = .vertical
        return stack
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .titleFont
        label.accessibilityIdentifier = AccessibilityId.airportNameLabel
        label.text = airport.name
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        return label
    }()

    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = .seconderyFont
        label.text = "\(airport.latitude), \(airport.longitude)"
        return label
    }()

    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = .seconderyFont
        label.text = airport.address
        return label
    }()

    lazy var sperator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()

    lazy var nearstAirportPlaceholder: UILabel = {
        let label = UILabel()
        label.font = .titleFont
        label.text = Str.nearestAirport
        return label
    }()

    lazy var nearstAirportLabel: UILabel = {
        let label = UILabel()
        label.font = .seconderyFont
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.loadData()
        viewModel.nearestAirport.subscribe { [unowned self] text in
            self.nearstAirportLabel.text = text
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

private extension AirportDetailsController {
    func setup() {
        title = airport.id
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemGray6
        } else {
            view.backgroundColor = .white
        }
        view.addSubview(mainStack)
        mainStack.setConstrainsEqualToSafeArea(edge: [.trailing, .leading], with: 12)
        mainStack.setConstrainsEqualToSafeArea(edge: [.top], with: 24)
        mainStack.addArrangedSubview(nameLabel)
        mainStack.addArrangedSubview(addressLabel)
        mainStack.addArrangedSubview(locationLabel)
        mainStack.addArrangedSubview(sperator)
        mainStack.addArrangedSubview(nearstAirportPlaceholder)
        mainStack.addArrangedSubview(nearstAirportLabel)
    }
}

extension UIFont {
    static var titleFont: UIFont { UIFont.boldSystemFont(ofSize: 18) }
    static var seconderyFont: UIFont { UIFont.systemFont(ofSize: 16) }
}
