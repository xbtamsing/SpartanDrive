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
 * Represents a UITableViewCell tailored to represent a File.
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
        configureImageView()
        configureLabels(label: self.titleFromName)
        
        // constraining views...
        setImageConstraints()
        setNameLabelConstraints(name: self.titleFromName)
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
    
    
    /**
     * Configures the FileCell's ImageView.
     */
    func configureImageView() {
        self.fileImageView.layer.cornerRadius = 10
        self.fileImageView.clipsToBounds = true
    }
    
    
    /**
    * Configures the FileCell's UILabels.
    */
    func configureLabels(label: UILabel) {
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
    }
    
    
    /**
     * Sets the constraints of this FileCell's ImageView.
     */
    func setImageConstraints() {
        self.fileImageView.translatesAutoresizingMaskIntoConstraints                                                    = false
        self.fileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive                                    = true
        self.fileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive                      = true
        self.fileImageView.heightAnchor.constraint(equalToConstant: 60).isActive                                        = true
        self.fileImageView.widthAnchor.constraint(equalTo: self.fileImageView.heightAnchor).isActive                    = true
    }
    
    
    /**
    * Sets the constraints for this FileCell's file name UILabel.
    */
    func setNameLabelConstraints(name: UILabel) {
        self.titleFromName.translatesAutoresizingMaskIntoConstraints                                                    = false
        self.titleFromName.centerYAnchor.constraint(equalTo: centerYAnchor).isActive                                    = true
        self.titleFromName.leadingAnchor.constraint(equalTo: self.fileImageView.trailingAnchor, constant: 20).isActive  = true
        self.titleFromName.heightAnchor.constraint(equalToConstant: 40).isActive                                        = true
        self.titleFromName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive                   = true
    }
    
}

