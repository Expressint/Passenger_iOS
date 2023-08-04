//
//  AJAlertController.Swift
//  AJAlertController
//
//  Created by Arpit Jain on 13/12/17.
//  Copyright © 2017 Arpit Jain. All rights reserved.
//

import UIKit
import Foundation
import MessageUI

class AJAlertController: UIViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate  {
    
    // MARK:- Private Properties
    // MARK:-

    private var strAlertTitle = String()
    private var strAlertText = String()
    private var btnCancelTitle:String?
    private var btnOtherTitle:String?
    private var showStack: Bool = true
    private var showContact: Bool = true
    
    private let btnOtherColor  = UIColor.black//UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
    private let btnCancelColor = UIColor.black//UIColor(red: 255.0/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
    
    // MARK:- Public Properties
    // MARK:-

    @IBOutlet var viewAlert: UIView!
    @IBOutlet weak var viewSubAlert: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblAlertText: UILabel?
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var btnOther: UIButton!
    @IBOutlet var btnOK: UIButton!
    @IBOutlet var viewAlertBtns: UIView!
    
    @IBOutlet var btnYes: UIButton!
    @IBOutlet var btnNo: UIButton!
    
    @IBOutlet weak var stackBtns: UIStackView!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnMsg: UIButton!
    
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnPhone: UIButton!
    
    // @IBOutlet var alertWidthConstraint: NSLayoutConstraint!
    
    /// AlertController Completion handler
    typealias alertCompletionBlock = ((Int, String) -> Void)?
    var block : alertCompletionBlock?
    
    // MARK:- AJAlertController Initialization
    // MARK:-
    
    /**
     Creates a instance for using AJAlertController
     - returns: AJAlertController
     */
    static func initialization() -> AJAlertController
    {
        let alertController = AJAlertController(nibName: "AJAlertController", bundle: nil)
        return alertController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnOK.setTitle("OK".localized, for: .normal)
        
        self.btnEmail.isHidden = true
        self.btnPhone.isHidden = true
        
        self.btnPhone.underline(text: "\("Phone Number :".localized) +592-223-9988")
        self.btnEmail.underline(text: "\("Email :".localized) info@bookaridegy.com")
        
        setupAJAlertController()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let image = (Localize.currentLanguage() == Languages.English.rawValue) ? "ic_RedChat" : "ic_RedChat_es"
        self.btnMsg.setBackgroundImage(UIImage(named: image), for: .normal)
    }
    
    // MARK:- AJAlertController Private Functions
    // MARK:-
    
    /// Inital View Setup
    private func setupAJAlertController(){
        
        btnYes.isHidden = true
        btnNo.isHidden = true
        
        let visualEffectView   = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.alpha = 0.8
        visualEffectView.frame = self.view.bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped)))
        self.view.insertSubview(visualEffectView, at: 0)
        
        preferredAlertWidth()
        
        viewAlert.layer.cornerRadius  = 10.0
        viewAlert.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0)
        viewAlert.layer.shadowColor   = UIColor(white: 0.0, alpha: 1.0).cgColor
        viewAlert.layer.shadowOpacity = 0.3
        viewAlert.layer.shadowRadius  = 3.0
        
        viewSubAlert.layer.cornerRadius  = 10.0
        viewSubAlert.layer.masksToBounds = true
        
//        btnOther.backgroundColor = themeButtonColor
//        btnCancel.backgroundColor = themeButtonColor
//        btnOK.backgroundColor = themeButtonColor
        
        btnOther.backgroundColor = themeAppMainColor
        btnCancel.backgroundColor = themeAppMainColor
        btnOK.backgroundColor = themeAppMainColor
        
        stackBtns.isHidden = showStack
        btnEmail.isHidden = showContact
        btnPhone.isHidden = showContact
        
        btnPhone.setTitle("\("Phone Number :".localized) +592-223-9988", for: .normal)
        btnEmail.setTitle("\("Email :".localized) info@bookaridegy.com", for: .normal)
        
        lblTitle.text = strAlertTitle
        lblAlertText?.text = strAlertText
        lblAlertText?.textAlignment = (showContact) ? .center : .left
        
        let msg = (Localize.currentLanguage() == Languages.English.rawValue) ? msgNoCarsAvailable : msgNoCarsAvailable_Spanish
        if(strAlertText == msg) {
            
            btnYes.isHidden = false
            btnYes.titleLabel?.numberOfLines = 0
            btnYes.titleLabel?.textAlignment = .center
            btnYes.setTitle("Yes, I'll wait for the next available car".localized, for: .normal)
            
            btnNo.isHidden = false
            btnNo.titleLabel?.numberOfLines = 0
            btnNo.titleLabel?.textAlignment = .center
            btnNo.setTitle("No problem, I'll find another means of transportation".localized, for: .normal)
            
            btnOther.isHidden = true
            btnCancel.isHidden = true
            btnOK.isHidden = true
            return
        }
        
        if let aCancelTitle = btnCancelTitle {
            btnCancel.setTitle(aCancelTitle, for: .normal)
            btnOK.setTitle(nil, for: .normal)
            btnCancel.setTitleColor(btnCancelColor, for: .normal)
        } else {
            btnCancel.isHidden  = true
        }
        
        if let aOtherTitle = btnOtherTitle {
            btnOther.setTitle(aOtherTitle, for: .normal)
            btnOK.setTitle(nil, for: .normal)
            btnOther.setTitleColor(btnOtherColor, for: .normal)
        } else {
            btnOther.isHidden  = true
        }
        
        if btnOK.title(for: .normal) != nil {
            btnOK.setTitleColor(btnOtherColor, for: .normal)
        } else {
            btnOK.isHidden  = true
        }
        
    }
    
    /// Setup different widths for iPad and iPhone
    private func preferredAlertWidth()
    {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: break
        //        alertWidthConstraint.constant = 280.0
        case .pad: break
          //      alertWidthConstraint.constant = 340.0
            case .unspecified: break
            case .tv: break
            case .carPlay: break
                
        
        case .mac: break
        }
    }
    
    /// Create and Configure Alert Controller
    private func configure(title: String, message:String, btnCancelTitle:String?, btnOtherTitle:String?, showStack: Bool = false, showContact: Bool = false)
    {
        self.strAlertTitle = title
        self.strAlertText = message
        self.btnCancelTitle = btnCancelTitle
        self.btnOtherTitle = btnOtherTitle
        self.showStack = showStack
        self.showContact = showContact
    }
    
    /// Show Alert Controller
    private func show()
    {
        if let appDelegate = UIApplication.shared.delegate, let window = appDelegate.window, let rootViewController = window?.rootViewController {
            
            var topViewController = rootViewController
            while topViewController.presentedViewController != nil {
                topViewController = topViewController.presentedViewController!
            }
            
            topViewController.addChildViewController(self)
            topViewController.view.addSubview(view)
            viewWillAppear(true)
            didMove(toParentViewController: topViewController)
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.alpha = 0.0
            view.frame = topViewController.view.bounds
            
            viewAlert.alpha     = 0.0
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.view.alpha = 1.0
            }, completion: nil)
            
            viewAlert.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            viewAlert.center    = CGPoint(x: (self.view.bounds.size.width/2.0), y: (self.view.bounds.size.height/2.0)-10)
            UIView.animate(withDuration: 0.2 , delay: 0.1, options: .curveEaseOut, animations: { () -> Void in
                self.viewAlert.alpha = 1.0
                self.viewAlert.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.viewAlert.center    = CGPoint(x: (self.view.bounds.size.width/2.0), y: (self.view.bounds.size.height/2.0))
            }, completion: nil)
        }
    }
    
    /// Hide Alert Controller
    private func hide()
    {
        self.view.endEditing(true)
        self.viewAlert.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
            self.viewAlert.alpha = 0.0
            self.viewAlert.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            self.viewAlert.center    = CGPoint(x: (self.view.bounds.size.width/2.0), y: (self.view.bounds.size.height/2.0)-5)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.25, delay: 0.05, options: .curveEaseIn, animations: { () -> Void in
            self.view.alpha = 0.0
            
        }) { (completed) -> Void in
            
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
    }
    
    // MARK:- UIButton Clicks
    // MARK:-
    @IBAction func btnPhoneAction(_ sender: Any) {
        hide()
        let contactNumber = DispatchCall 
        if contactNumber == "" {
            UtilityClass.setCustomAlert(title: "\(appName)", message: "Contact number is not available") { (index, title) in
            }
        } else {
            callNumber(phoneNumber: contactNumber)
        }
    }
    
    @IBAction func btnEmailAction(_ sender: Any) {
        hide()
        if !MFMailComposeViewController.canSendMail() {
            return
        }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients(["info@bookaridegy.com"])
        composeVC.setSubject("")
        composeVC.setMessageBody("", isHTML: false)
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        switch result {
        case MFMailComposeResult.cancelled:
            print("Mail cancelled")
            UtilityClass.setCustomAlert(title: "Error", message: "Mail cancelled".localized) { (index, title) in
            }

        case MFMailComposeResult.saved:
            print("Mail saved")
           
            UtilityClass.setCustomAlert(title: "Done".localized, message: "Mail saved".localized) { (index, title) in
            }
        case MFMailComposeResult.sent:
            print("Mail sent")
            
            UtilityClass.setCustomAlert(title: "Done".localized, message: "Mail sent".localized) { (index, title) in
            }
        case MFMailComposeResult.failed:
            print("Mail sent failure: \(String(describing: error?.localizedDescription))")
      
            UtilityClass.setCustomAlert(title: "Error", message: "\("Mail sent failure".localized): \(String(describing: error?.localizedDescription))") { (index, title) in
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

            UtilityClass.setCustomAlert(title: "Error", message: "Mail cancelled".localized) { (index, title) in
            }
        case MessageComposeResult.sent:
            print("Mail sent")
            
            UtilityClass.setCustomAlert(title: "Done".localized, message: "Mail sent".localized) { (index, title) in
            }
        case MessageComposeResult.failed:
            print("Mail sent failure")

            UtilityClass.setCustomAlert(title: "Error", message: "Mail sent failure".localized) { (index, title) in
            }
        default:

             UtilityClass.setCustomAlert(title: "Error", message: "Something went wrong") { (index, title) in
             }
            break
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCallAcion(_ sender: Any) {
        hide()
        let contactNumber = helpLineNumber //strPassengerMobileNumber
        if contactNumber == "" {
            UtilityClass.setCustomAlert(title: "\(appName)", message: "Contact number is not available") { (index, title) in
            }
        }
        else {
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
    
    @IBAction func btnMsgAction(_ sender: Any) {
        openChatForDispatcher()
        hide()
    }
    
    func openChatForDispatcher(){
        let NextPage = mainStoryboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        NextPage.receiverName = DispatchName
        NextPage.bookingId = ""
        NextPage.isDispacherChat = true
        NextPage.receiverId = DispatchId
        self.navigationController?.pushViewController(NextPage, animated: true)
    }
    
    @IBAction func btnCancelTapped(sender: UIButton) {
        block!!(1,btnCancelTitle ?? "")
        hide()
    }
    
    @IBAction func btnOtherTapped(sender: UIButton) {
        block!!(1, btnOtherTitle ?? "")
        hide()
    }
    
    @IBAction func btnOkTapped(sender: UIButton) 
    {
        block!!(0,"OK".localized)
        hide()
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
        block!!(2, btnCancelTitle ?? "")
        hide()
    }
    
    @IBAction func btnYes(_ sender: UIButton) {
        hide()
        NotificationCenter.default.post(name: sendNoCarYesMsg, object: nil)
    }
    
    @IBAction func btnNo(_ sender: UIButton) {
        hide()
        NotificationCenter.default.post(name: sendNoCarWillWaitMsg, object: nil)
    }
    
    
    /// Hide Alert Controller on background tap
    @objc func backgroundViewTapped(sender:AnyObject)
    {
       // hide()
    }

    // MARK:- AJAlert Functions
    // MARK:-

    /**
     Display an Alert
     
     - parameter aStrMessage:    Message to display in Alert
     - parameter aCancelBtnTitle: Cancel button title
     - parameter aOtherBtnTitle: Other button title
     - parameter otherButtonArr: Array of other button title
     - parameter completion:     Completion block. Other Button Index - 1 and Cancel Button Index - 0
     */
    
    public func showAlert( aStrMessage:String,
                           aStrTitle:String,
                    aCancelBtnTitle:String?,
                    aOtherBtnTitle:String? ,
                    completion : alertCompletionBlock){
        configure( title: aStrTitle, message: aStrMessage, btnCancelTitle: aCancelBtnTitle, btnOtherTitle: aOtherBtnTitle)
        show()
        block = completion
    }
    
    /**
     Display an Alert With "OK" Button
     
     - parameter aStrMessage: Message to display in Alert
     - parameter completion:  Completion block. OK Button Index - 0
     */
    
    public func showAlertWithOkButton( aStrTitle:String, aStrMessage:String,showStack:Bool = true, showContact: Bool = true,completion : alertCompletionBlock){
        configure(title: aStrTitle, message: aStrMessage, btnCancelTitle: nil, btnOtherTitle: nil, showStack: showStack, showContact: showContact)
        show()
        block = completion
    }
 }

