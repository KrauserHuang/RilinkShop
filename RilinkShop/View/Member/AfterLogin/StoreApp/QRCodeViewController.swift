//
//  QRCodeViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/27.
//

import UIKit
import AVFoundation
import SwiftUI

protocol QRCodeViewControllerDelegate: AnyObject {
    func didFinishScan(_ viewController: QRCodeViewController)
}

class QRCodeViewController: UIViewController {
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var outView: UIView!
    
    weak var delegate: QRCodeViewControllerDelegate?
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.backButtonTitle = ""
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setMask()
        setLayer()
        configureQRCodeReader()
//        outView.alpha = 0.5
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setMask(){
        let maskLayer = CAShapeLayer()
        let path = CGMutablePath()
        path.addRect(cameraView.frame)
        path.addRect(outView.bounds)
        maskLayer.path = path
        maskLayer.fillRule = .evenOdd
        outView.layer.mask = maskLayer
    }
    
    func setLayer(){
//        畫出畫面四周的線
        let layer = CAShapeLayer()
        layer.frame = cameraView.bounds
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 35))
        path.addLine(to: .zero)
        path.addLine(to: CGPoint(x: 35, y: 0))
        
        path.move(to: CGPoint(x: layer.frame.maxX - 35, y: 0))
        path.addLine(to: CGPoint(x: layer.frame.maxX, y: 0))
        path.addLine(to: CGPoint(x: layer.frame.maxX, y: 35))
        
        path.move(to: CGPoint(x: 0, y: layer.frame.maxY - 35))
        path.addLine(to: CGPoint(x: 0, y: layer.frame.maxY))
        path.addLine(to: CGPoint(x: 35, y: layer.frame.maxY))
        
        path.move(to: CGPoint(x: layer.frame.maxX, y: layer.frame.maxY - 35))
        path.addLine(to: CGPoint(x: layer.frame.maxX, y: layer.frame.maxY))
        path.addLine(to: CGPoint(x: layer.frame.maxX - 35, y: layer.frame.maxY))
        
        layer.path = path.cgPath
        layer.lineWidth = 5
        layer.strokeColor = UIColor(red: 1, green: 61/255, blue: 148/255, alpha: 1).cgColor
        layer.fillColor = UIColor.clear.cgColor
        cameraView.layer.insertSublayer(layer, below: videoPreviewLayer)
    }
    
    func configureQRCodeReader() {
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Fail to get the camera device")
            return
        }
        do {
//            qrCodeFrameView = UIView()
//            if let qrCodeFrameView = qrCodeFrameView {
//                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
//                qrCodeFrameView.layer.borderWidth = 2
//                view.addSubview(qrCodeFrameView)
//                view.bringSubviewToFront(qrCodeFrameView)
//            }
            
            // 使用前一個裝置物件來取得AVCaptureDeviceInput類別的實例
            let input = try AVCaptureDeviceInput(device: captureDevice)
            // 在擷取session設定輸入裝置
            captureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [.qr]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = .resizeAspectFill
//            videoPreviewLayer?.frame = view.layer.bounds
            videoPreviewLayer?.frame.size = view.bounds.size
//            view.layer.addSublayer(videoPreviewLayer!)
            view.layer.insertSublayer(videoPreviewLayer!, at: 0)
            // 開始影片的擷取
            captureSession.startRunning()
        } catch {
            print(error)
            return
        }
    }
    
    @IBAction func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension QRCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//        // 檢查metadataObjects陣列為非空值，他至少需包含一個物件
//        if metadataObjects.count == 0 {
//            qrCodeFrameView?.frame = .zero
//        }
//        // 取得元資料(metadata)物件
//        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
//
//        if metadataObj.type == .qr {
//            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
//            qrCodeFrameView?.frame = barCodeObject!.bounds
//
//            if metadataObj.stringValue != nil {
//
//            }
//        }
        if let metaDataObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           metaDataObj.type == .qr,
           let str = metaDataObj.stringValue {
            print("回吐qrcode:\(str)")
            captureSession.stopRunning()
            
            let qrcode = str
            
            QRCodeService.shared.storeConfirm(storeAcc: Global.ACCOUNT, storePwd: Global.ACCOUNT_PASSWORD, qrcode: qrcode) { success, response in
                
                guard success else {
                    let errorMsg = response as! String
                    Alert.showMessage(title: "", msg: errorMsg, vc: self) {
                        self.dismiss(animated: true, completion: nil)
                    }
                    return
                }
                
                Alert.showMessage(title: "", msg: "核銷完成", vc: self) {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            print("錯誤metaData")
        }
    }
}
