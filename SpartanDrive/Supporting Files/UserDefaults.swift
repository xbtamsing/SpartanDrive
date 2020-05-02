//
//  UserDefaults.swift
//  SpartanDrive
//
//  Created by Brian Tamsing on 4/26/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    // Methods
    /**
     * Maintains the logged in status of a User in SpartanDrive.
     */
    func loggedIn() -> Void {
        set(true, forKey: UserStatusKeys.isLoggedIn.rawValue)
    }
    
    
    /**
     * Maintains the logged out status of a User in SpartanDrive.
     */
    func signedOut() -> Void {
        set(false, forKey: UserStatusKeys.isLoggedIn.rawValue)
    }
    
    
    /**
     * Returns the logged in/logged out status of the current User.
     */
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaults.UserStatusKeys.isLoggedIn.rawValue)
    }
    
    
    // Enumeration extension
    /**
     * Adds a new key for UserDefaults.
     */
    enum UserStatusKeys: String {
        case isLoggedIn
    }
    
}
