//
//  SideMenuTableViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 26/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import DropDown

protocol delegateForTiCKPayVerifyStatus {
    
    func didRegisterCompleted()
}

//let KEnglish : String = "EN"
//let KSwiley : String = "SW"

class SideMenuTableViewController: UIViewController, delegateForTiCKPayVerifyStatus {
    
    //    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var CollectionView: UICollectionView!
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var btnLS: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var segmentLang: UISegmentedControl!
    @IBOutlet weak var btnSignout: ThemeButton!
    
    @IBOutlet weak var btnSignOut1: UIButton! {
        didSet {
            btnSignOut1.layer.borderColor = UIColor.black.cgColor
            btnSignOut1.layer.borderWidth = 1.0
            btnSignOut1.setTitleColor(UIColor.black, for: .normal)
            btnSignOut1.layer.cornerRadius = 20
        }
    }
    @IBOutlet weak var CollectionHeight: NSLayoutConstraint!
    var ProfileData = NSDictionary()
    var arrMenuIcons = [String]()
    var arrMenuTitle = [String]()
    var strSelectedLaungage = String()
    
    var arrLang: [String] = ["English","Spanish"]
    @IBOutlet weak var btnSelectLanguage: UIButton!
    @IBOutlet weak var btnEnglish: UIButton!
    //-------------------------------------------------------------
    // MARK: - Base Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSelectLanguage.titleLabel?.numberOfLines = 0
        NotificationCenter.default.removeObserver(self, name: UpdateProfileNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setProfileData), name: UpdateProfileNotification, object: nil)
        setProfileData()
        self.navigationController?.isNavigationBarHidden = false
        self.btnSignout.layer.cornerRadius = self.btnSignout.frame.size.height/2
        self.btnSignout.layer.masksToBounds = true
        self.btnSignout.setTitleColor(UIColor.black, for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(self.SetRating), name: NSNotification.Name(rawValue: "rating"), object: nil)
        arrMenuIcons = ["icon_MyBookingUnselect","icon_FavouriteUnselect","img_mn_receipt_unselect" ,"iconHelp", "icon_InviteFriendUnselect"]//icon_UnselectedCard//img_mn_receipt_unselect
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        //        if UserDefaults.standard.value(forKey: "i18n_language") != nil {
        //                        if let language = UserDefaults.standard.value(forKey: "i18n_language") as? String {
        //                            if language == "sw" {
        //                                setLayoutForswahilLanguage()
        //                            }
        //                            else {
        //                                setLayoutForEnglishLanguage()
        //                            }
        //                        }
        //                    }
        arrMenuTitle = ["My Bookings" , "Favourites", "My Receipts", "Help", "Invite Friends"]//"My Receipts","My Ratings","Legal", "Support"]//,"Payment Options"
        
        if((Localize.currentLanguage() == Languages.English.rawValue)){
            self.btnEnglishAction(self.btnEnglish)
        }else{
            self.btnSelectLangAction(self.btnSelectLanguage)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
//        segmentLang.selectedConfiguration(color: .white)
//        segmentLang.selectedSegmentIndex = (Localize.currentLanguage() == Languages.English.rawValue) ? 0 : 1
//        segmentLang.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
        self.setLocalition()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        if segmentLang.selectedSegmentIndex == 0 {
            Localize.setCurrentLanguage(Languages.English.rawValue)
        } else if segmentLang.selectedSegmentIndex == 1 {
            Localize.setCurrentLanguage(Languages.Spanish.rawValue)
        }
    }
    
    @IBAction func btnSelectLangAction(_ sender: Any) {
        self.btnSelectLanguage.isSelected = true
        self.btnEnglish.isSelected = false
        Localize.setCurrentLanguage(Languages.Spanish.rawValue)
        
        self.btnSelectLanguage.layer.borderColor = UIColor(hex: "02A64D").cgColor
        self.btnSelectLanguage.backgroundColor = UIColor(hex: "02A64D")
        self.btnSelectLanguage.layer.borderWidth = 1
        self.btnSelectLanguage.layer.cornerRadius = 5
        
        self.btnEnglish.layer.borderColor = UIColor.black.cgColor
        self.btnEnglish.backgroundColor = UIColor.clear
        self.btnEnglish.layer.borderWidth = 1
        self.btnEnglish.layer.cornerRadius = 5
    }
    
    @IBAction func btnEnglishAction(_ sender: Any) {
       // self.SelectLangDropdownSetup()
        
        self.btnSelectLanguage.isSelected = false
        self.btnEnglish.isSelected = true
        Localize.setCurrentLanguage(Languages.English.rawValue)
        
        self.btnEnglish.layer.borderColor = UIColor(hex: "02A64D").cgColor
        self.btnEnglish.backgroundColor = UIColor(hex: "02A64D")
        self.btnEnglish.layer.borderWidth = 1
        self.btnEnglish.layer.cornerRadius = 5
        
        self.btnSelectLanguage.layer.borderColor = UIColor.black.cgColor
        self.btnSelectLanguage.backgroundColor = UIColor.clear
        self.btnSelectLanguage.layer.borderWidth = 1
        self.btnSelectLanguage.layer.cornerRadius = 5
        
    }
    
    @objc func changeLanguage(){
        self.setLocalition()
    }
    
    
    func setLocalition() {
        self.CollectionView.reloadData()
        self.btnSetting.setTitle("Settings".localized, for: .normal)
        self.btnSignOut1.setTitle("Sign out".localized, for: .normal)
        self.btnLS.underline(text: "Legal Stuff".localized)
        self.btnDelete.underline(text: "Delete Account".localized)
       // btnSelectLanguage.setTitle("Select Language".localized, for: .normal)
    }
    
    @objc func setProfileData() {
        ProfileData = SingletonClass.sharedInstance.dictProfile
        
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.width / 2
        self.imgProfile.layer.borderWidth = 1.0
        self.imgProfile.layer.borderColor = UIColor.white.cgColor
        self.imgProfile.layer.masksToBounds = true
        
        self.imgProfile.sd_setShowActivityIndicatorView(true)
        self.imgProfile.sd_setIndicatorStyle(.whiteLarge)
        
        if SingletonClass.sharedInstance.isFromSocilaLogin {
            self.imgProfile.sd_setImage(with: URL(string: (WebserviceURLs.kImageBaseURL + (ProfileData.object(forKey: "Image") as! String)) ), completed: nil)
        } else {
            self.imgProfile.sd_setImage(with: URL(string: ((ProfileData.object(forKey: "Image") as! String))), completed: nil)
        }
        
        
        //
        self.lblName.text = ProfileData.object(forKey: "Fullname") as? String
        
        self.lblMobileNumber.text = ProfileData.object(forKey: "Email") as? String
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let _ = self.CollectionHeight {
            self.CollectionHeight.constant = self.CollectionView.collectionViewLayout.collectionViewContentSize.height
        }
    }
    
    
    //    func setViewWillAppear() {
    //                    if UserDefaults.standard.value(forKey: "i18n_language") != nil {
    //                        if let language = UserDefaults.standard.value(forKey: "i18n_language") as? String {
    //                            if language == "sw" {
    //                                setLayoutForSwahilLanguage()
    //                            }
    //                            else {
    //                                setLayoutForEnglishLanguage()
    //                            }
    //                        }
    //                    }
    //            }
    
    func setLayoutForswahilLanguage() {
        UserDefaults.standard.set("sw", forKey: "i18n_language")
        UserDefaults.standard.synchronize()
        //            setLayoutForSwahilLanguage()
    }
    func setLayoutForenglishLanguage()
    {
        UserDefaults.standard.set("en", forKey: "i18n_language")
        UserDefaults.standard.synchronize()
        //        setLayoutForSwahilLanguage()
        //        setLayoutForEnglishLanguage()
    }
    @objc func SetRating() {
        self.CollectionView.reloadData()
    }
    
    @objc func setNewBookingOnArray() {
        
        if SingletonClass.sharedInstance.bookingId == "" {
            if (arrMenuTitle.contains("New Booking")) {
                arrMenuIcons.removeFirst()
                arrMenuTitle.removeFirst()
            }
        }
        
        if !(arrMenuTitle.contains("New Booking")) && SingletonClass.sharedInstance.bookingId != "" {
            arrMenuIcons.insert("icon_NewBookingUnselect", at: 0)
            arrMenuTitle.insert("New Booking", at: 0)
        }
        
        self.CollectionView.reloadData()
    }
    
    func giveGradientColor() {
        
        let colorTop =  UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
        let colorMiddle =  UIColor(red: 36/255, green: 24/255, blue: 3/255, alpha: 0.5).cgColor
        let colorBottom = UIColor(red: 64/255, green: 43/255, blue: 6/255, alpha: 0.8).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorMiddle, colorBottom]
        gradientLayer.locations = [ 0.0, 0.5, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
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
    
    // MARK:- IBAction Methods
    
    @IBAction func btnLSAction(_ sender: Any) {
        self.showSheet()
    }
    
    @IBAction func btnDeleteAction(_ sender: Any) {
        self.showDeleteSheet()
    }
    
//    @IBAction func btnLiveHelpAction(_ sender: Any) {
//        
//        self.sideMenuController?.toggle()
//    }
    
    
    @IBAction func btnSettings(_ sender: UIButton) {
        
        NotificationCenter.default.post(name: OpenEditProfile, object: nil)
        sideMenuController?.toggle()
    }
    
    
    @IBAction func btnLogoutAction(_ sender: UIButton) {
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
        
        /*
         
         let socket = (UIApplication.shared.delegate as! AppDelegate).SocketManager
         
         //        socket.off(SocketData.kPassengerCancelTripNotification)
         //        socket.off(SocketData.kNearByDriverList)
         //        socket.off(SocketData.kReceiveGetEstimateFare)
         //        socket.off(SocketData.kAcceptBookingRequestNotification)
         //        socket.off(SocketData.kRejectBookingRequestNotification)
         //
         //        socket.off(SocketData.kGetDriverLocation)
         //        socket.off(SocketData.kPickupPassengerNotification)
         //
         //        socket.off(SocketData.kBookingDetails)
         //        socket.off(SocketData.kAskForTipsToPassenger)
         //
         //
         //        socket.off(SocketData.kAskForTipsToPassengerForBookLater)
         //        socket.off(SocketData.kGetEstimateFare)
         //
         //        socket.off(SocketData.kReceiveMoneyNotify)
         //        socket.off(SocketData.kAcceptAdvancedBookingRequestNotification)
         //
         //        socket.off(SocketData.kRejectAdvancedBookingRequestNotification)
         //        socket.off(SocketData.kAcceptAdvancedBookingRequestNotify)
         //
         //        socket.off(SocketData.kAdvancedBookingPickupPassengerNotification)
         //        socket.off(SocketData.kAdvancedBookingTripHoldNotification)
         //        socket.off(SocketData.kAdvancedBookingDetails)
         
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
         
         for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
         print("\(key) = \(value) \n")
         
         if key == "Token" {
         
         }
         else {
         UserDefaults.standard.removeObject(forKey: key)
         }
         }
         //        UserDefaults.standard.set(false, forKey: kIsSocketEmited)
         //        UserDefaults.standard.synchronize()
         
         SingletonClass.sharedInstance.strPassengerID = ""
         UserDefaults.standard.removeObject(forKey: "profileData")
         SingletonClass.sharedInstance.isUserLoggedIN = false
         
         self.performSegue(withIdentifier: "unwindToContainerVC", sender: self)
         UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
         
         UserDefaults.standard.removeObject(forKey: "Passcode")
         SingletonClass.sharedInstance.setPasscode = ""
         
         UserDefaults.standard.removeObject(forKey: "isPasscodeON")
         SingletonClass.sharedInstance.isPasscodeON = false
         */
    }
    
    
    
    // MARK: - Table view data source
    
    /*
     
     func numberOfSections(in tableView: UITableView) -> Int {
     // #warning Incomplete implementation, return the number of sections
     return 2
     }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     if section == 0
     {
     return 1
     }
     else
     {
     return arrMenuIcons.count
     }
     }
     
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
     
     if (indexPath.section == 0)
     {
     let cellHeader = tableView.dequeueReusableCell(withIdentifier: "MainHeaderTableViewCell") as! MainHeaderTableViewCell
     cellHeader.selectionStyle = .none
     cellHeader.imgProfile.layer.cornerRadius = cellHeader.imgProfile.frame.width / 2
     cellHeader.imgProfile.layer.borderWidth = 1.0
     cellHeader.imgProfile.layer.borderColor = UIColor.white.cgColor
     cellHeader.imgProfile.layer.masksToBounds = true
     
     cellHeader.imgProfile.sd_setImage(with: URL(string: ProfileData.object(forKey: "Image") as! String), completed: nil)
     cellHeader.lblName.text = ProfileData.object(forKey: "Fullname") as? String
     
     cellHeader.lblMobileNumber.text = ProfileData.object(forKey: "MobileNo") as? String
     cellHeader.lblRating.text = SingletonClass.sharedInstance.passengerRating
     
     return cellHeader
     }
     else
     {
     let cellMenu = tableView.dequeueReusableCell(withIdentifier: "ContentTableViewCell") as! ContentTableViewCell
     
     cellMenu.imgDetail?.image = UIImage.init(named:  "\(arrMenuIcons[indexPath.row])")
     cellMenu.selectionStyle = .none
     
     cellMenu.lblTitle.text = arrMenuTitle[indexPath.row]
     
     return cellMenu
     }
     
     
     // Configure the cell...
     
     //        return cellHeader
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
     if indexPath.section == 0 {
     let next = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
     self.navigationController?.pushViewController(next, animated: true)
     
     }
     else if (indexPath.section == 1)
     {
     if arrMenuTitle[indexPath.row] == "New Booking" {
     NotificationCenter.default.post(name: NotificationForBookingNewTrip, object: nil)
     sideMenuController?.toggle()
     
     }
     if arrMenuTitle[indexPath.row] == "My Booking"
     {
     NotificationCenter.default.post(name: OpenMyBooking, object: nil)
     sideMenuController?.toggle()
     }
     
     if arrMenuTitle[indexPath.row] == "Payment Options" {
     NotificationCenter.default.post(name: OpenPaymentOption, object: nil)
     sideMenuController?.toggle()
     }
     else if arrMenuTitle[indexPath.row] == "Wallet" {
     NotificationCenter.default.post(name: OpenWallet, object: nil)
     sideMenuController?.toggle()
     }
     else if arrMenuTitle[indexPath.row] == "Favourites" {
     NotificationCenter.default.post(name: OpenFavourite, object: nil)
     sideMenuController?.toggle()
     }
     else if arrMenuTitle[indexPath.row] == "My Receipts" {
     NotificationCenter.default.post(name: OpenMyReceipt, object: nil)
     sideMenuController?.toggle()
     }
     else if arrMenuTitle[indexPath.row] == "Invite Friends" {
     NotificationCenter.default.post(name: OpenInviteFriend, object: nil)
     sideMenuController?.toggle()
     }
     else if arrMenuTitle[indexPath.row] == "Settings" {
     NotificationCenter.default.post(name: OpenSetting, object: nil)
     sideMenuController?.toggle()
     }
     else if arrMenuTitle[indexPath.row] == "Become a \(appName) Driver" {
     UIApplication.shared.openURL(NSURL(string: "https://itunes.apple.com/us/app/pick-n-go-driver/id1320783710?mt=8")! as URL)
     }
     else if arrMenuTitle[indexPath.row] == "Package History"
     {
     let next = self.storyboard?.instantiateViewController(withIdentifier: "PackageHistoryViewController") as! PackageHistoryViewController
     self.navigationController?.pushViewController(next, animated: true)
     }
     
     
     if (arrMenuTitle[indexPath.row] == "LogOut")
     {
     self.performSegue(withIdentifier: "unwindToContainerVC", sender: self)
     UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
     
     UserDefaults.standard.removeObject(forKey: "Passcode")
     SingletonClass.sharedInstance.setPasscode = ""
     
     UserDefaults.standard.removeObject(forKey: "isPasscodeON")
     SingletonClass.sharedInstance.isPasscodeON = false
     
     }
     //            else if (indexPath.row == arrMenuTitle.count - 2)
     //            {
     //                self.performSegue(withIdentifier: "pushToBlank", sender: self)
     //            }
     }
     
     
     }
     
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     if (indexPath.section == 0)
     {
     return 130
     }
     else
     {
     return 42
     }
     }
     */
    
    
    func didRegisterCompleted() {
        
        webserviceOfTickPayStatus()
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    /* func navigateToTiCKPay() {
     //        webserviceOfTickPayStatus()
     
     if self.varifyKey == 0 {
     let next = self.storyboard?.instantiateViewController(withIdentifier: "TickPayRegistrationViewController") as! TickPayRegistrationViewController
     next.delegateForVerifyStatus = self
     self.navigationController?.pushViewController(next, animated: true)
     }
     
     else if self.varifyKey == 1 {
     let next = self.storyboard?.instantiateViewController(withIdentifier: "TiCKPayNeedToVarifyViewController") as! TiCKPayNeedToVarifyViewController
     self.navigationController?.pushViewController(next, animated: true)
     }
     
     else if self.varifyKey == 2 {
     let next = self.storyboard?.instantiateViewController(withIdentifier: "PayViewController") as! PayViewController
     self.navigationController?.pushViewController(next, animated: true)
     }
     }*/
    
    @IBAction func btnProfilePickClicked(_ sender: Any)
    {
        //        let next = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        //        self.navigationController?.pushViewController(next, animated: true)
        //        NotificationCenter.default.post(name: OpenEditProfile, object: nil)
        //        sideMenuController?.toggle()
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    var varifyKey = Int()
    func webserviceOfTickPayStatus() {
        
        webserviceForTickpayApprovalStatus(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                if let id = (result as! [String:AnyObject])["Verify"] as? String {
                    
                    //                    SingletonClass.sharedInstance.TiCKPayVarifyKey = Int(id)!
                    self.varifyKey = Int(id)!
                }
                else if let id = (result as! [String:AnyObject])["Verify"] as? Int {
                    
                    //                    SingletonClass.sharedInstance.TiCKPayVarifyKey = id
                    self.varifyKey = id
                }
                
            }
            else {
                print(result)
            }
        }
    }
    
}


// MARK: - UICollectionView DataSource & Delegate Methods

extension SideMenuTableViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrMenuTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = self.CollectionView.dequeueReusableCell(withReuseIdentifier: "SideMenuCollectionViewCell", for: indexPath) as! SideMenuCollectionViewCell
        
        customCell.imgDetail?.image = UIImage.init(named:  "\(arrMenuIcons[indexPath.row])")
        customCell.lblTitle.text = arrMenuTitle[indexPath.row].localized
        //        customCell.lblTitle.font = UIFont.regular(ofSize: 12.0)
        if(arrMenuTitle[indexPath.row].localized == "SOS")
        {
            customCell.lblTitle.textColor = .red
        }
        else
        {
            customCell.imgDetail?.tintColor = UIColor.black
            customCell.lblTitle.textColor = UIColor.black
            
        }
        
        return customCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //        if arrMenuTitle[indexPath.row] == "New Booking" {
        //            NotificationCenter.default.post(name: NotificationForBookingNewTrip, object: nil)
        //            sideMenuController?.toggle()
        //
        //        }
        if arrMenuTitle[indexPath.row] == "My Bookings"
        {
            NotificationCenter.default.post(name: OpenMyBooking, object: nil)
            sideMenuController?.toggle()
        }
        
        else if arrMenuTitle[indexPath.row] == "Payment Options" {
            NotificationCenter.default.post(name: OpenPaymentOption, object: nil)
            sideMenuController?.toggle()
        }
        else if arrMenuTitle[indexPath.row] == "Wallet" {
            NotificationCenter.default.post(name: OpenWallet, object: nil)
            sideMenuController?.toggle()
        }
        else if arrMenuTitle[indexPath.row] == "Favourites" {
            NotificationCenter.default.post(name: OpenFavourite, object: nil)
            sideMenuController?.toggle()
        }
        else if arrMenuTitle[indexPath.row] == "My Receipts" {
            NotificationCenter.default.post(name: OpenMyReceipt, object: nil)
            sideMenuController?.toggle()
        }
        else if arrMenuTitle[indexPath.row] == "Invite Friends" {
//            NotificationCenter.default.post(name: OpenInviteFriend, object: nil)
            self.inviteDriver()
            sideMenuController?.toggle()
        }
        else if arrMenuTitle[indexPath.row] == "My Ratings" {
            NotificationCenter.default.post(name: OpenFavourite, object: nil)
            sideMenuController?.toggle()
        }
        else if arrMenuTitle[indexPath.row] == "Previous Due" {
            NotificationCenter.default.post(name: OpenPastDues, object: nil)
            sideMenuController?.toggle()
        }
        else if arrMenuTitle[indexPath.row] == "Legal" {
            NotificationCenter.default.post(name: OpenSetting, object: nil)
            sideMenuController?.toggle()
        }
        else if arrMenuTitle[indexPath.row] == "Support" {
            UtilityClass.setCustomAlert(title: "Info Message".localized, message: "This feature is coming soon") { (index, title) in
            }
            return
            /* Rj Change
             NotificationCenter.default.post(name: OpenSupport, object: nil)
             sideMenuController?.toggle()
             */
        }
        else if arrMenuTitle[indexPath.row] == "Help" {
            //            UtilityClass.showAlert(appName, message: "This feature is coming soon", vc: self)
//            self.dialNumber(number: helpLineNumber)
            self.alertForHelpOptions()
        }
    }
    
    func inviteDriver(){
        NotificationCenter.default.post(name: OpenInviteFriend, object: nil)
        
//        let decodeResults = SingletonClass.sharedInstance.dictProfile
//        print(decodeResults)
//        var strName = String()
//
//        if decodeResults.count != 0
//        {
//
//            strName = (decodeResults.object(forKey: "Fullname") as? String)!
//        }
//
//        let strInvitation1 = "has invited you to become a Book A ride Passenger".localized
//        let strInvitation2 = "Your invite code is:".localized
//
//        let strContent = "\(strName) \(strInvitation1)\n \n For iOS Click Here : \(appURLiOS) \n \n For Android Click Here : \(appURLAndroid)"
//        let share = [strContent]
//
//        let activityViewController = UIActivityViewController(activityItems: share, applicationActivities: nil)
//        activityViewController.popoverPresentationController?.sourceView = self.view
//        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
        //        let customCell = self.CollectionView.dequeueReusableCell(withReuseIdentifier: "SideMenuCollectionViewCell", for: indexPath) as! SideMenuCollectionViewCell
        
        if(arrMenuTitle[indexPath.row].localized != "SOS")
        {
            let customCell = collectionView.cellForItem(at: indexPath) as! SideMenuCollectionViewCell
            customCell.imgDetail?.tintColor = themeYellowColor
            customCell.lblTitle.textColor = themeYellowColor
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        
        if(arrMenuTitle[indexPath.row].localized != "SOS")
        {
            let customCell = collectionView.cellForItem(at: indexPath) as! SideMenuCollectionViewCell
            customCell.imgDetail?.tintColor = UIColor.black
            customCell.lblTitle.textColor = UIColor.black
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let MenuWidth = sideMenuController?.sideViewController.view.frame.width
        //        let CollectionCellWidth = (MenuWidth! - 95.0) / 2
        
        let CollectionCellWidth = (MenuWidth! - 80.0) / 2
        return CGSize(width: CollectionCellWidth, height: CollectionCellWidth)
    }
    
    func alertForHelpOptions()
    {
        let reasonsVC = CancelAlertViewController(nibName: "CancelAlertViewController", bundle: nil)
        
        reasonsVC.isHelp = true
        reasonsVC.okPressedClosure = { (reason) in
            
        }
        reasonsVC.modalPresentationStyle = .overCurrentContext
        self.present(reasonsVC, animated: true)
    }
    
    func dialNumber(number : String) {
        
        if let url = URL(string: "tel://\(number)"),
           UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
        }
    }
}

