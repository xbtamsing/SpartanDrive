//
//  User.swift
//  SpartanDrive
//
//  Created by Brian Tamsing on 4/2/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import Foundation

/**
 * Represents a User within SpartanDrive.
 */
class User {
    
    // User Properties
    var uid: String = ""
    var email: String? = ""
    
    // User Initialization
    init(uid: String, email: String?) {
        self.uid = uid
        self.email = email
    }
}
