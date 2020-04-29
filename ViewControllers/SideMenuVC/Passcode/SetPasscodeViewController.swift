//
//  SetPasscodeViewController.swift
//  TickTok User
//
//  Created by Excelent iMac on 22/12/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit



class SetPasscodeViewController: UIViewController {
    
    
    var delegateOfSwitch: checkSwitchIsOnOrOff!
    
    var strStatusToNavigate = String()
    
    var aryImagesPassword = [String]()
    var aryImagesRetypePassword = [String]()
    
    
    var strPassword = String()
    var strRetypePassword = String()
    var strImages = String()
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         
            lblPasscode.text = "".localized
    }
   
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet var btnNumbers: [UIButton]!
    
    @IBOutlet var imgPasscode: [UIImageView]!
    
    @IBOutlet weak var lblPasscode: UILabel!
    
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnNumbersActions(_ sender: UIButton) {
        
        if strPassword.count < 4 {
            strPassword.append(sender.currentTitle!)
            print("strPassword : \(strPassword)")
            imgPasscode[strPassword.count-1].image = UIImage(named: "iconDot")
            
            aryImagesPassword.append("iconDot")
            
            if strPassword.count == 4 {
                lblPasscode.text = "Verify Passcode"
                
                for i in 0..<imgPasscode.count
                {
                    imgPasscode[i].image = UIImage(named: "iconLockStar")
                }
            }
        }
        else {
            if strRetypePassword.count < 4 {
                
                strRetypePassword.append(sender.currentTitle!)
                print("strRetypePassword : \(strRetypePassword)")
                imgPasscode[strRetypePassword.count-1].image = UIImage(named: "iconDot")
                
                aryImagesRetypePassword.append("iconDot")
                
                if strRetypePassword.count == 4 {
                    
                    if strPassword != strRetypePassword {
                        
                        lblPasscode.text = "Retype Password"
                        
                        strRetypePassword.removeAll()
                        aryImagesRetypePassword.removeAll()
                        
                        for i in 0..<imgPasscode.count
                        {
                            imgPasscode[i].image = UIImage(named: "iconLockStar")
                        }
                    }
                    else {
                        
                        SingletonClass.sharedInstance.setPasscode = strPassword
                        UserDefaults.standard.set(SingletonClass.sharedInstance.setPasscode, forKey: "Passcode")
                        
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
                            else {
//                                UtilityClass.showAlertWithCompletion("", message: "Passcode set successfully", vc: self, completionHandler: { ACTION in
//
//                                    self.delegateOfSwitch.switchIs(param: true)
//                                    self.navigationController?.popViewController(animated: true)
//                                })
                                
                                UtilityClass.setCustomAlert(title: "\(appName)", message: "Passcode set successfully", completionHandler: { (index, title) in
                                    
                                    self.delegateOfSwitch.switchIs(param: true)
                                    self.navigationController?.popViewController(animated: true)
                                    
                                })
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
    
    @IBAction func btnClearAction(_ sender: UIButton) {
        
        if strPassword.count < 4 && strPassword.count != 0 {
            strPassword.removeLast()
            aryImagesPassword.removeLast()
            
            if aryImagesPassword.count < 4 && aryImagesPassword.count >= 0
            {
                for j in 0..<imgPasscode.count {
                    
                    if aryImagesPassword.count > j {
                        imgPasscode[j].image = UIImage(named: "iconDot")
                    }
                    else {
                        imgPasscode[j].image = UIImage(named: "iconLockStar")
                    }
                }
            }
            
            print("Removerd strPassword = \(strPassword)")
        }
        else if strRetypePassword.count < 4 && strRetypePassword.count != 0 {
            
            strRetypePassword.removeLast()
            aryImagesRetypePassword.removeLast()
            
            if aryImagesRetypePassword.count < 4 && aryImagesRetypePassword.count >= 0
            {
                for j in 0..<imgPasscode.count {
                    
                    if aryImagesRetypePassword.count > j {
                        imgPasscode[j].image = UIImage(named: "iconDot")
                    }
                    else {
                        imgPasscode[j].image = UIImage(named: "iconLockStar")
                    }
                }
            }
            
            print("Removerd strRetypePassword = \(strRetypePassword)")
        }
        
    }
    
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        
        if checkPresentation() {
            
            self.dismiss(animated: true, completion: nil)
        }
        else {
            
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    
    
    
    
}
