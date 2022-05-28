//
//  TicketDetailViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/27.
//

import UIKit
import CoreImage.CIFilterBuiltins

class TicketDetailViewController: UIViewController {

    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var buyDateLabel: UILabel!
    @IBOutlet weak var orderNoLabel: UILabel!
    
    var ticket = UNQRCode()
    var product = PackageProduct()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if product.qrconfirm!.count == 0 { // 代表是單獨商品
            setView()
        } else {
            setView1()
        }
        
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let QRFilter = CIFilter(name: "CIQRCodeGenerator") {
            QRFilter.setValue(data, forKey: "inputMessage")
            
            guard let QRImage = QRFilter.outputImage else { return nil }
            return UIImage(ciImage: QRImage)
        }
        return nil
    }
    
    func setView() {
        if let ticketProductName = ticket.productName {
            nameLabel.text = ticketProductName
        } else if let ticketPackageName = ticket.packageName {
            nameLabel.text = ticketPackageName
        }
        buyDateLabel.text = "購買日期：\(ticket.orderDate)"
        orderNoLabel.text = "訂單編號：\(ticket.orderNo)"
        if let ticketQRConfirm = ticket.qrconfirm {
            print(#function)
            print(ticket.qrconfirm)
            qrImageView.image = generateQRCode(from: ticketQRConfirm)
        }
    }
    
    func setView1() {
        print(#function)
        print(product.qrconfirm)
        nameLabel.text = product.productName
        buyDateLabel.text = "購買日期：\(ticket.orderDate)"
        orderNoLabel.text = "訂單編號：\(ticket.orderNo)"
        qrImageView.image = generateQRCode(from: product.qrconfirm!)
    }
}
