//
//  CheckoutViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/25.
//

import UIKit
//import MBProgressHUD
import SwiftUI
import EzPopup
import DropDown

class CheckoutViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bonusPointLabel: UILabel!
    @IBOutlet weak var bonusPointTextField: UITextField!
    @IBOutlet weak var orderAmountLabel: UILabel!       // 商品合計
    @IBOutlet weak var discountAmountLabel: UILabel!    // 點數折抵
    @IBOutlet weak var orderPayLabel: UILabel!          // 應付金額合計
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var checkoutButton: UIButton!
    
    @IBOutlet weak var invoicePhoneStackView: UIStackView!
    @IBOutlet weak var uniformNoStackView: UIStackView!
    
    @IBOutlet weak var invoicePhoneTextField: UITextField!
    @IBOutlet weak var uniformNoTextField: UITextField!
    @IBOutlet weak var uniformNoTitleTextField: UITextField!

    var orderAmount = 0
    var point = 0
    // 應付金額合計
    var orderPay = 0
    var inCartItems = [Product]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var account: String!
    var password: String!
    let dropDown = DropDown()
    var invoiceType = InvoiceType.individual.rawValue
    let allowedPredicate = NSPredicate(format: "SELF MATCHES %@", "^[0-9A-Z+-.]{0,7}$")
    var orderNo: String?

    
    init(account: String, password: String) {
        super.init(nibName: nil, bundle: nil)
        self.account = account
        self.password = password
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureButton()
        showInfo()
        configureKeyboard()
        setPointView()
        invoicePhoneStackView.isHidden = true
        uniformNoStackView.isHidden = true
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

    private func loadInCartItems() {
        HUD.showLoadingHUD(inView: self.view, text: "載入中")
        ProductService.shared.loadShoppingCartList(id: account, pwd: password) { items in
            DispatchQueue.global(qos: .userInitiated).async {
                URLCache.shared.removeAllCachedResponses()
                DispatchQueue.main.sync {
                    HUD.hideLoadingHUD(inView: self.view)
                    self.inCartItems = items
                    self.tableViewHeightConstraint.constant = CGFloat(items.count * 105)
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
        // pointInt = 使用點數textField輸入的文字
        guard let pointInt = Int(bonusPointTextField.text!) else {
            bonusPointTextField.text = "0"
            return
        }
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

    private func configureTableView() {
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(CheckoutTableViewCell.nib, forCellReuseIdentifier: CheckoutTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
    }

    private func configureButton() {
        backButton.layer.borderWidth        = 1
        backButton.layer.borderColor        = UIColor.primaryOrange.cgColor
        backButton.layer.cornerRadius       = 10
        backButton.tintColor                = .primaryOrange
    
        checkoutButton.backgroundColor      = .primaryOrange
        checkoutButton.tintColor            = .white
        checkoutButton.layer.cornerRadius   = 10
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
                        Alert.showMessage(title: "系統訊息", msg: errorMsg, vc: self, handler: nil)
                        return
                    }
                    if let user = response as? User {
                        self.bonusPointLabel.text = user.point
                        self.point = Int(user.point)!
                    }
                }
            }
        }
    }

    private func configureKeyboard() {
        bonusPointTextField.delegate = self
        invoicePhoneTextField.delegate = self
        uniformNoTextField.delegate = self
        uniformNoTitleTextField.delegate = self
        
        uniformNoTextField.keyboardType = .numberPad
        
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
        let contentInsets                   = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset             = contentInsets
        scrollView.scrollIndicatorInsets    = contentInsets
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        let contentInsets                   = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.contentInset             = contentInsets
        scrollView.scrollIndicatorInsets    = contentInsets
    }
    
    @IBAction func invoiceButtonTapped(_ sender: UIButton) {
        dropDown.dataSource = ["個人電子發票", "手機條碼載具", "三聯式發票"]
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            sender.setTitle(item, for: .normal)
            switch index {
            case 0:
                self?.invoiceType = InvoiceType.individual.rawValue
                self?.invoicePhoneStackView.isHidden = true
                self?.uniformNoStackView.isHidden = true
            case 1:
                self?.invoiceType = InvoiceType.phone.rawValue
                self?.invoicePhoneStackView.isHidden = false
                self?.uniformNoStackView.isHidden = true
            case 2:
                self?.invoiceType = InvoiceType.uniform.rawValue
                self?.invoicePhoneStackView.isHidden = true
                self?.uniformNoStackView.isHidden = false
            default:
                break
            }
        }
    }
    

    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func checkoutButtonTapped(_ sender: UIButton) {
        switch invoiceType {
        case InvoiceType.phone.rawValue:
            let count = invoicePhoneTextField.text?.count
            guard count == 0 || count == 8 else {
                Alert.showMessage(title: "系統訊息", msg: "手機載具條碼格式不符", vc: self)
                return
            }
        case InvoiceType.uniform.rawValue:
            let count = uniformNoTextField.text?.count
            guard count == 0 || count == 8 else {
                Alert.showMessage(title: "系統訊息", msg: "統一編號格式不符", vc: self)
                return
            }
        default:
            break
        }
        let group = DispatchGroup()
        group.enter()
        guard let orderAmount = orderAmountLabel.text,
              let discountAmount = discountAmountLabel.text,
              let orderPay = orderPayLabel.text else { return }
        OrderService.shared.addECOrder(id: account,
                                       pwd: password,
                                       orderAmount: orderAmount,
                                       discountAmount: discountAmount,
                                       orderPay: orderPay) { response in
            let orderNo = response.responseMessage
            self.orderNo = orderNo
            print("訂單確認")
//            group.leave()
//            group.enter()
            InvoiceService.shared.createInvoice(orderNo: orderNo,
                                                invoiceType: "\(self.invoiceType)",
                                                companyTitle: self.uniformNoTitleTextField.text ?? "",
                                                uniformNo: self.uniformNoTextField.text ?? "",
                                                invoicePhone: self.invoicePhoneTextField.text ?? "") { success, response in
                print("發票確認")
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            let alertController = UIAlertController(title: "準備結帳", message: "", preferredStyle: .alert)
            let checkoutAction = UIAlertAction(title: "付款去", style: .default) { _ in
                let wkWebVC = WKWebViewController()
                wkWebVC.delegate = self
                wkWebVC.urlStr = PAYMENT_API_URL + self.orderNo!
                wkWebVC.orderNo = self.orderNo!
                let popVC = PopupViewController(contentController: wkWebVC,
                                                popupWidth: self.view.bounds.width - 40,
                                                popupHeight: self.view.bounds.height - 100)
                
                popVC.cornerRadius  = 10
                popVC.backgroundColor = .black
                popVC.backgroundAlpha = 1
                popVC.shadowEnabled = true
                popVC.canTapOutsideToDismiss = false
                self.present(popVC, animated: true, completion: nil)
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == invoicePhoneTextField {
            textField.text = "/"
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case invoicePhoneTextField: //必須以【 / 】為開頭，其餘7碼則由數字【0-9】大寫英文【A-Z】與特殊符號【+】【-】【.】這39個字元組成的編號
            let maxLength = 8
            let currentString = textField.text ?? ""
            let newString = (currentString as NSString).replacingCharacters(in: range, with: string)
            let newStringWithoutSlash = newString.dropFirst()
            if range.location == 0 && range.length == 1 {
                return false
            }

            return newString.count <= maxLength && allowedPredicate.evaluate(with: newStringWithoutSlash)
        case uniformNoTextField: //8碼數字【0-9】組成
            let maxLength = 8
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            let allowedCharacterSet = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            
            return newString.length <= maxLength && allowedCharacterSet.isSuperset(of: characterSet)
        default:
            return true
        }
    }
}
// MARK: - WKWebViewControllerDelegate
extension CheckoutViewController: WKWebViewControllerDelegate {
    func backAction(_ viewController: WKWebViewController) {
        HUD.showLoadingHUD(inView: self.view, text: "")
        navigationController?.popToRootViewController(animated: true)
        HUD.hideLoadingHUD(inView: self.view)
    }
}
