//
//  NotificationService.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/11/22.
//

import Foundation
import Alamofire
import SwiftyJSON

class NotificationService {
    static let shared   = NotificationService()
    var token           = ""
    
    func memberSetToken(id: String, pwd: String, token: String, completion: @escaping Completion) {
        let url = SHOP_API_URL + URL_MEMBERSETTOKEN
        let parameters = [
            "member_id": id,
            "member_pwd": pwd,
            "notify_token": token
        ]
        let returnCode = ReturnCode.MALL_RETURN_SUCCESS.0
        
        AF.request(url, method: .post, parameters: parameters).response { response in
            
            guard response.error == nil else {
                completion(false, RSError.connectionFailure as AnyObject)
                return
            }
            
            let value = JSON(response.value)
            print(#function)
            print(value)
            
            switch response.result {
            case .success:
                guard value["code"].stringValue == returnCode else {
                    let errorMsg = value["responseMessage"].stringValue
                    completion(false, errorMsg as AnyObject)
                    return
                }
                let successMsg = value["responseMessage"].stringValue
                completion(true, successMsg as AnyObject)
            case .failure:
                let errorMsg = value["responseMessage"].stringValue
                completion(false, errorMsg as AnyObject)
            }
        }
    }
    
    func memberClearToken(id: String, pwd: String, completion: @escaping Completion) {
        let url = SHOP_API_URL + URL_MEMBERCLEARTOKEN
        let parameters = [
            "member_id": id,
            "member_pwd": pwd
        ]
        let returnCode = ReturnCode.MALL_RETURN_SUCCESS.0
        
        AF.request(url, method: .post, parameters: parameters).response { response in
            
            guard response.error == nil else {
                completion(false, RSError.connectionFailure as AnyObject)
                return
            }
            
            let value = JSON(response.value)
            print(#function)
            print(value)
            
            switch response.result {
            case .success:
                guard value["code"].stringValue == returnCode else {
                    let errorMsg = value["responseMessage"].stringValue
                    completion(false, errorMsg as AnyObject)
                    return
                }
                let successMsg = value["responseMessage"].stringValue
                completion(true, successMsg as AnyObject)
            case .failure:
                let errorMsg = value["responseMessage"].stringValue
                completion(false, errorMsg as AnyObject)
            }
        }
    }
    
    func pushMsgGetHistory(id: String, pwd: String, completion: @escaping Completion) {
        let url = SHOP_API_URL + URL_PUSHMSGGETHISTORY
        let parameters = [
            "member_id": id,
            "member_pwd": pwd
        ]
        let returnCode = ReturnCode.MALL_RETURN_SUCCESS.0
        
        AF.request(url, method: .post, parameters: parameters).response { response in
            
            guard response.error == nil else {
                completion(false, RSError.connectionFailure as AnyObject)
                return
            }
            
            let value = JSON(response.value)
            print(#function)
            print(value)
            
            switch response.result {
            case .success:
                guard value["code"].stringValue == returnCode else {
                    let errorMsg = value["responseMessage"].stringValue
                    completion(false, errorMsg as AnyObject)
                    return
                }
                
                let datas = value.arrayValue
                var histories: [History] = []
                for data in datas {
                    let history = History(type: data["type"].stringValue,
                                          title: data["title"].stringValue,
                                          message: data["message"].stringValue,
                                          log: data["log"].stringValue,
                                          push_datetime: data["push_datetime"].stringValue)
                    histories.append(history)
                }
                completion(true, histories as AnyObject)
            case .failure:
                let errorMsg = value["responseMessage"].stringValue
                completion(false, errorMsg as AnyObject)
            }
        }
    }
    
    func storeAdminGetNotifyHistory(storeAcc: String, storePwd: String, storeID: String, completion: @escaping Completion) {
        let url = SHOP_API_URL + URL_STOREADMINGETNOTIFYHISTORY
        let parameters = [
            "store_acc": storeAcc,
            "store_pwd": storePwd,
            "store_id": storeID
        ]
        let returnCode = ReturnCode.MALL_RETURN_SUCCESS.0
        
        AF.request(url, method: .post, parameters: parameters).response { response in
            
            guard response.error == nil else {
                completion(false, RSError.connectionFailure as AnyObject)
                return
            }
            
            let value = JSON(response.value)
            print(#function)
            print(value)
            
            switch response.result {
            case .success:
                guard value["code"].stringValue == returnCode else {
                    let errorMsg = value["responseMessage"].stringValue
                    completion(false, errorMsg as AnyObject)
                    return
                }
                
                let datas = value["data"].arrayValue
                var histories: [AdminHistory] = []
                for data in datas {
                    let history = AdminHistory(type: data["type"].stringValue,
                                               title: data["title"].stringValue,
                                               message: data["message"].stringValue,
                                               updatetime: data["updatetime"].stringValue)
                    histories.append(history)
                }
                completion(true, histories as AnyObject)
            case .failure:
                let errorMsg = value["responseMessage"].stringValue
                completion(false, errorMsg as AnyObject)
            }
        }
    }
    
    func storeAdminIsNotify(storeAcc: String, storePwd: String, storeID: String, completion: @escaping Completion) {
        let url = SHOP_API_URL + URL_STOREADMINISNOTIFY
        let parameters = [
            "store_acc": storeAcc,
            "store_pwd": storePwd,
            "store_id": storeID
        ]
        let returnCode = ReturnCode.MALL_RETURN_SUCCESS.0
        
        AF.request(url, method: .post, parameters: parameters).response { response in
            
            guard response.error == nil else {
                completion(false, RSError.connectionFailure as AnyObject)
                return
            }
            
            let value = JSON(response.value)
            print(#function)
            print(value)
            
            switch response.result {
            case .success:
                guard value["code"].stringValue == returnCode else {
                    let errorMsg = value["responseMessage"].stringValue
                    completion(false, errorMsg as AnyObject)
                    return
                }
                
                let status = value["data"].stringValue // on/off
                completion(true, status as AnyObject)
            case .failure:
                let errorMsg = value["responseMessage"].stringValue
                completion(false, errorMsg as AnyObject)
            }
        }
    }
    
    func storeAdminSetNotify(storeAcc: String, storePwd: String, storeID: String, isNotify: String, completion: @escaping Completion) {
        let url = SHOP_API_URL + URL_STOREADMINSETNOTIFY
        let parameters = [
            "store_acc": storeAcc,
            "store_pwd": storePwd,
            "store_id": storeID,
            "isnotify": isNotify
        ]
        let returnCode = ReturnCode.MALL_RETURN_SUCCESS.0
        
        AF.request(url, method: .post, parameters: parameters).response { response in
            
            guard response.error == nil else {
                completion(false, RSError.connectionFailure as AnyObject)
                return
            }
            
            let value = JSON(response.value)
            print(#function)
            print(value)
            
            switch response.result {
            case .success:
                guard value["code"].stringValue == returnCode else {
                    let errorMsg = value["responseMessage"].stringValue
                    completion(false, errorMsg as AnyObject)
                    return
                }
                
                let successMsg = value["responseMessage"].stringValue
                completion(true, successMsg as AnyObject)
            case .failure:
                let errorMsg = value["responseMessage"].stringValue
                completion(false, errorMsg as AnyObject)
            }
        }
    }
}
