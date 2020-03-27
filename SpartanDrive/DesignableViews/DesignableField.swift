//
//  DesignableField.swift
//  SpartanDrive
//
//  Created by Brian Tamsing on 3/26/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableField: UIView {
    // Properties
    @IBInspectable var bottomBorder: CALayer = CALayer() {
        didSet {
            
        }
    }
}
