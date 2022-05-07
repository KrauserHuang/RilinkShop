//
//  WKWebViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/6.
//

import UIKit
import WebKit

protocol WKWebViewControllerDelegate: AnyObject {
    func backAction(_ viewController: WKWebViewController)
}

class WKWebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    weak var delegate: WKWebViewControllerDelegate?
    var urlStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureWebView()
    }
    
    private func configureWebView() {
        webView.navigationDelegate = self
        webView.uiDelegate = self
        loadWeb(urlStr: urlStr)
    }
    
    private func loadWeb(urlStr: String) {
        guard let url = URL(string: urlStr) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension WKWebViewController: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        //
    }
}
