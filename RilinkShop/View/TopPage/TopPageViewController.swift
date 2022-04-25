//
//  TopPageViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/6.
//

import UIKit

class TopPageViewController: UIViewController {

    @IBOutlet weak var anouncementLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBAction func instructAvtion(_ sender: UIButton) {
    }
    @IBAction func moreActivity(_ sender: UIButton) {
    }
    @IBAction func moreProduct(_ sender: UIButton) {
    }
    @IBOutlet weak var promotionsBottomView: UIView!
    @IBOutlet weak var productsBottomViiew: UIView!
    @IBOutlet weak var activity1BV: UIView!
    @IBOutlet weak var activity2BV: UIView!
    @IBOutlet weak var activity3BV: UIView!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        productsBottomViiew.backgroundColor = .clear
        promotionsBottomView.backgroundColor = .clear
        
        image1.layer.cornerRadius = 20
        image2.layer.cornerRadius = 20
        image3.layer.cornerRadius = 20
        
        makeViewRoundEdgeAndAddShadow(obj: activity1BV)
        makeViewRoundEdgeAndAddShadow(obj: activity2BV)
        makeViewRoundEdgeAndAddShadow(obj: activity3BV)

        
        
    }
    
    func makeViewRoundEdgeAndAddShadow( obj: UIView){
        obj.layer.shadowRadius = 20
        obj.layer.shadowColor = UIColor.black.cgColor
        obj.layer.borderColor = UIColor.clear.cgColor
        obj.layer.borderWidth = 1
        obj.layer.cornerRadius = 20
        obj.layer.shadowOpacity = 0.15
        obj.backgroundColor = .white
    }
    
}
