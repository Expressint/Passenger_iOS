//
//  ChangePasswordVC.swift
//  TickTok User
//
//  Created by Excellent Webworld on 11/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import ACFloatingTextfield_Swift

class ChangePasswordVC: BaseViewController {

    
    @IBOutlet weak var lblChangePassWorld: UILabel!
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.setNavBarWithBack(Title: "Change Password".localized, IsNeedRightButton: true)
        
        btnSubmit.layer.cornerRadius = 5
        btnSubmit.layer.masksToBounds = true
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         setLocalization()
    }
    
    func setLocalization()
    {
        lblChangePassWorld.text = "Change Password".localized
        
        txtNewPassword.placeholder = "New Password".localized
        txtCurrentPassword.placeholder = "Current Password".localized
        txtConfirmPassword.placeholder = "Confirm Password".localized
        btnSubmit.setTitle("Submit".localized, for: .normal)
        
    }
    

    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var txtNewPassword: ACFloatingTextfield!
    @IBOutlet weak var txtConfirmPassword: ACFloatingTextfield!
    @IBOutlet weak var txtCurrentPassword: ACFloatingTextfield!
    
    
    
    @IBOutlet weak var btnSubmit: ThemeButton!
    
    
    @IBAction func btnSubmit(_ sender: ThemeButton) {
            
        let str = txtNewPassword.text
        
        
//        txtNewPassword.placeholder
        guard !txtCurrentPassword.text!.isEmpty else {
            UtilityClass.setCustomAlert(title: "Missing".localized, message: "Please enter current password".localized) { (index, title) in
             }
             return
         }
        
        guard !txtNewPassword.text!.isEmpty else {
            UtilityClass.setCustomAlert(title: "Missing".localized, message: "Please enter new password".localized) { (index, title) in
            }
            return
        }
        
        guard !txtConfirmPassword.text!.isEmpty else {
            UtilityClass.setCustomAlert(title: "Missing".localized, message: "Please confirm password".localized) { (index, title) in
            }
            return
        }
        
        if ((txtConfirmPassword.text?.hasPrefix(" ") == true) || (txtConfirmPassword.text?.hasSuffix(" ") == true))
        {
            UtilityClass.setCustomAlert(title: "Required".localized, message: "Confirm password can’t start or end with a blank space".localized) { (index, title) in
            }
            
            return
        }
        else if ((txtConfirmPassword.text?.hasPrefix(" ") == true) || (txtConfirmPassword.text?.hasSuffix(" ") == true))
        {
            UtilityClass.setCustomAlert(title: "Required".localized, message: "Confirm password can’t start or end with a blank space".localized) { (index, title) in
            }
            
            return
        }
        if txtNewPassword.text == txtConfirmPassword.text {
        
            if str!.count >= 8  {
                webserviceOfChangePassword()
            }
            else {
                UtilityClass.setCustomAlert(title: "Missing".localized, message: "Password must contain at least 8 characters".localized) { (index, title) in
            }
            }
        }
        else {
            UtilityClass.setCustomAlert(title: "Password did not match".localized, message: "Password and confirm password must be same".localized) { (index, title) in
            }
        }
    }
    
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var btnCall: UIButton!
    @IBAction func btCallClicked(_ sender: UIButton)
    {
        
        let contactNumber = helpLineNumber
        
        if contactNumber == "" {
            
            UtilityClass.setCustomAlert(title: "\(appName)", message: "Contact number is not available".localized) { (index, title) in
            }
        }
        else
        {
            callNumber(phoneNumber: contactNumber)
        }
    }
    
    private func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    func webserviceOfChangePassword() {
        
    
        var dictData = [String:AnyObject]()
        
        dictData["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
        dictData["Password"] = txtNewPassword.text as AnyObject
        dictData["OldPassword"] = txtCurrentPassword.text as AnyObject
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        webserviceForChangePassword(dictData as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
                self.txtNewPassword.text = ""
                self.txtConfirmPassword.text = ""
                
                UtilityClass.setCustomAlert(title: appName, message: (result as! NSDictionary).object(forKey: GetResponseMessageKey()) as! String) { (index, title) in
                    
                    self.navigationController?.popViewController(animated: true)
            }
                
//                UtilityClass.showAlert("", message: (result as! NSDictionary).object(forKey: "message") as! String, vc: self)
                
                
            }
            else {
                 print(result)
                
//                UtilityClass.setCustomAlert(title: <#T##String#>, message: <#T##String#>, completionHandler: { (<#Int#>, <#String#>) in
//                    <#code#>
//                })
                
            }
        }
        
    }
    

}
