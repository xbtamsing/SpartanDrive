//
//  ViewController.swift
//  SpartanDrive
//
//  Created by Spencer on 2/25/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var count = 0
    @IBOutlet weak var countLabel: UILabel!
    @IBAction func countButton(_ sender: Any) {
        count += 1
        countLabel.text = "Count: \(count)"
    }
}

