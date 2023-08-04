//
//  BookLaterViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 04/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import M13Checkbox
import GoogleMaps
import GooglePlaces
import SDWebImage
import FormTextField
import ACFloatingTextfield_Swift
import IQKeyboardManagerSwift
import SocketIO
import NVActivityIndicatorView

protocol isHaveCardFromBookLaterDelegate {
    func didHaveCards()
}

protocol BookLaterSubmitedDelegate {
    func BookLaterComplete()
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}


class BookLaterViewController: BaseViewController, GMSAutocompleteViewControllerDelegate, UINavigationControllerDelegate, WWCalendarTimeSelectorProtocol, UIPickerViewDelegate, UIPickerViewDataSource, isHaveCardFromBookLaterDelegate, UITextFieldDelegate,SelectCardDelegate, SelectCardForBookingDelegate {
    
    let socket = (UIApplication.shared.delegate as! AppDelegate).socket
    var BookLaterCompleted:BookLaterSubmitedDelegate!
    var datePickerView = UIDatePicker()
    var dictSelectedDriver: [String: AnyObject]?
    var pickerViewForInvoiceType = UIPickerView()
    var strModelId = String()
    var BoolCurrentLocation = Bool()
    var BoolDropLocation : Bool = false
    var BoolAdditionalDropLocation : Bool = false
    var isCalenderFordateTime = Bool()
    var strCarModelURL = String()
    var strPassengerType = String()
    var convertDateToString = String()
    var boolIsSelected = Bool()
    var boolIsSelectedNotes = Bool()
    var strAppliedPromocode = String()
    var strCarName = String()
    var ReceiptType = String()
    var strFullname = String()
    var strMobileNumber = String()
    var PasangerDefinedLimit:Int = 0
    var arrNumberOfPassengerList:[String] = []
    var arrPromocodes:[[String:Any]] = []
    var arrPromocodeList:[String] = []
    var priceType = ""
    var BackView = UIView()
    var isAddCardSelected = Bool()
    var msgPriceModel = ""
    
    var placesClient = GMSPlacesClient()
    var locationManager = CLLocationManager()
    var aryOfPaymentOptionsNames = [String]()
    var aryOfPaymentOptionsImages = [String]()
    var CardID = String()
    var paymentType = String()
    var intNumberOfPassengerOnShareRiding:Int = 1
    var DateTimeselector = WWCalendarTimeSelector.instantiate()
    var TimeSelector = WWCalendarTimeSelector.instantiate()
    var NearByRegion:GMSCoordinateBounds!
    var isOpenPlacePickerController:Bool = false
    var strSelectedCarTotalFare = ""
    var validationsMobileNumber = Validation()
    var inputValidatorMobileNumber = InputValidator()
    var priceModel = ""
    
    var strPickupLocation = String()
    var strDropoffLocation = String()
    var doublePickupLat = Double()
    var doublePickupLng = Double()
    var doubleDropOffLat = Double()
    var doubleDropOffLng = Double()
    var doubleDropOffLat2 = Double()
    var doubleDropOffLng2 = Double()
    var strSecondDropoffLocation = ""
    var isMultiDropReq: Bool = false
    var intShareRide:Int = 0
    var currentDate = Date()
    var aryCards = [[String:AnyObject]]()
    var selectDate = Date()
    
    @IBOutlet weak var TitlePickupLoc: UILabel!
    @IBOutlet weak var TitleDropOffLoc: UILabel!
    @IBOutlet weak var TitleAdditionalDropOffLoc: UILabel!
    
    @IBOutlet weak var viewNotes: UIView!
    @IBOutlet weak var imgCardForPaymentType: UIImageView!
    @IBOutlet weak var imgCashForPaymentType: UIImageView!
    @IBOutlet weak var txtEstimatedFare: UITextField!
    @IBOutlet weak var btnCancelPromocode: UIButton!
    @IBOutlet weak var btnApplyPromocode: UIButton!
    @IBOutlet weak var btnPromoCancel: UIButton!
    @IBOutlet weak var lblPleaceCompleteBooking: UILabel!
    @IBOutlet weak var lblEstimatedFare: UILabel!
    @IBOutlet weak var lblSelectPaymentMethod: UILabel!
    @IBOutlet weak var PayCashView: UIView!
    @IBOutlet weak var btnCash: UIButton!
    @IBOutlet weak var PayCardView: UIView!
    @IBOutlet weak var btnCardSelection: UIButton!
    @IBOutlet weak var viewProocode: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblTitleApplyPromoCode: UILabel!
    @IBOutlet weak var viewFlightNumber: M13Checkbox!
    @IBOutlet weak var viewDestinationLocation: UIView!
    @IBOutlet weak var viewCurrentLocation: UIView!
    @IBOutlet weak var viewSecondDestinationLocation: UIView!
    @IBOutlet weak var lblCareModelClass: UILabel!
    @IBOutlet weak var imgCareModel: UIImageView!
    @IBOutlet weak var txtPickupLocation: UITextField!
    @IBOutlet weak var txtDropOffLocation: UITextField!
    @IBOutlet weak var txtScondDropOffLocation: UITextField!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtMobileNumber: FormTextField!
    @IBOutlet weak var txtDataAndTimeFromCalendar: UITextField!
    @IBOutlet weak var btnCalendar: UIButton!
    @IBOutlet weak var txtFlightNumber: UITextField!
    @IBOutlet weak var View_FlightNumber: UIView!
    @IBOutlet weak var txtFlightArrivalTime: UITextField!
    @IBOutlet weak var btnNotes: M13Checkbox!
    @IBOutlet weak var txtPromoCode: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet var alertView: UIView!
    @IBOutlet weak var viewPaymentMethod: UIView!
    @IBOutlet weak var lblPromoCode: UILabel!
    @IBOutlet weak var ViewArrivalTime: UIView!
    @IBOutlet weak var ViewFlightArrivalTime: UIView!
    @IBOutlet weak var CheckArrivalTime: M13Checkbox!
    @IBOutlet weak var btnSelectPromocode: UIButton!
    @IBOutlet weak var btnTimeCalender: UIButton!
    
    @IBOutlet weak var vWMobileNumber: UIView!
    @IBOutlet weak var vwFullName: UIView!
    @IBOutlet weak var btnBookForSomeone: UIButton!
    @IBOutlet weak var lblblookForSomeone: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PayCardView.isHidden = false
        
        vwFullName.isHidden = true
        vWMobileNumber.isHidden = true
        
        self.viewSecondDestinationLocation.isHidden = (isMultiDropReq) ? false : true
        
        //        self.title = "Schedule Trip"
        self.setNavBarWithBack(Title: "Book Later".localized, IsNeedRightButton: false)
        
        self.navigationItem.title = "Book Later".localized
        
        //        self.lblWalletTitle.numberOfLines = 0
        let imageViewForCalendar = self.btnCalendar.imageView
        imageViewForCalendar?.setImageColor(color: themeAppMainColor)
        self.btnCalendar.setImage(imageViewForCalendar?.image, for: .normal)
        self.btnTimeCalender.setImage(imageViewForCalendar?.image, for: .normal)
        btnSelectPromocode.setTitleColor(themeAppMainColor, for: .normal)
        
        txtDropOffLocation.delegate = self
        txtPickupLocation.delegate = self
        txtScondDropOffLocation.delegate = self
        
        self.btnSelectPromocode.setTitle("Select Promocode", for: .normal)
        
        
        txtDropOffLocation.text = strDropoffLocation
        DateTimeselector.delegate = self
        TimeSelector.delegate = self
        viewProocode.isHidden = true
        webserviceOfCardList(setCardInButton: false)
        aryOfPaymentOptionsNames = [""]
        aryOfPaymentOptionsImages = [""]
        
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        setViewDidLoad()
        //        txtDataAndTimeFromCalendar.isUserInteractionEnabled = false
        
        imgCareModel.sd_setImage(with: URL(string: strCarModelURL), completed: nil)
        lblCareModelClass.text = "\("Vehicle Type".localized): \(strCarName)"
        
        //        lblPassenger.text = "(maximum \(self.PasangerDefinedLimit) passengers)"
        if strCarName == "VAN" {
            self.arrNumberOfPassengerList = ["5","6","7","8","9","10"]
        } else {
            self.arrNumberOfPassengerList = ["1","2","3","4"]
        }
        
        //        self.btnNumberOfPassenger.setTitle(self.arrNumberOfPassengerList[0], for: .normal)
        
//        txtFullName.text = strFullname
//        txtMobileNumber.text = strMobileNumber
        
        checkMobileNumber()
        
        
        datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.dateAndTime
        
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: 0, to: Date())
        datePickerView.minimumDate = date
        
        txtDataAndTimeFromCalendar.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.pickupdateMethod(_:)), for: UIControl.Event.valueChanged)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onClickDoneButton))
        toolBar.setItems([space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        txtDataAndTimeFromCalendar.inputAccessoryView = toolBar
        
        
        let mySelectedAttributedTitle = NSAttributedString(string: "Have a Promocode?",
                                                           attributes: [NSAttributedString.Key.foregroundColor : themeAppMainColor,NSAttributedString.Key.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        self.btnSelectPromocode.setAttributedTitle(mySelectedAttributedTitle, for: .normal)
        self.btnSelectPromocode.setTitle("\("Promocode Applied".localized) \(self.txtPromoCode.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")", for: .normal)
        self.btnApplyPromocode.backgroundColor = themeYellowColor
        self.btnApplyPromocode.setTitleColor(.black, for: .normal)
        self.txtMobileNumber.leftMargin = 0
        
        self.lblEstimatedFare.textColor = themeRedColor
    }
    
    @objc func onClickDoneButton() {
        self.view.endEditing(true)
        
        let dateFormaterView1 = DateFormatter()
        dateFormaterView1.dateFormat = "yyyy-MM-dd HH:mm"
        let date = dateFormaterView1.string(from: self.selectDate)
        self.webserviceForEstimateFare(date: date)
    }
    
    @objc func pickupdateMethod(_ sender: UIDatePicker)
    {
        self.selectDate = sender.date
        let dateFormaterView = DateFormatter()
        dateFormaterView.dateFormat = "MM-dd-yyyy hh:mm a"
        txtDataAndTimeFromCalendar.text = dateFormaterView.string(from: sender.date)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isOpenPlacePickerController == false {
            fillTextFields()
        }
        self.setLocalization()
        self.isOpenPlacePickerController = false
    }

    func setLocalization(){
        txtFullName.placeholder = "Full Name".localized
        txtMobileNumber.placeholder = "Mobile Number".localized
        txtPickupLocation.placeholder = "Pickup Location".localized
        txtDropOffLocation.placeholder = "Dropoff Location".localized
        txtScondDropOffLocation.placeholder = "Second Dropoff Location".localized
        txtDataAndTimeFromCalendar.placeholder = "Pickup Time".localized
        lblEstimatedFare.text = "Estimated Fare".localized
        lblSelectPaymentMethod.text = "Select Payment Method".localized
        btnCardSelection.setTitle("Card".localized, for: .normal)
        btnCash.setTitle("Cash".localized, for: .normal)
        btnSubmit.setTitle("Submit".localized, for: .normal)
        self.btnSelectPromocode.underline(text: "Have a promocode?".localized)
        lblPleaceCompleteBooking.text = "Please complete booking details.".localized
        lblTitleApplyPromoCode.text = "Apply Promocode".localized
        txtPromoCode.placeholder = "Enter Promocode".localized
        btnApplyPromocode.setTitle("Apply".localized, for: .normal)
        btnPromoCancel.setTitle("Cancel".localized, for: .normal)
        
        TitlePickupLoc.text = "Pickup Location".localized
        TitleDropOffLoc.text = "Dropoff Location".localized
        TitleAdditionalDropOffLoc.text = "Second Dropoff Location".localized
        lblblookForSomeone.text = "Booking for someone else".localized
    }
    
    func fillTextFields() {
        txtPickupLocation.text = strPickupLocation
        txtDropOffLocation.text = strDropoffLocation
        txtScondDropOffLocation.text = strSecondDropoffLocation
    }
    
    func gaveCornerRadius() {
        
        viewCurrentLocation.layer.cornerRadius = 5
        viewDestinationLocation.layer.cornerRadius = 5
        
        viewCurrentLocation.layer.borderWidth = 1
        viewDestinationLocation.layer.borderWidth = 1
        
        viewDestinationLocation.layer.borderColor = UIColor.black.cgColor
        viewDestinationLocation.layer.borderColor = UIColor.black.cgColor
        
        viewCurrentLocation.layer.masksToBounds = true
        viewDestinationLocation.layer.masksToBounds = true
        
    }
    
    func setViewDidLoad() {
        viewFlightNumber.tintColor = themeAppMainColor
        CheckArrivalTime.tintColor = themeAppMainColor
        btnNotes.tintColor = themeAppMainColor
        viewFlightNumber.stateChangeAnimation = .fill
        CheckArrivalTime.stateChangeAnimation = .fill
        btnNotes.stateChangeAnimation = .fill
        btnNotes.boxType = .square
        strPassengerType = "myself"
        viewFlightNumber.boxType = .square
        CheckArrivalTime.boxType = .square
        View_FlightNumber.isHidden = true
        txtFlightNumber.text = ""
        ViewArrivalTime.isHidden = true
        ViewFlightArrivalTime.isHidden = true
        txtFlightNumber.isEnabled = false
        txtDescription.isEnabled = false
        alertView.layer.cornerRadius = 10
        alertView.layer.masksToBounds = true
        txtFlightArrivalTime.layer.borderWidth = 1
        txtFlightArrivalTime.layer.cornerRadius = 5
        txtFlightArrivalTime.layer.borderColor = UIColor.black.cgColor
        txtFlightArrivalTime.layer.masksToBounds = true
        btnSubmit.layer.cornerRadius = 10
        btnSubmit.layer.masksToBounds = true
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    @IBAction func btnSelectPromocode(_ sender: Any) {
        viewProocode.isHidden = false
    }
    
    @IBAction func btnApply(_ sender: UIButton) {
        if self.txtPromoCode.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            self.webServiceOfCheckPromoCode()
        }
        else {
            UtilityClass.showAlert("", message: "Please enter promocode!", vc: self)
        }
        viewProocode.isHidden = true
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        viewProocode.isHidden = true
        txtPromoCode.text = ""
    }
    
    @IBAction func btnHavePromoCode(_ sender: UIButton) {
        txtPromoCode.becomeFirstResponder()
        viewProocode.isHidden = false
    }
    
    @IBAction func btnNotes(_ sender: M13Checkbox) {
        boolIsSelectedNotes = !boolIsSelectedNotes
        if (boolIsSelectedNotes) {
            viewNotes.isHidden = false
            txtDescription.isEnabled = true
        }
        else {
            viewNotes.isHidden = true
            txtDescription.isEnabled = false
        }
    }
    
    @IBAction func btnBookForSomeoneAction(_ sender: Any) {
        if btnBookForSomeone.isSelected {
            btnBookForSomeone.isSelected = false
            vwFullName.isHidden = true
            vWMobileNumber.isHidden = true
        } else {
            btnBookForSomeone.isSelected = true
            vwFullName.isHidden = false
            vWMobileNumber.isHidden = false
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if(textField == txtDataAndTimeFromCalendar)
        {
            let dateFormaterView = DateFormatter()
            dateFormaterView.dateFormat = "MM-dd-yyyy hh:mm a"
            txtDataAndTimeFromCalendar.text = dateFormaterView.string(from: datePickerView.date)
            
            convertDateToString =  UtilityClass.formattedDateFromString(dateString: txtDataAndTimeFromCalendar.text ?? "", fromFormat: "MM-dd-yyyy hh:mm a", withFormat: "yyyy-MM-dd HH:mm:ss") ?? ""
            
        }
    }
    
    @objc func ActionForViewMySelf() {
        txtFullName.text = strFullname
        txtMobileNumber.text = strMobileNumber
        strPassengerType = "myself"
    }
    
    @objc func ActionForViewOther() {
        txtFullName.text = ""
        txtMobileNumber.text = ""
        strPassengerType = "other"
    }
    
    @IBAction func viewFlightNumber(_ sender: M13Checkbox) {
        
        boolIsSelected = !boolIsSelected
        
        if (boolIsSelected) {
            self.View_FlightNumber.isHidden = false
            self.ViewArrivalTime.isHidden = false
            txtFlightNumber.isEnabled = true
        }
        else {
            self.View_FlightNumber.isHidden = true
            self.txtFlightNumber.text = ""
            self.ViewArrivalTime.isHidden = true
            if self.ViewFlightArrivalTime.isHidden == false {
                self.ViewFlightArrivalTime.isHidden = true
                self.CheckArrivalTime.checkState = .unchecked
                self.CheckArrivalTime.stateChangeAnimation = .fill
            }
            txtFlightNumber.isEnabled = false
        }
    }
    
    @IBAction func ViewArrivalTimeAction(_ sender: M13Checkbox) {
        
        self.ViewFlightArrivalTime.isHidden = !self.ViewFlightArrivalTime.isHidden
    }
    
    
    @IBAction func txtPickupLocation(_ sender: UITextField) {
        self.isOpenPlacePickerController = true
        BoolCurrentLocation = true
        BoolDropLocation = false
        BoolAdditionalDropLocation = false
        
        self.openAddressPicker()
        
//        let acController = GMSAutocompleteViewController()
//        acController.delegate = self
//
//
//        let filter = GMSAutocompleteFilter()
//        filter.countries = ["GY"]
//        acController.autocompleteFilter = filter
//        present(acController, animated: true, completion: nil)
        
    }
    
    @IBAction func txtDropOffLocation(_ sender: UITextField) {
        self.isOpenPlacePickerController = true
        BoolCurrentLocation = false
        BoolDropLocation = true
        BoolAdditionalDropLocation = false
        
        self.openAddressPicker()
        
//        let acController = GMSAutocompleteViewController()
//        acController.delegate = self
//
//        let filter = GMSAutocompleteFilter()
//        filter.countries = ["GY"]
//        acController.autocompleteFilter = filter
//        present(acController, animated: true, completion: nil)
        
    }
    
    @IBAction func txtSecondDropOffLocation(_ sender: UITextField) {
        self.isOpenPlacePickerController = true
        BoolCurrentLocation = false
        BoolDropLocation = false
        BoolAdditionalDropLocation = true
        
        self.openAddressPicker()
        
//        let acController = GMSAutocompleteViewController()
//        acController.delegate = self
//       
//        
//        let filter = GMSAutocompleteFilter()
//        filter.countries = ["GY"]
//        acController.autocompleteFilter = filter
//        present(acController, animated: true, completion: nil)
    }
    
    func openAddressPicker() {
        let addressPicker = AddressPickerVC { [weak self] location in
            if self?.BoolCurrentLocation ?? false {
                self?.txtPickupLocation.text = location.address
                self?.strPickupLocation = location.address
                self?.doublePickupLat = location.coordinate.latitude
                self?.doublePickupLng = location.coordinate.longitude
                
            } else if self?.BoolDropLocation ?? false {
                self?.txtDropOffLocation.text = location.address
                self?.strDropoffLocation = location.address
                self?.doubleDropOffLat = location.coordinate.latitude
                self?.doubleDropOffLng = location.coordinate.longitude
            } else {
                self?.txtScondDropOffLocation.text = location.address
                self?.strSecondDropoffLocation = location.address
                self?.doubleDropOffLat2 = location.coordinate.latitude
                self?.doubleDropOffLat2 = location.coordinate.longitude
            }
            
            self?.lblEstimatedFare.text = "Estimated Fare".localized
            self?.lblEstimatedFare.textColor = UIColor.black
            self?.txtDataAndTimeFromCalendar.text = ""
            self?.txtEstimatedFare.text = ""
        }
        
        present(addressPicker.bindToSystemNavigation(), animated: true, completion: nil)
    }
    
    @IBAction func btnCalendar(_ sender: UIButton) {
        self.isCalenderFordateTime = true
        
        DateTimeselector.optionCalendarFontColorPastDates = UIColor.gray
        DateTimeselector.optionButtonFontColorDone = themeAppMainColor
        DateTimeselector.optionSelectorPanelBackgroundColor = themeAppMainColor
        DateTimeselector.optionCalendarBackgroundColorTodayHighlight = themeAppMainColor
        DateTimeselector.optionTopPanelBackgroundColor = themeAppMainColor
        DateTimeselector.optionClockBackgroundColorMinuteHighlightNeedle = themeAppMainColor
        DateTimeselector.optionClockBackgroundColorHourHighlight = themeAppMainColor
        DateTimeselector.optionClockBackgroundColorAMPMHighlight = themeAppMainColor
        DateTimeselector.optionCalendarBackgroundColorPastDatesHighlight = themeAppMainColor
        DateTimeselector.optionCalendarBackgroundColorFutureDatesHighlight = themeAppMainColor
        DateTimeselector.optionClockBackgroundColorMinuteHighlight = themeAppMainColor
        DateTimeselector.optionStyles.showYear(false)
        DateTimeselector.optionStyles.showTime(true)
        DateTimeselector.optionTopPanelTitle = "Please choose date".localized
        DateTimeselector.optionIdentifier = "Time" as AnyObject
        let dateCurrent = Date()
        DateTimeselector.optionCurrentDate = dateCurrent.addingTimeInterval(30 * 60)
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(DateTimeselector, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func btnTimeCalendar(_ sender: Any) {
        if self.txtDataAndTimeFromCalendar.text?.count == 19 {
            self.isCalenderFordateTime = false
            TimeSelector.optionCalendarFontColorPastDates = UIColor.gray
            TimeSelector.optionButtonFontColorDone = themeAppMainColor
            TimeSelector.optionSelectorPanelBackgroundColor = themeAppMainColor
            TimeSelector.optionCalendarBackgroundColorTodayHighlight = themeAppMainColor
            TimeSelector.optionTopPanelBackgroundColor = themeAppMainColor
            TimeSelector.optionClockBackgroundColorMinuteHighlightNeedle = themeAppMainColor
            TimeSelector.optionClockBackgroundColorHourHighlight = themeAppMainColor
            TimeSelector.optionClockBackgroundColorAMPMHighlight = themeAppMainColor
            TimeSelector.optionCalendarBackgroundColorPastDatesHighlight = themeAppMainColor
            TimeSelector.optionCalendarBackgroundColorFutureDatesHighlight = themeAppMainColor
            TimeSelector.optionClockBackgroundColorMinuteHighlight = themeAppMainColor
            TimeSelector.optionStyles.showYear(false)
            TimeSelector.optionStyles.showMonth(false)
            TimeSelector.optionStyles.showDateMonth(false)
            TimeSelector.optionStyles.showTime(true)
            TimeSelector.optionTopPanelTitle = "Please choose Time"
            TimeSelector.optionIdentifier = "Time" as AnyObject
            let dateCurrent = Date()
            TimeSelector.optionCurrentDate = dateCurrent.addingTimeInterval(30 * 60)
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(TimeSelector, animated: true, completion: nil)
        } else {
            UtilityClass.showAlert("", message: "Please select date first!".localized, vc: self)
        }
    }
    
    //MARK: - Validation Method
    func isValidateRequest() -> (String,Bool) {
        
        var ValidationStatus:Bool = true
        var ValidationMessage:String = ""
        
        if txtFullName.text == "" && btnBookForSomeone.isSelected {
            ValidationStatus = false
            ValidationMessage = "Please enter name!".localized
        } else if txtMobileNumber.text == ""  && btnBookForSomeone.isSelected  {
            ValidationStatus = false
            ValidationMessage = "Please enter contact number!".localized
        } else if self.convertDateToString == "" {
            ValidationStatus = false
            ValidationMessage = "Please select pickup date and time!".localized
        } else if txtPickupLocation.text == "" {
            ValidationStatus = false
            ValidationMessage = "Please select pickup location!".localized
        } else if txtDropOffLocation.text == "" {
            ValidationStatus = false
            ValidationMessage = "Please select drop off location!".localized
        } else if txtScondDropOffLocation.text == "" && isMultiDropReq{
            ValidationStatus = false
            ValidationMessage = "Please select second drop off location".localized
        } else if self.viewFlightNumber.checkState == .checked && self.txtFlightNumber.text == "" {
            ValidationStatus = false
            ValidationMessage = "Please enter flight number!".localized
        } else if self.CheckArrivalTime.checkState == .checked && self.txtFlightArrivalTime.text == "" {
            ValidationStatus = false
            ValidationMessage = "Please select flight arrival time!".localized
        }else if paymentType == "" {
            ValidationStatus = false
            ValidationMessage = "Select Payment Type".localized
        }else if txtDataAndTimeFromCalendar.text == ""{
            ValidationStatus = false
            ValidationMessage = "Please select pickup date and time!".localized
        }
        if self.convertDateToString != ""{
            let status = checkDuration(strPickTime: self.convertDateToString)
            if(!status){
                ValidationStatus = false
                ValidationMessage = "Please select pickUp time one hour later".localized
            }
        }
        return (ValidationMessage,ValidationStatus)
    }
    
    func checkDuration(strPickTime: String) -> Bool {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: 0, to: Date()) ?? Date()
        let dateFormaterView = DateFormatter()
        dateFormaterView.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date1 = dateFormaterView.string(from: date)
        
        let status = self.timeGapBetweenDates(previousDate:date1 , currentDate: strPickTime)
        return status
    }
    
    func timeGapBetweenDates(previousDate : String,currentDate : String) -> Bool {
        let dateString1 = previousDate
        let dateString2 = currentDate
        
        let Dateformatter = DateFormatter()
        Dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
        let date1 = Dateformatter.date(from: dateString1)
        let date2 = Dateformatter.date(from: dateString2)
        
        let distanceBetweenDates: TimeInterval? = date2?.timeIntervalSince(date1!)
        let minsInAnHour: Double = 60
        
        let minBetweenDates = Int((distanceBetweenDates! / minsInAnHour))
        if minBetweenDates >= 120 {
            return true
        }else{
            return false
        }
    }
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        
        let validation = self.isValidateRequest()
        if validation.1 == true {
            self.showConfirmation()
        } else {
            UtilityClass.showAlert("", message: validation.0, vc: self)
        }
    }
    
    func showConfirmation() {
        let myAttribute = [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
        let myAttribute1 = [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : themeRedColor]
        let myString = NSMutableAttributedString(string: "\("Pickup Location".localized) : \n", attributes: myAttribute )
        myString.append(NSAttributedString(string:self.strPickupLocation))
        myString.append(NSAttributedString(string:"\n\n\("Destination Location".localized) : \n",attributes: myAttribute))
        myString.append(NSAttributedString(string:self.strDropoffLocation))
        if(self.strSecondDropoffLocation != ""){
            myString.append(NSAttributedString(string:"\n\n\("Additional Destination Location".localized) : ",attributes: myAttribute))
            myString.append(NSAttributedString(string:self.strSecondDropoffLocation))
        }
        
        if(self.priceModel != ""){
            myString.append(NSAttributedString(string: "\n\n" + self.msgPriceModel.capitalized,attributes: myAttribute1))
        }
        
        myString.append(NSAttributedString(string:"\n\n\("Estimated Fare".localized) : \n",attributes: myAttribute1))
        myString.append(NSAttributedString(string:self.txtEstimatedFare.text ?? ""))

        let alert = UIAlertController(title: appName, message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.setValue(myString, forKey: "attributedMessage")
        
        alert.addAction(UIAlertAction(title: "Decline".localized, style: .default, handler: { (action) in

        }))
        
        alert.addAction(UIAlertAction(title: "Accept".localized, style: .default, handler: { (action) in
            self.btnSubmit.isEnabled = false
            self.webserviceOFBookLater()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkMobileNumber() {
        txtMobileNumber.inputType = .integer
        validationsMobileNumber.maximumLength = 10
        validationsMobileNumber.minimumLength = 10
        validationsMobileNumber.characterSet = NSCharacterSet.decimalDigits
        let inputValidator = InputValidator(validation: validationsMobileNumber)
        txtMobileNumber.inputValidator = inputValidator
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if BoolCurrentLocation {
            txtPickupLocation.text = place.formattedAddress
            strPickupLocation = place.formattedAddress!
            doublePickupLat = place.coordinate.latitude
            doublePickupLng = place.coordinate.longitude
            
        } else if BoolDropLocation {
            txtDropOffLocation.text = place.formattedAddress
            strDropoffLocation = place.formattedAddress!
            doubleDropOffLat = place.coordinate.latitude
            doubleDropOffLng = place.coordinate.longitude
        } else {
            txtScondDropOffLocation.text = place.formattedAddress
            strSecondDropoffLocation = place.formattedAddress!
            doubleDropOffLat2 = place.coordinate.latitude
            doubleDropOffLat2 = place.coordinate.longitude
        }
        
        self.lblEstimatedFare.text = "Estimated Fare".localized
        self.lblEstimatedFare.textColor = UIColor.black
        self.txtDataAndTimeFromCalendar.text = ""
        self.txtEstimatedFare.text = ""
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtDropOffLocation {
            self.txtDropOffLocation(txtDropOffLocation)
            return false
        }else if textField == txtPickupLocation {
            self.txtPickupLocation(txtPickupLocation)
            return false
        }else if textField == txtScondDropOffLocation {
            self.txtSecondDropOffLocation(txtScondDropOffLocation)
            return false
        }
        return true
    }
    
    
    func getPlaceFromLatLong()
    {
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            self.txtPickupLocation.text = ""
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.strPickupLocation = place.formattedAddress!
                    self.doublePickupLat = place.coordinate.latitude
                    self.doublePickupLng = place.coordinate.longitude
                    self.txtPickupLocation.text = place.formattedAddress?.components(separatedBy: ", ")
                        .joined(separator: "\n")
                }
            }
        })
    }
    
    func setCardIcon(str: String) -> String {
        var CardIcon = String()
        
        switch str {
        case "visa":
            CardIcon = "Visa"
            return CardIcon
        case "mastercard":
            CardIcon = "MasterCard"
            return CardIcon
        case "amex":
            CardIcon = "Amex"
            return CardIcon
        case "diners":
            CardIcon = "Diners Club"
            return CardIcon
        case "discover":
            CardIcon = "Discover"
            return CardIcon
        case "jcb":
            CardIcon = "JCB"
            return CardIcon
        case "iconCashBlack":
            CardIcon = "iconCashBlack"
            return CardIcon
        case "iconWalletBlack":
            CardIcon = "iconWalletBlack"
            return CardIcon
        case "iconPlusBlack":
            CardIcon = "iconPlusBlack"
            return CardIcon
        case "other":
            CardIcon = "iconDummyCard"
            return CardIcon
        default:
            return ""
        }
        
    }
    
    func didHaveCards() {
        aryCards.removeAll()
        webserviceOfCardList(setCardInButton: true)
    }
    
    @objc func IQKeyboardmanagerDoneMethod() {
        if (isAddCardSelected) {
            self.addNewCard()
        }
    }
    
    //------------------------------------------------------------
    // MARK: - PickerView Methods
    //-------------------------------------------------------------
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return aryCards.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let data = aryCards[row]
        let myView = UIView(frame: CGRect(x:0, y:0, width: pickerView.bounds.width - 30, height: 60))
        let centerOfmyView = myView.frame.size.height / 4
        let myImageView = UIImageView(frame: CGRect(x:0, y:centerOfmyView, width:40, height:26))
        myImageView.contentMode = .scaleAspectFit
        
        var rowString = String()
        switch row {
        case 0:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 1:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 2:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 3:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 4:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 5:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 6:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 7:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 8:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 9:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 10:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        default:
            rowString = "Error: too many rows"
            myImageView.image = nil
        }
        let myLabel = UILabel(frame: CGRect(x:60, y:0, width:pickerView.bounds.width - 90, height:60 ))
        myLabel.text = rowString
        myView.addSubview(myLabel)
        myView.addSubview(myImageView)
        
        return myView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == self.pickerViewForInvoiceType {
        } else {
            let data = aryCards[row]
            if data["CardNum"] as! String == "Add a Card" {
                isAddCardSelected = true
                return
            }
            
            let type = data["CardNum"] as! String
            if type  == "wallet" {
                paymentType = "wallet"
            }
            else if type == "cash" {
                paymentType = "cash"
            }
            else {
                paymentType = "card"
            }
            if paymentType == "card" {
                if data["Id"] as? String != "" {
                    CardID = data["Id"] as! String
                }
            }
        }
    }
    
    @IBAction func selectPaymentOption(_ sender: UIButton)
    {
        self.imgCashForPaymentType.image = UIImage(named: "icon_CashUnselected")
        self.imgCardForPaymentType.image = UIImage(named: "icon_UnselectedCard")
        self.PayCashView.backgroundColor = UIColor.init(hex: "E5E5E5")
        self.PayCardView.backgroundColor = UIColor.init(hex: "E5E5E5")
        self.btnCash.setTitleColor(UIColor.black, for: .normal)
        self.btnCardSelection.setTitleColor(UIColor.black, for: .normal)
        
        CardID = ""
        imgCashForPaymentType.isHighlighted = false
        imgCardForPaymentType.isHighlighted = false
        if(sender.tag == 1)
        {
            self.btnCash.setTitleColor(themeYellowColor, for: .normal)
            self.imgCashForPaymentType.image = UIImage(named: "icon_SelectedCash")
            self.imgCashForPaymentType.tintColor = .red
            self.PayCashView.backgroundColor = UIColor.black
            paymentType = "cash"
            btnCash.setTitleColor(themeAppMainColor, for: .normal)
            btnCardSelection.setTitle("Card", for: .normal)
            CardID = ""
            paymentType = "cash"
            
        } else if(sender.tag == 2) {
            paymentType = "wallet"
            
        } else if(sender.tag == 3) {
            self.imgCardForPaymentType.image = UIImage(named: "icon_SelectedCard")
            self.btnCardSelection.setTitleColor(themeYellowColor, for: .normal)
            paymentType = "card" //rjChange "m_pesa"
            self.imgCardForPaymentType.tintColor = .red
            self.PayCardView.backgroundColor = UIColor.black
            btnCardSelection.setTitleColor(themeAppMainColor, for: .normal)
        }
    }
    
    func presentCardListScreen() {
        let next = mainStoryboard.instantiateViewController(withIdentifier: "WalletCardsVC") as! WalletCardsVC
        next.delegateForSelectCardForBooking = self
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    func didSelectCard(cardId: String) {
        CardID = cardId
    }
    
    
    func didSelectCard(dictData: [String : AnyObject]) {
        //        if let strCardNumber = dictData["CardNum2"] as? String
        //        {
        //            if let lastComponent = strCardNumber.components(separatedBy: " ").last
        //            {
        //                    self.lblCardTitle.text = lastComponent
        //                    CardID = dictData["Id"] as? String ?? ""
        //            }
        //        }
    }
    
    func addNewCard() {
        let next = self.storyboard!.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
        next.delegateAddCardFromBookLater = self
        self.isAddCardSelected = false
        self.navigationController?.pushViewController(next, animated: true)//present(next, animated: true, completion: nil)
    }
    
    func selectExistingCard() {
        let next = self.storyboard!.instantiateViewController(withIdentifier: "WalletCardsVC") as! WalletCardsVC
        next.delegateForTopUp = self
        next.canEditRowBool = false
        self.isAddCardSelected = false
        SingletonClass.sharedInstance.isFromTopUP = true
        self.navigationController?.pushViewController(next, animated: true)//present(next, animated: true, completion: nil)
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Calendar Method
    //-------------------------------------------------------------
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date)
    {
        
        let myDateFormatter: DateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        
        let TimeFormatter: DateFormatter = DateFormatter()
        TimeFormatter.dateFormat = "hh:mm a"
        
        let dateOfPostToApi: DateFormatter = DateFormatter()
        dateOfPostToApi.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let Date_Time = (String(self.txtDataAndTimeFromCalendar.text!).components(separatedBy: " ") )[0]
        
        let TimeString = TimeFormatter.string(from: date)
        let FlightTimeDate = myDateFormatter.date(from: "\(Date_Time) \(TimeString)")
        
        var SelectedDate = Date()
        
        if selector == DateTimeselector {
            SelectedDate = date
        } else {
            SelectedDate = FlightTimeDate!
        }
        
        if currentDate < SelectedDate {
            
            let currentTimeInterval = currentDate.addingTimeInterval(30 * 60)
            if  SelectedDate > currentTimeInterval {
                convertDateToString = dateOfPostToApi.string(from: SelectedDate)
                
                if self.isCalenderFordateTime == true {
                    let finalDate = myDateFormatter.string(from: SelectedDate)
                    let mySelectedDate = String(describing: finalDate)
                    txtDataAndTimeFromCalendar.text = mySelectedDate
                    txtDataAndTimeFromCalendar.textColor = UIColor.black
                }
                else {
                    txtFlightArrivalTime.text = TimeString
                }
            }
            else {
                if self.isCalenderFordateTime == true {
                    txtDataAndTimeFromCalendar.text = ""
                } else {
                    txtFlightArrivalTime.text = ""
                }
                UtilityClass.setCustomAlert(title: "Invalid Request".localized, message: "System Does Not Accept Prebook Option If Pick Up Time Is Within 30 Minutes.".localized) { (index, title) in
                }
            }
        }
        
    }
    
    func WWCalendarTimeSelectorWillDismiss(_ selector: WWCalendarTimeSelector) {
        
    }
    
    func WWCalendarTimeSelectorDidDismiss(_ selector: WWCalendarTimeSelector) {
        
    }
    
    func WWCalendarTimeSelectorShouldSelectDate(_ selector: WWCalendarTimeSelector, date: Date) -> Bool {
        
        if currentDate < date {
            let currentTimeInterval = currentDate.addingTimeInterval(30 * 60)
            if  date > currentTimeInterval {
                return true
            }
            return false
        }
        return false
    }
    
    @IBAction func btnCancelPromocode(_ sender: Any) {
        self.strAppliedPromocode = ""
        btnCancelPromocode.isHidden = true
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice For Book Later
    //-------------------------------------------------------------
    func webserviceForEstimateFare(date: String) {
        
        let arrDate = date.components(separatedBy: " ")
        
        var dictData = [String:AnyObject]()
        dictData["PickupDate"] = arrDate[0] as AnyObject
        dictData["PickupTime"] = arrDate[1] as AnyObject
        dictData["ModelId"] = self.strModelId as AnyObject
        dictData["PickupLocation"] = self.strPickupLocation as AnyObject
        dictData["PickupLat"] = self.doublePickupLat as AnyObject
        dictData["PickupLong"] = self.doublePickupLng as AnyObject
        dictData["DropoffLocation"] = self.strDropoffLocation as AnyObject
        dictData["DropOffLat"] = self.doubleDropOffLat as AnyObject
        dictData["DropOffLong"] = self.doubleDropOffLng as AnyObject
        dictData["Ids"] = SingletonClass.sharedInstance.strOnlineDriverID as AnyObject
        if(isMultiDropReq){
            dictData["DropoffLocation2"] = txtScondDropOffLocation.text as AnyObject
            dictData["DropOffLat2"] = doubleDropOffLat2 as AnyObject
            dictData["DropOffLon2"] = doubleDropOffLng2 as AnyObject
        }
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        webserviceForEstimateFareForbookLater(dictData as AnyObject) { (result, status) in
            
            if (status) {
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                print(result)
                let estimateRange = ((result as! NSDictionary).object(forKey: "estimate_fare") as! NSDictionary).object(forKey: "estimate_fare_range") as? String ?? ""
                self.txtEstimatedFare.text = estimateRange
                self.strSelectedCarTotalFare = "\(((result as! NSDictionary).object(forKey: "estimate_fare") as! NSDictionary).object(forKey: "total") as? Int ?? 0)"
                
                let priceModel = ((result as! NSDictionary).object(forKey: "estimate_fare") as! NSDictionary).object(forKey: "price_name") as? String ?? ""
                if(priceModel != ""){
                    self.priceModel = priceModel
                    let spanishText = ((result as! NSDictionary).object(forKey: "estimate_fare") as! NSDictionary).object(forKey: "price_name_spanish") as? String ?? ""
                    self.lblEstimatedFare.text = "Estimated Fare".localized + " " + "(" + "\((Localize.currentLanguage() == Languages.English.rawValue) ? priceModel : spanishText)" + ")"
//                    self.lblEstimatedFare.textColor = themeRedColor
                }
                
                let msg = (Localize.currentLanguage() == Languages.English.rawValue) ? ((result as! NSDictionary).object(forKey: "estimate_fare") as! NSDictionary).object(forKey: "notify_message") as? String ?? "" : ((result as! NSDictionary).object(forKey: "estimate_fare") as! NSDictionary).object(forKey: "notify_message_spanish") as? String ?? ""
                self.msgPriceModel = msg
                
            } else {
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "Error", message: res) { (index, title) in}
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "Error", message: resDict.object(forKey: GetResponseMessageKey()) as! String) { (index, title) in }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: GetResponseMessageKey()) as! String) { (index, title) in }
                }
            }
        }
    }
    
    func webServiceOfCheckPromoCode() {
        if Connectivity.isConnectedToInternet() == false {
            UtilityClass.setCustomAlert(title: "Connection Error".localized, message: "Internet connection not available".localized) { (index, title) in
            }
            return
        }
        var dictData = [String:AnyObject]()
        if let strPromocode = txtPromoCode.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        {
            dictData["PromoCode"] = strPromocode as AnyObject
            webserviceForCheckPromocode(dictData as AnyObject) { (result, status) in
                if (status) {
                    let mySelectedAttributedTitle = NSAttributedString(string: "\("Promocode Applied".localized) \(self.txtPromoCode.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")",
                                                                       attributes: [NSAttributedString.Key.foregroundColor : UIColor.green])
                    self.btnSelectPromocode.setAttributedTitle(mySelectedAttributedTitle, for: .normal)
                    self.btnSelectPromocode.setTitle("\("Promocode Applied".localized) \(self.txtPromoCode.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")", for: .normal)
                    self.viewProocode.isHidden = true
                    self.btnCancelPromocode.isHidden = false
                    self.strAppliedPromocode = self.txtPromoCode.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                } else {
                    self.btnSubmit.isEnabled = true
                    print(result)
                    if let res = result as? String {
                        UtilityClass.setCustomAlert(title: "Error", message: res) { (index, title) in }
                    } else if let resDict = result as? NSDictionary {
                        UtilityClass.setCustomAlert(title: "Error", message: resDict.object(forKey: GetResponseMessageKey()) as! String) { (index, title) in
                        }
                    } else if let resAry = result as? NSArray {
                        UtilityClass.setCustomAlert(title: "Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: GetResponseMessageKey()) as! String) { (index, title) in }
                    }
                }
                self.txtPromoCode.text = ""
            }
        }
        
    }
    
    func webserviceOFBookLater() {
        if Connectivity.isConnectedToInternet() == false {
            
            UtilityClass.setCustomAlert(title: "Connection Error".localized, message: "Internet connection not available".localized) { (index, title) in
            }
            return
        }
        var dictData = [String:AnyObject]()
        if let dict = self.dictSelectedDriver {
            if let strDriverID = dict["DriverId"] as? String {
                dictData["DriverId"] = strDriverID as AnyObject
            }
            if let strDriverID = dict["DriverId"] as? Int {
                dictData["DriverId"] = strDriverID as AnyObject
            }
        }
        dictData["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
        dictData["ModelId"] = strModelId as AnyObject
        dictData["PickupLocation"] = txtPickupLocation.text as AnyObject
        dictData["DropoffLocation"] = txtDropOffLocation.text as AnyObject
        dictData["PassengerType"] = (btnBookForSomeone.isSelected) ? "other" as AnyObject : "myself" as AnyObject
        dictData["PassengerName"] = (btnBookForSomeone.isSelected) ? txtFullName.text as AnyObject : strFullname as AnyObject
        dictData["PassengerContact"] = (btnBookForSomeone.isSelected) ? txtMobileNumber.text as AnyObject : strMobileNumber as AnyObject
        dictData["PickupDateTime"] = convertDateToString as AnyObject
        dictData["EstimateFare"] = strSelectedCarTotalFare as AnyObject
        dictData["PickupLat"] = doublePickupLat as AnyObject
        dictData["PickupLng"] = doublePickupLng as AnyObject
        dictData["DropOffLat"] = doubleDropOffLat as AnyObject
        dictData["DropOffLon"] = doubleDropOffLng as AnyObject
        if(isMultiDropReq){
            dictData["DropoffLocation2"] = txtScondDropOffLocation.text as AnyObject
            dictData["DropOffLat2"] = doubleDropOffLat2 as AnyObject
            dictData["DropOffLon2"] = doubleDropOffLng2 as AnyObject
        }
        if lblPromoCode.text != "" {
            dictData["PromoCode"] = lblPromoCode.text as AnyObject
        }
        dictData["Notes"] = txtDescription.text as AnyObject
        
        if paymentType == "" {
            UtilityClass.setCustomAlert(title: "Missing".localized, message: "Select Payment Type".localized) { (index, title) in
            }
        }
        else {
            dictData["PaymentType"] = paymentType as AnyObject
            if(paymentType == "card"){
                if(self.CardID == ""){
                    dictData[SubmitBookingRequest.kCardId] = "" as AnyObject
                }else{
                    dictData[SubmitBookingRequest.kCardId] = self.CardID as AnyObject
                }
            }
        }
        
        if txtFlightNumber.text!.count == 0 {
            dictData["FlightNumber"] = "" as AnyObject
        }
        else {
            dictData["FlightNumber"] = txtFlightNumber.text as AnyObject
        }
        
        dictData["language"] = Localize.currentLanguage() as AnyObject
        dictData["PriceType"] = self.priceType as AnyObject
        
        print("book later.. \(dictData)")
        webserviceForBookLater(dictData as AnyObject) { (result, status) in
            self.btnSubmit.isEnabled = true
            if (status) {
                print(result)
                
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "Success Message".localized, message: res) { (index, title) in
                        self.BookLaterCompleted.BookLaterComplete()
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "Success Message".localized, message: resDict.object(forKey:  GetResponseMessageKey()) as? String ?? "") { (index, title) in
                        self.BookLaterCompleted.BookLaterComplete()
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "Success Message".localized, message: (resAry.object(at: 0) as! NSDictionary).object(forKey: GetResponseMessageKey()) as? String ?? "") { (index, title) in
                        self.BookLaterCompleted.BookLaterComplete()
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                
            } else {
                
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "Error", message: res) { (index, title) in
                    }
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "Error", message: resDict.object(forKey:  GetResponseMessageKey()) as! String) { (index, title) in
                    }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: GetResponseMessageKey()) as! String) { (index, title) in
                    }
                }
            }
        }
    }
    
    
    
    func webserviceOfCardList(setCardInButton : Bool) {
        if Connectivity.isConnectedToInternet() == false {
            
            UtilityClass.setCustomAlert(title: "Connection Error".localized, message: "Internet connection not available".localized) { (index, title) in
            }
            return
        }
        UtilityClass.showACProgressHUD()
        webserviceForCardList(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
            if self.arrPromocodes.count == 0 {
                self.webserviewOfGetPromocodeList()
            } else {
                UtilityClass.hideACProgressHUD()
            }
            
            if (status) {
                print(result)
                
                if let res = result as? [String:AnyObject] {
                    if let cards = res["cards"] as? [[String:AnyObject]] {
                        self.aryCards = cards
                        
                        if(setCardInButton) {
                            
                            //((result["cards"] as! [[String:AnyObject]])[0]["CardNum2"] as? String)?.components(separatedBy: " ").last
                            if let arrCards = result["cards"] as? [[String:AnyObject]] {
                                if let strCardNumber = arrCards[0]["CardNum2"] as? String
                                {
                                    if let lastComponent = strCardNumber.components(separatedBy: " ").last
                                    {
                                        //                                        self.lblCardTitle.text = lastComponent
                                        self.CardID = arrCards[0]["Id"] as? String ?? ""
                                    }
                                }
                            }
                        }
                    }
                }
            }else {
                print(result)
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "Error", message: res) { (index, title) in
                    }
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "Error", message: resDict.object(forKey:  GetResponseMessageKey()) as! String) { (index, title) in
                    }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: GetResponseMessageKey()) as! String) { (index, title) in
                    }
                }
            }
        }
    }
    
    func webserviewOfGetPromocodeList() {
        if Connectivity.isConnectedToInternet() == false {
            
            UtilityClass.setCustomAlert(title: "Connection Error", message: "Internet connection not available") { (index, title) in
            }
            return
        }
        webserviceForPromoCodeList { (result, status) in
            UtilityClass.hideACProgressHUD()
            if (status) {
                print(result)
                if let arrPromo = (result as! [String:Any])["promocode_list"] as? [[String:Any]] {
                    if arrPromo.count > 0 {
                        self.arrPromocodes = arrPromo
                        self.arrPromocodeList.removeAll()
                        self.arrPromocodeList.append("Select Promocode")
                        for PromocodeDict in self.arrPromocodes {
                            var Benefit:String = ""
                            var Promocode:String = ""
                            if let FlatValue:String = PromocodeDict["Description"] as? String {
                                Benefit = FlatValue
                            }
                            if let PromoValue:String = PromocodeDict["PromoCode"] as? String {
                                Promocode =  PromoValue
                            }
                            let PromocodeDetail = "\(Promocode) : \(Benefit)"
                            self.arrPromocodeList.append(PromocodeDetail)
                            
                        }
                    } else {
                        self.arrPromocodeList.removeAll()
                        self.arrPromocodeList.append("No promo code available")
                    }
                } else {
                    self.arrPromocodeList.removeAll()
                    self.arrPromocodeList.append("No promo code available")
                }
            }
            else {
                print(result)
            }
        }
    }
    
    @IBAction func btnClearCurrentLocation(_ sender: UIButton) {
        txtPickupLocation.text = ""
    }
    
    @IBAction func btnClearDropOffLocation(_ sender: UIButton) {
        txtDropOffLocation.text = ""
    }
    
    @IBAction func btnClearSecondDropOffLocation(_ sender: UIButton) {
        txtScondDropOffLocation.text = ""
    }
    
}

// Delegates to handle events for the location manager.
extension BookLaterViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // let location: CLLocation = locations.last!
        //        print("Location: \(location)")
        
        //        self.getPlaceFromLatLong()
        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: break
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
}

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}

extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        dateformat.timeZone = .current
        return dateformat.string(from: self)
    }
}
