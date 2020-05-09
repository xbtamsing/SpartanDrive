//
//  FileCell.swift
//  SpartanDrive
//
//  Created by Brian Tamsing on 4/30/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import Foundation
import UIKit

/**
 * Represents a UITableViewCell tailored to emulate a File.
 */
class FileCell: UITableViewCell {
    
    // FileCell properties
    public var fileImageView = UIImageView()
    public var titleFromName = UILabel()
    
    
    // Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // adding views...
        addSubview(fileImageView)
        addSubview(titleFromName)
        
        // configuring views...
        configureLabels(label: self.titleFromName)
        
        // constraining views...
        setImageConstraints(image: self.fileImageView)
        setLabelConstraints(label: self.titleFromName, image: self.fileImageView)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // FileCell Methods
    /**
     * Sets this FileCell's information to the information contained within the input File.
     */
    func setFileProperties(file: File) {
        self.fileImageView.image = file.icon
        self.titleFromName.text = file.name
    }
    
}

