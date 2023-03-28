//
//  QRCodeService.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/11.
//

import Foundation
import Alamofire
import SwiftyJSON



class QRCodeService {
    static let shared = QRCodeService()
    var theqrcodes = [String]()
    
    enum QRListType: Int { // 0: 商品, 1: 套票
        case product
        case package
    }
    // 會員未核銷商品/套票
    func getQRUnconfirmList(type: QRListType, completion: @escaping ([QRCode]) -> Void) {
        let url = SHOP_API_URL + URL_QRUNCONFIRMLIST
        let parameters = [
            "member_id": Global.ACCOUNT,
            "member_pwd": Global.ACCOUNT_PASSWORD,
            "ispackage": "\(type.rawValue)"
        ]

        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [QRCode].self) { response in
            guard response.value != nil else {
                print("伺服器連線失敗")
                return
            }

            switch response.result {
            case .success:
                guard let unconfirmList = response.value else { return }
                completion(unconfirmList)
            case .failure:
                print(response.error as Any)
            }
        }
    }
//    func getQRUnconfirmList(id: String, pwd: String, ispackage: String, completed: @escaping Completion) {
//        let url = SHOP_API_URL + URL_QRUNCONFIRMLIST
//        let parameters = [
//            "member_id": id,
//            "member_pwd": pwd,
//            "ispackage": ispackage
//        ]
//        let returnCode = ReturnCode.MALL_RETURN_SUCCESS.0
//
//        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
//
//            guard response.value != nil else {
//                let errorMsg = "伺服器連線失敗"
//                completed(false, errorMsg as AnyObject)
//                return
//            }
//
//            let value = JSON(response.value!)
//            print(#function)
//            print(value)
//
//            switch response.result {
//            case .success:
//
//                guard value["code"].stringValue == returnCode else {
//                    let errorMsg = value["responseMessage"].stringValue
//                    completed(false, errorMsg as AnyObject)
//                    return
//                }
//
//                var getQRUnconfirmList: [UNQRCode] = []
//                for value in value.arrayValue {
//                    let unconfirm = UNQRCode(orderNo: value["order_no"].stringValue,
//                                             orderDate: value["order_date"].stringValue,
//                                             productName: value["product_name"].stringValue,
//                                             storeID: value["store_id"].stringValue,
//                                             productPicture: value["product_picture"].stringValue,
//                                             qrconfirm: value["qrconfirm"].stringValue,
//                                             storeName: value["store_name"].stringValue,
//                                             packageName: value["package_name"].stringValue,
//                                             packagePicture: value["package_picture"].stringValue,
//                                             product: value["product"])
//                    getQRUnconfirmList.append(unconfirm)
//                }
//
//                print(getQRUnconfirmList)
//                completed(true, getQRUnconfirmList as AnyObject)
//            case .failure:
//                let errorMsg = value["responseMessage"].stringValue
//                completed(false, errorMsg as AnyObject)
//            }
//        }
//    }
    // 會員已核銷商品/套票
    func getQRConfirmList(type: QRListType, completion: @escaping ([QRCode]) -> Void) {
        let url = SHOP_API_URL + URL_QRCONFIRMLIST
        let parameters = [
            "member_id": Global.ACCOUNT,
            "member_pwd": Global.ACCOUNT_PASSWORD,
            "ispackage": "\(type.rawValue)"
        ]

        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [QRCode].self) { response in
            
            guard response.value != nil else {
                print(#function)
                print("伺服器連線失敗")
                return
            }

            switch response.result {
            case .success:
                guard let confirmList = response.value else { return }
                completion(confirmList)
            case .failure:
                print(response.error as Any)
            }
        }
    }
    func confirmList(id: String, pwd: String, ispackage: String, completed: @escaping Completion) {
        let url = SHOP_API_URL + URL_QRCONFIRMLIST
        let parameters = [
            "member_id": id,
            "member_pwd": pwd,
            "ispackage": ispackage
        ]
        let returnCode = ReturnCode.MALL_RETURN_SUCCESS.0

        AF.request(url, method: .post, parameters: parameters).responseJSON { response in

            guard response.value != nil else {
                let errorMsg = "伺服器連線失敗"
                completed(false, errorMsg as AnyObject)
                return
            }

            let value = JSON(response.value!)

            switch response.result {
            case .success:
                let datas = value["returnData"].arrayValue
                var qrcodes: [QRCode] = []
                for data in datas {
                    let qrcode = QRCode(orderNo: data["order_no"].stringValue,
                                        orderDate: data["order_date"].stringValue,
                                        productName: data["product_name"].stringValue,
                                        productPicture: data["product_picture"].stringValue,
                                        storeID: data["store_id"].stringValue,
                                        qrconfirm: data["qrconfirm"].stringValue,
                                        storeName: data["store_name"].stringValue,
                                        packageName: data["package_name"].stringValue,
                                        packagePicture: data["package_picture"].stringValue,
                                        product: data["product"].arrayValue as? [PackageProduct])
                    qrcodes.append(qrcode)
                }
                print(qrcodes)
                completed(true, qrcodes as AnyObject)
            case .failure:
                let errorMsg = value["responseMessage"].stringValue
                completed(false, errorMsg as AnyObject)
            }
        }
    }
    // 店家核銷商品/套票
    func storeConfirm(storeAcc: String, storePwd: String, qrcode: String, completion: @escaping Completion) {
        let url = SHOP_API_URL + URL_STOREAPPQRCONFIRM
        let parameters = [
            "store_acc": storeAcc,
            "store_pwd": storePwd,
            "qrcode": qrcode
        ]
        let returnCode = ReturnCode.MALL_RETURN_SUCCESS.0

        AF.request(url, method: .post, parameters: parameters).validate().response { response in
            
            guard response.error == nil else {
                completion(false, RSError.connectionFailure as AnyObject)
                return
            }
            
            let value = JSON(response.value!)
            
            switch response.result {
            case .success:
                guard value["code"].stringValue == returnCode else {
                    let message = value["responseMessage"].stringValue
                    completion(false, message as AnyObject)
                    return
                }

                let message = value["responseMessage"].stringValue
                completion(true, message as AnyObject)
            case .failure:
                let errorMsg = value["responseMessage"].stringValue
                completion(false, errorMsg as AnyObject)
            }
        }
    }
}
