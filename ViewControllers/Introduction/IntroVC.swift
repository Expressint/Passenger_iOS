//
//  IntroVC.swift
//  Book A Ride
//
//  Created by Yagnik on 12/01/23.
//  Copyright © 2023 Excellent Webworld. All rights reserved.
//

import UIKit
import FSPagerView
import SDWebImage
import SafariServices

class IntroVC: BaseViewController {
    
    @IBOutlet weak var lblServices: UILabel!
    @IBOutlet weak var lblGoAnywhere: UILabel!
    @IBOutlet weak var lblRide: UILabel!
    @IBOutlet weak var lblHourly: UILabel!
    @IBOutlet weak var lblCorporate: UILabel!
    @IBOutlet weak var vWAdvertisement: FSPagerView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var arrAdvImages : [[String: AnyObject]] = []
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    let socket = (UIApplication.shared.delegate as! AppDelegate).socket
    
    override func viewWillAppear(_ animated: Bool) {
       
        self.checkForNotification()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
        self.socketMethods()
        self.setNotificationcenter()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeObserver()
        self.RentalOffMethods()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webserviceOfAdvList()
        
        self.setLocalization()
        self.setupRedirection()
        
    }
    
    
    func socketMethods() {
        socket?.on(clientEvent: .disconnect) { (data, ack) in
            print ("socket? is disconnected please reconnect")
        }
        
        socket?.on(clientEvent: .reconnect) { (data, ack) in
            print ("socket? is reconnected")
        }
        
        socket?.on(clientEvent: .connect) { data, ack in
            print("socket? BaseURl : \(SocketData.kBaseURL)")
            print("socket? connected")
            self.RentalOnMethods()
        }
        
        if socket?.status == .connected {
            self.RentalOnMethods()
       } else {
            self.socket?.connect()
        }
    }
    
    func RentalOnMethods() {
        self.socketForAdv()
    }
    
    func RentalOffMethods() {
        self.socket?.off(SocketData.AdvertisementReportReponse)
    }
    
    @objc func changeLanguage(){
        self.setLocalization()
    }
    func setLocalization(){
        self.setNavBarWithSideMenu(Title: "Services".localized, IsNeedRightButton: true, isWhatsApp: true)
        self.lblServices.text = "Services".localized
        self.lblGoAnywhere.text = "GoAnywhere".localized
        self.lblRide.text = "Ride".localized
        self.lblHourly.text = "Hourly".localized
        self.lblCorporate.text = "Corporate".localized
    }
    
    func setupPagerView() {
        pageControl.numberOfPages = arrAdvImages.count
        pageControl.currentPage = 0
        
        vWAdvertisement.dataSource = self
        vWAdvertisement.delegate = self
        
        vWAdvertisement.automaticSlidingInterval = 3.0
        vWAdvertisement.isInfinite = true
        vWAdvertisement.transformer = FSPagerViewTransformer(type: .linear)
        vWAdvertisement.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        vWAdvertisement.reloadData()
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
        if currentTripType == "1" {
            let next = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.navigationController?.pushViewController(next, animated: true)
        }else if currentTripType == "2" {
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
        NotificationCenter.default.addObserver(self, selector: #selector(IntroVC.goChatScreen), name: GoToChatScreen, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(IntroVC.deleteAccount), name: DeleteAccount, object: nil)
        
        let AdvNotification = "AdvNotification"
        let notificationName = Notification.Name(AdvNotification)
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
        NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: nil) { notification in
            if let data = notification.userInfo as? [String: String] {
                let Id = data["Id"]
                let Url = data["Url"]
                self.socketEmitForAdv(id: Id ?? "", Url: Url ?? "")
            }
        }
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
                    Toast.show(message: res, state: .failure)
                }
                else if let resDict = result as? NSDictionary {
                    Toast.show(message: resDict.object(forKey: GetResponseMessageKey()) as? String ?? "", state: .failure)
                }
                else if let resAry = result as? NSArray {
                    Toast.show(message: (resAry.object(at: 0) as! NSDictionary).object(forKey: GetResponseMessageKey()) as? String ?? "", state: .failure)
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
    
    @objc func openAboutUs(){
        let next = mainStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
        self.navigationController?.pushViewController(next, animated: true)
    }
}

extension IntroVC: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.arrAdvImages.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
//        cell.imageView?.image = nil
//        if index.isMultiple(of: 2) {
//            let videoURL = Bundle.main.url(forResource: "demo", withExtension: "mp4")!
//            let asset = AVAsset(url: videoURL)
//            let durationInSeconds = CMTimeGetSeconds(asset.duration)
//            player = AVPlayer(url: videoURL)
//            playerLayer = AVPlayerLayer(player: player)
//            playerLayer?.frame = cell.contentView.bounds
//            cell.contentView.layer.addSublayer(playerLayer!)
//            player?.play()
//            vWAdvertisement.automaticSlidingInterval = durationInSeconds
//
//        } else {
//            vWAdvertisement.automaticSlidingInterval = 3
//            let urlLogo = WebserviceURLs.kBaseImageURL +  (arrAdvImages[index]["BannerImage"] as? String ?? "")
//            cell.imageView?.sd_setImage(with: URL(string: urlLogo), placeholderImage: UIImage(named: "Banner_Placeholder"), options: [.continueInBackground], progress: nil, completed: { (image, error, cache, url) in
//                if (error == nil) {
//                    cell.imageView?.image = image
//                }
//            })
//
//            cell.contentView.layer.sublayers?.forEach({ layer in
//                if layer is AVPlayerLayer {
//                    layer.removeFromSuperlayer()
//                }
//            })
//        }

        let urlLogo = WebserviceURLs.kBaseImageURL +  (arrAdvImages[index]["BannerImage"] as? String ?? "")
        cell.imageView?.sd_setImage(with: URL(string: urlLogo), placeholderImage: UIImage(named: "Banner_Placeholder"), options: [.continueInBackground], progress: nil, completed: { (image, error, cache, url) in
            if (error == nil) {
                cell.imageView?.image = image
            }
        })
        
        cell.imageView?.contentMode = .scaleAspectFit
        cell.cornerRadius = 10
        cell.contentMode = .scaleAspectFit
        cell.clipsToBounds = true
        cell.layer.masksToBounds = true
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        self.socketEmitForAdv(id: arrAdvImages[index]["Id"] as? String ?? "", Url: arrAdvImages[index]["WebsiteURL"] as? String ?? "")
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pageControl.currentPage = pagerView.currentIndex
    }
}

extension IntroVC {
    func webserviceOfAdvList() {
        webserviceForAdvList { (result, status) in
            if (status) {
                print(result)
                let data = result["data"] as? [[String: AnyObject]] ?? [[:]]
                self.arrAdvImages = data
                self.setupPagerView()
            }else {
                if let res = result as? String {
                    Toast.show(message: res, state: .failure)
                }
                else if let resDict = result as? NSDictionary {
                    Toast.show(message: resDict.object(forKey: GetResponseMessageKey()) as? String ?? "", state: .failure)
                }
                else if let resAry = result as? NSArray {
                    Toast.show(message: (resAry.object(at: 0) as! NSDictionary).object(forKey: GetResponseMessageKey()) as? String ?? "", state: .failure)
                }
            }
        }
    }
    
    func gotoPage(strUrl: String) {
        let next = mainStoryboard.instantiateViewController(withIdentifier: "webViewVC") as! webViewVC
        next.headerName = "BookARide"
        next.strURL = strUrl
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    func viewAdv(URLMain: String) {
        guard let url = URL(string: URLMain) else {return}
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
    }
}

extension IntroVC {
    func socketForAdv() {
        self.socket?.on(SocketData.AdvertisementReportReponse, callback: { (data, ack) in
            print ("AdvertisementReportReponse : \(data)")
            let msg = (data as NSArray)
        })
    }
    
    func socketEmitForAdv(id: String, Url: String) {
        let myJSON = ["UserId" : SingletonClass.sharedInstance.strPassengerID,
                      "AdvertisementId": id,
                      "Lat": "\(SingletonClass.sharedInstance.passengerLocation?.latitude ?? 0.0)",
                      "Long": "\(SingletonClass.sharedInstance.passengerLocation?.longitude ?? 0.0)"] as [String : Any]
        
        self.socket?.emit(SocketData.AdvertisementReportCreate, with: [myJSON], completion: nil)
        print ("\(SocketData.AdvertisementReportCreate) : \(myJSON)")
        
        self.viewAdv(URLMain: Url)
    }
}
