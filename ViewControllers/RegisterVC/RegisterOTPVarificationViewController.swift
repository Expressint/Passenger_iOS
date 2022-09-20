//
//  RegisterOTPVarificationViewController.swift
//  PickNGo User
//
//  Created by Excelent iMac on 17/02/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift

class RegisterOTPVarificationViewController: UIViewController {


    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var txtOTP: ThemeTextField!
    
    @IBOutlet weak var lblFirstStep: UILabel!
    
    @IBOutlet weak var lblSecondStep: UILabel!
    
    @IBOutlet weak var btnVerify: ThemeButton!
    
    @IBOutlet weak var btnResendOTP: UIButton!
    
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetLayout()
        txtOTP.keyboardType = .numberPad
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
           setLocalization()
    }

    @objc func changeLanguage(){
        self.setLocalization()
    }
    
    func  setLocalization(){
        txtOTP.placeholder = "Enter OTP".localized
//        lblFirstStep.text = "".localized
//        lblSecondStep.text = "".localized
        btnResendOTP.setTitle("Resend OTP".localized, for: .normal)
        btnVerify.setTitle("Verify".localized, for: .normal)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnNext(_ sender: ThemeButton) {
        
        
        let registerVC = (self.navigationController?.viewControllers.last as! RegistrationContainerViewController).childViewControllers.last as! RegistrationNewViewController
        registerVC.setupScrollView()
        guard txtOTP.text?.count != 0 else {
            UtilityClass.setCustomAlert(title: "\(appName)", message: "OTP cannot be blank".localized, completionHandler: { (index, title) in
            })
            return
        }
        
        if SingletonClass.sharedInstance.otpCode == txtOTP.text {
            let registrationContainerVC = self.navigationController?.viewControllers.last as! RegistrationContainerViewController
            registrationContainerVC.scrollObject.setContentOffset(CGPoint(x: self.view.frame.size.width * 2, y: 0), animated: true)
        }else{
            UtilityClass.setCustomAlert(title: "\(appName)", message: "Please enter valid OTP code".localized, completionHandler: { (index, title) in
            })
        }
    }
    
    
    @IBAction func btnResendOTP(_ sender: UIButton) {
    
        let registerVC = (self.navigationController?.viewControllers.last as! RegistrationContainerViewController).childViewControllers[0] as! RegisterViewController
        
        let strPhoneNumber = (registerVC.txtPhoneNumber.text)!
        let strEmail = (registerVC.txtEmail.text)!
        
        self.webserviceForGetOTPCode(email: strEmail, mobile: strPhoneNumber)
    
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Web Service Methods
    //-------------------------------------------------------------
    
    
    func webserviceForGetOTPCode(email: String, mobile: String) {
        
        //      Param : MobileNo,Email
        
        var param = [String:AnyObject]()
        param["MobileNo"] = mobile as AnyObject
        param["Email"] = email as AnyObject
        
        UtilityClass.showACProgressHUD()
        
        webserviceForOTPRegister(param as AnyObject) { (result, status) in
            UtilityClass.hideACProgressHUD()
            
            if (status) {
                print(result)
                
                let datas = (result as! [String:AnyObject])
                
                
                UtilityClass.showAlertWithCompletion("OTP Code", message: datas["message"] as! String, vc: self, completionHandler: { ACTION in
                    
                    if let otp = datas["otp"] as? String {
                        SingletonClass.sharedInstance.otpCode = otp
                    }
                    else if let otp = datas["otp"] as? Int {
                        SingletonClass.sharedInstance.otpCode = "\(otp)"
                    }
                })
                
            }
            else {
                print(result)
                
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "Error", message: res) { (index, title) in
                    }
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "Error", message: resDict.object(forKey: "message") as! String) { (index, title) in
                    }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    }
                }
                
            }
        }
    }
    

}


//-------------------------------------------------------------
// MARK: - Custom Methods
//-------------------------------------------------------------

extension RegisterOTPVarificationViewController {
    func SetLayout() {
        self.lblFirstStep.layer.cornerRadius = 12.5
        self.lblSecondStep.layer.cornerRadius = 12.5
        self.lblFirstStep.layer.masksToBounds = true
        self.lblSecondStep.layer.masksToBounds = true
    }
}
