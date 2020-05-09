<<<<<<< HEAD
=======
//
//  File.swift
//  SpartanDrive
//
//  Created by Brian Tamsing on 4/29/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

>>>>>>> 68ff8320d4f01097fbb7c506dac314760266eef0
import UIKit

/**
 * Represents a File.
 */
class File {
    
    // File Properties
    public var icon: UIImage
    public var name: String
    public var size: String
<<<<<<< HEAD
    public var sizeInBytes: Int
    public var fullPath: String
=======
>>>>>>> 68ff8320d4f01097fbb7c506dac314760266eef0
    lazy public var description: String! = String()
    public var isShared: Bool? = false
    public var sharedWith: String?
    
    // Initialization
<<<<<<< HEAD
    init(icon: UIImage, name: String, size: String, sizeInBytes: Int, fullPath: String) {
        self.icon = icon
        self.name = name
        self.size = size
        self.sizeInBytes = sizeInBytes
        self.fullPath = fullPath
=======
    init(icon: UIImage, name: String, size: String) {
        self.icon = icon
        self.name = name
        self.size = size
>>>>>>> 68ff8320d4f01097fbb7c506dac314760266eef0
    }
    
}
