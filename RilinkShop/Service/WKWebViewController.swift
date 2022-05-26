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
    var orderNo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureWebView()
        
        let config = webView.configuration
        config.userContentController.add(self, name: "AppFunc")
    }
    
    private func configureWebView() {
        webView.navigationDelegate = self
        webView.uiDelegate = self
        loadWeb(urlStr: urlStr)
        print(urlStr)
        print(orderNo)
    }
    
    private func loadWeb(urlStr: String) {
        guard let url = URL(string: urlStr) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func toOrderList() {
        tabBarController?.selectedIndex = 3
        self.navigationController?.popToRootViewController(animated: false)
        let memberNVC = self.tabBarController?.selectedViewController as? MemberNavigationViewController
        memberNVC?.popToRootViewController(animated: false)
        
        if let myOderTVC = memberNVC?.viewControllers.compactMap({ $0 as? MyOrderTableViewController}).first {
            print("To MyOrderTVC")
            memberNVC?.pushViewController(myOderTVC, animated: true)
        }
//        self.tabBarController?.selectedIndex = 1
//        let shopNavigationController = self.tabBarController?.selectedViewController as? ShopNavigationController
//        shopNavigationController?.popToRootViewController(animated: false)
////        if let shopListViewController = shopNavigationController?.topViewController as? ShopListViewController {
//        if let shopListViewController = shopNavigationController?.viewControllers.compactMap({ $0 as? ShopListViewController }).first {
//            // do property to change
////            shopListViewController.removeFromParent()
////            shopListViewController.channelPrice = channelPrice
//            shopListViewController.channelPrice = "1" // 強迫進去折抵商城，不管sid回傳的channel_price
//            shopListViewController.sid = sid
////            shopNavigationController?.pushViewController(shopListViewController, animated: false)
//        }
    }
}

extension WKWebViewController: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("---------------------------")
        print("navigationActionResquestURL:\(navigationAction.request.url?.absoluteString)")
        if let url = navigationAction.request.url,
           url.description.lowercased().hasPrefix("line://") {
            if UIApplication.shared.canOpenURL(url) {
                print("+++++")
                print(url)
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        if let url = navigationAction.request.url,
           url.absoluteString.hasPrefix("rilinkshop://") {
            print("++++++++++++")
            print("url:\(url)")
            delegate?.backAction(self)
        }
        decisionHandler(.allow)
    }
    
    func setLeftItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(goBack))
    }
    
    @objc func goBack() {
        webView.goBack()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView.canGoBack {
            setLeftItem()
        } else if let navC = navigationController,
                  navC.viewControllers.count > 1 {
            navigationItem.leftBarButtonItem = navigationItem.backBarButtonItem
        } else {
            navigationItem.leftBarButtonItem = nil
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if webView.canGoBack {
            setLeftItem()
        } else if let navC = navigationController,
                  navC.viewControllers.count > 1 {
            navigationItem.leftBarButtonItem = navigationItem.backBarButtonItem
        } else {
            navigationItem.leftBarButtonItem = nil
        }
    }
}

extension WKWebViewController: WKScriptMessageHandler {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Start to load.")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("didReceiveMessage: \(message.name)")
        switch message.name {
        case "AppFunc":
            print("AppFunc")
            self.toOrderList()
        default:
            break
        }
    }
}
