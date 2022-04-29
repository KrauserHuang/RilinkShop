//
//  TicketDetailViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/27.
//

import UIKit

class TicketDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var buyDateLabel: UILabel!
    @IBOutlet weak var orderNoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func scanAction(_ sender: UIButton) {
        let controller = QRCodeViewController()
        controller.modalPresentationStyle = .fullScreen
//        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
