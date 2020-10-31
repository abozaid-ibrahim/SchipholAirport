//
//  ActivityIndicatorFooter.swift
//  ContactList
//
//  Created by abuzeid on 01.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit

final class ActivityIndicatorFooterView: UIView {
    private var activityView: UIActivityIndicatorView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    static var identifier: String {
        return String(describing: self)
    }

    func set(isLoading: Bool) {
        isLoading ? activityView.startAnimating() : activityView.stopAnimating()
    }

    private func setup() {
        if #available(iOS 13, *) {
            activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        } else {
            activityView = UIActivityIndicatorView(style: .gray)
        }
        activityView.hidesWhenStopped = true
        activityView.startAnimating()
        addSubview(activityView)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            activityView.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityView.centerXAnchor.constraint(equalTo: centerXAnchor)])
    }
}
