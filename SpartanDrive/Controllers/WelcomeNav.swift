//
//  WelcomeNav.swift
//  SpartanDrive
//
//  Created by Brian Tamsing on 4/27/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import UIKit

class WelcomeNav: UIViewController {
    
    // WelcomeNav Properties
    // ...
    
    // WelcomeNav Methods
    /**
    * Prepares the View elements as the app is loaded into memory.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLeftNavigationButton()
        title = ""
    }
    
    
    func configureLeftNavigationButton() {
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.black
    }
}
