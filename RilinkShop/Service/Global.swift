//
//  Global.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/17.
//

import Foundation
import MBProgressHUD

public class Global {
        
    static var ACCOUNT          = ""
    static var ACCOUNT_TYPE     = "0"
    static var ACCOUNT_PASSWORD = ""
    static var ACCESS_TOKEN     = ""
//    for 店長
    static var personalData: User?
}

public func Base64(string:String)->String {
    let data = string.data(using: .utf8)
    return data?.base64EncodedString(options: .lineLength64Characters) ?? ""
}

class Alert {
    
    class func comfirmBeforeLogout(title: String?, msg: String, vc: UIViewController, handler: @escaping Handler) {
        
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
                
        let confirm = UIAlertAction(title: "登出", style: .destructive) { (action) in
            handler()
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        vc.present(alert, animated: true, completion: nil)
    }
    
    class func showConfirm(title: String?, msg: String, vc: UIViewController, handler: @escaping Handler) {
        

        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
                
        let confirm = UIAlertAction(title: "確定", style: .default) { (action) in
            handler()
        }
        
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }

        alert.addAction(confirm)
        alert.addAction(cancel)
        vc.present(alert, animated: true, completion: nil)
    }
    
    class func showLogout(title: String?, msg: String?, vc: UIViewController, handler: @escaping Handler) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let logout = UIAlertAction(title: "登出", style: .destructive) { (action) in
            handler()
        }
        
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        
        alert.addAction(logout)
        alert.addAction(cancel)
        vc.present(alert, animated: true, completion: nil)
    }
    
    class func showMessage(title: String?, msg: String, vc: UIViewController, handler: Handler? = nil) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
                
        let done = UIAlertAction(title: "確定", style: .default) { (action) in
            if (handler != nil) {
                handler!()
            }
        }
        alert.addAction(done)
        vc.present(alert, animated: true, completion: nil)
    }
    
    
    class func showSecurityAlert(title: String?, msg: String, vc: UIViewController, handler: Handler? = nil) {
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurVisualEffectView.frame = vc.view.bounds
        
    
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
                
        let done = UIAlertAction(title: "確定", style: .default) { (action) in
            blurVisualEffectView.removeFromSuperview()
            if (handler != nil) {
                handler!()
            }
        }
        alert.addAction(done)
        
        vc.view.addSubview(blurVisualEffectView)
        vc.present(alert, animated: true, completion: nil)
        
    }
    
}

class HUD {
    
    //loading
    class func showLoadingHUD(inView:UIView!, text:String?) {
        let hud = MBProgressHUD.showAdded(to: inView, animated: true)
        hud.mode = .indeterminate
        hud.label.text = text

    }
    
    //hide loading
    class func hideLoadingHUD(inView:UIView!){
        MBProgressHUD.hide(for: inView, animated: true)
    }
    
    class func showTextHud(inView:UIView!, text:String, delay:TimeInterval) {
        
        let hud = MBProgressHUD.showAdded(to: inView, animated: true)
        hud.mode = .text
        hud.label.text = text
        hud.label.numberOfLines = 0
        hud.hide(animated: true, afterDelay: delay)
        
    }
}

enum finishLoginViewWith {
    case Login
    case Singup
    case Forget
    case BossLogIn  //TODO:
//    case ReFillData //TODO:
}

public func getSavedImage(named: String) -> UIImage? {
    
    if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
        
        let url = URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path
        
        return UIImage(contentsOfFile: url)
        
    }
    return nil
}
