//
//  SignUp.swift
//  SpartanDrive
//
//  Created by Brian Tamsing on 4/25/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import UIKit
import Firebase

class SignUp: UIViewController, UITextFieldDelegate {
    
    // SignUp Properties
    @IBOutlet private weak var email: UITextField!
    @IBOutlet private weak var password: UITextField!
    @IBOutlet private weak var confirmPassword: UITextField!
    @IBOutlet private weak var signUp: UIButton! {
        didSet {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleSignUpTapGesture))
            signUp.addGestureRecognizer(recognizer)
        }
    }
    
    
    @IBOutlet weak var tappableView: UIView! {
        didSet {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleScreenTapGesture))
            tappableView.addGestureRecognizer(recognizer)
        }
    }
    
    private var userEmail: String = ""
    private var userPassword: String = ""
    private var userConfirmedPassword: String = ""
    
    private var error: Bool = false
    
    public var spartanUser: User?
    private var handle: AuthStateDidChangeListenerHandle?
    
    
    // SignUp Methods
    /**
     * Begins monitoring User authentication through Firebase.
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.spartanUser = User(uid: user.uid, email: user.email)
            }
            else {
                self.spartanUser = nil
            }
        }
    }
    
    /**
     * Prepares view elements.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign Up"
        configureTextFields()
    }
    
    /**
     * Registers a new SpartanDrive User with Firebase.
     */
    func signUp(
        email: String,
        password: String,
        signUpHandler: @escaping AuthDataResultCallback
    ){
        Auth.auth().createUser(withEmail: email, password: password, completion: signUpHandler)
    }
    
    /**
     * Assigns the UITextFieldDelegates to the SignUp View's input text fields.
     *
     * This will be used for text field validation later.
     */
    func configureTextFields() {
        let emailPadding = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        let passwordPadding = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        let confirmPasswordPadding = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        
        self.email.delegate = self
        self.email.leftView = emailPadding
        self.email.leftViewMode = UITextField.ViewMode.always
        self.email.becomeFirstResponder()
        
        self.password.delegate = self
        self.password.leftView = passwordPadding
        self.password.leftViewMode = UITextField.ViewMode.always
        self.password.isSecureTextEntry = true
        
        self.confirmPassword.delegate = self
        self.confirmPassword.leftView = confirmPasswordPadding
        self.confirmPassword.leftViewMode = UITextField.ViewMode.always
        self.confirmPassword.isSecureTextEntry = true
    }
    
    /**
     * Called after a text field becomes the First Responder.
     */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.tintColor = #colorLiteral(red: 0, green: 0.3333333333, blue: 0.6352941176, alpha: 1)
        textField.layer.borderColor = #colorLiteral(red: 0, green: 0.3333333333, blue: 0.6352941176, alpha: 1)
    }
    
    /**
     * Called after a text field resigns its First Responder Status.
     *
     * Assigns the field value to either the user email, password, or password confirmation properties aftewards.
     */
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.email {
            self.userEmail = textField.text!
        }
        else if textField == self.password {
            self.userPassword = textField.text!
        }
        else if textField == self.confirmPassword {
            self.userConfirmedPassword = textField.text!
        }
        
        textField.layer.borderWidth = 0
        textField.layer.borderColor = nil
    }
    
    /**
     * Handles a tap gesture occuring within this View.
     */
    @objc func handleScreenTapGesture() {
        if self.tappableView.gestureRecognizers![0].state
            == .ended {
            if self.email.isFirstResponder {
                self.email.resignFirstResponder()
            }
            else if self.password.isFirstResponder {
                self.password.resignFirstResponder()
            }
            else if self.confirmPassword.isFirstResponder {
                self.confirmPassword.resignFirstResponder()
            }
        }
    }
    
    /**
     * Handles a tap gesture on the "Sign Up" button.
     */
    @objc func handleSignUpTapGesture() {
        if self.signUp.gestureRecognizers![0].state
            == .ended {
            if self.email.isFirstResponder {
                self.email.resignFirstResponder()
            }
            else if self.password.isFirstResponder {
                self.password.resignFirstResponder()
            }
            else if self.confirmPassword.isFirstResponder {
                self.confirmPassword.resignFirstResponder()
            }
        }
        
        // this code below contains the signUp method call
        if self.userEmail != "" && self.userPassword != ""
            && self.userConfirmedPassword != "" {
            if self.userPassword == self.userConfirmedPassword {
                self.signUp(email: self.userEmail, password: self.userPassword, signUpHandler: { (result, error) in
                    if error != nil {
                        self.error = true
                    }
                })
            }
        }
    }
    
    /**
     * Dismounts the Firebase Object's State Listener.
     */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(self.handle!)
    }
    
}
