//
//  UIViewExtension.swift
//  TesteGitHub
//
//  Created by Victor Rabelo on 12/10/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

enum LayoutError: Error {
    case dontHaveParent
}

extension UIView {
    func toEdges() throws {
        guard let parent = superview else {
            throw LayoutError.dontHaveParent
        }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
    }
}
