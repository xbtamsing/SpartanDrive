//
//  AppHomeTabBar.swift
//  SpartanDrive
//
//  Created by Brian Tamsing on 4/27/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import UIKit

class AppHomeTabBar: UITabBarController {
    
    // Application Home Properties
    @IBOutlet weak var tab: UITabBar!
    
    
    // Application Home Methods
    /**
    * Prepares the View elements as the app is loaded into memory.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarStyling()
    }
    
    
    /**
     * Sets the styling for the Application Home's Tab Bar.
     */
    func setTabBarStyling() {
        self.tab.tintColor = #colorLiteral(red: 0.8980392157, green: 0.6588235294, blue: 0.137254902, alpha: 1)
    }
    
}
