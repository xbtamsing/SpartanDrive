//
//  AppHomeNav.swift
//  SpartanDrive
//
//  Created by Brian Tamsing on 4/27/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import UIKit

class AppHomeNav: UINavigationController {
    
    // Home Properties
    
    // Home Methods
    /**
    * Prepares the View elements as the app is loaded into memory.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        setFontSize()
    }
    
    /**
     * Sets the font size for the Tab Bar items.
     */
    func setFontSize() {
        let fontSize = UIFont.systemFont(ofSize: 20)
        self.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: fontSize], for: .normal)
    }
}
