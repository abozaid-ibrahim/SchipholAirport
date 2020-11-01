//
//  AirportDetailsController.swift
//  SchipholApp
//
//  Created by abuzeid on 31.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import UIKit

final class AirportDetailsController: UIViewController {
    private let viewModel: AirportDetailsViewModel

    init(with viewModel: AirportDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var airport: Airport { viewModel.airport }

    lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .top
        stack.spacing = 8
        stack.axis = .vertical
        return stack
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .titleFont
        label.text = airport.name
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

    lazy var nearstAirportPlaceholder: UILabel = {
        let label = UILabel()
        label.font = .titleFont
        label.text = "Nearest Airport"
        return label
    }()

    lazy var nearstAirportLabel: UILabel = {
        let label = UILabel()
        label.font = .seconderyFont
        label.text = self.viewModel.nearestAirport
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
        view.backgroundColor = .white
        view.addSubview(mainStack)
        mainStack.setConstrainsEqualToSafeArea(edge: [.top, .trailing, .leading], with: 12)
        mainStack.addArrangedSubview(nameLabel)
        mainStack.addArrangedSubview(addressLabel)
        mainStack.addArrangedSubview(locationLabel)
        mainStack.addArrangedSubview(nearstAirportPlaceholder)
        mainStack.addArrangedSubview(nearstAirportLabel)
    }
}

extension UIFont {
    static var titleFont: UIFont { UIFont.systemFont(ofSize: 24) }
    static var seconderyFont: UIFont { UIFont.systemFont(ofSize: 16) }
}
