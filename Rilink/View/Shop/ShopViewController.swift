//
//  ShopViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/6.
//

import UIKit
import WebKit

class ShopViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    var urlStr = "https://www.apple.com/mac/"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let url = URL(string: urlStr) else { return }
        let request = URLRequest(url: url)
        
        webView.navigationDelegate = self
        webView.load(request)
        
    }
    
}
