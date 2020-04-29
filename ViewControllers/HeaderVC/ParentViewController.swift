//
//  ParentViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 09/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import SocketIO

class ParentViewController: UIViewController, HeaderViewDelegate {
    
//    let socket = SocketIOClient(socketURL: URL(string: "http://54.206.55.185:8080")!, config: [.log(false), .compress])
    
    let heightWithoutLabel : Int = 54
    let heightWithoutLabelForX : Int = 114
    
    
    let heightWithLabel : Int = 94
    let heightWithLabelForX : Int = 144
    @IBInspectable var showsBackButton: Bool = false
    @IBInspectable var showsCallButton: Bool = false
    @IBInspectable var showTitleLabelView : Bool = false
//    @IBInspectable var hideSwitchButton: Bool = false
    @IBInspectable var strHeaderTitle: String?
    @IBInspectable var strTitle : String?
//    @IBInspectable var hideSignOut: Bool = false
    
    var headerView: HeaderView?
    var userDefault = UserDefaults.standard
    var driverDuty = String()
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        createHeaderView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    

    func didSideMenuClicked()       //  Side Menu
    {
        SideMenuClicked()
    }
    func didBackButtonClicked()     //  Back Button
    {
        BackButtonClicked()
    }
    
    func didSignOutClicked()        //  SignOut
    {
        SignOutClicked()
    }
    func didCallClicked()        //  SignOut
    {
        CallButtonClicked()
    }
    func didSwitchOnOFFClicked(isOn: Bool) {
        
        if isOn {
            SwitchOnClicked()
        }
        else {
            SwitchOFFClicked()
        }
    }
    
    // ------------------------------------------------------------
    
    func SideMenuClicked()       //  Side Menu
    {
        sideMenuController?.toggle()
    }
    func BackButtonClicked()     //  Back Button
    {

        if isModal() {
            self.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: Notification.Name("CallToRating"), object: nil)

            })
            
        }
        else {
            
            self.navigationController?.popViewController(animated: true)
        }
        
    }
     func CallButtonClicked()     //  Call Button
    {
        let contactNumber = helpLineNumber
        
        if contactNumber == "" {
            
            UtilityClass.setCustomAlert(title: "\(appName)", message: "Contact number is not available") { (index, title) in
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
    func isModal() -> Bool {
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
    
    func SearchClicked()         //  Search
    {
        
    }
    func SignOutClicked()        //  SignOut
    {
        
        userDefault.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        
        performSegue(withIdentifier: "SignOutFromRegister", sender: (Any).self)
  
    }
    func SwitchOnClicked()    //  Switch On
    {

    }
    func SwitchOFFClicked()   //  Switch OFF
    {

    }
    
    func CloseButtonClicked()    //  Close Button
    {
        self.navigationController?.popViewController(animated: true)
    }
    // ------------------------------------------------------------
    
    func createHeaderView() {
        
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        
        let screenRect: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenRect.size.width
        let hView = HeaderView.headerView(withDelegate: self)
        
        var frame = CGRect(x: CGFloat(0), y: CGFloat(20), width: screenWidth, height: CGFloat(heightWithoutLabel))
        hView.bottomView.isHidden = !showTitleLabelView
        if (showTitleLabelView)
        {
            frame = CGRect(x: CGFloat(0), y: CGFloat(20), width: screenWidth, height: CGFloat(heightWithLabel))
            hView.lblHeaderTitle.text = strHeaderTitle
        }

        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                frame = CGRect(x: CGFloat(0), y: CGFloat(-20), width: screenWidth, height: CGFloat(heightWithoutLabelForX))
                hView.contraintLabelCentr.constant = 10

                if (showTitleLabelView)
                {
                    frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: screenWidth, height: CGFloat(heightWithLabelForX))
                    hView.lblHeaderTitle.text = strHeaderTitle
                }
            default:
                print("unknown")
            }
        }
        
        headerView?.lblTitle.isHidden = true
        
        if (strTitle != nil)
        {
            hView.lblTitle.isHidden = false
            hView.lblTitle.text = strTitle
            hView.imgHeaderImage.isHidden = true
        }
        
        hView.btnBack.isHidden = !showsBackButton
        hView.btnMenu.isHidden = showsBackButton
//        hView.btnSwitch.isHidden = !hideSwitchButton
//        hView.btnSignOut.isHidden = !hideSignOut
        hView.btnCall.isHidden = !showsCallButton
        hView.frame = frame
        headerView = hView
        view.addSubview(hView)
        
    }
    
    
}

