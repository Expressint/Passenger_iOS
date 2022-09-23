//
//  ForgetPasswordViewController.swift
//  Book A Ride-Driver
//
//  Created by Rahul Patel on 29/10/21.
//  Copyright © 2021 Excellent Webworld. All rights reserved.
//

import UIKit
import CountryPickerView

class ForgetPasswordViewController: UIViewController {
    
    @IBOutlet var txtPhoneNumber: ThemeTextField!
    @IBOutlet var btnCountryCode: UIButton!
    @IBOutlet weak var lblOr: UILabel!
    @IBOutlet weak var btnForgotPassword: ThemeButton!
    @IBOutlet var txtEmail: ThemeTextField!
    let countryPicker = CountryPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPhoneNumber.delegate = self
        txtEmail.delegate = self
        countryPicker.delegate = self
        btnCountryCode.setTitle("+592", for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
        self.setLocalization()
        super.viewWillAppear(animated)
    }
    
    @objc func changeLanguage(){
        self.setLocalization()
    }
    
    func setLocalization(){
        self.txtPhoneNumber.placeholder = "Mobile Number".localized
        self.lblOr.text = "OR".localized
        self.btnForgotPassword.setTitle("Forgot Password".localized, for: .normal)
        self.txtEmail.placeholder = "Email".localized
    }
    
    @IBAction func btnForgetPassword(_ sender: Any) {
        if(validation()){
            webserviceForgotPassword()
        }
    }
    
    @IBAction func btnCountryCode(_ sender: Any) {
        countryPicker.showPhoneCodeInView = true
        countryPicker.showCountriesList(from: self)
    }
    
    
    func validation() -> Bool{
        let isEmailAddressValid = isValidEmailAddress(emailID: txtEmail.text!)
        if((txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0) && (txtPhoneNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0)){
            UtilityClass.showAlert("Missing".localized, message: "Please enter mobile number or email".localized, vc: self)
            return false
        }else if ( (txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines).count != 0) && !isEmailAddressValid){
            UtilityClass.showAlert("App Name".localized, message: "Please enter a valid email".localized, vc: self)
            return false
        }
        //        else if ((txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0) && txtPhoneNumber.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count != 0)
        //        {
        //            UtilityClass.showAlert("App Name".localized, message: "Please enter mobile number".localized, vc: self)
        //            return false
        //        }
        return true
    }
    
    func isValidEmailAddress(emailID: String) -> Bool{
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
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func webserviceForgotPassword()
    {
        var params = [String:AnyObject]()
        if(txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0)
        {
            params["MobileNo"] = txtPhoneNumber.text as AnyObject
            params["CountryCode"] = btnCountryCode.titleLabel?.text as AnyObject
            
        }
        else
        {
            params["Email"] = txtEmail.text as AnyObject
            
        }
        webserviceForForgotPassword(params as AnyObject) { (result, status) in
            
            if (status) {
                
                print(result)
                let alert = UIAlertController(title: "App Name".localized, message: result.object(forKey: GetResponseMessageKey()) as? String, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            } else {
                print(result)
                
                if let res = result as? String {
                    UtilityClass.showAlert("App Name".localized, message: res, vc: self)
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.showAlert("App Name".localized, message: resDict.object(forKey: GetResponseMessageKey()) as! String, vc: self)
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.showAlert("App Name".localized, message: (resAry.object(at: 0) as! NSDictionary).object(forKey: GetResponseMessageKey()) as! String, vc: self)
                }
            }
        }
    }
}


extension ForgetPasswordViewController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        btnCountryCode.setTitle(country.phoneCode, for: .normal)
        
    }
    
    //    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
    //        btnCountryCode.setTitle(country.phoneCode, for: .normal)
    //    }
}

extension ForgetPasswordViewController: CountryPickerViewDataSource {
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Select a Country"
    }
    
    func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition {
        return .tableViewHeader
    }
    
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return true
    }
    
    func showCountryCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return false
    }
}

extension ForgetPasswordViewController : UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtPhoneNumber {
            self.txtEmail.text = ""
        } else {
            self.txtPhoneNumber.text = ""
        }
    }
}




func GetResponseMessageKey() -> String {
    var MessageKey: String = ""
    let currentLang = Localize.currentLanguage()
    MessageKey = (currentLang == Languages.English.rawValue) ? "message" : "spanish_message"
    return MessageKey
}
