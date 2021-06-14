//
//  DriverInfoViewController.swift
//  TickTok User
//
//  Created by Excelent iMac on 08/12/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import SDWebImage
import MarqueeLabel
import CoreLocation
import MapKit

class DriverInfoViewController: UIViewController {
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var imgCar: UIImageView!
    @IBOutlet weak var lblCareName: UILabel!
    @IBOutlet weak var lblCarClassModel: UILabel!
    @IBOutlet weak var lblPickupLocation: MarqueeLabel!
    @IBOutlet weak var lblDropoffLocation: MarqueeLabel!
    @IBOutlet weak var lblDropoffLocation2: MarqueeLabel!
    @IBOutlet weak var viewDropoffLocation2: UIView!
    
    
    @IBOutlet weak var viewTimeToReachPickLocation: UIView!
    @IBOutlet weak var viewDistanceToReachPickLocation: UIView!

    
    @IBOutlet var btnCallGreen: UIButton!
    @IBOutlet weak var lblCarPlateNumber: UILabel!
    @IBOutlet weak var imgDriver: UIImageView!
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var viewCarAndDriverInfo: UIView!
    @IBOutlet weak var btnOk: ThemeButton!
    @IBOutlet weak var lblDriverInfo: UILabel!
    var directions: MKDirections!
    var strApproxTimeToYourLocation = String()
    var strApproxDistanceToYourLocation = String()
    var shouldShow = Bool()
    
    var strCurrentLat = ""
    var strCurrentLng = ""
    var strPickUpLat = ""
    var strPickUpLng = ""
    var strBookingID = ""
    var strBookingType = ""
    var ApproxTimeReachYourLocation:String = ""
    var ApproxDistanceReachYourLocation:String = ""

    var strCarImage = String()
    var strCareName = String()
    var strCarClass = String()
    var strPickupLocation = String()
    var strDropoffLocation = String()
    var strDropoffLocation2 = String()
    var strDriverImage = String()
    var strDriverName = String()
    var strCarPlateNumber = String()
    var strPassengerMobileNumber = String()
    
    
    @IBOutlet var lblApproxTime: UILabel!
    @IBOutlet var lblApproxDistanceToYourLocation: UILabel!


    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        setLocalization()
//        fillAllFields()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        btnOk.layer.cornerRadius = 5
        btnOk.layer.masksToBounds = true
        viewCarAndDriverInfo.layer.cornerRadius = 5
        viewCarAndDriverInfo.layer.masksToBounds = true
        btnCallGreen.layer.cornerRadius = btnCallGreen.frame.width / 2
        btnCallGreen.clipsToBounds = true
        self.webserviceForGetEstimateETA()
        
        if(shouldShow)
        {
            self.getEstimateData { (status) in
                if status {
                    
                    self.strApproxTimeToYourLocation = self.ApproxTimeReachYourLocation
                    self.strApproxDistanceToYourLocation = self.ApproxDistanceReachYourLocation
                    self.fillAllFields()
                    
                    UIView.animate(withDuration: 0.5) {
                        self.view.layoutIfNeeded()
                    }
                }
            }
        }
        else
        {
            self.fillAllFields()
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        imgCar.layer.cornerRadius = imgCar.frame.size.width / 2
//        imgCar.layer.masksToBounds = true
//
        imgDriver.layer.cornerRadius = imgDriver.frame.size.width / 2
        imgDriver.layer.masksToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    func setLocalization()
    {
        
        lblDriverInfo.text = "Driver Info".localized
        lblDriverName.text = "Jina la dereva".localized
        lblCareName.text = "Jina la Gari".localized
        lblPickupLocation.text = "Pickup Location".localized
        lblDropoffLocation.text = "Dropoff Location".localized
        
    }
    

    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnClosed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnOK(_ sender: ThemeButton) {
   
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnCall(_ sender: UIButton) {
        
        let contactNumber = strPassengerMobileNumber
        
        if contactNumber == "" {
            
            UtilityClass.setCustomAlert(title: "\(appName)", message: "Contact number is not available") { (index, title) in
            }
        }
        else {
            callNumber(phoneNumber: contactNumber)
        }
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func fillAllFields() {
        
//        if strCarImage is String {
//            imgCar.sd_setShowActivityIndicatorView(true)
//            imgCar.sd_setIndicatorStyle(.gray)
//            imgCar.sd_setImage(with: URL(string: carImg), completed: nil)
//        }
        
        
        
        let driverImg = strDriverImage
        imgDriver.sd_setShowActivityIndicatorView(true)
        imgDriver.sd_setIndicatorStyle(.gray)
        imgDriver.sd_setImage(with: URL(string: driverImg), completed: nil)
        viewDropoffLocation2.isHidden = true
        if(strDropoffLocation2 != "")
        {
            viewDropoffLocation2.isHidden = false
            lblDropoffLocation2.text = strDropoffLocation2
        }
        
        lblCareName.text = strCareName
        lblCarPlateNumber.text = strCarPlateNumber
       
        lblPickupLocation.text = strPickupLocation
        lblDropoffLocation.text = strDropoffLocation
        lblDriverName.text = strDriverName
       
        if strCarClass.count == 1 {
            lblCarClassModel.text = carClass(strClass: strCarClass)
        }
        else {
            lblCarClassModel.text = strCarClass
        }
        
        
        self.lblApproxTime.text  = self.strApproxTimeToYourLocation
        self.lblApproxDistanceToYourLocation.text    = self.strApproxDistanceToYourLocation

        self.lblApproxTime.isHidden  = (self.strApproxTimeToYourLocation == "")
        self.lblApproxDistanceToYourLocation.isHidden = (self.strApproxDistanceToYourLocation == "")
        self.viewTimeToReachPickLocation.isHidden = self.lblApproxTime.isHidden
        self.viewDistanceToReachPickLocation.isHidden = self.lblApproxDistanceToYourLocation.isHidden

    }
   
    @IBAction func btnCallToDriver(_ sender: UIButton) {
        
        let contactNumber = strPassengerMobileNumber
        
        if contactNumber == "" {
    
            UtilityClass.setCustomAlert(title: "\(appName)", message: "Contact number is not available") { (index, title) in
            }
        }
        else {
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
    
    func carClass(strClass: String) -> String {
        
        switch strClass {
        case "1":
            return "Premium"
        case "2":
            return "Mini Car"
        case "3":
            return "VAN"
        case "4":
            return "Nano"
        case "5":
            return "Tuk Tuk"
        case "6":
            return "Breakdown Services"
        case "7":
            return "Bus"
//        case "8":
//            return "Motorbike"
//        case "9":
//            return "Car Delivery"
//        case "10":
//            return "Van / Trays"
//        case "11":
//            return "3T truck"
        default:
            return ""
        }
        
    }
    lazy var request = MKDirections.Request()

    
    func getEstimateData(Response: @escaping (Bool) -> ()) {
        
        
        var TotalMinutes:Double = 0.0  // this variable counts total minutes from pickup to destination time in Minutes
        var TotalDistance:Double = 0.0 // this variable counts total minutes from pickup to destination distance in Miles
        // First Location Details
        let pickupLat = strCurrentLat
        let pickupLng = strCurrentLng
        let DropOffLat = strPickUpLat
        let DropOffLng = strPickUpLng
        
        let start = CLLocationCoordinate2D(latitude: (pickupLat as NSString).doubleValue, longitude: (pickupLng as NSString).doubleValue)
        let Destiny = CLLocationCoordinate2D(latitude: (DropOffLat as NSString).doubleValue, longitude: (DropOffLng as NSString).doubleValue)
        
        estimateTravelTime(request: request, transportType: .automobile, source: start, destination: Destiny) { (minutes, distance) in
            TotalMinutes = (TotalMinutes + minutes).rounded(toPlaces: 2)
            TotalDistance = (TotalDistance + distance).rounded(toPlaces: 2)
            
            
            self.ApproxTimeReachYourLocation = "Estimate time: \(TotalMinutes) Minutes"
            self.ApproxDistanceReachYourLocation = "Estimate distance: \(TotalDistance) km(s)"
            Response(true)
        }
        
    }
    
    
    func estimateTravelTime(request: MKDirections.Request, transportType: MKDirectionsTransportType, source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, string: @escaping (Double, Double) -> ()) {
        
        let p1 = CLLocation(latitude: source.latitude, longitude: source.longitude)
        let p2 = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        let distance = p2.distance(from: p1) / 1000
        
        let start = MKMapItem(placemark: MKPlacemark(coordinate: source, addressDictionary: nil))
        let Destiny = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
        
        request.source = start
        request.destination = Destiny
        request.transportType = transportType
        request.requestsAlternateRoutes = false
        directions = MKDirections(request: request)
        directions.calculateETA { (response, error) in
            if let seconds = response?.expectedTravelTime {
                let minutes = seconds / 60
                string(minutes , distance)
                //                    string(Int(ceil(minutes)).description, String(format: "%.2f", distance))
            } else {
                string(0, distance)
            }
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods for Add Address to Favourite
    //-------------------------------------------------------------
    
    func webserviceForGetEstimateETA() {
        //        PassengerId,Type,Address,Lat,Lng
      /*
        CurrentLat:23.7485451
        CurrentLng:72.5145151
        BookingId:5
        BookingType:Booking OR AdvanceBooking
        */
        
        var param = [String:AnyObject]()
        param["CurrentLat"] = strCurrentLat as AnyObject
        param["CurrentLng"] = strCurrentLng as AnyObject
        param["BookingId"] = strBookingID as AnyObject
        param["BookingType"] = strBookingType as AnyObject
//        param["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
//        param["BookingType"] = type as AnyObject
//        param["BookingId"] = txtDestinationLocation.text as AnyObject
//        param["CurrentLat"] = doubleDropOffLat as AnyObject  // SingletonClass.sharedInstance.currentLatitude as AnyObject
//        param["CurrentLng"] = doubleDropOffLng as AnyObject  // SingletonClass.sharedInstance.currentLongitude as AnyObject
        
        webserviceForGetDriverETA(param as AnyObject) { (result, status) in
            
            if (status) {
                //  print(result)
                
                if let res = result as? String {
                    
                    UtilityClass.setCustomAlert(title: "Error", message: res) { (index, title) in
                    }
                }
                else if let res = result as? NSDictionary {
                    
//                    let alert = UIAlertController(title: nil, message: res.object(forKey: "message") as? String, preferredStyle: .alert)
//                    let OK = UIAlertAction(title: "OK".localized, style: .default, handler: { ACTION in
//
//                        UIView.transition(with: self.viewForMainFavourite, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
//                            self.viewForMainFavourite.isHidden = true
//                        }) { _ in }
//                    })
//                    alert.addAction(OK)
//                    self.present(alert, animated: true, completion: nil)
                }
            }
            else {
                //     print(result)
            }
        }
    }
}
