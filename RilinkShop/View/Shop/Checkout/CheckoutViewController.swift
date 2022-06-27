//
//  CheckoutViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/25.
//

import UIKit
import MBProgressHUD
import SwiftUI

class CheckoutViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bonusPointLabel: UILabel!
    @IBOutlet weak var bonusPointTextField: UITextField!
    @IBOutlet weak var orderAmountLabel: UILabel!
    @IBOutlet weak var discountAmountLabel: UILabel!
    @IBOutlet weak var orderPayLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var checkoutButton: UIButton!
    
    var orderAmount = 0
    var point = 0
    var discount = 0
    var orderPay = 0 {
        didSet {
            orderPay = orderAmount - discount
        }
    }
    var inCartItems = [Product]() {
        didSet {
            DispatchQueue.main.async {
                self.cartTableView.reloadData()
            }
        }
    }
    let account = MyKeyChain.getAccount() ?? ""
    let password = MyKeyChain.getPassword() ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadInCartItems()
        configureTableView()
        configureView()
        showInfo()
        configureKeyboard()
        setPointView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadInCartItems()
    }
    
    func loadInCartItems() {
        let indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        indicator.isUserInteractionEnabled = false
        indicator.show(animated: true)
        cartTableView.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ProductService.shared.loadShoppingCartList(id: self.account, pwd: self.password) { items in
                self.inCartItems = items
                self.cartTableView.isHidden = false
                // 85: Fixed cart cell height
                self.tableViewHeightConstraint.constant = CGFloat(items.count * 85)
                indicator.hide(animated: true)
            }
        }
    }
    
    func setPointView() {
        let textDone = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(inputDone))
        let tool = UIToolbar()
        tool.sizeToFit()
        tool.items = [textDone]
        bonusPointTextField.inputAccessoryView = tool
    }
    @objc func inputDone(){
        guard let pointInt = Int(bonusPointTextField.text!) else {
            bonusPointTextField.text = "0"
            return
        }
        let priceInt = orderPay
        let pointNow = point
        if pointInt < pointNow { // 檢查輸入點數小於現有點數
            let check = priceInt - pointInt * 2 // 應付金額扣除(輸入點數*2)
            if check > 0 {
                orderPayLabel.text = String(check)
            } else {
                var pointuse = priceInt / 2 // 點數使用 = 應付金額 / 2
                if priceInt == pointuse * 2 { // ??????
                    pointuse -= 1
                }
                bonusPointTextField.text = String(pointuse)
                orderPayLabel.text = String(priceInt - pointuse * 2)
            }
            
        } else { // 若輸入點數大於現有點數
            let check = priceInt - pointNow * 2 // 應付金額直接扣除(現有點數*2)
            if check > 0 {
                orderPayLabel.text = String(check)
                bonusPointTextField.text = "\(point)"
            } else {
                var pointuse = priceInt / 2
                if priceInt == pointuse * 2 {
                    pointuse -= 1
                }
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
        backButton.layer.borderColor = UIColor(hex: "#4F846C")?.cgColor
        backButton.layer.cornerRadius = 10
        backButton.tintColor = UIColor(hex: "#4F846C")
        
        checkoutButton.backgroundColor = UIColor(hex: "#4F846C")
        checkoutButton.tintColor = .white
        checkoutButton.layer.cornerRadius = 10
    }
    
    func showInfo() {
        orderAmountLabel.text = "\(orderAmount)"
        discountAmountLabel.text = "\(discount)"
        orderPay = orderAmount - discount
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
        let discount = Int(discountAmount)! * 5
        OrderService.shared.addECOrder(id: account,
                                       pwd: password,
                                       orderAmount: orderAmount,
                                       discountAmount: "\(discount)",
                                       orderPay: orderPay) { response in
            let alertController = UIAlertController(title: "準備結帳", message: "", preferredStyle: .alert)
            let checkoutAction = UIAlertAction(title: "付款去", style: .default) { action in
                let wkWebVC = WKWebViewController()
                wkWebVC.delegate = self
                wkWebVC.urlStr = PAYMENT_API_URL + "\(response.responseMessage)"
//                "http://211.20.181.125:11073/ticketec/ecpay/ecpayindex.php?orderid=\(response.responseMessage)"
                wkWebVC.orderNo = response.responseMessage
                self.navigationController?.pushViewController(wkWebVC, animated: true)
            }
            let backToShopAction = UIAlertAction(title: "回首頁", style: .default) { action in
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
//        let discount = Int(bonusPoint)! * 2
//        discountAmountLabel.text = "\(discount)"
//    }
}
// MARK: - WKWebViewControllerDelegate
extension CheckoutViewController: WKWebViewControllerDelegate {
    func backAction(_ viewController: WKWebViewController) {
        navigationController?.popToRootViewController(animated: true)
    }
}
