//
//  FileDescription.swift
//  SpartanDrive
//
//  Created by Brian Tamsing on 5/2/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import UIKit

/**
 * Manages a User's File/Folder description.
 */
class FileDescription: UIViewController {
    
    // FileDescription Propeties
    @IBOutlet weak var fileDescriptionField: UITextView!
    public var name: String!
    public var check: Bool! = false
    private var savedDescription: String! = String()
    @IBOutlet var tappableView: UIView! {
        didSet {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleViewTapGesture))
            tappableView.addGestureRecognizer(recognizer)
        }
    }
    @IBOutlet weak var saveFileDescription: UIButton! {
        didSet {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleSaveFileDescriptionTapGesture))
            saveFileDescription.addGestureRecognizer(recognizer)
        }
    }
    
    
    // FileDescription Methods
    /**
     * Prepares View elements as the app is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureSaveButton()
        self.fileDescriptionField.delegate = self
        
        // a practical solution for now, at least.
        if UserDefaults.standard.bool(forKey: "\(String(describing: self.name)) has changed desc") {
            self.fileDescriptionField.text = UserDefaults.standard.value(forKey: (self.name)) as? String
        }
        else {
            self.fileDescriptionField.text = "Enter a file description here."
        }
    }
    
    
    /**
     * Configures this Save File Description Button.
     */
    func configureSaveButton() {
        self.saveFileDescription.showsTouchWhenHighlighted = true
    }
    
    
    /**
     * Handles a View tap gesture by having the fileDescriptionField resign its First Responder status.
     */
    @objc func handleViewTapGesture() {
        if self.tappableView.gestureRecognizers![0].state
            == .ended {
            self.fileDescriptionField.resignFirstResponder()
        }
    }
    
    
    /**
     * Handles a tap gesture on the Save File Description Button by having the description saved to UserDefaults.
     */
    @objc func handleSaveFileDescriptionTapGesture() {
        if self.saveFileDescription.gestureRecognizers![0].state
            == .ended {
            self.fileDescriptionField.resignFirstResponder()
            // save the user's file description to UserDefaults.
            UserDefaults.standard.set(self.savedDescription, forKey: self.name)
            UserDefaults.standard.set(true, forKey: "\(String(describing: self.name)) has changed desc")
        }
    }
}

extension FileDescription: UITextViewDelegate {
    
    /**
     * Called when the fileDescriptionField resigns its First Responder status.
     */
    func textViewDidEndEditing(_ textView: UITextView) {
        self.savedDescription = textView.text
    }
}
