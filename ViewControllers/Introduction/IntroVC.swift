//
//  IntroVC.swift
//  Book A Ride
//
//  Created by Yagnik on 12/01/23.
//  Copyright © 2023 Excellent Webworld. All rights reserved.
//

import UIKit

class IntroVC: BaseViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavBarWithSideMenu(Title: "Services".localized, IsNeedRightButton: false)
        self.setNotificationcenter()
        self.checkForNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeObserver()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupRedirection()
    }
    
    @IBAction func btnRideAction(_ sender: Any) {
        let next = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func btnRideHourlyAction(_ sender: Any) {
        let profileViewController = bookingsStoryboard.instantiateViewController(withIdentifier: "SelectModelVC") as! SelectModelVC
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    @IBAction func btnCorporateRideAction(_ sender: Any) {
        //appDelegate.GoToHome()
    }
    
    func setupRedirection() {
        if currentTripType == "2" {
            let profileViewController = bookingsStoryboard.instantiateViewController(withIdentifier: "SelectModelVC") as! SelectModelVC
            self.navigationController?.pushViewController(profileViewController, animated: true)
        }
    }
    
    func setNotificationcenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(IntroVC.GotoProfilePage), name: OpenEditProfile, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(IntroVC.GotoMyBookingPage), name: OpenMyBooking, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(IntroVC.GotoHourlyBookingPage), name: OpenHourlyBooking, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(IntroVC.GotoPaymentPage), name: OpenPaymentOption, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(IntroVC.GotoMyReceiptPage), name: OpenMyReceipt, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(IntroVC.GotoFavouritePage), name: OpenFavourite, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(IntroVC.GotoInviteFriendPage), name: OpenInviteFriend, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(IntroVC.GotoSettingPage), name: OpenSetting, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(IntroVC.GotoSupportPage), name: OpenSupport, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(IntroVC.GotoPastDuesPage), name: OpenPastDues, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(IntroVC.openPP), name: openNPP, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(IntroVC.openTC), name: openNTC, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(IntroVC.openRP), name: openNRP, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(IntroVC.openAboutUs), name: openNAboutUs, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(IntroVC.openChatForDispatcher), name: openChatForDispatcher1, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(IntroVC.goChatScreen), name: GoToChatScreen, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(IntroVC.deleteAccount), name: DeleteAccount, object: nil)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: OpenEditProfile, object: nil)
        NotificationCenter.default.removeObserver(self, name: OpenMyBooking, object: nil)
        NotificationCenter.default.removeObserver(self, name: OpenHourlyBooking, object: nil)
        NotificationCenter.default.removeObserver(self, name: OpenPaymentOption, object: nil)
        NotificationCenter.default.removeObserver(self, name: OpenMyReceipt, object: nil)
        NotificationCenter.default.removeObserver(self, name: OpenFavourite, object: nil)
        NotificationCenter.default.removeObserver(self, name: OpenInviteFriend, object: nil)
        NotificationCenter.default.removeObserver(self, name: OpenSetting, object: nil)
        NotificationCenter.default.removeObserver(self, name: OpenSupport, object: nil)
        NotificationCenter.default.removeObserver(self, name: OpenPastDues, object: nil)
        NotificationCenter.default.removeObserver(self, name: openNPP, object: nil)
        NotificationCenter.default.removeObserver(self, name: openNTC, object: nil)
        NotificationCenter.default.removeObserver(self, name: openNRP, object: nil)
        NotificationCenter.default.removeObserver(self, name: openNAboutUs, object: nil)
        NotificationCenter.default.removeObserver(self, name: openChatForDispatcher1, object: nil)
        NotificationCenter.default.removeObserver(self, name: GoToChatScreen, object: nil)
        NotificationCenter.default.removeObserver(self, name: DeleteAccount, object: nil)
    }
    
    func checkForNotification(){
        if(AppDelegate.pushNotificationObj != nil){
            if(AppDelegate.pushNotificationType == NotificationTypes.newMeassage.rawValue){
                self.ChatScreen()
            }
        }
    }
    
    @objc func GotoProfilePage() {
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "UpdateProfileViewController") as? UpdateProfileViewController
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    @objc func GotoMyBookingPage() {
        let NextPage = myBookingsStoryboard.instantiateViewController(withIdentifier: "MyBookingViewController") as! MyBookingViewController
        self.navigationController?.pushViewController(NextPage, animated: true)
    }
    @objc func GotoHourlyBookingPage() {
        let NextPage = bookingsStoryboard.instantiateViewController(withIdentifier: "TourTripHistoryVC") as! TourTripHistoryVC
        self.navigationController?.pushViewController(NextPage, animated: true)
    }
    @objc func GotoPaymentPage() {
        if SingletonClass.sharedInstance.CardsVCHaveAryData.count == 0 {
            let next = mainStoryboard.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
            self.navigationController?.pushViewController(next, animated: true)
        } else {
            let next = mainStoryboard.instantiateViewController(withIdentifier: "WalletCardsVC") as! WalletCardsVC
            self.navigationController?.pushViewController(next, animated: true)
        }
    }
    
    @objc func GotoMyReceiptPage() {
        let NextPage = myBookingsStoryboard.instantiateViewController(withIdentifier: "MyReceiptsViewController") as! MyReceiptsViewController
        self.navigationController?.pushViewController(NextPage, animated: true)
    }
    
    @objc func GotoFavouritePage() {
        let NextPage = mainStoryboard.instantiateViewController(withIdentifier: "FavoriteViewController") as! FavoriteViewController
        self.navigationController?.pushViewController(NextPage, animated: true)
    }
    
    @objc func GotoPastDuesPage() {
        let next = mainStoryboard.instantiateViewController(withIdentifier: "PreviousDueViewController") as! PreviousDueViewController
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @objc func GotoInviteFriendPage() {
        let NextPage = mainStoryboard.instantiateViewController(withIdentifier: "InviteDriverViewController") as! InviteDriverViewController
        self.navigationController?.pushViewController(NextPage, animated: true)
    }
    
    @objc func GotoSettingPage() {
        let NextPage = mainStoryboard.instantiateViewController(withIdentifier: "SettingPasscodeVC") as! SettingPasscodeVC
        self.navigationController?.pushViewController(NextPage, animated: true)
    }
    
    @objc func GotoSupportPage() {
        let next = mainStoryboard.instantiateViewController(withIdentifier: "webViewVC") as! webViewVC
        next.headerName = "\(appName)"
        next.strURL = supportURL
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    func ChatScreen() {
        let bookingID = AppDelegate.pushNotificationObj?.booking_id ?? ""
        let senderID = AppDelegate.pushNotificationObj?.sender_id ?? ""
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        viewController.receiverName = ""
        viewController.bookingId = bookingID
        viewController.receiverId = senderID
        viewController.isFromPush = true
        viewController.isDispacherChat = (bookingID == "0" || bookingID == "") ? true : false
        self.navigationController?.pushViewController(viewController, animated: true)
        
        AppDelegate.pushNotificationObj = nil
        AppDelegate.pushNotificationType = nil
    }
    
    @objc func goChatScreen() {
        self.ChatScreen()
    }
    
    @objc func deleteAccount() {
        self.webserviceOfDeleteAccount()
    }
    
    func webserviceOfDeleteAccount() {
        webserviceForDeleteAccount(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
            if (status) {
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
            else {
                print(result)
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "Error", message: res) { (index, title) in
                    }
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "Error", message: resDict.object(forKey: GetResponseMessageKey()) as! String) { (index, title) in
                    }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: GetResponseMessageKey()) as! String) { (index, title) in
                    }
                }
            }
        }
    }
    
    @objc func openPP(){
        let next = mainStoryboard.instantiateViewController(withIdentifier: "webViewVC") as! webViewVC
        next.headerName = "Privacy Policy"
        next.strURL = app_PrivacyPolicy
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @objc func openTC(){
        let next = mainStoryboard.instantiateViewController(withIdentifier: "webViewVC") as! webViewVC
        next.headerName = "Terms and Conditions"
        next.strURL = app_TermsAndCondition
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @objc func openRP(){
        let next = mainStoryboard.instantiateViewController(withIdentifier: "webViewVC") as! webViewVC
        next.headerName = "Refund Policy"
        next.strURL = app_RefundPolicy
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @objc func openChatForDispatcher(){
        let NextPage = mainStoryboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        NextPage.receiverName = DispatchName
        NextPage.bookingId = ""
        NextPage.isDispacherChat = true
        NextPage.receiverId = DispatchId
        self.navigationController?.pushViewController(NextPage, animated: true)
    }
    
    @objc func openAboutUs(){
        let next = mainStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
        self.navigationController?.pushViewController(next, animated: true)
    }
}
