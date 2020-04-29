//
//  SettingPasscodeVC.swift
//  TickTok User
//
//  Created by Excelent iMac on 05/01/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit

protocol checkSwitchIsOnOrOff {
    
    func switchIs(param : Bool)
    
}


class SettingPasscodeVC: BaseViewController, checkSwitchIsOnOrOff {

    
    var bottomBorderOfPasscode = CALayer()
    var bottomBorderOfChangePasscode = CALayer()
    var bottomBorderOfProfile = CALayer()
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchPasscode.isOn = SingletonClass.sharedInstance.isPasscodeON
        
        if (SingletonClass.sharedInstance.isPasscodeON) {
            viewChangePasscode.isHidden = false
        }
        else {
//            viewChangePasscode.isHidden = true
        }
        self.setNavBarWithBack(Title: "Legal".localized, IsNeedRightButton: true)
//        bottomBorder()
       
    }
      
    @IBOutlet weak var btnPrivacyAndPolicy: UIButton!
    @IBOutlet weak var btnTermsAndCondition: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        btnPrivacyAndPolicy.setTitle("Privacy Policy".localized, for: .normal)
        btnTermsAndCondition.setTitle("Terms & Conditions".localized, for: .normal)
        switchPasscode.isOn = SingletonClass.sharedInstance.isPasscodeON
        
        if switchPasscode.isOn {
            switchPasscode.thumbTintColor = themeYellowColor
        }
        else {
            switchPasscode.thumbTintColor = UIColor.gray
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        convertToiPhoneX()
    }
    
    
    func switchIs(param: Bool) {
        
        SingletonClass.sharedInstance.isPasscodeON = param
        
        switchPasscode.isOn = SingletonClass.sharedInstance.isPasscodeON
        
        if (SingletonClass.sharedInstance.isPasscodeON) {
            viewChangePasscode.isHidden = false
        }
        else {
//            viewChangePasscode.isHidden = true
        }
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var viewSetPasscode: UIView!
    @IBOutlet weak var viewChangePasscode: UIView!
    @IBOutlet weak var viewProfile: UIView!
    
    @IBOutlet weak var switchPasscode: UISwitch!
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func switchPasscode(_ sender: UISwitch) {
        
        
        if sender.isOn
        {
            viewChangePasscode.isHidden = false

            switchPasscode.thumbTintColor = themeYellowColor
            SingletonClass.sharedInstance.isPasscodeON = true
            UserDefaults.standard.set(SingletonClass.sharedInstance.isPasscodeON, forKey: "isPasscodeON")
            
            if SingletonClass.sharedInstance.setPasscode == ""
            {
                let next = self.storyboard?.instantiateViewController(withIdentifier: "SetPasscodeViewController") as! SetPasscodeViewController
                next.delegateOfSwitch = self
                sender.isOn = false
                SingletonClass.sharedInstance.isPasscodeON = false
                UserDefaults.standard.set(SingletonClass.sharedInstance.isPasscodeON, forKey: "isPasscodeON")
                
                self.navigationController?.pushViewController(next, animated: true)
            }
            
        }
        else {
//            viewChangePasscode.isHidden = true
            
            switchPasscode.thumbTintColor = UIColor.gray
            
            SingletonClass.sharedInstance.isPasscodeON = false
            UserDefaults.standard.set(SingletonClass.sharedInstance.isPasscodeON, forKey: "isPasscodeON")

        }
        
    }
    
    
    @IBAction func btnChangePasscode(_ sender: UIButton) {
        //Terms and condition
//        if SingletonClass.sharedInstance.setPasscode == "" {
//            let next = self.storyboard?.instantiateViewController(withIdentifier: "SetPasscodeViewController") as! SetPasscodeViewController
//            self.navigationController?.pushViewController(next, animated: true)
//        }
////        else {
//            let next = self.storyboard?.instantiateViewController(withIdentifier: "VerifyPasswordViewController") as! VerifyPasswordViewController
//        next.delegateOfSwitch = self
//            next.isFromSetting = true
//            self.navigationController?.pushViewController(next, animated: true)
////        }
//
        UtilityClass.setCustomAlert(title: "Info Message".localized, message: "This feature is coming soon") { (index, title) in
        }
        return
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "webViewVC") as! webViewVC
        next.headerName = "\(appName)"
        next.strURL = "https://www.tantaxitanzania.com/front/termsconditions"
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func btnProfile(_ sender: UIButton) {
        //Privacy Policy
//        let next = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
//        self.navigationController?.pushViewController(next, animated: true)
        
        UtilityClass.setCustomAlert(title: "Info Message".localized, message: "This feature is coming soon") { (index, title) in
        }
        return
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "webViewVC") as! webViewVC
        next.headerName = "\(appName)"
        next.strURL = "https://www.tantaxitanzania.com/front/privacypolicy"
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func bottomBorder() {
        
        bottomBorderOfPasscode.frame = CGRect(x: 0.0, y: viewSetPasscode.frame.size.height - 1, width: viewSetPasscode.frame.size.width, height: 1.0)
        bottomBorderOfPasscode.backgroundColor = UIColor.black.cgColor
        viewSetPasscode.layer.addSublayer(bottomBorderOfPasscode)
        
        bottomBorderOfChangePasscode.frame = CGRect(x: 0.0, y: viewChangePasscode.frame.size.height - 1, width: viewChangePasscode.frame.size.width, height: 1.0)
        bottomBorderOfChangePasscode.backgroundColor = UIColor.black.cgColor
        viewChangePasscode.layer.addSublayer(bottomBorderOfChangePasscode)
        
        bottomBorderOfProfile.frame = CGRect(x: 0.0, y: viewProfile.frame.size.height - 1, width: viewProfile.frame.size.width, height: 1.0)
        bottomBorderOfProfile.backgroundColor = UIColor.black.cgColor
        viewProfile.layer.addSublayer(bottomBorderOfProfile)
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Convert To iPhone X
    //-------------------------------------------------------------
    
    func convertToiPhoneX() {
        /*
        let heightWithoutLabel : Int = 54
        let heightWithoutLabelForX : Int = 114
        
        
        let heightWithLabel : Int = 94
        let heightWithLabelForX : Int = 144
        
        let screenWidth = UIScreen.main.nativeBounds.width
        
        
        let hView = HeaderView.headerView(withDelegate: self)
        
        var frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: screenWidth, height: CGFloat(heightWithoutLabel))
        hView.bottomView.isHidden = !showTitleLabelView
        if (showTitleLabelView)
        {
            frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: screenWidth, height: CGFloat(heightWithLabel))
            hView.lblHeaderTitle.text = strHeaderTitle
        }
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                frame = CGRect(x: CGFloat(0), y: CGFloat(-20), width: screenWidth, height: CGFloat(heightWithoutLabelForX))
                if (showTitleLabelView)
                {
                    frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: screenWidth, height: CGFloat(heightWithLabelForX))
                    hView.lblHeaderTitle.text = strHeaderTitle
                }
            default:
                print("unknown")
            }
        }
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                frame = CGRect(x: CGFloat(0), y: CGFloat(-20), width: screenWidth, height: CGFloat(heightWithoutLabelForX))
                if (showTitleLabelView)
                {
                    frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: screenWidth, height: CGFloat(heightWithLabelForX))
                    hView.lblHeaderTitle.text = strHeaderTitle
                }
            default:
                print("unknown")
            }
        }
         */
    }
    
    
    
}
