//
//  SDTextField.swift
//  SpartanDrive
//
//  Created by Brian Tamsing on 4/1/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import SwiftUI

struct SDTextField: View {
    
    // SDTextField State Properties
    @Binding var fieldValue: String
    var placeholder: String = "Placeholder"
    var isSecure: Bool = false
    var onEditingChanged: ((Bool) -> (Void)) = { _ in }
    
    
    // Main SDTextField View
    var body: some View {
        // presents either a plain (email) text field, or a secure, hidden input (password) field.
        HStack {
            if !isSecure {
                TextField(self.placeholder, text: self.$fieldValue, onEditingChanged: { flag in self.onEditingChanged(flag) })
                .padding()
                .frame(width: 350, height: 45)
                .background(Color.init(#colorLiteral(red: 0.9254901961, green: 0.9411764706, blue: 0.9529411765, alpha: 0.5)))
                .cornerRadius(20)
            }
            else {
                SecureField(self.placeholder, text: self.$fieldValue, onCommit: { self.onEditingChanged(false) })
                .padding()
                .frame(width: 350, height: 45)
                .background(Color.init(#colorLiteral(red: 0.9254901961, green: 0.9411764706, blue: 0.9529411765, alpha: 0.5)))
                .cornerRadius(20)
            }
        }
    }
}

struct SDTextField_Previews: PreviewProvider {
    static var previews: some View {
        SDTextField(fieldValue: .constant(""))
    }
}
