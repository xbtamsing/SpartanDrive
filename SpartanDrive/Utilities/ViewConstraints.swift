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
    
    /**
     * Sets the constraints for a UITableCell's ImageView.
     */
    func setImageConstraints(image: UIImageView) {
        image.translatesAutoresizingMaskIntoConstraints                                                    = false
        image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive                                    = true
        image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive                      = true
        image.heightAnchor.constraint(equalToConstant: 55).isActive                                        = true
        image.widthAnchor.constraint(equalTo: image.heightAnchor).isActive                                 = true
    }
    
    /**
     * Sets the constraints for a UITableCell's UILabel.
     */
    func setLabelConstraints(label: UILabel, image: UIImageView) {
        label.translatesAutoresizingMaskIntoConstraints                                                    = false
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive                                    = true
        label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20).isActive               = true
        label.heightAnchor.constraint(equalToConstant: 40).isActive                                        = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive                   = true
    }
    
    /**
    * Configures a UITableCell's UILabel.
    */
    func configureLabels(label: UILabel) {
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
    }
    
}
