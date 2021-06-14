//
//  PastBookingVC.swift
//  TickTok User
//
//  Created by Excellent Webworld on 09/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class PastBookingVC: UIViewController, UITableViewDataSource, UITableViewDelegate,delegatePesapalWebView
{
    
    var aryData = NSMutableArray()
    
    var strPickupLat = String()
    var strPickupLng = String()
    
    var strDropoffLat = String()
    var strDropoffLng = String()
    
    var strNotAvailable: String = "N/A"
    
    var expandedCellPaths = Set<IndexPath>()
    
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
        
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        self.tableView.addSubview(self.refreshControl)
        

        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableView), name: NSNotification.Name(rawValue: NotificationCenterName.keyForPastBooking), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    
    }

     func setLocalization()
     {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func reloadTableView()
    {
        self.webserviceOfPastbookingpagination(index: 1)
//        self.aryData = SingletonClass.sharedInstance.aryPastBooking
        self.tableView.reloadData()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
//        self.webserviceOfPastbookingpagination(index: 1)
        
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------

    @IBOutlet weak var tableView: UITableView!
    
    
    
    //-------------------------------------------------------------
    // MARK: - Table View Methods
    //-------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PastBooingTableViewCell") as! PastBooingTableViewCell
        
        if aryData.count > 0 {
            
            cell.lblBookingID.text = "Booking Id :".localized
            cell.lblPickupAddress.text = "First Description".localized
            cell.lblDropoffAddress.text = "Second Description".localized
            cell.lblPickupTimeTitle.text = "Pickup Time:".localized
//            cell.lblPickupTimeTitle.text = "Booking Fee:".localized
            cell.lblDropoffTimeTitle.text = "Dropoff Time".localized
//            cell.lblDropoffTimeTitle.text = "Trip Fare:".localized
            cell.lblVehicleTypeTitle.text = "Vehicle Type:".localized
            cell.lblPaymentTypeTitle.text = "Payment Type:".localized
            cell.lblBookingFreeTitle.text = "Total Amount :".localized
            cell.lblTripFareTitle.text = "Trip Fare:".localized
//            cell.lblTripTitle.text = "Tip".localized
            cell.lblWaitingCostTitle.text = "Waiting Cost".localized
            cell.lblWaitingTimeTitle.text = "Waiting Time".localized
            cell.lblLessTitle.text = "Less" .localized
//            cell.lblPromoApplied.text = "Promo Applied:".localized
            cell.lblTotlaAmountTitile.text = "Total Amount :".localized
            cell.lblInclTax.text = "(incl tax)".localized
            cell.lblTripStatusTitle.text = "Trip Status:".localized
            
            cell.selectionStyle = .none
//            cell.viewCell.layer.cornerRadius = 10
//            cell.viewCell.clipsToBounds = true
            //        cell.viewCell.layer.shadowRadius = 3.0
            //        cell.viewCell.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
            //        cell.viewCell.layer.shadowOffset = CGSize (width: 1.0, height: 1.0)
            //        cell.viewCell.layer.shadowOpacity = 1.0

            let currentData = (aryData.object(at: indexPath.row) as! NSDictionary)
            cell.lblDriverName.text = ""

            if let name = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DriverName") as? String
            {

                if name == "" {
//                    cell.lblDriverName.isHidden = true
                    cell.lblDriverName.text = ""
                }
                else {
              
                    cell.lblDriverName.text = name
//                    cell.lblDriverName.text = name
                }
            }
           else
            {
//              cell.lblDriverName.isHidden = true
                cell.lblDriverName.text = ""
            }
            let formattedString = NSMutableAttributedString()
            formattedString
                .normal("\("Booking Id :".localized)")
                .bold("\(String(describing: (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Id")!))", 14)
            
            let lbl = UILabel()
            lbl.attributedText = formattedString
            
            cell.lblBookingID.attributedText = formattedString
            
//            cell.lblBookingID.text = "Booking Id: \(String(describing: (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Id")!))"
            
            if let dateAndTime = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "CreatedDate") as? String {
                
                if dateAndTime == "" {
                    cell.lblDateAndTime.isHidden = true
                }
                else {
                    cell.lblDateAndTime.text = dateAndTime
                }
                
            }
//            cell.lblDateAndTime.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "CreatedDate") as? String
            
            // DropOff Address is PickupAddress
            // Pickup Address is DropOffAddress
            
            print("Data : \(currentData)")
//            PickupTime
//            DropTime
//            Model
//            PaymentType
//            BookingCharge
//            TripFare
////            TipStatus == 1 then tip
//            WaitingTimeCost
//            WaitingTime
//            PromoCode
//            GrandTotal
            
            let pickupLocation = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "DropoffLocation", isNotHave: strNotAvailable)
            let dropoffLocation = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "PickupLocation", isNotHave: strNotAvailable)
            let pickupTime = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "PickupTime", isNotHave: strNotAvailable)
            let DropoffTime = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "DropTime", isNotHave: strNotAvailable)
            let strModel = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "Model", isNotHave: strNotAvailable)
//            let strTripDistance = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "TripDistance", isNotHave: strNotAvailable)
            let strTripFare = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "TripFare", isNotHave: strNotAvailable)
            
            let strDropLocation2 = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "DropoffLocation2", isNotHave: strNotAvailable)
            
            let strBookingFee = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "BookingCharge", isNotHave: strNotAvailable) //(aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "BookingCharge") as? String
//            let strPromoCode = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "Discount", isNotHave: "0")// (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Discount") as? String
//            let  strTip = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "TollFee", isNotHave: strNotAvailable)
            
            let strTotalAmount = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "GrandTotal", isNotHave: strNotAvailable)

            let strWaitingTimeCost = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "WaitingTimeCost", isNotHave: strNotAvailable)
//            let strModel = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "Model", isNotHave: strNotAvailable)
//            let strTripDistance = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "TripDistance", isNotHave: strNotAvailable)
//            let strTripFare = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "TripFare", isNotHave: strNotAvailable)
            let strNightFare = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "NightFare", isNotHave: strNotAvailable)
            
            if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                if SelectedLanguage == "en"
                {
                    cell.lblTripStatus.text = currentData.object(forKey: "Status") as? String
                    
                }
                else if SelectedLanguage == "sw"
                {
                    cell.lblTripStatus.text = currentData.object(forKey: "swahili_BookingStatus") as? String
                }
            }
            
            
            
            cell.btnPaymentOrReceipt.isHidden = true
             if let paymentURL = currentData.object(forKey: "payment_url") as? String
             {
                if !UtilityClass.isEmpty(str: paymentURL)
                {
                    cell.btnPaymentOrReceipt.isHidden = false
                    cell.btnPaymentOrReceipt.setTitle("Make Payment".localized, for: .normal)
                }
            }
        
            
            cell.btnPaymentOrReceipt.addTarget(self, action: #selector(btnCellPaymentReceiptClicked(_:)), for: .touchUpInside)
            
            let waitingTime = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "WaitingTime", isNotHave: strNotAvailable)
            
            var strWaitingTime: String = "00:00:00"
      
            if waitingTime != strNotAvailable {
                let intWaitingTime = Int(waitingTime)
                let WaitingTimeIs = ConvertSecondsToHoursMinutesSeconds(seconds: intWaitingTime!)
                if WaitingTimeIs.0 == 0 {
                    if WaitingTimeIs.1 == 0 {
                        strWaitingTime = "00:00:\(WaitingTimeIs.2)"
                    } else {
                        strWaitingTime = "00:\(WaitingTimeIs.1):\(WaitingTimeIs.2)"
                    }
                } else {
                    strWaitingTime = "\(WaitingTimeIs.0):\(WaitingTimeIs.1):\(WaitingTimeIs.2)"
                }
            }
            else {
                strWaitingTime = waitingTime
            }
            
            cell.lblWaitingTime.text = strWaitingTime
            
            cell.lblPickupAddress.text = dropoffLocation
            cell.lblDropoffAddress.text = pickupLocation
            
            if pickupTime == strNotAvailable {
                 cell.lblPickupTime.text = pickupTime
            } else {
                 cell.lblPickupTime.text = setTimeStampToDate(timeStamp: pickupTime)
            }
            
            if DropoffTime == strNotAvailable {
                 cell.lblDropoffTime.text = DropoffTime
            } else {
                cell.lblDropoffTime.text = setTimeStampToDate(timeStamp: DropoffTime)
            }
            cell.stackViewDropLocation2.isHidden = true
            if(strDropLocation2 != strNotAvailable)
            {
                cell.stackViewDropLocation2.isHidden = false
                cell.lblDropoffAddress2.text = strDropLocation2
            }
            cell.lblVehicleType.text = strModel
//            cell.lblTip.text = "\(strTip)x \(currencySign)"
            cell.lblTripFare.text = "\(strTripFare) \(currencySign)"
            cell.lblWaitingCost.text = "\(strWaitingTimeCost) \(currencySign)" // (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "WaitingTimeCost") as? String
            
            cell.lblBookingFee.text = "\(strBookingFee) \(currencySign)" //(aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "BookingCharge") as? String
//            cell.lblPromoCode.text = "\(strPromoCode) \(currencySign)"// (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Discount") as? String
           
            cell.lblTotalAmount.text = "\(strTotalAmount) \(currencySign)"
            if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                if SelectedLanguage == "en"
                {
                    cell.lblPaymentType.text = (checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "PaymentType", isNotHave: strNotAvailable)).capitalizingFirstLetter()//(aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PaymentType") as? String
                    
                    
                    
                    
                }
                else if SelectedLanguage == "sw"
                {
                     cell.lblPaymentType.text = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "swahili_PaymentType", isNotHave: strNotAvailable)//(aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PaymentType") as? String
                }
            }
            
            cell.lblNightFare.text = strNightFare
//
//
//            cell.lblTollFee.text = strTollFee // (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "TollFee") as? String
       
//            cell.lblWaitingTime.text = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "Tax", isNotHave: strNotAvailable) // (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Tax") as? String
         
    
            
            
//            if let pickupAddress = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropoffLocation") as? String {
////                DropoffLocation
//                if pickupAddress == "" {
//                     cell.lblPickupAddress.isHidden = true
//                }
//                else {
//                    cell.lblPickupAddress.text = pickupAddress
//                }
//            }
           
//            if let dropoffAddress = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupLocation") as? String {
////                PickupLocation
//                if dropoffAddress == "" {
//                    cell.lblDropoffAddress.isHidden = true
//                }
//                else {
//                    cell.lblDropoffAddress.text = dropoffAddress
//                }
//            }
            
//            cell.lblPickupAddress.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupLocation") as? String
//            cell.lblDropoffAddress.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropoffLocation") as? String
            
//            if let pickupTime = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupTime") as? String {
//                if pickupTime == "" {
//                    cell.lblPickupTime.isHidden = true
//                    cell.stackViewPickupTime.isHidden = true
//                }
//                else {
//                    cell.lblPickupTime.text = setTimeStampToDate(timeStamp: pickupTime)
//                }
//            }
            
//            if let DropoffTime = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropTime") as? String {
//                if DropoffTime == "" {
//                    cell.lblDropoffTime.isHidden = true
//                    cell.stackViewDropoffTime.isHidden = true
//                }
//                else {
//                    cell.lblDropoffTime.text = setTimeStampToDate(timeStamp: DropoffTime)
//                }
//            }
            
//            cell.lblPickupTime.text = setTimeStampToDate(timeStamp: ((aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupTime") as? String)!)
//            cell.lblDropoffTime.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropTime") as? String
            
//            if let strModel = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Model") as? String {
//                if strModel == "" {
//                    cell.lblVehicleType.isHidden = true
//                    cell.stackViewVehicleType.isHidden = true
//                }
//                else {
//                    cell.lblVehicleType.text = strModel
//                }
//            }
//            cell.lblVehicleType.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Model") as? String
//            if let strTripDistance = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "TripDistance") as? String {
//                if strTripDistance == "" {
//                    cell.lblDistanceTravelled.isHidden = true
//                    cell.stackViewDistanceTravelled.isHidden = true
//                }
//                else {
//                    cell.lblDistanceTravelled.text = strTripDistance
//                }
//            }
//            cell.lblDistanceTravelled.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "TripDistance") as? String
            
            
//            if let strTripFare = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "TripFare") as? String {
//                if strTripFare == "" {
//                    cell.lblTripFare.text = strNotAvailable
//                }
//                else {
//                    cell.lblTripFare.text = strTripFare
//                }
//            }

            if let strNightFare = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "NightFare") as? String {
                if strNightFare == "" {
                    cell.lblNightFare.isHidden = false
                    cell.stackViewNightFare.isHidden = false
                    
                    cell.lblNightFare.text = "N/A"
                }
                else {
                    cell.lblNightFare.text = strNightFare
                    cell.lblNightFare.isHidden = false
                    cell.stackViewNightFare.isHidden = false
                }
            }
            
            
//            cell.lblTripFare.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "TripFare") as? String
//            cell.lblNightFare.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "NightFare") as? String
            
            
//            cell.lblTollFee.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "TollFee") as? String
//            cell.lblWaitingCost.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "WaitingTimeCost") as? String
//            cell.lblBookingCharge.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "BookingCharge") as? String
//            cell.lblTax.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Tax") as? String
//            cell.lblDiscount.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Discount") as? String
//            cell.lblPaymentType.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PaymentType") as? String
//            cell.lblTotalCost.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "GrandTotal") as? String
            
            
            cell.viewDetails.isHidden = !expandedCellPaths.contains(indexPath)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? PastBooingTableViewCell {
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
    
    func setTimeStampToDate(timeStamp: String) -> String {
        
        let unixTimestamp = Double(timeStamp)
        //        let date = Date(timeIntervalSince1970: unixTimestamp)
        
        let date = Date(timeIntervalSince1970: unixTimestamp!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current //Set timezone that you want
        dateFormatter.locale = NSLocale.current
//        dateFormatter.dateFormat = "HH:mm yyyy/MM/dd" //Specify your format that you want
        
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm "
        
        let strDate: String = dateFormatter.string(from: date)
        
        return strDate
    }
    
    func webserviceOfPastbookingpagination(index: Int)
    {
        
        let driverId = SingletonClass.sharedInstance.strPassengerID //+ "/" + "\(index)"

        webserviceForPastBookingList(driverId as AnyObject, PageNumber: index as AnyObject) { (result, status) in
            if (status) {
                DispatchQueue.main.async {


                    
                    var tempPastData = NSArray()

                    if let dictData = result as? [String:AnyObject]
                    {
                        if let aryHistory = dictData["history"] as? [[String:AnyObject]]
                        {
                            tempPastData = aryHistory as NSArray
                        }
                    }
                    
                    for i in 0..<tempPastData.count {
                        
                        let dataOfAry = (tempPastData.object(at: i) as! NSDictionary)
                        
                        let strHistoryType = dataOfAry.object(forKey: "HistoryType") as? String
                        
                        if strHistoryType == "Past" {
                            self.aryData.add(dataOfAry)
                        }
                    }
                    
                    if(self.aryData.count == 0) {
//                        self.labelNoData.text = "No data found."
//                        self.tableView.isHidden = true
                    }
                    else {
//                        self.labelNoData.removeFromSuperview()
                        self.tableView.isHidden = false
                    }
                    
                    //                    self.getPostJobs()
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                    
                    UtilityClass.hideACProgressHUD()
                }
            }
            else {
//                UtilityClass.showAlertOfAPIResponse(param: result, vc: self)
            }

        }
    }
    
    var isDataLoading:Bool=false
    var pageNo:Int = 0
    var didEndReached:Bool=false
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }
    
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        print("scrollViewDidEndDragging")
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height) {
            //            if !isDataLoading{
            //                isDataLoading = true
            //                self.pageNo = self.pageNo + 1
            //                webserviceOfPastbookingpagination(index: self.pageNo)
            //            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == (self.aryData.count - 5) {
            if !isDataLoading{
                isDataLoading = true
                self.pageNo = self.pageNo + 1
                webserviceOfPastbookingpagination(index: self.pageNo)
            }
        }
    }
    
    @IBAction func btnCellPaymentReceiptClicked(_ sender: UIButton)
    {
        let btnTag = sender.tag
        let next = self.storyboard?.instantiateViewController(withIdentifier: "PesapalWebViewViewController") as! PesapalWebViewViewController
        next.delegate = self
        let currentData = (aryData.object(at: btnTag) as! NSDictionary)
        
        let url = currentData.object(forKey: "payment_url") as! String //"https://www.tantaxitanzania.com/pesapal/add_money/\(SingletonClass.sharedInstance.strPassengerID)/\("\(Amount)")/passenger"
        next.strUrl = url
        //            self.present(next, animated: true, completion: nil)
        
        let navController = UINavigationController.init(rootViewController: next)
        UIApplication.shared.keyWindow?.rootViewController?.present(navController, animated: true, completion: nil)
    }
    
    func didOrderPesapalStatus(status: Bool)
    {
//        if status
//        {
            self.webserviceOfPastbookingpagination(index: 1)
            
//        }
//        else
//        {
////            self.btnOK.setTitle("Make Payment", for: .normal)
//        }
    }
    
}



extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String, _ fontSize: CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: "AvenirNext-Medium", size: fontSize)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)
        return self
    }
   
}
