//
//  CheckoutViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/25.
//

import UIKit
import MBProgressHUD

class CheckoutViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cartTableView.rowHeight = UITableView.automaticDimension
        cartTableView.estimatedRowHeight = 170
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableViewHeightConstraint.constant = cartTableView.contentSize.height
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewWillLayoutSubviews()
    }
    
    func loadInCartItems() {
        let indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        indicator.isUserInteractionEnabled = false
        indicator.show(animated: true)
        cartTableView.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ProductService.shared.loadShoppingCartList(id: "0910619306", pwd: "a12345678") { items in
                self.inCartItems = items
                self.cartTableView.isHidden = false
                indicator.hide(animated: true)
            }
        }
    }
    
    func configureTableView() {
//        cartTableView.rowHeight = UITableView.automaticDimension
//        cartTableView.estimatedRowHeight = 44
        cartTableView.dataSource = self
        cartTableView.register(UINib(nibName: CheckoutTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: CheckoutTableViewCell.reuseIdentifier)
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
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func checkoutButtonTapped(_ sender: UIButton) {
        guard let orderAmount = orderAmountLabel.text,
              let discountAmount = discountAmountLabel.text,
              let orderPay = orderPayLabel.text else { return }
        OrderService.shared.addECOrder(id: "0910619306",
                                       pwd: "a12345678",
                                       orderAmount: orderAmount,
                                       discountAmount: discountAmount,
                                       orderPay: orderPay) { response in
            let alertController = UIAlertController(title: "準備結帳", message: "！", preferredStyle: .alert)
            let checkoutAction = UIAlertAction(title: "付款去", style: .default) { action in
//                let wkWebViewController
                print("敬請期待")
            }
            alertController.addAction(checkoutAction)
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
