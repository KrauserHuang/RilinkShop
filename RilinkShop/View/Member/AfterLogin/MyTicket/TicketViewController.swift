//
//  TicketViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/10.
//

import UIKit

class TicketViewController: UIViewController {

    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet var containerViews: [UIView]!
    @IBAction func changeView(_ sender: UISegmentedControl) {
        containerViews.forEach {
           $0.isHidden = true
        }
        containerViews[sender.selectedSegmentIndex].isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
