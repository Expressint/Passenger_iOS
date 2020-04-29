//
//  GiveRatingViewController.swift
//  TickTok User
//
//  Created by Excelent iMac on 23/12/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
protocol delegateRateGiven
{
    func delegateforGivingRate()
}
class GiveRatingViewController: UIViewController, FloatRatingViewDelegate {

    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var viewMainFinalRating: UIView!
    @IBOutlet weak var viewSubFinalRating: UIView!
    @IBOutlet weak var txtFeedbackFinal: UITextField!
    
    @IBOutlet weak var giveRating: FloatRatingView!
    
    
    
    @IBOutlet weak var btnSubmit: ThemeButton!
    
    
    @IBOutlet weak var lblMessageToShow: UILabel!
    var ProfileData = NSDictionary()
    
     var delegateRating: delegateRateGiven?
    var ratingToDriver = Float()
    var commentToDriver = String()
    var strBookingType = String()
//    var delegate: CompleterTripInfoDelegate!

    var strBookingID = String()
    var dictData : NSDictionary!
    var dictPassengerInfo : NSDictionary!
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        giveRating.delegate = self
        ProfileData = SingletonClass.sharedInstance.dictDriverProfile
//        ProfileData.object(forKey: "Fullname") as? String

        
        lblMessageToShow.text = "How was your experience with \(ProfileData.object(forKey: "Fullname")!)?"
        
        viewSubFinalRating.layer.cornerRadius = 5
        viewSubFinalRating.layer.masksToBounds = true
        
//        btnSubmit.layer.cornerRadius = 5
//        btnSubmit.layer.masksToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       setLoclization()
    }
    
     func setLoclization()
     {
        txtFeedbackFinal.placeholder = "Any other feedback(Optional)".localized
        btnSubmit.setTitle("Submit".localized, for: .normal)
        let strLoc = "How was your experience with Driver".localized
        lblMessageToShow.text = "\(strLoc) \(ProfileData.object(forKey: "Fullname")!)?"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    


    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        
        giveRating.rating = rating
        ratingToDriver = giveRating.rating
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    
    @IBAction func btnSubmitFinalRating(_ sender: ThemeButton) {
        self.btnSubmit.isUserInteractionEnabled = false
        webserviceOfRating()
    }
    
    
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    func webserviceOfRating() {
        //        BookingId,Rating,Comment,BookingType(BookNow,BookLater)
        
        var param = [String:AnyObject]()
        param["BookingId"] = SingletonClass.sharedInstance.bookingId as AnyObject
        param["Rating"] = ratingToDriver as AnyObject
        param["Comment"] = txtFeedbackFinal.text as AnyObject
        param["BookingType"] = strBookingType as AnyObject
        
        webserviceForRatingAndComment(param as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                self.txtFeedbackFinal.text = ""
                self.ratingToDriver = 0
                
                //                self.completeTripInfo()
                
//                self.delegate.didRatingCompleted()
                
                self.btnSubmit.isUserInteractionEnabled = true
//                NotificationCenter.default.removeObserver("CallToRating")
//
//                self.dismiss(animated: true, completion: nil)
                
                self.ratingToDriver = 0
                self.dismiss(animated: true, completion: nil)
                //                Utilities.showAlertWithCompletion(appName, message: "Rating successfull", vc: (UIApplication.shared.keyWindow?.rootViewController)!) { (status) in
                //                }
                //                                Utilities.showAlertWithCompletion(appName, message: "Thanks for feedback.", vc: (UIApplication.shared.keyWindow?.rootViewController)!) { (status) in
                //                }
                UtilityClass.showAlert(appName, message: "Thanks for feedback".localized, vc: (UIApplication.shared.keyWindow?.rootViewController)!)
                
                self.btnSubmit.isUserInteractionEnabled = true
                
                
                
                //                self.dismiss(animated: true, completion: nil)
                //                Utilities.hideActivityIndicator()
                
                
            }
            else {
                print(result)
              self.btnSubmit.isUserInteractionEnabled = true
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
            self.btnSubmit.isUserInteractionEnabled = true
            SingletonClass.sharedInstance.bookingId = ""
//            NotificationCenter.default.post(name: NotificationForAddNewBooingOnSideMenu, object: nil)
        }
    }
    
    

}
