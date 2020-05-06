//
//  File.swift
//  SpartanDrive
//
//  Created by Brian Tamsing on 4/29/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import UIKit

/**
 * Represents a File.
 */
class File {
    
    // File Properties
    public var icon: UIImage
    public var name: String
    public var size: String
    lazy public var description: String! = String()
    public var isShared: Bool? = false
    public var sharedWith: String?
    
    // Initialization
    init(icon: UIImage, name: String, size: String) {
        self.icon = icon
        self.name = name
        self.size = size
    }
    
}
