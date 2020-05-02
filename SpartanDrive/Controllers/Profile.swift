//
//  Profile.swift
//  SpartanDrive
//
//  Created by Brian Tamsing on 4/27/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import UIKit
import Firebase

class Profile: UIViewController {
    
    // Profile Properties
    public var currentUser: UserProfile!
    @IBOutlet weak var currentUserLabel: UILabel!
    @IBOutlet weak var filesOwned: UILabel!
    @IBOutlet weak var foldersOwned: UILabel!
    @IBOutlet weak var totalStorageUsed: UILabel!
    
    
    @IBOutlet weak var signOutButton: UIButton! {
        didSet {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleSignOutTapGesture))
            self.signOutButton.addGestureRecognizer(recognizer)
        }
    }
    
    
    // Profile Methods
    /**
    * Prepares the View elements as the app is loaded into memory.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUserInfo()
        title = "Profile"
    }
    
    
    /**
     * Handles the User tapping the "Sign Out" button.
     */
    @objc func handleSignOutTapGesture() {
        if self.signOutButton.gestureRecognizers![0].state
            == .ended {
            self.signOut()
            UserDefaults.standard.signedOut()
            
            guard let destinationViewController = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeNavController") as?
                WelcomeNavController else { return }
            destinationViewController.modalPresentationStyle = .fullScreen
            present(destinationViewController, animated: true, completion: nil)
            
        }
    }
    
    
    /**
     * Signs out the currently active User using Firebase.
     */
    func signOut() {
        do {
            try Auth.auth().signOut()
        }
        catch {
            return
        }
    }
    
    
    /**
     * Sets the information needed for the User's Usage Report.
     */
    func setUserInfo() {
        self.currentUser.userEmail = self.getCurrentUser()
        self.currentUserLabel.text = "Logged in as \(self.currentUser.userEmail)"
        self.filesOwned.text = "Files Owned: \(self.currentUser.filesOwned)"
        let totalStorage: Int64 = {
            var total: Int64 = 0
            for file in 0..<self.currentUser.storageUsed.count {
                total += self.currentUser.storageUsed[file]
            }
            return total
        }()
        self.totalStorageUsed.text = "Total Storage Space Used: \(totalStorage) bytes"
        
    }
    
    
    /**
     * Gets the email of the currently signed in User.
     */
    func getCurrentUser() -> String {
        if let user = Auth.auth().currentUser {
            return user.email!
        }
        return ""
    }
    
}
