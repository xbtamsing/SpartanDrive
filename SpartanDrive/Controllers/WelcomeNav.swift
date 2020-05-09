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
<<<<<<< HEAD
        self.navigationItem.backBarButtonItem?.tintColor = UIColor { tc in
            switch tc.userInterfaceStyle {
            case .dark:
                return UIColor.white
            default:
                return UIColor.black
            }
        }
=======
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.black
>>>>>>> 68ff8320d4f01097fbb7c506dac314760266eef0
    }
}
