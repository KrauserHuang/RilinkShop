//
//  WKWebViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/6.
//

import UIKit
import WebKit
import SwiftUI

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
        Alert.showMessage(title: "訂單已完成", msg: "請去\n會員中心  ➡  我的訂單\n查看", vc: self) {
            self.view.window?.rootViewController?.dismiss(animated: true, completion: {
                self.delegate?.backAction(self)
            })
        }
    }
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        Alert.showMessage(title: "訂單已完成", msg: "請去\n會員中心  ➡  我的訂單\n查看", vc: self) {
            self.dismiss(animated: true) {
                self.delegate?.backAction(self)
            }
        }
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
//            if let navC = navigationController,
//               let lastOne = navC.viewControllers.last {
//                lastOne.navigationItem.leftBarButtonItem = nil
//                print("you don't have back button!")
//            } else {
//                setLeftItem()
//            }
            //https://rilink.com.tw/ticketec/ecpay/ecpayindex.php?orderid=
//            if webView.url?.absoluteString == "https://rilink.jotangi.com.tw:11074/ticketec/ecpay/payments/epospay/eposOrderResult.php" {
            if webView.url?.absoluteString == "https://rilink.jotangi.tw:11074/ticketec/ecpay/payments/epospay/eposOrderResult.php" {
                navigationItem.leftBarButtonItem = nil
                print("you are on the last page, no button for you!")
            } else {
                setLeftItem()
                print("you got a custom arrow!")
            }

        } else if let navC = navigationController,
                  navC.viewControllers.count > 1 {
            if let lastPage = navC.viewControllers.last {
                lastPage.navigationItem.leftBarButtonItem = nil
                print("you are on the last page, no button for you!")
            } else {
                navigationItem.leftBarButtonItem = navigationItem.backBarButtonItem
                print("you got a back arrow button!")
            }
//            if let lastOne = navC.viewControllers.last {
//                lastOne.navigationItem.leftBarButtonItem = nil
//            } else {
//                navigationItem.leftBarButtonItem = navigationItem.backBarButtonItem
//            }
        } else {
            navigationItem.leftBarButtonItem = nil
            print("you have nothing!")
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
    // 載入中，畫面慢慢出現
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Start to load.")
    }
    // 載入失敗
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("didReceiveMessage: \(message.name)")
//        switch message.name {
//        case "AppFunc":
//            print("AppFunc")
//            self.toOrderList()
//        default:
//            break
//        }
        self.toOrderList()
    }
}
