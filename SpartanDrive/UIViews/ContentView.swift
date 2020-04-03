//
//  ContentView.swift
//  SpartanDrive
//
//  Created by Brian Tamsing on 4/2/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import SwiftUI

/**
 * A struct that acts as a high-level View, wrapping Views like LoginView (and thus SignUpView and PasswordRecoveryView).
 */
struct ContentView: View {
    
    // Content View Environment Object
    @EnvironmentObject var session: Authentication
    
    
    // Main Content View
    var body: some View {
        return LoginView()
            .environmentObject(Authentication())
            .onAppear(perform: getUser)
    }
    
    
    // Content View Methods
    func getUser() {
        session.listen()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Authentication())
    }
}
