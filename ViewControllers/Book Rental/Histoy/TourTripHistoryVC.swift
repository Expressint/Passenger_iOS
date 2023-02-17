//
//  TourTripHistoryVC.swift
//  Book A Ride
//
//  Created by Yagnik on 17/02/23.
//  Copyright © 2023 Excellent Webworld. All rights reserved.
//

import UIKit

class TourTripHistoryVC: BaseViewController {
    
    @IBOutlet weak var btnOnGoing: UIButton!
    @IBOutlet weak var btnUpComing: UIButton!
    @IBOutlet weak var btnPastBooking: UIButton!
    @IBOutlet weak var tblData: UITableView!
    
    var selectedTyoe = "3"
    var currentPage = "1"
    var isPageEnd: Bool = false
    var aryData : [[String:AnyObject]] = [[:]]
    let socket = (UIApplication.shared.delegate as! AppDelegate).socket
    
    override func viewDidDisappear(_ animated: Bool) {
        self.RentalOffMethods()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.socketMethods()
        
        self.btnOnGoing.setTitle("OnGoing".localized, for: .normal)
        self.btnUpComing.setTitle("UpComing".localized, for: .normal)
        self.btnPastBooking.setTitle("Past Booking".localized, for: .normal)
        
        self.tblData.delegate = self
        self.tblData.dataSource = self
        self.tblData.separatorStyle = .none
        self.tblData.showsHorizontalScrollIndicator = false
        self.tblData.showsVerticalScrollIndicator = false
        
        self.registerNib()

        self.setNavBarWithBack(Title: "Hourly Bookings".localized, IsNeedRightButton: false)
        self.reloadTopView(index: selectedTyoe)
        self.APIForHistory(index: selectedTyoe)
        
    }
    
    func registerNib(){
        let nib = UINib(nibName: TourTripHistoryCell.className, bundle: nil)
        self.tblData.register(nib, forCellReuseIdentifier: TourTripHistoryCell.className)
    }
    
    func reloadTopView(index: String) {
        if index == "1" {
            self.btnOnGoing.backgroundColor = themeYellowColor
            self.btnOnGoing.setTitleColor(.white, for: .normal)
            self.btnUpComing.backgroundColor = .lightGray
            self.btnUpComing.setTitleColor(.darkGray, for: .normal)
            self.btnPastBooking.backgroundColor = .lightGray
            self.btnPastBooking.setTitleColor(.darkGray, for: .normal)
        } else if index == "2" {
            self.btnOnGoing.backgroundColor = .lightGray
            self.btnOnGoing.setTitleColor(.darkGray, for: .normal)
            self.btnUpComing.backgroundColor = themeYellowColor
            self.btnUpComing.setTitleColor(.white, for: .normal)
            self.btnPastBooking.backgroundColor = .lightGray
            self.btnPastBooking.setTitleColor(.darkGray, for: .normal)
        } else {
            self.btnOnGoing.backgroundColor = .lightGray
            self.btnOnGoing.setTitleColor(.darkGray, for: .normal)
            self.btnUpComing.backgroundColor = .lightGray
            self.btnUpComing.setTitleColor(.darkGray, for: .normal)
            self.btnPastBooking.backgroundColor = themeYellowColor
            self.btnPastBooking.setTitleColor(.white, for: .normal)
        }
        self.isPageEnd = false
        self.aryData = []
        self.currentPage = "1"
        self.APIForHistory(index: selectedTyoe)
    }
    
    func CancelRequest(Id: String) {
        RMUniversalAlert.show(in: self, withTitle:appName, message: "Are you sure you want to cancel the trip?".localized, cancelButtonTitle: nil, destructiveButtonTitle: nil, otherButtonTitles: ["Accept".localized, "Decline".localized], tap: {(alert, buttonIndex) in
            if (buttonIndex == 2){
                let myJSON = [SocketDataKeys.kBookingIdNow : Id, SocketDataKeys.kCancelReasons : ""] as [String : Any]
                self.socket?.emit(SocketData.CancelRentalTripByPassenger , with: [myJSON], completion: nil)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.APIForHistory(index: self.selectedTyoe)
                }
            }
        })
    }
    
    func getReceipt(url: String) {
        let strContent = "Please download your receipt from the below link\n\n\(url)"
        let share = [strContent]
        let activityViewController = UIActivityViewController(activityItems: share as [Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func viewReceipt(receiptURL: String) {
        let next = mainStoryboard.instantiateViewController(withIdentifier: "webViewVC") as! webViewVC
        next.headerName = "Receipt".localized
        next.strURL = receiptURL
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    func doPayment(Url: String) {
        let next = mainStoryboard.instantiateViewController(withIdentifier: "PesapalWebViewViewController") as! PesapalWebViewViewController
        next.delegate = self
        next.strUrl = Url
        self.navigationController?.present(next, animated: true, completion: nil)
    }

    @IBAction func btnOnGoingAction(_ sender: Any) {
        self.selectedTyoe = "1"
        self.reloadTopView(index: selectedTyoe)
    }
    
    @IBAction func btnUpComingAction(_ sender: Any) {
        self.selectedTyoe = "2"
        self.reloadTopView(index: selectedTyoe)
    }
    
    @IBAction func btnPastBookingAction(_ sender: Any) {
        self.selectedTyoe = "3"
        self.reloadTopView(index: selectedTyoe)
    }
}


extension TourTripHistoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.aryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblData.dequeueReusableCell(withIdentifier: TourTripHistoryCell.className) as! TourTripHistoryCell
        cell.selectionStyle = .none
        
        cell.lblDriverName.text = self.aryData[indexPath.row]["DriverName"] as? String ?? ""
        cell.lblDriverName.underlineToLabel()
        cell.lblOrderID.text = "\("Order Number/Booking Number".localized) :" + "\(self.aryData[indexPath.row]["Id"] as? String ?? "")"
        cell.lblPickUpLoc.text = self.aryData[indexPath.row]["PickupLocation"] as? String ?? ""
        cell.lblDropOffLoc.text = self.aryData[indexPath.row]["DropoffLocation"] as? String ?? ""
        
        
        cell.lblBookingDate.text = "\(self.aryData[indexPath.row]["CreatedDate"] as? String ?? "")".components(separatedBy: " ")[0]
        cell.lblPickUpDate.text = self.aryData[indexPath.row]["PickupDateTime"] as? String ?? ""
        cell.lblPaymentType.text = self.aryData[indexPath.row]["PaymentType"] as? String ?? ""
        cell.lblTripStatus.text = self.aryData[indexPath.row]["StatusName"] as? String ?? ""
        
        if selectedTyoe == "1" {
            cell.stackBtns.isHidden = true
        } else if selectedTyoe == "2"{
            cell.stackBtns.isHidden = false
            cell.btnCancel.isHidden = false
            cell.btnGetReceipt.isHidden = true
            cell.btnViewReceipt.isHidden = true
            cell.btnPayment.isHidden = true
        } else {
            cell.stackBtns.isHidden = (self.aryData[indexPath.row]["StatusName"] as? String ?? "" == "Canceled") ? true : false
            cell.btnCancel.isHidden = true
            cell.btnGetReceipt.isHidden = false
            cell.btnViewReceipt.isHidden = false
            cell.btnPayment.isHidden = ((self.aryData[indexPath.row]["PaymentType"] as? String ?? "").lowercased() == "card" && self.aryData[indexPath.row]["IsPaymentRequired"] as? Int ?? 0 == 1) ? false : true
        }
        
        cell.cancelTap = {
            self.CancelRequest(Id: self.aryData[indexPath.row]["Id"] as? String ?? "")
        }
        
        cell.getReceiptTap = {
            self.getReceipt(url: self.aryData[indexPath.row]["ShareUrl"] as? String ?? "")
        }
        
        cell.viewReceiptTap = {
            self.viewReceipt(receiptURL: self.aryData[indexPath.row]["ShareUrl"] as? String ?? "")
        }
        
        cell.paymentTap = {
            self.doPayment(Url: self.aryData[indexPath.row]["PaymentURL"] as? String ?? "")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height && !isPageEnd{
            var page = Int(currentPage)
            page! += 1
            currentPage = "\(page ?? 1)"
            APIForHistory(index: selectedTyoe)
        }
    }

}

extension TourTripHistoryVC {
    func APIForHistory(index: String) {
 
        var dictData = [String:AnyObject]()
        dictData["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
        dictData["Status"] = selectedTyoe as AnyObject
        dictData["page_number"] = currentPage as AnyObject
      
        webserviceForRentalHistory(dictData as AnyObject) { (result, status) in
            if (status) {
                print(result)
                let dictData = result as? [String:AnyObject] ?? [:]
                let data = dictData["data"] as? [[String:AnyObject]] ?? []
                if data.count != 0 {
                    self.aryData.append(contentsOf: data)
                } else {
                    self.isPageEnd = true
                }
                self.tblData.reloadData()

                
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

extension TourTripHistoryVC {
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
            self.socketForRentalTripCancelled()
        }
        
        if socket?.status == .connected {
            self.socketForRentalTripCancelled()
        } else {
            self.socket?.connect()
        }
    }
    
    func RentalOffMethods() {
        self.socket?.off(SocketData.CancelRentalTripNotification)
    }
    
    func socketForRentalTripCancelled() {
        self.socket?.on(SocketData.CancelRentalTripNotification, callback: { (data, ack) in
            print("CancelRentalTripNotification: \(data)")
            UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0][GetResponseMessageKey()]! as! String, completionHandler: { (index, title) in
                self.APIForHistory(index: self.selectedTyoe)
            })
        })
    }
}

extension TourTripHistoryVC : delegatePesapalWebView {
    func didOrderPesapalStatus(status: Bool) {
        if status {
            self.APIForHistory(index: selectedTyoe)
        }
    }
}
