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
//import ActionSheetPicker_3_0

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


class BookLaterViewController: BaseViewController, GMSAutocompleteViewControllerDelegate, UINavigationControllerDelegate, WWCalendarTimeSelectorProtocol, UIPickerViewDelegate, UIPickerViewDataSource, isHaveCardFromBookLaterDelegate, UITextFieldDelegate,SelectCardDelegate {


    
    @IBOutlet weak var btnCancelPromocode: UIButton!
    @IBOutlet weak var btnApplyPromocode: UIButton!

    var BookLaterCompleted:BookLaterSubmitedDelegate!
    var datePickerView = UIDatePicker()
    var dictSelectedDriver: [String: AnyObject]?
//    var pickerView = UIPickerView()
    var pickerViewForInvoiceType = UIPickerView()
    var strModelId = String()
    var BoolCurrentLocation = Bool()
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
    
    
    var placesClient = GMSPlacesClient()
    var locationManager = CLLocationManager()
    
    var aryOfPaymentOptionsNames = [String]()
    var aryOfPaymentOptionsImages = [String]()
    
    var CardID = String()
    var paymentType = String()
    
    var intNumberOfPassengerOnShareRiding:Int = 1
    var DateTimeselector = WWCalendarTimeSelector.instantiate()
    var TimeSelector = WWCalendarTimeSelector.instantiate()
    
    @IBOutlet weak var viewNotes: UIView!
    var NearByRegion:GMSCoordinateBounds!
    var isOpenPlacePickerController:Bool = false
    
//    @IBOutlet weak var btnNumberOfPassenger: UIButton!

    @IBOutlet weak var imgCardForPaymentType: UIImageView!
    @IBOutlet weak var imgWalletForPaymentType: UIImageView!
    @IBOutlet weak var imgCashForPaymentType: UIImageView!

    @IBOutlet weak var lblCashTitle: UILabel!
    @IBOutlet weak var lblWalletTitle: UILabel!
    @IBOutlet weak var lblCardTitle: UILabel!
    
    @IBOutlet weak var txtDriverAwayTime: UITextField!
    @IBOutlet weak var txtDriverAwayKm: UITextField!
    @IBOutlet weak var txtEstimatedFare: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()


//        self.title = "Schedule Trip"
        self.setNavBarWithBack(Title: "Book Later".localized, IsNeedRightButton: false)

        self.navigationItem.title = "Book Later".localized
        
        self.lblWalletTitle.numberOfLines = 0
        let imageViewForCalendar = self.btnCalendar.imageView
        imageViewForCalendar?.setImageColor(color: themeAppMainColor)
        self.btnCalendar.setImage(imageViewForCalendar?.image, for: .normal)
        self.btnTimeCalender.setImage(imageViewForCalendar?.image, for: .normal)
        btnSelectPromocode.setTitleColor(themeAppMainColor, for: .normal)
        
        txtDropOffLocation.delegate = self
        txtPickupLocation.delegate = self
        self.btnSelectPromocode.setTitle("Select Promocode", for: .normal)
        //        UIApplication.shared.statusBarView?.backgroundColor = UIColor.black
        
        if #available(iOS 11.0, *) {
            if (UIApplication.shared.keyWindow?.safeAreaInsets.top)! > 0.0 {
                
                print("iPhone X")
            }
            else {
                print("Not iPhone X ")
            }
        } else {
            // Fallback on earlier versions
        }
        
        txtDropOffLocation.text = strDropoffLocation
        
        
//        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
//        txtFullName.leftView = paddingView
//        txtFullName.leftViewMode = .always

        DateTimeselector.delegate = self
        TimeSelector.delegate = self
        
        //        alertView.removeFromSuperview()
        
        //        btnForMySelfAction.addTarget(self, action: #selector(self.ActionForViewMySelf), for: .touchUpInside)
        //
        //        btnForOthersAction.addTarget(self, action: #selector(self.ActionForViewOther), for: .touchUpInside)
        
        viewProocode.isHidden = true
        
        webserviceOfCardList(setCardInButton: false)
        
//        pickerView.delegate = self

        aryOfPaymentOptionsNames = [""]
        aryOfPaymentOptionsImages = [""]
        
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        setViewDidLoad()
        //        txtDataAndTimeFromCalendar.isUserInteractionEnabled = false
        
        imgCareModel.sd_setImage(with: URL(string: strCarModelURL), completed: nil)
        lblCareModelClass.text = "Vehicle Type: \(strCarName)"
        
        //        lblPassenger.text = "(maximum \(self.PasangerDefinedLimit) passengers)"
        if strCarName == "VAN" {
            self.arrNumberOfPassengerList = ["5","6","7","8","9","10"]
        } else {
            self.arrNumberOfPassengerList = ["1","2","3","4"]
        }
        
//        self.btnNumberOfPassenger.setTitle(self.arrNumberOfPassengerList[0], for: .normal)

        txtFullName.text = strFullname
        txtMobileNumber.text = strMobileNumber
        
        checkMobileNumber()


        datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.dateAndTime
        
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: 30, to: Date())
        datePickerView.minimumDate = date
        txtDataAndTimeFromCalendar.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.pickupdateMethod(_:)), for: UIControl.Event.valueChanged)
        
        
        let mySelectedAttributedTitle = NSAttributedString(string: "Have a Promocode?",
                                                           attributes: [NSAttributedString.Key.foregroundColor : themeAppMainColor,NSAttributedString.Key.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        self.btnSelectPromocode.setAttributedTitle(mySelectedAttributedTitle, for: .normal)
        self.btnSelectPromocode.setTitle("Promocode Applied \(self.txtPromoCode.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")", for: .normal)
        self.btnApplyPromocode.backgroundColor = themeAppMainColor
        self.btnApplyPromocode.setTitleColor(.black, for: .normal)
        self.txtMobileNumber.leftMargin = 0

    }



        @objc func pickupdateMethod(_ sender: UIDatePicker)
        {
            let dateFormaterView = DateFormatter()
            dateFormaterView.dateFormat = "MM-dd-yyyy hh:mm a"

            txtDataAndTimeFromCalendar.text = dateFormaterView.string(from: sender.date)
        }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isOpenPlacePickerController == false {
//            gaveCornerRadius()

            if SingletonClass.sharedInstance.CardsVCHaveAryData.count != 0 {
//                pickerView.reloadAllComponents()
//                txtSelectPaymentMethod.text = ""
//                imgPaymentOption.image = UIImage(named: "iconDummyCard")
                //            paymentType = "cash"
//                pickerView.selectedRow(inComponent: 0)
//                txtSelectPaymentMethod.becomeFirstResponder()
//                txtSelectPaymentMethod.resignFirstResponder()

            }
            
//            txtSelectPaymentMethod.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(self.IQKeyboardmanagerDoneMethod))

            fillTextFields()
        }
        
        self.isOpenPlacePickerController = false
        
        //        getPlaceFromLatLong()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fillTextFields() {
        txtPickupLocation.text = strPickupLocation
        txtDropOffLocation.text = strDropoffLocation
        postPickupAndDropLocationForEstimateFare()
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
        
        //        let themeColor: UIColor = UIColor.init(red: 255/255, green: 163/255, blue: 0, alpha: 1.0)
        //        viewMySelf.tintColor = ThemeYellowColor
        //        viewOthers.tintColor = ThemeYellowColor
        viewFlightNumber.tintColor = themeAppMainColor
        CheckArrivalTime.tintColor = themeAppMainColor
//        tripCheck.tintColor = ThemeYellowColor
//        taxCheck.tintColor = ThemeYellowColor
                btnNotes.tintColor = themeAppMainColor

        
        //        viewMySelf.stateChangeAnimation = .fill
        //        viewOthers.stateChangeAnimation = .fill
        viewFlightNumber.stateChangeAnimation = .fill
        CheckArrivalTime.stateChangeAnimation = .fill
//        tripCheck.stateChangeAnimation = .fill
//        taxCheck.stateChangeAnimation = .fill
                btnNotes.stateChangeAnimation = .fill
        //
        //        viewMySelf.boxType = .square
        //        viewMySelf.checkState = .checked
        //        viewOthers.boxType = .square
                btnNotes.boxType = .square

        strPassengerType = "myself"
        viewFlightNumber.boxType = .square
        CheckArrivalTime.boxType = .square
//        tripCheck.boxType = .square
//        taxCheck.boxType = .square
//        self.SelectReceiptType(index: 0)

        //        constraintsHeightOFtxtFlightNumber.constant = 0 // 30 Height
        //        constaintsOfTxtFlightNumber.constant = 0
        //        imgViewLineForFlightNumberHeight.constant = 0
        //        constantHavePromoCodeTop.constant = 0
        //        constantNoteHeight.constant = 0
        //        imgViewLineForFlightNumberHeight.constant = 0
        //        imgViewLineForNotesHeight.constant = 0
        
        //        txtFlightNumber.isHidden = true
        View_FlightNumber.isHidden = true
        txtFlightNumber.text = ""
        ViewArrivalTime.isHidden = true
        
        ViewFlightArrivalTime.isHidden = true
        
        txtFlightNumber.isEnabled = false
        txtDescription.isEnabled = false
        
        alertView.layer.cornerRadius = 10
        alertView.layer.masksToBounds = true
        
        //        txtDataAndTimeFromCalendar.layer.borderWidth = 1
        //        txtDataAndTimeFromCalendar.layer.cornerRadius = 5
        //        txtDataAndTimeFromCalendar.layer.borderColor = UIColor.black.cgColor
        //        txtDataAndTimeFromCalendar.layer.masksToBounds = true
        
        txtFlightArrivalTime.layer.borderWidth = 1
        txtFlightArrivalTime.layer.cornerRadius = 5
        txtFlightArrivalTime.layer.borderColor = UIColor.black.cgColor
        txtFlightArrivalTime.layer.masksToBounds = true
        
//        viewPaymentMethod.layer.borderWidth = 1
//        viewPaymentMethod.layer.cornerRadius = 5
//        viewPaymentMethod.layer.borderColor = UIColor.black.cgColor
//        viewPaymentMethod.layer.masksToBounds = true

        btnSubmit.layer.cornerRadius = 10
        btnSubmit.layer.masksToBounds = true
        
        //        viewCurrentLocation.layer.shadowOpacity = 0.3
        //        viewCurrentLocation.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        //        viewDestinationLocation.layer.shadowOpacity = 0.3
        //        viewDestinationLocation.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    @IBOutlet weak var viewProocode: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    //    @IBOutlet weak var viewMySelf: M13Checkbox!
    //    @IBOutlet weak var viewOthers: M13Checkbox!
    @IBOutlet weak var viewFlightNumber: M13Checkbox!
    
    @IBOutlet weak var viewDestinationLocation: UIView!
    @IBOutlet weak var viewCurrentLocation: UIView!
    
    //    @IBOutlet weak var lblMySelf: UILabel!
    //    @IBOutlet weak var lblOthers: UILabel!
    
    @IBOutlet weak var lblCareModelClass: UILabel!
    @IBOutlet weak var imgCareModel: UIImageView!
    
    @IBOutlet weak var txtPickupLocation: UITextField!
    @IBOutlet weak var txtDropOffLocation: UITextField!
    
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtMobileNumber: FormTextField!
    
    @IBOutlet weak var txtDataAndTimeFromCalendar: UITextField!
    
    @IBOutlet weak var btnCalendar: UIButton!
    
    @IBOutlet weak var txtFlightNumber: UITextField!
    @IBOutlet weak var View_FlightNumber: UIView!
    
    @IBOutlet weak var txtFlightArrivalTime: UITextField!
    
//    @IBOutlet weak var lblPassenger: UILabel!

    //    @IBOutlet weak var constraintsHeightOFtxtFlightNumber: NSLayoutConstraint!
    //    @IBOutlet weak var constaintsOfTxtFlightNumber: NSLayoutConstraint! // 10
    
//    @IBOutlet weak var txtSelectPaymentMethod: UITextField!
//    @IBOutlet weak var imgPaymentOption: UIImageView!

        @IBOutlet weak var btnNotes: M13Checkbox!
    //
    //    @IBOutlet weak var constantNoteHeight: NSLayoutConstraint!  // 40
    //
    //    @IBOutlet weak var constantHavePromoCodeTop: NSLayoutConstraint!  // 10
    
    @IBOutlet weak var txtPromoCode: UITextField!
    
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet var alertView: UIView!
    @IBOutlet weak var viewPaymentMethod: UIView!
    
    @IBOutlet weak var lblPromoCode: UILabel!
    
    @IBOutlet weak var ViewArrivalTime: UIView!
    
    @IBOutlet weak var ViewFlightArrivalTime: UIView!
    
    @IBOutlet weak var CheckArrivalTime: M13Checkbox!
    
    var BackView = UIView()
    
    //    @IBOutlet weak var btnForMySelfAction: UIButton!
    //    @IBOutlet weak var btnForOthersAction: UIButton!
    //    @IBOutlet weak var imgViewLineForFlightNumberHeight: NSLayoutConstraint!
    //    @IBOutlet weak var imgViewLineForNotesHeight: NSLayoutConstraint!
    
//    @IBOutlet weak var lblNumberOfPassengers: UILabel!

    
    //-------------------------------------------------------------
    // MARK: - Button Actions
    //-------------------------------------------------------------
    
    @IBAction func btnSelectNumberOfPassenger(_ sender: Any) {
        
      /*
         ActionSheetStringPicker.show(withTitle: "Select Number Of Passenger", rows: arrNumberOfPassengerList, initialSelection: 0, doneBlock: { (actionSheet, index, obj) in
            //            self.selectedIndex = index
            //            Singletons.sharedInstance.strReasonForCancel = arrData[index]
//            self.btnNumberOfPassenger.setTitle(self.arrNumberOfPassengerList[index], for: .normal)

        }, cancel: { (actionSheet) in
            
        }, origin: self.view)
         
        */
    }
    
    @IBOutlet weak var btnSelectPromocode: UIButton!
    
    @IBAction func btnSelectPromocode(_ sender: Any) {
        
//        ActionSheetStringPicker.show(withTitle: "Select Promocode", rows: self.arrPromocodeList, initialSelection: 0, doneBlock: { (actionSheet, index, obj) in
//            //            self.selectedIndex = index
//            //            Singletons.sharedInstance.strReasonForCancel = arrData[index]
//            if self.arrPromocodeList.count > 1 {
//                self.btnSelectPromocode.setTitle(self.arrPromocodeList[index], for: .normal)
//            }
//        }, cancel: { (actionSheet) in
//
//        }, origin: self.view)

        viewProocode.isHidden = false
    }
    
    
    
    @IBAction func IncreasePassengerCount(_ sender: UIButton) {
        if intNumberOfPassengerOnShareRiding < self.PasangerDefinedLimit {
            intNumberOfPassengerOnShareRiding = intNumberOfPassengerOnShareRiding + 1
        }
//        self.lblNumberOfPassengers.text = "\(intNumberOfPassengerOnShareRiding)"
    }
    
    
    @IBAction func DecreasePassengerCount(_ sender: UIButton) {
        
        if intNumberOfPassengerOnShareRiding > 1 {
            intNumberOfPassengerOnShareRiding = intNumberOfPassengerOnShareRiding - 1
            
        }
//        self.lblNumberOfPassengers.text = "\(intNumberOfPassengerOnShareRiding)"

    }
    
    
    
    
    
    @IBAction func btnApply(_ sender: UIButton) {
        if self.txtPromoCode.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            self.webServiceOfCheckPromoCode()
        }
        else {
            UtilityClass.showAlert("", message: "Please enter promocode!", vc: self)
        }
        
        
        //       lblPromoCode.text = txtPromoCode.text
        //
                viewProocode.isHidden = true

        //        self.view.alpha = 1.0
        //        BackView.removeFromSuperview()
        //        alertView.removeFromSuperview()
        
        
    }
    @IBAction func btnCancel(_ sender: UIButton) {
        
        viewProocode.isHidden = true
        
        txtPromoCode.text = ""
        //        self.view.alpha = 1.0
        //        BackView.removeFromSuperview()
        //        alertView.removeFromSuperview()
    }
    
    @IBAction func btnHavePromoCode(_ sender: UIButton) {
        
        txtPromoCode.becomeFirstResponder()
        viewProocode.isHidden = false
        
        //        UIApplication.shared.keyWindow!.bringSubview(toFront: alertView)
    }
        /*
     @IBOutlet weak var tripCheck: M13Checkbox!

     @IBOutlet weak var taxCheck: M13Checkbox!


    @IBAction func TripReceiptType(_ sender: M13Checkbox) {
        if sender == tripCheck {
            SelectReceiptType(index: 0)
        } else if sender == taxCheck {
            SelectReceiptType(index: 1)
        }
    }
    
    
    func SelectReceiptType(index:Int) {
        
        self.tripCheck.checkState = .unchecked
        self.tripCheck.stateChangeAnimation = .fill
        self.taxCheck.checkState = .unchecked
        self.taxCheck.stateChangeAnimation = .fill
        
        switch index {
        case 0:
            self.tripCheck.checkState = .checked
            self.tripCheck.stateChangeAnimation = .fill
            self.ReceiptType = "Trip Receipt"
        case 1:
            self.taxCheck.checkState = .checked
            self.taxCheck.stateChangeAnimation = .fill
            self.ReceiptType = "Tax Receipt"
        default:
            break
        }
        
    }
    */
    
    @IBAction func btnNotes(_ sender: M13Checkbox) {
        
        boolIsSelectedNotes = !boolIsSelectedNotes
        
        if (boolIsSelectedNotes) {
            
            //            constantNoteHeight.constant = 40
            //            constantHavePromoCodeTop.constant = 10
            //            imgViewLineForNotesHeight.constant = 1
            viewNotes.isHidden = false
//            txtSelectPaymentMethod.isHidden = false
            txtDescription.isEnabled = true
        }
        else {
            
            //            constantNoteHeight.constant = 0
            //            constantHavePromoCodeTop.constant = 0
            //            imgViewLineForNotesHeight.constant = 0
            viewNotes.isHidden = true
//            txtSelectPaymentMethod.isHidden = true
            txtDescription.isEnabled = false
            
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
//    @IBAction func txtSelectPaymentMethod(_ sender: UITextField) {
//
//        txtSelectPaymentMethod.inputView = pickerView
//    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func viewMySelf(_ sender: M13Checkbox) {
        
        ActionForViewMySelf()
        
    }
    
    @objc func ActionForViewMySelf() {
        
        //        viewMySelf.checkState = .checked
        //        viewOthers.checkState = .unchecked
        //        viewMySelf.stateChangeAnimation = .fill
        
        
        txtFullName.text = strFullname
        txtMobileNumber.text = strMobileNumber
        
        strPassengerType = "myself"
        
    }
    
    @objc func ActionForViewOther() {
        //        viewMySelf.checkState = .unchecked
        //        viewOthers.checkState = .checked
        //        viewOthers.stateChangeAnimation = .fill
        
        txtFullName.text = ""
        txtMobileNumber.text = ""
        
        strPassengerType = "other"
    }
    
    @IBAction func viewOthers(_ sender: M13Checkbox) {
        ActionForViewOther()
        
    }
    
    @IBAction func viewFlightNumber(_ sender: M13Checkbox) {
        
        boolIsSelected = !boolIsSelected
        
        if (boolIsSelected) {
            
            //            constraintsHeightOFtxtFlightNumber.constant = 40
            //            constaintsOfTxtFlightNumber.constant = 10
            //            imgViewLineForFlightNumberHeight.constant = 1
            self.View_FlightNumber.isHidden = false
            self.ViewArrivalTime.isHidden = false
            //            txtFlightNumber.isHidden = false
            txtFlightNumber.isEnabled = true
        }
        else {
            
            //            constraintsHeightOFtxtFlightNumber.constant = 0
            //            constaintsOfTxtFlightNumber.constant = 0
            //            imgViewLineForFlightNumberHeight.constant = 0
            
            
            self.View_FlightNumber.isHidden = true
            self.txtFlightNumber.text = ""
            self.ViewArrivalTime.isHidden = true
            if self.ViewFlightArrivalTime.isHidden == false {
                self.ViewFlightArrivalTime.isHidden = true
                self.CheckArrivalTime.checkState = .unchecked
                self.CheckArrivalTime.stateChangeAnimation = .fill
            }
            txtFlightNumber.isEnabled = false
            
            
            //            txtFlightNumber.isHidden = true
            
            
        }
    }
    
    @IBAction func ViewArrivalTimeAction(_ sender: M13Checkbox) {
        
        self.ViewFlightArrivalTime.isHidden = !self.ViewFlightArrivalTime.isHidden
    }
    
    
    @IBAction func txtPickupLocation(_ sender: UITextField) {
        self.isOpenPlacePickerController = true
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
//        acController.autocompleteBounds = NearByRegion
        BoolCurrentLocation = true

        let filter = GMSAutocompleteFilter()
        filter.country = "GY"
        if(UIDevice.current.name.lowercased() == "rahul's iphone")
        {
            filter.country = "IN"
        }
        acController.autocompleteFilter = filter
        present(acController, animated: true, completion: nil)
        
    }
    
    @IBAction func txtDropOffLocation(_ sender: UITextField) {
        self.isOpenPlacePickerController = true
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
//        acController.autocompleteBounds = NearByRegion
        let filter = GMSAutocompleteFilter()
        filter.country = "GY"
        if(UIDevice.current.name.lowercased() == "rahul's iphone")
        {
            filter.country = "IN"
        }
        acController.autocompleteFilter = filter
        BoolCurrentLocation = false
        
        present(acController, animated: true, completion: nil)
        
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
        
        
        //        selector.optionStyles.showDateMonth(true)
        DateTimeselector.optionStyles.showYear(false)
        //        selector.optionStyles.showMonth(true)
        
        DateTimeselector.optionStyles.showTime(true)
        
        // 2. You can then set delegate, and any customization options
        
        DateTimeselector.optionTopPanelTitle = "Please choose date"
        
        DateTimeselector.optionIdentifier = "Time" as AnyObject
        
        let dateCurrent = Date()
        
        
        DateTimeselector.optionCurrentDate = dateCurrent.addingTimeInterval(30 * 60)
        
        // 3. Then you simply present it from your view controller when necessary!
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(DateTimeselector, animated: true, completion: nil)
        //        self.present(DateTimeselector, animated: true, completion: nil)
//        UtilityClass.presentOverAlert(vc: DateTimeselector)
    }
    
    
    @IBOutlet weak var btnTimeCalender: UIButton!
    
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
            //            self.present(TimeSelector, animated: true, completion: nil)
//            UtilityClass.presentOverAlert(vc: TimeSelector)
            
        } else {
            UtilityClass.showAlert("", message: "Please select date first!", vc: self)
        }
    }
    
    //MARK:- Validation Method
    
    func isValidateRequest() -> (String,Bool) {
        
        var ValidationStatus:Bool = true
        var ValidationMessage:String = ""
        
        if txtFullName.text == "" {
            ValidationStatus = false
            ValidationMessage = "Please enter name!"
        } else if txtMobileNumber.text == "" {
            ValidationStatus = false
            ValidationMessage = "Please enter contact number!"
        } else if self.convertDateToString == "" {
            ValidationStatus = false
            ValidationMessage = "Please select pickup date and time!"
        } else if txtPickupLocation.text == "" {
            ValidationStatus = false
            ValidationMessage = "Please select pickup location!"
        } else if txtDropOffLocation.text == "" {
            ValidationStatus = false
            ValidationMessage = "Please select drop off location!"
        } else if self.viewFlightNumber.checkState == .checked && self.txtFlightNumber.text == "" {
            ValidationStatus = false
            ValidationMessage = "Please enter flight number!"
        } else if self.CheckArrivalTime.checkState == .checked && self.txtFlightArrivalTime.text == "" {
            ValidationStatus = false
            ValidationMessage = "Please select flight arrival time!"
        }else if paymentType == "" {
            ValidationStatus = false
            ValidationMessage = "Select Payment Type"
        }
        else if paymentType == "card" && CardID.count == 0 {
            ValidationStatus = false
            ValidationMessage = "Please Select Card or Change the Payment Method"
        }
        
        return (ValidationMessage,ValidationStatus)
    }
    
    
    
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        
        let validation = self.isValidateRequest()
        if validation.1 == true {
            self.btnSubmit.isEnabled = false
//            if self.btnSelectPromocode.currentTitle != "Select Promocode" {
//                self.webServiceOfCheckPromoCode()
//            } else {
                webserviceOFBookLater()
//            }
            
        } else {
            UtilityClass.showAlert("", message: validation.0, vc: self)
        }
        
        
        //        if txtFullName.text == "" || txtMobileNumber.text == "" || txtPickupLocation.text == "" || txtDropOffLocation.text == "" || txtDataAndTimeFromCalendar.text == "" || strPassengerType == "" || paymentType == "" {
        //
        //
        //            UtilityClass.setCustomAlert(title: "Missing", message: "All fields are required...") { (index, title) in
        //            }
        //        }
        ////        else if viewMySelf.checkState == .unchecked && viewOthers.checkState == .unchecked {
        ////
        ////
        ////            UtilityClass.setCustomAlert(title: "Missing", message: "Please Checked Myself or Other") { (index, title) in
        ////            }
        ////        }
        //        else {
        //            webserviceOFBookLater()
        //        }
        
    }
    
    var validationsMobileNumber = Validation()
    var inputValidatorMobileNumber = InputValidator()
    
    func checkMobileNumber() {
        
        
        txtMobileNumber.inputType = .integer
        
        
        //        var validation = Validation()
        validationsMobileNumber.maximumLength = 10
        validationsMobileNumber.minimumLength = 10
        validationsMobileNumber.characterSet = NSCharacterSet.decimalDigits
        let inputValidator = InputValidator(validation: validationsMobileNumber)
        txtMobileNumber.inputValidator = inputValidator
        
        print("txtMobileNumber : \(txtMobileNumber.text!)")
    }
    
    var strPickupLocation = String()
    var strDropoffLocation = String()
    
    var doublePickupLat = Double()
    var doublePickupLng = Double()
    
    var doubleDropOffLat = Double()
    var doubleDropOffLng = Double()
    /// if intShareRide = 1 than ON and if intShareRide = 0 OFF
    var intShareRide:Int = 0
    let socket = SocketIOClient(socketURL: URL(string: SocketData.kBaseURL)!, config: [.log(false), .compress])
    //  MARK: - Get estimate fare
    
    func postPickupAndDropLocationForEstimateFare()
    {
//        let driverID = aryOfOnlineCarsIds.compactMap{ $0 }.joined(separator: ",")
        
        var myJSON = ["PassengerId" : SingletonClass.sharedInstance.strPassengerID,  "PickupLocation" : strPickupLocation ,"PickupLat" :  doublePickupLat , "PickupLong" :  self.doublePickupLng, "DropoffLocation" : strDropoffLocation,"DropoffLat" : self.doubleDropOffLat, "DropoffLon" : self.doubleDropOffLng,"Ids" : SingletonClass.sharedInstance.strOnlineDriverID, "ShareRiding": intShareRide ] as [String : Any]
        
        if(strDropoffLocation.count == 0)
        {
            myJSON = ["PassengerId" : SingletonClass.sharedInstance.strPassengerID,  "PickupLocation" : strPickupLocation ,"PickupLat" :  self.doublePickupLat , "PickupLong" :  self.doublePickupLng, "DropoffLocation" : strPickupLocation,"DropoffLat" : self.doubleDropOffLng, "DropoffLon" : self.doubleDropOffLng,"Ids" : SingletonClass.sharedInstance.strOnlineDriverID, "ShareRiding": intShareRide] as [String : Any]
        }
        socket.emit(SocketData.kSendRequestForGetEstimateFare , with: [myJSON])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // Change `2.0` to the desired number of seconds.
           // Code you want to be delayed
            if SingletonClass.sharedInstance.aryEstimateFareData.count != 0 {
                
                var EstimateFare:String = ""
                if let indexPath = SingletonClass.sharedInstance.selectedIndexPath {
                    if let fareRange = (SingletonClass.sharedInstance.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "estimate_fare_range") as? String {
    //                    cell.lblPrices.text = fareRange
                        self.txtEstimatedFare.text = fareRange
                    }
        //                    if ((self.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "duration") as? NSNull) != nil {
        //                        if EstimateFare != "" {
        //                            cell.lblMinutes.text = "\(currencySign)\(EstimateFare) - \(0.00) min"
        //                        }
        //                    }
        //                    else if
                    if let minute = (SingletonClass.sharedInstance.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "duration") as? Int {
    //                    cell.lblMinutes.text = "\(minute) min ETA"
                        self.txtDriverAwayTime.text =  "\(minute) min"
                    }
                    
                    if let strAvilCAR = (SingletonClass.sharedInstance.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "available_driver") as? Int {
                        
                        if let strDistance = (SingletonClass.sharedInstance.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "km") as? Double {
                            if strAvilCAR == 0 {
                                self.txtDriverAwayKm.text = "Distance \(0) km"
                            }else {
                                self.txtDriverAwayKm.text = "Distance \(strDistance) km"
                            }
                        }
                        //
                        
                    }
                    
                  
                }
    //
              
    //                    if (intShareRide == 1) {
    //
    //                        if let ride = (self.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "share_ride") as? String {
    //
    //                            if ride == "1" {
    //                                cell.contentView.isUserInteractionEnabled = true
    //                            }
    //                            else if ride == "0" {
    //
    //                            }
    //                        }
    //                    }
            }
        }

    }
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        if BoolCurrentLocation {
            txtPickupLocation.text = place.formattedAddress
            strPickupLocation = place.formattedAddress!
            doublePickupLat = place.coordinate.latitude
            doublePickupLng = place.coordinate.longitude
            
        }else {
            txtDropOffLocation.text = place.formattedAddress
            strDropoffLocation = place.formattedAddress!
            doubleDropOffLat = place.coordinate.latitude
            doubleDropOffLng = place.coordinate.longitude
        }
        postPickupAndDropLocationForEstimateFare()
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
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
            
            //            self.txtCurrentLocation.text = "No current place"
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
        //        visa , mastercard , amex , diners , discover , jcb , other
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
        
        //        txtSelectPaymentMethod.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(self.IQKeyboardmanagerDoneMethod))
    }
    
    
    
    //-------------------------------------------------------------
    // MARK: - PickerView Methods
    //-------------------------------------------------------------
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //        if pickerView == pickerViewForInvoiceType {
        //            return InvoiceTypes.count
        //        }
        return aryCards.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    //    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    //
    //    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        //        if pickerView == pickerViewForInvoiceType {
        //
        //            let myView = UIView(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height: 60))
        //            let myLabel = UILabel(frame: CGRect(x:10, y: 5, width:UIScreen.main.bounds.width - 20, height:50 ))
        //            myLabel.font = UIFont.systemFont(ofSize: 30)
        //            myLabel.text = self.InvoiceTypes[row]
        //            myLabel.textAlignment = .center
        //            myView.addSubview(myLabel)
        //
        //            return myView
        //        }
        //
        
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
        //        myLabel.font = UIFont(name:some, font, size: 18)
        myLabel.text = rowString
        
        myView.addSubview(myLabel)
        myView.addSubview(myImageView)
        
        return myView
    }
    
    var isAddCardSelected = Bool()



    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == self.pickerViewForInvoiceType {
            
            
        } else {
            
            
            let data = aryCards[row]
            
            if data["CardNum"] as! String == "Add a Card" {
                
                isAddCardSelected = true
//                self.addNewCard()
                return
                //            self.addNewCard()
            }
            
//            imgPaymentOption.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
//            txtSelectPaymentMethod.text = data["CardNum2"] as? String

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
        
        // do something with selected row
    }
    
    @IBAction func selectPaymentOption(_ sender: UIButton)
    {

//        sender.isSelected = !sender.isSelected
        imgCashForPaymentType.isHighlighted = false
        lblCashTitle.isHighlighted = false
        imgWalletForPaymentType.isHighlighted = false
        lblWalletTitle.isHighlighted = false
        imgCardForPaymentType.isHighlighted = false
        lblCardTitle.isHighlighted = false
        lblWalletTitle.text = "Wallet"
        if(sender.tag == 1)
        {
            paymentType = "cash"
            imgCashForPaymentType.isHighlighted = true
            lblCashTitle.isHighlighted = true
        }
        else if(sender.tag == 2)
        {
            paymentType = "wallet"
            imgWalletForPaymentType.isHighlighted = true
            lblWalletTitle.isHighlighted = true
            lblWalletTitle.text = "Wallet\n\(SingletonClass.sharedInstance.strCurrentBalance)"

        }
        else if(sender.tag == 3)
        {
            paymentType = "card"
            imgCardForPaymentType.isHighlighted = true
            lblCardTitle.isHighlighted = true


            if(self.aryCards.count == 0)
            {
                addNewCard()

            }
            else
            {
                selectExistingCard()
            }
        }
        
    }
    
    func didSelectCard(dictData: [String : AnyObject]) {

            if let strCardNumber = dictData["CardNum2"] as? String
            {
                if let lastComponent = strCardNumber.components(separatedBy: " ").last
                {
                    self.lblCardTitle.text = lastComponent
                    CardID = dictData["Id"] as? String ?? ""
                }
            }

    }
    func addNewCard() {
//        let WalletSB = UIStoryboard(name: "Wallet", bundle: nil)
        let next = self.storyboard!.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
        next.delegateAddCardFromBookLater = self
        self.isAddCardSelected = false
        self.navigationController?.pushViewController(next, animated: true)//present(next, animated: true, completion: nil)
    }

    func selectExistingCard() {
//        let WalletSB = UIStoryboard(name: "Wallet", bundle: nil)
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
    
    var currentDate = Date()
    
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
                    // get the date string applied date format
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
                UtilityClass.setCustomAlert(title: "Invalid Request", message: "System Does Not Accept Prebook Option If Pick Up Time Is Within 30 Minutes.") { (index, title) in
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
    
    //PassengerId,ModelId,PickupLocation,DropoffLocation,PassengerType(myself,other),PassengerName,PassengerContact,PickupDateTime,FlightNumber,
    //PromoCode,Notes,PaymentType,CardId(If paymentType is card)
    
    func webServiceOfCheckPromoCode() {
        if Connectivity.isConnectedToInternet() == false {
            
                        UtilityClass.setCustomAlert(title: "Connection Error", message: "Internet connection not available") { (index, title) in
            }
            return
        }
        var dictData = [String:AnyObject]()
        
//        if self.btnSelectPromocode.currentTitle != "Select Promocode" {
//            if let Promodetail:String = self.btnSelectPromocode.currentTitle {
//                let promocode = Promodetail.components(separatedBy: " ")[0]
//                dictData["PromoCode"] = promocode as AnyObject
//            }
//        }
        if let strPromocode = txtPromoCode.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        {
            
            dictData["PromoCode"] = strPromocode as AnyObject
            webserviceForCheckPromocode(dictData as AnyObject) { (result, status) in
                if (status) {
//                    self.webserviceOFBookLater()
                    //                self.lblPromoCode.text = self.txtPromoCode.text
                    //                self.lblPromoCode.isHidden = false
                    
                    let mySelectedAttributedTitle = NSAttributedString(string: "Promocode Applied \(self.txtPromoCode.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")",
                        attributes: [NSAttributedString.Key.foregroundColor : UIColor.green])
                    self.btnSelectPromocode.setAttributedTitle(mySelectedAttributedTitle, for: .normal)
                    self.btnSelectPromocode.setTitle("Promocode Applied \(self.txtPromoCode.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")", for: .normal)
                    self.viewProocode.isHidden = true
                    self.btnCancelPromocode.isHidden = false
                    self.strAppliedPromocode = self.txtPromoCode.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                } else {
                    self.btnSubmit.isEnabled = true
                    print(result)
                    //                self.lblPromoCode.text = ""
                    //                self.lblPromoCode.isHidden = true
                    if let res = result as? String {
                        UtilityClass.setCustomAlert(title: "Error", message: res) { (index, title) in }
                    }
                    else if let resDict = result as? [String:Any] {
                        UtilityClass.setCustomAlert(title: "Error", message: resDict["message"] as! String) { (index, title) in }
                    }
                    else if let resAry = result as? NSArray {
                        UtilityClass.setCustomAlert(title: "Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in }
                    }
                    
                }
                self.txtPromoCode.text = ""

            }
        }
    
    }
    
    func webserviceOFBookLater() {
        if Connectivity.isConnectedToInternet() == false {
            
            UtilityClass.setCustomAlert(title: "Connection Error", message: "Internet connection not available") { (index, title) in
            }
            return
        }
        var dictData = [String:AnyObject]()
        /*  dictData["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
         dictData["ModelId"] = strModelId as AnyObject
         dictData["PickupLocation"] = txtPickupLocation.text as AnyObject
         dictData["DropoffLocation"] = txtDropOffLocation.text as AnyObject
         dictData["PassengerType"] = strPassengerType as AnyObject
         dictData["PassengerName"] = txtFullName.text as AnyObject
         dictData["PassengerContact"] = txtMobileNumber.text as AnyObject
         dictData["PickupDateTime"] = convertDateToString as AnyObject
         //        dictData["NoOfPassenger"] = self.btnNumberOfPassenger.currentTitle as AnyObject
         dictData["ReceiptType"] = self.ReceiptType as AnyObject
         
         if self.strAppliedPromocode.trimmingCharacters(in: .whitespacesAndNewlines).count != 0 {
         if let Promodetail:String = self.strAppliedPromocode.trimmingCharacters(in: .whitespacesAndNewlines) {
         let promocode = Promodetail.components(separatedBy: " ")[0]
         dictData["PromoCode"] = promocode as AnyObject
         }
         }
         
         dictData["Notes"] = txtDescription.text as AnyObject
         
         if paymentType == "" {
         
         UtilityClass.setCustomAlert(title: "Missing", message: "Select Payment Type") { (index, title) in
         }
         
         return
         }
         else {
         dictData["PaymentType"] = paymentType as AnyObject
         }
         
         if CardID == "" {
         
         }
         else {
         dictData["CardId"] = CardID as AnyObject
         }
         
         if txtFlightNumber.text!.count == 0 {
         
         dictData["FlightNumber"] = "" as AnyObject
         }
         else {
         dictData["FlightNumber"] = txtFlightNumber.text as AnyObject
         
         } */
        
        if let dict = self.dictSelectedDriver {
            if let strDriverID = dict["DriverId"] as? String {
                dictData["DriverId"] = strDriverID as AnyObject
                //                dictData.setObject(strDriverID, forKey: "DriverId" as NSCopying)
            }
            if let strDriverID = dict["DriverId"] as? Int {
                dictData["DriverId"] = strDriverID as AnyObject
                //                dictData.setObject(strDriverID, forKey: "DriverId" as NSCopying)
            }
        }
        dictData["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
        dictData["ModelId"] = strModelId as AnyObject
        dictData["PickupLocation"] = txtPickupLocation.text as AnyObject
        dictData["DropoffLocation"] = txtDropOffLocation.text as AnyObject
        dictData["PassengerType"] = strPassengerType as AnyObject
        dictData["PassengerName"] = txtFullName.text as AnyObject
        dictData["PassengerContact"] = txtMobileNumber.text as AnyObject
        dictData["PickupDateTime"] = convertDateToString as AnyObject
        
        
        dictData["PickupLat"] = doublePickupLat as AnyObject
        dictData["PickupLng"] = doublePickupLng as AnyObject
        dictData["DropOffLat"] = doubleDropOffLat as AnyObject
        dictData["DropOffLon"] = doubleDropOffLng as AnyObject
        
        if lblPromoCode.text == "" {
            
        }
        else {
            dictData["PromoCode"] = lblPromoCode.text as AnyObject
        }
        
        dictData["Notes"] = txtDescription.text as AnyObject
        
        if paymentType == "" {
            
            UtilityClass.setCustomAlert(title: "Missing", message: "Select Payment Type") { (index, title) in
            }
        }
        else {
            dictData["PaymentType"] = paymentType as AnyObject
        }
        
        if CardID == "" {
        }
        else {
            dictData["CardId"] = CardID as AnyObject
        }
        
        if txtFlightNumber.text!.count == 0 {
            dictData["FlightNumber"] = "" as AnyObject
        }
        else {
            dictData["FlightNumber"] = txtFlightNumber.text as AnyObject
        }
        
        print("book later.. \(dictData)")
        webserviceForBookLater(dictData as AnyObject) { (result, status) in
            self.btnSubmit.isEnabled = true
            if (status) {
                print(result)
                
                UtilityClass.setCustomAlert(title: "Success Message", message: "Thanks For Prebooking With \(appName).\nIf your plans change please cancel your booking.", completionHandler: { (index, title) in
                    self.BookLaterCompleted.BookLaterComplete()
                    self.navigationController?.popViewController(animated: true)
                })
                
                /*
                 {
                 info =     {
                 BookingFee = "2.2";
                 Duration = 27;
                 EstimatedFare = "43.28";
                 GrandTotal = "45.48";
                 Id = 1;
                 KM = "9.6";
                 SubTotal = "43.28";
                 Tax = "4.548";
                 };
                 status = 1;
                 }
                 */
                
            } else {
                
                print(result)
                
                //                if let res = result as? String {
                //                    UtilityClass.setCustomAlert(title: alertTitle, message: res) { (index, title) in
                //                    }
                //                }
                //                else if let resDict = result as? NSDictionary {
                //                    UtilityClass.setCustomAlert(title: alertTitle, message: resDict.object(forKey: "message") as! String) { (index, title) in
                //                    }
                //                }
                //                else if let resAry = result as? NSArray {
                //                    UtilityClass.setCustomAlert(title: alertTitle, message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                //                    }
                //                }
                
                
                print(result)
                
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
                
                
                //                UtilityClass.showAlertOfAPIResponse(param: result, vc: self)
            }
        }
        
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    var aryCards = [[String:AnyObject]]()
    
    func webserviceOfCardList(setCardInButton : Bool) {
        if Connectivity.isConnectedToInternet() == false {
            
            UtilityClass.setCustomAlert(title: "Connection Error", message: "Internet connection not available") { (index, title) in
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
                                        self.lblCardTitle.text = lastComponent
                                        self.CardID = arrCards[0]["Id"] as? String ?? ""
                                    }
                                }
                            }
                        }
                    }
                }


                /*
                var dict = [String:AnyObject]()
                dict["CardNum"] = "cash" as AnyObject
                dict["CardNum2"] = "cash" as AnyObject
                dict["Type"] = "iconCashBlack" as AnyObject
                
                var dict2 = [String:AnyObject]()
                dict2["CardNum"] = "wallet" as AnyObject
                dict2["CardNum2"] = "wallet" as AnyObject
                dict2["Type"] = "iconWalletBlack" as AnyObject
                
                
                self.aryCards.append(dict)
                self.aryCards.append(dict2)
                
                if self.aryCards.count == 2 {
                    var dict3 = [String:AnyObject]()
                    dict3["Id"] = "000" as AnyObject
                    dict3["CardNum"] = "Add a Card" as AnyObject
                    dict3["CardNum2"] = "Add a Card" as AnyObject
                    dict3["Type"] = "iconPlusBlack" as AnyObject
                    self.aryCards.append(dict3)
                    
                }
                
//                self.pickerView.selectedRow(inComponent: 0)
                let data = self.aryCards[0]
                
//                self.imgPaymentOption.image = UIImage(named: self.setCardIcon(str: data["Type"] as! String))
//                self.txtSelectPaymentMethod.text = data["CardNum2"] as? String

                let type = data["CardNum"] as! String
                
                if type  == "wallet" {
                    self.paymentType = "wallet"
                }
                else if type == "cash" {
                    self.paymentType = "cash"
                }
                else {
                    self.paymentType = "card"
                }
                if self.paymentType == "card" {
                    
                    if data["Id"] as? String != "" {
                        self.CardID = data["Id"] as! String
                    }
                }
 */
                
            }
            else {
                print(result)
//                if let res = result as? String {
//                    UtilityClass.setCustomAlert(title: alertTitle, message: res) { (index, title) in
//                    }
//                }
//                else if let resDict = result as? NSDictionary {
//                    UtilityClass.setCustomAlert(title: alertTitle, message: resDict.object(forKey: "message") as! String) { (index, title) in
//                    }
//                }
//                else if let resAry = result as? NSArray {
//                    UtilityClass.setCustomAlert(title: alertTitle, message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
//                    }
//                }
                
                
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
                //                if let res = result as? String {
                //                    UtilityClass.setCustomAlert(title: alertTitle, message: res) { (index, title) in
                //                    }
                //                }
                //                else if let resDict = result as? NSDictionary {
                //                    UtilityClass.setCustomAlert(title: alertTitle, message: resDict.object(forKey: "message") as! String) { (index, title) in
                //                    }
                //                }
                //                else if let resAry = result as? NSArray {
                //                    UtilityClass.setCustomAlert(title: alertTitle, message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                //                    }
                //                }
            }
        }
    }
    
    @IBAction func btnClearCurrentLocation(_ sender: UIButton) {
        txtPickupLocation.text = ""
    }
    
    @IBAction func btnClearDropOffLocation(_ sender: UIButton) {
        txtDropOffLocation.text = ""
    }
    
    
}

// Delegates to handle events for the location manager.
extension BookLaterViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
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

/*
import UIKit
import M13Checkbox
import GoogleMaps
import GooglePlaces
import SDWebImage
import FormTextField
import ACFloatingTextfield_Swift
import IQKeyboardManagerSwift

protocol isHaveCardFromBookLaterDelegate {
    func didHaveCards()
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}


class BookLaterViewController: BaseViewController, GMSAutocompleteViewControllerDelegate, UINavigationControllerDelegate, WWCalendarTimeSelectorProtocol, UIPickerViewDelegate, UIPickerViewDataSource, isHaveCardFromBookLaterDelegate, UITextFieldDelegate,GMSMapViewDelegate {
   
    var delegateBookLater : deleagateForBookTaxiLater!
    var mapView : GMSMapView?
    var pickerView = UIPickerView()
    var strModelId = String()
    var BoolCurrentLocation = Bool()
    var strCarModelURL = String()
    var strPassengerType = String()
    var convertDateToString = String()
    var boolIsSelected = Bool()
    var boolIsSelectedNotes = Bool()
    var strCarName = String()
    
    var strFullname = String()
    var strMobileNumber = String()
    
    var placesClient = GMSPlacesClient()
    var locationManager = CLLocationManager()
    
    var aryOfPaymentOptionsNames = [String]()
    var aryOfPaymentOptionsImages = [String]()
    
    @IBOutlet var lblapplyPromoTitle: UILabel!
    var CardID = String()
    var paymentType = String()
    
    var selector = WWCalendarTimeSelector.instantiate()
    
    @IBOutlet var lblFlightnum: UILabel!
    @IBOutlet var btnhavePromoCode: UIButton!
    @IBOutlet var lblYouhaveToNotified: UILabel!
    @IBOutlet var lblSelectPaymentMethod: UILabel!
    @IBOutlet var lblNotes: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLocalization()
        mapView = GMSMapView()
        mapView?.delegate = self
        
        txtSelectPaymentMethod.delegate = self
        txtDropOffLocation.delegate = self
        
        txtSelectPaymentMethod.inputView = pickerView

        
        
//        txtSelectPaymentMethod.text = "Cash"
//        txtSelectPaymentMethod.isUserInteractionEnabled = false
        self.setNavBarWithBack(Title: "Book Later".localized, IsNeedRightButton: false)
//        UIApplication.shared.statusBarView?.backgroundColor = UIColor.black
         self.navigationItem.title = "Book Later".localized
         

        if #available(iOS 11.0, *) {
            if (UIApplication.shared.keyWindow?.safeAreaInsets.top)! > 0.0 {
                
                print("iPhone X")
            }
            else {
                print("Not iPhone X ")
            }
        } else {
            // Fallback on earlier versions
        }
    
        txtDropOffLocation.text = strDropoffLocation

        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        txtFullName.leftView = paddingView
        txtFullName.leftViewMode = .always
        
        
        selector.delegate = self
//        alertView.removeFromSuperview()
        
//        btnForMySelfAction.addTarget(self, action: #selector(self.ActionForViewMySelf), for: .touchUpInside)
//        
//        btnForOthersAction.addTarget(self, action: #selector(self.ActionForViewOther), for: .touchUpInside)
        
        viewProocode.isHidden = true
        

        
//        webserviceOfCardList()
        
        pickerView.delegate = self
        
        aryOfPaymentOptionsNames = [""]
        aryOfPaymentOptionsImages = [""]
        
        locationManager.startUpdatingLocation()
        locationManager.delegate = self

        setViewDidLoad()
        
        txtDataAndTimeFromCalendar.isUserInteractionEnabled = false
        imgCareModel.sd_setImage(with: URL(string: strCarModelURL), completed: nil)
        let strCardLoca = "Car Model:".localized
        lblCareModelClass.text = "\(strCardLoca): \(strCarName)"
        
        txtFullName.text = strFullname
        txtMobileNumber.text = strMobileNumber

        checkMobileNumber()
        
        gaveCornerRadius()
        fillTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if SingletonClass.sharedInstance.CardsVCHaveAryData.count != 0 {
//            pickerView.reloadAllComponents()
//            txtSelectPaymentMethod.text = ""
//            imgPaymentOption.image = UIImage(named: "iconDummyCard")
////            paymentType = "cash"
//           pickerView.selectedRow(inComponent: 0)
//            txtSelectPaymentMethod.becomeFirstResponder()
//            txtSelectPaymentMethod.resignFirstResponder()
//
//        }
//
//       txtSelectPaymentMethod.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(self.IQKeyboardmanagerDoneMethod))
//
//        getPlaceFromLatLong()
        
        self.lblPromoCode.isHidden = true
        self.btnhavePromoCode.isHidden = true
        
        
        self.txtPromoCode.isHidden = true
        
        self.constantHavePromoCodeTop.constant = 0
        
    }
    
    func setLocalization()
    {
        lblCareModelClass.text = "Car Model:".localized
        txtPickupLocation.placeholder = "Pickup Location".localized
        txtDropOffLocation.placeholder = "Dropoff Location".localized
        txtFullName.placeholder = "Full Name".localized
        txtMobileNumber.placeholder = "Phone Number".localized
        txtDataAndTimeFromCalendar.placeholder = "Click calendar icon to select pickup time".localized
        txtFlightNumber.placeholder = "Flight Number".localized
        lblFlightnum.text = "Flight Number (If applicable)".localized
        lblNotes.text = "Notes (Optional)".localized
        txtDescription.placeholder = "Notes (Optional)".localized
        btnhavePromoCode.setTitle("Have a promocode?".localized, for: .normal)
        lblSelectPaymentMethod.text = "Select Payment Method".localized
        txtSelectPaymentMethod.placeholder = "Select Payment Method".localized
        btnSubmit.setTitle("Submit".localized, for: .normal)
       lblYouhaveToNotified.text =   "You will be notified with your driver detail after your request is submitted.".localized
        
        btnhavePromoCode.setTitle("Have a promocode?".localized, for: .normal)
        
        lblapplyPromoTitle.text = "Apply Promocode".localized
        txtPromoCode.placeholder = "Enter Promocode".localized
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fillTextFields() {
        txtPickupLocation.text = strPickupLocation
        txtDropOffLocation.text = strDropoffLocation
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
        
//        let themeColor: UIColor = UIColor.init(red: 255/255, green: 163/255, blue: 0, alpha: 1.0)
        
//        viewMySelf.tintColor = themeYellowColor
//        viewOthers.tintColor = themeYellowColor
        viewFlightNumber.tintColor = themeYellowColor
        btnNotes.tintColor = themeYellowColor
        
        
//        viewMySelf.stateChangeAnimation = .fill
//        viewOthers.stateChangeAnimation = .fill
        viewFlightNumber.stateChangeAnimation = .fill
        btnNotes.stateChangeAnimation = .fill
        
//        viewMySelf.boxType = .square
//
//        viewMySelf.checkState = .checked
//        viewOthers.boxType = .square
        btnNotes.boxType = .square
        strPassengerType = "myself"
        viewFlightNumber.boxType = .square
        
        constraintsHeightOFtxtFlightNumber.constant = 0 // 30 Height
        constaintsOfTxtFlightNumber.constant = 0
        imgViewLineForFlightNumberHeight.constant = 0
        
        constantHavePromoCodeTop.constant = 0
        constantNoteHeight.constant = 0
        imgViewLineForFlightNumberHeight.constant = 0
        imgViewLineForNotesHeight.constant = 0
        
        txtFlightNumber.isHidden = true
        txtFlightNumber.isEnabled = false
        txtDescription.isEnabled = false
        
        
        alertView.layer.cornerRadius = 10
        alertView.layer.masksToBounds = true
        
        txtDataAndTimeFromCalendar.layer.borderWidth = 1
        txtDataAndTimeFromCalendar.layer.cornerRadius = 5
        txtDataAndTimeFromCalendar.layer.borderColor = UIColor.black.cgColor
        txtDataAndTimeFromCalendar.layer.masksToBounds = true
        
        
        viewPaymentMethod.layer.borderWidth = 1
        viewPaymentMethod.layer.cornerRadius = 5
        viewPaymentMethod.layer.borderColor = UIColor.black.cgColor
        viewPaymentMethod.layer.masksToBounds = true
        
        btnSubmit.layer.cornerRadius = 10
        btnSubmit.layer.masksToBounds = true
        
//        viewCurrentLocation.layer.shadowOpacity = 0.3
//        viewCurrentLocation.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
//        viewDestinationLocation.layer.shadowOpacity = 0.3
//        viewDestinationLocation.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    @IBOutlet weak var viewProocode: UIView!
    @IBOutlet weak var btnSubmit: ThemeButton!
    
    
//    @IBOutlet weak var viewMySelf: M13Checkbox!
//    @IBOutlet weak var viewOthers: M13Checkbox!
    @IBOutlet weak var viewFlightNumber: M13Checkbox!
    
    @IBOutlet weak var viewDestinationLocation: UIView!
    @IBOutlet weak var viewCurrentLocation: UIView!
    
    @IBOutlet weak var lblMySelf: UILabel!
    @IBOutlet weak var lblOthers: UILabel!
    
    @IBOutlet weak var lblCareModelClass: UILabel!
    @IBOutlet weak var imgCareModel: UIImageView!
    
    @IBOutlet weak var txtPickupLocation: UITextField!
    @IBOutlet weak var txtDropOffLocation: UITextField!
    
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtMobileNumber: FormTextField!
    @IBOutlet weak var txtDataAndTimeFromCalendar: UITextField!
    @IBOutlet weak var btnCalendar: UIButton!
 
    @IBOutlet weak var txtFlightNumber: UITextField!
    @IBOutlet weak var constraintsHeightOFtxtFlightNumber: NSLayoutConstraint!
    @IBOutlet weak var constaintsOfTxtFlightNumber: NSLayoutConstraint! // 10
    
    @IBOutlet weak var txtSelectPaymentMethod: UITextField!
    @IBOutlet weak var imgPaymentOption: UIImageView!
    
    @IBOutlet weak var btnNotes: M13Checkbox!
    
    @IBOutlet weak var constantNoteHeight: NSLayoutConstraint!  // 40
    
    @IBOutlet weak var constantHavePromoCodeTop: NSLayoutConstraint!  // 10
    
    @IBOutlet weak var txtPromoCode: UITextField!
    
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet var alertView: UIView!
    @IBOutlet weak var viewPaymentMethod: UIView!
    
    @IBOutlet weak var lblPromoCode: UILabel!
    var BackView = UIView()
    
    @IBOutlet weak var btnForMySelfAction: UIButton!
    @IBOutlet weak var btnForOthersAction: UIButton!
    
    @IBOutlet weak var imgViewLineForFlightNumberHeight: NSLayoutConstraint!
    @IBOutlet weak var imgViewLineForNotesHeight: NSLayoutConstraint!
    
    
    //-------------------------------------------------------------
    // MARK: - Button Actions
    //-------------------------------------------------------------
    
    @IBAction func btnApply(_ sender: UIButton)
    {
        
        let strPromo = txtPromoCode.text
        //        let strFinalPromo = "\(strPromo!)/\(SingletonClass.sharedInstance.strEstimatedFare)"
        //        self.strAppliedPromoCode = strPromo!
        
        var dictData = [String : AnyObject]()
        dictData["PromoCode"] = strPromo as AnyObject
        if !(UtilityClass.isEmpty(str: strPromo))
        {
            webserviceForValidPromocode(dictData as AnyObject, showHUD: true) { (result, status) in
                if status
                {
                    print(result)
                    
                    self.lblPromoCode.text = self.txtPromoCode.text
                    
                    self.viewProocode.isHidden = true
                    
//                    let strNewAmount = result["new_estimate_fare"] as! String
//                    let text = "Estimated Fare is $\(SingletonClass.sharedInstance.strEstimatedFare)   $\(strNewAmount)"
//                    let range = (text as NSString).range(of: "$\(SingletonClass.sharedInstance.strEstimatedFare)")
//                    let attributedString1 = NSMutableAttributedString(string:text)
//                    attributedString1.addAttributes([NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue], range: range)
//                    self.lblEstimatedFare.attributedText = attributedString1
//
//                    let dict =  result["promocode"] as! NSDictionary
//
//                    self.strPromoCodeDiscountType = dict.object(forKey: "DiscountType") as! String
//                    self.strPromoCodeDiscountValue = "\((dict.object(forKey: "DiscountValue")!))"
                    
                }
                else
                {
                    print(result)
                   
                    if let res = result as? String
                    {
                        if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                            if SelectedLanguage == "en"
                            {
                                UtilityClass.showAlert("Error", message: res, vc: self)
                                
                            }
                            else if SelectedLanguage == "sw"
                            {
                                UtilityClass.showAlert("Error", message: res, vc: self)
                            }
                        }
                    }
                    else if let resDict = result as? NSDictionary
                    {
                        
                        
                        if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                            if SelectedLanguage == "en"
                            {
                                UtilityClass.showAlert("Error", message: resDict.object(forKey: "message") as! String, vc: self)
                                
                            }
                            else if SelectedLanguage == "sw"
                            {
                                UtilityClass.showAlert("Error", message: resDict.object(forKey: "swahili_message") as! String, vc: self)
                            }
                        }
                    }
                    else if let resAry = result as? NSArray
                    {
                        
                        if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                            if SelectedLanguage == "en"
                            {
                               UtilityClass.showAlert("Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                                
                            }
                            else if SelectedLanguage == "sw"
                            {
                                UtilityClass.showAlert("Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "swahili_message") as! String, vc: self)
                            }
                        }
                    }
                }
            }
        }
        
        
    }
    @IBAction func btnCancel(_ sender: UIButton) {
        
        viewProocode.isHidden = true
        
        txtPromoCode.text = ""
//        self.view.alpha = 1.0
//        BackView.removeFromSuperview()
//        alertView.removeFromSuperview()
    }
    
    @IBAction func btnHavePromoCode(_ sender: UIButton) {
        
        txtPromoCode.becomeFirstResponder()
        viewProocode.isHidden = false
        
     
        
        
//        UIApplication.shared.keyWindow!.bringSubview(toFront: alertView)
    }
    
    @IBAction func btnNotes(_ sender: M13Checkbox) {
        
        boolIsSelectedNotes = !boolIsSelectedNotes
        
        if (boolIsSelectedNotes) {
            
            constantNoteHeight.constant = 40
            constantHavePromoCodeTop.constant = 10
            imgViewLineForNotesHeight.constant = 1
            txtSelectPaymentMethod.isHidden = false
             txtDescription.isEnabled = true
        }
        else {
            
            constantNoteHeight.constant = 0
            constantHavePromoCodeTop.constant = 0
            imgViewLineForNotesHeight.constant = 0
            txtSelectPaymentMethod.isHidden = true
            txtDescription.isEnabled = false

        }
        
    }
    @IBAction func txtSelectPaymentMethod(_ sender: UITextField) {
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        
    self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func viewMySelf(_ sender: M13Checkbox) {
        ActionForViewMySelf()
    }
    
    @objc func ActionForViewMySelf() {
        
//        viewMySelf.checkState = .checked
//        viewOthers.checkState = .unchecked
//        viewMySelf.stateChangeAnimation = .fill
//
//        txtFullName.text = strFullname
//        txtMobileNumber.text = strMobileNumber
//
//        strPassengerType = "myself"
        
    }
    
    @objc func ActionForViewOther() {
//        viewMySelf.checkState = .unchecked
//        viewOthers.checkState = .checked
//        viewOthers.stateChangeAnimation = .fill
//
//        txtFullName.text = ""
//        txtMobileNumber.text = ""
//
//        strPassengerType = "other"
    }
    
    @IBAction func viewOthers(_ sender: M13Checkbox) {
        ActionForViewOther()
        
    }
    
    @IBAction func viewFlightNumber(_ sender: M13Checkbox) {
        
        boolIsSelected = !boolIsSelected
        
        if (boolIsSelected) {
            
            constraintsHeightOFtxtFlightNumber.constant = 40
            constaintsOfTxtFlightNumber.constant = 10
            imgViewLineForFlightNumberHeight.constant = 1
            txtFlightNumber.isHidden = false
            txtFlightNumber.isEnabled = true
        }
        else {
            
            constraintsHeightOFtxtFlightNumber.constant = 0
            constaintsOfTxtFlightNumber.constant = 0
            imgViewLineForFlightNumberHeight.constant = 0
            txtFlightNumber.isHidden = true
            txtFlightNumber.isEnabled = false
           
        }
    }
    
    @IBAction func txtPickupLocation(_ sender: UITextField) {

        let visibleRegion = mapView?.projection.visibleRegion()
        var location = CLLocationCoordinate2D()
        if SingletonClass.sharedInstance.currentLatitude != nil
        {
            location = CLLocationCoordinate2DMake(Double(SingletonClass.sharedInstance.currentLatitude)!, Double(SingletonClass.sharedInstance.currentLongitude)!)
        }
        
        let bounds = GMSCoordinateBounds(coordinate: location, coordinate: location)
        
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        
        BoolCurrentLocation = true
        
        present(acController, animated: true, completion: nil)
        
    }
    @IBAction func txtDropOffLocation(_ sender: UITextField) {
        
        
        let visibleRegion = mapView?.projection.visibleRegion()
        var location = CLLocationCoordinate2D()
        if SingletonClass.sharedInstance.currentLatitude != nil
        {
            location = CLLocationCoordinate2DMake(Double(SingletonClass.sharedInstance.currentLatitude)!, Double(SingletonClass.sharedInstance.currentLongitude)!)
        }
        
        let bounds = GMSCoordinateBounds(coordinate: location, coordinate: location)
        
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        
        BoolCurrentLocation = false
        
        present(acController, animated: true, completion: nil)
        
    }
    
    @IBAction func btnCalendar(_ sender: UIButton) {
        
        selector.optionCalendarFontColorPastDates = UIColor.gray

        selector.optionButtonFontColorDone = themeYellowColor
        selector.optionSelectorPanelBackgroundColor = themeYellowColor
        selector.optionCalendarBackgroundColorTodayHighlight = themeYellowColor
        selector.optionTopPanelBackgroundColor = themeYellowColor
        selector.optionClockBackgroundColorMinuteHighlightNeedle = themeYellowColor
        selector.optionClockBackgroundColorHourHighlight = themeYellowColor
        selector.optionClockBackgroundColorAMPMHighlight = themeYellowColor
        selector.optionCalendarBackgroundColorPastDatesHighlight = themeYellowColor
        selector.optionCalendarBackgroundColorFutureDatesHighlight = themeYellowColor
        selector.optionClockBackgroundColorMinuteHighlight = themeYellowColor
        
        selector.optionButtonFontColorCancel = themeYellowColor
        
//        selector.optionStyles.showDateMonth(true)
        selector.optionStyles.showYear(false)
//        selector.optionStyles.showMonth(true)
        
        selector.optionStyles.showTime(true)
        
        // 2. You can then set delegate, and any customization options

        selector.optionTopPanelTitle = "Please choose date"
        
        selector.optionIdentifier = "Time" as AnyObject
        
        selector.optionButtonShowCancel = true

        let dateCurrent = Date()
     

        selector.optionCurrentDate = dateCurrent.addingTimeInterval(30 * 60)

        // 3. Then you simply present it from your view controller when necessary!
        self.present(selector, animated: true, completion: nil)
   
    }
    
    
    @IBAction func btnSubmit(_ sender: ThemeButton) {
        
       
        if txtFullName.text == "" || txtMobileNumber.text == "" || txtPickupLocation.text == "" || txtDropOffLocation.text == "" || txtDataAndTimeFromCalendar.text == "" || strPassengerType == "" || paymentType == ""  {
            
           
            UtilityClass.setCustomAlert(title: "Missing", message: "Please fill all the details".localized) { (index, title) in
            }
        }
//        else if viewMySelf.checkState == .unchecked && viewOthers.checkState == .unchecked {
//            
//           
//            UtilityClass.setCustomAlert(title: "Missing", message: "Please Checked Myself or Other") { (index, title) in
//            }
//        }
        else {
            webserviceOFBookLater()
        }
        
    }
    
    var validationsMobileNumber = Validation()
    var inputValidatorMobileNumber = InputValidator()
    
    func checkMobileNumber() {
        
        
        txtMobileNumber.inputType = .integer
        
        
        //        var validation = Validation()
        validationsMobileNumber.maximumLength = 10
        validationsMobileNumber.minimumLength = 10
        validationsMobileNumber.characterSet = NSCharacterSet.decimalDigits
        let inputValidator = InputValidator(validation: validationsMobileNumber)
        txtMobileNumber.inputValidator = inputValidator
        
        print("txtMobileNumber : \(txtMobileNumber.text!)")
    }
    
    var strPickupLocation = String()
    var strDropoffLocation = String()
    
    var doublePickupLat = Double()
    var doublePickupLng = Double()
    
    var doubleDropOffLat = Double()
    var doubleDropOffLng = Double()
    
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        if BoolCurrentLocation {
            let SelectedFromLocation = "\(place.name), \(place.formattedAddress!)"
            txtPickupLocation.text = SelectedFromLocation
//                place.formattedAddress
            strPickupLocation = SelectedFromLocation
//                place.formattedAddress!
            doublePickupLat = place.coordinate.latitude
            doublePickupLng = place.coordinate.longitude
            
        }
        else {
            let SelectedDestinationLocation = "\(place.name), \(place.formattedAddress!)"
            txtDropOffLocation.text = SelectedDestinationLocation
//                place.formattedAddress
            strDropoffLocation = SelectedDestinationLocation
//                place.formattedAddress!
            doubleDropOffLat = place.coordinate.latitude
            doubleDropOffLng = place.coordinate.longitude
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
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
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtSelectPaymentMethod {
            if txtSelectPaymentMethod.text == "card" {
                self.addNewCard()
            }
            
//            if textField.text == ""
        }
    }
    
    
    func getPlaceFromLatLong()
    {
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            //            self.txtCurrentLocation.text = "No current place"
            self.txtPickupLocation.text = ""
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    let SelectedFromLocation = "\(place.name), \(place.formattedAddress!)"
                    self.strPickupLocation = SelectedFromLocation
//                        place.formattedAddress!
                    self.doublePickupLat = place.coordinate.latitude
                    self.doublePickupLng = place.coordinate.longitude
                    self.txtPickupLocation.text = SelectedFromLocation
//                        place.formattedAddress?.components(separatedBy: ", ")
//                        .joined(separator: "\n")
                }
            }
        })
    }
    
    func setCardIcon(str: String) -> String {
//        visa , mastercard , amex , diners , discover , jcb , other
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
        case "icon_SelectedCash":
            CardIcon = "icon_SelectedCash"
            return CardIcon
        case "icon_SelectedCard":
            CardIcon = "icon_SelectedCard"
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
//        webserviceOfCardList()
    }
    
    @objc func IQKeyboardmanagerDoneMethod() {
        
        if (isAddCardSelected) {
             self.addNewCard()
        }
        
//        txtSelectPaymentMethod.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(self.IQKeyboardmanagerDoneMethod))
    }
    
  
    
    //-------------------------------------------------------------
    // MARK: - PickerView Methods
    //-------------------------------------------------------------
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return aryCards.count
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
  
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
//        let data = aryCards[row]
        
        let myView = UIView(frame: CGRect(x:0, y:0, width: pickerView.bounds.width - 30, height: 60))
        
        let centerOfmyView = myView.frame.size.height / 4
        
        let myImageView = UIImageView(frame: CGRect(x:0, y:centerOfmyView, width:40, height:26))
        myImageView.contentMode = .scaleAspectFit
        
        var rowString = String()
        
        switch row {
            
        case 0:
//            rowString = data["CardNum2"] as! String
//            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
            rowString = "Select"
            
        case 1:
//            rowString = data["CardNum2"] as! String
//            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
            rowString = "Cash"
            myImageView.image = UIImage(named: "icon_CashUnselected")
            
            
            
        case 2:
            rowString = "M-Pesa"
            myImageView.image = UIImage(named: "icon_UnselectedCard")
//            rowString = data["CardNum2"] as! String
//            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
//        case 3:
//            rowString = data["CardNum2"] as! String
//            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
//        case 4:
//            rowString = data["CardNum2"] as! String
//            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
//        case 5:
//            rowString = data["CardNum2"] as! String
//            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
//        case 6:
//            rowString = data["CardNum2"] as! String
//            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
//        case 7:
//            rowString = data["CardNum2"] as! String
//            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
//        case 8:
//            rowString = data["CardNum2"] as! String
//            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
//        case 9:
//            rowString = data["CardNum2"] as! String
//            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
//        case 10:
//            rowString = data["CardNum2"] as! String
//            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        default:
            rowString = "Error: too many rows"
            myImageView.image = nil
        }
        let myLabel = UILabel(frame: CGRect(x:60, y:0, width:pickerView.bounds.width - 90, height:60 ))
//        myLabel.font = UIFont(name:some, font, size: 18)
        myLabel.text = rowString
        
        myView.addSubview(myLabel)
        myView.addSubview(myImageView)
        
        return myView
    }
    
    var isAddCardSelected = Bool()
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
//        let data = aryCards[row]
        if row == 0 {
            
            paymentType = ""
            txtSelectPaymentMethod.text = ""

            
        } else if row == 1 {
            
            paymentType = "cash"
            
            txtSelectPaymentMethod.text = "Cash"
            
        } else {
            paymentType = "m_pesa"
            
            txtSelectPaymentMethod.text = "M-Pesa"
        }
        
        
//        imgPaymentOption.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
//        txtSelectPaymentMethod.text = data["CardNum2"] as? String
        
//        if data["CardNum"] as! String == "Add a Card" {
//
//            isAddCardSelected = true
////            self.addNewCard()
//        }

//        let type = data["CardNum"] as! String
//
//        if type == "cash" {
//            paymentType = "cash"
//        } else {
//            paymentType = "card"
//            if data["Id"] != nil {
//                if data["Id"] as? String != "" {
//                    CardID = data["Id"] as! String
//                }
//            }
//        }
        
        
//        if type  == "wallet" {
//            paymentType = "wallet"
//        } else if type == "cash" {
//            paymentType = "cash"
//        } else {
//            paymentType = "pesapal"
//        }
        
//        if paymentType == "card" {
//
//            if data["Id"] as? String != "" {
//                CardID = data["Id"] as! String
//            }
//        }
        
        // do something with selected row
    }
    
    func addNewCard() {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
        next.delegateAddCardFromBookLater = self
        self.isAddCardSelected = false
//        self.navigationController?.pushViewController(next, animated: true)
    }
    
    //-------------------------------------------------------------
    // MARK: - Calendar Method
    //-------------------------------------------------------------
    
    var currentDate = Date()
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
       
        if currentDate < date {
            
//            let calendarDate = Calendar.current
//            let hour = calendarDate.component(.hour, from: date)
//            let minutes = calendarDate.component(.minute, from: date)
   
            let currentTimeInterval = currentDate.addingTimeInterval(30 * 60)
            
            if  date > currentTimeInterval {
                
                let myDateFormatter: DateFormatter = DateFormatter()
                myDateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
                
                let dateOfPostToApi: DateFormatter = DateFormatter()
                dateOfPostToApi.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
                convertDateToString = dateOfPostToApi.string(from: date)
                
                let finalDate = myDateFormatter.string(from: date)
                
                // get the date string applied date format
                let mySelectedDate = String(describing: finalDate)
                
                txtDataAndTimeFromCalendar.text = mySelectedDate
            }
            else {
                
                txtDataAndTimeFromCalendar.text = ""
                
                UtilityClass.setCustomAlert(title: "Time should be", message: "Please select 30 minutes greater time from current time!") { (index, title) in
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
    
    func WWCalendarTimeSelectorCancel(_ selector: WWCalendarTimeSelector, date: Date) {
        print("It works")
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Webservice For Book Later
    //-------------------------------------------------------------
    
    //PassengerId,ModelId,PickupLocation,DropoffLocation,PassengerType(myself,other),PassengerName,PassengerContact,PickupDateTime,FlightNumber,
    //PromoCode,Notes,PaymentType,CardId(If paymentType is card)
    
    func webserviceOFBookLater() {
        
        var dictData = [String:AnyObject]()
        
        dictData["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
        dictData["ModelId"] = strModelId as AnyObject
        dictData["PickupLocation"] = txtPickupLocation.text as AnyObject
        dictData["DropoffLocation"] = txtDropOffLocation.text as AnyObject
        dictData["PassengerType"] = strPassengerType as AnyObject
        dictData["PassengerName"] = txtFullName.text as AnyObject
        dictData["PassengerContact"] = txtMobileNumber.text as AnyObject
        dictData["PickupDateTime"] = convertDateToString as AnyObject
        
        
        dictData["PickupLat"] = doublePickupLat as AnyObject
        dictData["PickupLng"] = doublePickupLng as AnyObject
        dictData["DropOffLat"] = doubleDropOffLat as AnyObject
        dictData["DropOffLon"] = doubleDropOffLng as AnyObject
        
        if lblPromoCode.text == "" {
            
        }
        else {
            dictData["PromoCode"] = lblPromoCode.text as AnyObject
        }
        
        dictData["Notes"] = txtDescription.text as AnyObject
       
        if paymentType == "" {
            
            UtilityClass.setCustomAlert(title: "Missing", message: "Select Payment Type") { (index, title) in
            }
        }
        else {
            dictData["PaymentType"] = paymentType as AnyObject
        }
        
        if CardID == "" {
        }
        else {
            dictData["CardId"] = CardID as AnyObject
        }
        
        if txtFlightNumber.text!.count == 0 {
            dictData["FlightNumber"] = "" as AnyObject
        }
        else {
            dictData["FlightNumber"] = txtFlightNumber.text as AnyObject
        }
        
        webserviceForBookLater(dictData as AnyObject) { (result, status) in
            
            if (status) {
                print(result)

                UtilityClass.setCustomAlert(title: "\(appName)", message: "Your ride has been booked.".localized, completionHandler: { (index, title) in
                    self.delegateBookLater.btnRequestLater()
                    self.navigationController?.popViewController(animated: true)
                })
                
 /*
                {
                    info =     {
                        BookingFee = "2.2";
                        Duration = 27;
                        EstimatedFare = "43.28";
                        GrandTotal = "45.48";
                        Id = 1;
                        KM = "9.6";
                        SubTotal = "43.28";
                        Tax = "4.548";
                    };
                    status = 1;
                }
*/
                
            } else {
                
                print(result)
              
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
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    var aryCards = [[String:AnyObject]]()
    
    func webserviceOfCardList() {
        
        webserviceForCardList(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
//                if let res = result as? [String:AnyObject] {
//                    if let cards = res["cards"] as? [[String:AnyObject]] {
//                        self.aryCards = cards
//                    }
//                }
                
                self.aryCards.removeAll()
                
                if let res = result as? [String:AnyObject] {
                    if let cards = res["cards"] as? [[String:AnyObject]] {
                        self.aryCards = cards                        
                    }
                }
                
                var dict = [String:AnyObject]()
                dict["CardNum"] = "cash" as AnyObject
                dict["CardNum2"] = "cash" as AnyObject
                dict["Type"] = "icon_SelectedCash" as AnyObject
                self.aryCards.append(dict)
                
                if self.aryCards.count == 1 {
                    
                    var dict2 = [String:AnyObject]()
                    dict2["CardNum"] = "card" as AnyObject
                    dict2["CardNum2"] = "card" as AnyObject
                    dict2["Type"] = "icon_SelectedCard" as AnyObject
                    self.aryCards.append(dict2)
                }
                
//                var dict2 = [String:AnyObject]()
//                dict2["CardNum"] = "wallet" as AnyObject
//                dict2["CardNum2"] = "wallet" as AnyObject
//                dict2["Type"] = "iconWalletBlack" as AnyObject
//
//                var dict3 = [String:AnyObject]()
//                dict3["CardNum"] = "pesapal" as AnyObject
//                dict3["CardNum2"] = "pesapal" as AnyObject
//                dict3["Type"] = "icon_SelectedCard" as AnyObject
                
                
//                self.aryCards.append(dict3)
                
//
//                if self.aryCards.count == 2 {
//                    var dict3 = [String:AnyObject]()
//                    dict3["Id"] = "000" as AnyObject
//                    dict3["CardNum"] = "Add a Card" as AnyObject
//                    dict3["CardNum2"] = "Add a Card" as AnyObject
//                    dict3["Type"] = "iconPlusBlack" as AnyObject
//                    self.aryCards.append(dict3)
//
//                }
//
//                self.pickerView.selectedRow(inComponent: 0)
                let data = self.aryCards[0]
//
                self.imgPaymentOption.image = UIImage(named: self.setCardIcon(str: data["Type"] as! String))
                self.txtSelectPaymentMethod.text = data["CardNum2"] as? String

                let type = data["CardNum"] as! String

                if type == "cash" {
                    self.paymentType = "cash"
                }
                else {
                    self.paymentType = "card"
                }
               
//                else {
//                    self.paymentType = "pesapal"
//                }
                if self.paymentType == "card" {

                    if data["Id"] != nil {
                        if data["Id"] as? String != "" {
                            self.CardID = data["Id"] as! String
                        }
                    }
                }
//                 self.paymentType = "cash"
                self.pickerView.reloadAllComponents()
              
                /*
                 {
                     cards =     (
                     {
                         Alias = visa;
                         CardNum = 4639251002213023;
                         CardNum2 = "xxxx xxxx xxxx 3023";
                         Id = 59;
                         Type = visa;
                     }
                     );
                     status = 1;
                 }
                 */
            }
            else {
                print(result)
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
        }
    }
    
    
    @IBAction func btnClearCurrentLocation(_ sender: UIButton) {
        txtPickupLocation.text = ""
    }
    
    @IBAction func btnClearDropOffLocation(_ sender: UIButton) {
        txtDropOffLocation.text = ""
    }
    
    
}

// Delegates to handle events for the location manager.
extension BookLaterViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
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
*/
extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
