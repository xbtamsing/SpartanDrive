//
//  Authentication.swift
//  SpartanDrive
//
//  Created by Brian Tamsing on 4/2/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import Foundation

import SwiftUI
import Firebase
import FirebaseAuth
import Combine

/**
 * A class that handles User authentication via Firebase.
 */
class Authentication: ObservableObject {
    
    // Authentication Properties...
    @Published var session: User?
    var handle: AuthStateDidChangeListenerHandle?
    
    
    // Authentication Methods...
    /**
     * Begins monitoring User authentication through Firebase.
     */
    func listen() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                    self.session = User(uid: user.uid, email: user.email)
            }
            else {
                    self.session = nil
            }
        }
    }

    /**
     * Registers a new User.
     */
    func signUp(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
    ){
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    /**
     * Signs in an authenticated User.
     */
    func signIn(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
    ){
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    /**
     * Signs out a User.
     */
    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            self.session = nil
            return true
        }
        catch {
            return false
        }
    }
    
    /**
     * Cancels User authentication monitoring.
     */
    func dismount() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
}
