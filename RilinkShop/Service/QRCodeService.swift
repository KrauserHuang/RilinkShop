//
//  QRCodeService.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/11.
//

import Foundation
import Alamofire
import SwiftyJSON

enum ispackage: Int { //訂單類型
    case product
    case package
}

class QRCodeService {
    static let shared = QRCodeService()
    var theqrcodes = [String]()
    // 會員未核銷商品/套票
    func unconfirmList(id: String, pwd: String, ispackage: String, completion: @escaping ([UNQRCode]) -> Void) {
        let url = SHOP_API_URL + URL_QRUNCONFIRMLIST
        let parameters = [
            "member_id": id,
            "member_pwd": pwd,
            "ispackage": ispackage
        ]
        
        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [UNQRCode].self) { response in
//            print(response)
            guard response.value != nil else {
                print(#function)
                print("伺服器連線失敗")
                return
            }
            
//            print(#function)
//            print(response.value)
            
            switch response.result {
            case .success:
                guard let unconfirmList = response.value else { return }
                completion(unconfirmList)
            case .failure:
                print(response.error as Any)
            }
        }
    }
//    func unconfirmList(id: String, pwd: String, ispackage: String, completed: @escaping Completion) {
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
//                var unconfirmList: [UNQRCode] = []
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
//                    unconfirmList.append(unconfirm)
//                }
//
//                print(unconfirmList)
//                completed(true, unconfirmList as AnyObject)
//            case .failure:
//                let errorMsg = value["responseMessage"].stringValue
//                completed(false, errorMsg as AnyObject)
//            }
//        }
//    }
    // 會員已核銷商品/套票
    func confirmList(id: String, pwd: String, ispackage: String, completion: @escaping ([QRCode]) -> Void) {
        let url = SHOP_API_URL + URL_QRCONFIRMLIST
        let parameters = [
            "member_id": id,
            "member_pwd": pwd,
            "ispackage": ispackage
        ]
        
        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [QRCode].self) { response in
//            print("+++++")
//            print(response)
            guard response.value != nil else {
                print(#function)
                print("伺服器連線失敗")
                return
            }
//            print("+++++")
//            print(#function)
//            print(response.value)
            
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
            print(#function)
            print("value:\(value)")
//            print("result:\(response.result)")
            
            switch response.result {
            case .success:
//                guard value["code"].stringValue == returnCode else {
//                    let errorMsg = value["responseMessage"].stringValue
//                    completed(false, errorMsg as AnyObject)
//                    return
//                }

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
    func storeConfirm(storeAcc: String, storePwd: String, qrcode: String, completion: @escaping (Output) -> Void) {
        let url = SHOP_API_URL + URL_STOREAPPQRCONFIRM
        let parameters = [
            "store_acc": storeAcc,
            "store_pwd": storePwd,
            "qrcode": qrcode
        ]
        
        AF.request(url, method: .post, parameters: parameters).validate().responseDecodable(of: Output.self) { response in
            print("@@@@@")
            print(response)
            switch response.result {
            case .success(let output):
                print("*****")
                print(output.responseMessage)
                completion(output)
            case .failure(let error):
                print("!!!!!")
                print(error)
            }
        }
    }
    func storeConfirm(storeAcc: String, storePwd: String, qrcode: String, completed: @escaping Completion) {
        let url = SHOP_API_URL + URL_STOREAPPQRCONFIRM
        let parameters = [
            "store_acc": storeAcc,
            "store_pwd": storePwd,
            "qrcode": qrcode
        ]
        
        let returnCode = ReturnCode.MALL_RETURN_SUCCESS.0
        
        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
            
            guard response.value != nil else {
                let message = "伺服器連線失敗"
                completed(false, message as AnyObject)
                return
            }
            
            let value = JSON(response.value!)
            print(#function)
            print(value)
            
            switch response.result {
            case .success:
                guard value["code"].stringValue == returnCode else {
                    let message = value["responseMessage"].stringValue
                    completed(false, message as AnyObject)
                    return
                }
                
                let message = value["responseMessage"].stringValue
                completed(true, message as AnyObject)
            case .failure:
                let message = value["responseMessage"].stringValue
                completed(false, message as AnyObject)
            }
        }
    }
}
