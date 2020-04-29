//
//  EditProfileViewController.swift
//  TickTok User
//
//  Created by Excelent iMac on 23/12/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class EditProfileViewController: BaseViewController {

    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    @IBOutlet weak var lblEditProfile: UILabel!
    @IBOutlet weak var lblAccount: UILabel!
    @IBOutlet var btnSignOut: ThemeButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavBarWithBack(Title: "PROFILE".localized, IsNeedRightButton: true)
        
        viewEditProfile.layer.cornerRadius = 10
        viewEditProfile.layer.masksToBounds = true
        
        viewAccount.layer.cornerRadius = 10
        viewAccount.layer.masksToBounds = true
       
        btnSignOut.setTitleColor(themeYellowColor, for: .normal)
        btnSignOut.backgroundColor = UIColor.clear
        btnSignOut.layer.cornerRadius = btnSignOut.frame.height / 2
        btnSignOut.clipsToBounds = true
        btnSignOut.layer.borderWidth = 1.0
        btnSignOut.layer.borderColor = themeYellowColor.cgColor
//        self.ConstraintEditProfileX.constant = self.view.frame.origin.x - viewEditProfile.frame.size.width - 20
//        self.constraintAccountTailing.constant = -(viewEditProfile.frame.size.width + 20)
//
        
//        AnimationToView()


        setImageColor()
        
        iconProfile.image = setImageColorOfImage(name: "iconEditProfile")
        iconAccount.image = setImageColorOfImage(name: "iconAccount")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLocalization()
        self.setNavBarWithBack(Title: "Profile".localized, IsNeedRightButton: true)
//        ConstraintEditProfileX.constant = -(self.view.frame.size.width)
//        constraintAccountTailing.constant = -(self.view.frame.size.width)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
//        AnimationToView()
    }
    func setLocalization()
    {
        lblEditProfile.text =  "Edit Profile".localized
        lblAccount.text =  "Account".localized
        btnSignOut.setTitle("Signout".localized, for: .normal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func setImageColor() {
        
//        let img = UIImage(named: "iconArrowGrey")
//        imgArrowProfile.image = img?.maskWithColor(color: UIColor.white)
//        imgArrowAccount.image = img?.maskWithColor(color: UIColor.white)
    }
    
    func setImageColorOfImage(name: String) -> UIImage {
        
        var imageView = UIImageView()
        
        let img = UIImage(named: name)
        imageView.image = img?.maskWithColor(color: UIColor.white)
       
        
        return imageView.image!
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var viewEditProfile: UIView!
    @IBOutlet weak var viewAccount: UIView!
    
    @IBOutlet weak var imgArrowProfile: UIImageView!
    @IBOutlet weak var imgArrowAccount: UIImageView!
    
    @IBOutlet weak var ConstraintEditProfileX: NSLayoutConstraint!
    @IBOutlet weak var constraintAccountTailing: NSLayoutConstraint!
    
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var iconProfile: UIImageView!
    @IBOutlet weak var iconAccount: UIImageView!
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
//        AnimationToView()
        
        print("Back Button Clicked")
        
    }
    
    @IBAction func btnSignOutClicked(_ sender: UIButton)
    {
        RMUniversalAlert.show(in: self, withTitle:appName, message: "Are you sure you want to logout?".localized, cancelButtonTitle: nil, destructiveButtonTitle: nil, otherButtonTitles: ["Signout".localized, "Cancel".localized], tap: {(alert, buttonIndex) in
            if (buttonIndex == 2)
            {

                let socket = (UIApplication.shared.delegate as! AppDelegate).SocketManager
                
                
                socket.off(SocketData.kReceiveGetEstimateFare)
                socket.off(SocketData.kNearByDriverList)
                socket.off(SocketData.kAskForTipsToPassengerForBookLater)
                socket.off(SocketData.kAskForTipsToPassenger)
                socket.off(SocketData.kAcceptBookingRequestNotification)
                socket.off(SocketData.kRejectBookingRequestNotification)
                socket.off(SocketData.kCancelTripByDriverNotficication)
                socket.off(SocketData.kPickupPassengerNotification)
                socket.off(SocketData.kBookingCompletedNotification)
                socket.off(SocketData.kAcceptAdvancedBookingRequestNotification)
                socket.off(SocketData.kRejectAdvancedBookingRequestNotification)
                socket.off(SocketData.kAdvancedBookingPickupPassengerNotification)
                socket.off(SocketData.kReceiveHoldingNotificationToPassenger)
                socket.off(SocketData.kAdvancedBookingTripHoldNotification)
                socket.off(SocketData.kReceiveDriverLocationToPassenger)
                socket.off(SocketData.kAdvancedBookingDetails)
                socket.off(SocketData.kInformPassengerForAdvancedTrip)
                socket.off(SocketData.kAcceptAdvancedBookingRequestNotify)
                //                Singletons.sharedInstance.isPasscodeON = false
                socket.disconnect()
  
                
//                self.navigationController?.popToRootViewController(animated: true)
                
                (UIApplication.shared.delegate as! AppDelegate).GoToLogout()
            }
        })
        
        
    }
    @IBAction func btnEditProfile(_ sender: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "UpdateProfileViewController") as? UpdateProfileViewController

        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    @IBAction func btnEditAccount(_ sender: UIButton)
    {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "EditAccountViewController") as? EditAccountViewController
        
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    @IBOutlet weak var btnCall: UIButton!
    @IBAction func btCallClicked(_ sender: UIButton)
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
    func AnimationToView() {

        self.ConstraintEditProfileX.constant = self.view.frame.origin.x - viewEditProfile.frame.size.width - 20
        self.constraintAccountTailing.constant = -(viewEditProfile.frame.size.width + 20)
        
        self.viewMain.layoutIfNeeded()
        
        UIView.animate(withDuration: 2.0, delay: 0.0, options: .curveEaseIn, animations: {

            
            self.ConstraintEditProfileX.constant = 20
            self.constraintAccountTailing.constant = 20
            
            self.viewMain.layoutIfNeeded()
            
            
        }, completion: { finished in
            
        })
        
        
    }
    

}


extension UIImage {
    
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
}
