//
//  BNRWebViewViewController.swift
//  WorldTrotterBNR
//
//  Created by Anatoliy Chernyuk on 12/25/17.
//  Copyright © 2017 Anatoliy Chernyuk. All rights reserved.
//

import UIKit
import WebKit

class BNRWebViewViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadBNRWebPage()

        // Do any additional setup after loading the view.
    }
    
    func loadBNRWebPage() {
        let urlString = "https://www.bignerdranch.com"
        let url = URL(string: urlString)
        if let url = url {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
    }

}
