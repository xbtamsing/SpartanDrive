//
//  FileStorage.swift
//  SpartanDrive
//
//  Created by Brian Tamsing on 4/28/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

/**
 * Manages file references for uploads to Firebase Storage.
 */
class FileStorage {
    
    // FileStorage Properties
    public var storage: Storage
    public var storageRef: StorageReference
    public var localFileURL: URL?
    public var lastPathComponent: String?
    
    
    // Initialization
    init() {
        self.storage = Storage.storage()
        self.storageRef = self.storage.reference()
        self.localFileURL = nil
        self.lastPathComponent = nil
    }
    
    
    // File Storage Methods
    /**
    * Sets the local file's URL path and subsequently its last path component.
    */
    func setLocalFileUrl(_ url: URL) {
        self.localFileURL = url
        self.setLastPathComponent(self.localFileURL!.lastPathComponent)
    }
    
    
    /**
    * Sets the local file's last component path  from the URL
    */
    func setLastPathComponent(_ lastPath: String) {
        self.lastPathComponent = lastPath
    }
}
