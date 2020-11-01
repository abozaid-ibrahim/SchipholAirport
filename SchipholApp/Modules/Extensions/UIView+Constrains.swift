//
//  UIView+Constrains.swift
//
//  Created by abuzeid on 22.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import UIKit
enum Edge {
    case leading
    case trailing
    case top
    case bottom
    case all
}

extension UIView {
    func setConstrainsEqualToParentEdges(top: Float = 0, bottom: Float = 0, leading: Float = 0, trailing: Float = 0) {
        guard let parent = superview else {
            fatalError("This view doesn't have a parent")
        }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: CGFloat(leading)),
            trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -CGFloat(trailing)),
            topAnchor.constraint(equalTo: parent.topAnchor, constant: CGFloat(top)),
            bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -CGFloat(bottom))])
    }

    func setConstrainsEqualToParent(edge: Set<Edge>, with margin: Float = 0) {
        guard let parent = superview else {
            fatalError("This view doesn't have a parent")
        }
        setConstrainsEqualTo(view: parent, edge: edge, with: margin)
    }

  

    func setConstrainsEqualTo(view: UILayoutGuide, edge: Set<Edge>, with margin: Float) {
        translatesAutoresizingMaskIntoConstraints = false
        for edge in edge {
            switch edge {
            case .all:
                setConstrainsEqualToParentEdges(top: margin, bottom: margin, leading: margin, trailing: margin)
            case .leading:
                leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(margin)).isActive = true
            case .trailing:
                trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -CGFloat(margin)).isActive = true
            case .top:
                topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(margin)).isActive = true
            case .bottom:
                bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -CGFloat(margin)).isActive = true
            }
        }
    }
    
    func setConstrainsEqualTo(view: UIView, edge: Set<Edge>, with margin: Float) {
        translatesAutoresizingMaskIntoConstraints = false
        for edge in edge {
            switch edge {
            case .all:
                setConstrainsEqualToParentEdges(top: margin, bottom: margin, leading: margin, trailing: margin)
            case .leading:
                leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(margin)).isActive = true
            case .trailing:
                trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -CGFloat(margin)).isActive = true
            case .top:
                topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(margin)).isActive = true
            case .bottom:
                bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -CGFloat(margin)).isActive = true
            }
        }
    }
    func setConstrainsEqualToSafeArea(edge: Set<Edge>, with margin: Float = 0) {
        guard let parent = superview?.safeAreaLayoutGuide else {
            fatalError("This view doesn't have a parent")
        }
        setConstrainsEqualTo(view: parent, edge: edge, with: margin)
    }
}

