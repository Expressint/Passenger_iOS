//
//  OnGoingVC.swift
//  TickTok User
//
//  Created by Excellent Webworld on 09/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import SDWebImage

class OnGoingVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var strPickupLat = String()
    var strPickupLng = String()
//    var aryData = NSArray()
    
    var aryData = NSMutableArray()
    
    var strDropoffLat = String()
    var strDropoffLng = String()
    
    var PickupAddress = String()
    var DropoffAddress = String()
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadDataOfTableView), name: NSNotification.Name(rawValue: NotificationCenterName.keyForOnGoing), object: nil)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func reloadDataOfTableView() {
        
//        self.aryData = SingletonClass.sharedInstance.aryOnGoing
        
        
        webserviceOfOngoingpagination(index: 1)
        
        
        self.tableView.reloadData()
        
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
//        webserviceOfOngoingpagination(index: 1)
        
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

        let cell = tableView.dequeueReusableCell(withIdentifier: "OnGoingTableViewCell") as! OnGoingTableViewCell
        
        
        cell.lblBookingID.text = "Booking Id".localized
        cell.btnTrackYourTrip.setTitle("\("TrackYourTrip".localized)", for: .normal)
        if aryData.count > 0 {
            
            cell.selectionStyle = .none
//            cell.viewCell.layer.cornerRadius = 10
//            cell.viewCell.clipsToBounds = true
            if let name = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DriverName") as? String {
                
                if name == "" {
                    cell.lblDriverName.text = "NULL"
                }
                else {
                    cell.lblDriverName.text = name
                }
                
            }
            else {
                cell.lblDriverName.text = "NULL"
            }
            
           
            
            let formattedString = NSMutableAttributedString()
            formattedString
                .normal("\("Order Number/Booking Number".localized):")
                .bold("\(String(describing: (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Id")!))", 14)
            
           
            cell.lblBookingID.attributedText = formattedString
            cell.lblDateAndTime.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "CreatedDate") as? String
            
            cell.lblFirstDescription.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupLocation") as? String // PickupLocation
            cell.lblDropoffAddress.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropoffLocation") as? String  // DropoffLocation
            
            if let pickupTime = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupTime") as? String {
                if pickupTime == "" {
                    cell.lblPickupTime.text = "Date and Time not available".localized
                }
                else {
                    cell.lblPickupTime.text = setTimeStampToDate(timeStamp: pickupTime)
                }
            }
            
            if let DropoffTime = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropTime") as? String {
                if DropoffTime == "" {
                    cell.lblDropoffTime.text = "Date and Time not available".localized
                }
                else {
                    cell.lblDropoffTime.text = setTimeStampToDate(timeStamp: DropoffTime)
                }
            }
            
//            cell.lblPickupTime.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupTime") as? String
//            cell.lblDropoffTime.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropTime") as? String
            cell.lblVehicleType.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Model") as? String
            cell.lblDistanceTravelled.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "TripDistance") as? String
            cell.lblTripFare.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "TripFare") as? String
            cell.lblNightFare.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "NightFare") as? String
            cell.lblTollFee.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "TollFee") as? String
            cell.lblWaitingCost.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "WaitingTimeCost") as? String
            cell.lblBookingCharge.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "BookingCharge") as? String
            cell.lblTax.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Tax") as? String
            cell.lblDiscount.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Discount") as? String
//            cell.lblPaymentType.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PaymentType") as? String


      
            
            if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                if SelectedLanguage == "en"
                {
                    cell.lblPaymentType.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PaymentType") as? String
                    
                }
                else if SelectedLanguage == "sw"
                {
//                    cell.lblPaymentType.text = aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "swahili_PaymentType") as? String
                    cell.lblPaymentType.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "swahili_PaymentType") as? String
                }
            }


            cell.lblTotalCost.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "GrandTotal") as? String
            
            cell.btnTrackYourTrip.tag = indexPath.row
            cell.btnTrackYourTrip.addTarget(self, action: #selector(self.trackYourTrip(sender:)), for: .touchUpInside)
            
             cell.viewDetails.isHidden = !expandedCellPaths.contains(indexPath)
        
        }
 
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? OnGoingTableViewCell {
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
    
    
    @objc func CancelRequest() {
        
    }
   
    @objc func trackYourTrip(sender: UIButton) {
        
        let currentData = aryData.object(at: sender.tag)
        
        let id:String = (currentData as! NSDictionary).object(forKey: "Id")! as! String
        
        RunningTripTrack(param: id)
        
    }
    
    
    func RunningTripTrack(param: String) {
        
        
        webserviceForTrackRunningTrip(param as AnyObject) { (result, status) in
            
            if (status) {
                 print(result)
                SingletonClass.sharedInstance.bookingId = param
                
//                 Post notification
                NotificationCenter.default.post(name: NotificationTrackRunningTrip, object: nil)
                
                self.navigationController?.popViewController(animated: true)
                
            }
            else {
                SingletonClass.sharedInstance.bookingId = ""
                NotificationCenter.default.post(name: NotificationForAddNewBooingOnSideMenu, object: nil)
                var msg = String()
                if let res = result as? String {
                    msg = res
                }
                else if let resDict = result as? NSDictionary {
                    msg = resDict.object(forKey:  GetResponseMessageKey()) as! String
                }
                else if let resAry = result as? NSArray {
                    msg = (resAry.object(at: 0) as! NSDictionary).object(forKey: GetResponseMessageKey()) as! String
                }
                
                let alert = UIAlertController(title: appName, message: msg, preferredStyle: .alert)
                let OK = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
                alert.addAction(OK)
                self.present(alert, animated: true, completion: nil)
            }
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
        dateFormatter.dateFormat = "HH:mm yyyy/MM/dd" //Specify your format that you want
        let strDate: String = dateFormatter.string(from: date)
        
        return strDate
    }
    
    func webserviceOfOngoingpagination(index: Int) {
        
        let driverId = SingletonClass.sharedInstance.strPassengerID
        
        webserviceForOngoingBookingList(driverId as AnyObject, PageNumber: index as AnyObject) { (result, status) in
            print(result)
            
            if (status) {
                DispatchQueue.main.async {
                    
                    var tempUpcomingData = NSArray()
                    
                    if let dictData = result as? [String:AnyObject]
                    {
                        if let aryHistory = dictData["history"] as? [[String:AnyObject]]
                        {
                            tempUpcomingData = aryHistory as NSArray
                        }
                    }
                    
                    for i in 0..<tempUpcomingData.count {
                        
                        let dataOfAry = (tempUpcomingData.object(at: i) as! NSDictionary)
                        
                        let strHistoryType = dataOfAry.object(forKey: "HistoryType") as? String
                        
                        if strHistoryType == "onGoing" {
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
    
    
    
    
}
