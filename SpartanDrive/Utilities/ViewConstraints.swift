//
//  ViewConstraints.swift
//  SpartanDrive
//
//  Created by Brian Tamsing on 4/30/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import UIKit

/**
 * Contains a set of constraints that will be used for the BaseAppHome's UITableView.
 */
extension UIView {
    
    // Methods
    /**
     * Sets the constraints for the input View by pinning it to the sides of the Storyboard.
     */
    func pin(to superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
    }
}
