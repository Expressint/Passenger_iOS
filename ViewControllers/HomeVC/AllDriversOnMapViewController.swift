//
//  AllDriversOnMapViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 08/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces
import Pulsator

class AllDriversOnMapViewController: UIViewController, CLLocationManagerDelegate {

    let kMaxRadius: CGFloat = 200
    let kMaxDuration: TimeInterval = 10
    
   
    
    @IBOutlet weak var subMapView: UIView!
    
     var timer = Timer()
    
    var mapView : GMSMapView!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var defaultLocation = CLLocation() // CLLocation(latitude: -37.814, longitude: 144.96332)// 144.96332
    var zoomLevel: Float = 5.0
    var viewMap = UIView()
    
    let pulsator = Pulsator()
    
    var ripple: MTRipple!
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436: break
                
            default:
                print("unknown")
            }
        }

//        startAnimation()
        
        webserviceForAllDrivers()
        
//        if SingletonClass.sharedInstance.allDiverShowOnBirdView.count != 0 {
//            webserviceForAllDrivers()
//        }
//        else {
//            self.dictData = SingletonClass.sharedInstance.allDiverShowOnBirdView
//        }
        
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            if locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization))
            {
                if locationManager.location != nil
                {
                    locationManager.startUpdatingLocation()
                    locationManager.delegate = self

                }
            }
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude, zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), camera: camera)
        mapView.isMyLocationEnabled = false
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  
        subMapView.addSubview(mapView)
        
         getAllLatandLong()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         
         
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.layoutIfNeeded()
        pulsator.position = imgStartTrip.layer.position
    }

    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var imgStartTrip: UIImageView!
    @IBOutlet weak var animatingView: UIView!
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    func startAnimation() {
        
        ripple = MTRipple.init(frame:CGRect(x: 0.0, y: 0.0, width: self.animatingView.frame.size.width, height: self.animatingView.frame.size.height)).startViewAniamtion(animationTime: 4.0, animateView: self.animatingView) as! MTRipple
        
        ripple.setImage(UIImage.init(named: "round30.png")!)
        
        scheduledTimerWithTimeInterval()
    }
    

    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    @IBAction func btnDismissToHome(_ sender: UIButton) {
        
        if ripple != nil {
             ripple.hideAnimation()
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    private func setupInitialValues() {
        
       pulsator.numPulse = 5
       pulsator.radius = CGFloat(0.7) * kMaxRadius
        pulsator.animationDuration = Double(0.5) * kMaxDuration
        
        pulsator.backgroundColor = UIColor.red.cgColor
    }

    
    @IBAction func btnClose(_ sender: UIButton) {
       
        if ripple != nil {
             ripple.hideAnimation()
        }
        
        self.dismiss(animated: true, completion: nil)
        
     //   self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
        
    }
   
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.btnClose(_:)), userInfo: nil, repeats: false)
        
    }

    //-------------------------------------------------------------
    // MARK: - Location Methods
    //-------------------------------------------------------------
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        defaultLocation = location
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView.camera = camera
        
//        print("Location: \(location)")
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
   
    func setMarkersOnMap(latitude: Double, longitude: Double, name: String, carModel: String) {
        
        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let marker = GMSMarker(position: position)
        marker.icon = UIImage(named: carModel)
        marker.snippet = name
        marker.map = self.mapView
        
        subMapView.addSubview(mapView)
    }
    
    //-------------------------------------------------------------
    // MARK: - webserviceForGetAllDrivers
    //-------------------------------------------------------------
    
    var dictData = NSArray()
    
    func webserviceForAllDrivers()
    {
        webserviceForAllDriversList { (result, status) in
            
            if (status) {

                self.dictData = ((result as! NSDictionary).object(forKey: "drivers") as! NSArray)
                self.getAllLatandLong()
                self.startAnimation()
           
            }
            else {
                print(result)
            }
        }
    }
    
    func getAllLatandLong()
    {
        for i in 0..<self.dictData.count {
            
            let currentMarkers = self.dictData[i] as! NSDictionary
            
            let lat = currentMarkers.object(forKey: "Lat") as! String
            let lng = currentMarkers.object(forKey: "Lng") as! String
            let name = currentMarkers.object(forKey: "Fullname") as! String
    
            if currentMarkers.object(forKey: "Models") as! String != "" {
                
                let img = (currentMarkers.object(forKey: "Models") as! String).first!
                
                if (lat != "" && lng != "") && (lat != "0" && lng != "0") {
                    let doubleLat = Double(lat)
                    let doubleLng = Double(lng)
                    setMarkersOnMap(latitude: doubleLat!, longitude: doubleLng!, name: name, carModel: setCarImage(modelId: img))
                }
            }
            

//            let img = (currentMarkers.object(forKey: "Models") as! String).replacingOccurrences(of: ",", with: "")
            
//            print("img : \(img)")
//            let strImg = Character("".randomCarModelFromList(length: 1, param: img))
//            print("strImg : \(strImg)")
            
            print(lat)
            print(lng)
            
            
        }
    }
    
    func setCarImage(modelId : Character) -> String {
        
        var CarModel = String()
       
        switch modelId {
        case "1":
            CarModel = "imgBusinessClass"
             return CarModel
        case "2":
            CarModel = "imgMIni"
             return CarModel
        case "3":
            CarModel = "imgVan"
             return CarModel
        case "4":
            CarModel = "imgNano"
             return CarModel
        case "5":
            CarModel = "imgTukTuk"
             return CarModel
        case "6":
            CarModel = "imgBreakdown"
             return CarModel
        default:
            CarModel = "imgBus"
             return CarModel
        }
    }
    
}

extension String {
    
    func randomCarModelFromList(length: Int, param: String) -> String {
        let base = param
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}
