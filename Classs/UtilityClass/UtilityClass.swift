//
//  UtilityClass.swift
//  TickTok User
//
//  Created by Excellent Webworld on 27/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

typealias CompletionHandler = (_ success:Bool) -> Void

class UtilityClass: NSObject, alertViewMethodsDelegates {
    
    var delegateOfAlert : alertViewMethodsDelegates!
    
    //MARK: -
    class func formattedDateFromString(dateString: String,fromFormat : String = "", withFormat format: String) -> String? {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if(fromFormat.trimmingCharacters(in: .whitespacesAndNewlines).count != 0)
        {
            inputFormatter.dateFormat = fromFormat
            
        }
        //        2018-08-01 17:34:32
        if let date = inputFormatter.date(from: dateString)
        {
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            let str = outputFormatter.string(from: date)
            return str
        }
        
        return nil
    }
    
    class func showAlert(_ title: String, message: String, vc: UIViewController) -> Void
    {
        let alert = UIAlertController(title: appName,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "OK".localized,
                                         style: .cancel, handler: nil)
        
        
        
        alert.addAction(cancelAction)
        
        if((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.presentedViewController != nil)
        {
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.dismiss(animated: true, completion: {
//                vc.present(alert, animated: true, completion: nil)
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
            })
        }
        else {
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
        
        
        //vc will be the view controller on which you will present your alert as you cannot use self because this method is static.
        
    }
    
    /// Response may be Any Type
    class func showAlertOfAPIResponse(param: Any, vc: UIViewController) {
        
        if let res = param as? String {
            UtilityClass.showAlert(appName, message: res, vc: vc)
        }
        else if let resDict = param as? NSDictionary {
            if let msg = resDict.object(forKey: "message") as? String {
                UtilityClass.showAlert(appName, message: msg, vc: vc)
            }
            else if let msg = resDict.object(forKey: "msg") as? String {
                UtilityClass.showAlert(appName, message: msg, vc: vc)
            }
            else if let msg = resDict.object(forKey: "message") as? [String] {
                UtilityClass.showAlert(appName, message: msg.first ?? "", vc: vc)
            }
        }
        else if let resAry = param as? NSArray {
            
            if let dictIndxZero = resAry.firstObject as? NSDictionary {
                if let message = dictIndxZero.object(forKey: "message") as? String {
                    UtilityClass.showAlert(appName, message: message, vc: vc)
                }
                else if let msg = dictIndxZero.object(forKey: "msg") as? String {
                    UtilityClass.showAlert(appName, message: msg, vc: vc)
                }
                else if let msg = dictIndxZero.object(forKey: "message") as? [String] {
                    UtilityClass.showAlert(appName, message: msg.first ?? "", vc: vc)
                }
            }
            else if let msg = resAry as? [String] {
                UtilityClass.showAlert(appName, message: msg.first ?? "", vc: vc)
            }
        }
    }
    
    class func presentPopupOverScreen(_ alertController : UIViewController)
    {
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    
    class func showAlertWithCompletion(_ title: String, message: String, okTitle : String = "", otherTitle : String = "", vc: UIViewController,completionHandler: @escaping CompletionHandler) -> Void
    {
        let alert = UIAlertController(title: appName,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        
      
        
        if(okTitle != "")
        {
            alert.addAction(UIAlertAction(title: okTitle.localized, style: .default, handler: { (action) in
                completionHandler(true)
            }))
        }
        else
        {
            alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: { (action) in
                completionHandler(true)
            }))
            
        }
        
        
        if(otherTitle != "")
        {
            alert.addAction(UIAlertAction(title: otherTitle.localized, style: .default, handler: { (action) in
                completionHandler(false)
            }))
        }
        
        if((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.presentedViewController != nil)
        {
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.dismiss(animated: true, completion: {
                //                vc.present(alert, animated: true, completion: nil)
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
            })
        }
        else {
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
        }

    }
    
    
    class func CustomAlertViewMethod(_ title: String, message: String, vc: UIViewController, completionHandler: @escaping CompletionHandler) -> Void {
        
        let next = vc.storyboard?.instantiateViewController(withIdentifier: "CustomAlertsViewController") as! CustomAlertsViewController
        
//        next.delegateOfAlertView = vc as! alertViewMethodsDelegates
        next.strTitle = appName
        next.strMessage = message
        
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(next, animated: false, completion: nil)
        
    }
    class func setLeftPaddingInTextfield(textfield:UITextField , padding:(CGFloat))
    {
        let view:UIView = UIView (frame: CGRect (x: 0, y: 0, width: padding, height: textfield.frame.size.height) )
        textfield.leftView = view
        textfield.leftViewMode = UITextFieldViewMode.always
    }
    
    class func setRightPaddingInTextfield(textfield:UITextField, padding:(CGFloat))
    {
        
        let view:UIView = UIView (frame: CGRect (x: 0, y: 0, width: padding, height: textfield.frame.size.height) )
        textfield.rightView = view
        textfield.rightViewMode = UITextFieldViewMode.always
    }
    class func isEmpty(str: String?) -> Bool
    {
        var newString : String?
        newString = (str)
        
        if (newString as? NSNull) == NSNull()
        {
            return true
        }
        if (newString == "(null)")
        {
            return true
        }
        if (newString == "<null>")
        {
            return true
        }
        if newString == nil
        {
            return true
        }
        else if (newString?.count ?? 0) == 0 {
            return true
        }
        else
        {
            newString = newString?.trimmingCharacters(in: .whitespacesAndNewlines)
            if ((str)!.count ) == 0 {
                return true
                
            }
        }
        if ((str)! == "<null>")
        {
            return true
        }
        return false
    }
    typealias alertCompletionBlockAJ = ((Int, String) -> Void)?
    
    class func setCustomAlert(title: String, message: String, showStack: Bool = true,completionHandler: alertCompletionBlockAJ) -> Void {
        
        if let appDelegate = UIApplication.shared.delegate, let window = appDelegate.window, let rootViewController = window?.rootViewController {
            
            let topViewController = rootViewController
            if topViewController.presentedViewController == nil {
                let vc = topViewController.childViewControllers.last! as? AJAlertController
                vc?.view.removeFromSuperview()
                vc?.removeFromParentViewController()
            }
        }

       
        AJAlertController.initialization().showAlertWithOkButton(aStrTitle: appName, aStrMessage: message, showStack: showStack) { (index,title) in
            
            if index == 0 {
                completionHandler?(0,title)
                
            }
            else if index == 2 {
                completionHandler?(2,title)
                
            }
            
        }
        
    }
    

    
    class func showHUD()
    {
        let activityData = ActivityData()
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
    }
    
    class func hideHUD()
    {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()

    }
    class func showACProgressHUD() {
        
        let activityData = ActivityData()
        NVActivityIndicatorView.DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME = 55
        NVActivityIndicatorView.DEFAULT_BLOCKER_DISPLAY_TIME_THRESHOLD = 55
        NVActivityIndicatorView.DEFAULT_TYPE = .ballRotate
        NVActivityIndicatorView.DEFAULT_COLOR = themeYellowColor
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
    }
    
    class func hideACProgressHUD() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()

    }

}

extension UILabel {
    func underlineToLabel() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedStringKey.underlineStyle,
                                          value: NSUnderlineStyle.styleSingle.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}


//-------------------------------------------------------------
// MARK: - Internet Connection Check Methods
//-------------------------------------------------------------

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}


extension UIViewController {
    
    func checkDictionaryHaveValue(dictData: [String:AnyObject], didHaveValue paramString: String, isNotHave: String) -> String {
        
        let currentData = dictData
        
        if currentData[paramString] == nil {
            return isNotHave
        }
        
        if ((currentData[paramString] as? String) != nil) {
            if String(currentData[paramString] as! String) == "" {
                return isNotHave
            }
            return String(currentData[paramString] as! String)
            
        } else if ((currentData[paramString] as? Int) != nil) {
            if String(currentData[paramString] as! Int) == "" {
                return isNotHave
            }
            return String((currentData[paramString] as! Int))
            
        } else if ((currentData[paramString] as? Double) != nil) {
            if String(currentData[paramString] as! Double) == "" {
                return isNotHave
            }
            return String(currentData[paramString] as! Double)
            
        } else if ((currentData[paramString] as? Float) != nil){
            if String(currentData[paramString] as! Float) == "" {
                return isNotHave
            }
            return String(currentData[paramString] as! Float)
        }
        else {
            return isNotHave
        }
    }
    

    /// Convert Seconds to Hours, Minutes and Seconds
    func ConvertSecondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    var isModal: Bool {

           let presentingIsModal = presentingViewController != nil
           let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
           let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController

           return presentingIsModal || presentingIsNavigation || presentingIsTabBar
       }
    
}


extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
