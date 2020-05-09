//
//  WebView.swift
//  SpartanDrive
//
//  Created by Brian Tamsing on 5/2/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import UIKit
import WebKit

class WebView: UIViewController {
    
    // WebView Properties
    private var webView: WKWebView!
    public var fileURL: URL!
    public var fileTitle: String!
    
    
    // Initialization
    override func loadView() {
        let webConfig = WKWebViewConfiguration()
        self.webView = WKWebView(frame: .zero, configuration: webConfig)
        self.webView.uiDelegate = self
        self.view = self.webView
    }
    
    
    // WebView Methods
    /**
    * Prepares the View elements as the app is loaded into memory.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let webRequest = self.fileURL {
            self.webView.load(URLRequest(url: webRequest))
        }
    }
}


extension WebView: WKUIDelegate {
    
}
