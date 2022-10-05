//
//  WebAPI.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/9/28.
//

import Foundation
import UIKit.UIImage
import CryptoKit

class WebAPI: NSObject {
    //    singleton
    static let shared = WebAPI()
    private override init() {}
    let HttpSecretToken = ""
    /**
     parameters = [參數1名稱:參數1內容,參數2名稱:參數2內容,...]
     */
    func request(urlStr: String, parameters: [String: Any], method: String = "POST", useMd5: Bool = false, completion: @escaping(_ status: Bool, _ data: Data?, _ error: Error?) -> Void) {
        var paraStr = ""
        for parameter in parameters {
            if paraStr != "" {
                paraStr += "&"
            }
            paraStr += "\(parameter.key)=\(parameter.value)"
        }
        self.request(urlString: urlStr, parameters: paraStr, completion: completion)
    }

    /**
    parameters = "參數1名稱=參數1內容&參數2名稱=參數2內容..."
     */
    func request(urlString: String, parameters: String, method: String = "POST", useMd5: Bool = false, completion: @escaping(_ status: Bool, _ data: Data?, _ error: Error?) -> Void) {
        var urlStr = urlString
        if method == "GET", parameters != "" {
            urlStr += "?" + parameters
        }
        guard let url = URL(string: urlStr) else {
            print("rulError:\(urlString)")
            DispatchQueue.main.async {
                completion(false, nil, nil)
            }
            return
        }
        var request = URLRequest(url: url)
//        預設為GET，POST需再設定
        if method == "POST" {
            request.httpMethod = "POST"
            request.httpBody = parameters.data(using: .utf8)
        }
        if useMd5 {
            if #available(iOS 13.0, *) {
                let dateformat = DateFormatter()
                dateformat.dateFormat = "yyyyMMdd"
                let headString = HttpSecretToken + dateformat.string(from: Date())
                let md5 = Insecure.MD5.hash(data: headString.data(using: .utf8)!)
                let md5Str = md5.map({ String(format: "%02hhx", $0) }).joined()
                request.addValue(md5Str, forHTTPHeaderField: "Authorization")
            }
        }

        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
        session.dataTask(with: request) { data, response, error in
            if let err = error as NSError?, err.domain == NSURLErrorDomain {
                print("url:\(url)")
                print("errorCode:\(err.code)")
                print("description:\(err.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false, data, error)
                }
                session.invalidateAndCancel()
                return
            }
            guard error == nil else {
                print("url:\(url)")
                print("error:\(error)")
                DispatchQueue.main.async {
                    completion(false, data, error)
                }
                session.invalidateAndCancel()
                return
            }
//            確認網路回傳狀態是否成功
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                print("url:\(url)")
                print("responseError:\(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                DispatchQueue.main.async {
                    completion(false, data, error)
                }
                session.invalidateAndCancel()
                return
            }
//            確認回傳JSON的status是不是false
            if let data = data, let results = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any], results["status"] as? String == "false" {
                print("url:\(url)")
                print("errorData:\(String(describing: data))")
                print(results)
                DispatchQueue.main.async {
                    completion(false, data, error)
                }
                session.invalidateAndCancel()
                return
            }
            DispatchQueue.main.async {
                completion(true, data, error)
            }
            session.invalidateAndCancel()
        }.resume()
    }

    func requestImage(urlString: String, completion: @escaping((UIImage) -> Void)) {
        guard let picUrl = URL(string: urlString) else {
            print("url:\(urlString)")
            print("urlError\(urlString)")
            return
        }
        let session = URLSession(configuration: .default)
        session.dataTask(with: picUrl) { data, _, error in
            if let error = error {
                print("url:\(urlString)")
                print(error.localizedDescription)
            }
            guard let data = data, let image = UIImage(data: data) else {
                print("url:\(urlString)")
                print("dataError")
                return
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
