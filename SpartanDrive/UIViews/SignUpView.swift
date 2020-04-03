//
//  SignUpView.swift
//  SpartanDrive
//
//  Created by Brian Tamsing on 4/1/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    
    // Sign Up State Properties
    // standard
    @State private var userEmail: String = ""
    @State private var userPassword: String = ""
    @State private var userConfirmedPassword: String = ""
    
    // for "confirm password" validation
    @State private var passwordsMatch: Bool = false
    @State private var matchingPasswordsCheck: Bool = false
    
    // to compensate for swiftui placeholder defect (does not restore placeholder text on button commit)
    @State private var refresh: Bool = false
    
    // for "session.signUp" validation
    @State private var error: Bool = false
    @State private var loading: Bool = false
    
    // miscellaneous
    @State private var formOffset: CGFloat = 0
    @Binding var displaySignUpSheet: Bool
    
    // Environment Variable
    @EnvironmentObject var session: Authentication
    
    
    // Main Sign Up View
    var body: some View {
        return VStack(spacing: 55) {
            // header information
            Image("SpartanSpirit_web")
                .resizable()
                .frame(width: 75, height: 75)
            Text("Sign Up")
                .font(.title).bold()
            
            // email, password, and a confirmed password vertical stack.
            VStack {
                SDTextField(fieldValue: self.$userEmail, placeholder: "Email" + (self.refresh ? "" : " "), isSecure: false, onEditingChanged: {
                    flag in withAnimation() {
                        self.formOffset = flag ? -150 : 0
                    }
                    })
                SDTextField(fieldValue: self.$userPassword, placeholder: "Password" + (self.refresh ? "" : " "), isSecure: true)
                SDTextField(fieldValue: self.$userConfirmedPassword, placeholder: "Confirm Password" + (self.refresh ? "" : " "), isSecure: true)
                HStack {
                    Button(action: { self.signUp() }) {
                        Text("Sign Up")
                            .fixedSize()
                            .frame(width: 250, height: 45)
                    }
                        .padding()
                        .fixedSize()
                        .frame(height: 30)
                        .foregroundColor(Color.init(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                        .background(Color.init(#colorLiteral(red: 0, green: 0.3333333333, blue: 0.6352941176, alpha: 0.7473512414)))
                        .cornerRadius(20)
                }
                    .padding(10)
                
                // presents the status of a successful, or unsuccessful, sign up to the application User.
                if !self.passwordsMatch && self.matchingPasswordsCheck {
                    VStack(spacing: 25) {
                        Text("Passwords do not match. Please try again.")
                            .foregroundColor(Color.init(#colorLiteral(red: 0.6264649224, green: 0, blue: 0, alpha: 1)))
                            .lineSpacing(5)
                    }
                }
                else if self.passwordsMatch && self.matchingPasswordsCheck {
                    VStack(spacing: 25) {
                        Text("Account creation successful.")
                            .foregroundColor(Color.init(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                            .lineSpacing(5)
                        }
                }
            }
            
            // will dismiss the current sign up sheet view
            Button(action: {
                self.displaySignUpSheet.toggle()
                
            }) {
                HStack {
                    Text("Already have an account?").accentColor(Color.init(#colorLiteral(red: 0.8980392157, green: 0.6588235294, blue: 0.137254902, alpha: 1)))
                }
            }
           
        }
    }
    
    
    // Sign Up View Methods
    func signUp(){
        if self.userPassword == self.userConfirmedPassword && self.userPassword != "" && self.userConfirmedPassword != "" {
            self.passwordsMatch = true
            self.session.signUp(email: self.userEmail, password: self.userPassword, handler: {
            (result, error) in
                self.loading = false
                if error != nil {
                    self.error = true
                }
                else {
                    self.userEmail = ""
                    self.userPassword = ""
                    self.userConfirmedPassword = ""
                    self.refresh.toggle()
                }
            })
        }
        self.matchingPasswordsCheck = true
    }
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(displaySignUpSheet: .constant(false))
            .environmentObject(Authentication())
    }
}
