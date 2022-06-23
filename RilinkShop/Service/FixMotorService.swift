//
//  FixMotorService.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/6/22.
//

import Foundation
import Alamofire
import SwiftyJSON

class FixMotorService {
    static let shared = FixMotorService()
    
    func storeBookingTime(id: String, pwd: String, storeId: String, completion: @escaping Completion) {
        let url = SHOP_API_URL + URL_FIXMOTORINFO
        let parameters = [
            "member_id": id,
            "member_pwd": pwd,
            "store_id": storeId
        ]
        let returnCode = ReturnCode.MALL_RETURN_SUCCESS.0
        
        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
            
            guard response.error == nil else {
                let errorMsg = "伺服器連線失敗"
                completion(false, errorMsg as AnyObject)
                return
            }
            
            let value = JSON(response.value)
            
            switch response.result {
            case .success:
                
                guard value["code"].stringValue == returnCode else {
                    let errorMsg = value["responseMessage"].stringValue
                    completion(false, errorMsg as AnyObject)
                    return
                }
                
                let successMsg = value["data"].arrayValue
                completion(true, successMsg as AnyObject)
            case .failure:
                let errorMsg = value["responseMessage"].stringValue
                completion(false, errorMsg as AnyObject)
            }
        }
    }
    
    func bookingFixMotor(id: String, pwd: String, storeId: String, bookingdate: String, duration: String, name: String, phone: String, motorNo: String, motorType: String, fixType: String, description: String, completion: @escaping Completion) {
        let url = SHOP_API_URL + URL_BOOKINGFIXMOTOR
        let parameters = [
            "member_id": id,
            "member_pwd": pwd,
            "store_id": storeId,
            "bookingdate": bookingdate,
            "duration": duration,
            "name": name,
            "phone": phone,
            "motor_no": motorNo,
            "motor_type": motorType,
            "fixtype": fixType
        ]
        
        let returnCode = ReturnCode.MALL_RETURN_SUCCESS.0
        
        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
            guard response.error == nil else {
                let errorMsg = "伺服器連線失敗"
                completion(false, errorMsg as AnyObject)
                return
            }
            
            let value = JSON(response.value)
            
            switch response.result {
            case .success:
                
                guard value["code"].stringValue == returnCode else {
                    let errorMsg = value["responseMessage"].stringValue
                    completion(false, errorMsg as AnyObject)
                    return
                }
                
                let successMsg = value["responseMessage"].arrayValue
                completion(true, successMsg as AnyObject)
            case .failure:
                let errorMsg = value["responseMessage"].stringValue
                completion(false, errorMsg as AnyObject)
            }
        }
    }
}
