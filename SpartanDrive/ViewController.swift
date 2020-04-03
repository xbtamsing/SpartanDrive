//
//  ViewController.swift
//  SpartanDrive
//
//  Created by Spencer on 2/25/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    // segue to the Login Screen modal, which can in turn present more modal views.
    @IBSegueAction func getStarted(_ coder: NSCoder) -> UIViewController? {
        let rootView = ContentView().environmentObject(Authentication())
        return UIHostingController(coder: coder, rootView: rootView)
    }
}

