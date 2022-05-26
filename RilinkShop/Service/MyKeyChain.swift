//
//  MyKeyChain.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/10.
//

import Foundation

class MyKeyChain {
    
    static func setAccount(_ account: String) {
        guard account != "" else {
            UserDefaults.standard.removeObject(forKey: "account")
            return
        }
        UserDefaults.standard.set(account, forKey: "account")
    }
    static func getAccount() -> String? {
        guard let account = UserDefaults.standard.string(forKey: "account"), account != "" else {
            return nil
        }
//        let decrypt = self.decryptString(account)
        return account
    }
    static func setPassword(_ password: String) {
        guard password != "" else{
            UserDefaults.standard.removeObject(forKey: "password")
            return
        }
//        let encrypt = self.encryptString(password)
        UserDefaults.standard.set(password, forKey: "password")
    }
    static func getPassword() -> String? {
        guard let password = UserDefaults.standard.string(forKey: "password"), password != "" else{
            return nil
        }
//        let decrypt = self.decryptString(password)
        return password
    }
    
    static func setBossAccount(_ account: String) {
        guard account != "" else {
            UserDefaults.standard.removeObject(forKey: "bossaccount")
            return
        }
        UserDefaults.standard.set(account, forKey: "bossaccount")
    }
    static func getBossAccount() -> String? {
        guard let account = UserDefaults.standard.string(forKey: "bossaccount"), account != "" else {
            return nil
        }
        return account
    }
    
    static func setBossPassword(_ password: String) {
        guard password != "" else {
            UserDefaults.standard.removeObject(forKey: "bosspassword")
            return
        }
        UserDefaults.standard.set(password, forKey: "bosspassword")
    }
    static func getBossPassword() -> String? {
        guard let password = UserDefaults.standard.string(forKey: "bosspassword"), password != "" else{
            return nil
        }
        return password
    }
    static func logout() {
        MyKeyChain.setAccount("")
        MyKeyChain.setPassword("")
        MyKeyChain.setBossAccount("")
        MyKeyChain.setBossPassword("")
        Global.ACCOUNT = ""
        Global.ACCOUNT_PASSWORD = ""
        UserService.shared.didLogin = false
    }
}
