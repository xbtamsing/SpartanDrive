//
//  Folder.swift
//  SpartanDrive
//
//  Created by Brian Tamsing on 5/3/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import UIKit

/**
 * Represents a Folder.
 */
class Folder {
    
    // Folder Properties
    public var icon: UIImage
    public var name: String
    lazy public var files: [File] = [File]()
    
    
    // Initialization
    init(icon: UIImage, name: String) {
        self.icon = icon
        self.name = name
    }
    
    
    // Folder Methods
    
}
