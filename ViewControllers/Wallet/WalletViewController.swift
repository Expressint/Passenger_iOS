//
//  WalletViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 06/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class WalletViewController: BaseViewController, UIScrollViewDelegate {

    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
//    @IBOutlet weak var viewBalanceUser: UIView!
//
//    @IBOutlet weak var viewCardsUser: UIView!
//
//    @IBOutlet weak var viewTransferUser: UIView!

    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    
    @IBOutlet weak var scrollObj: UIScrollView!
    
    
    //    @IBOutlet weak var pageCtrl: UIPageControl!
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewOptions: UIView!
    
    @IBOutlet weak var lblCurrentBalance: UILabel!
    @IBOutlet weak var imgBpay: UIImageView!
    @IBOutlet weak var imgTravel: UIImageView!
    @IBOutlet weak var imgEntertainment: UIImageView!
    
    @IBOutlet weak var lblBpay: UILabel!
    @IBOutlet weak var lblTravel: UILabel!
    @IBOutlet weak var lblEntertainment: UILabel!
    
    @IBOutlet var viewcardsUser: UIView!
    @IBOutlet var viewTransferUser: UIView!
    @IBOutlet var viewBalanceUser: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.title = "WALLET"
//        self.setNavBarWithMenu(Title: "WALLET", IsNeedRightButton: false)
        self.setNavBarWithBack(Title: "WALLET".localized, IsNeedRightButton: true)
        viewcardsUser.layer.cornerRadius = viewcardsUser.frame.height / 2
        viewTransferUser.layer.cornerRadius = viewTransferUser.frame.height / 2
        viewBalanceUser.layer.cornerRadius = viewBalanceUser.frame.height / 2
        
//        viewTop.layer.cornerRadius = 5
//        viewTop.layer.masksToBounds = true
//
//        viewOptions.layer.cornerRadius = 5
//        viewOptions.layer.masksToBounds = true
        
//        scrollObj.delegate = self
//        scrollObj.isScrollEnabled = false
        
//        bPaySelected()
        
        webserviceOfTransactionHistory()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
      
        
    }
    @IBOutlet weak var lblTransfer: UILabel!
    
    @IBOutlet weak var lblCards: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//         bPaySelected()
        setLocalization()
        self.lblCurrentBalance.text = "\("Balance".localized) \n \(SingletonClass.sharedInstance.strCurrentBalance) \(currencySign)"
       
    }
    
    
    func setLocalization()
    {
        lblCurrentBalance.text = "Balance".localized
        lblTransfer.text = "Transfer".localized
        lblCards.text = "Cards".localized
    }
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnBackToNavigate(_ sender: UIButton) {
        
        for vc in (self.navigationController?.viewControllers ?? []) {
            if vc is CustomSideMenuViewController {
                _ = self.navigationController?.popToViewController(vc, animated: true)
                break
            }
        }
        
//        self.navigationController?.popToRootViewController(animated: true)
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
    @IBAction func btnBalance(_ sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletBalanceMainVC") as! WalletBalanceMainVC
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    
    @IBAction func btnTransfer(_ sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletTransferViewController") as! WalletTransferViewController
        self.navigationController?.pushViewController(next, animated: true)
  
    }
    
    
    @IBAction func btnCards(_ sender: UIButton) {
        
        if SingletonClass.sharedInstance.CardsVCHaveAryData.count == 0 {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
            self.navigationController?.pushViewController(next, animated: true)
        }
        else {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletCardsVC") as! WalletCardsVC
            self.navigationController?.pushViewController(next, animated: true)
        }
    }
    
    @IBAction func btnBpay(_ sender: UIButton) {
        
//        bPaySelected()
        
        
    }
    
    @IBAction func btnTravel(_ sender: UIButton) {
        
//        travelSelected()
        
        
    }
    
    @IBAction func btnEntertainment(_ sender: UIButton) {
        
//        entertainmentSelected()
        
       
    }
    
    func bPaySelected() {
        
        scrollObj.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        lblBpay.textColor = UIColor.init(red: 56/255, green: 145/255, blue: 219/255, alpha: 1.0)
        lblTravel.textColor = UIColor.init(red: 147/255, green: 147/255, blue: 147/255, alpha: 1.0)
        lblEntertainment.textColor = UIColor.init(red: 147/255, green: 147/255, blue: 147/255, alpha: 1.0)
        
        imgBpay.image = UIImage(named: "iconDollerSelected")
        imgEntertainment.image = UIImage(named: "iconEntertainmentUnSelected")
        imgTravel.image = UIImage(named: "iconTravelBag")
    }
    
    func travelSelected() {
        
        scrollObj.setContentOffset(CGPoint(x: self.view.frame.size.width, y: 0), animated: true)
        
        lblBpay.textColor = UIColor.init(red: 147/255, green: 147/255, blue: 147/255, alpha: 1.0)
        lblTravel.textColor = UIColor.init(red: 56/255, green: 145/255, blue: 219/255, alpha: 1.0)
        lblEntertainment.textColor = UIColor.init(red: 147/255, green: 147/255, blue: 147/255, alpha: 1.0)
        
        imgBpay.image = UIImage(named: "iconDollerGrey")
        imgEntertainment.image = UIImage(named: "iconEntertainmentUnSelected")
        imgTravel.image = UIImage(named: "iconTravelBagSelected")
    }
    
    func entertainmentSelected() {
        
        imgBpay.image = UIImage(named: "iconDollerGrey")
        imgEntertainment.image = UIImage(named: "iconEntertainmentSelected")
        imgTravel.image = UIImage(named: "iconTravelBag")
        
        scrollObj.setContentOffset(CGPoint(x: self.view.frame.size.width * 2, y: 0), animated: true)
        
        lblBpay.textColor = UIColor.init(red: 147/255, green: 147/255, blue: 147/255, alpha: 1.0)
        lblTravel.textColor = UIColor.init(red: 147/255, green: 147/255, blue: 147/255, alpha: 1.0)
        lblEntertainment.textColor = UIColor.init(red: 56/255, green: 145/255, blue: 219/255, alpha: 1.0)
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Transaction History
    //-------------------------------------------------------------
    
    func webserviceOfTransactionHistory() {
        
        webserviceForTransactionHistory(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                SingletonClass.sharedInstance.strCurrentBalance = ((result as! NSDictionary).object(forKey: "walletBalance") as AnyObject).doubleValue
                self.lblCurrentBalance.text = "\("Balance".localized) \n\(SingletonClass.sharedInstance.strCurrentBalance)  \(currencySign)"

                if let dictData = result as? [String:AnyObject]
                {
                    if let aryHistory = dictData["history"] as? [[String:AnyObject]]
                    {
                        SingletonClass.sharedInstance.walletHistoryData = aryHistory
                    }
                }

                
                self.webserviceOFGetAllCards()
                
            }
            else {
                print(result)
                
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "Error", message: res) { (index, title) in
                    }
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "Error", message: resDict.object(forKey: "message") as! String) { (index, title) in
                    }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    }
                }
                
            }
        
        }

    }
    
    var aryCards = [[String:AnyObject]]()
    
    func webserviceOFGetAllCards() {
        
        webserviceForCardList(SingletonClass.sharedInstance.strPassengerID as AnyObject){ (result, status) in

            if (status) {
                print(result)
                
                self.aryCards = (result as! NSDictionary).object(forKey: "cards") as! [[String:AnyObject]]
                
                SingletonClass.sharedInstance.CardsVCHaveAryData = self.aryCards
                
//                SingletonClass.sharedInstance.isCardsVCFirstTimeLoad = false

            }
            else {
                print(result)
                if let res = result as? String {
                    UtilityClass.showAlert("", message: res, vc: self)
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.showAlert("", message: resDict.object(forKey: "message") as! String, vc: self)
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.showAlert("", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                }
            }
        }

    }

}

//-------------------------------------------------------------
// MARK: - BpayVC
//-------------------------------------------------------------


class BpayVC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewTop.layer.cornerRadius = 5
        viewTop.layer.masksToBounds = true
        
        btnSubmit.layer.cornerRadius = 5
        btnSubmit.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var viewTop: UIView!
    
    @IBOutlet weak var btnSubmit: ThemeButton!
    
    @IBAction func btnSubmit(_ sender: ThemeButton) {
        
    }
    
}


//-------------------------------------------------------------
// MARK: - TravelVC
//-------------------------------------------------------------

class TravelVC: UIViewController {
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewTop.layer.cornerRadius = 5
        viewTop.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var viewTop: UIView!
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnAction(_ sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "CommingSoonViewController") as! CommingSoonViewController
        self.navigationController?.pushViewController(next, animated: true)
        
        /*
        switch sender.tag {
        case 1:
            showWebSite(strHeager: "TRAIN", strURL: "http://www.metrotrains.com.au/")
            
        case 2:
             showWebSite(strHeager: "BUS", strURL: "https://www.ptv.vic.gov.au/projects/buses")
            
        case 3:
            showWebSite(strHeager: "TRAM", strURL: "https://www.ptv.vic.gov.au/getting-around/maps/metropolitan-trams/")
            
        case 4:
            showWebSite(strHeager: "VLINE", strURL: "https://www.vline.com.au/")
            
        case 5:
            showWebSite(strHeager: "FERRY", strURL: "https://www.ptv.vic.gov.au/getting-around/ferries/")
            
        case 6:
            showWebSite(strHeager: "FLIGHT", strURL: "https://www.virginaustralia.com/au/en/bookings/flights/make-a-booking/")
            
        default: break
            
        }
       */
       
        
//        let next = self.storyboard?.instantiateViewController(withIdentifier: "webViewVC") as! webViewVC
//        self.navigationController?.pushViewController(next, animated: true)
    }
    
    
    func showWebSite(strHeager: String, strURL: String) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "webViewVC") as! webViewVC
        next.headerName = strHeager
        next.strURL = strURL
        self.navigationController?.present(next, animated: true, completion: nil)
    }
    
}

//-------------------------------------------------------------
// MARK: - EntertainmentVC
//-------------------------------------------------------------

class EntertainmentVC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewTop.layer.cornerRadius = 5
        viewTop.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var viewTop: UIView!
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
   
    @IBAction func btnActions(_ sender: UIButton) {

        let next = self.storyboard?.instantiateViewController(withIdentifier: "CommingSoonViewController") as! CommingSoonViewController
        self.navigationController?.pushViewController(next, animated: true)
        
        /*
        switch sender.tag {
        case 11:
            showWebSite(strHeager: "MOVIE", strURL: "https://www.hoyts.com.au/")
            
        case 12:
            showWebSite(strHeager: "GROCERIES", strURL: "https://www.coles.com.au/")
            
        case 13:
            showWebSite(strHeager: "RETAILS", strURL: "https://www.chadstone.com.au/")
            
        case 14:
            showWebSite(strHeager: "DISCOUNT", strURL: "https://www.chadstone.com.au/whats-on")
            
        case 15:
            showWebSite(strHeager: "GIFT CARD", strURL: "https://www.chadstone.com.au/services-facilities/services/gift-card")
            
        case 16:
            showWebSite(strHeager: "FESTIVAL", strURL: "https://www.festival.melbourne/2017/")
            
        default: break
            
        }
        */
    }
    
    func showWebSite(strHeager: String, strURL: String) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "webViewVC") as! webViewVC
        next.headerName = strHeager
        next.strURL = strURL
        self.navigationController?.present(next, animated: true, completion: nil)
    }
    
    
}



