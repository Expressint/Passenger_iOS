//
//  UpCommingVC.swift
//  TickTok User
//
//  Created by Excellent Webworld on 09/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class UpCommingVC: UIViewController, UITableViewDataSource, UITableViewDelegate { 

    var aryData = NSMutableArray()
    var strPickupLat = String()
    var strPickupLng = String()
    var strDropoffLat = String()
    var strDropoffLng = String()
    let notAvailable: String = "N/A"
    var bookinType = String()
    
    var toolBar = UIToolbar()
    var picker  = UIDatePicker()
    var selectDate = ""
    
    var bookIdToChange = ""
    var pickTimeToChange = ""
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadDataTableView), name: NSNotification.Name(rawValue: NotificationCenterName.keyForUpComming), object: nil)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        
//        webserviceOfUpcommingpagination(index: 1)
        
        tableView.reloadData()
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    @objc func reloadDataTableView()
    {
//        self.aryData = SingletonClass.sharedInstance.aryUpComming
        
        webserviceOfUpcommingpagination(index: 1)
        
        self.tableView.reloadData()
//        self.tableView.frame.size = tableView.contentSize
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpCommingTableViewCell") as! UpCommingTableViewCell
        
        if aryData.count > 0 {
            
            
            let currentData = (aryData.object(at: indexPath.row) as! [String:AnyObject])
            
            cell.selectionStyle = .none
            
//            cell.viewCell.layer.cornerRadius = 10
//            cell.viewCell.clipsToBounds = true
            let myString = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DriverName") as? String
//            let myAttribute = [ NSAttributedStringKey.foregroundColor: UIColor.black, .underlineStyle: NSUnderlineStyle.styleSingle.rawValue] as [NSAttributedStringKey : Any]
//            let myAttrString = NSAttributedString(string: myString!, attributes: myAttribute)
            cell.lblDriverName.text = myString
//            cell.lblPaymentType.text = "Cash".lo
            cell.lblVehicleType.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Model") as? String
//            cell.lblTripStatus.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Status") as? String
            cell.lblPickupAddress.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupLocation") as? String // PickupLocation
            cell.lblDropoffAddress.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropoffLocation") as? String //  DropoffLocation
            var time = ((aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "CreatedDate") as? String)
            time!.removeLast(3)
            
            cell.lblDateAndTime.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "CreatedDate") as? String
//            cell.lblPaymentType.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PaymentType") as? String
            
            let dateAndTime = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "CreatedDate") as? String ?? ""
            if(dateAndTime.contains(" ")){
                let date = dateAndTime.components(separatedBy: " ")
                cell.lblBookingDate.text = date[0]
            }
            
            if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                if SelectedLanguage == "en"
                {
                    cell.lblTripStatus.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Status") as? String
                    
                }
                else if SelectedLanguage == "sw"
                {
                    cell.lblTripStatus.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "swahili_BookingStatus") as? String
                }
            }
            
            if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                if SelectedLanguage == "en"
                {
                    cell.lblPaymentType.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PaymentType") as? String//(aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PaymentType") as? String
                    
                }
                else if SelectedLanguage == "sw"
                {
                    cell.lblPaymentType.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "swahili_PaymentType") as? String
                }
            }
            
            if let bookingID = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Id") as? String {
                cell.btnCancelRequest.tag = Int(bookingID)!
                cell.btnRescheduleRequst.tag = Int(bookingID)!
            }
            else if let bookingID = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Id") as? Int {
                cell.btnCancelRequest.tag = bookingID
                cell.btnRescheduleRequst.tag = bookingID
            }
            
            cell.lblPickupTime.text = checkDictionaryHaveValue(dictData: currentData, didHaveValue: "PickupDateTime", isNotHave: notAvailable)
            
            let date = checkDictionaryHaveValue(dictData: currentData, didHaveValue: "PickupDateTime", isNotHave: notAvailable)
            if(date.contains(" ")){
                let time = date.components(separatedBy: " ")
                cell.lblProcessingDate.text = time[0]
            }
            
            cell.rescheduleTap = {
                self.RescheduleRequest(bookingId: "\(cell.btnRescheduleRequst.tag)", Pickup: date)
            }
            
            let rescheduleStatus = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "rescheduleAllowed") as? Bool ?? false
            if(rescheduleStatus){
                cell.btnRescheduleRequst.isHidden = false
            }else{
                cell.btnRescheduleRequst.isHidden = true
            }
            
//            cell.lblDistanceTravelled.text = checkDictionaryHaveValue(dictData: currentData, didHaveValue: "TripDistance", isNotHave: notAvailable)
            
            cell.lblBookingId.text = "\("\("Order Number/Booking Number".localized) :") \(checkDictionaryHaveValue(dictData: currentData, didHaveValue: "Id", isNotHave: notAvailable))"
            
            cell.lblVehicleTypeTitle.text = "Vehicle Type:".localized
            cell.lblPaymentTypeTitle.text = "Payment Type:".localized
            cell.lblTripStatusTitle.text = "Trip Status:".localized
            cell.lblTitleCompnyName.text = "\("Company name".localized):"
            cell.lblTitleBookingDate.text = "\("Booking Date".localized):"
            cell.lblTitleProcessingDate.text = "\("Processing Date".localized):"
            cell.lblTitlePickUpTime.text = "\("Pickup Time".localized):"
            cell.lblTitlePaymentType.text = "\("Payment Type".localized):"
            bookinType = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "BookingType") as! String
            cell.btnCancelRequest.setTitle("Cancel Request".localized, for: .normal)
            cell.btnCancelRequest.addTarget(self, action: #selector(self.CancelRequest), for: .touchUpInside)
            
            cell.btnRescheduleRequst.setTitle("Reschedule".localized, for: .normal)
            
            cell.btnCancelRequest.layer.cornerRadius = 5
            cell.btnCancelRequest.layer.masksToBounds = true
            
            cell.viewDetails.isHidden = !expandedCellPaths.contains(indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        if let cell = tableView.cellForRow(at: indexPath) as? UpCommingTableViewCell {
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
                webserviceOfUpcommingpagination(index: self.pageNo)
            }
        }
    }
    
    func RescheduleRequest(bookingId: String, Pickup: String)
    {
 
        self.bookIdToChange = bookingId
        self.pickTimeToChange = Pickup
        
        self.setupToolbar()
        self.setupPicker()
    }
    
    func setupToolbar(){
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 400, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        
        let doneButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        doneButton.setTitle("Done".localized, for: .normal)
        doneButton.contentHorizontalAlignment = .right
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        doneButton.backgroundColor = UIColor.clear
        doneButton.setTitleColor(UIColor.systemBlue, for: .normal)
        doneButton.layer.masksToBounds = true
        doneButton.tintColor = UIColor.black
        doneButton.addTarget(self, action: #selector(self.onDoneButtonTapped), for: .touchUpInside)
        
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(customView: doneButton),
        ]
    }
    
    @objc func onDoneButtonTapped() {
        UIView.animate(withDuration: 0.4, animations: {
            self.toolBar.alpha = 0
            self.picker.alpha = 0
        }) { _ in
            self.toolBar.removeFromSuperview()
            self.picker.removeFromSuperview()
        }
       
        self.validateDate()
    }
    
    func validateDate() {
        if(self.selectDate != ""){
            let tempDate =  UtilityClass.formattedDateFromString(dateString: self.selectDate, fromFormat: "MM-dd-yyyy hh:mm a", withFormat: "yyyy-MM-dd HH:mm:ss") ?? ""
            
            let status = checkDuration(strPickTime: tempDate)
            if(!status){
                UtilityClass.setCustomAlert(title: "", message: "Please select pickUp time one hour later".localized) { (index, title) in}
            }else{
                self.webserviceForRescheduleBookLater(date: tempDate)
            }
        }
    }
    
    func checkDuration(strPickTime: String) -> Bool {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: 0, to: Date()) ?? Date()
        let dateFormaterView = DateFormatter()
        dateFormaterView.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date1 = dateFormaterView.string(from: date)
        
        let status = self.timeGapBetweenDates(previousDate:date1 , currentDate: strPickTime)
        return status
    }
    
    func timeGapBetweenDates(previousDate : String,currentDate : String) -> Bool {
        let dateString1 = previousDate
        let dateString2 = currentDate
        
        let Dateformatter = DateFormatter()
        Dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
        let date1 = Dateformatter.date(from: dateString1)
        let date2 = Dateformatter.date(from: dateString2)
        
        let distanceBetweenDates: TimeInterval? = date2?.timeIntervalSince(date1!)
        let minsInAnHour: Double = 60
        
        let minBetweenDates = Int((distanceBetweenDates! / minsInAnHour))
        if minBetweenDates >= 120 {
            return true
        }else{
            return false
        }
    }
    
    func setupPicker() {
        
        picker.backgroundColor = UIColor.white
        picker.datePickerMode = UIDatePicker.Mode.dateAndTime
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }

        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 400, width: UIScreen.main.bounds.size.width, height: 400)
        picker.addTarget(self, action: #selector(self.pickupdateMethod(_:)), for: UIControl.Event.valueChanged)
       // self.picker.selectRow(self.vehicleList[0].id, inComponent: 0, animated: false)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: self.pickTimeToChange)
        picker.date = date ?? Date()
        picker.minimumDate = Date()
        
        UIView.animate(withDuration: 0.4, animations: {
            self.view.addSubview(self.picker)
            self.view.addSubview(self.toolBar)
            self.picker.backgroundColor = UIColor.white
            self.picker.alpha = 1
            self.toolBar.alpha = 1
        }) { status in
        }
    }
    
    @objc func pickupdateMethod(_ sender: UIDatePicker)
    {
        
        let dateFormaterView = DateFormatter()
        dateFormaterView.dateFormat = "MM-dd-yyyy hh:mm a"
        print(dateFormaterView.string(from: sender.date))
        self.selectDate = dateFormaterView.string(from: sender.date)
    }
    
    
    @objc func CancelRequest(sender: UIButton)
    {
        
         let bookingID = sender.tag
        
        RMUniversalAlert.show(in: self, withTitle:appName, message: "Are you sure you want to cancel the trip?".localized, cancelButtonTitle: nil, destructiveButtonTitle: nil, otherButtonTitles: ["YES".localized, "NO".localized], tap: {(alert, buttonIndex) in
            if (buttonIndex == 2)
            {
               
                
                let socketData = (self.navigationController?.childViewControllers[0] as! HomeViewController).socket
                //((self.navigationController?.childViewControllers[1] as! CustomSideMenuViewController).childViewControllers[0].childViewControllers[0] as! HomeViewController).socket
                let showTopView = self.navigationController?.childViewControllers[0] as! HomeViewController //((self.navigationController?.childViewControllers[1] as! CustomSideMenuViewController).childViewControllers[0].childViewControllers[0] as! HomeViewController)
                
                if (SingletonClass.sharedInstance.isTripContinue) {
                    
                    //            if (SingletonClass.sharedInstance.bookingId == String(bookingID)) {
                    
                    UtilityClass.setCustomAlert(title: "Your trip has started", message: "You cannot cancel this request.") { (index, title) in
                    }
                    
                    //            }
                    
                }
                else {
                    if self.bookinType == "Book Now"
                    {
                        let myJSON = [SocketDataKeys.kBookingIdNow : bookingID] as [String : Any]
                        socketData?.emit(SocketData.kCancelTripByPassenger , with: [myJSON], completion: nil)
                        
                        showTopView.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
                        
                        //                UtilityClass.showAlertWithCompletion("", message: "Your request cancelled successfully", vc: self, completionHandler: { ACTION in
                        //                    self.navigationController?.popViewController(animated: true)
                        //                })
                        
                        //                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.navigationController?.popViewController(animated: true)
                        //                }
                        
                        
                        //                UtilityClass.setCustomAlert(title: "\(appName)", message: "Your request cancelled successfully", completionHandler: { (index, title) in
                        //                    self.navigationController?.popViewController(animated: true)
                        //                })
                    }
                    else {
                        let myJSON = [SocketDataKeys.kBookingIdNow : bookingID] as [String : Any]
                        print(socketData?.status.rawValue)
                        socketData?.emit(SocketData.kAdvancedBookingCancelTripByPassenger , with: [myJSON], completion: nil)
                        
                        //                UtilityClass.showAlertWithCompletion("", message: "Your request cancelled successfully", vc: self, completionHandler: { ACTION in
                        //                    self.navigationController?.popViewController(animated: true)
                        //                })
                        //                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.navigationController?.popViewController(animated: true)
                        //                }
                        //                UtilityClass.setCustomAlert(title: "\(appName)", message: "Your request cancelled successfully", completionHandler: { (index, title) in
                        //                    self.navigationController?.popViewController(animated: true)
                        //                })
                    }
                }
            }
        })
      
        
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
        dateFormatter.dateFormat = "HH:mm dd/MM/yyyy" //Specify your format that you want
        let strDate: String = dateFormatter.string(from: date)
        
        return strDate
    }
    
    func changeDateAndTimeFormate(dateAndTime: String) -> String {
        
        let time = dateAndTime // "22:02:00"
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-mm-dd HH-mm-ss"
        
        let fullDate = dateFormatter.date(from: time)
        
        dateFormatter.dateFormat = "yyyy/mm/dd HH:mm"
        
        let time2 = dateFormatter.string(from: fullDate!)
        
        return time2
    }
    
    
    func webserviceOfUpcommingpagination(index: Int) {
        
        let driverId = SingletonClass.sharedInstance.strPassengerID
        
        webserviceForUpcomingBookingList(driverId as AnyObject, PageNumber: index as AnyObject) { (result, status) in
            print(result)
            
            if (status) {
                DispatchQueue.main.async {
                    
                    var tempOngoingData = NSArray()
                    
                    if let dictData = result as? [String:AnyObject]
                    {
                        if let aryHistory = dictData["history"] as? [[String:AnyObject]]
                        {
                            tempOngoingData = aryHistory as NSArray
                        }
                    }
                    
                    for i in 0..<tempOngoingData.count {
                        
                        let dataOfAry = (tempOngoingData.object(at: i) as! NSDictionary)
                        
                        let strHistoryType = dataOfAry.object(forKey: "HistoryType") as? String
                        
                        if strHistoryType == "Upcoming" {
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
    
    //-------------------------------------------------------------
    // MARK: - Webservice For Book Later
    //-------------------------------------------------------------
    func webserviceForRescheduleBookLater(date: String) {
        
        var dictData = [String:AnyObject]()
        dictData["PickupDateTime"] = date as AnyObject
        dictData["BookingId"] = self.bookIdToChange as AnyObject
       
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        webserviceForRscheduleBookLater(dictData as AnyObject) { (result, status) in
            
            if (status) {
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                print(result)
             
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "", message: res) { (index, title) in
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "", message: resDict.object(forKey: GetResponseMessageKey()) as! String) { (index, title) in
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: GetResponseMessageKey()) as! String) { (index, title) in
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            } else {
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "Error", message: res) { (index, title) in}
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "Error", message: resDict.object(forKey: GetResponseMessageKey()) as! String) { (index, title) in }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: GetResponseMessageKey()) as! String) { (index, title) in }
                }
            }
        }
    }
    
    
}
