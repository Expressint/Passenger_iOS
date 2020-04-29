//
//  VerifyPasswordViewController.swift
//  TickTok User
//
//  Created by Excelent iMac on 22/12/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class VerifyPasswordViewController: UIViewController {

    var delegateOfSwitch: checkSwitchIsOnOrOff!
    
    var strStatusToNavigate = String()
    
    var aryImagesPassword = [String]()
    var aryImagesRetypePassword = [String]()
    
    
    var strPassword = String()
    var strRetypePassword = String()
    var strImages = String()
    
    var isFromSetting = Bool()
    
    var isCheckPasscodeTrue = Bool()
    var isFromAppDelegate = Bool()
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isFromAppDelegate) {
            
            btnBack.isHidden = true
        }
        else {
            btnBack.isHidden = false
            
        }
        
        if (isFromSetting) {
            lblPasscode.text = "Enter Old Passcode"
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  
    @IBOutlet weak var btnForgot: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         
         lblPasscode.text = "Passcode Required".localized
        btnForgot.setTitle("Forgot?".localized, for: .normal)
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var lblPasscode: UILabel!
    @IBOutlet var imgPasscodes: [UIImageView]!
    @IBOutlet weak var btnBack: UIButton!
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    var checkPasscode = String()
    var createNewPasscode = String()
    var retypeCreateNewPasscode = String()
    
    
    @IBAction func btnNumberActions(_ sender: UIButton) {
        
        if (isFromSetting) {
            
            if (!isCheckPasscodeTrue) {
                
                if checkPasscode.count <= 4 {
                    
                    checkPasscode.append(sender.currentTitle!)
                    imgPasscodes[checkPasscode.count - 1].image = UIImage(named: "iconDot")
                    aryImagesPassword.append("iconDot")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        
                        if self.checkPasscode.count == 4 {
                            
                            if SingletonClass.sharedInstance.setPasscode != self.checkPasscode {
                                
                                self.removeCheckPasscodeAndIcons()
                            }
                            else {
                                self.removeCheckPasscodeAndIcons()
                                self.isCheckPasscodeTrue = true
                                self.lblPasscode.text = "Create Passcode"
                            }
                        }
                    }
                }
            }
            else if (isCheckPasscodeTrue) {
                
                // Create New Passcode
                
                if createNewPasscode.count < 4 {
                    
                    createNewPasscode.append(sender.currentTitle!)
                    imgPasscodes[createNewPasscode.count-1].image = UIImage(named: "iconDot")
                    aryImagesPassword.append("iconDot")
                    
                    if createNewPasscode.count == 4 {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                           
                            self.lblPasscode.text = "Retype Passcode"
                            
                            self.aryImagesPassword.removeAll()
                            for i in 0..<self.imgPasscodes.count
                            {
                                self.imgPasscodes[i].image = UIImage(named: "iconLockStar")
                            }
                        }
                       
                    }
                }
                else {
                    // Retype New Passcode
                    
                    if retypeCreateNewPasscode.count < 4 {
                        
                        retypeCreateNewPasscode.append(sender.currentTitle!)
                        imgPasscodes[retypeCreateNewPasscode.count-1].image = UIImage(named: "iconDot")
                        aryImagesRetypePassword.append("iconDot")
                        
                        if retypeCreateNewPasscode.count == 4 {
                        
                            
                            if createNewPasscode != retypeCreateNewPasscode {
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    
                                    self.lblPasscode.text = "Retype Passcode"
                                    
                                    self.retypeCreateNewPasscode.removeAll()
                                    self.aryImagesRetypePassword.removeAll()
                                    
                                    for i in 0..<self.imgPasscodes.count
                                    {
                                        self.imgPasscodes[i].image = UIImage(named: "iconLockStar")
                                    }
                                }
                                
                            }
                            else {
                                
                                SingletonClass.sharedInstance.setPasscode = createNewPasscode
                                UserDefaults.standard.set(SingletonClass.sharedInstance.setPasscode, forKey: "Passcode")
                                
//                                UtilityClass.showAlertWithCompletion("", message: "Passcode change successfully", vc: self, completionHandler: { ACTION in
//                                    
//                                    self.delegateOfSwitch.switchIs(param: true)
//                                    self.navigationController?.popViewController(animated: true)
//                                })
                               
                                UtilityClass.setCustomAlert(title: "\(appName)", message: "Passcode change successfully", completionHandler: { (index, title) in
                                    
                                    self.delegateOfSwitch.switchIs(param: true)
                                    self.navigationController?.popViewController(animated: true)
                                    
                                })
                                
                            }
                            
                        }
                        
                    }
                    
                }

            }
            
        }
        else {
            
            if strRetypePassword.count < 4 {
                
                strRetypePassword.append(sender.currentTitle!)
                print("strRetypePassword : \(strRetypePassword)")
                imgPasscodes[strRetypePassword.count-1].image = UIImage(named: "iconDot")
                
                aryImagesPassword.append("iconDot")
                
                if strRetypePassword.count == 4 {
                    
                    if SingletonClass.sharedInstance.setPasscode != strRetypePassword {
                        
                        lblPasscode.text = "Retype Password"
                        strRetypePassword.removeAll()
                        aryImagesPassword.removeAll()
                        
                        for i in 0..<imgPasscodes.count
                        {
                            imgPasscodes[i].image = UIImage(named: "iconLockStar")
                        }
                    }
                    else {
                        SingletonClass.sharedInstance.passwordFirstTime = true
                        
                        if checkPresentation() {
                            self.dismiss(animated: true, completion: nil)
                        }
                        else {
                            if strStatusToNavigate == "0" {
                                
                                let next = self.storyboard?.instantiateViewController(withIdentifier: "TickPayRegistrationViewController") as! TickPayRegistrationViewController
                                self.navigationController?.pushViewController(next, animated: true)
                            }
                            else if strStatusToNavigate == "1" {
                                
                                let next = self.storyboard?.instantiateViewController(withIdentifier: "TiCKPayNeedToVarifyViewController") as! TiCKPayNeedToVarifyViewController
                                self.navigationController?.pushViewController(next, animated: true)
                                
                            }
                            else if strStatusToNavigate == "2" {
                                
                                let next = self.storyboard?.instantiateViewController(withIdentifier: "PayViewController") as! PayViewController
                                self.navigationController?.pushViewController(next, animated: true)
                            }
                            else if strStatusToNavigate == "Wallet" {
                                let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
                                self.navigationController?.pushViewController(next, animated: true)
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func checkPresentation() -> Bool {
        if (presentingViewController != nil) {
            return true
        }
        if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        }
        if (tabBarController?.presentingViewController is UITabBarController) {
            return true
        }
        return false
    }
    
    @IBAction func btnForgotPasscode(_ sender: UIButton) {
        
        let msg = "If you can't remember your passcode, you must sign out from \(appName) and login with your email address and password."
        
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        let OK = UIAlertAction(title: "OK".localized, style: .default, handler: { ACTIOn in
            
//            let socket = (UIApplication.shared.delegate as! AppDelegate).SocketManager

            UserDefaults.standard.removeObject(forKey: "Passcode")
            SingletonClass.sharedInstance.setPasscode = ""
            
            UserDefaults.standard.removeObject(forKey: "isPasscodeON")
            SingletonClass.sharedInstance.isPasscodeON = false
            
//            UserDefaults.standard.set(nil, forKey: "Passcode")

            self.performSegue(withIdentifier: "signOuyFromPasscode", sender: nil)
        })
        let Cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(OK)
        alert.addAction(Cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func btnClearNumber(_ sender: UIButton) {
        
        if (isFromSetting) {
            
            
            if (!isCheckPasscodeTrue) {
                
                if checkPasscode.count < 4 && checkPasscode.count != 0 {
                    checkPasscode.removeLast()
                    aryImagesPassword.removeLast()
                    
                    if aryImagesPassword.count < 4 && aryImagesPassword.count >= 0 {
                        
                        for j in 0..<imgPasscodes.count {
                            
                            if aryImagesPassword.count > j {
                                imgPasscodes[j].image = UIImage(named: "iconDot")
                            }
                            else {
                                imgPasscodes[j].image = UIImage(named: "iconLockStar")
                            }
                        }
                    }
                    
                }
                
            }
            else if (isCheckPasscodeTrue) {
                
                if createNewPasscode.count < 4 && createNewPasscode.count != 0 {
                    
                    createNewPasscode.removeLast()
                    aryImagesPassword.removeLast()
                    
                    if aryImagesPassword.count < 4 && aryImagesPassword.count >= 0 {
                        
                        for j in 0..<imgPasscodes.count {
                            
                            if aryImagesPassword.count > j {
                                imgPasscodes[j].image = UIImage(named: "iconDot")
                            }
                            else {
                                imgPasscodes[j].image = UIImage(named: "iconLockStar")
                            }
                        }
                        
                    }
                    
                }
                else if retypeCreateNewPasscode.count < 4 && retypeCreateNewPasscode.count != 0 {
                    
                    retypeCreateNewPasscode.removeLast()
                    aryImagesRetypePassword.removeLast()
                    
                    if aryImagesRetypePassword.count < 4 && aryImagesRetypePassword.count >= 0 {
                        
                        for j in 0..<imgPasscodes.count {
                            
                            if aryImagesRetypePassword.count > j {
                                imgPasscodes[j].image = UIImage(named: "iconDot")
                            }
                            else {
                                imgPasscodes[j].image = UIImage(named: "iconLockStar")
                            }
                        }
                    }
                }
            }
            
        }
        else {
            
            if strRetypePassword.count < 4 && strRetypePassword.count != 0 {
                
                strRetypePassword.removeLast()
                aryImagesPassword.removeLast()
                
                if aryImagesPassword.count < 4 && aryImagesPassword.count >= 0
                {
                    
                    for i in 0..<imgPasscodes.count
                    {
                        if aryImagesPassword.count > i {
                            imgPasscodes[i].image = UIImage(named: "iconDot")
                        }
                        else {
                            imgPasscodes[i].image = UIImage(named: "iconLockStar")
                        }
                        
                    }
                }
                
                print("Removerd strRetypePassword = \(strRetypePassword)")
            }
        }
        
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        
        if checkPresentation() {
            
            self.dismiss(animated: true, completion: nil)
        }
        else {
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func removeCheckPasscodeAndIcons() {
        
        checkPasscode.removeAll()
        aryImagesPassword.removeAll()
        
        for i in 0..<imgPasscodes.count
        {
            imgPasscodes[i].image = UIImage(named: "iconLockStar")
        }
    }
    
   

}
