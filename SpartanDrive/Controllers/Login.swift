//
//  Login.swift
//  SpartanDrive
//
//  Created by Brian Tamsing on 4/26/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class Login: UIViewController, UITextFieldDelegate {
    
    // Login Properties --------------------------------------------------------------------------------------------------
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
<<<<<<< HEAD
    @IBOutlet weak var showHidePasswordButton: UIButton!
=======
>>>>>>> 2d9c4c06a28224f0baf6217d60792cca21be5408
    @IBOutlet weak var login: UIButton! {
        didSet {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleLoginTapGesture))
            login.addGestureRecognizer(recognizer)
        }
    }
    
    @IBOutlet var tappableView: UIView! {
        didSet {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleScreenTapGesture))
            tappableView.addGestureRecognizer(recognizer)
        }
    }
    
    @IBOutlet weak var googleSignInButton: GIDSignInButton! {
        didSet {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleGoogleSignInTapGesture))
            googleSignInButton.addGestureRecognizer(recognizer)
            googleSignInButton.style = .iconOnly
            googleSignInButton.colorScheme = .dark
            
        }
    }
    
    private var userEmail: String = ""
    private var userPassword: String = ""
    
    private var error: Bool = false
    public var isLoggedIn: Bool = false
    
    public var spartanUser: User?
    private var handle: AuthStateDidChangeListenerHandle?
    
    
    // Login Methods
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
    * Prepares the View elements as the app is loaded into memory.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        configureTextFields()
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    
    /**
     * Sets the Login class to be the delegate of the GIDSignIn shared instance.
     *
     * This will cause the Login class' signIn extension method to get fired.
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GIDSignIn.sharedInstance().delegate = self
    }
    
    
    /**
     * Logs in a registered SpartanDrive User with Firebase.
     */
    func login(
        email: String,
        password: String,
        loginHandler: @escaping AuthDataResultCallback
    ){
        Auth.auth().signIn(withEmail: email, password: password, completion: loginHandler)
    }
     
    
    /**
     * Assigns the UITextFieldDelegates to the Login View's text fields.
     *
     * This will be used for text field validation later.
     */
    func configureTextFields() {
        let emailPadding = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        let passwordPadding = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        
        self.email.delegate = self
        self.email.leftView = emailPadding
        self.email.leftViewMode = UITextField.ViewMode.always
        self.email.becomeFirstResponder()
        
        self.password.delegate = self
        self.password.leftView = passwordPadding
        self.password.leftViewMode = UITextField.ViewMode.always
        self.password.isSecureTextEntry = true
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
     * Assigns the field value to either the user email or password properties aftewards.
     */
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.email {
            self.userEmail = textField.text!
        }
        else if textField == self.password {
            self.userPassword = textField.text!
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
        }
    }
    
<<<<<<< HEAD
    @IBAction func handleShowHidePasswordTapGesture(_ sender: Any) {
        self.password.isSecureTextEntry = !self.password.isSecureTextEntry
        self.showHidePasswordButton.setTitle(self.password.isSecureTextEntry ? "Show Password" : "Hide Password", for: .normal)
    }
=======
>>>>>>> 2d9c4c06a28224f0baf6217d60792cca21be5408
    
    /**
     * Handles a tap gesture on the "Login" button.
     */
    @objc func handleLoginTapGesture() {
        if self.login.gestureRecognizers![0].state
            == .ended {
            if self.email.isFirstResponder {
                self.email.resignFirstResponder()
            }
            else if self.password.isFirstResponder {
                self.password.resignFirstResponder()
            }
        }
        
        // this code below contains the login method call
        if self.userEmail != "" && self.userPassword != "" {
            self.login(email: self.userEmail, password: self.userPassword, loginHandler: { (result, error) in
                if error != nil {
                    self.error = true
                }
                else {
                    self.isLoggedIn = true
                    UserDefaults.standard.loggedIn()
                    self.presentHomeView()
                }
            })
        }
    }
    
    
    /**
     * Presents SpartanDrive's Home view to the User.
     */
    func presentHomeView() {
        // upon a successful login, go to the app's homepage.
        guard let destinationViewController = self.storyboard?.instantiateViewController(withIdentifier: "AppHomeNavigationViewController") as? AppHomeNav else { return }
        destinationViewController.modalPresentationStyle = .fullScreen
        self.present(destinationViewController, animated: true, completion: nil)
    }
    
    
    /**
       * Handles a tap gesture on the Google "Sign In" button.
       */
      @objc func handleGoogleSignInTapGesture() {
          if self.googleSignInButton.gestureRecognizers![0].state
              == .ended {
                GIDSignIn.sharedInstance().signIn()
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

extension Login: GIDSignInDelegate {
    // Google Sign In
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
          print(error)
          return
        }

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        
        // present User Home on a successful login
        Auth.auth().signIn(with: credential, completion: { (authResult, error) in
            if let error = error {
                print(error)
            } else {
                UserDefaults.standard.loggedIn()
                self.presentHomeView()
            }
        })
    }
    
}
