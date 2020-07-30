//
//  MyReceiptsViewController.swift
//  TickTok User
//
//  Created by Excelent iMac on 13/12/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import MessageUI

class MyReceiptsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    
    
    var aryData = NSArray()
    var urlForMail = String()
    var counts = Int()
    var messages = String()
    
    var expandedCellPaths = Set<IndexPath>()
    
    var labelNoData = UILabel()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = themeYellowColor
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.counts = 0
  
        
      
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
//        labelNoData = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
//        self.labelNoData.text = "Loading..."
//        labelNoData.textAlignment = .center
//        self.view.addSubview(labelNoData)
//        self.tableView.isHidden = true
        
       webserviewOfMyReceipt()
          self.setNavBarWithBack(Title: "My Receipts".localized, IsNeedRightButton: true)
        self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        self.tableView.addSubview(self.refreshControl)
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        webserviewOfMyReceipt()
        
        tableView.reloadData()
        refreshControl.endRefreshing()
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet var tableView: UITableView!
    
    
    //-------------------------------------------------------------
    // MARK: - Table View Methods
    //-------------------------------------------------------------
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.counts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRecepitTableViewCell") as! MyRecepitTableViewCell
        cell.selectionStyle = .none
        
        
        cell.lblPickUpTimeTitle.text = "Pickup Time".localized
        cell.lblDropOffTimeTitle.text = "DropoffTime:".localized
        cell.lblVehicleTypeTitle.text = "Vehicle Type:".localized
        cell.lblPaymentTypeTitle.text = "Payment Type:".localized
        cell.lblBookingFeeTitle.text = "Booking Fee:".localized
        cell.lblTripFareTitle.text = "Trip Fare:".localized
        cell.lblWaitingCostTitle.text = "Waiting Cost".localized
        cell.lblWaitingTimeTitle.text = "Waiting Time".localized
        cell.lblLessTitle.text = "Less".localized
        cell.lblPromoAppliedTitle.text = "Promo Applied:".localized
        cell.lblTotalAmountTitle.text = "Total Amount :".localized
        cell.lblInclTaxTitle.text = "(incl tax)".localized
        cell.lblTripStatusTitlr.text = "Trip Status:".localized
        cell.btnGetReceipt.setTitle("GET RECEIPT".localized, for: .normal)
        cell.lblNightFareTitle.text = "Night Fare :".localized
        

        let dictData = self.newAryData.object(at: indexPath.row) as! NSDictionary
        
//        cell.viewCell.layer.cornerRadius = 10
//        cell.viewCell.clipsToBounds = true
//        cell.viewCell.layer.shadowRadius = 3.0
//        cell.viewCell.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
//        cell.viewCell.layer.shadowOffset = CGSize (width: 1.0, height: 1.0)
//        cell.viewCell.layer.shadowOpacity = 1.0
        
        if dictData["HistoryType"] as! String == "Past" {
            
            if dictData["Status"] as! String == "completed" {
                
                cell.btnGetReceipt.layer.cornerRadius = 5
                cell.btnGetReceipt.layer.masksToBounds = true
                
                //Id
                //CreatedDate
                //PickupTime
                //DropTime
                //Model    vehicletype
                //PaymentType
                //BookingCharge
                //TripFare
                //WaitingTimeCost
                //WaitingTime
                //PromoCode
                //Status
                
                if let bookingID = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Id") as? String {
                    cell.lblBookingId.text = "\("Booking Id :".localized) \(bookingID)"
                }
               
//                "\("Booking Id :".localized) \(String(describing: dictData.object(forKey: "Id")))"
              
                let PickTime = Double(dictData.object(forKey: "PickupTime") as! String)
                let dropoffTime = Double(dictData.object(forKey: "DropTime") as! String)
                
                
                let unixTimestamp = PickTime //as Double//as! Double//dictData.object(forKey: "PickupTime")
                let unixTimestampDrop = (dropoffTime as! Double)
                let date = Date(timeIntervalSince1970: TimeInterval(unixTimestamp!))
                let dateDrop = Date(timeIntervalSince1970: TimeInterval(unixTimestampDrop))
                let dateFormatter = DateFormatter()
                //        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
                //        dateFormatter.locale = NSLocale.current
                dateFormatter.dateFormat = "yyyy/MM/dd HH:mm" //Specify your format that you want
                let strDate = dateFormatter.string(from: date)
                let strDateDrop = dateFormatter.string(from: dateDrop)
                
                cell.lblPickupTime.text = strDate//dictData.object(forKey: "PickupDateTime") as? String
                
                cell.lblDrooffTime.text = strDateDrop //dictData.object(forKey: "PickupDateTime") as? String
                
                cell.lblDriversNames.text = (dictData.object(forKey: "DriverName") as? String)?.uppercased()
                
                cell.lblDropLocationDescription.text = dictData.object(forKey: "DropoffLocation") as? String
                cell.lblDateAndTime.text = dictData.object(forKey: "CreatedDate") as? String
                
                cell.lblPickUpLocationDescription.text = dictData.object(forKey: "PickupLocation") as? String
                cell.lblVehicleType.text = dictData.object(forKey: "Model") as? String
                
//                cell.lblPaymentType.text = dictData.object(forKey: "PaymentType") as? String
                cell.lblBookingFee.text = "\(dictData.object(forKey: "BookingCharge") as! String) \(currencySign)"
                cell.lblTripFare.text = "\(dictData.object(forKey: "TripFare") as! String) \(currencySign)"
                cell.lblWaitingCost.text = "\(dictData.object(forKey: "WaitingTimeCost") as! String) \(currencySign)"
                cell.lblWaitingTime.text = dictData.object(forKey: "WaitingTime") as? String
                cell.lblPromoCode.text = "\(dictData.object(forKey: "PromoCode") as! String) \(currencySign)"
                cell.lblTotalAmount.text = "\(dictData.object(forKey: "GrandTotal") as! String) \(currencySign)"
                
                cell.lblNightFare.text = "\(dictData.object(forKey: "NightFare") as! String) \(currencySign)"
                
                
//                cell.lblTripStatus.text = dictData.object(forKey: "Status") as? String
                
                if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                    if SelectedLanguage == "en"
                    {
                        cell.lblTripStatus.text = dictData.object(forKey: "Status") as? String
                        
                    }
                    else if SelectedLanguage == "sw"
                    {
                        cell.lblTripStatus.text = dictData.object(forKey: "swahili_BookingStatus") as? String
                    }
                }
                
                if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                    if SelectedLanguage == "en"
                    {
                        cell.lblPaymentType.text = dictData.object(forKey: "PaymentType") as? String
                        
                    }
                    else if SelectedLanguage == "sw"
                    {
                        cell.lblPaymentType.text = dictData.object(forKey: "swahili_PaymentType") as? String
                    }
                }
                
                
//                cell.lblDistanceTravelled.text = dictData.object(forKey: "TripDistance") as? String
//                cell.lblTolllFee.text = dictData.object(forKey: "TollFee") as? String
//                cell.lblFareTotal.text = dictData.object(forKey: "TripFare") as? String
//                cell.lblDiscountApplied.text = dictData.object(forKey: "Discount") as? String
//                cell.lblChargedCard.text = dictData.object(forKey: "PaymentType") as? String
//
                
                
                
                
                
//                self.urlForMail = dictData.object(forKey: "ShareUrl") as! String
                
                
                
                cell.btnGetReceipt.addTarget(self, action: #selector(self.getReceipt(sender:)), for: .touchUpInside)
                cell.viewDetails.isHidden = !self.expandedCellPaths.contains(indexPath)
                
                return cell
            }
            else
            {
                return UITableViewCell()
            }
        }
        else {
            return UITableViewCell()
        }
        
        
//        return cell
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        if let cell = tableView.cellForRow(at: indexPath) as? MyRecepitTableViewCell {
            cell.viewDetails.isHidden = !cell.viewDetails.isHidden
            if cell.viewDetails.isHidden {
                expandedCellPaths.remove(indexPath)
            } else {
                expandedCellPaths.insert(indexPath)
            }
            tableView.beginUpdates()
            tableView.endUpdates()
           
        }
      
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func nevigateToBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func getReceipt(sender: UIButton) {
        
        let emailTitle = ""
        let messageBody = urlForMail
        let toRecipents = [""]
    
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(toRecipents)
            mail.setMessageBody(messageBody, isHTML: true)
            
            present(mail, animated: true)
        } else {
            UtilityClass.setCustomAlert(title: "Missing", message: "Your Email Id is not configured from settings. Please configure it from Settings -> Mail".localized) { (index, title) in
            }
        }
        
       
    }
    
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        switch result {
        case MFMailComposeResult.cancelled:
            print("Mail cancelled")
            messages = "Mail cancelled"
//            UtilityClass.setCustomAlert(title: "Error", message: "Mail cancelled") { (index, title) in
//            }
        case MFMailComposeResult.saved:
            print("Mail saved")
            messages = "Mail saved"
//            UtilityClass.setCustomAlert(title: "Done", message: "Mail saved") { (index, title) in
//            }
        case MFMailComposeResult.sent:
            print("Mail sent")
            messages = "Mail sent"
//            UtilityClass.setCustomAlert(title: "Done", message: "Mail sent") { (index, title) in
//            }
        case MFMailComposeResult.failed:
            print("Mail sent failure: \(String(describing: error?.localizedDescription))")
            messages = "Mail sent failure: \(String(describing: error?.localizedDescription))"
//            UtilityClass.setCustomAlert(title: "Error", message: "Mail sent failure: \(String(describing: error?.localizedDescription))") { (index, title) in
//      }
        default:
            messages = "Something went wrong"
//            UtilityClass.setCustomAlert(title: "Error", message: "Something went wrong") { (index, title) in
//            }
            break
        }
        
        controller.dismiss(animated: true) {
            self.mailAlert(strMsg: self.messages)
        }
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        switch result {
        case MessageComposeResult.cancelled:
            print("Mail cancelled")
            
//            UtilityClass.setCustomAlert(title: "Error", message: "Mail cancelled") { (index, title) in
//            }
            messages = "Mail cancelled"
        case MessageComposeResult.sent:
            print("Mail sent")
            
//            UtilityClass.setCustomAlert(title: "Done", message: "Mail sent") { (index, title) in
//            }
            messages = "Mail sent"
        case MessageComposeResult.failed:
            print("Mail sent failure")
            messages = "Mail sent failure"
        //            UtilityClass.showAlert("", message: "Mail sent failure: \(String(describing: error?.localizedDescription))", vc: self)
        default:
//            UtilityClass.showAlert("", message: "Something went wrong", vc: self)
//            UtilityClass.setCustomAlert(title: "Error", message: "Something went wrong") { (index, title) in
//            }
            messages = "Something went wrong"
//            
            break
        }
        controller.dismiss(animated: true) {
            self.mailAlert(strMsg: self.messages)
        }
    }
    
    
    func mailAlert(strMsg: String) {
        
        UtilityClass.setCustomAlert(title: appName, message: strMsg) { (index, title) in
        }
    }
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    var newAryData = NSMutableArray()
    
    func webserviewOfMyReceipt() {
        
        webserviceForBookingHistory(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
//                self.aryData = (result as! NSDictionary).object(forKey: "history") as! NSArray

                if let dictData = result as? [String:AnyObject]
                {
                    if let aryHistory = dictData["history"] as? [[String:AnyObject]]
                    {
                        self.aryData = aryHistory as NSArray
                    }
                }
                
                self.counts = 0
                self.newAryData = NSMutableArray()
                
                for i in 0..<self.aryData.count {
                    
                    let dictData = self.aryData.object(at: i) as! NSDictionary
                    
                    if dictData["HistoryType"] as! String == "Past" {
                        
                        if dictData["Status"] as! String == "completed" {
                            self.counts += 1
                            
                            self.newAryData.add(self.aryData.object(at: i) as! NSDictionary)
                        }
                    }
                }
                
            
               self.tableView.reloadData()
                
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
    
    
    
}

