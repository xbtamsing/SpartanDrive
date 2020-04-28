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
    @IBOutlet weak var currentUserLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton! {
        didSet {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleSignOutTapGesture))
            self.signOutButton.addGestureRecognizer(recognizer)
        }
    }
    
    
    private var userEmail: String = "" {
        didSet {
            self.currentUserLabel.text = "Logged in as\n \(self.userEmail)"
        }
    }
    
    // Profile Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentUser()
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
     * Gets the email of the currently signed in User.
     */
    func getCurrentUser() -> Void {
        if let user = Auth.auth().currentUser {
            self.userEmail = user.email!
        }
    }
}
