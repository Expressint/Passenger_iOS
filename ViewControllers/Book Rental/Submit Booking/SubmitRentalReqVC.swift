//
//  SubmitRentalReqVC.swift
//  Book A Ride
//
//  Created by Yagnik on 05/01/23.
//  Copyright © 2023 Excellent Webworld. All rights reserved.
//

import UIKit

class SubmitRentalReqVC: BaseViewController {
    
    @IBOutlet weak var lblPickUpLoc: UILabel!
    @IBOutlet weak var lblDropOffLoc: UILabel!
    @IBOutlet weak var lblModel: UILabel!
    @IBOutlet weak var lblPackage: UILabel!
    @IBOutlet weak var lblPaymentType: UILabel!
    @IBOutlet weak var lblPickUpDate: UILabel!
    @IBOutlet weak var vWPickUpTime: UIView!
    @IBOutlet weak var btnConfirm: UIButton!
    
    @IBOutlet weak var lblTitlePickUpLoc: UILabel!
    @IBOutlet weak var lblTitleDropOffLoc: UILabel!
    @IBOutlet weak var lblTitleModel: UILabel!
    @IBOutlet weak var lblTitlePackage: UILabel!
    @IBOutlet weak var lblTitlePaymentType: UILabel!
    @IBOutlet weak var lblTitlePickUpDate: UILabel!
    
    var modelId: Int?
    var modelName:String = ""
    var durationId: Int?
    var durationName:String = ""
    var paymentType:String = ""
    var pickUpDateTime:String = ""
    
    var pickUpLocation: String = ""
    var pickUpLat: Double?
    var pickUpLong: Double?
    var dropOffLocation: String = ""
    var dropOffLat: Double?
    var dropOffLong: Double?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavBarWithBack(Title: "Confirm Details".localized, IsNeedRightButton: true)
        
        self.lblPickUpLoc.text = pickUpLocation
        self.lblDropOffLoc.text = dropOffLocation
        self.lblModel.text = modelName
        self.lblPackage.text = durationName
        self.lblPaymentType.text = paymentType.capitalized
        self.lblPickUpDate.text = pickUpDateTime
        self.vWPickUpTime.isHidden = (self.pickUpDateTime == "") ? true : false
        self.btnConfirm.setTitle("\("Confirm".localized) \(modelName) \("Tour".localized)", for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setLocalization()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    @objc func changeLanguage(){
        self.setLocalization()
    }
    
    func setLocalization(){
        self.lblTitlePickUpLoc.text = "Pickup Location".localized
        self.lblTitleDropOffLoc.text = "Final Destination".localized
        self.lblTitleModel.text = "Model".localized
        self.lblTitlePackage.text = "Package".localized
        self.lblTitlePaymentType.text = "Payment Type".localized
        self.lblTitlePickUpDate.text = "PickupDate".localized
    }
    
    func backToRoot() {
        self.navigationController?.popToViewController(ofClass: SelectModelVC.self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            NotificationCenter.default.post(name: RequestForTaxiHourly, object: nil)
        }
    }
    
    @IBAction func btnConfirmAction(_ sender: Any) {
        self.submitRequestAPI()
    }
}

extension SubmitRentalReqVC {
    func submitRequestAPI() {
        
        let dictParams = NSMutableDictionary()
        dictParams.setObject((pickUpDateTime == "") ? "1" : "2", forKey: "BookingType" as NSCopying)
        dictParams.setObject(SingletonClass.sharedInstance.strPassengerID, forKey: "PassengerId" as NSCopying)
        dictParams.setObject("\(modelId ?? 0)", forKey: "ModelId" as NSCopying)
        dictParams.setObject("\(durationId ?? 0)", forKey: "PackageId" as NSCopying)
        dictParams.setObject(pickUpDateTime, forKey: "PickupDateTime" as NSCopying)
        dictParams.setObject(pickUpLocation, forKey: "PickupLocation" as NSCopying)
        dictParams.setObject("\(pickUpLat ?? 0.0)", forKey: "PickupLat" as NSCopying)
        dictParams.setObject("\(pickUpLong ?? 0.0)", forKey: "PickupLng" as NSCopying)
        dictParams.setObject(dropOffLocation, forKey: "DropoffLocation" as NSCopying)
        dictParams.setObject("\(dropOffLat ?? 0.0)", forKey: "DropOffLat" as NSCopying)
        dictParams.setObject("\(dropOffLong ?? 0.0)", forKey: "DropOffLng" as NSCopying)
        dictParams.setObject("", forKey: "PromoCode" as NSCopying)
        dictParams.setObject((paymentType.capitalized == "Cash") ? "0" : "1", forKey: "PaymentType" as NSCopying)
        
        webserviceForSubmitTourRequest(dictParams) { (result, status) in
            if (status) {
                if(self.pickUpDateTime == ""){
                    self.backToRoot()
                } else {
                    Toast.show(message: result.object(forKey: "message") as? String ?? "You request is submited.", state: .success)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.navigationController?.popToViewController(ofClass: IntroVC.self)
                    }
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
