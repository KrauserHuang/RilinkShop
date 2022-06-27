//
//  StoreService.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/10.
//

import Foundation
import Alamofire

class StoreService {
    static let shared = StoreService()
    
    func getStoreType(id: String, pwd: String, completion: @escaping ([StoreType]) -> Void) {
        let url = SHOP_API_URL + URL_STORETYPE
        let parameters = [
            "member_id": id,
            "member_pwd": pwd
        ]
        
        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [StoreType].self) { response in
            print(response)
            guard let storeType = response.value else { return }
            completion(storeType)
        }
    }
    
//    func getStoreList(id: String, pwd: String, type: String, completion: @escaping ([Store]) -> Void) {
//        let url = SHOP_API_URL + URL_STORELIST
//        let parameters = [
//            "member_id": id,
//            "member_pwd": pwd,
//            "store_type": type
//        ]
//
//        AF.request(url, method: .post, parameters: parameters).validate().responseDecodable(of: [Store].self) { response in
//            guard let storeList = response.value else { return }
//            completion(storeList)
//        }
//    }
    
    func getStoreList(id: String, pwd: String, completion: @escaping ([Store]) -> Void) {
        let url = SHOP_API_URL + URL_STORELIST
        let parameters = [
            "member_id": id,
            "member_pwd": pwd,
        ]
        
        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [Store].self) { response in
            print(#function)
//            print(response)
            guard let storeList = response.value else { return }
            print(storeList)
            completion(storeList)
        }
    }
}
