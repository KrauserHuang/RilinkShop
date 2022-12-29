//
//  LocalStorageManager.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/12/23.
//

import Foundation

class LocalStorageManager {
    
    /// This is the keys for every value. We can add a new key here if we need to asve any new value with new category.
    enum LocalStorageKeys: String, CaseIterable {
        case userIdKey
        case userPasswordKey
        case hasLoggedIn
        case adminIdKey
        case adminPasswordKey
    }
    
    static let shared = LocalStorageManager()
    private let defaults = UserDefaults.standard
    private init() {}
    
//    func setAccount(_ account: String) {
//        defaults.set(account, forKey: LocalStorageKeys.userIdKey.rawValue)
//    }
//    
//    func getAccount() -> String? {
//        defaults.object(forKey: LocalStorageKeys.userIdKey.rawValue) as? String
//    }
//    
//    func setPassword(_ password: String) {
//        defaults.set(password, forKey: LocalStorageKeys.userPasswordKey.rawValue)
//    }
//    
//    func getPassword() -> String? {
//        defaults.object(forKey: LocalStorageKeys.userPasswordKey.rawValue) as? String
//    }
    
    /// Set the UserDefaults data to the device.
    /// - Parameters:
    ///   - value: The value that will be stored.
    ///   - key: The category of the value. (Unique, hence key)
    func setData<T>(_ value: T, key: LocalStorageKeys) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    /// Get the data of the UserDefaults. This will return a generic type.
    /// - Parameters:
    ///   - type: The type of the supposed value. ie: Int.self, String.self, etc.
    ///   - key: The category.
    /// - Returns: The value either exist or not.
    func getData<T>(_ type: T.Type, forKey key: LocalStorageKeys) -> T? {
        defaults.object(forKey: key.rawValue) as? T
    }
    
    func removeData(key: LocalStorageKeys) {
        defaults.removeObject(forKey: key.rawValue)
    }
}

@propertyWrapper
struct UserDefault<T: PropertyListValue> {
    let key: Key
    let defaults = UserDefaults.standard

    var wrappedValue: T? {
        get { defaults.value(forKey: key.rawValue) as? T}
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
}

protocol PropertyListValue {}

extension Data: PropertyListValue {}
extension String: PropertyListValue {}
extension Date: PropertyListValue {}
extension Bool: PropertyListValue {}
extension Int: PropertyListValue {}
extension Double: PropertyListValue {}
extension Float: PropertyListValue {}

extension Array: PropertyListValue where Element: PropertyListValue {}
extension Dictionary: PropertyListValue where Key == String, Value: PropertyListValue {}

struct Key: RawRepresentable {
    let rawValue: String
}

extension Key: ExpressibleByStringLiteral {
    init(stringLiteral: String) {
        rawValue = stringLiteral
    }
    
    static let isFirstLaunch: Key = "isFirstLaunch"
}
