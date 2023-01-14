//
//  UserService.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/4.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserService {
    static let shared = UserService()
    private(set) var user: User?
//    var id = Global.ACCOUNT
//    var pwd = Global.ACCOUNT_PASSWORD
    var didLogin = false
    var renewUser: (() -> Void)?

    private init() {
//        guard let account = LocalStorageManager.shared.getData(String.self, forKey: .userIdKey),
//              let password = LocalStorageManager.shared.getData(String.self, forKey: .userPasswordKey) else {
        guard let account = MyKeyChain.getAccount(), let password = MyKeyChain.getPassword() else {
            didLogin = true
            return
        }
        getPersonalData(account: account, pw: password, accountType: "0") { success, response in
            guard success else {
                self.renewUser?()
                return
            }
            Global.personalData = response as? User
            self.user = Global.personalData
//            self.id = account
//            self.pwd = password

            self.didLogin = true
            self.renewUser?()
        }
    }

    private func loadUser(account: String, password: String) {
        print("UserService " + #function)
        print("account:\(account)\npassword:\(password)")
        let url = SHOP_API_URL + URL_USERLOGIN
        let parameters = [
            "member_id": account,
            "member_pwd": password
        ]

        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value) :
                let json = JSON(value)
                print(json)
                self.setUser(account: account, password: password, from: json.rawValue as! [ String: Any])
            case .failure(let error) :
                print(error)
                self.renewUser?()
            }
        }
    }

    private func setUser(account: String, password: String, from dict: [String: Any]) {
        print("UserService " + #function)
        print("account:\(account)\npassword:\(password)")
    }

    func reloadUser() {
        print("UserService " + #function)
        guard let user = user else { return }
//        loadUser(id: user.memberId, pw: user.password)
    }
    // MARK: - 使用者登入Login
    func userLogin(id: String, pwd: String, completed: @escaping Completion) {
        let url = SHOP_API_URL + URL_USERLOGIN
        let parameters = [
            "member_id": id,
            "member_pwd": pwd
        ]
        let returnCode = ReturnCode.MALL_RETURN_SUCCESS.0

        AF.request(url, method: .post, parameters: parameters).response { response in
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
                    let errorMsg = value["responseMessage"].stringValue
                    completed(false, errorMsg as AnyObject)
                    return
                }

                let successMsg = value["responseMessage"].stringValue
//                LocalStorageManager.shared.setData(id, key: .userIdKey)
//                LocalStorageManager.shared.setData(pwd, key: .userPasswordKey)
                MyKeyChain.setAccount(id)
                MyKeyChain.setPassword(pwd)
//                self.id = id
//                self.pwd = pwd

                self.getPersonalData(account: id, pw: pwd, accountType: "0") { success, response in
                    guard success else {
                        self.renewUser?()
                        return
                    }
                    Global.personalData = response as? User
                    self.user = Global.personalData
                    self.didLogin = true
                    self.renewUser = { completed(true, "" as AnyObject) }
                }

                completed(true, successMsg as AnyObject)
            case .failure:
                let errorMsg = value["responseMessage"].stringValue
                completed(false, errorMsg as AnyObject)
            }
        }
    }
    // 取得使用者資料MemberInfoViewController
    func getUserData(id: String, pwd: String, completion: @escaping (UserResponse) -> Void) {
        let url = SHOP_API_URL + URL_USERGETDATA
        let parameters = [
            "member_id": id,
            "member_pwd": pwd
        ]
        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: UserResponse.self) { response in

//            print(#function)
//            print(response.value)

            guard response.value != nil else {
                print(response.error as Any)
                return
            }

            switch response.result {
            case .success:
                guard let user = response.value else { return }
                completion(user)
            case .failure:
                print(response.error as Any)
            }
        }
    }
    // 獲取個人資料
    func getPersonalData(account: String, pw: String, accountType: String, completed: @escaping Completion) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]

        let parameters: Parameters = ["account": Base64(string: account),
                                      "pw": Base64(string: pw),
                                      "accountType": Base64(string: accountType)
        ]

        let url =  API_URL + GET_PERSONAL_DATA
        let httpMethod = HTTPMethod.post
        let returnCode = ReturnCode.RETURN_SUCCESS.0

        AF.request(url, method: httpMethod, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in

            guard response.value != nil else {
                let message = "伺服器連線失敗"
                completed(false, message as AnyObject)
                return
            }

            let value = JSON(response.value!)
//            print(#function)
//            print(value)

            switch response.result {
            case .success:

                guard value["returnCode"].intValue == returnCode else {
                    let message = value["errorMsg"].stringValue
                    completed(false, message  as AnyObject)
                    return
                }

                let data = value["returnData"]
                let personal = User(account: data["account"].stringValue,
                                    tel: data["tel"].stringValue,
                                    name: data["name"].stringValue,
                                    email: data["email"].stringValue,
                                    sex: data["sex"].stringValue,
                                    address: data["address"].stringValue,
                                    birthday: data["birthday"].stringValue,
                                    point: data["point"].stringValue,
                                    cmdImageFile: data["cmdImageFile"].stringValue,
                                    accountType: data["accountType"].stringValue,
                                    referrerCount: data["referrerCount"].stringValue,
                                    mobileType: data["mobileType"].stringValue,
                                    city: data["city"].stringValue,
                                    referrerPhone: data["referrerPhone"].stringValue,
                                    region: data["region"].stringValue,
                                    imageName: data["imageName"].stringValue)

                completed(true, personal as AnyObject)

            case .failure:
                let message = value["errorMsg"].stringValue
                completed(false, message as AnyObject)
            }
        }
    }
    // 編修個人資料
    func modifyPersonalData(account: String, pw: String, accountType: String, name: String, tel: String, birthday: String, email: String, sex: String, city: String, region: String, address: String, completed: @escaping Completion) {

        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]

        let parameters: Parameters = ["account": Base64(string: account),
                                      "pw": Base64(string: pw),
                                      "accountType": Base64(string: accountType),
                                      "name": Base64(string: name),
                                      "tel": Base64(string: tel),
                                      "birthday": Base64(string: birthday),
                                      "email": Base64(string: email),
                                      "address": Base64(string: address),
                                      "sex": Base64(string: sex),
                                      "city": Base64(string: city),
                                      "region": Base64(string: region)
        ]
        
//        print("parameters:\(parameters)")
//        dump(parameters)

        let url =  API_URL + MODIFY_PERSONAL_DATA
        let httpMethod = HTTPMethod.post
        let returnCode = ReturnCode.RETURN_SUCCESS.0

        AF.request(url, method: httpMethod, parameters: parameters, encoding: URLEncoding.default, headers: headers).response { (response) in

            guard response.error == nil else {
                let message = "伺服器連線失敗"
                completed(false, message as AnyObject)
                return
            }

            let value = JSON(response.value!)
            print(#function)
            print(value)

            switch response.result {
            case .success:
                guard value["returnCode"].intValue == returnCode else {
                    let message = value["errorMsg"].stringValue
                    completed(false, message as AnyObject)
                    return
                }
                completed(true, "修改完成" as AnyObject)

            case .failure:
                let message = value["errorMsg"].stringValue
                completed(false, message as AnyObject)
            }
        }
    }
    // 上傳照片
    func uploadImage(imgtitle: String, cmdImageFile: UIImage, completed: @escaping Completion) {
        let url = API_URL + UPLOAD_IMAGE
        let returnCode = ReturnCode.RETURN_SUCCESS.0
        let imgData = cmdImageFile.jpegData(compressionQuality: 0.75)!

        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "cmdImageFile", fileName: "image.jpg", mimeType: "image/jpg")
            multipartFormData.append(Base64(string: Global.ACCOUNT).data(using: .utf8)!, withName: "account")
            multipartFormData.append(Base64(string: Global.ACCOUNT_PASSWORD).data(using: .utf8)!, withName: "pw")
            multipartFormData.append(Base64(string: Global.ACCOUNT_TYPE).data(using: .utf8)!, withName: "accountType")
            multipartFormData.append(Base64(string: imgtitle).data(using: .utf8)!, withName: "imgtitle")
        }, to: url).responseJSON { response in

            guard response.value != nil else {
                let errorMsg = "伺服器連線失敗"
                completed(false, errorMsg as AnyObject)
                return
            }

            let value = JSON(response.value!)
            print(#function)
            print(value)

            switch response.result {
            case .success:
                guard value["returnCode"].intValue == returnCode else {
                    let errorMsg = value["errorMsg"].stringValue
                    completed(false, errorMsg as AnyObject)
                    return
                }
                completed(true, "" as AnyObject)
            case .failure:
                let errorMsg = value["errorMsg"].stringValue
                completed(false, errorMsg as AnyObject)
            }
        }
    }
    // 登出
    func logout() {
        print("UserService + \(#function)")
        user = nil
        renewUser = nil
//        id = ""
//        pwd = ""
        Global.ACCOUNT = ""
        Global.ACCOUNT_PASSWORD = ""
        Global.personalData = nil
//        LocalStorageManager.shared.removeData(key: .userIdKey)
//        LocalStorageManager.shared.removeData(key: .userPasswordKey)
        MyKeyChain.setAccount("")
        MyKeyChain.setPassword("")
        MyKeyChain.setBossAccount("")
        MyKeyChain.setBossPassword("")
        didLogin = false
    }
    // MARK: - 註冊1 - 傳送手機驗證號碼
    func signUp(account: String, completed: @escaping Completion) {
//        let headers: HTTPHeaders = [
//            "Content-Type": "application/x-www-form-urlencoded"
//        ]

        let parameters: Parameters = ["account": Base64(string: account),
                                      "accountType": Base64(string: Global.ACCOUNT_TYPE)]

        let url =  API_URL + SIGN_UP
        let httpMethod = HTTPMethod.post

        AF.request(url, method: httpMethod, parameters: parameters).responseJSON { (response) in

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

                guard [101, 102, 103].contains(value["returnCode"].intValue) else {
                    let message = value["errorMsg"].stringValue
                    completed(false, message  as AnyObject)
                    return
                }
                // 回傳成功時跳轉到驗證碼輸入畫面
                completed(true, value["returnCode"].intValue as AnyObject)

            case .failure:
                let message = value["errorMsg"].stringValue
                completed(false, message as AnyObject)
            }
        }
    }
    // MARK: - 註冊2 - 送出驗證/密碼
    func verifyCode(action: String, account: String, accountType: String, registeCode: String, pw: String, pw2: String, completed: @escaping Completion) {

        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]

        let parameters: Parameters = ["action": Base64(string: action),
                                      "account": Base64(string: account),
                                      "accountType": Base64(string: accountType),
                                      "registeCode": Base64(string: registeCode),
                                      "pw": Base64(string: pw),
                                      "pw2": Base64(string: pw2)
        ]

        let url =  API_URL + VERIFY_CODE
        let httpMethod = HTTPMethod.post
        let returnCode = ReturnCode.RETURN_SUCCESS.0

        AF.request(url, method: httpMethod, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in

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

                guard value["returnCode"].intValue == returnCode else {
                    let message = value["errorMsg"].stringValue
                    completed(false, message  as AnyObject)
                    return
                }
                completed(true, "" as AnyObject)

            case .failure:
                let message = value["errorMsg"].stringValue
                completed(false, message as AnyObject)
            }
        }

    }
    // MARK: - 註冊2 - 重送驗證碼
    func reSendCode(account: String, accountType: String, action: String, completed: @escaping Completion) {

        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]

        let parameters: Parameters = ["account": Base64(string: account),
                                      "accountType": Base64(string: accountType),
                                      "action": Base64(string: action)
        ]

        let url =  API_URL + RESEND_CODE
        let httpMethod = HTTPMethod.post
        let returnCode = ReturnCode.RETURN_SUCCESS.0

        AF.request(url, method: httpMethod, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in

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

                guard value["returnCode"].intValue == returnCode else {
                    let message = value["errorMsg"].stringValue
                    completed(false, message  as AnyObject)
                    return
                }
                completed(true, "" as AnyObject)

            case .failure:
                let message = value["errorMsg"].stringValue
                completed(false, message as AnyObject)
            }
        }
    }
    // MARK: - 註冊3 - 初始個人資料
    func InitPersonalData(account: String, pw: String, accountType: String, name: String, tel: String, birthday: String, email: String, sex: String, city: String, region: String, address: String, referrerPhone: String, completed: @escaping Completion) {

        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]

        let parameters: Parameters = ["account": Base64(string: account),
                                      "pw": Base64(string: pw),
                                      "accountType": Base64(string: accountType),
                                      "name": Base64(string: name),
                                      "tel": Base64(string: tel),
                                      "birthday": Base64(string: birthday),
                                      "email": Base64(string: email),
                                      "address": Base64(string: address),
                                      "sex": Base64(string: sex),
                                      "city": Base64(string: city),
                                      "region": Base64(string: region),
                                      "referrerPhone": Base64(string: referrerPhone)
        ]

        let url =  API_URL + MODIFY_PERSONAL_DATA
        let httpMethod = HTTPMethod.post
        let returnCode = ReturnCode.RETURN_SUCCESS.0

        AF.request(url, method: httpMethod, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in

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

                guard value["returnCode"].intValue == returnCode else {
                    let message = value["errorMsg"].stringValue
                    completed(false, message  as AnyObject)
                    return
                }
                completed(true, "" as AnyObject)

            case .failure:
                let message = value["errorMsg"].stringValue
                completed(false, message as AnyObject)
            }
        }
    }
    // MARK: - MALL - UPDATE PASSWORD
    func mallUpdatePassword(mobile: String, password: String, completed: @escaping Completion) {

        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let parameters: Parameters = ["mobile": mobile,
                                      "password": password]

        let url =  MALL_REWRITE_PWD
        let httpMethod = HTTPMethod.post

        AF.request(url, method: httpMethod, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in

            guard response.value != nil else {
                let message = "伺服器連線失敗"
                completed(false, message as AnyObject)
                return
            }

            let value = JSON(response.value!)
//            print(#function)
//            print(value)

            switch response.result {
            case .success:

                let code = value["code"].stringValue
                let responseStr = value["message"].stringValue

                guard ["0x0200"].contains(code) else {
                    completed(false, responseStr as AnyObject)
                    return
                }

                completed(true, responseStr as AnyObject)

            case .failure:
                let message = value["message"].stringValue
                completed(false, message as AnyObject)
            }
        }
    }
    // MARK: - 店長對應店家list
    func getStoreIDList(storeAcc: String, storePwd: String, completed: @escaping Completion) {
        let url = SHOP_API_URL + URL_STOREIDLIST
        let parameters = [
            "store_acc": storeAcc,
            "store_pwd": storePwd
        ]
        let returnCode = ReturnCode.MALL_RETURN_SUCCESS.0

        AF.request(url, method: .post, parameters: parameters).response { response in

            guard response.value != nil else {
                let message = "伺服器連線失敗"
                completed(false, message as AnyObject)
                return
            }

            let value = JSON(response.value!)

            switch response.result {
            case .success:

                guard value["code"].stringValue == returnCode else {
                    let message = value["errorMsg"].stringValue
                    completed(false, message  as AnyObject)
                    return
                }

                let datas = value["info"].arrayValue
                var storeIDs: [StoreIDInfo] = []
                for data in datas {
                    let storeID = StoreIDInfo(storeName: data["store_name"].stringValue,
                                           storeID: data["store_id"].stringValue)
                    storeIDs.append(storeID)
                }

//                print(storeIDs)
                completed(true, storeIDs as AnyObject)
            case .failure:
                let message = value["responseMessage"].stringValue
                completed(false, message as AnyObject)
            }
        }
    }

    func storeAdminLogin(storeAcc: String, storePwd: String, storeID: String, notificationToken: String, completed: @escaping Completion) {
        let url = SHOP_API_URL + URL_STOREADMINLOGIN
        let parameters = [
            "store_acc": storeAcc,
            "store_pwd": storePwd,
            "store_id": storeID,
            "notification_token": notificationToken
        ]
        let returnCode = ReturnCode.MALL_RETURN_SUCCESS.0

        AF.request(url, method: .post, parameters: parameters).response { response in

            guard response.value != nil else {
                let message = "伺服器連線失敗"
                completed(false, message as AnyObject)
                return
            }

            let value = JSON(response.value!)

            switch response.result {
            case .success:

                guard value["code"].stringValue == returnCode else {
                    let errorMsg = value["responseMessage"].stringValue
                    completed(false, errorMsg as AnyObject)
                    return
                }
                
                MyKeyChain.setBossAccount(storeAcc)
                MyKeyChain.setBossPassword(storePwd)
                Global.OWNER_STORE_ID = storeID

                let info = StoreInfo(storeName: value["store_name"].stringValue,
                                     storeAddress: value["store_address"].stringValue,
                                     storePhone: value["store_phone"].stringValue,
                                     storeEmail: value["store_email"].stringValue,
                                     storeDescript: value["store_descript"].stringValue,
                                     storeOpentime: value["store_opentime"].stringValue,
                                     storePicture: value["store_picture"].stringValue)
                completed(true, info as AnyObject)
            case .failure:
                let errorMsg = value["responseMessage"].stringValue
                completed(false, errorMsg as AnyObject)
            }
        }
    }

//    func storeAdminLogin(storeAcc: String, storePwd: String, storeID: String, completed: @escaping (StoreAdminLogin) -> Void) {
//        let url = SHOP_API_URL + URL_STOREADMINLOGIN
//        let parameters = [
//            "store_acc": storeAcc,
//            "store_pwd": storePwd,
//            "store_id": storeID
//        ]
//        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: StoreAdminLogin.self) { response in
//
//            guard response.value != nil else {
//                print(#function)
//                print("伺服器連線失敗")
//                return
//            }
//
////            print(#function)
//
//            switch response.result {
//            case .success:
//                guard let store = response.value else { return }
//                self.didLogin = true
//                completed(store)
//            case .failure:
//                print(response.error as Any)
//            }
//        }
//    }
    
    func storeAdminLogout(storeAcc: String, storePwd: String, storeID: String, completion: @escaping Completion) {
        let url = SHOP_API_URL + URL_STOREADMINLOGOUT
        let parameters = [
            "store_acc": storeAcc,
            "store_pwd": storePwd,
            "store_id": storeID
        ]
        let returnCode = ReturnCode.RETURN_SUCCESS.0
        
        AF.request(url, method: .post, parameters: parameters).response { response in
            
            guard response.value != nil else {
                let message = "伺服器連線失敗"
                completion(false, message as AnyObject)
                return
            }
            
            let value = JSON(response.value)
            print("===================================")
            print(value)
            print("===================================")
            
            switch response.result {
            case .success:
                guard value["code"].intValue == returnCode else {
                    let errorMsg = value["responseMessage"].stringValue
                    completion(false, errorMsg as AnyObject)
                    return
                }
                
                MyKeyChain.logout()
                let successMsg = value["responseMessage"].stringValue
                completion(true, successMsg as AnyObject)
            case .failure:
                let errorMsg = value["responseMessage"].stringValue
                completion(false, errorMsg as AnyObject)
            }
        }
    }

    func userDel(id: String, pwd: String, completed: @escaping Completion) {
        print("UserService " + #function)
        print("Account:\(id)\nPassword:\(pwd)")
        let url = SHOP_API_URL + URL_USERDEL
        let parameters = [
            "member_id": id,
            "member_pwd": pwd
        ]
        let returnCode = ReturnCode.MALL_RETURN_SUCCESS.0

        AF.request(url, method: .post, parameters: parameters).response { response in

            guard response.value != nil else {
                let message = "伺服器連線失敗"
                completed(false, message as AnyObject)
                return
            }

            let value = JSON(response.value!)
            print(value)

            switch response.result {
            case .success:

                guard value["code"].stringValue == returnCode else {
                    let errorMsg = value["responseMessage"].stringValue
                    completed(false, errorMsg as AnyObject)
                    return
                }

                let successMsg = value["responseMessage"].stringValue
                completed(true, successMsg as AnyObject)
            case .failure:
                let errorMsg = value["responseMessage"].stringValue
                completed(false, errorMsg as AnyObject)
            }
        }
    }
}
