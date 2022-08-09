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
//        switch sender.selectedSegmentIndex{ // <<== Here
//            case 0:
//            containerViews[1].isHidden = true
//            containerViews[0].isHidden = false
//            case 1:
//            containerViews[0].isHidden = true
//            containerViews[1].isHidden = false
//            default:
//                print("segmentError")
//        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
