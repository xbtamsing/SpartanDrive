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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tab.tintColor = .black
    }
}
