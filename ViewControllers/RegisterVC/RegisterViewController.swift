//
//  RegisterViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 25/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit


class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtPhoneNumber: ThemeTextField!
    
    @IBOutlet weak var txtEmail: ThemeTextField!
    
    @IBOutlet weak var txtPassword: ThemeTextField!
    
    @IBOutlet weak var txtConfirmPassword: ThemeTextField!
    
    @IBOutlet weak var btnNext: ThemeButton!
    
    @IBOutlet weak var lblFirstStep: UILabel!
    
    @IBOutlet weak var lblSecondStep: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setLocalization()
    }
    
    func setLocalization()
    {
        txtPhoneNumber.placeholder = "Phone Number".localized
        txtEmail.placeholder = "Email".localized
        txtPassword.placeholder = "Password".localized
        txtConfirmPassword.placeholder = "Confirm Password".localized
        btnNext.setTitle("Next".localized, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtPhoneNumber.delegate = self
        self.SetLayout()
        
        //        txtPhoneNumber.text = "1234567890"
        //        txtEmail.text = "rahul.bbit@gmail.com"
        //        txtPassword.text = "12345678"
        //        txtConfirmPassword.text = "12345678"
        
        if SingletonClass.sharedInstance.isFromSocilaLogin == true
        {
            self.txtEmail.text = SingletonClass.sharedInstance.strSocialEmail
          
        }
//        txtPhoneNumber.placeHolderColor = UIColor.red
        // Do any additional setup after loading the view.
    }
    
    
    
    //-------------------------------------------------------------
    // MARK: - TextField Delegate Method"Sign Up
    //-------------------------------------------------------------
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtPhoneNumber {
            let resultText: String? = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            
            if resultText!.count >= 11 {
                return false
            }
            else {
                return true
            }
        } 
        return true
    }
    
    // MARK: - Navigation
    
    
    @IBAction func btnNext(_ sender: Any) {
        
        if (validateAllFields())
        {

            webserviceForGetOTPCode(email: txtEmail.text!, mobile: txtPhoneNumber.text!)

        }
        
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-------------------------------------------------------------
    // MARK: - validation Email Methods
    //-------------------------------------------------------------
    
    func validateAllFields() -> Bool
    {
     
        let isEmailAddressValid = isValidEmailAddress(emailID: txtEmail.text!)
        
        if (txtPhoneNumber.text?.count == 0)
        {

            UtilityClass.setCustomAlert(title: "Missing", message: "Please enter phone number".localized) { (index, title) in
            }

            return false
        }
        else if ((txtPhoneNumber.text?.count)! < 10)
        {

            UtilityClass.setCustomAlert(title: "Missing", message: "Please enter a valid phone number".localized) { (index, title) in
            }

            return false
        }
        else if (txtEmail.text?.count == 0)
        {
            UtilityClass.setCustomAlert(title: "Missing", message: "Please enter email".localized) { (index, title) in
            }

            return false
        }
        else if (!isEmailAddressValid)
        {
            UtilityClass.setCustomAlert(title: "Missing", message: "Please enter a valid email".localized) { (index, title) in
            }

            return false
        }
        else if (txtPassword.text?.count == 0)
        {
            UtilityClass.setCustomAlert(title: "Missing", message: "Please enter password".localized) { (index, title) in
            }

            return false
        }
            
        else if ((txtPassword.text?.count)! < 6)
        {
            UtilityClass.setCustomAlert(title: "Required", message: "Password must contain at least 8 characters".localized) { (index, title) in
            }

            return false
        }
        else if (txtConfirmPassword.text?.count == 0)
        {
            UtilityClass.setCustomAlert(title: "Missing", message: "Please enter confirm password".localized) { (index, title) in
            }
            
            return false
        }
            
        else if ((txtConfirmPassword.text?.count)! < 6)
        {
            UtilityClass.setCustomAlert(title: "Required", message: "Password must contain at least 8 characters".localized) { (index, title) in
            }
            
            return false
        }
        else if (txtPassword.text != txtConfirmPassword.text)
        {
            UtilityClass.setCustomAlert(title: "Missing", message: "Password and Confirm Password does not match".localized) { (index, title) in
            }

            return false
        }
       
        
        return true
    }
    
    
    func isValidEmailAddress(emailID: String) -> Bool
    {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z)-9.-]+\\.[A-Za-z]{2,3}"
        
        do{
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailID as NSString
            let results = regex.matches(in: emailID, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
        }
        catch _ as NSError
        {
            returnValue = false
        }
        
        return returnValue
    }
    
    func setCustomAlert(title: String, message: String) {
        AJAlertController.initialization().showAlertWithOkButton(aStrTitle: title, aStrMessage: message) { (index,title) in
        }
     
    }
    
    func webserviceForGetOTPCode(email: String, mobile: String) {
        
//      Param : MobileNo,Email

        var param = [String:AnyObject]()
        param["MobileNo"] = mobile as AnyObject
        param["Email"] = email as AnyObject
        
        webserviceForOTPRegister(param as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                let datas = (result as! [String:AnyObject])
                
                if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                    if SelectedLanguage == "en" {
                        
                        UtilityClass.showAlertWithCompletion("OTP Code", message: datas["message"] as! String, vc: self, completionHandler: { ACTION in
                            
                            if let otp = datas["otp"] as? String {
                                SingletonClass.sharedInstance.otpCode = otp
                            }else if let otp = datas["otp"] as? Int {
                                SingletonClass.sharedInstance.otpCode = "\(otp)"
                            }
                            
                            let registrationContainerVC = self.navigationController?.viewControllers.last as! RegistrationContainerViewController
                            registrationContainerVC.scrollObject.setContentOffset(CGPoint(x: self.view.frame.size.width, y: 0), animated: true)
                        })
                    }
                    else //if SelectedLanguage == "sw"
                    {
                        UtilityClass.showAlertWithCompletion("OTP Code".localized, message: datas["swahili_message"] as! String, vc: self, completionHandler: { ACTION in
                            
                            if let otp = datas["otp"] as? String {
                                SingletonClass.sharedInstance.otpCode = otp
                            }
                            else if let otp = datas["otp"] as? Int {
                                SingletonClass.sharedInstance.otpCode = "\(otp)"
                            }
                            
                            let registrationContainerVC = self.navigationController?.viewControllers.last as! RegistrationContainerViewController
                            registrationContainerVC.scrollObject.setContentOffset(CGPoint(x: self.view.frame.size.width, y: 0), animated: true)
                        })
                    }
                }
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

extension RegisterViewController {
    
    func SetLayout() {
        
        self.lblFirstStep.layer.cornerRadius = 12.5
        self.lblSecondStep.layer.cornerRadius = 12.5
        self.lblFirstStep.layer.masksToBounds = true
        self.lblSecondStep.layer.masksToBounds = true
    }
    
}

