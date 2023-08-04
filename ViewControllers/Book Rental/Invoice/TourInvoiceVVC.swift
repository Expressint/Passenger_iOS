//
//  TourInvoiceVVC.swift
//  Book A Ride-Driver
//
//  Created by Yagnik on 30/01/23.
//  Copyright © 2023 Excellent Webworld. All rights reserved.
//

import UIKit
import MarqueeLabel

class TourInvoiceVVC: BaseViewController {

    @IBOutlet weak var lblPickUpLoc: UILabel!
    @IBOutlet weak var lblTotalTime: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var llTotalPrice: UILabel!
    @IBOutlet weak var llDateTime: UILabel!
    @IBOutlet weak var llDropDateTime: UILabel!
    @IBOutlet weak var llServiceType: UILabel!
    @IBOutlet weak var lblVehicleInfo: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPackageInfo: UILabel!
    
    @IBOutlet weak var giveRating: FloatRatingView!
    @IBOutlet weak var txtFeedbackFinal: UITextField!
    @IBOutlet weak var btnPayment: UIButton!
    @IBOutlet weak var stackPayment: UIStackView!
    @IBOutlet weak var vwRating: UIView!
    
    @IBOutlet weak var lblTitlePickUp: UILabel!
    @IBOutlet weak var lblTitleDropOff: UILabel!
    @IBOutlet weak var lblDropOfLoc: UILabel!
    @IBOutlet weak var lblTitleTime: UILabel!
    @IBOutlet weak var lblTitleDistance: UILabel!
    @IBOutlet weak var lblTitleGrandTotal: UILabel!
    @IBOutlet weak var lblTitleDateTime: UILabel!
    @IBOutlet weak var lblTitleDropDateTime: UILabel!
    @IBOutlet weak var lblTitleService: UILabel!
    @IBOutlet weak var lblTitleVehicle: UILabel!
    @IBOutlet weak var lblTitlePackage: UILabel!
    @IBOutlet weak var lblTitlePayable: UILabel!
    @IBOutlet weak var lblTitleRating: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var lblTitleDropOff2: UILabel!
    @IBOutlet weak var lblDropOfLoc2: UILabel!
    @IBOutlet weak var stackDrop2: UIStackView!
    
    var ratingToDriver: Float = 0
    var dictCompleteTripData = NSDictionary()

    override func viewWillAppear(_ animated: Bool) {
        self.setLocalization()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavBarWithBack(Title: "Invoice".localized, IsNeedRightButton: true)
        self.giveRating.delegate = self
        
        self.setupData()
    }
    
    @objc func changeLanguage(){
        self.setLocalization()
    }
    func setLocalization(){
        self.lblTitlePickUp.text = "Pickup Location".localized
        self.lblTitleDropOff.text = "Final Destination".localized
        self.lblTitleDropOff2.text = "Dropoff Location".localized
        self.lblTitleTime.text = "Total Time".localized
        self.lblTitleDistance.text = "Distance".localized
        self.lblTitleGrandTotal.text = "Grand Total".localized
        self.lblTitleDateTime.text = "\("Pickup Date & Time".localized) :"
        self.lblTitleDropDateTime.text = "\("Dropoff Date & Time".localized) :"
        self.lblTitleService.text = "Service Type".localized
        self.lblTitleVehicle.text = "Vehicle Info".localized
        self.lblTitlePackage.text = "Package Info".localized
        self.lblTitlePayable.text = "Total Payable".localized
        self.lblTitleRating.text = "How was your experience with Driver?".localized
        self.btnSubmit.setTitle("Submit".localized, for: .normal)
        self.btnPayment.setTitle("Make Payment", for: .normal)
    }
    
    func setupData() {
        self.lblPickUpLoc.text = self.dictCompleteTripData.object(forKey: "PickupLocation") as? String
        self.lblDropOfLoc.text = self.dictCompleteTripData.object(forKey: "DropoffLocation") as? String
        self.stackDrop2.isHidden = ((self.dictCompleteTripData.object(forKey: "DropoffLocation2") as? String ?? "") == "") ? true : false
        self.lblDropOfLoc2.text = self.dictCompleteTripData.object(forKey: "DropoffLocation2") as? String ?? ""
        self.lblTotalTime.text = "\(self.dictCompleteTripData.object(forKey: "TripDuration") as? String ?? "0")".secondsToTimeFormate()
        self.lblDistance.text = "\(self.dictCompleteTripData.object(forKey: "TripDistance") as? String ?? "0") Km"
        self.llTotalPrice.text = "$\(self.dictCompleteTripData.object(forKey: "GrandTotal") as? String ?? "0")"
        self.lblPrice.text = "$\(self.dictCompleteTripData.object(forKey: "GrandTotal") as? String ?? "0")"
        self.llDateTime.text = self.dictCompleteTripData.object(forKey: "PickupDateTime") as? String
        self.llDropDateTime.text = self.dictCompleteTripData.object(forKey: "DropoffDateTime") as? String
        self.llServiceType.text = "BookARide Rental"
        
        let vehicleInfo = self.dictCompleteTripData.object(forKey: "CarInfo") as? NSDictionary
        let packageInfo = self.dictCompleteTripData.object(forKey: "PackageInfo") as? NSDictionary
        
        self.lblVehicleInfo.text = vehicleInfo?.object(forKey: "Name") as? String ?? ""
        self.lblPackageInfo.text = "\(packageInfo?.object(forKey: "MinimumHours") as? String ?? "") hrs/\(packageInfo?.object(forKey: "MinimumKm") as? String ?? "") km $\(packageInfo?.object(forKey: "MinimumAmount") as? String ?? "")"
        
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

                Toast.show(message: result.object(forKey: GetResponseMessageKey()) as? String ?? "", state: .success)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.navigationController?.popToViewController(ofClass: IntroVC.self, animated: true)
                }
            } else {
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
