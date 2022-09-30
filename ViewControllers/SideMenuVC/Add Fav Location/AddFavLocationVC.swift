//
//  AddFavLocationVC.swift
//  Book A Ride
//
//  Created by Tej P on 20/07/22.
//  Copyright © 2022 Excellent Webworld. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift
import GoogleMaps
import CoreLocation
import GooglePlaces

class AddFavLocationVC: BaseViewController {
    
    @IBOutlet weak var txtLocationName: ACFloatingTextfield!
    @IBOutlet weak var txtAddress: ACFloatingTextfield!
    @IBOutlet weak var btnSubmit: ThemeButton!
    var isFromHome: Bool = false
    var destinationLocation: String = ""
    var address: String = ""
    var lat: String = ""
    var lng: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtAddress.delegate = self
        self.txtAddress.text = self.destinationLocation
        if(isFromHome){
            self.getLatLongFromAddress(address: self.destinationLocation)
        }
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.setLocalization()
    }
    
    func setLocalization(){
        self.txtLocationName.placeholder = "Location Name (Ex: Home, Office)".localized
        self.txtAddress.placeholder = "Address".localized
        self.btnSubmit.setTitle("Submit".localized, for: .normal)
    }

    @IBAction func btnSubmitAction(_ sender: Any) {
        if(self.txtAddress.text?.replacingOccurrences(of: " ", with: "") != "" && self.txtLocationName.text?.replacingOccurrences(of: " ", with: "") != ""){
            self.webserviceOfAddAddressToFavourite(lat: self.lat, lng: self.lng)
        }else{
            UtilityClass.setCustomAlert(title: "Missing".localized, message: "Add all fields".localized) { (index, title) in}
        }
    }
    
    func openPlacePicker() {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        let filter = GMSAutocompleteFilter()
//        filter.country = "GY"
        acController.autocompleteFilter = filter
        present(acController, animated: true, completion: nil)
    }
    
    func getLatLongFromAddress(address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            placemarks, error in
            let placemark = placemarks?.first
            self.lat = "\(placemark?.location?.coordinate.latitude ?? 0.0)"
            self.lng = "\(placemark?.location?.coordinate.longitude ?? 0.0)"
        }
    }

}

extension AddFavLocationVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.openPlacePicker()
    }
    
}

extension AddFavLocationVC {
    func webserviceOfAddAddressToFavourite(lat: String, lng: String) {
     
        var param = [String:AnyObject]()
        param["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
        param["Type"] = txtLocationName.text as AnyObject
        param["Address"] = txtAddress.text as AnyObject
        param["Lat"] = lat as AnyObject
        param["Lng"] = lng as AnyObject
        
        webserviceForAddAddress(param as AnyObject) { (result, status) in
            if (status) {
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "Error", message: res) { (index, title) in }
                }
                else if let res = result as? NSDictionary {
                    let alert = UIAlertController(title: nil, message: res.object(forKey:  GetResponseMessageKey()) as? String, preferredStyle: .alert)
                    let OK = UIAlertAction(title: "OK".localized, style: .default, handler: { ACTION in
                        if(!self.isFromHome){
                            NotificationCenter.default.post(name: ReloadFavLocations, object: nil)
                        }
                        self.navigationController?.popViewController(animated: true)
                    })
                    alert.addAction(OK)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else {
                UtilityClass.setCustomAlert(title: "Error", message: "Something went wrong") { (index, title) in }
            }
        }
    }
}

extension AddFavLocationVC: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.address = place.formattedAddress ?? "-"
        self.lat = "\(place.coordinate.latitude)"
        self.lng = "\(place.coordinate.longitude)"
        self.txtAddress.text = self.address
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
