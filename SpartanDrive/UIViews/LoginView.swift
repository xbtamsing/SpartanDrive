//
//  LoginView.swift
//  SpartanDrive
//
//  Created by Brian Tamsing on 3/27/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    // Login State Properties
    @State private var userEmail: String = ""
    @State private var userPassword: String = ""
    @State private var displaySignUpSheet: Bool = false
    @State private var displayPasswordRecoverySheet: Bool = false
    @State private var formOffset: CGFloat = 0
    
    // Environment Object, a.k.a. an application wide State property
    @EnvironmentObject var session: Authentication
    
    
    // Main Login View
    var body: some View {
        VStack(spacing: 40) {
            // header information
            Image("SpartanSpirit_web")
                .resizable()
                .frame(width: 75, height: 75)
            Text("Login")
                .font(.title).bold()
            
            // email and password vertical stack
            VStack {
                SDTextField(fieldValue: self.$userEmail, placeholder: "Email", isSecure: false, onEditingChanged: { flag in
                    withAnimation {
                        self.formOffset = flag ? -150 : 0
                    }
                })
                SDTextField(fieldValue: self.$userPassword, placeholder: "Password", isSecure: true)
                HStack {
                    Button(action: {}) {
                         Text("Login")
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
            }
            
            // sign up imperative that will modally present a new sheet within the view to sign up for an account.
            Button(action: { self.displaySignUpSheet.toggle() }) {
                HStack {
                    Text("Don't have an account yet? Sign up!").accentColor(Color.init(#colorLiteral(red: 0.8980392157, green: 0.6588235294, blue: 0.137254902, alpha: 1)))
                }
            }.sheet(isPresented: self.$displaySignUpSheet) {
                SignUpView(displaySignUpSheet: self.$displaySignUpSheet)
                    .environmentObject(Authentication())
            }
            
            // recover password imperative that will modally present a new sheet within the view to recover your password.
            Button(action: { self.displayPasswordRecoverySheet.toggle() }) {
                HStack {
                    Text("Forgot your password?").accentColor(Color.init(#colorLiteral(red: 0, green: 0.3333333333, blue: 0.6352941176, alpha: 1)))
                }.sheet(isPresented: self.$displayPasswordRecoverySheet) {
                    PasswordRecoveryView(displayPasswordRecoverySheet: self.$displayPasswordRecoverySheet)
                        .environmentObject(Authentication())
                }
            }
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(Authentication())
    }
}
