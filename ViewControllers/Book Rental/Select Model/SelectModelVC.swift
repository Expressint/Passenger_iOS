//
//  SelectModelVC.swift
//  Book A Ride
//
//  Created by Yagnik on 20/12/22.
//  Copyright © 2022 Excellent Webworld. All rights reserved.
//

import UIKit
import SDWebImage
import SocketIO
import CoreLocation
import GoogleMaps
import FSPagerView
import SafariServices

class SelectModelVC: BaseViewController {
    
    @IBOutlet weak var tblData: UITableView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var vwNoTrip: UIView!
    @IBOutlet weak var vwTrip: UIView!
    @IBOutlet weak var btnDriverInfo: UIButton!
    @IBOutlet weak var btnCancelTrip: UIButton!
    @IBOutlet weak var stackBtns: UIStackView!
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var vwDuration: UIView!
    @IBOutlet weak var lbltripDuration: UILabel!
    @IBOutlet weak var vWAdvertisement: FSPagerView!
    @IBOutlet weak var advHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var btnCloseAdv: UIButton!
    
    let socket = (UIApplication.shared.delegate as! AppDelegate).socket
    var pickUpLocation: String = ""
    var pickUpLat: Double = 0.0
    var pickUpLng: Double = 0.0
    var dropOffLocation: String = ""
    var dropOffLat: Double = 0.0
    var dropOffpLng: Double = 0.0
    var modelId: Int?
    var modelName: String = ""
    var durationId: Int?
    var durationName: String?
    var arrData = [[String:Any]]()
    var arrDurationData = [[String:Any]]()
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    
    var dictCurrentBookingInfoData = NSDictionary()
    var dictCurrentDriverInfoData = NSDictionary()
    var dictCompleteTripData = NSDictionary()
    
    var driverMarker: GMSMarker!
    var destinationCordinate: CLLocationCoordinate2D!
    var boolShouldTrackCamera = true
    var moveMent: ARCarMovement!
    
    var originMarker = GMSMarker()
    var zoomLevel: Float = 17
    var selectedRoute: Dictionary<String, AnyObject>!
    var overviewPolyline: Dictionary<String, AnyObject>!
    var originCoordinate: CLLocationCoordinate2D!
    var destinationCoordinate: CLLocationCoordinate2D!
    var arrivedRoutePath: GMSPath?
    let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    
    var totalSecond = Int()
    var timer:Timer?
    var arrAdvImages : [[String: AnyObject]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLocalization()
        
        LocationManager.shared.delegate = self
        moveMent = ARCarMovement()
        moveMent.delegate = self
        
        self.socketMethods()
        self.registerNib()
        self.registerNotification()
        self.tblData.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.vwTrip.isHidden = true
        self.vwNoTrip.isHidden = true
        self.vwDuration.isHidden = true
        
        if currentTripType == "2" {
            self.getRentalCurrentBookingData()
            self.webserviceOfAdvList()
            self.setNavBarWithBack(Title: "Rental Trip".localized, IsNeedRightButton: true, isSOSNeeded: true)
        } else {
            self.webserviceCallForRentalModels()
            self.setNavBarWithBack(Title: "Select Model".localized, IsNeedRightButton: true)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(sosCall), name: Notification.Name(rawValue: "TourSOS"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    func setupPagerView() {
//        pageControl.numberOfPages = arrAdvImages.count
//        pageControl.currentPage = 0
//
        vWAdvertisement.dataSource = self
        vWAdvertisement.delegate = self
        
        vWAdvertisement.automaticSlidingInterval = 3.0
        vWAdvertisement.isInfinite = true
        vWAdvertisement.transformer = FSPagerViewTransformer(type: .linear)
        vWAdvertisement.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        vWAdvertisement.reloadData()
    }
    
    @objc func changeLanguage(){
        self.setLocalization()
    }
    
    @objc func sosCall(){
        self.socketEmitForSOS()
    }
    
    func setLocalization(){
        //self.lblServices.text = "Services".localized
        self.btnNext.setTitle("Next".localized, for: .normal)
        self.btnCancelTrip.setTitle("Cancel Trip".localized, for: .normal)
        
    }
    
    func getRentalCurrentBookingData() {
        UtilityClass.showHUD()
        var dictData = [String:Any]()
        dictData["PassengerId"] =  SingletonClass.sharedInstance.strPassengerID
    
        webserviceForRntalCurrentTrip(dictData as AnyObject) { result, success in
            UtilityClass.hideHUD()
            if(success) {
                let resultData = (result as! NSDictionary)
                print(result)
                self.dictCurrentBookingInfoData = resultData.object(forKey: "BookingInfo") as! NSDictionary
                self.dictCurrentDriverInfoData = resultData.object(forKey: "DriverInfo") as! NSDictionary
                self.setupViewForTripAccepted(bookingInfo: self.dictCurrentBookingInfoData, driverInfo: self.dictCurrentDriverInfoData)
                
                let driverLat = self.dictCurrentDriverInfoData.object(forKey: "Lat") as? String ?? "0.0"
                let driverLong = self.dictCurrentDriverInfoData.object(forKey: "Lng") as? String ?? "0.0"
                let pickUpTime = self.dictCurrentBookingInfoData.object(forKey: "PickupTime") as? String ?? ""
                let DestinationLat = (pickUpTime == "") ? self.dictCurrentBookingInfoData.object(forKey: "PickupLat") as? String ?? "0.0" : self.dictCurrentBookingInfoData.object(forKey: "DropOffLat") as? String ?? "0.0"
                let DestinationLong = (pickUpTime == "") ? self.dictCurrentBookingInfoData.object(forKey: "PickupLng") as? String ?? "0.0" : self.dictCurrentBookingInfoData.object(forKey: "DropOffLng") as? String ?? "0.0"
                
                if(pickUpTime != ""){
                    self.vwDuration.isHidden = false
                    self.stackBtns.isHidden = true
                    
                    let date = Date()
                    let df = DateFormatter()
                    df.dateFormat = "HH:mm:ss"
                    let currentTime = df.string(from: date)
                    self.totalSecond = Int(Double(self.findDateDiff(time1Str: self.convertDate(strDate: pickUpTime), time2Str: currentTime)) ?? 0)
                    self.startTimer()
                }
                
                let camera = GMSCameraPosition.camera(withLatitude: Double(driverLat) ?? 0.0,longitude: Double(driverLong) ?? 0.0, zoom: self.zoomLevel)
                self.mapView.animate(to: camera)
                self.LoadMapView(destinationLat: DestinationLat, destinationLong: DestinationLong, driverLat: driverLat, driverLong: driverLong)
            }
        }
    }
    
    func goTonvoice(tripData: NSDictionary) {
        let viewController = bookingsStoryboard.instantiateViewController(withIdentifier: "TourInvoiceVVC") as! TourInvoiceVVC
        viewController.dictCompleteTripData = tripData
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func goToConfirmLocation() {
        let viewController = bookingsStoryboard.instantiateViewController(withIdentifier: "ConfirmLocationVC") as? ConfirmLocationVC
        viewController?.modelId = modelId
        viewController?.modelName = modelName
        viewController?.durationId = durationId
        viewController?.durationName = durationName ?? ""
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    func registerNib() {
        let nib = UINib(nibName: SelectModelCell.className, bundle: nil)
        self.tblData.register(nib, forCellReuseIdentifier: SelectModelCell.className)
    }
    
    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.showLoader(_:)), name: RequestForTaxiHourly, object: nil)
    }
    
    @objc func showLoader(_ notification: NSNotification) {
        let viewCtr = requestLoading()
        self.present(viewCtr, animated: true)
    }
 
    func setupViewForTripAccepted(bookingInfo: NSDictionary, driverInfo: NSDictionary) {
        self.setNavBarWithBack(Title: "Rental Trip".localized, IsNeedRightButton: false, isSOSNeeded: true)
        self.vwNoTrip.isHidden = true
        self.vwTrip.isHidden = false
        
        print(bookingInfo)
        print(driverInfo)
    }
    
    func setupInitialView() {
        self.setNavBarWithBack(Title: "Select Model".localized, IsNeedRightButton: false)
        self.vwNoTrip.isHidden = false
        self.vwTrip.isHidden = true
        currentTripType = "4"
    }
    
    func updateLocation() {
        let myJSON = ["PassengerId" : SingletonClass.sharedInstance.strPassengerID, "Lat": "\(SingletonClass.sharedInstance.passengerLocation?.latitude ?? 0.0)", "Long": "\(SingletonClass.sharedInstance.passengerLocation?.longitude ?? 0.0)", "Token" : SingletonClass.sharedInstance.deviceToken, "ShareRide": SingletonClass.sharedInstance.isShareRide] as [String : Any]
        socket?.emit(SocketData.kUpdatePassengerLatLong , with: [myJSON], completion: nil)
    }
    
    func openDriverInfo() {
        let vc = bookingsStoryboard.instantiateViewController(withIdentifier: "TourDriverInfoVC") as! TourDriverInfoVC
        vc.delegate = self
        vc.dictCurrentBookingInfoData = self.dictCurrentBookingInfoData
        vc.dictCurrentPassengerInfoData = self.dictCurrentDriverInfoData
        vc.modalPresentationStyle = .overCurrentContext
        let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.coverVertical
        vc.modalTransitionStyle = modalStyle
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func brrnNextAction(_ sender: Any) {
        if(modelId == nil){
            Toast.show(message: "Please select model".localized, state: .failure)
        } else {
            let vc = bookingsStoryboard.instantiateViewController(withIdentifier: "DurationPopupVC") as! DurationPopupVC
            vc.modelSelected = self.modelId
            vc.delegate = self
            vc.strSelectedModel = modelName
            vc.modalPresentationStyle = .overCurrentContext
            let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.coverVertical
            vc.modalTransitionStyle = modalStyle
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnDriverInfoAction(_ sender: Any) {
        self.openDriverInfo()
    }
    
    @IBAction func btnCancelTripAction(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Are you sure you want to cancel the trip".localized, preferredStyle: .alert)
        let OK = UIAlertAction(title: "Accept".localized, style: .default, handler: { ACTION in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                let vc = bookingsStoryboard.instantiateViewController(withIdentifier: "CancelRentalTripVC") as! CancelRentalTripVC
                vc.delegate = self
                vc.modalPresentationStyle = .overCurrentContext
                let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.coverVertical
                vc.modalTransitionStyle = modalStyle
                self.present(vc, animated: true, completion: nil)
            }
        })
        let Cancel = UIAlertAction(title: "Decline".localized, style: .destructive, handler: { ACTION in
        })
        alert.addAction(OK)
        alert.addAction(Cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnCloseAdv(_ sender: Any) {
        advHeightConstraints.change(multiplier: 0)
        btnCloseAdv.isHidden = true
        self.view.updateConstraintsIfNeeded()
    }
}

extension SelectModelVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblData.dequeueReusableCell(withIdentifier: SelectModelCell.className) as! SelectModelCell
        cell.selectionStyle = .none
        
        cell.lblName.text = (arrData[indexPath.row])["ModelName"] as? String ?? ""
        cell.imgModel.sd_setIndicatorStyle(UIActivityIndicatorViewStyle.medium)
        cell.imgModel.sd_setShowActivityIndicatorView(true)
        let imageURL = (arrData[indexPath.row])["Model_Image"] as? String ?? ""
        cell.imgModel.sd_setImage(with: URL(string: NetworkEnvironment.current.imageBaseURL + imageURL), completed: { (image, error, cacheType, url) in
            cell.imgModel.sd_setShowActivityIndicatorView(false)
        })
        
        if(modelId != nil && modelId == Int((arrData[indexPath.row])["ModelId"] as? String ?? "")){
            cell.imgSelected.isHidden = false
        } else {
            cell.imgSelected.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.modelId = Int((arrData[indexPath.row])["ModelId"] as? String ?? "")
        self.modelName = arrData[indexPath.row]["ModelName"] as? String ?? ""
        self.tblData.reloadData()
    }
}

extension SelectModelVC {
    func webserviceCallForRentalModels() {
        UtilityClass.showHUD()
        webserviceForRentalModels("" as AnyObject) { response, status in
            UtilityClass.hideHUD()
            if(status) {
                self.vwNoTrip.isHidden = false
                DispatchQueue.main.async {
                    self.arrData = (response as? [String:Any])?["data"] as? [[String:Any]] ?? []
                    self.tblData.reloadData()
                }
            } else {
                if let res = response as? String {
                    Toast.show(message: res, state: .failure)
                }
                else if let resDict = response as? NSDictionary {
                    Toast.show(message: resDict.object(forKey: GetResponseMessageKey()) as? String ?? "", state: .failure)
                }
                else if let resAry = response as? NSArray {
                    Toast.show(message: (resAry.object(at: 0) as! NSDictionary).object(forKey: GetResponseMessageKey()) as? String ?? "", state: .failure)
                }
            }
        }
    }
}

extension SelectModelVC : DurationProtocol{
    func selectedDuration(id: Int, Name: String) {
        self.durationId = id
        self.durationName = Name
        self.goToConfirmLocation()
    }
}

extension SelectModelVC {
    func socketMethods() {
        
        socket?.on(clientEvent: .disconnect) { (data, ack) in
            print ("socket? is disconnected please reconnect")
        }
        
        socket?.on(clientEvent: .reconnect) { (data, ack) in
            print ("socket? is reconnected")
        }
        
        socket?.on(clientEvent: .connect) { data, ack in
            print("socket? BaseURl : \(NetworkEnvironment.current.socketURL)")
            print("socket? connected")
            self.RentalOnMethods()
        }
        
        if socket?.status == .connected {
            self.RentalOnMethods()
        } else {
            self.socket?.connect()
        }
    }
    
    func RentalOnMethods() {
        self.socketTourRequestRejected()
        self.socketTourRequestAccepted()
        self.socketForDriverLocation()
        self.socketForRentalDriverArrived()
        self.socketForPickupRentalPassenger()
        self.socketForRentalTripComplete()
        self.socketForRentalTripCancelled()
        self.socketForSOS()
    }
    
    func RentalOffMethods() {
        self.socket?.off(SocketData.RejectRentalBookingRequest)
        self.socket?.off(SocketData.AcceptRentalBookingRequest)
        self.socket?.off(SocketData.RentalDriverArrived)
        self.socket?.off(SocketData.PickupRentalPassengerNotification)
        self.socket?.off(SocketData.RentalTripCompleted)
        self.socket?.off(SocketData.CancelRentalTripNotification)
        self.socket?.off(SocketData.SOS)
    }
    
    func socketTourRequestRejected() {
        self.socket?.on(SocketData.RejectRentalBookingRequest, callback: { (data, ack) in
            print("RejectRentalBookingRequest() is \(data)")
            
            self.closeViewController(ofType: RequestLoadingVC.self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                Toast.show(message: (data as! [[String:AnyObject]])[0][GetResponseMessageKey()]! as? String ?? "", state: .failure)
            }
       })
    }
    
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
    func getBearingBetweenTwoPoints(point1 : CLLocationCoordinate2D, point2 : CLLocationCoordinate2D) -> Double {

        let lat1 = degreesToRadians(degrees: point1.latitude)
        let lon1 = degreesToRadians(degrees: point1.longitude)

        let lat2 = degreesToRadians(degrees: point2.latitude)
        let lon2 = degreesToRadians(degrees: point2.longitude)

        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)

        return radiansToDegrees(radians: radiansBearing)
    }
    
    func socketTourRequestAccepted() {
        self.socket?.on(SocketData.AcceptRentalBookingRequest, callback: { (data, ack) in
            print("AcceptRentalBookingRequest: \(data)")
            
            self.stackBtns.isHidden = false
            
            if let getInfoFromData = data as? [[String:AnyObject]] {
                let infoData = getInfoFromData[0]
                if let bookingInfo = infoData["BookingInfo"] as? [[String:AnyObject]] {
                    let bookingId = (bookingInfo[0])["Id"] as? String ?? ""
                    print(bookingId)
                    self.dictCurrentBookingInfoData = bookingInfo[0] as NSDictionary
                    
                    let driverInfo = infoData["DriverInfo"] as? [[String:AnyObject]]
                    self.dictCurrentDriverInfoData = driverInfo![0] as NSDictionary
                    //BookingType
                    let driverLat = self.dictCurrentDriverInfoData.object(forKey: "Lat") as? String ?? "0.0"
                    let driverLong = self.dictCurrentDriverInfoData.object(forKey: "Lng") as? String ?? "0.0"
                    let pickUpTime = self.dictCurrentBookingInfoData.object(forKey: "PickupTime") as? String ?? ""
                    let DestinationLat = (pickUpTime == "") ? self.dictCurrentBookingInfoData.object(forKey: "PickupLat") as? String ?? "0.0" : self.dictCurrentBookingInfoData.object(forKey: "DropOffLat") as? String ?? "0.0"
                    let DestinationLong = (pickUpTime == "") ? self.dictCurrentBookingInfoData.object(forKey: "PickupLng") as? String ?? "0.0" : self.dictCurrentBookingInfoData.object(forKey: "DropOffLng") as? String ?? "0.0"
                    
                    Toast.show(message: (data as! [[String:AnyObject]])[0][GetResponseMessageKey()]! as? String ?? "", state: .success)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        let bookingType = self.dictCurrentBookingInfoData.object(forKey: "BookingType") as? Int ?? 1
                        let onTheWay = self.dictCurrentBookingInfoData.object(forKey: "OnTheWay") as? String ?? ""
                        if(bookingType != 2  || onTheWay == "1") {
                            self.webserviceOfAdvList()
                            currentTripType = "2"
                            
                            self.closeViewController(ofType: RequestLoadingVC.self)
                            self.setupViewForTripAccepted(bookingInfo: self.dictCurrentBookingInfoData, driverInfo: self.dictCurrentDriverInfoData)
                            
                            let camera = GMSCameraPosition.camera(withLatitude: Double(driverLat) ?? 0.0,longitude: Double(driverLong) ?? 0.0, zoom: self.zoomLevel)
                            self.mapView.animate(to: camera)
                            self.LoadMapView(destinationLat: DestinationLat, destinationLong: DestinationLong, driverLat: driverLat, driverLong: driverLong)
                        }
                    }
                }
            }
       })
    }
    
    func socketForDriverLocation() {
        self.socket?.on(SocketData.kReceiveDriverLocationToPassenger, callback: { (data, ack) in
            print("kReceiveDriverLocationToPassenger: \(data)")
            
            SingletonClass.sharedInstance.driverLocation = (data as NSArray).object(at: 0) as! [String : AnyObject]
            
            var DoubleLat = Double()
            var DoubleLng = Double()
            
            if let lat = SingletonClass.sharedInstance.driverLocation["Location"]! as? [Double] {
                DoubleLat = lat[0]
                DoubleLng = lat[1]
            } else if let lat = SingletonClass.sharedInstance.driverLocation["Location"]! as? [String] {
                DoubleLat = Double(lat[0])!
                DoubleLng = Double(lat[1])!
            }
            
            var DriverCordinate = CLLocationCoordinate2D(latitude: DoubleLat , longitude: DoubleLng)
            DriverCordinate = CLLocationCoordinate2DMake(DriverCordinate.latitude, DriverCordinate.longitude)
            
            if self.driverMarker == nil {
                self.driverMarker = GMSMarker(position: DriverCordinate) // self.originCoordinate
                self.driverMarker.icon = UIImage(named: "dummyCar")
                self.driverMarker.map = self.mapView
            } else {
                self.driverMarker.icon = UIImage.init(named: "dummyCar")
            }
            
            self.driverMarker.map = self.mapView
            
            if(self.destinationCordinate == nil){
                self.destinationCordinate = CLLocationCoordinate2DMake(DriverCordinate.latitude, DriverCordinate.longitude)
            }
            
            if self.destinationCordinate != nil {
                CATransaction.begin()
                CATransaction.setValue(2, forKey: kCATransactionAnimationDuration)
            }

            let bearing = self.getBearingBetweenTwoPoints(point1: CLLocationCoordinate2DMake(self.destinationCordinate.latitude, self.destinationCordinate.longitude), point2:CLLocationCoordinate2DMake(DriverCordinate.latitude, DriverCordinate.longitude))
                     
            if(self.boolShouldTrackCamera) {
               // let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,longitude: location.coordinate.longitude,zoom: zoomLevel)
                let camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2DMake(DriverCordinate.latitude, DriverCordinate.longitude), zoom: 17, bearing: bearing, viewingAngle: 45)
                self.mapView.animate(to: camera)
            }
            
            self.moveMent.ARCarMovement(marker: self.driverMarker, oldCoordinate: self.destinationCordinate, newCoordinate: DriverCordinate, mapView: self.mapView, bearing: 0)
            
            self.destinationCordinate = DriverCordinate
            if self.destinationCordinate != nil {
                CATransaction.commit()
            }
       })
    }
    
    func socketForRentalDriverArrived() {
        self.socket?.on(SocketData.RentalDriverArrived, callback: { (data, ack) in
            print("RentalDriverArrived: \(data)")
            currentTripType = "2"
            Toast.show(message: (data as! [[String:AnyObject]])[0][GetResponseMessageKey()]! as? String ?? "", state: .success)
        })
    }
    
    func socketForPickupRentalPassenger() {
        self.socket?.on(SocketData.PickupRentalPassengerNotification, callback: { (data, ack) in
            print("PickupRentalPassengerNotification: \(data)")
            
            self.stackBtns.isHidden = true
            
            if let getInfoFromData = data as? [[String:AnyObject]] {
                let infoData = getInfoFromData[0]
                if let bookingInfo = infoData["BookingInfo"] as? [[String:AnyObject]] {
                    self.dictCurrentBookingInfoData = bookingInfo[0] as NSDictionary
                    
                    let driverInfo = infoData["DriverInfo"] as? [[String:AnyObject]]
                    self.dictCurrentDriverInfoData = driverInfo![0] as NSDictionary
                    
                    let driverLat = self.dictCurrentDriverInfoData.object(forKey: "Lat") as? String ?? "0.0"
                    let driverLong = self.dictCurrentDriverInfoData.object(forKey: "Lng") as? String ?? "0.0"
                    let pickUpTime = self.dictCurrentBookingInfoData.object(forKey: "PickupTime") as? String ?? ""
                    let DestinationLat = (pickUpTime == "") ? self.dictCurrentBookingInfoData.object(forKey: "PickupLat") as? String ?? "0.0" : self.dictCurrentBookingInfoData.object(forKey: "DropOffLat") as? String ?? "0.0"
                    let DestinationLong = (pickUpTime == "") ? self.dictCurrentBookingInfoData.object(forKey: "PickupLng") as? String ?? "0.0" : self.dictCurrentBookingInfoData.object(forKey: "DropOffLng") as? String ?? "0.0"
                    
                    self.vwDuration.isHidden = false
                    let bookingTime = self.dictCurrentBookingInfoData.object(forKey: "PickupTime") as? String
                    
                    let date = Date()
                    let df = DateFormatter()
                    df.dateFormat = "HH:mm:ss"
                    let currentTime = df.string(from: date)
                    
                    self.totalSecond = Int(Double(self.findDateDiff(time1Str: self.convertDate(strDate: bookingTime ?? ""), time2Str: currentTime)) ?? 0)
                    self.startTimer()
                    
                    Toast.show(message: (data as! [[String:AnyObject]])[0][GetResponseMessageKey()]! as? String ?? "", state: .success)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        let camera = GMSCameraPosition.camera(withLatitude: Double(driverLat) ?? 0.0,longitude: Double(driverLong) ?? 0.0, zoom: self.zoomLevel)
                        self.mapView.animate(to: camera)
                        self.LoadMapView(destinationLat: DestinationLat, destinationLong: DestinationLong, driverLat: driverLat, driverLong: driverLong)
                    }
                }
            }
        })
    }
    
    func socketForRentalTripCancelled() {
        self.socket?.on(SocketData.CancelRentalTripNotification, callback: { (data, ack) in
            print("CancelRentalTripNotification: \(data)")
            Toast.show(message: (data as! [[String:AnyObject]])[0][GetResponseMessageKey()]! as? String ?? "", state: .success)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.setupInitialView()
            }
        })
    }
    
    func convertDate(strDate: String) -> String {
        let PickDate = Double(strDate)
        guard let unixTimestamp1 = PickDate else { return "" }
        let date1 = Date(timeIntervalSince1970: TimeInterval(unixTimestamp1))
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "HH:mm:ss"
        let strDate1 = dateFormatter1.string(from: date1)
        return strDate1
    }
    
    func findDateDiff(time1Str: String, time2Str: String) -> String {
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "HH:mm:ss"
        guard let time1 = timeformatter.date(from: time1Str),let time2 = timeformatter.date(from: time2Str) else { return "" }
        let interval = time2.timeIntervalSince(time1)
        return "\(interval)"
    }
    
    func startTimer(){
        if(timer?.isValid != true){
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        }
    }
    
    @objc func countdown() {
        var hours: Int
        var minutes: Int
        var seconds: Int
        
        totalSecond = totalSecond + 1
        hours = totalSecond / 3600
        minutes = (totalSecond % 3600) / 60
        seconds = (totalSecond % 3600) % 60
        self.lbltripDuration.text = "\("Trip Duration".localized) : \(String(format: "%02d:%02d:%02d", hours, minutes, seconds))"
        
        let packageInfo = self.dictCurrentBookingInfoData.object(forKey: "PackageInfo") as? NSDictionary
        let packageHours = Int(packageInfo?.object(forKey: "MinimumHours") as? String ?? "") ?? 0
        
        if(hours >= packageHours && minutes >= 0 && seconds > 0){
            vwDuration.backgroundColor = UIColor.red
        } else {
            vwDuration.backgroundColor = themeYellowColor
        }
    }
    
    func socketForRentalTripComplete() {
        self.socket?.on(SocketData.RentalTripCompleted, callback: { (data, ack) in
            print("RentalTripCompleted: \(data)")
            self.timer?.invalidate()
            self.timer = nil
            currentTripType = ""
            
            if let getInfoFromData = data as? [[String:AnyObject]] {
                let infoData = getInfoFromData[0]
                if let bookingInfo = infoData["Info"] as? [[String:AnyObject]] {
                    self.dictCompleteTripData = bookingInfo[0] as NSDictionary
                    
                    Toast.show(message: "Your trip has been completed".localized, state: .success)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.setupInitialView()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.goTonvoice(tripData: self.dictCompleteTripData)
                        }
                    }
                }
            }
        })
    }
    
    func socketEmitForSOS() {
        let myJSON = ["UserId" : SingletonClass.sharedInstance.strPassengerID,
                      "BookingId": "\(self.dictCurrentBookingInfoData.object(forKey: "Id") as AnyObject)",
                      "UserType": "Passenger","Lat": "\(SingletonClass.sharedInstance.passengerLocation?.latitude ?? 0.0)", "Lng": "\(SingletonClass.sharedInstance.passengerLocation?.longitude ?? 0.0)"] as [String : Any]
        
        self.socket?.emit(SocketData.RentalSOS, with: [myJSON], completion: nil)
        print ("\(SocketData.RentalSOS) : \(myJSON)")
    }
    
    func socketForSOS() {
        self.socket?.on(SocketData.RentalSOS, callback: { (data, ack) in
            print ("SOS Driver Notify : \(data)")
            let msg = (data as NSArray)
            Toast.show(message: (msg.object(at: 0) as? NSDictionary)?.object(forKey: GetResponseMessageKey()) as? String ?? "", state: .success)
//            UtilityClass.showAlert("", message: (msg.object(at: 0) as? NSDictionary)?.object(forKey: GetResponseMessageKey()) as? String ?? "", vc: self)
        })
    }
}

extension SelectModelVC: LocationManagerDelegate {
    func locationManager(_ manager: LocationManager, didUpdateLocation mostRecentLocation: CLLocation) {
        updateLocation()
    }
}

extension SelectModelVC: ARCarMovementDelegate {
    func ARCarMovementMoved(_ Marker: GMSMarker) {
        driverMarker = Marker
        driverMarker.map = mapView
    }
}

extension SelectModelVC {
    
    func LoadMapView(destinationLat: String, destinationLong: String, driverLat: String, driverLong: String) {
        let dropOffLat = destinationLat
        let dropOffLong = destinationLong
        let originalLoc: String = "\(driverLat),\(driverLong)"
        let destiantionLoc: String = "\(dropOffLat),\(dropOffLong)"
        getDirectionsSeconMethod(origin: originalLoc, destination: destiantionLoc, waypoints: nil, travelMode: nil, completionHandler: nil)
    }
    
    func getDirectionsSeconMethod(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, completionHandler: ((_ status:   String, _ success: Bool) -> Void)?) {
        
        mapView.clear()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if let originLocation = origin {
                if let destinationLocation = destination {
                    var directionsURLString = self.baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation + "&key=" + googlApiKey
                    print ("directionsURLString: \(directionsURLString)")
                    directionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                    let directionsURL = NSURL(string: directionsURLString)
                    DispatchQueue.main.async( execute: { () -> Void in
                        let directionsData = NSData(contentsOf: directionsURL! as URL)
                        
                        do{
                            let dictionary: Dictionary<String, AnyObject> = try JSONSerialization.jsonObject(with: directionsData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
                            
                            let status = dictionary["status"] as! String
                            if status == "OK" {
                                self.selectedRoute = (dictionary["routes"] as! Array<Dictionary<String, AnyObject>>)[0]
                                self.overviewPolyline = self.selectedRoute["overview_polyline"] as? Dictionary<String, AnyObject>
                                
                                let legs = self.selectedRoute["legs"] as! Array<Dictionary<String, AnyObject>>
                                let startLocationDictionary = legs[0]["start_location"] as! Dictionary<String, AnyObject>
                                self.originCoordinate = CLLocationCoordinate2DMake(startLocationDictionary["lat"] as! Double, startLocationDictionary["lng"] as! Double)
                                
                                let endLocationDictionary = legs[legs.count - 1]["end_location"] as! Dictionary<String, AnyObject>
                                self.destinationCoordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
                                
                                _ = legs[0]["start_address"] as! String
                                let destinationAddress = legs[legs.count - 1]["end_address"] as! String
                                
                                if(self.driverMarker == nil) {
                                    self.driverMarker = GMSMarker(position: self.originCoordinate)
                                    self.driverMarker.icon = UIImage(named: "dummyCar")
                                    self.driverMarker.map = self.mapView
                                }
                                
                                let destinationMarker = GMSMarker(position: self.destinationCoordinate)
                                destinationMarker.map = self.mapView
                                destinationMarker.icon = UIImage.init(named: "iconMapPin")
                                destinationMarker.title = destinationAddress
                                
                                var aryDistance = [Double]()
                                var finalDistance = Double()
                                
                                for i in 0..<legs.count {
                                    let legsData = legs[i]
                                    let distanceKey = legsData["distance"] as! Dictionary<String, AnyObject>
                                    let distance = distanceKey["text"] as! String
                                    let stringDistance = distance.components(separatedBy: " ")
                                    if stringDistance[1] == "m" {
                                        finalDistance += Double(stringDistance[0])! / 1000
                                    }
                                    else {
                                        finalDistance += Double(stringDistance[0].replacingOccurrences(of: ",", with: ""))!
                                    }
                                    aryDistance.append(finalDistance)
                                }
                                
                                print("aryDistance : \(aryDistance)")
                                let route = self.overviewPolyline["points"] as! String
                                self.arrivedRoutePath = GMSPath(fromEncodedPath: route)!
                                let path: GMSPath = GMSPath(fromEncodedPath: route)!
                                let routePolyline = GMSPolyline(path: path)
                                routePolyline.map = self.mapView
                                routePolyline.strokeColor = themeYellowColor
                                routePolyline.strokeWidth = 3.0
                                print("line draw : \(#line) function name : \(#function)")
                            } else {
                                print("OVER_QUERY_LIMIT Line number : \(#line) function name : \(#function)")
                            }
                        } catch {
                            print("Catch Not able to get location due to free api key please restart app")
                        }
                    })
                } else {
                    print  ("Destination is nil.")
                }
            } else {
                print  ("Origin is nil")
            }
        }
    }

}

extension SelectModelVC : CancelRentalTripProtocol {
    func CancelRentalTrip(Reason: String) {
        let myJSON = [SocketDataKeys.kBookingIdNow : self.dictCurrentBookingInfoData.object(forKey: "Id") as? String ?? "", SocketDataKeys.kCancelReasons : Reason] as [String : Any]
        socket?.emit(SocketData.CancelRentalTripByPassenger , with: [myJSON], completion: nil)
    }
}

extension SelectModelVC: ChatWithDriverprotocol {
    func gotoChat() {
        currentTripType = "2"
        
        let strBookingID = "\(self.dictCurrentBookingInfoData.object(forKey: "Id") as AnyObject)"
        let setDriverId =  "\(self.dictCurrentDriverInfoData.object(forKey: "Id") as AnyObject)"
        let DriverName = self.dictCurrentDriverInfoData.object(forKey: "Fullname") as? String ?? ""
      
        let NextPage = mainStoryboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        NextPage.bookingType = "Rental"
        NextPage.receiverName = DriverName
        NextPage.bookingId = String(strBookingID)
        NextPage.receiverId = String(setDriverId)
        self.navigationController?.pushViewController(NextPage, animated: true)
    }
}


extension SelectModelVC: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.arrAdvImages.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
   
        let urlLogo = NetworkEnvironment.current.imageBaseURL +  (arrAdvImages[index]["BannerImage"] as? String ?? "")
        cell.imageView?.sd_setImage(with: URL(string: urlLogo), placeholderImage: UIImage(named: "Banner_Placeholder"), options: [.continueInBackground], progress: nil, completed: { (image, error, cache, url) in
            if (error == nil) {
                cell.imageView?.image = image
            }
        })
        
        cell.imageView?.contentMode = .scaleAspectFit
        cell.cornerRadius = 10
        cell.contentMode = .scaleAspectFit
        cell.clipsToBounds = true
        cell.layer.masksToBounds = true
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        
        let AdvNotification = "AdvNotification"
        let notificationName = Notification.Name(AdvNotification)
        let data = ["Id": arrAdvImages[index]["Id"] as? String ?? "", "Url" : arrAdvImages[index]["WebsiteURL"] as? String ?? ""]
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: data)
    }
    
//    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
//        self.pageControl.currentPage = targetIndex
//    }
//
//    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
//        self.pageControl.currentPage = pagerView.currentIndex
//    }
}

extension SelectModelVC {
    func webserviceOfAdvList() {
        webserviceForAdvList { (result, status) in
            if (status) {
                print(result)
                let data = result["data"] as? [[String: AnyObject]] ?? [[:]]
                self.arrAdvImages = data
                self.setupPagerView()
            }else {
                print(result)
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
    
    func gotoPage(strUrl: String) {
        let next = mainStoryboard.instantiateViewController(withIdentifier: "webViewVC") as! webViewVC
        next.headerName = "BookARide"
        next.strURL = strUrl
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    func viewAdv(URLMain: String) {
        guard let url = URL(string: URLMain) else {return}
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
    }
}
