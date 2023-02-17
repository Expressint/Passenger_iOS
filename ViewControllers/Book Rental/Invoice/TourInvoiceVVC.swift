//
//  TourInvoiceVVC.swift
//  Book A Ride-Driver
//
//  Created by Yagnik on 30/01/23.
//  Copyright © 2023 Excellent Webworld. All rights reserved.
//

import UIKit

class TourInvoiceVVC: BaseViewController {

    @IBOutlet weak var lblPickUpLoc: UILabel!
    @IBOutlet weak var lblDropOfLoc: UILabel!
    @IBOutlet weak var lblTotalTime: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var llTotalPrice: UILabel!
    @IBOutlet weak var llDateTime: UILabel!
    @IBOutlet weak var llServiceType: UILabel!
    @IBOutlet weak var lblVehicleInfo: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPackageInfo: UILabel!
    
    @IBOutlet weak var giveRating: FloatRatingView!
    @IBOutlet weak var txtFeedbackFinal: UITextField!
    @IBOutlet weak var btnPayment: UIButton!
    @IBOutlet weak var stackPayment: UIStackView!
    @IBOutlet weak var vwRating: UIView!
    
    var ratingToDriver: Float = 0
    var dictCompleteTripData = NSDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavBarWithBack(Title: "Invoice".localized, IsNeedRightButton: false)
        self.giveRating.delegate = self
        
        self.setupData()
    }
    
    func setupData() {
        self.lblPickUpLoc.text = self.dictCompleteTripData.object(forKey: "PickupLocation") as? String
        self.lblDropOfLoc.text = self.dictCompleteTripData.object(forKey: "DropoffLocation") as? String
        self.lblTotalTime.text = "\(self.dictCompleteTripData.object(forKey: "TripDuration") as? String ?? "0")".secondsToTimeFormate()
        self.lblDistance.text = "\(self.dictCompleteTripData.object(forKey: "TripDistance") as? String ?? "0") Km"
        self.llTotalPrice.text = "$\(self.dictCompleteTripData.object(forKey: "GrandTotal") as? String ?? "0")"
        self.lblPrice.text = "$\(self.dictCompleteTripData.object(forKey: "GrandTotal") as? String ?? "0")"
        self.llDateTime.text = self.dictCompleteTripData.object(forKey: "PickupDateTime") as? String
        self.llServiceType.text = "BookARide Tours"
        
        let vehicleInfo = self.dictCompleteTripData.object(forKey: "CarInfo") as? NSDictionary
        let packageInfo = self.dictCompleteTripData.object(forKey: "PackageInfo") as? NSDictionary
        
        self.lblVehicleInfo.text = vehicleInfo?.object(forKey: "Name") as? String ?? ""
        self.lblPackageInfo.text = "\(packageInfo?.object(forKey: "MinimumHours") as? String ?? "") Hr/\(packageInfo?.object(forKey: "MinimumKm") as? String ?? "") km $\(packageInfo?.object(forKey: "MinimumAmount") as? String ?? "")"
        
        let paymentType = self.dictCompleteTripData.object(forKey: "PaymentType") as? String ?? ""
        if paymentType.lowercased() == "cash" {
            self.stackPayment.isHidden = true
            self.vwRating.isHidden = false
        } else {
            self.stackPayment.isHidden = false
            self.vwRating.isHidden = true
        }
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPaymentAction(_ sender: Any) {
        let next = mainStoryboard.instantiateViewController(withIdentifier: "PesapalWebViewViewController") as! PesapalWebViewViewController
        next.delegate = self
        let url = self.dictCompleteTripData.object(forKey: "PaymentURL") as? String ?? ""
        next.strUrl = url
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    
    @IBAction func btnSubmitFinalRating(_ sender: UIButton) {
        
        var param = [String:AnyObject]()
        param["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
        param["DriverId"] = self.dictCompleteTripData.object(forKey: "DriverId") as AnyObject
        param["BookingId"] = self.dictCompleteTripData.object(forKey: "Id") as AnyObject
        param["Rating"] = ratingToDriver as AnyObject
        param["Comment"] = txtFeedbackFinal.text as AnyObject

        webserviceForRentalRating(param as AnyObject) { (result, status) in
            if (status) {
                self.txtFeedbackFinal.text = ""
                self.ratingToDriver = 0.0
                self.giveRating.rating = 0.0
                UtilityClass.setCustomAlert(title: "Success".localized, message: result.object(forKey: "message") as? String ?? "") { (index, title) in
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "Error", message: res) { (index, title) in}
                } else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "Error", message: resDict.object(forKey: GetResponseMessageKey()) as! String) { (index, title) in }
                } else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: GetResponseMessageKey()) as! String) { (index, title) in }
                }
            }
        }
    }
}

extension TourInvoiceVVC : FloatRatingViewDelegate {
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        
        giveRating.rating = rating
        ratingToDriver = giveRating.rating
    }
}

extension TourInvoiceVVC : delegatePesapalWebView {
    func didOrderPesapalStatus(status: Bool) {
        if status {
            self.stackPayment.isHidden = true
            self.vwRating.isHidden = false
        } else {
            self.stackPayment.isHidden = false
            self.vwRating.isHidden = true
        }
    }
}
