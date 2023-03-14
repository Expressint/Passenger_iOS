//
//  SideMenuTableVC.swift
//  Peppea User
//
//  Created by Excellent Webworld on 28/06/19.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}

class SideMenuTableVC: UIViewController {

    static var newInstance: SideMenuTableVC {
        let viewController: SideMenuTableVC = InitialStoryboard.instantiateViewController(withIdentifier: "SidemenuTableVC") as! SideMenuTableVC
        return viewController
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var logoutTouchView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var lblLogout: UILabel!
    
    var arrMenuTitle = [String]()
    var arrMenuIcons = [String]()
    var ProfileData = NSDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.removeObserver(self, name: UpdateProfileNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setProfileData), name: UpdateProfileNotification, object: nil)
        setProfileData()
        
        arrMenuIcons = ["icon_MyBookingUnselect","icon_MyBookingUnselect","icon_FavouriteUnselect","img_mn_receipt_unselect" ,"iconHelp", "icon_InviteFriendUnselect","ic_Language","ic_legal"]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrMenuTitle = ["My Bookings".localized, "Hourly Bookings".localized, "Favourites".localized, "My Receipts".localized, "Help".localized, "Invite Friends".localized,"Select Language".localized,"Legal Stuff".localized]
        tableView.reloadData()
        //setData()
    }
    
    @objc func setProfileData() {
        ProfileData = SingletonClass.sharedInstance.dictProfile
        
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.width / 2
        self.imgProfile.layer.borderWidth = 1.0
        self.imgProfile.layer.borderColor = UIColor.white.cgColor
        self.imgProfile.layer.masksToBounds = true
        self.imgProfile.sd_setShowActivityIndicatorView(true)
        self.imgProfile.sd_setIndicatorStyle(.medium)
        
        lblLogout.text = "Sign out".localized
        deleteButton.setTitle("Delete Account".localized, for: .normal)
        
        if SingletonClass.sharedInstance.isFromSocilaLogin {
            self.imgProfile.sd_setImage(with: URL(string: (WebserviceURLs.kImageBaseURL + (ProfileData.object(forKey: "Image") as! String)) ), completed: nil)
        } else {
            self.imgProfile.sd_setImage(with: URL(string: ((ProfileData.object(forKey: "Image") as! String))), completed: nil)
        }
        
        self.lblName.text = ProfileData.object(forKey: "Fullname") as? String
        self.lblEmail.text = ProfileData.object(forKey: "Email") as? String
    }

    @IBAction func ProfileButtonTapped(_ sender: UIButton) {
        sideMenuSwiftController?.hideMenu()
        NotificationCenter.default.post(name: OpenEditProfile, object: nil)
    }
    
    @IBAction func LogoutButtonTapped(_ sender: UIButton) {
        RMUniversalAlert.show(in: self, withTitle:appName, message: "Are you sure you want to logout?".localized, cancelButtonTitle: nil, destructiveButtonTitle: nil, otherButtonTitles: ["Sign out".localized, "Cancel".localized], tap: {(alert, buttonIndex) in
            if (buttonIndex == 2) {
                
                let socket = (UIApplication.shared.delegate as! AppDelegate).socket
                socket?.off(SocketData.kReceiveGetEstimateFare)
                socket?.off(SocketData.kNearByDriverList)
                socket?.off(SocketData.kAskForTipsToPassengerForBookLater)
                socket?.off(SocketData.kAskForTipsToPassenger)
                socket?.off(SocketData.kAcceptBookingRequestNotification)
                socket?.off(SocketData.kRejectBookingRequestNotification)
                socket?.off(SocketData.kCancelTripByDriverNotficication)
                socket?.off(SocketData.kPickupPassengerNotification)
                socket?.off(SocketData.kBookingCompletedNotification)
                socket?.off(SocketData.kAcceptAdvancedBookingRequestNotification)
                socket?.off(SocketData.kRejectAdvancedBookingRequestNotification)
                socket?.off(SocketData.kAdvancedBookingPickupPassengerNotification)
                socket?.off(SocketData.kReceiveHoldingNotificationToPassenger)
                socket?.off(SocketData.kAdvancedBookingTripHoldNotification)
                socket?.off(SocketData.kReceiveDriverLocationToPassenger)
                socket?.off(SocketData.kAdvancedBookingDetails)
                socket?.off(SocketData.kInformPassengerForAdvancedTrip)
                socket?.off(SocketData.kAcceptAdvancedBookingRequestNotify)
                socket?.disconnect()
                (UIApplication.shared.delegate as! AppDelegate).GoToLogout()
            }
        })
    }
    
    @IBAction func deleteAccountAction() {
        showDeleteSheet()
    }

    func showDeleteSheet() {
        let refreshAlert = UIAlertController(title: "Delete Account".localized, message: "Are you sure you want to delete your account?".localized, preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Yes".localized, style: .default, handler: { (action: UIAlertAction!) in
            self.sideMenuController?.toggle()
            NotificationCenter.default.post(name: DeleteAccount, object: nil)
        }))

        refreshAlert.addAction(UIAlertAction(title: "No".localized, style: .cancel, handler: { (action: UIAlertAction!) in
            self.sideMenuController?.toggle()
              print("Handle No Logic here")
        }))

        present(refreshAlert, animated: true, completion: nil)
    }
}

// MARK: - Table view data source
extension SideMenuTableVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrMenuTitle.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellMenu = tableView.dequeueReusableCell(withIdentifier: "side_menu_cell", for: indexPath) as! SideMenuCell
        cellMenu.iconImageView?.image = UIImage.init(named:  "\(arrMenuIcons[indexPath.row])")
        cellMenu.titleLabel.text = arrMenuTitle[indexPath.row]
        cellMenu.iconImageView?.tintColor = UIColor.black
        cellMenu.titleLabel.textColor = UIColor.black
        return cellMenu
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if arrMenuTitle[indexPath.row] == "My Bookings".localized {
            NotificationCenter.default.post(name: OpenMyBooking, object: nil)
        } else if arrMenuTitle[indexPath.row] == "Hourly Bookings".localized {
            NotificationCenter.default.post(name: OpenHourlyBooking, object: nil)
        } else if arrMenuTitle[indexPath.row] == "Payment Options".localized {
            NotificationCenter.default.post(name: OpenPaymentOption, object: nil)
        } else if arrMenuTitle[indexPath.row] == "Wallet".localized {
            NotificationCenter.default.post(name: OpenWallet, object: nil)
        } else if arrMenuTitle[indexPath.row] == "Favourites".localized {
            NotificationCenter.default.post(name: OpenFavourite, object: nil)
        } else if arrMenuTitle[indexPath.row] == "My Receipts".localized {
            NotificationCenter.default.post(name: OpenMyReceipt, object: nil)
        } else if arrMenuTitle[indexPath.row] == "Invite Friends".localized {
            NotificationCenter.default.post(name: OpenInviteFriend, object: nil)
        } else if arrMenuTitle[indexPath.row] == "My Ratings".localized {
            NotificationCenter.default.post(name: OpenFavourite, object: nil)
        } else if arrMenuTitle[indexPath.row] == "Previous Due".localized {
            NotificationCenter.default.post(name: OpenPastDues, object: nil)
        } else if arrMenuTitle[indexPath.row] == "Legal Stuff".localized {
            showSheet()
        } else if arrMenuTitle[indexPath.row] == "Select Language".localized {
            showSheetForLanguageChange()
        } else if arrMenuTitle[indexPath.row] == "Support".localized {
            UtilityClass.setCustomAlert(title: "Info Message".localized, message: "This feature is coming soon") { (index, title) in
            }
            return
        }
        else if arrMenuTitle[indexPath.row] == "Help".localized {
            self.alertForHelpOptions()
        }
        sideMenuSwiftController?.hideMenu()
    }
    
    func showSheet() {
        let alert = UIAlertController(title: "Legal Stuff".localized, message: "Please Select an Option".localized, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "About Us".localized, style: .default , handler:{ (UIAlertAction)in
            NotificationCenter.default.post(name: openNAboutUs, object: nil)
            self.sideMenuController?.toggle()
        }))
        
        alert.addAction(UIAlertAction(title: "Refund Policy".localized, style: .default , handler:{ (UIAlertAction)in
            NotificationCenter.default.post(name: openNRP, object: nil)
            self.sideMenuController?.toggle()
        }))
        
        alert.addAction(UIAlertAction(title: "privacyPolicy".localized, style: .default , handler:{ (UIAlertAction)in
            NotificationCenter.default.post(name: openNPP, object: nil)
            self.sideMenuController?.toggle()
        }))
        
        alert.addAction(UIAlertAction(title: "Terms and Conditions".localized, style: .default, handler:{ (UIAlertAction)in
            NotificationCenter.default.post(name: openNTC, object: nil)
            self.sideMenuController?.toggle()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler:{ (UIAlertAction)in
            print("User click Cancel")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func alertForHelpOptions() {
        let reasonsVC = CancelAlertViewController(nibName: "CancelAlertViewController", bundle: nil)
        
        reasonsVC.isHelp = true
        reasonsVC.okPressedClosure = { (reason) in
            
        }
        reasonsVC.modalPresentationStyle = .overCurrentContext
        self.present(reasonsVC, animated: true)
    }

    func showSheetForLanguageChange() {
        let alert = UIAlertController(title: "Select Language".localized, message: "Please Select an Option".localized, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "English".localized, style: .default , handler:{ (UIAlertAction)in
            Localize.setCurrentLanguage(Languages.English.rawValue)
        }))
        
        alert.addAction(UIAlertAction(title: "Spanish".localized, style: .default , handler:{ (UIAlertAction)in
            Localize.setCurrentLanguage(Languages.Spanish.rawValue)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler:{ (UIAlertAction)in
            print("User click Cancel")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
}
