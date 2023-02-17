//
//  ConfirmLocationVC.swift
//  Book A Ride
//
//  Created by Yagnik on 20/12/22.
//  Copyright © 2022 Excellent Webworld. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces
import GoogleMaps
import CoreLocation

class ConfirmLocationVC: BaseViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var lblPickUpLoc: UILabel!
    @IBOutlet weak var txtPickUpLoc: UITextField!
    @IBOutlet weak var lblDropOffLoc: UILabel!
    @IBOutlet weak var txtDropOffLoc: UITextField!
    @IBOutlet weak var txtPickUpDate: UITextField!
    @IBOutlet weak var btnBookNow: UIButton!
    @IBOutlet weak var btnBookLater: UIButton!
    @IBOutlet weak var stackPickUpDate: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imgCardForPaymentType: UIImageView!
    @IBOutlet weak var imgCashForPaymentType: UIImageView!
    @IBOutlet weak var PayCashView: UIView!
    @IBOutlet weak var PayCardView: UIView!
    @IBOutlet weak var btnCard: UIButton!
    @IBOutlet weak var btnCash: UIButton!
    @IBOutlet weak var btnMapPick: UIButton!
    @IBOutlet weak var btnMapDrop: UIButton!
    
    @IBOutlet weak var lblPackage: UILabel!
    @IBOutlet weak var lblModel: UILabel!
    
    var modelId: Int?
    var modelName:String = ""
    var durationId: Int?
    var durationName:String = ""
    
    var pickUpLat: Double?
    var pickUpLong: Double?
    var dropOffLat: Double?
    var dropOffLong: Double?
    
    var isPickUpSelected : Bool?
    var isPickUpMapMoved : Bool?
    var cameraZoom: Float = 17.0
    let baseUrlForGetAddress = "https://maps.googleapis.com/maps/api/geocode/json?"
    
    var datePicker:UIDatePicker = UIDatePicker()
    var toolBar = UIToolbar()
    var paymentType = ""
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setPickUpLocation()
        self.btnMapPick.underline(text: "Find on Map")
        self.btnMapDrop.underline(text: "Find on Map")
        self.stackPickUpDate.isHidden = true
        self.lblModel.text = self.modelName
        self.lblPackage.text = self.durationName
        self.setNavBarWithBack(Title: "Confirm Location".localized, IsNeedRightButton: true)
    }
    
    //MARK: - Custom Methods
    func openPlacePiicker() {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        let filter = GMSAutocompleteFilter()
       // filter.country = "GY"
        acController.autocompleteFilter = filter
        present(acController, animated: true, completion: nil)
    }
    
    func setPickUpLocation() {
        self.txtPickUpLoc.text = self.getAddressForLatLng(latitude: "\(SingletonClass.sharedInstance.latitude ?? 0.0)", longitude: "\(SingletonClass.sharedInstance.longitude ?? 0.0)")
        self.pickUpLat = SingletonClass.sharedInstance.latitude ?? 0.0
        self.pickUpLong = SingletonClass.sharedInstance.longitude ?? 0.0
    }
    
    func getAddressForLatLng(latitude: String, longitude: String) -> String {
        let url = NSURL(string: "\(baseUrlForGetAddress)latlng=\(latitude),\(longitude)&key=\(googlApiKey)")
        let data = NSData(contentsOf: url! as URL)
        do {
            let json = try JSONSerialization.jsonObject(with: (data as Data?) ?? Data(), options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
            if let result = json?["results"] as? [[String:AnyObject]] {
                if let address = result.first?["formatted_address"] as? String {
                    return address
                }
            }
        } catch {
            print("json error: \(error.localizedDescription)")
        }
        return ""
    }
    
    func setupDatePicker() {
        datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
        datePicker.addTarget(self, action: #selector(self.dateChanged), for: .allEvents)
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        }
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.minimumDate = Date()
        txtPickUpDate.inputView = datePicker
        let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(self.datePickerDone))
        toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: true)
        txtPickUpDate.inputAccessoryView = toolBar
    }
    
    @objc func datePickerDone() {
        txtPickUpDate.resignFirstResponder()
        if(txtPickUpDate.text == ""){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                UtilityClass.setCustomAlert(title: "Missing".localized, message: "Please select pickup date and time!".localized) { (index, title) in
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.confirmBookLater()
            }
        }
    }
    
    @objc func dateChanged() {
        let dateFormaterView = DateFormatter()
        dateFormaterView.dateFormat = "yyyy-MM-dd HH:mm:ss"
        txtPickUpDate.text = dateFormaterView.string(from: datePicker.date)
    }
    
    func gotoFinalScreen(pickTime: String) {
        let viewController = bookingsStoryboard.instantiateViewController(withIdentifier: "SubmitRentalReqVC") as? SubmitRentalReqVC
        viewController?.modelId = modelId
        viewController?.modelName = modelName
        viewController?.durationId = durationId
        viewController?.durationName = durationName
        
        viewController?.pickUpLocation = self.txtPickUpLoc.text ?? ""
        viewController?.pickUpLat = pickUpLat
        viewController?.pickUpLong = pickUpLong
        
        viewController?.dropOffLocation = self.txtDropOffLoc.text ?? ""
        viewController?.dropOffLat = dropOffLat
        viewController?.dropOffLong = dropOffLong
        
        viewController?.paymentType = self.paymentType
        viewController?.pickUpDateTime = pickTime
        
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    func confirmBookLater() {
        if paymentType == "" {
            UtilityClass.setCustomAlert(title: "Missing".localized, message: "Please select payment method.".localized) { (index, title) in
            }
        } else {
            gotoFinalScreen(pickTime: self.txtPickUpDate.text ?? "")
        }
    }
    
    @IBAction func selectPaymentMethod(_ sender: UIButton)
    {
        self.imgCashForPaymentType.image = UIImage(named: "icon_CashUnselected")
        self.imgCardForPaymentType.image = UIImage(named: "icon_UnselectedCard")
        self.PayCashView.backgroundColor = UIColor.init(hex: "E5E5E5")
        self.PayCardView.backgroundColor = UIColor.init(hex: "E5E5E5")
        self.btnCash.setTitleColor(UIColor.black, for: .normal)
        self.btnCard.setTitleColor(UIColor.black, for: .normal)
        
        //cardID = ""
        imgCashForPaymentType.isHighlighted = false
        imgCardForPaymentType.isHighlighted = false
        if(sender.tag == 1)
        {
            self.btnCash.setTitleColor(themeYellowColor, for: .normal)
            self.imgCashForPaymentType.image = UIImage(named: "icon_SelectedCash")
            self.imgCashForPaymentType.tintColor = .red
            self.PayCashView.backgroundColor = UIColor.black
            self.paymentType = "cash"
            btnCash.setTitleColor(themeAppMainColor, for: .normal)
            btnCard.setTitle("Card", for: .normal)
            
        } else if(sender.tag == 2) {
            self.paymentType = "wallet"
            
        } else if(sender.tag == 3) {
            self.imgCardForPaymentType.image = UIImage(named: "icon_SelectedCard")
            self.btnCard.setTitleColor(themeYellowColor, for: .normal)
            self.paymentType = "card"
            self.imgCardForPaymentType.tintColor = .red
            self.PayCardView.backgroundColor = UIColor.black
            btnCard.setTitleColor(themeAppMainColor, for: .normal)
            
        }
    }
    
    @IBAction func btnBookNowActiion(_ sender: Any) {
        stackPickUpDate.isHidden = true
        if self.txtPickUpLoc.text == ""{
            UtilityClass.setCustomAlert(title: "Missing".localized, message: "Please enter your pickup location again".localized) { (index, title) in
            }
        } else if self.txtDropOffLoc.text == ""{
            UtilityClass.setCustomAlert(title: "Missing".localized, message: "Please enter your destination again".localized) { (index, title) in
            }
        }else if paymentType == "" {
            UtilityClass.setCustomAlert(title: "Missing".localized, message: "Please select payment method.".localized) { (index, title) in
            }
        } else {
            gotoFinalScreen(pickTime: "")
        }
    }
    
    func openMap(lat: Double, Lng: Double, address: String) {
        let vc = bookingsStoryboard.instantiateViewController(withIdentifier: "PickFromMapVC") as! PickFromMapVC
        vc.delegate = self
        vc.pickUpLat = lat
        vc.pickUpLong = Lng
        vc.modalPresentationStyle = .overCurrentContext
        let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.coverVertical
        vc.modalTransitionStyle = modalStyle
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnBookLaterAction(_ sender: Any) {
        if self.txtPickUpLoc.text == ""{
            UtilityClass.setCustomAlert(title: "Missing".localized, message: "Please enter your pickup location again".localized) { (index, title) in
            }
        } else if self.txtDropOffLoc.text == ""{
            UtilityClass.setCustomAlert(title: "Missing".localized, message: "Please enter your destination again".localized) { (index, title) in
            }
        }else if paymentType == "" {
            UtilityClass.setCustomAlert(title: "Missing".localized, message: "Please select payment method.".localized) { (index, title) in
            }
        } else {
            stackPickUpDate.isHidden = !stackPickUpDate.isHidden
            self.setupDatePicker()
        }
    }
    
    @IBAction func btnMapPickAction(_ sender: Any) {
        self.isPickUpMapMoved = true
        self.openMap(lat: pickUpLat ?? 0.0, Lng: pickUpLong ?? 0.0, address: self.txtPickUpLoc.text ?? "")
    }
    
    @IBAction func btnMapDropAction(_ sender: Any) {
        self.isPickUpMapMoved = false
        self.openMap(lat: dropOffLat ?? 0.0, Lng: dropOffLong ?? 0.0, address: self.txtDropOffLoc.text ?? "")
    }
}

//MARK: - GMSAutocompleteViewControllerDelegate Methods
extension ConfirmLocationVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if(isPickUpSelected != nil && isPickUpSelected == true){
            
            let Location = place.formattedAddress ?? "-"
            self.txtPickUpLoc.text = Location
            self.pickUpLat = place.coordinate.latitude
            self.pickUpLong = place.coordinate.longitude
            
        }else{
            
            let Location = place.formattedAddress ?? "-"
            self.txtDropOffLoc.text = Location
            self.dropOffLat = place.coordinate.latitude
            self.dropOffLong = place.coordinate.longitude
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        dismiss(animated: true, completion: nil)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - UITextFieldDelegate Methods
extension ConfirmLocationVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtPickUpLoc {
            isPickUpSelected = true
            self.openPlacePiicker()
        }else if textField == txtDropOffLoc {
            isPickUpSelected = false
            self.openPlacePiicker()
        }
    }
}

extension ConfirmLocationVC: LocationProtocol {
    func LocationPicjked(lat: Double, lng: Double, Address: String) {
        if(self.isPickUpMapMoved ?? false){
            self.txtPickUpLoc.text = Address
            self.pickUpLat = lat
            self.pickUpLong = lng
        } else {
            self.txtDropOffLoc.text = Address
            self.dropOffLat = lat
            self.dropOffLong = lng
        }
    }
}
