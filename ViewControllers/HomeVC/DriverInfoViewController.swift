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
import Alamofire
import SwiftyJSON


class DriverInfoViewController: UIViewController {
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var imgCar: UIImageView!
//    @IBOutlet weak var lblCareName: UILabel!
    @IBOutlet weak var lblCarClassModel: UILabel!
    
    @IBOutlet weak var lblTitleVehicleColor: UILabel!
    @IBOutlet weak var lblTitleVehicleType: UILabel!
    @IBOutlet weak var lblTitleVehiclePlateNum: UILabel!
    @IBOutlet weak var lblTitleVehicleMake: UILabel!
    @IBOutlet weak var lblVehicleMake: UILabel!
    @IBOutlet weak var lblVehiclePlateNum: UILabel!
    @IBOutlet weak var lblVehicleType: UILabel!
    @IBOutlet weak var lblVehicleColor: UILabel!
    
    @IBOutlet weak var lblPickupLocation: MarqueeLabel!
    @IBOutlet weak var lblDropoffLocation: MarqueeLabel!
    @IBOutlet weak var lblDropoffLocation2: MarqueeLabel!
    @IBOutlet weak var viewDropoffLocation2: UIView!
    @IBOutlet weak var btnChat: UIButton!
    
    @IBOutlet weak var viewTimeToReachPickLocation: UIView!
    @IBOutlet weak var viewDistanceToReachPickLocation: UIView!
    var driverLocationLat = String()
    var driverLocationLong = String()
    
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
    
    var strVehicleMake = String()
    var strVehiclePlateNum = String()
    var strVehicleType = String()
    var strVehicleColor = String()
    
    
    var strPickupLocation = String()
    var strDropoffLocation = String()
    var strDropoffLocation2 = String()
    var strDriverImage = String()
    var strDriverName = String()
    var strCarPlateNumber = String()
    var strPassengerMobileNumber = String()
    var strDriverID = String()
    var homeVC : HomeViewController?
    
    var delegate: deleagateGoToChat?
    
//    @IBOutlet var lblApproxTime: UILabel!
//    @IBOutlet var lblApproxDistanceToYourLocation: UILabel!


    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        fillAllFields()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
        self.setLocalization()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        socketOnMethodForGettingDriverLocation()
        
        btnOk.layer.cornerRadius = 5
        btnOk.layer.masksToBounds = true
        viewCarAndDriverInfo.layer.cornerRadius = 5
        viewCarAndDriverInfo.layer.masksToBounds = true
        btnCallGreen.layer.cornerRadius = btnCallGreen.frame.width / 2
        btnCallGreen.clipsToBounds = true
//        self.webserviceForGetEstimateETA()
        

//        self.fillAllFields()
        
       
        if(shouldShow)
        {
            self.strApproxTimeToYourLocation = "calculating..."
            self.strApproxDistanceToYourLocation = "calculating..."
            self.fillAllFields()

            
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                self.socketMethodForEmitingToGetDriverLocation()
            }

        }
        else
        {
            self.fillAllFields()
            
        }
    }
    
    @objc func changeLanguage(){
        self.setLocalization()
    }
    
    func socketMethodForEmitingToGetDriverLocation(){
        let myJSON = ["PassengerId" : SingletonClass.sharedInstance.strPassengerID, "DriverId": strDriverID] as [String : Any]
        homeVC?.socket?.emit(SocketData.kGetDriverCurrentLatLong , with: [myJSON], completion: nil)
        print("Method name is \(SocketData.kGetDriverCurrentLatLong) and value is \(myJSON)")
//        print("is Socket connected \(homeVC?.socket?.status)")
        if homeVC?.socket?.status != .connected {
            
            print("socket?.status != .connected")
        }else
        {
            print("Its connected")
            
//            self.socketMethodForEmitingToGetDriverLocation()
        }
    }
    
    func socketOnMethodForGettingDriverLocation()
    {
        print("Socket did on")
        homeVC?.socket?.on(SocketData.kGetDriverCurrentLatLong, callback: { data, ack in
            print( "The data is \((data.first as? [String:Any]) ?? [:])")
            
            if let dictData = data.first as? [String:Any]
            {
                if let arrLocation = dictData["Location"] as? [Double]
                {
                    self.strCurrentLat = "\(arrLocation.first ?? 0.0)"
                    self.strCurrentLng = "\(arrLocation.last ?? 0.0)"
                }
                else if let arrLocation = dictData["Location"] as? [String]
                {
                    self.strCurrentLat = arrLocation.first ?? "0.0"
                    self.strCurrentLng = arrLocation.last ?? "0.0"
                }
                
              //  self.getEstimate()
            }
        })
    }
    
    func getEstimate()
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        imgCar.layer.cornerRadius = imgCar.frame.size.width / 2
//        imgCar.layer.masksToBounds = true
//
        imgDriver.layer.cornerRadius = 20
        imgDriver.layer.masksToBounds = true
        
        imgCar.layer.cornerRadius = 20
        imgCar.layer.masksToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    func setLocalization(){
        lblDriverInfo.text = "Driver Info".localized
        lblTitleVehicleMake.text = "Vehicle Make".localized
        lblTitleVehicleType.text = "Vehicle Type".localized
        lblTitleVehiclePlateNum.text = "Vehicle Plate Num".localized
        lblTitleVehicleColor.text = "Vehicle Color".localized
        lblDriverName.text = "Jina la dereva".localized
//        lblCareName.text = "Jina la Gari".localized
        lblPickupLocation.text = "Pickup Location".localized
        lblDropoffLocation.text = "Dropoff Location".localized
    }
    

    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnClosed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnMessage(_ sender: UIButton) {
        self.onSOS()
        socketEmitForSOS()
    }
    
    
    func socketEmitForSOS()
    {
        let myJSON = ["UserId" : SingletonClass.sharedInstance.strPassengerID,
                      "BookingId": strBookingID,
                      "BookingType" : self.strBookingType,
                      "UserType": "Passenger", "Token": SingletonClass.sharedInstance.deviceToken,"Lat": SingletonClass.sharedInstance.currentLatitude, "Lng": SingletonClass.sharedInstance.currentLongitude] as [String : Any]
        
        homeVC?.socket?.emit(SocketData.SOS, with: [myJSON], completion: nil)
        print ("\(SocketData.SOS) : \(myJSON)")
    }
    
    func onSOS() {
        
        homeVC?.socket?.on("SOS", callback: { (data, ack) in
            print ("SOS Driver Notify : \(data)")
            
            let msg = (data as NSArray)
            
            UtilityClass.showAlert("", message: (msg.object(at: 0) as! NSDictionary).object(forKey: GetResponseMessageKey()) as? String ?? "", vc: self)
            
        })
        
    }
    
    func goToChat() {
        delegate?.btndeleagateGoToChat()
    }
    
    
    @IBAction func btnChatAction(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.goToChat()
            }
        })
       
    }
    
    @IBAction func btnOK(_ sender: ThemeButton) {
   
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnCall(_ sender: UIButton) {
        
        let contactNumber = helpLineNumber //strPassengerMobileNumber
        
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
 
        imgDriver.sd_setShowActivityIndicatorView(true)
        imgDriver.sd_setIndicatorStyle(UIActivityIndicatorViewStyle.medium)
        imgDriver.sd_setImage(with: URL(string: strDriverImage), placeholderImage: UIImage(named: "icon_UserImages"), options: [.retryFailed,.scaleDownLargeImages]) { image, error, cacheType, url in
//            print(image)

        }
        
        
        imgCar.sd_setShowActivityIndicatorView(true)
        imgCar.sd_setIndicatorStyle(UIActivityIndicatorViewStyle.medium)
        imgCar.sd_setImage(with: URL(string: strCarImage), placeholderImage: UIImage(named: "icon_UserImages"), options: [.retryFailed,.scaleDownLargeImages]) { image, error, cacheType, url in
//            print(image)

        }
        
        viewDropoffLocation2.isHidden = true
        if(strDropoffLocation2 != "")
        {
            viewDropoffLocation2.isHidden = false
            lblDropoffLocation2.text = strDropoffLocation2
        }
        lblPickupLocation.text = strPickupLocation
        lblDropoffLocation.text = strDropoffLocation
        lblDriverName.text = strDriverName
       
        if strCarClass.count == 1 {
            lblCarClassModel.text = carClass(strClass: strCarClass)
        }
        else {
            lblCarClassModel.text = strCarClass
        }
        
        
//        self.lblApproxTime.text  = self.strApproxTimeToYourLocation
//        self.lblApproxDistanceToYourLocation.text = self.strApproxDistanceToYourLocation
//
//        self.lblApproxTime.isHidden  = (self.strApproxTimeToYourLocation == "")
//        self.lblApproxDistanceToYourLocation.isHidden = (self.strApproxDistanceToYourLocation == "")
//        self.viewTimeToReachPickLocation.isHidden = self.lblApproxTime.isHidden
//        self.viewDistanceToReachPickLocation.isHidden = self.lblApproxDistanceToYourLocation.isHidden
        
        
        self.lblVehicleMake.text = "\(strVehicleMake)"
        self.lblVehiclePlateNum.text = "\(strCarPlateNumber)"
        self.lblVehicleType.text = "\(strVehicleType)"
        self.lblVehicleColor.text = "\(strVehicleColor)"
        
        
    


    }
   
    @IBAction func btnCallToDriver(_ sender: UIButton) {
        
        let contactNumber = helpLineNumber //strPassengerMobileNumber
        
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
        let pickupLat = self.strCurrentLat
        let pickupLng = self.strCurrentLng
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
        
//        let p1 = CLLocation(latitude: source.latitude, longitude: source.longitude)
//        let p2 = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        
        
        let directionURL = "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&key=\(googlApiKey)"
        
        print("The url is \(directionURL)")
        
        Alamofire.request(directionURL, method: .post, encoding: JSONEncoding.default, headers: nil).downloadProgress(queue: DispatchQueue.global(qos: .utility)){
            progress in
            print("Progress: \(progress.fractionCompleted)")
        }
        .responseJSON {
            response in
            if response.result.isSuccess {
                print("response is \(response)")
                let JsonResponse = JSON(response.result.value!)
                let routes = JsonResponse["routes"].arrayValue
                for route in routes
                {
                    
                    let duration = route["legs"][0]["duration"]["text"].doubleValue
                    
                    let distance = route["legs"][0]["distance"]["value"].doubleValue
                    
                    
//                    if let seconds = response?.expectedTravelTime {
//                        let minutes = seconds / 60
                        string(duration , distance/1000)
                        //                    string(Int(ceil(minutes)).description, String(format: "%.2f", distance))
//                    } else {
//                        string(0, distance)
//                    }
//
                    
                }
                
            }
            if response.result.isFailure {
                // Show error
                print("Response failed \(response.result.error?.localizedDescription ?? "")")
                string(0 , 0)

            }
        }
        
        //        let distance = p2.distance(from: p1) / 1000
        //
        //        let start = MKMapItem(placemark: MKPlacemark(coordinate: source, addressDictionary: nil))
        //        let Destiny = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
        //
        //        request.source = start
        //        request.destination = Destiny
        //        request.transportType = transportType
        //        request.requestsAlternateRoutes = false
        //        directions = MKDirections(request: request)
        //        directions.calculateETA { (response, error) in
        //            if let seconds = response?.expectedTravelTime {
        //                let minutes = seconds / 60
        //                string(minutes , distance)
        //                //                    string(Int(ceil(minutes)).description, String(format: "%.2f", distance))
        //            } else {
        //                string(0, distance)
        //            }
        //        }
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods for Add Address to Favourite
    //-------------------------------------------------------------
    
   /* func webserviceForGetEstimateETA() {
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
    }*/
}
