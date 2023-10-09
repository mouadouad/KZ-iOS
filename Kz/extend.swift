//
//  extend.swift
//  Kz
//
//  Created by mouad ouad on 29/03/2020.
//  Copyright © 2020 mouad ouad. All rights reserved.
//

import UIKit
import Foundation

extension UIView {
    func pinEdges(to other: UIView) {
        leadingAnchor.constraint(equalTo: other.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: other.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: other.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: other.bottomAnchor).isActive = true
    }

}


