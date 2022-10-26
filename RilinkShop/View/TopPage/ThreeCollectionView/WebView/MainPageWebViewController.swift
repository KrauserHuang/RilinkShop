//
//  MainPageWebViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/8/15.
//

import UIKit
import WebKit

protocol MainPageWebViewControllerDelegate: AnyObject {
    func didTapBackButton(_ viewController: MainPageWebViewController)
}

class MainPageWebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!

    weak var delegate: MainPageWebViewControllerDelegate?
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
        print(urlStr)
    }

    private func loadWeb(urlStr: String) {
        guard let url = URL(string: urlStr) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension MainPageWebViewController: WKNavigationDelegate {
}

extension MainPageWebViewController: WKUIDelegate {
}
