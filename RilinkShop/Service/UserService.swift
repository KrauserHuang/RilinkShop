//
//  UserService.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/4.
//

import Foundation
import Alamofire

class UserService {
    static let shared = UserService()
    var id = "0910619306"
    var pwd = "a12345678"
    
    func didUserLogin(id: String, pwd: String, completion: @escaping (User) -> Void) {
        let url = TEST_API_URL + URL_USERLOGIN
        let parameters = [
            "member_id": id,
            "member_pwd": pwd
        ]
        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: User.self) { response in
//            debugPrint(response.value)
        }
    }
    
    func editUser(id: String, pwd: String, name: String, gender: String, email: String, birthday: String, address: String, phone: String, completion: @escaping (User) -> Void) {
        let url = TEST_API_URL + URL_USEREDIT
        let parameters = [
            "member_id": id,
            "member_pwd": pwd,
            "member_name": name,
            "member_gender": gender,
            "member_email": email,
            "member_birthday": birthday,
            "member_address": address,
            "member_phone": phone
        ]
        AF.request(url, method: .post, parameters: parameters).validate().responseDecodable(of: User.self) { response in
//            debugPrint(response)
        }
    }
    
    func getUserData(id: String, pwd: String, completion: @escaping (User) -> Void) {
        let url = TEST_API_URL + URL_USERGETDATA
        let parameters = [
            "member_id": id,
            "member_pwd": pwd
        ]
        AF.request(url, method: .post, parameters: parameters).validate().responseDecodable(of: User.self) { response in
            guard let user = response.value else { return }
            completion(user)
        }
    }
}
