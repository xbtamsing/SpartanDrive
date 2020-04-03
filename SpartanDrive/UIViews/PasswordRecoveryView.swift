//
//  PasswordRecoveryView.swift
//  SpartanDrive
//
//  Created by Brian Tamsing on 4/1/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import SwiftUI

struct PasswordRecoveryView: View {
    
    // Password Recovery Properties
    @State private var userRegistrationEmail: String = ""
    @Binding var displayPasswordRecoverySheet: Bool
    
    // Environment Object
    @EnvironmentObject var session: Authentication
    
    
    // Main Password Recovery View
    var body: some View {
        VStack(spacing: 40) {
            // header information
            Image("SpartanSpirit_web")
                .resizable()
                .frame(width: 75, height: 75)
            Text("Recover Password")
                .font(.title).bold()
            
            // recover password through email vertical stack
            VStack {
                SDTextField(fieldValue: self.$userRegistrationEmail, placeholder: "Email", isSecure: false)
                HStack {
                    Button(action: {}) {
                        Text("Recover Password")
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
            
            // will dismiss the current password recovery sheet view
            Button(action: {
                self.displayPasswordRecoverySheet.toggle()
            }) {
                HStack {
                    Text("Cancel").accentColor(Color.init(#colorLiteral(red: 0.8980392157, green: 0.6588235294, blue: 0.137254902, alpha: 1)))
                }
            }
        }.padding()
    }
}

struct PasswordRecoveryView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordRecoveryView(displayPasswordRecoverySheet: .constant(false))
            .environmentObject(Authentication())
    }
}
