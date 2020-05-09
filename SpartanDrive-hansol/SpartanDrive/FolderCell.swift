//
//  FolderCell.swift
//  SpartanDrive
//
//  Created by Brian Tamsing on 5/3/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import UIKit

/**
 * Represents a UITableViewCell tailored to emulate a Folder.
 */
class FolderCell: UITableViewCell {
    
    // FolderCell Properties
    public var folderImageView = UIImageView()
    public var titleFromName = UILabel()
    
    
    // Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // adding views...
        addSubview(folderImageView)
        addSubview(titleFromName)
        
        // configuring views...
        configureLabels(label: self.titleFromName)
        
        // constraining views...
        setImageConstraints(image: self.folderImageView)
        setLabelConstraints(label: self.titleFromName, image: self.folderImageView)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // FolderCell Methods
    /**
     * Sets this FolderCell's information to the information contained within the input Folder.
     */
    func setFolderProperties(folder: Folder) {
        self.folderImageView.image = folder.icon
        self.titleFromName.text = folder.name
    }
    
}
