//
//  BaseAppHome.swift
//  SpartanDrive
//
//  Created by Brian Tamsing on 4/27/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import Foundation
import UIKit

class BaseAppHome: UIViewController {
    
    // BaseAppHome Properties
    private var userProfileButton: UIButton! = UIButton(type: .system)
    // BaseAppHome Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureLeftNavigationButton()
        title = "Home"
    }
    
    func configureLeftNavigationButton() {
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.black
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleProfileTapGesture))
        self.userProfileButton.addGestureRecognizer(recognizer)
        
        let configurationSize = UIImage.SymbolConfiguration(pointSize: 21, weight: .regular, scale: .large)
        let profileButtonImage = UIImage(systemName: "person.circle", withConfiguration: configurationSize)
        
        self.userProfileButton.setImage(profileButtonImage, for: .normal)
        self.userProfileButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        self.userProfileButton.tintColor = UIColor.black
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: userProfileButton)
    }
    
    @objc func handleProfileTapGesture() {
        performSegue(withIdentifier: "showProfile", sender: self)
    }
}
