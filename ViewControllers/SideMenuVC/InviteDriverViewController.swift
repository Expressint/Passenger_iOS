//
//  InviteDriverViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 14/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import MessageUI
import Social
import SDWebImage

class InviteDriverViewController: BaseViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {

    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------

    @IBOutlet var iconUser: UIImageView!
    var strReferralCode = String()
    var strReferralMoney = String()
    
    @IBOutlet var viewBottom: UIView!

    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet var imgProfilePick: UIImageView!
    @IBOutlet weak var lblReferralCode: UILabel!
    @IBOutlet weak var lblReferralMoney: UILabel!
    @IBOutlet weak var lblWhenAFriendRegister: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    
    @IBOutlet weak var lblShareYourInviteCode: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
       

        let profileData = SingletonClass.sharedInstance.dictProfile

        if let ReferralCode = profileData.object(forKey: "ReferralCode") as? String {
            strReferralCode = ReferralCode
            self.lblReferralCode.text = self.strReferralCode
        }
        
        if let RefarMoney = profileData.object(forKey: "ReferralAmount") as? Double {
            strReferralMoney = String(RefarMoney)
            self.lblReferralMoney.text = "\(currencySign) \(strReferralMoney)"
        }

        if let imgProfile = (profileData).object(forKey: "Image") as? String {
            
            imgProfilePick.sd_setShowActivityIndicatorView(true)
            imgProfilePick.sd_setIndicatorStyle(.gray)
            imgProfilePick.sd_setImage(with: URL(string: imgProfile), completed: nil)
            
        }
        
        

        // border
        viewBottom.layer.borderWidth = 1.0
        viewBottom.layer.borderColor = UIColor.clear.cgColor
        
        // shadow
        viewBottom.layer.shadowColor = UIColor.gray.cgColor
        viewBottom.layer.shadowOffset = CGSize(width: 3, height: 3)
        viewBottom.layer.shadowOpacity = 0.7
        viewBottom.layer.shadowRadius = 4.0
        
        
     
        
        imgProfilePick.layer.cornerRadius = imgProfilePick.frame.width / 2
        imgProfilePick.layer.masksToBounds = true
        imgProfilePick.layer.borderColor = themeYellowColor.cgColor
        imgProfilePick.layer.borderWidth = 1.0
        
        self.setNavBarWithBack(Title: "INVITE FRIENDS".localized, IsNeedRightButton: true)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setLocalization()
    }
    func setLocalization()
    {
        lblWhenAFriendRegister.text = "When a friend register with your code, you will recieve referal amount.".localized
        lblShareYourInviteCode.text = "SHARE YOUR INVITE CODE".localized
        btnShare.setTitle("SHARE".localized, for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnShareClicked(_ sender: Any)
    {
        let decodeResults = SingletonClass.sharedInstance.dictProfile
        print(decodeResults)
        var strName = String()
        
        if decodeResults.count != 0
        {
            
            strName = (decodeResults.object(forKey: "Fullname") as? String)!
        }
        
        let strInvitation1 = "has invited you to become a TanTaxi Passenger".localized
        let strInvitation2 = "Your invite code is:".localized
        
        let strContent = "\(strName) \(strInvitation1)\n \n click here \("https://itunes.apple.com/us/app/TanTaxi/id1445179460?ls=1&mt=8") \n\n \(strInvitation2) \(strReferralCode)"
        // \n https://www.facebook.com/tesluxe \n https://www.instagram.com/teslux3 \n https://www.instagram.com/teslux3 \n https://twitter.com/TESLUX3"
        //        name + " has invited you to become a Tesluxe Passenger.\n" +
        //            "\n" +
        //        click here (https://play.google.com/store/apps/details?id=com.Tesluxe) + "\n\n Your invite code is: "+ iniviteCode + "\n" + https://www.facebook.com/tesluxe
        //            + "\n" + https://www.instagram.com/teslux3
        //            + "\n" +https://twitter.com/TESLUX3
        let share = [strContent]
        
        let activityViewController = UIActivityViewController(activityItems: share, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
   

  
   
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
/*
    func nevigateToBack()
    {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: TabbarController.self) {
                self.sideMenuController?.embed(centerViewController: controller)
                break
            }
        }
    }
*/
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnFacebook(_ sender: UIButton) {
        
        let text = codeToSend()
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)

//        var fbController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//
//        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
//            var completionHandler: SLComposeViewControllerCompletionHandler = {(_ result: SLComposeViewControllerResult) -> Void in
//                fbController?.dismiss(animated: true) { [weak self] in }
//                switch result {
//                case .done:
//                    print("Posted.")
//                case .cancelled:
//                    fallthrough
//                default:
//                    print("Cancelled.")
//                }
//            }
////            fbController?.add(UIImage(named: "1.jpg") ?? UIImage())
//            fbController?.setInitialText(codeToSend())
////            fbController.add(URL(string: "URLString")!)
//            fbController?.completionHandler = completionHandler
//            self.present(fbController!, animated: true) { [weak self] in }
//        }
//        else {
//
//            UtilityClass.setCustomAlert(title: "Not Available App", message: "Please install Facebook app") { (index, title) in
//            }
//        }
        
        
        
//            if let fbSignInDialog = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
//                fbSignInDialog.setInitialText("")
//                self.present(fbSignInDialog, animated: false) { [weak self] in }
//        }
//            else {
//                UtilityClass.setCustomAlert(title: "Not Available App", message: "Please install Facebook app") { (index, title) in
//                }
//            }
//        }

//        commingSoon()
        
    }
    
    @IBAction func btnTwitter(_ sender: UIButton) {
        
        let text = codeToSend()
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        

//        var TWController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
//
//        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
//            var completionHandler: SLComposeViewControllerCompletionHandler = {(_ result: SLComposeViewControllerResult) -> Void in
//                TWController?.dismiss(animated: true) { [weak self] in }
//                switch result {
//                case .done:
//                    print("Posted.")
//                case .cancelled:
//                    fallthrough
//                default:
//                    print("Cancelled.")
//                }
//            }
//            //            fbController?.add(UIImage(named: "1.jpg") ?? UIImage())
//            TWController?.setInitialText(codeToSend())
//            //            fbController.add(URL(string: "URLString")!)
//            TWController?.completionHandler = completionHandler
//            self.present(TWController!, animated: true) { [weak self] in }
//        }
//        else {
//            if let twitterSignInDialog = SLComposeViewController(forServiceType: SLServiceTypeTwitter) {
//
//                twitterSignInDialog.setInitialText(codeToSend())
//
//                if twitterSignInDialog.serviceType == SLServiceTypeTwitter {
//                     self.present(twitterSignInDialog, animated: false)
//                }
//                else {
//
//                    UtilityClass.setCustomAlert(title: "Not Available App", message: "Please install Twitter app") { (index, title) in
//                    }
//                }
//
//            }
//            else {
//                UtilityClass.setCustomAlert(title: "Not Available App", message: "Please install Twitter app") { (index, title) in
//                }
//            }
//        }
 
//        commingSoon()
    }
    
    @IBAction func btnEmail(_ sender: UIButton) {
        
//        let emailTitle = ""
//        var messageBody = ""
//        let toRecipents = [""]
//
//        if (MFMailComposeViewController.canSendMail()) {
//            let mc: MFMailComposeViewController = MFMailComposeViewController()
//            mc.mailComposeDelegate = self
//            mc.setSubject(emailTitle)
//            mc.setMessageBody(codeToSend(), isHTML: false)
//            mc.setToRecipients(toRecipents)
//
//            self.present(mc, animated: true, completion: nil)
//        } else {
//            UtilityClass.setCustomAlert(title: "Email id Missing", message: "Please sign in from email settings") { (index, title) in
//            }
//        }
        
        
        let text = codeToSend()
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)

//        commingSoon()
    }
    
    @IBAction func btnWhatsApp(_ sender: UIButton) {

//        let urlString = codeToSend()
//        let urlStringEncoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
//        let url = NSURL(string: "whatsapp://send?text=\(urlStringEncoded!)")
//        
//        if UIApplication.shared.canOpenURL(url! as URL) {
//            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
//        } else {
//
//            UtilityClass.setCustomAlert(title: "Not Available App", message: "Please install WhatsApp app") { (index, title) in
//            }
//
//        }
        
        let text = codeToSend()
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        
        

//      commingSoon()
    }
    
    @IBAction func btnSMS(_ sender: UIButton) {
        
//        if (MFMessageComposeViewController.canSendText()) {
//            let controller = MFMessageComposeViewController()
//            controller.messageComposeDelegate = self
//            controller.body = codeToSend()
//            controller.recipients = [""]
//            self.present(controller, animated: true, completion: nil)
//        }
        
        let text = codeToSend()
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        
//        commingSoon()
    }
    
    func commingSoon() {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "CommingSoonViewController") as! CommingSoonViewController
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        switch result {
        case MFMailComposeResult.cancelled:
            print("Mail cancelled")
            UtilityClass.setCustomAlert(title: "Error", message: "Mail cancelled") { (index, title) in
            }

        case MFMailComposeResult.saved:
            print("Mail saved")
           
            UtilityClass.setCustomAlert(title: "Done", message: "Mail saved") { (index, title) in
            }
        case MFMailComposeResult.sent:
            print("Mail sent")
            
            UtilityClass.setCustomAlert(title: "Done", message: "Mail sent") { (index, title) in
            }
        case MFMailComposeResult.failed:
            print("Mail sent failure: \(String(describing: error?.localizedDescription))")
      
            UtilityClass.setCustomAlert(title: "Error", message: "Mail sent failure: \(String(describing: error?.localizedDescription))") { (index, title) in
            }
        default:
            
             UtilityClass.setCustomAlert(title: "Error", message: "Something went wrong") { (index, title) in
             }
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        switch result {
        case MessageComposeResult.cancelled:
            print("Mail cancelled")

            UtilityClass.setCustomAlert(title: "Error", message: "Mail cancelled") { (index, title) in
            }
        case MessageComposeResult.sent:
            print("Mail sent")
            
            UtilityClass.setCustomAlert(title: "Done", message: "Mail sent") { (index, title) in
            }
        case MessageComposeResult.failed:
            print("Mail sent failure")

            UtilityClass.setCustomAlert(title: "Error", message: "Mail sent failure") { (index, title) in
            }
        default:

             UtilityClass.setCustomAlert(title: "Error", message: "Something went wrong") { (index, title) in
             }
            break
        }
        
        controller.dismiss(animated: true, completion: nil)
    }

    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    
    func codeToSend() -> String
    {
        let profile = SingletonClass.sharedInstance.dictProfile
        let driverFullName = profile.object(forKey: "Fullname") as! String
        let messageBody = "\(driverFullName) has invited you to become a \(appName) user"
        let androidLink = "Android click \("")"
 
        let iosLink = "iOS click \("https://goo.gl/L6XLqx")"
        
        let yourInviteCode = "Your invite code is: \(strReferralCode)"
        let urlOfTick = "http://www.pickngo.lk/ https://www.facebook.com/PickNGoSrilanka/"
        
        let urlString = "\(messageBody) \n \(androidLink) \n \(iosLink) \n \(yourInviteCode) \n \(urlOfTick)" as String
        return urlString
    }
    
}
