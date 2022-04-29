//
//  CheckoutViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/25.
//

import UIKit

class CheckoutViewController: UIViewController {
    
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var cartTotalLabel: UILabel!
    @IBOutlet weak var bonusDiscountLabel: UILabel!
    @IBOutlet weak var overallCostLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var checkoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configureTableView()
        configureView()
    }
    
    func configureTableView() {
        cartTableView.delegate = self
        cartTableView.dataSource = self
        cartTableView.register(UINib(nibName: CheckoutTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: CheckoutTableViewCell.reuseIdentifier)
    }
    
    func configureView() {
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor(hex: "#54a0ff")?.cgColor
        backButton.layer.cornerRadius = 10
        backButton.tintColor = UIColor(hex: "#54a0ff")
        
        checkoutButton.backgroundColor = UIColor(hex: "#54a0ff")
        checkoutButton.tintColor = .white
        checkoutButton.layer.cornerRadius = 10
    }

    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func checkoutButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "準備結帳", message: "！", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CheckoutTableViewCell.reuseIdentifier, for: indexPath) as! CheckoutTableViewCell
        
        cell.configure()
        
        return cell
    }
}
