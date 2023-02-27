//
//  PickFromMapVC.swift
//  Book A Ride
//
//  Created by Yagnik on 05/01/23.
//  Copyright © 2023 Excellent Webworld. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import CoreLocation
import MarqueeLabel

protocol LocationProtocol: AnyObject {
    func LocationPicjked(lat: Double, lng: Double, Address: String)
}

class PickFromMapVC: BaseViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var lblAddress: MarqueeLabel!
    
    var pickUpLat: Double?
    var pickUpLong: Double?
    var address: String?
    var cameraZoom: Float = 17.0
    let baseUrlForGetAddress = "https://maps.googleapis.com/maps/api/geocode/json?"
    weak var delegate: LocationProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnConfirm.setTitle("Confirm Location".localized, for: .normal)
        
        self.mapView.delegate = self
        self.lblAddress.text = address
        
        CATransaction.begin()
        CATransaction.setValue(1.0, forKey: kCATransactionAnimationDuration)
        let camera = GMSCameraPosition.camera(withLatitude:pickUpLat ?? 0.0, longitude: pickUpLong ?? 0.0, zoom: self.cameraZoom)
        self.mapView.animate(to: camera)
        CATransaction.commit()
    }
    
    func getAddressForLatLng(latitude: String, longitude: String) {
        let url = NSURL(string: "\(baseUrlForGetAddress)latlng=\(latitude),\(longitude)&key=\(googlApiKey)")
        let data = NSData(contentsOf: url! as URL)
        do {
            let json = try JSONSerialization.jsonObject(with: (data as Data?) ?? Data(), options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
            if let result = json?["results"] as? [[String:AnyObject]] {
                if let address = result.first?["formatted_address"] as? String {
                    print(address)
                    self.address = address
                    self.lblAddress.text = address
                }
            }
        } catch {
            print("json error: \(error.localizedDescription)")
        }
    }
    
    //self.delegate?.selectedDuration(id: self.strSelectedDuration)
    @IBAction func btnConfirmAction(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.delegate?.LocationPicjked(lat: self.pickUpLat ?? 0.0, lng: self.pickUpLong ?? 0.0, Address: self.address ?? "")
        })
    }
}

//MARK: - GMSMapViewDelegate Methods
extension PickFromMapVC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        
        self.pickUpLat = cameraPosition.target.latitude
        self.pickUpLong = cameraPosition.target.longitude
        self.getAddressForLatLng(latitude: "\(self.pickUpLat ?? 0.0)", longitude: "\(self.pickUpLong ?? 0.0)")
        
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if (gesture){
            //            if(mapView == mapPickUpLoc){
            //                isPickUpMapMoved = true
            //            } else {
            //                isPickUpMapMoved = false
            //            }
        }
    }
}
