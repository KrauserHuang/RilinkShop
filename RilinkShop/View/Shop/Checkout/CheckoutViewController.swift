//
//  CheckoutViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/25.
//

import UIKit
import MBProgressHUD
import SwiftUI
import EzPopup

class CheckoutViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bonusPointLabel: UILabel!
    @IBOutlet weak var bonusPointTextField: UITextField!
    // 商品合計
    @IBOutlet weak var orderAmountLabel: UILabel!
    // 點數折抵
    @IBOutlet weak var discountAmountLabel: UILabel!
    // 應付金額合計
    @IBOutlet weak var orderPayLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var checkoutButton: UIButton!

    var orderAmount = 0
    var point = 0
    // 應付金額合計
    var orderPay = 0 {
        didSet {
            // 應付金額合計 = 商品合計 - 點數折抵
//            orderPay = orderAmount - point
        }
    }
    var inCartItems = [Product]() {
        didSet {
            DispatchQueue.main.async {
                self.cartTableView.reloadData()
            }
        }
    }
    var account = MyKeyChain.getAccount() ?? ""
    var password = MyKeyChain.getPassword() ?? ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadInCartItems()
        configureTableView()
        configureView()
        showInfo()
        configureKeyboard()
        setPointView()
        bonusPointTextField.addTarget(self, action: #selector(textFieldFilter(_:)), for: .editingChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadInCartItems()
        setPointView()
    }

    @objc func textFieldFilter(_ sender: UITextField) {
        if let text = sender.text, let intText = Int(text) {
            sender.text = "\(intText)"
        } else {
            sender.text = ""
        }
    }

    func loadInCartItems() {
        HUD.showLoadingHUD(inView: self.view, text: "載入中")
        ProductService.shared.loadShoppingCartList(id: account, pwd: password) { items in
            DispatchQueue.global(qos: .userInitiated).async {
                URLCache.shared.removeAllCachedResponses()
                DispatchQueue.main.sync {
                    HUD.hideLoadingHUD(inView: self.view)
                    self.inCartItems = items
                    self.tableViewHeightConstraint.constant = CGFloat(items.count * 85)
                }
            }
        }
    }
    // MARK: - 設定填寫使用點數的textField accessoryView，還有判斷式
    func setPointView() {
        let tool = UIToolbar()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let textDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(inputDone))
        tool.items = [flexibleSpace, textDone]
        tool.sizeToFit()
        bonusPointTextField.inputAccessoryView = tool
    }
    @objc func inputDone() {
        print(#function)
        print("vcPoint:\(point)")
        print("point:\(bonusPointTextField.text ?? "no point")")
        // pointInt = 使用點數textField輸入的文字
        guard let pointInt = Int(bonusPointTextField.text!) else {
            bonusPointTextField.text = "0"
            return
        }
        print("pointInt:\(pointInt)")
        let priceInt = orderPay // priceInt = 應付金額
        let pointNow = point // pointNow = 現有點數
        if pointInt < pointNow { // 輸入點數小於現有點數
            let check = priceInt - pointInt * 2 // 應付金額扣除(輸入點數*2)
            if check > 0 { // 代表點數折抵小於總價(合理)
                bonusPointLabel.text = "\(pointNow - pointInt)"
                discountAmountLabel.text = "\(pointInt * 2)"
                orderPayLabel.text = "\(check)"
            } else { // 點數折抵超過總價(不合理)
                var pointuse = priceInt / 2 // 點數使用 = 應付金額 / 2
                if priceInt == pointuse * 2 { // ??????
                    pointuse -= 1
                }
                bonusPointLabel.text = "\(pointNow)" // 不合理所以可使用點數不做變化
                discountAmountLabel.text = "\(pointuse * 2)"
                bonusPointTextField.text = String(pointuse)
                orderPayLabel.text = String(priceInt - pointuse * 2)
            }
        } else { // 若輸入點數大於現有點數(須禁止超過現有點數，直接使用現有點數去判斷)
            let check = priceInt - pointNow * 2 // 應付金額直接扣除(現有點數*2)
            if check > 0 {
                bonusPointLabel.text = "0"
                discountAmountLabel.text = "\(pointNow * 2)"
                orderPayLabel.text = "\(check)"
                bonusPointTextField.text = "\(pointNow)"
            } else {
                var pointuse = priceInt / 2
                if priceInt == pointuse * 2 {
                    pointuse -= 1
                }
                bonusPointLabel.text = "\(pointNow)" // 不合理所以可使用點數不做變化
                discountAmountLabel.text = "\(pointuse * 2)"
                bonusPointTextField.text = String(pointuse)
                orderPayLabel.text = String(priceInt - pointuse * 2)
            }
        }
        point = pointNow
        self.view.endEditing(true)
    }

    func configureTableView() {
        cartTableView.rowHeight = UITableView.automaticDimension
        cartTableView.dataSource = self
        cartTableView.register(UINib(nibName: CheckoutTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: CheckoutTableViewCell.reuseIdentifier)
        cartTableView.isScrollEnabled = false
        cartTableView.allowsSelection = false
    }

    func configureView() {
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = Theme.customOrange.cgColor
        backButton.layer.cornerRadius = 10
        backButton.tintColor = Theme.customOrange

        checkoutButton.backgroundColor = Theme.customOrange
        checkoutButton.tintColor = .white
        checkoutButton.layer.cornerRadius = 10
    }

    func showInfo() {
        orderAmountLabel.text = "\(orderAmount)"
        discountAmountLabel.text = "\(point)"
        orderPay = orderAmount - point
        orderPayLabel.text = "\(orderPay)"

        let accountType = "0"
        UserService.shared.getPersonalData(account: account, pw: password, accountType: accountType) { success, response in
            DispatchQueue.global(qos: .userInitiated).async {
                URLCache.shared.removeAllCachedResponses()
                DispatchQueue.main.async {

                    guard success else {
                        let errorMsg = response as! String
                        Alert.showMessage(title: "", msg: errorMsg, vc: self, handler: nil)
                        return
                    }
                    if let user = response as? User {
                        self.bonusPointLabel.text = user.point
                        self.point = Int(user.point)!
                        print(#function)
                        print("point2:\(self.point)")
                    }
                }
            }
        }
    }

    func configureKeyboard() {
        bonusPointTextField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func checkoutButtonTapped(_ sender: UIButton) {

        guard let orderAmount = orderAmountLabel.text,
              let discountAmount = discountAmountLabel.text,
              let orderPay = orderPayLabel.text else { return }
        print(#function)
//        print("orderAmount:\(orderAmount)")
//        print("discount:\(discountAmount)")
//        print("orderPay:\(orderPay)")
        OrderService.shared.addECOrder(id: account,
                                       pwd: password,
                                       orderAmount: orderAmount,
                                       discountAmount: discountAmount,
                                       orderPay: orderPay) { response in
            let alertController = UIAlertController(title: "準備結帳", message: "", preferredStyle: .alert)
            let checkoutAction = UIAlertAction(title: "付款去", style: .default) { _ in
                let wkWebVC = WKWebViewController()
                wkWebVC.delegate = self
                wkWebVC.urlStr = PAYMENT_API_URL + "\(response.responseMessage)"
                wkWebVC.orderNo = response.responseMessage
                let popVC = PopupViewController(contentController: wkWebVC,
                                                popupWidth: self.view.bounds.width - 40,
                                                popupHeight: self.view.bounds.height - 100)

                popVC.cornerRadius  = 10
                popVC.backgroundColor = .black
                popVC.backgroundAlpha = 1
                popVC.shadowEnabled = true
                popVC.canTapOutsideToDismiss = false

//                self.navigationController?.popToRootViewController(animated: true)
                self.present(popVC, animated: true, completion: nil)

//                self.present(popVC, animated: true) {
//                    self.navigationController?.popToRootViewController(animated: true)
//                }
//                self.present(popVC, animated: true, completion: nil)
            }
            let backToShopAction = UIAlertAction(title: "回首頁", style: .default) { _ in
                self.navigationController?.popToRootViewController(animated: true)
            }
            alertController.addAction(checkoutAction)
            alertController.addAction(backToShopAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
// MARK: - UITableViewDataSource
extension CheckoutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inCartItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CheckoutTableViewCell.reuseIdentifier, for: indexPath) as! CheckoutTableViewCell

        let inCartItem = inCartItems[indexPath.row]
        cell.configure(with: inCartItem)

        return cell
    }
}
// MARK: - UITextFieldDelegate
extension CheckoutViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        let bonusPoint = bonusPointTextField.text ?? "0"
//        let point = Int(bonusPoint)! * 2
//        discountAmountLabel.text = "\(point)"
//    }
}
// MARK: - WKWebViewControllerDelegate
extension CheckoutViewController: WKWebViewControllerDelegate {
    func backAction(_ viewController: WKWebViewController) {
        HUD.showLoadingHUD(inView: self.view, text: "")
        navigationController?.popToRootViewController(animated: true)
        HUD.hideLoadingHUD(inView: self.view)
    }
}
