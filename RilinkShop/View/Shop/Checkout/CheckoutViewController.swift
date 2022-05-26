//
//  CheckoutViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/25.
//

import UIKit
import MBProgressHUD

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
        OrderService.shared.addECOrder(id: account,
                                       pwd: password,
                                       orderAmount: orderAmount,
                                       discountAmount: discountAmount,
                                       orderPay: orderPay) { response in
            let alertController = UIAlertController(title: "準備結帳", message: "", preferredStyle: .alert)
            let checkoutAction = UIAlertAction(title: "付款去", style: .default) { action in
                let wkWebVC = WKWebViewController()
                wkWebVC.delegate = self
                wkWebVC.urlStr = "http://211.20.181.125:11073/ticketec/ecpay/ecpayindex.php?orderid=\(response.responseMessage)"
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
}
// MARK: - WKWebViewControllerDelegate
extension CheckoutViewController: WKWebViewControllerDelegate {
    func backAction(_ viewController: WKWebViewController) {
        navigationController?.popToRootViewController(animated: true)
    }
}
