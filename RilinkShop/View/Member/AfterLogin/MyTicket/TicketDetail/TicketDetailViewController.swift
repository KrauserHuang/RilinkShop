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
    
    var ticket = QRCode()
    var product = PackageProduct()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if product.qrconfirm!.count == 0 { // 代表是單獨商品
            setView()
        } else {
            setView1()
        }
        // 偵測使用者是否擷取圖片或是錄影(訂閱截圖及錄影通知)
        NotificationCenter.default.addObserver(self, selector: #selector(screenshotTaken), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(screenshotTaken), name: UIScreen.capturedDidChangeNotification, object: nil)
        
        let screen = UIScreen.main
        if screen.isCaptured {
            screenshotTaken()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //取消訂閱通知(此vc所有訂閱者)
        NotificationCenter.default.removeObserver(self)
    }
    @objc func screenshotTaken() {
        Alert.showMessage(title: "安全提醒", msg: "QR Code可供他人使用，請小心留存", vc: self, handler: nil)
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
        buyDateLabel.text = "購買日期：\(ticket.orderDate)"
        orderNoLabel.text = "訂單編號：\(ticket.orderNo)"
        
        if let ticketProductName = ticket.productName {
            nameLabel.text = ticketProductName
        } else if let ticketPackageName = ticket.packageName {
            nameLabel.text = ticketPackageName
        }
        
        if let ticketQRConfirm = ticket.qrconfirm {
            qrImageView.image = generateQRCode(from: ticketQRConfirm)
        }
    }
    
    func setView1() {
        buyDateLabel.text = "購買日期：\(ticket.orderDate)"
        orderNoLabel.text = "訂單編號：\(ticket.orderNo)"
        if let ticketQRConfirm = ticket.qrconfirm {
            qrImageView.image = generateQRCode(from: ticketQRConfirm)
        }
        
        nameLabel.text = product.productName
        
        
    }
}
