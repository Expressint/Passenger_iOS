//
//  HomeViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 26/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
//import SideMenu
import SocketIO
import SDWebImage
import NVActivityIndicatorView
import M13Checkbox
import AVFoundation

protocol FavouriteLocationDelegate {
    func didEnterFavouriteDestination(Source: [String: AnyObject])
}

protocol CompleterTripInfoDelegate {
    func didRatingCompleted()
}

protocol addCardFromHomeVCDelegate {
    func didAddCardFromHomeVC()
}
protocol deleagateForBookTaxiLater
{
    func btnRequestLater()
}

enum locationTypeEntered: String {
    case pickup, dropOffFirst, dropOffSecond
}

class HomeViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GMSAutocompleteViewControllerDelegate, FavouriteLocationDelegate, UIPickerViewDelegate, UIPickerViewDataSource, NVActivityIndicatorViewable, UIGestureRecognizerDelegate, FloatRatingViewDelegate, CompleterTripInfoDelegate, ARCarMovementDelegate, GMSMapViewDelegate, addCardFromHomeVCDelegate, SelectCardDelegate,delegateRateGiven,deleagateForBookTaxiLater, CadsSelectionDelegate, BookLaterSubmitedDelegate
{
    
    func BookLaterComplete() {
        //        self.clearSetupMapForNewBooking()
        btnRequestLater()
    }
    
    //RJ Change
    var timerToUpdatePassengerlocation:Timer!
    //
    var locationEnteredType : locationTypeEntered?
    
    let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    let baseUrlForGetAddress = "https://maps.googleapis.com/maps/api/geocode/json?"
    let baseUrlForAutocompleteAddress = "https://maps.googleapis.com/maps/api/place/autocomplete/json?"
    
    let apikey = googlApiKey
    
    let socket = (UIApplication.shared.delegate as! AppDelegate).socket


    //    let socket? = (UIApplication.shared.delegate as! AppDelegate).SocketManager
    var boolTimeEnd = Bool()
    
    var moveMent: ARCarMovement!
    var driverMarker: GMSMarker!
    var strTipAmount = String()
    //    var alertForTip = UIAlertController()
    var timer = Timer()
    var timerToGetDriverLocation : Timer!
    var aryCards = [[String:AnyObject]]()
    var aryCompleterTripData = [Any]()
    let completeProgress: CGFloat = 30
    var progressCompleted: CGFloat = 1
    
    var timerOfRequest : Timer!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView = GMSMapView()
    var placesClient = GMSPlacesClient()
    var zoomLevel: Float = 17.0
    var likelyPlaces: [GMSPlace] = []
    var selectedPlace: GMSPlace?
    var defaultLocation = CLLocation(latitude: 0, longitude: 0)
    var arrNumberOfAvailableCars = NSMutableArray()
    var arrTotalNumberOfCars = NSMutableArray()
    var arrNumberOfOnlineCars = NSMutableArray()
    //    var dictCars = NSMutableDictionary()
    var strCarModelClass = String()
    
    var boolShouldTrackCamera = true
    
    var aryRequestAcceptedData = NSMutableArray()
    {
        didSet
        {
            aryRequestAcceptedData.count != 0 ? self.setNavBarWithMenu(Title: "Home".localized, IsNeedRightButton: true,isFavNeeded: true,isSOSNeeded: true):self.setNavBarWithMenu(Title: "Home".localized, IsNeedRightButton: true,isFavNeeded: true,isSOSNeeded: false)
            
        }
    }
    
    @IBOutlet var constraintVerticalSpacingLocation : NSLayoutConstraint?
    
    var strCarModelID = String()
    var strCarModelIDIfZero = String()
    var strNavigateCarModel = String()
    
    var aryEstimateFareData = NSMutableArray()
    
    var strSelectedCarMarkerIcon = String()
    var ratingToDriver = Float()
    var commentToDriver = String()
    var strSelectedCarTotalFare = String()
    //    var currentLocationMarkerText = String()
    //    var destinationLocationMarkerText = String()
    
    @IBOutlet var btnRequestNow: UIButton!
    @IBOutlet var btnClose: [UIButton]!
    @IBOutlet var btnBookLater: ThemeButton!
    @IBOutlet var btnBookNow: ThemeButton!
    @IBOutlet var btnSubmitRating: UIButton!
    @IBOutlet var lblHowwasyourExperienceTitle: UILabel!
    @IBOutlet var lblYourRequestPendingStatusTitle: UILabel!
    
    //-------------------------------------------------------------
    // MARK: - Final Rating View
    //-------------------------------------------------------------
    @IBOutlet weak var MarkerCurrntLocation: UIButton!
    
    @IBOutlet weak var viewMainFinalRating: UIView!
    @IBOutlet weak var viewSubFinalRating: UIView!
    @IBOutlet weak var txtFeedbackFinal: UITextField!
    
    @IBOutlet weak var giveRating: FloatRatingView!
    
    @IBOutlet weak var viewBookNowLater: UIView!
    
    var isFromAutoComplete = Bool()
    
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        
        giveRating.rating = rating
        ratingToDriver = giveRating.rating
    }
    
    @IBAction func btnSubmitFinalRating(_ sender: UIButton) {
        //        BookingId,Rating,Comment,BookingType(BookNow,BookLater)
        
        var param = [String:AnyObject]()
        param["BookingId"] = SingletonClass.sharedInstance.bookingId as AnyObject
        param["Rating"] = ratingToDriver as AnyObject
        param["Comment"] = txtFeedbackFinal.text as AnyObject
        param["BookingType"] = strBookingType as AnyObject
        
        webserviceForRatingAndComment(param as AnyObject) { (result, status) in
            
            print(result)
            if (status) {
                
                self.txtFeedbackFinal.text = ""
                self.ratingToDriver = 0
                
                self.completeTripInfo()
            }
            else {
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
                else if let resDict = result as? NSDictionary {
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
                else if let resAry = result as? NSArray {
                    
                    if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                        if SelectedLanguage == "en" {
                            UtilityClass.showAlert("Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                            
                        }
                        else if SelectedLanguage == "sw" {
                            UtilityClass.showAlert("Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "swahili_message") as! String, vc: self)
                        }
                    }
                }
            }
        }
    }
    
    func didRatingCompleted() {
        
        openRatingView()
        
        //        self.completeTripInfo()
    }
    
    func btnRequestLater()
    {
        //        self.clearDataAfteCompleteTrip()
        clearMap()
        self.MarkerCurrntLocation.isHidden = false
        //        selectedIndexPath = nil
        //        self.collectionViewCars.reloadData()
        self.txtCurrentLocation.text = ""
        self.txtDestinationLocation.text = ""
        self.txtAdditionalDestinationLocation.text = ""
        
        self.viewCarLists.isHidden = true
        self.ConstantViewCarListsHeight.constant = 0
        
        self.btnDoneForLocationSelected.isHidden = true
        self.viewBookNowLater.isHidden = true
        
        //        self.btnclo.isHidden = true
        //        self.btnCloseDropoffAddress.isHidden = true
        //        self.dropoffLat = 0
        //        self.doublePickupLng = 0
        self.btnCurrentLocation(self.btnCurrentLocation)
        //        SingletonClass.sharedInstance.strPassengerID = ""
        
        currentLocationAction()
        
    }
    // ----------------------------------------------------------------------
    //MARK:- Driver Details
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblDriverEmail: UILabel!
    @IBOutlet weak var lblDriverPhoneNumber: UILabel!
    @IBOutlet weak var imgDriverImage: UIImageView!
    @IBOutlet weak var viewDriverInformation: UIView!
    @IBOutlet weak var viewTripActions: UIView!
    @IBOutlet weak var viewFromToSubmitButton: UIView!
    
    @IBOutlet weak var btnCancelStartedTrip: UIButton!
    
    //MARK:-
    @IBOutlet weak var viewCarLists: UIView!
   
    
    @IBOutlet weak var viewShareRideView: UIView!
    @IBOutlet weak var imgIsShareRideON: UIImageView!
    
    /// if intShareRide = 1 than ON and if intShareRide = 0 OFF
    var intShareRide:Int = 0
    
    var isShareRideON = Bool()
    
    @IBAction func btnShareRide(_ sender: UIButton) {
        isShareRideON = !isShareRideON
        
        if (isShareRideON) {
            imgIsShareRideON.image = UIImage(named: "iconGreen")
            intShareRide = 1
            SingletonClass.sharedInstance.isShareRide = 1
        } else {
            imgIsShareRideON.image = UIImage(named: "iconRed")
            intShareRide = 0
            SingletonClass.sharedInstance.isShareRide = 0
        }
        
        postPickupAndDropLocationForEstimateFare()
    }
    
    @IBOutlet weak var constantLeadingOfShareRideButton: NSLayoutConstraint! // 10 or -150
    @IBOutlet weak var btnShareRideToggle: UIButton!
    
    @IBAction func btnShareRideToggle(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "iconRightArraw") {
            
            sender.setImage(UIImage(named: "iconArrow"), for: .normal)
            constantLeadingOfShareRideButton.constant = 10
            
            UIView.animate(withDuration: 0.5) {
                self.viewShareRideView.layoutIfNeeded()
            }
        } else {
            
            sender.setImage(UIImage(named: "iconRightArraw"), for: .normal)
            constantLeadingOfShareRideButton.constant = -150
            
            UIView.animate(withDuration: 0.5) {
                self.viewShareRideView.layoutIfNeeded()
            }
        }
    }
    //PassengerId,ModelId,PickupLocation,DropoffLocation,PickupLat,PickupLng,DropOffLat,DropOffLon
    
    var strModelId = String()
    var strPickupLocation = String()
    var strDropoffLocation = String()
    var strAdditionalDropoffLocation = String()
    var doublePickupLat = Double()
    var doublePickupLng = Double()
    var doubleUpdateNewLat = Double()
    var doubleUpdateNewLng = Double()
    var doubleDropOffLat = Double()
    var doubleDropOffLng = Double()
    var arrDataAfterCompletetionOfTrip = NSMutableArray()
    var selectedIndexPath: IndexPath?
    var strSpecialRequest = String()
    var strSpecialRequestFareCharge = String()
    
    var strPickUpLatitude = String()
    var strPickUpLongitude = String()
    
    
    @IBOutlet weak var ConstantViewCarListsHeight: NSLayoutConstraint! // 170
    
    @IBOutlet weak var constraintTopSpaceViewDriverInfo: NSLayoutConstraint!
    
    @IBOutlet weak var viewForMainFavourite: UIView!
    @IBOutlet weak var viewForFavourite: UIView!
    
    var loadingView: NVActivityIndicatorView!
    //---------------
    
    var sumOfFinalDistance = Double()
    
    var selectedRoute: Dictionary<String, AnyObject>!
    var overviewPolyline: Dictionary<String, AnyObject>!
    
    var originCoordinate: CLLocationCoordinate2D!
    var destinationCoordinate: CLLocationCoordinate2D!
    
    
    //---------------
    @IBOutlet var HomeViewGrandParentView: UIView!
    
    @IBOutlet weak var viewDestinationLocation: UIView!
    @IBOutlet weak var viewCurrentLocation: UIView!
    @IBOutlet weak var viewAdditionalDestinationLocation: UIView!
    @IBOutlet weak var txtDestinationLocation: UITextField!
    @IBOutlet weak var txtAdditionalDestinationLocation: UITextField!
    
    @IBOutlet weak var txtCurrentLocation: UITextField!
    @IBOutlet weak var viewMap: UIView!
    @IBOutlet weak var collectionViewCars: UICollectionView!
    
    @IBOutlet var viewAddressandBooknowlaterBTN: UIView!
    
    var dropoffLat = Double()
    var dropoffLng = Double()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        PayCardView.isHidden = false
        //Crashlytics
        
        //        let button = UIButton(type: .roundedRect)
        //        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
        //        button.setTitle("Crash", for: [])
        //        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
        //        view.addSubview(button)
        
        
        
        
        self.viewBookNowLater.isHidden = true
        
        webserviceOfCardList()
        
        self.stackViewNumberOfPassenger.isHidden = true
        
        self.btnDoneForLocationSelected.isHidden = true
        
        self.ConstantViewCarListsHeight.constant = 0
        self.viewCarLists.isHidden = true
        //        self.viewShareRideView.isHidden = true
        
        //        currentLocationMarkerText = "Current Location"
        //        destinationLocationMarkerText = "Destination Location"
        
        imgIsShareRideON.image = UIImage(named: "iconRed")
        
        currentLocationMarker.isDraggable = true
        destinationLocationMarker.isDraggable = true
        
        moveMent = ARCarMovement()
        moveMent.delegate = self
        
//        self.mapView.delegate = self
        
        mapView.isHidden = true
        self.perform(#selector(btnCurrentLocation(_:)), with: nil, afterDelay: 2.0)
        self.setupGoogleMap()
        sortCarListFirstTime()
        webserviceOfCurrentBooking()
        setPaymentType()
        
        viewMainFinalRating.isHidden = true
        btnDriverInfo.layer.cornerRadius = 5
        btnDriverInfo.layer.masksToBounds = true
        btnRequest.layer.cornerRadius = 5
        btnRequest.layer.masksToBounds = true
        btnCurrentLocation.layer.cornerRadius = 5
        btnCurrentLocation.layer.masksToBounds = true
//        btnDriverInfo.setTitle("Driver Info / ETA", for: .normal)
        self.btnCancelStartedTrip.isHidden = true
        
        giveRating.delegate = self
        
        ratingToDriver = 0.0
        
        //        paymentType = "cash"
        
        self.viewBookNow.isHidden = true
        stackViewOfPromocode.isHidden = true
        
        viewMainActivityIndicator.isHidden = true
        
        viewActivity.type = .ballPulse
        viewActivity.color = themeYellowColor
        
        
        viewHavePromocode.tintColor = themeYellowColor
        viewHavePromocode.stateChangeAnimation = .fill
        viewHavePromocode.boxType = .square
        
        viewTripActions.isHidden = true
        self.constraintVerticalSpacingLocation?.priority = UILayoutPriority(800)
        
        //        webserviceOfCardList()
        
        viewForMainFavourite.isHidden = true
        
        viewForFavourite.layer.cornerRadius = 5
        viewForFavourite.layer.masksToBounds = true
        
        SingletonClass.sharedInstance.isFirstTimeDidupdateLocation = true;
        //        self.view.bringSubview(toFront: btnFavourite)
        
        callToWebserviceOfCardListViewDidLoad()
        
        //
        //        // Do any additional setup after loading the view.
        //         
        //
        //        viewCurrentLocation.layer.shadowOpacity = 0.3
        //        viewCurrentLocation.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        //
        //        viewDestinationLocation.layer.shadowOpacity = 0.3
        //        viewDestinationLocation.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        //
        //        self.setupSideMenu()
        ////        webserviceCallForGettingCarLists()
        //
        
        if(UIApplication.shared.delegate as! AppDelegate).isAlreadyLaunched == false
        {
            //            mapView.isHidden = true
            self.setNotificationcenter()
        }
        mapView.isHidden = false
        self.socketMethods()
        //        else
        //        {
        //            mapView.isHidden = false
        //        }
        self.setNavBarWithMenu(Title: "Home".localized, IsNeedRightButton: true,isFavNeeded: true)

    }
    
    func setNotificationcenter()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.setLocationFromBarAndClub(_:)), name: NotificationBookNow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.setBookLaterDestinationAddress(_:)), name: NotificationBookLater, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.webserviceOfRunningTripTrack), name: NotificationTrackRunningTrip, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.newBooking(_:)), name: NotificationForBookingNewTrip, object: nil)
        
        //Menu Navigation Observer
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.GotoProfilePage), name: OpenEditProfile, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.GotoMyBookingPage), name: OpenMyBooking, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.GotoPaymentPage), name: OpenPaymentOption, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.GotoWalletPage), name: OpenWallet, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.GotoMyReceiptPage), name: OpenMyReceipt, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.GotoFavouritePage), name: OpenFavourite, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.GotoInviteFriendPage), name: OpenInviteFriend, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.GotoSettingPage), name: OpenSetting, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.GotoSupportPage), name: OpenSupport, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.GotoPastDuesPage), name: OpenPastDues, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.GotoHomePage), name: OpenHome, object: nil)
    }
    //    @IBOutlet weak var viewHeaderHeightConstant: NSLayoutConstraint!
    //
    //    func setHeaderForIphoneX() {
    //
    //        if UIDevice().userInterfaceIdiom == .phone {
    //            switch UIScreen.main.nativeBounds.height {
    //            case 2436:
    //
    //                viewHeaderHeightConstant.constant = 80
    //
    //                //                frame = CGRect(x: CGFloat(0), y: CGFloat(-20), width: screenWidth, height: CGFloat(heightWithoutLabelForX))
    //                //                hView.contraintLabelCentr.constant = 10
    //                //
    //                //                if (showTitleLabelView)
    //                //                {
    //                //                    frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: screenWidth, height: CGFloat(heightWithLabelForX))
    //                //                    hView.lblHeaderTitle.text = strHeaderTitle
    //            //                }
    //            default:
    //                print("unknown")
    //            }
    //        }
    //
    //    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setLocalization()
        //        self.btnDoneForLocationSelected.isHidden = true
        
        //        setupGoogleMap()
        
        //        viewTripActions.isHidden = true
        
        // This is For Book Later Address
        if (SingletonClass.sharedInstance.isFromNotificationBookLater) {
            
            if strCarModelID == "" {
                
                //                UtilityClass.setCustomAlert(title: "Missing", message: "Please Select Car".localized) { (index, title) in
                //                }
                UtilityClass.setCustomAlert(title: "Missing", message: "No Driver Available Right Now.".localized) { (index, title) in
                }
            }
            else if strDestinationLocationForBookLater != "" {
                let profileData = SingletonClass.sharedInstance.dictProfile
                
                let next = mainStoryboard.instantiateViewController(withIdentifier: "BookLaterViewController") as! BookLaterViewController
                
                SingletonClass.sharedInstance.isFromNotificationBookLater = false
                
                next.BookLaterCompleted = self
                next.strModelId = strCarModelID
                next.strCarModelURL = strNavigateCarModel
                next.strCarName = strCarModelClass
                
                next.strFullname = profileData.object(forKey: "Fullname") as! String
                next.strMobileNumber = profileData.object(forKey: "MobileNo") as! String
                
                next.strDropoffLocation = strDestinationLocationForBookLater
                next.doubleDropOffLat = dropOffLatForBookLater
                next.doubleDropOffLng = dropOffLngForBookLater
                
                self.navigationController?.pushViewController(next, animated: true)
            } else {
                
                UtilityClass.setCustomAlert(title: "Missing", message: "We did not get proper address") { (index, title) in
                }
            }
        }
        
        viewSubFinalRating.layer.cornerRadius = 5
        viewSubFinalRating.layer.masksToBounds = true
        
        //        viewSelectPaymentOption.layer.borderWidth = 1.0
        //        viewSelectPaymentOption.layer.borderColor = UIColor.gray.cgColor
        //        viewSelectPaymentOption.layer.cornerRadius = 5
        //        viewSelectPaymentOption.layer.masksToBounds = true
        
        viewSelectPaymentOptionParent.layer.cornerRadius = 5
        viewSelectPaymentOptionParent.layer.masksToBounds = true
        
        if(locationManager != nil) {
            locationManager.startUpdatingLocation()
        }
        

    }
    
    func setLocalization()
    {
        //        lblEditProfile.text =  "Edit Profile".localized
        //        lblAccount.text =  "Account".localized
        txtCurrentLocation.placeholder = "Pickup Location".localized
        txtDestinationLocation.placeholder = "Dropoff Location".localized
        btnDoneForLocationSelected.setTitle("Done".localized, for: .normal)
        btnBookNow.setTitle("Book Now".localized, for: .normal)
        btnBookLater.setTitle("Book Later".localized, for: .normal)
        btnRequestNow.setTitle("REQUEST NOW".localized, for: .normal)
        lblPromocode.text = "Have a promocode?".localized
        txtNote.placeholder = "Notes".localized
        lblYourRequestPendingStatusTitle.text = "Your request status pending...".localized
        btnCancelStartedTrip.setTitle("Cancel Request".localized, for: .normal)
        btnRequest.setTitle("Cancel Request".localized, for: .normal)
        btnDriverInfo.setTitle("Driver Info / ETA".localized, for: .normal)
        txtHavePromocode.placeholder = "Enter Promocode".localized
        btnPesaPal.setTitle("pesapal".localized, for: .normal)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //        if (self.mapView != nil)
        //        {
        //
        //        self.mapView.clear()
        ////        self.mapView.stopRendering()
        ////        self.mapView.removeFromSuperview()
        ////        self.mapView = nil
        //        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //        setHeaderForIphoneX()
        //        self.arrTotalNumberOfCars = NSMutableArray(array: SingletonClass.sharedInstance.arrCarLists)
        let asdf = (SingletonClass.sharedInstance.arrCarLists as! [[String:Any]]).sorted {($0["Sort"] as! String) < ($1["Sort"] as! String)}
        self.arrTotalNumberOfCars = NSMutableArray(array: asdf)
        
        //        self.setupGoogleMap()
    }
    
    //-------------------------------------------------------------
    // MARK: - Notification Center Methods
    //-------------------------------------------------------------
    
    
    @objc func setLocationFromBarAndClub(_ notification: NSNotification) {
        
        print("Notification Data : \(notification)")
        
        if let Address = notification.userInfo?["Address"] as? String {
            // do something with your image
            txtDestinationLocation.text = Address
            strDropoffLocation = Address
            
            if let lat = notification.userInfo?["lat"] as? Double {
                
                if lat != 0 {
                    doubleDropOffLat = Double(lat)
                }
            }
            
            if let lng = notification.userInfo?["lng"] as? Double {
                
                if lng != 0 {
                    doubleDropOffLng = Double(lng)
                }
            }
        }
    }
    
    var strDestinationLocationForBookLater = String()
    var dropOffLatForBookLater = Double()
    var dropOffLngForBookLater = Double()
    
    @objc func setBookLaterDestinationAddress(_ notification: NSNotification) {
        
        print("Notification Data : \(notification)")
        
        if let Address = notification.userInfo?["Address"] as? String {
            // do something with your image
            strDestinationLocationForBookLater = Address
            
            if let lat = notification.userInfo?["lat"] as? Double {
                
                if lat != 0 {
                    dropOffLatForBookLater = Double(lat)
                }
            }
            
            if let lng = notification.userInfo?["lng"] as? Double {
                
                if lng != 0 {
                    dropOffLngForBookLater = Double(lng)
                }
            }
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - setMap and Location Methods
    //-------------------------------------------------------------
    @IBOutlet weak var btnDoneForLocationSelected: ThemeButton!
    
    @IBAction func btnDoneForLocationSelected(_ sender: ThemeButton) {
        
        clearMap()
        self.routePolyline.map = nil
        self.updateCounting()
        
        if(aryRequestAcceptedData.count != 0)
        {
                self.webserviceForUpdateDestinationAfterStartTrip(dropLocation: strDropoffLocation, lat: "\(doubleDropOffLat)", lng: "\(doubleDropOffLng)",dropLocation2: strAdditionalDropoffLocation, lat2: "\(doubleUpdateNewLat)", lng2: "\(doubleUpdateNewLng)")
        }
        else
        {
            if txtCurrentLocation.text != "" && txtDestinationLocation.text != "" {
                
                setupBothCurrentAndDestinationMarkerAndPolylineOnMap()
                
                self.collectionViewCars.reloadData()
                btnDoneForLocationSelected.isHidden = true
                self.viewBookNowLater.isHidden = false
                self.viewCarLists.isHidden = false
                
                self.viewCarLists.backgroundColor = UIColor.white
                self.viewCarLists.layer.shadowColor = UIColor.darkGray.cgColor
                self.viewCarLists.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
                self.viewCarLists.layer.shadowOpacity = 0.4
                self.viewCarLists.layer.shadowRadius = 1
                
                self.viewCarLists.layer.cornerRadius = 10
                //            self.viewShareRideView.isHidden = false
                self.ConstantViewCarListsHeight.constant = 150
            } else {
                if UtilityClass.isEmpty(str: txtCurrentLocation.text!) {
                    UtilityClass.showAlert("", message: "Please enter pick up location".localized, vc: self)
                    
                } else if UtilityClass.isEmpty(str: txtDestinationLocation.text!) {
                    UtilityClass.showAlert("", message: "Please enter drop off location".localized, vc: self)
                } else {
                    self.ConstantViewCarListsHeight.constant = 0
                    self.viewCarLists.isHidden = true
                    //            self.viewShareRideView.isHidden = true
                }
            }
        }
    }
    
    func setupBothCurrentAndDestinationMarkerAndPolylineOnMap() {
        
        if txtCurrentLocation.text != "" && txtDestinationLocation.text != "" {
            
            MarkerCurrntLocation.isHidden = true
            
            var PickupLat = doublePickupLat
            var PickupLng = doublePickupLng
            
            if(SingletonClass.sharedInstance.isTripContinue)
            {
                PickupLat = doubleUpdateNewLat
                PickupLng = doubleUpdateNewLng
            }
            
            let DropOffLat = doubleDropOffLat
            let DropOffLon = doubleDropOffLng
            
            let originalLoc: String = "\(PickupLat),\(PickupLng)"
            var destiantionLoc: String = "\(DropOffLat),\(DropOffLon)"
            
            
            let bounds = GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: PickupLat, longitude: PickupLng), coordinate: CLLocationCoordinate2D(latitude: DropOffLat, longitude: DropOffLon))
            
            let update = GMSCameraUpdate.fit(bounds, withPadding: CGFloat(150))
            
            self.mapView.animate(with: update)
            
            self.mapView.moveCamera(update)
            
            var aryMyWayPoints = [String]()
            
            if txtDestinationLocation.text?.trimmingCharacters(in: .whitespacesAndNewlines).count != 0 {
                destiantionLoc = "\(DropOffLat),\(DropOffLon)"
            }
            if txtDestinationLocation.text?.trimmingCharacters(in: .whitespacesAndNewlines).count != 0 && txtAdditionalDestinationLocation.text?.trimmingCharacters(in: .whitespacesAndNewlines).count != 0 {
                aryMyWayPoints.append("\(DropOffLat),\(DropOffLon)")
                //                aryMyWayPoints.append("\(self.doubleUpdateNewLat),\(self.doubleUpdateNewLng)")
                destiantionLoc = "\(self.doubleUpdateNewLat),\(self.doubleUpdateNewLng)"
            }
            
            if aryMyWayPoints.count != 0 {
                setDirectionLineOnMapForSourceAndDestinationShow(origin: originalLoc, destination: destiantionLoc, waypoints: aryMyWayPoints, travelMode: nil, completionHandler: nil)
            } else {
                setDirectionLineOnMapForSourceAndDestinationShow(origin: originalLoc, destination: destiantionLoc, waypoints: nil, travelMode: nil, completionHandler: nil)
            }
        }
    }
    
    @IBOutlet weak var btnCurrentLocation: UIButton!
    var currentLocationMarker = GMSMarker()
    var destinationLocationMarker = GMSMarker()
    var additionalDestinationLocationMarker = GMSMarker()
    
    var routePolyline = GMSPolyline()
    var demoPolylineOLD = GMSPolyline()
    
    var setDummyLineIndex = 0
    var dummyTimer = Timer()
    
    @IBAction func btnCurrentLocation(_ sender: UIButton) {
        //        self.getDummyDataLinedata()
        //        dummyTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(dummyCarMovement), userInfo: nil, repeats: true)
        self.boolShouldTrackCamera = true
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: 17)
        mapView.camera = camera
        
        if CLLocationManager.locationServicesEnabled() {
             switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .restricted, .denied:
                 self.mapView.animate(toZoom: 1)
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                }
            } else {
                print("Location services are not enabled")
        }
        
    }
    
    @objc func dummyCarMovement() {
        
        self.setDummyLine(index: setDummyLineIndex)
        setDummyLineIndex += 1
        
        if setDummyLineIndex == aryDummyLineData.count {
            setDummyLineIndex = 0
            self.setDummyLine(index: setDummyLineIndex)
        }    }
    
    func currentLocationAction() {
        
        clearMap()
        
        txtDestinationLocation.text = ""
        txtAdditionalDestinationLocation.text = ""
        strDropoffLocation = ""
        doubleDropOffLat = 0
        doubleDropOffLng = 0
        self.destinationLocationMarker.map = nil
        self.currentLocationMarker.map = nil
        self.locationEnteredType = .pickup
        self.btnDoneForLocationSelected.isHidden = false
        self.viewBookNowLater.isHidden = true
        self.ConstantViewCarListsHeight.constant = 0
        self.viewCarLists.isHidden = true

        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: 17)
        
        mapView.camera = camera


        self.MarkerCurrntLocation.isHidden = false
        self.btnDoneForLocationSelected.isHidden = false
        self.viewBookNowLater.isHidden = true
        self.doublePickupLat = (defaultLocation.coordinate.latitude)
        self.doublePickupLng = (defaultLocation.coordinate.longitude)
        
        let strLati: String = "\(self.doublePickupLat)"
        let strlongi: String = "\(self.doublePickupLng)"
        //
        getAddressForLatLng(latitude: strLati, longitude: strlongi, markerType: .pickup)
        
    }
    
    let geocoder = GMSGeocoder()
    
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if (gesture){
            print("dragged")
            self.boolShouldTrackCamera = false
        }
    }

    
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
//        sleep(12)
        
        print("idleAt cameraPosition : \(cameraPosition)")
        if(isFromAutoComplete)
        {
            isFromAutoComplete = false
            return
        }
        
        if Connectivity.isConnectedToInternet() {
            
            if MarkerCurrntLocation.isHidden == false {
                self.btnDoneForLocationSelected.isHidden = false
                self.viewBookNowLater.isHidden = true
                
                if self.locationEnteredType == .pickup {
                    
                    self.doublePickupLat = cameraPosition.target.latitude
                    self.doublePickupLng = cameraPosition.target.longitude
                    
                    getAddressForLatLng(latitude: "\(cameraPosition.target.latitude)", longitude: "\(cameraPosition.target.longitude)", markerType: .pickup)
                }
                else if self.locationEnteredType == .dropOffFirst {
                    
                    self.doubleDropOffLat = cameraPosition.target.latitude
                    self.doubleDropOffLng = cameraPosition.target.longitude
                    getAddressForLatLng(latitude: "\(cameraPosition.target.latitude)", longitude: "\(cameraPosition.target.longitude)", markerType: .dropOffFirst)
                }
                else if self.locationEnteredType == .dropOffSecond {
                    
                    self.doubleUpdateNewLat = cameraPosition.target.latitude
                    self.doubleUpdateNewLng = cameraPosition.target.longitude
                    getAddressForLatLng(latitude: "\(cameraPosition.target.latitude)", longitude: "\(cameraPosition.target.longitude)", markerType: .dropOffSecond)
                }
            }
        } else {
            UtilityClass.showAlert("", message: "Internet connection not available", vc: self)
        }
    }
    
    func getAddressForLatLng(latitude: String, longitude: String, markerType: locationTypeEntered)
    {
        let url = NSURL(string: "\(baseUrlForGetAddress)latlng=\(latitude),\(longitude)&key=\(apikey)")
        
        let data = NSData(contentsOf: url! as URL)
        do {
            let json = try JSONSerialization.jsonObject(with: (data as Data?) ?? Data(), options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
            if let result = json?["results"] as? [[String:AnyObject]] {
                if let address = result.first?["formatted_address"] as? String
                {
                    if markerType == .pickup {
                        self.txtCurrentLocation.text = address
                        self.strPickupLocation = address
                        self.btnDoneForLocationSelected.isHidden = false
                        self.viewBookNowLater.isHidden = true
                    }
                    else if markerType == .dropOffFirst {
                        self.txtDestinationLocation.text = address
                        self.strDropoffLocation = address
                        self.btnDoneForLocationSelected.isHidden = false
                        self.viewBookNowLater.isHidden = true
                    }
                    else if markerType == .dropOffSecond {
                        self.txtAdditionalDestinationLocation.text = address
                        self.strAdditionalDropoffLocation = address
                        self.btnDoneForLocationSelected.isHidden = false
                        self.viewBookNowLater.isHidden = true
                    }
                }
            }
            
        } catch {
            print("json error: \(error.localizedDescription)")
        }
    }


    
    @IBOutlet weak var btnFavourite: UIButton!
    @IBAction func btnFavourite(_ sender: UIButton) {
        
        if txtDestinationLocation.text!.count == 0 {
            
            UtilityClass.setCustomAlert(title: "Missing", message: "Enter Destination Address") { (index, title) in
            }
        }
        else if txtAdditionalDestinationLocation.text!.count != 0 {
            
            UtilityClass.setCustomAlert(title: "", message: "Cannot store multiple drop offs, please remove additional location") { (index, title) in
            }
        }
        else
        {
            UIView.transition(with: viewForMainFavourite, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
                self.viewForMainFavourite.isHidden = false
            }) { _ in }
        }
    }
    
    @IBAction func btnSOS(_ sender: UIButton) {
        socketEmitForSOS()
    }
    func socketEmitForSOS()
    {
        let myJSON = ["UserId" : SingletonClass.sharedInstance.strPassengerID,
                      "BookingId": SingletonClass.sharedInstance.bookingId,
                      "BookingType" : self.strBookingType,
                      "UserType": "Passenger", "Token": SingletonClass.sharedInstance.deviceToken,"Lat": SingletonClass.sharedInstance.currentLatitude, "Lng": SingletonClass.sharedInstance.currentLongitude] as [String : Any]
        
        self.socket?.emit(SocketData.SOS, with: [myJSON], completion: nil)
        print ("\(SocketData.SOS) : \(myJSON)")
    }
    
    func onSOS() {
        
        self.socket?.on(SocketData.SOS, callback: { (data, ack) in
            print ("SOS Driver Notify : \(data)")
            
            let msg = (data as NSArray)
            
            UtilityClass.showAlert("", message: (msg.object(at: 0) as? NSDictionary)?.object(forKey: GetResponseMessageKey()) as? String ?? "", vc: self)
            
        })
        
    }
    
    
    
    func setPaymentType() {
        paymentType = "cash"
    }
    
    func setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: Bool)
    {
        
        //        viewCurrentLocation.isHidden = status
        //        viewDestinationLocation.isHidden = status
        //        viewAddressandBooknowlaterBTN.isHidden = status
//        btnCurrentLocation.isHidden = status
    }
    
    
    //Mark - Webservice Call For Miss Booking Request
    func webserviceCallForMissBookingRequest()
    {
        
        var dictParam = [String:AnyObject]()
        dictParam["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
        dictParam["ModelId"] = strCarModelIDIfZero as AnyObject
        dictParam["PickupLocation"] = self.strPickupLocation as AnyObject
        dictParam["DropoffLocation"] = self.strDropoffLocation as AnyObject
        dictParam["PickupLat"] = doublePickupLat as AnyObject
        dictParam["PickupLng"] = doublePickupLng as AnyObject
        dictParam["DropOffLat"] = doubleDropOffLat as AnyObject
        dictParam["DropOffLon"] = doubleDropOffLng as AnyObject
        dictParam["Notes"] = "" as AnyObject
        
        webserviceForMissBookingRequest(dictParam as AnyObject) { (result, status) in
        }
    }
    
    //MARK:- Webservice Call for Booking Requests
    func webserviceCallForBookingCar()
    {
        
        //PassengerId,ModelId,PickupLocation,DropoffLocation,PickupLat,PickupLng,DropOffLat,DropOffLon
        //,PromoCode,Notes,PaymentType,CardId(If paymentType is card)
        
        let dictParams = NSMutableDictionary()
        if let dict = self.dictSelectedDriver {
            if let strDriverID = dict["DriverId"] as? String {
                dictParams.setObject(strDriverID, forKey: "DriverId" as NSCopying)
            }
            if let strDriverID = dict["DriverId"] as? Int {
                dictParams.setObject(strDriverID, forKey: "DriverId" as NSCopying)
            }
        }
        dictParams.setObject(SingletonClass.sharedInstance.strPassengerID, forKey: "PassengerId" as NSCopying)
        dictParams.setObject(strModelId, forKey: SubmitBookingRequest.kModelId as NSCopying)
        if(strModelId == "")
        {
            dictParams.setObject(strCarModelIDIfZero, forKey: SubmitBookingRequest.kModelId as NSCopying)
            
        }
        dictParams.setObject(strPickupLocation, forKey: SubmitBookingRequest.kPickupLocation as NSCopying)
        dictParams.setObject(strDropoffLocation, forKey: SubmitBookingRequest.kDropoffLocation as NSCopying)
        
        dictParams.setObject(strAdditionalDropoffLocation, forKey: SubmitBookingRequest.kDropoffLocation2 as NSCopying)
        
        dictParams.setObject(doublePickupLat, forKey: SubmitBookingRequest.kPickupLat as NSCopying)
        dictParams.setObject(doublePickupLng, forKey: SubmitBookingRequest.kPickupLng as NSCopying)
        
        dictParams.setObject(doubleDropOffLat, forKey: SubmitBookingRequest.kDropOffLat as NSCopying)
        dictParams.setObject(doubleDropOffLng, forKey: SubmitBookingRequest.kDropOffLon as NSCopying)
        
        dictParams.setObject(doubleUpdateNewLat, forKey: SubmitBookingRequest.kDropOffLat2 as NSCopying)
        dictParams.setObject(doubleUpdateNewLng, forKey: SubmitBookingRequest.kDropOffLon2 as NSCopying)
        
        
        dictParams.setObject(txtNote.text!, forKey: SubmitBookingRequest.kNotes as NSCopying)
        dictParams.setObject(strSpecialRequest, forKey: SubmitBookingRequest.kSpecial as NSCopying)
        dictParams.setObject(self.strSelectedCarTotalFare, forKey: "EstimateFare" as NSCopying)
        if paymentType == "" {
        }
        else {
            dictParams.setObject(paymentType, forKey: SubmitBookingRequest.kPaymentType as NSCopying)
        }
        
        if txtHavePromocode.text == "" {
        } else {
            dictParams.setObject(txtHavePromocode.text!, forKey: SubmitBookingRequest.kPromoCode as NSCopying)
        }
        
//        if CardID == "" {
//        } else {
//            dictParams.setObject(CardID, forKey: SubmitBookingRequest.kCardId as NSCopying)
//        }
        
        if intShareRide == 1 {
            dictParams.setObject(intShareRide, forKey: SubmitBookingRequest.kShareRide as NSCopying)
            dictParams.setObject(intNumberOfPassengerOnShareRiding, forKey: SubmitBookingRequest.kNoOfPassenger as NSCopying)
        }
        
        self.view.bringSubview(toFront: self.viewMainActivityIndicator)
        self.viewMainActivityIndicator.isHidden = false
        webserviceForTaxiRequest(dictParams) { (result, status) in
            
            if (status) {
                //      print(result)
                
                SingletonClass.sharedInstance.bookedDetails = (result as! NSDictionary)
                
                if let bookingId = ((result as! NSDictionary).object(forKey: "details") as! NSDictionary).object(forKey: "BookingId") as? Int {
                    SingletonClass.sharedInstance.bookingId = "\(bookingId)"
                }
                
                self.strBookingType = "BookNow"
                self.viewBookNow.isHidden = true
                self.viewActivity.startAnimating()
            }
            else {
                //    print(result)
                
                self.viewBookNow.isHidden = true
                self.viewMainActivityIndicator.isHidden = true
                
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "Error", message: res) { (index, title) in
                    }
                }
                else if let resDict = result as? NSDictionary {
                    if((resDict.object(forKey: "message") as? NSArray) != nil) {
                        UtilityClass.setCustomAlert(title: "Error", message: (resDict.object(forKey: "message") as! NSArray).object(at: 0) as! String) { (index, title) in
                        }
                    } else {
                        UtilityClass.setCustomAlert(title: "Error", message: resDict.object(forKey: "message") as! String) { (index, title) in
                        }
                    }
                } else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    }
                }
            }
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - View Book Now
    //-------------------------------------------------------------
    
    @IBAction func tapToDismissActivityIndicator(_ sender: UITapGestureRecognizer) {
        viewMainActivityIndicator.isHidden = true
        
        //        socketMethodForCancelRequestTrip()
        
    }
    @IBOutlet weak var viewMainActivityIndicator: UIView!
    @IBOutlet weak var viewActivity: NVActivityIndicatorView!
    
    @IBOutlet weak var viewBookNow: UIView!
    
    @IBOutlet weak var viewSelectPaymentOptionParent: UIView!
    @IBOutlet weak var viewSelectPaymentOption: UIView!
    @IBOutlet weak var txtSelectPaymentOption: UITextField!
    
    @IBOutlet weak var viewHavePromocode: M13Checkbox!
    @IBOutlet weak var stackViewOfPromocode: UIStackView!
    @IBOutlet weak var stackViewNumberOfPassenger: UIStackView!
    
    @IBOutlet weak var txtNumberOfPassengers: UITextField!
    
    @IBOutlet weak var imgPaymentType: UIImageView!
    @IBOutlet weak var txtHavePromocode: UITextField!
    @IBOutlet weak var txtNote: UITextField!
    var boolIsSelected = Bool()
    
    var pickerView = UIPickerView()
    var pickerViewForNoOfPassenger = UIPickerView()
    
    var CardID = String()
    var paymentType = String()
    
    var intNumberOfPassengerOnShareRiding = Int()
    
    @IBAction func btnPromocode(_ sender: UIButton) {
        
        boolIsSelected = !boolIsSelected
        
        if (boolIsSelected) {
            stackViewOfPromocode.isHidden = false
            viewHavePromocode.checkState = .checked
            viewHavePromocode.stateChangeAnimation = .fill
        }
        else {
            stackViewOfPromocode.isHidden = true
            viewHavePromocode.checkState = .unchecked
            viewHavePromocode.stateChangeAnimation = .fill
        }
    }
    
    @IBAction func viewHavePromocode(_ sender: M13Checkbox) {
        
        //        boolIsSelected = !boolIsSelected
        //
        //        if (boolIsSelected) {
        //            stackViewOfPromocode.isHidden = false
        //        }
        //        else {
        //            stackViewOfPromocode.isHidden = true
        //
        //        }
    }
    @IBAction func tapToDismissBookNowView(_ sender: UITapGestureRecognizer) {
        viewBookNow.isHidden = true
    }
    
    @IBAction func txtPaymentOption(_ sender: UITextField) {
        pickerView.delegate = self
        pickerView.dataSource = self
        txtSelectPaymentOption.inputView = pickerView
    }
    
    @IBAction func txtNumberOfPassenger(_ sender: UITextField) {
        
        pickerViewForNoOfPassenger.delegate = self
        pickerViewForNoOfPassenger.dataSource = self
        //        pickerViewForNoOfPassenger.sc
        txtNumberOfPassengers.inputView = pickerViewForNoOfPassenger
    }
    
    @IBAction func btnRequestNow(_ sender: UIButton) {
        self.webserviceCallForBookingCar()
    }
    
    //-------------------------------------------------------------
    // MARK: - PickerView Methods
    //-------------------------------------------------------------
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == pickerViewForNoOfPassenger {
            return 2
        }
        return cardData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        if pickerView == pickerViewForNoOfPassenger {
            return 120
        }
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        if pickerView == pickerViewForNoOfPassenger {
            
            let myView = UIView(frame: CGRect(x:0, y:0, width: pickerViewForNoOfPassenger.frame.size.width, height: pickerViewForNoOfPassenger.frame.size.height))
            
            let myImageView = UIImageView(frame: CGRect(x:myView.center.x - 50, y:myView.center.y - 50, width:100, height:100))
            var rowString = String()
            switch row {
            
            case 0:
                myImageView.image = UIImage(named: "circle.png")
                rowString = "1"
            case 1:
                myImageView.image = UIImage(named: "circle.png")
                rowString = "2"
            default:
                print("something wrong")
            }
            
            let myLabel = UILabel(frame: CGRect(x:myImageView.center.x-10, y:myImageView.center.y-25, width:50, height:50 ))
            myLabel.font = UIFont.systemFont(ofSize: 30)
            myLabel.text = rowString
            
            
            myView.addSubview(myImageView)
            myView.addSubview(myLabel)
            
            return myView
        }
        
        let data = cardData[row]
        
        let myView = UIView(frame: CGRect(x:0, y:0, width: pickerView.bounds.width - 30, height: 60))
        
        let myImageView = UIImageView(frame: CGRect(x:0, y:0, width:50, height:50))
        
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == pickerViewForNoOfPassenger {
            if row == 0 {
                intNumberOfPassengerOnShareRiding = 1
            } else if row == 1 {
                intNumberOfPassengerOnShareRiding = 2
            }
            txtNumberOfPassengers.text = "\(intNumberOfPassengerOnShareRiding)"
        } else {
            let data = cardData[row]
            
            imgPaymentType.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
            txtSelectPaymentOption.text = data["CardNum2"] as? String
            
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
                CardID = data["Id"] as! String
            }
        }
        // do something with selected row
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
        case "other":
            CardIcon = "iconDummyCard"
            return CardIcon
        default:
            return ""
        }
    }
    
    // ----------------------------------------------------------------------
    //-------------------------------------------------------------
    // MARK: - Webservice For Find Cards List Available
    //-------------------------------------------------------------
    
    func callToWebserviceOfCardListViewDidLoad() {
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.reloadWebserviceOfCardList), name: NSNotification.Name(rawValue: "CardListReload"), object: nil)
    }
    
    var isReloadWebserviceOfCardList = Bool()
    
    @objc func reloadWebserviceOfCardList() {
        self.webserviceOfCardList()
        isReloadWebserviceOfCardList = true
        //        self.paymentOptions()
    }
    
    var aryCardsListForBookNow = [[String:AnyObject]]()
    
    func webserviceOfCardList() {
        
        webserviceForCardList(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
            
            if (status) {
                //        print(result)
                
                if let res = result as? [String:AnyObject] {
                    if let cards = res["cards"] as? [[String:AnyObject]] {
                        self.aryCardsListForBookNow = cards
                    }
                }
                
                var dict = [String:AnyObject]()
                dict["CardNum"] = "cash" as AnyObject
                dict["CardNum2"] = "cash" as AnyObject
                dict["Type"] = "iconCashBlack" as AnyObject
                
                var dict2 = [String:AnyObject]()
                dict2["CardNum"] = "wallet" as AnyObject
                dict2["CardNum2"] = "wallet" as AnyObject
                dict2["Type"] = "iconWalletBlack" as AnyObject
                
                self.aryCardsListForBookNow.append(dict)
                self.aryCardsListForBookNow.append(dict2)
                
                SingletonClass.sharedInstance.CardsVCHaveAryData = (result as! NSDictionary).object(forKey: "cards") as! [[String:AnyObject]]
                
                self.pickerView.reloadAllComponents()
                
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "CardListReload"), object: nil)
                
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
                //    print(result)
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
    
    
    //    //MARK:- SideMenu Methods
    //
    //    @IBOutlet weak var openSideMenu: UIButton!
    //    @IBAction func openSideMenu(_ sender: Any) {
    //
    //        sideMenuController?.toggle()
    //
    //    }
    func onGetEstimateFare() {
        
        self.socket?.on(SocketData.kReceiveGetEstimateFare, callback: { (data, ack) in
//            print("onGetEstimateFare() is \(data)")
            
            
            if (((data as NSArray).firstObject as? NSDictionary) != nil) {
                var estimateData = (data as! [[String:AnyObject]])
                
                if estimateData[0]["estimate_fare"] != nil
                {
                    estimateData =  estimateData[0]["estimate_fare"] as! [[String:AnyObject]]
                    
                    let sortedArray = estimateData.sorted {($0["sort"] as! Int) < ($1["sort"] as! Int)}
                    
                    if self.aryEstimateFareData == self.aryEstimateFareData {
                        
                        let ary1 = self.aryEstimateFareData as! [[String:AnyObject]]
                        let ary2 = sortedArray
                        
                        for i in 0..<self.aryEstimateFareData.count {
                            
                            let dict1 = ary1[i] as NSDictionary
                            let dict2 = ary2[i] as NSDictionary
                            
                            if dict1 != dict2 {
                                
                                UIView.performWithoutAnimation {
                                    self.collectionViewCars.reloadData()
                                }
                            }
                        }
                    }
                    
                    self.aryEstimateFareData = NSMutableArray(array: sortedArray).mutableCopy() as! NSMutableArray
                    var count = Int()
                    for i in 0..<self.arrNumberOfOnlineCars.count
                    {
                        let dictOnlineCarData = (self.arrNumberOfOnlineCars.object(at: i) as! NSDictionary)
                        count = count + (dictOnlineCarData["carCount"] as! Int)
                        if (count == 0)
                        {
                            
                            if(self.arrNumberOfOnlineCars.count == 0)
                            {
                                
                                let alert = UIAlertController(title: "",
                                                              message: "Book Now cars not available. Please click OK to Book Later.",
                                                              preferredStyle: UIAlertControllerStyle.alert)
                                
                                
                                alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: { (action) in
                                    self.btnBookLater((Any).self)
                                }))
                                
                                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                                }))
                                
                                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
                                
                            }
                        }
                    }
                    /// RJ change this is use for pass data to
                    SingletonClass.sharedInstance.aryEstimateFareData = self.aryEstimateFareData
                    UIView.performWithoutAnimation {
                        self.collectionViewCars.reloadData()
                        for vc in (UIApplication.topViewController()?.childViewControllers ?? [])
                        {
                            for navVC in vc.childViewControllers
                            {
                                if let bookLaterVC = navVC as? BookLaterViewController
                                {
                                    bookLaterVC.postPickupAndDropLocationForEstimateFare()
                                }
                            }
                        }
                    }
                }
            }
        })
    }
    
    func onDriverArrived() {
        
        self.socket?.on(SocketData.kDriverArrived, callback: { (data, ack) in
            print(#function,data)
            
            if (((data as NSArray).firstObject as? NSDictionary) != nil) {
                _ = (data as! [[String:AnyObject]])
                if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                    if SelectedLanguage == "en" {
                        
                        UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
                        })
                    }
                    else if SelectedLanguage == "sw"
                    {
                        UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["swahili_message"]! as! String, completionHandler: { (index, title) in
                        })
                    }
                }
            }
        })
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods for Add Address to Favourite
    //-------------------------------------------------------------
    
    func webserviceOfAddAddressToFavourite(type: String) {
        //        PassengerId,Type,Address,Lat,Lng
        
        var param = [String:AnyObject]()
        param["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
        param["Type"] = type as AnyObject
        param["Address"] = txtDestinationLocation.text as AnyObject
        param["Lat"] = doubleDropOffLat as AnyObject  // SingletonClass.sharedInstance.currentLatitude as AnyObject
        param["Lng"] = doubleDropOffLng as AnyObject  // SingletonClass.sharedInstance.currentLongitude as AnyObject
        
        webserviceForAddAddress(param as AnyObject) { (result, status) in
            
            if (status) {
                //  print(result)
                
                if let res = result as? String {
                    
                    UtilityClass.setCustomAlert(title: "Error", message: res) { (index, title) in
                    }
                }
                else if let res = result as? NSDictionary {
                    
                    let alert = UIAlertController(title: nil, message: res.object(forKey: "message") as? String, preferredStyle: .alert)
                    let OK = UIAlertAction(title: "OK".localized, style: .default, handler: { ACTION in
                        
                        UIView.transition(with: self.viewForMainFavourite, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
                            self.viewForMainFavourite.isHidden = true
                        }) { _ in }
                    })
                    alert.addAction(OK)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else {
                //     print(result)
            }
        }
    }
    
    //MARK: - Setup Google Maps
    func setupGoogleMap()
    {
        // Initialize the location manager.
        //        locationManager = CLLocationManager()
        //        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestAlwaysAuthorization()
        //        locationManager.distanceFilter = 0.1
        //        locationManager.delegate = self
        //        locationManager.startUpdatingLocation()
        //        locationManager.startUpdatingHeading()
        
        locationManager.delegate = self
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            if (locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) || locationManager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization))) {
                if locationManager.location != nil {
                    locationManager.startUpdatingLocation()
                }
            }
        }
        
        placesClient = GMSPlacesClient.shared()
        
//
        
        // Create a map.
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: 17)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        
        mapView.camera = camera
        mapView.delegate = self
        self.locationEnteredType = .pickup
        self.mapView.settings.rotateGestures = false
        self.mapView.settings.tiltGestures = false
        
        //        let position = CLLocationCoordinate2D(latitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude)
        //        let marker = GMSMarker(position: position)
        //        marker.map = self.mapView
        //        marker.isDraggable = true
        //        marker.icon = UIImage(named: "iconCurrentLocation")
        
        //        mapView.settings.myLocationButton = false
        //        mapView.isMyLocationEnabled = true
        
        //        self.mapView.padding = UIEdgeInsets(top:txtDestinationLocation.frame.size.height + txtDestinationLocation.frame.origin.y, left: 0, bottom: 0, right: 0)
        
        viewMap.addSubview(mapView)
        mapView.isHidden = true
        
    }
    var x = 1
    
    func getPlaceFromLatLong()
    {
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            //            self.txtCurrentLocation.text = "No current place"
            self.txtCurrentLocation.text = ""
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    let SelectedCurrentLocation = "\(place.name ?? ""), \(place.formattedAddress ?? "")"
                    self.strPickupLocation = SelectedCurrentLocation
                    //                        place.formattedAddress!
                    self.doublePickupLat = place.coordinate.latitude
                    self.doublePickupLng = place.coordinate.longitude
                    self.txtCurrentLocation.text = SelectedCurrentLocation
                    //                        place.formattedAddress?.components(separatedBy: ", ")
                    //                        .joined(separator: "\n")
                    self.locationEnteredType = .pickup
                }
            }
        })
    }
    
    //MARK:- IBActions
    var cardData = [[String:AnyObject]]()
    
    @objc func newBooking(_ sender: UIButton) {
        let alert = UIAlertController(title: "New Booking", message: "This will clear old trip details on map for temporary now.", preferredStyle: .alert)
        let OK = UIAlertAction(title: "OK".localized, style: .default, handler: { ACTION in            self.clearSetupMapForNewBooking()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { ACTION in
        })
        alert.addAction(OK)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnCollectionViewScrollRight(_ sender: Any) {
        if (arrTotalNumberOfCars.count <= 3) {
            //            self.collectionViewCars.scrollToItem(at: NSIndexPath(row: 0, section: 0) as IndexPath, at: .right, animated: true)
        }
        else {
            
            if self.collectionViewCars!.contentSize.width >= 150 {
                self.collectionViewCars.scrollToItem(at: NSIndexPath(row: arrTotalNumberOfCars.count-1, section: 0) as IndexPath, at: .right, animated: true)
            }
        }
    }
    
    @IBAction func btnCollectionViewScrollLeft(_ sender: Any) {
        self.collectionViewCars.scrollToItem(at: NSIndexPath(row: 0, section: 0) as IndexPath, at: .left, animated: true)
    }
    
    var dictSelectedDriver : [String : AnyObject]?
    
    @IBAction func btnBookNow(_ sender: Any) {
        
        if Connectivity.isConnectedToInternet()
        {
            
            if intShareRide == 1 {
                self.stackViewNumberOfPassenger.isHidden = false
                txtNumberOfPassengers.text = "1"
            }
            else {
                self.stackViewNumberOfPassenger.isHidden = true
                txtNumberOfPassengers.text = ""
            }
            
            if SingletonClass.sharedInstance.strPassengerID == "" || strModelId == "" || strPickupLocation == "" || strDropoffLocation == "" || doublePickupLat == 0 || doublePickupLng == 0 || doubleDropOffLat == 0 || doubleDropOffLng == 0 || strCarModelID == ""
            {
                if txtCurrentLocation.text!.count == 0 {
                    
                    UtilityClass.setCustomAlert(title: "Missing", message: "Please enter your pickup location again") { (index, title) in
                    }
                }
                else if txtDestinationLocation.text!.count == 0 {
                    
                    UtilityClass.setCustomAlert(title: "Missing", message: "Please enter your destination again") { (index, title) in
                    }
                }
                else if strCarModelID == "" {
                    UtilityClass.setCustomAlert(title: "Missing", message: "Please select a vehicle".localized) { (index, title) in
                    }
                }
                else if strModelId == "" {
                    
                    //                UtilityClass.setCustomAlert(title: "Missing", message: "Please Select Car".localized) { (index, title) in
                    //                }
                    UtilityClass.setCustomAlert(title: "Missing", message: "Vehicle not available".localized) { (index, title) in
                    }
                    //                    UtilityClass.setCustomAlert(title: appName, message: "There are no cars available. Do you want to pay extra chareges?") { (index, title) in
                    //                    }
                    
                    
                    //"There are no vehicles available within 5 kms and do u want to pay additional \(currencySign) \(strSpecialRequestFareCharge) and make a booking?"
                    
                    //                    let alert = UIAlertController(title: appName, message: "Car not available"  , preferredStyle: .alert)
                    //                    let OK = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
                    ////                        self.strSpecialRequest = "1"
                    ////                        self.bookingRequest()
                    ////                        self.webserviceCallForMissBookingRequest()
                    //
                    //                    })
                    ////                    let Cancel = UIAlertAction(title: "No", style: .destructive, handler: { ACTION in
                    ////
                    ////                        self.webserviceCallForMissBookingRequest()
                    ////
                    ////                    })
                    ////
                    //
                    //                    alert.addAction(OK)
                    ////                    alert.addAction(Cancel)
                    //                    self.present(alert, animated: true, completion: nil)
                    
                }
                else {
                    
                    UtilityClass.setCustomAlert(title: "Missing", message: "Locations or select available car") { (index, title) in
                    }
                }
                
            }
            else {
                
                
                let myAttribute = [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
                let myString = NSMutableAttributedString(string: "Pickup location : \n", attributes: myAttribute )
              
                let fare = (aryEstimateFareData.object(at: selectedIndexPath?.item ?? 0) as? NSDictionary)?.object(forKey: "estimate_fare_range") as? String ?? "0.0"
                
                myString.append(NSAttributedString(string:txtCurrentLocation.text ?? ""))
                myString.append(NSAttributedString(string:"\n\nDestination Location : ",attributes: myAttribute))
                myString.append(NSAttributedString(string:txtDestinationLocation.text ?? ""))

                if(txtAdditionalDestinationLocation.text != "")
                {
                    myString.append(NSAttributedString(string:"\n\nAdditional Destination Location : ",attributes: myAttribute))
                    myString.append(NSAttributedString(string:txtAdditionalDestinationLocation.text ?? ""))
                }
                
                myString.append(NSAttributedString(string:"\n\nApproximate Fare : \n",attributes: myAttribute))
                myString.append(NSAttributedString(string:fare))

                let alert = UIAlertController(title: appName, message: "", preferredStyle: UIAlertControllerStyle.alert)
                    alert.setValue(myString, forKey: "attributedMessage")

                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    self.strSpecialRequest = "0"
                    self.bookingRequest()
                    self.SetPaymentOption(SelectionIndex: 0)
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in

                }))
                
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }
        else {
            UtilityClass.showAlert("", message: "Internet connection not available", vc: self)
        }
    }
    
    
    func bookingRequest()
    {
        
        //        if (SingletonClass.sharedInstance.CardsVCHaveAryData.count == 0) && self.aryCardsListForBookNow.count == 2 {
        //            //                UtilityClass.showAlert("", message: "There is no card, If you want to add card than choose payment options to add card.", vc: self)
        //
        //            let alert = UIAlertController(title: nil, message: "Do you want to add card.", preferredStyle: .alert)
        //            let OK = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
        //
        //                let next = mainStoryborad.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
        //
        //                next.delegateAddCardFromHomeVC = self
        //
        //                self.navigationController?.present(next, animated: true, completion: nil)
        //
        //            })
        //            let Cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { ACTION in
        //                self.paymentOptions()
        //            })
        //            alert.addAction(OK)
        //            alert.addAction(Cancel)
        //            self.present(alert, animated: true, completion: nil)
        //
        //        }
        //        else {
        self.paymentOptions()
        //        }
        
    }
    @IBOutlet weak var lblSelectPaymentTitle: UILabel!
    
    @IBOutlet weak var lblPromocode: UILabel!
    @IBOutlet weak var PayCashView: UIView!
    
    @IBOutlet weak var CashLogo: UIImageView!
    @IBOutlet weak var btnCash: UIButton!
    
    @IBOutlet weak var PayWalletView: UIView!
    @IBOutlet weak var WalletLogo: UIImageView!
    @IBOutlet weak var btnWallet: UIButton!
    
    @IBOutlet weak var imgCard: UIImageView!
    @IBOutlet weak var btnCardSelection: UIButton!
    
    @IBOutlet weak var PayCardView: UIView!
    @IBOutlet weak var CardLogo: UIImageView!
    @IBOutlet weak var btnPesaPal: UIButton!
    
    @IBAction func btnPayment(_ sender: UIButton) {
        
        switch sender {
        case self.btnCash:
            self.SetPaymentOption(SelectionIndex: 0)
            
        case self.btnWallet:
            self.SetPaymentOption(SelectionIndex: 1)
            
        case self.btnPesaPal:
            self.SetPaymentOption(SelectionIndex: 2)
            
        case self.btnCardSelection:
            self.SetPaymentOption(SelectionIndex: 3)
            
        default:
            break
        }
    }
    
    @IBAction func btnPesaPalOptionClicked(_ sender: UIButton) {
    }
    
    func SetPaymentOption(SelectionIndex:Int) {
        
        self.CashLogo.image = UIImage(named: "icon_CashUnselected")
        self.WalletLogo.image = UIImage(named: "icon_UnSelectedWallet")
        self.CardLogo.image = UIImage(named: "icon_UnselectedCard")
        self.imgCard.image = UIImage(named: "icon_UnselectedCard")
        
        //        self.btnCash.isSelected = false
        //        self.btnWallet.isSelected = false
        //        self.btnPesaPal.isSelected = false
        
        self.PayCashView.backgroundColor = UIColor.init(hex: "E5E5E5")
        self.PayWalletView.backgroundColor = UIColor.init(hex: "E5E5E5")
        self.PayCardView.backgroundColor = UIColor.init(hex: "E5E5E5")
        
        self.btnCash.setTitleColor(UIColor.black, for: .normal)
        self.btnCardSelection.setTitleColor(UIColor.black, for: .normal)
        //        self.btnCardSelection.setTitle("Card", for: .normal)
        CardID = ""
        
        if SelectionIndex == 0 {
            
            self.btnCash.setTitleColor(themeYellowColor, for: .normal)
            
            self.CashLogo.image = UIImage(named: "icon_SelectedCash")
            self.CashLogo.tintColor = .red
            //            self.btnCash.isSelected = true
            self.PayCashView.backgroundColor = UIColor.black
            paymentType = "cash"
            btnCash.setTitleColor(themeAppMainColor, for: .normal)
            btnCardSelection.setTitle("Card", for: .normal)
            CardID = ""
            
        } else if SelectionIndex == 1 {
            self.WalletLogo.image = UIImage(named: "icon_SelectedWallet")
            //            self.btnWallet.isSelected = true
            //            self.PayWalletView.backgroundColor = UIColor.black
            paymentType = "wallet"
        } else if SelectionIndex == 2 {
            self.CardLogo.image = UIImage(named: "icon_SelectedCard")
            //            self.btnPesaPal.isSelected = true
            //            self.PayCardView.backgroundColor = UIColor.black
            paymentType = "card"  //"pesapal"
        } else if SelectionIndex == 3 {
            
            self.imgCard.image = UIImage(named: "icon_SelectedCard")
            self.btnCardSelection.setTitleColor(themeYellowColor, for: .normal)
            paymentType = "card" //rjChange "m_pesa"
            
            self.imgCard.tintColor = .red
            self.PayCardView.backgroundColor = UIColor.black
            btnCardSelection.setTitleColor(themeAppMainColor, for: .normal)

//            if SingletonClass.sharedInstance.CardsVCHaveAryData.count == 0 {
//                let next = mainStoryboard.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
//                next.delegateAddCardFromHomeVC = self
//                self.navigationController?.pushViewController(next, animated: true)
//            } else {
//                let next = mainStoryboard.instantiateViewController(withIdentifier: "WalletCardsVC") as! WalletCardsVC
//                next.delegateForHomeAddcard = self
//                next.canEditRowBool = false
//                self.navigationController?.pushViewController(next, animated: true)
//            }
        }
        //        paymentType = "cash"
    }
    
    func didAddCard(cards: [String : Any]) {
        
        let cardPostfix = (cards["CardNum2"] as? String ?? "").components(separatedBy: " ").last ?? ""
        CardID = cards["Id"] as? String ?? ""
        btnCardSelection.setTitle("Card (\(cardPostfix))", for: .normal)
    }
    
    @IBAction func btnAddCard(_ sender: Any) {
        
        //        let next = mainStoryborad.instantiateViewController(withIdentifier: "WalletCardsVC") as! WalletCardsVC
        //        SingletonClass.sharedInstance.isFromTopUP = true
        //        next.delegateForTopUp = self
        //        self.navigationController?.pushViewController(next, animated: true)
        
        
        //        let next = mainStoryborad.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
        //
        //        next.delegateAddCardFromHomeVC = self
        //
        //        self.navigationController?.present(next, animated: true, completion: nil)
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Select Card Delegate Methods
    //-------------------------------------------------------------
    
    func didSelectCard(dictData: [String : AnyObject]) {
        print(dictData)
        CardID = dictData["Id"] as! String
        self.SetPaymentOption(SelectionIndex: 2)
    }
    
    func paymentOptions() {
        
        if SingletonClass.sharedInstance.CardsVCHaveAryData.count != 0 {
            
            cardData = SingletonClass.sharedInstance.CardsVCHaveAryData
            
            for i in 0..<aryCardsListForBookNow.count {
                cardData.append(aryCardsListForBookNow[i])
            }
            
            if self.aryCardsListForBookNow.count != 0 {
                cardData = self.aryCardsListForBookNow
            }
            
        }
        else {
            cardData.removeAll()
            
            for i in 0..<aryCardsListForBookNow.count {
                cardData.append(aryCardsListForBookNow[i])
            }
        }
        self.pickerView.reloadAllComponents()
        
        let data = cardData.first
        
        //        imgPaymentType.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        //        txtSelectPaymentOption.text = data["CardNum2"] as? String
        //
        let type = data?["CardNum"] as? String
        
        if type  == "wallet" {
            paymentType = "wallet"
        }
        else if type == "cash" {
            paymentType = "cash"
        }
        else {
            paymentType =  "card" //"pesapal"//"card"
        }
        
//        if paymentType == "card" {
//            CardID = data["Id"] as! String
//        }
        
        //        self.SetPaymentOption(SelectionIndex: 0)
        viewBookNow.isHidden = false
        
        //        paymentType = "cash"
        
        //         self.webserviceCallForBookingCar()
    }
    
    func didAddCardFromHomeVC() {
        paymentOptions()
    }
    
    @IBAction func btnBookLater(_ sender: Any)
    {
        
        if(txtAdditionalDestinationLocation.text == "")
        
        {
            if Connectivity.isConnectedToInternet() {
                
                let profileData = SingletonClass.sharedInstance.dictProfile
                
                // This is For Book Later Address
                if (SingletonClass.sharedInstance.isFromNotificationBookLater) {
                    
                    if strCarModelID == ""
                    {
                        
                        //                UtilityClass.setCustomAlert(title: "Missing", message: "Please Select Car".localized) { (index, title) in
                        //                }
                        UtilityClass.setCustomAlert(title: "Missing", message: "Please select a vehicle type.".localized) { (index, title) in
                        }
                    }
                    else
                    {
                        let next = mainStoryboard.instantiateViewController(withIdentifier: "BookLaterViewController") as! BookLaterViewController
                        
                        SingletonClass.sharedInstance.isFromNotificationBookLater = false
                        next.BookLaterCompleted = self
                        next.strModelId = strCarModelID
                        next.strCarModelURL = strNavigateCarModel
                        next.strCarName = strCarModelClass
                        
                        next.dictSelectedDriver = self.dictSelectedDriver
                        
                        next.strFullname = profileData.object(forKey: "Fullname") as! String
                        next.strMobileNumber = profileData.object(forKey: "MobileNo") as! String
                        
                        next.strPickupLocation = strPickupLocation
                        next.doublePickupLat = doublePickupLat
                        next.doublePickupLng = doublePickupLng
                        
                        next.strDropoffLocation = strDropoffLocation
                        next.doubleDropOffLat = doubleDropOffLat
                        next.doubleDropOffLng = doubleDropOffLng
                        
                        self.navigationController?.pushViewController(next, animated: true)
                    }
                }
                else {
                    
                    if strCarModelID == "" && strCarModelIDIfZero == ""{
                        //                UtilityClass.setCustomAlert(title: "Missing", message: "Please Select Car".localized) { (index, title) in
                        //                }
                        UtilityClass.setCustomAlert(title: "Missing", message: "Please select a vehicle type.".localized) { (index, title) in
                        }
                    }
                    else {
                        let next = mainStoryboard.instantiateViewController(withIdentifier: "BookLaterViewController") as! BookLaterViewController
                        next.BookLaterCompleted = self
                        next.strModelId = strCarModelID
                        next.strCarModelURL = strNavigateCarModel
                        next.strCarName = strCarModelClass
                        
                        next.dictSelectedDriver = self.dictSelectedDriver
                        
                        next.strPickupLocation = strPickupLocation
                        next.doublePickupLat = doublePickupLat
                        next.doublePickupLng = doublePickupLng
                        
                        next.strDropoffLocation = strDropoffLocation
                        next.doubleDropOffLat = doubleDropOffLat
                        next.doubleDropOffLng = doubleDropOffLng
                        
                        next.strFullname = profileData.object(forKey: "Fullname") as! String
                        next.strMobileNumber = profileData.object(forKey: "MobileNo") as! String
                        
                        self.navigationController?.pushViewController(next, animated: true)
                    }
                }
            } else {
                UtilityClass.showAlert("", message: "Internet connection not available", vc: self)
            }
        }
        else
        {
            UtilityClass.showAlert("", message: "Multiple Dropoff is not allowed for book later request.", vc: self)
        }
    }
    
    @IBAction func btnGetFareEstimate(_ sender: Any) {
        
        if txtCurrentLocation.text == "" || txtDestinationLocation.text == "" {
            
            UtilityClass.setCustomAlert(title: "Missing", message: "Please enter both address.") { (index, title) in
            }
        } else {
            self.postPickupAndDropLocationForEstimateFare()
        }
    }
    
    @IBOutlet weak var btnRequest: ThemeButton!
    
    @IBAction func btnRequest(_ sender: ThemeButton) {
        
        let alert = UIAlertController(title: "", message: "Are you sure you want to cancel the trip?".localized, preferredStyle: .alert)
        let OK = UIAlertAction(title: "YES".localized, style: .default, handler: { ACTION in
            
            alert.dismiss(animated: false) {
                let reasonsVC = CancelAlertViewController(nibName: "CancelAlertViewController", bundle: nil)
                reasonsVC.okPressedClosure = { (reason) in
                    if self.strBookingType == "BookLater" {
                        self.CancelBookLaterTripAfterDriverAcceptRequest(withReason: reason)
                    } else {
                        self.socketMethodForCancelRequestTrip(withReason: reason)
                    }
                    
                    self.clearMap()
                    self.txtCurrentLocation.text = ""
                    self.txtDestinationLocation.text = ""
                    self.txtAdditionalDestinationLocation.text = ""
                    self.clearDataAfteCompleteTrip()
                    self.getPlaceFromLatLong()
                    
                    //        UtilityClass.setCustomAlert(title: "\(appName)", message: "Request Cancelled") { (index, title) in
                    //        }
                    
                    self.viewTripActions.isHidden = true
                    self.constraintVerticalSpacingLocation?.priority = UILayoutPriority(800)

                    self.viewCarLists.isHidden = false
                    self.ConstantViewCarListsHeight.constant = 150
                    reasonsVC.dismiss(animated: true, completion: nil)
                }
                
                    reasonsVC.modalPresentationStyle = .overCurrentContext
                    self.present(reasonsVC, animated: true)
            }
        
            
          
        })
        let Cancel = UIAlertAction(title: "NO".localized, style: .destructive, handler: { ACTION in
            //            self.paymentOptions()
        })
        alert.addAction(OK)
        alert.addAction(Cancel)
        self.present(alert, animated: true, completion: nil)
        //        Utilities.presentPopupOverScreen(alert)
        
        
        //        self.constraintTopSpaceViewDriverInfo.constant = 170
        //        self.viewShareRideView.isHidden = true
        
    }
    
    
    @IBOutlet weak var btnDriverInfo: ThemeButton!
    
    @IBAction func btnDriverInfo(_ sender: ThemeButton) {
        
        let DriverInfo = ((self.aryRequestAcceptedData.object(at: 0) as! NSDictionary).object(forKey: "DriverInfo") as! NSArray).object(at: 0) as! NSDictionary
        let carInfo = ((self.aryRequestAcceptedData.object(at: 0) as! NSDictionary).object(forKey: "CarInfo") as! NSArray).object(at: 0) as! NSDictionary
        let bookingInfo = ((self.aryRequestAcceptedData.object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
        
        showDriverInfo(bookingInfo: bookingInfo, DriverInfo: DriverInfo, carInfo: carInfo)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func swipDownDriverInfo(_ sender: UISwipeGestureRecognizer) {
        //        constraintTopSpaceViewDriverInfo.constant = 170
    }
    
    @IBAction func TapToDismissGesture(_ sender: UITapGestureRecognizer) {
        
        UIView.transition(with: viewForMainFavourite, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
            self.viewForMainFavourite.isHidden = true
        }) { _ in }
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        //        self.dismiss(animated: true, completion: nil)
    }
    
    // function which is triggered when handleTap is called
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("Hello World")
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
    @IBAction func btnCancelStartedTrip(_ sender: UIButton) {
        UtilityClass.showAlert("", message: "Currently this feature is not available.", vc: self)
    }
    
    //-------------------------------------------------------------
    // MARK: - Favourite Delegate Methods
    //-------------------------------------------------------------
    
    func didEnterFavouriteDestination(Source: [String:AnyObject]) {
        
        txtDestinationLocation.text = Source["Address"] as? String
        strDropoffLocation = Source["Address"] as! String
        doubleDropOffLat = Double(Source["Lat"] as! String)!
        doubleDropOffLng = Double(Source["Lng"] as! String)!
    }
    
    //-------------------------------------------------------------
    // MARK: - Favourites Actions
    //-------------------------------------------------------------
    
    @IBAction func btnHome(_ sender: UIButton) {
        webserviceOfAddAddressToFavourite(type: "Home")
    }
    
    @IBAction func btnOffice(_ sender: UIButton) {
        webserviceOfAddAddressToFavourite(type: "Office")
    }
    
    @IBAction func btnAirport(_ sender: UIButton) {
        webserviceOfAddAddressToFavourite(type: "Airport")
    }
    
    @IBAction func btnOthers(_ sender: UIButton) {
        webserviceOfAddAddressToFavourite(type: "Others")
    }
    
    
    @IBOutlet weak var btnSwapAddress: UIButton!
    
    @IBAction func btnSwapAddress(_ sender: UIButton) {
        
        let pickupLet = self.doublePickupLat
        let pickuplong = self.doublePickupLng
        
        let dropoffLet = self.doubleDropOffLat
        let dropoffLong = self.doubleDropOffLng
        
        let FromAddress:String = self.txtCurrentLocation.text!
        let ToAddress:String = self.txtDestinationLocation.text!
        
        self.doublePickupLat = dropoffLet
        self.doublePickupLng = dropoffLong
        
        self.doubleDropOffLat = pickupLet
        self.doubleDropOffLng = pickuplong
        
        self.txtDestinationLocation.text = FromAddress
        self.txtCurrentLocation.text = ToAddress
    }
    
    //-------------------------------------------------------------
    // MARK: - Sound Implement Methods
    //-------------------------------------------------------------
    
    var audioPlayer:AVAudioPlayer!
    
    //    RequestConfirm.m4a
    //    ringTone.mp3
    
    func playSound(fileName: String, extensionType: String) {
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: extensionType) else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            audioPlayer.numberOfLoops = 1
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopSound(fileName: String, extensionType: String) {
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: extensionType) else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            audioPlayer.stop()
            audioPlayer = nil
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    //MARK:- Collectionview Delegate and Datasource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if self.arrNumberOfOnlineCars.count == 0 {
            return self.arrTotalNumberOfCars.count //5
        }
        
        return self.arrNumberOfOnlineCars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarsCollectionViewCell", for: indexPath as IndexPath) as! CarsCollectionViewCell
        
        //        cell.viewOfImage.layer.cornerRadius = cell.viewOfImage.frame.width / 2
        //        cell.viewOfImage.layer.borderWidth = 3.0
        
        if selectedIndexPath == indexPath
        {
            cell.CarUnderline.backgroundColor = themeRedColor
            cell.lblCarType.textColor = themeRedColor
            cell.lblPrices.textColor = themeRedColor
            cell.lblMinutes.textColor = themeRedColor
            cell.lblAvailableCars.textColor = themeRedColor
            cell.lblDistance.textColor = themeRedColor
            cell.lblCapacity.textColor = themeRedColor
            //            cell.viewOfImage.layer.borderColor = themeYellowColor.cgColor
            //            cell.viewOfImage.layer.masksToBounds = true
        }
        else
        {
            cell.CarUnderline.backgroundColor = UIColor.black
            cell.lblCarType.textColor = UIColor.black
            cell.lblPrices.textColor = UIColor.black
            cell.lblMinutes.textColor = UIColor.black
            cell.lblAvailableCars.textColor = UIColor.black
            cell.lblDistance.textColor = UIColor.black
            cell.lblCapacity.textColor = UIColor.black
            //            cell.viewOfImage.layer.borderColor = themeGrayColor.cgColor
            //            cell.viewOfImage.layer.masksToBounds = true
        }
        
        if self.arrNumberOfOnlineCars.count == 0 {
            cell.imgCars.sd_setIndicatorStyle(UIActivityIndicatorViewStyle.medium)
            cell.imgCars.sd_setShowActivityIndicatorView(true)
            
            let dictOnlineCarData = (arrTotalNumberOfCars.object(at: indexPath.row) as! [String : AnyObject])
            let imageURL = dictOnlineCarData["Image"] as! String
            
            cell.imgCars.sd_setImage(with: URL(string: imageURL), completed: { (image, error, cacheType, url) in
                cell.imgCars.sd_setShowActivityIndicatorView(false)
            })
            
            cell.lblMinutes.text = "0 min"
            cell.lblDistance.text = ""
            cell.lblCapacity.text = ""
            //            cell.lblPrices.text = "\(currencySign) 0.00"
            cell.lblCarType.text = dictOnlineCarData["Name"] as? String
            
            return cell
            
        }
//        else if (self.arrNumberOfOnlineCars.count != 0 && indexPath.row < self.arrNumberOfOnlineCars.count)
//        {
            let dictOnlineCarData = (arrNumberOfOnlineCars.object(at: indexPath.row) as! [String : AnyObject])
            let imageURL = dictOnlineCarData["Image"] as! String
            
            cell.imgCars.sd_setIndicatorStyle(UIActivityIndicatorViewStyle.medium)
            cell.imgCars.sd_setShowActivityIndicatorView(true)
            
            cell.imgCars.sd_setImage(with: URL(string: imageURL), completed: { (image, error, cacheType, url) in
                cell.imgCars.sd_setShowActivityIndicatorView(false)
            })
            
            cell.lblMinutes.text = "0 min"
            //            cell.lblPrices.text = "\(currencySign) 0.00"
            cell.lblCarType.text = dictOnlineCarData["Name"] as? String
                        
            if self.aryEstimateFareData.count != 0 {
                if let fareRange = (self.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "estimate_fare_range") as? String {
                    cell.lblPrices.text = fareRange
                    
                }
                if let minute = (self.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "est_duration") as? Int {
                    cell.lblMinutes.text = "\(minute) min ETA"
                }
                
                if let minute = (self.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "est_duration") as? Int {
                    cell.lblMinutes.text = "\(minute) min ETA"
                }
                
                if let capacity = (self.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "capacity") as? String {
                    cell.lblCapacity.text = "\(capacity)"
                }
                
//                cell.lblCapacity.backgroundColor = .red
                
                if let strAvilCAR = dictOnlineCarData["carCount"] as? Int {
                    cell.lblAvailableCars.text = "Avail \(strAvilCAR)"
                    if(selectedIndexPath == indexPath)
                    {
                        
                        let dictOnlineCarData = (arrNumberOfOnlineCars.object(at: indexPath.row) as! NSDictionary)
                        let carModelID = dictOnlineCarData.object(forKey: "Id") as? String
                        let carModelIDConverString: String = carModelID!
                          
                        let strCarName: String = dictOnlineCarData.object(forKey: "Name") as! String
                        
                        strCarModelClass = strCarName
                        strCarModelID = carModelIDConverString
                        
                        let available: Int = dictOnlineCarData.object(forKey: "carCount") as? Int ?? 0
                        let checkAvailabla = String(available)
                        
                        if checkAvailabla != "0" {
                            strModelId = dictOnlineCarData.object(forKey: "Id") as! String
                        }
                        else {
                            strModelId = ""
                        }
                    }
                }
                else if let strAvilCAR = dictOnlineCarData["carCount"] as? String {
                    cell.lblAvailableCars.text = "Avail \(strAvilCAR)"
                    if(selectedIndexPath == indexPath)
                    {
                        
                        let dictOnlineCarData = (arrNumberOfOnlineCars.object(at: indexPath.row) as! NSDictionary)
                        let carModelID = dictOnlineCarData.object(forKey: "Id") as? String
                        let carModelIDConverString: String = carModelID!
                        
                        let strCarName: String = dictOnlineCarData.object(forKey: "Name") as! String
                        
                        strCarModelClass = strCarName
                        strCarModelID = carModelIDConverString
                        
                        let available: Int = dictOnlineCarData.object(forKey: "carCount") as? Int ?? 0
                        let checkAvailabla = String(available)
                        
                        if checkAvailabla != "0" {
                            strModelId = dictOnlineCarData.object(forKey: "Id") as! String
                        }
                        else {
                            strModelId = ""
                        }
                    }
                }
                
                if let strDistance = (self.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "driver_distance") as? Double {
                    cell.lblDistance.text = "Distance \(strDistance) km"
                }
            }
//         }
        
        return cell
        
        // Maybe for future testing ///////
        
        
    }
    
    var markerOnlineCars = GMSMarker()
    var aryMarkerOnlineCars = [GMSMarker]()
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        MarkerCurrntLocation.isHidden = true
        
        if self.arrNumberOfOnlineCars.count == 0 {
            // do nothing here
            
            for i in 0..<self.aryMarkerOnlineCars.count {
                
                self.aryMarkerOnlineCars[i].map = nil
            }
            
            self.aryMarkerOnlineCars.removeAll()
            
            let dictOnlineCarData = (arrTotalNumberOfCars.object(at: indexPath.row) as! NSDictionary)
            let carModelID = dictOnlineCarData.object(forKey: "Id") as? String
            let carModelIDConverString: String = carModelID!
            
            let strCarName: String = dictOnlineCarData.object(forKey: "Name") as! String
            
            strCarModelClass = strCarName
            strCarModelID = carModelIDConverString
            
            let cell = collectionView.cellForItem(at: indexPath) as! CarsCollectionViewCell
            cell.viewOfImage.layer.borderColor = themeGrayColor.cgColor
            
            selectedIndexPath = indexPath
            
            let imageURL = dictOnlineCarData.object(forKey: "Image") as! String
            
            strNavigateCarModel = imageURL
            //                strCarModelID = ""
            strCarModelIDIfZero = carModelIDConverString
            
            let available: Int = dictOnlineCarData.object(forKey: "carCount") as? Int ?? 0
            let checkAvailabla = String(available)
            
            if checkAvailabla != "0" {
                strModelId = dictOnlineCarData.object(forKey: "Id") as! String
            }
            else {
                strModelId = ""
            }
        }
        else if (arrNumberOfOnlineCars.count != 0 && indexPath.row < self.arrNumberOfOnlineCars.count)
        {
            
            let dictOnlineCarData = (arrNumberOfOnlineCars.object(at: indexPath.row) as! NSDictionary)
            strSpecialRequestFareCharge = dictOnlineCarData.object(forKey: "SpecialExtraCharge") as? String ?? ""
            if dictOnlineCarData.object(forKey: "carCount") as! Int != 0 {
                
                self.markerOnlineCars.map = nil
                self.strSelectedCarTotalFare = "\((self.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "total") as! Int)"
                for i in 0..<self.aryMarkerOnlineCars.count {
                    
                    self.aryMarkerOnlineCars[i].map = nil
                }
                
                self.aryMarkerOnlineCars.removeAll()
                
                let available = dictOnlineCarData.object(forKey: "carCount") as! Int
                let checkAvailabla = String(available)
                
                
                var lati = dictOnlineCarData.object(forKey: "Lat") as! Double
                var longi = dictOnlineCarData.object(forKey: "Lng") as! Double
                
                
                let locationsArray = (dictOnlineCarData.object(forKey: "locations") as! [[String:AnyObject]])
                
                for i in 0..<locationsArray.count
                {
                    if( (locationsArray[i]["CarType"] as! String) == (dictOnlineCarData.object(forKey: "Id") as! String))
                    {
                        lati = (locationsArray[i]["Location"] as! [AnyObject])[0] as! Double
                        longi = (locationsArray[i]["Location"] as! [AnyObject])[1] as! Double
                        let position = CLLocationCoordinate2D(latitude: lati, longitude: longi)
                        self.markerOnlineCars = GMSMarker(position: position)
                        //                        self.markerOnlineCars.tracksViewChanges = false
                        //                        self.strSelectedCarMarkerIcon = self.markertIcon(index: indexPath.row)
                        self.strSelectedCarMarkerIcon = "dummyCar"//self.setCarImage(modelId: dictOnlineCarData.object(forKey: "Id") as! String)
                        //                        self.markerOnlineCars.icon = UIImage(named: self.markertIcon(index: indexPath.row)) // iconCurrentLocation
                        
                        self.aryMarkerOnlineCars.append(self.markerOnlineCars)
                        
                        //                        self.markerOnlineCars.map = nil
                        //                    self.markerOnlineCars.map = self.mapView
                        
                    }
                }
                
                // Show Nearest Driver from Passenger
                if self.aryMarkerOnlineCars.count != 0 {
                    if self.aryMarkerOnlineCars.first != nil {
                        if let nearestDriver = self.aryMarkerOnlineCars.first {
                            
                            let camera = GMSCameraPosition.camera(withLatitude: nearestDriver.position.latitude, longitude: nearestDriver.position.longitude, zoom: 17)
                            self.mapView.camera = camera
                        }
                    }
                }
                
                for i in 0..<self.aryMarkerOnlineCars.count {
                    
                    self.aryMarkerOnlineCars[i].position = self.aryMarkerOnlineCars[i].position
                    self.aryMarkerOnlineCars[i].icon = UIImage(named: self.setCarImage(modelId: dictOnlineCarData.object(forKey: "Id") as! String))
                    self.aryMarkerOnlineCars[i].map = self.mapView
                }
                
                let carModelID = dictOnlineCarData.object(forKey: "Id") as? String
                let carModelIDConverString: String = carModelID!
                
                let strCarName: String = dictOnlineCarData.object(forKey: "Name") as! String
                
                strCarModelClass = strCarName
                strCarModelID = carModelIDConverString
                
                selectedIndexPath = indexPath
                
                let cell = collectionView.cellForItem(at: indexPath) as! CarsCollectionViewCell
                cell.viewOfImage.layer.borderColor = themeYellowColor.cgColor
                
                let imageURL = dictOnlineCarData.object(forKey: "Image") as! String
                strNavigateCarModel = imageURL
                strCarModelIDIfZero = ""
                if checkAvailabla != "0" {
                    strModelId = dictOnlineCarData.object(forKey: "Id") as! String
                }
                else {
                    strModelId = "0"
                }
            }
            else {
                
                for i in 0..<self.aryMarkerOnlineCars.count {
                    
                    self.aryMarkerOnlineCars[i].map = nil
                }
                
                self.aryMarkerOnlineCars.removeAll()
                
                let carModelID = dictOnlineCarData.object(forKey: "Id") as? String
                let carModelIDConverString: String = carModelID!
                
                let strCarName: String = dictOnlineCarData.object(forKey: "Name") as! String
                
                strCarModelClass = strCarName
                strCarModelID = carModelIDConverString
                
                let cell = collectionView.cellForItem(at: indexPath) as! CarsCollectionViewCell
                cell.viewOfImage.layer.borderColor = themeGrayColor.cgColor
                
                selectedIndexPath = indexPath
                
                let imageURL = dictOnlineCarData.object(forKey: "Image") as! String
                
                strNavigateCarModel = imageURL
                //                strCarModelID = ""
                strCarModelIDIfZero = carModelIDConverString
                
                let available = dictOnlineCarData.object(forKey: "carCount") as! Int
                let checkAvailabla = String(available)
                
                if checkAvailabla != "0" {
                    strModelId = dictOnlineCarData.object(forKey: "Id") as! String
                }
                else {
                    strModelId = ""
                }
                
            }
            collectionViewCars.reloadData()
        }
        
        //RJ Change
        SingletonClass.sharedInstance.selectedIndexPath = indexPath
        //Code for getting online driver list and sending specific request to that driver
      /*  let alert = UIAlertController(title: appName,
                                      message: "Do you want to send booking request to specific driver?",
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let yesAction = UIAlertAction(title: "YES", style: .default) { (alertAction) in
            let driverListStoryBoard = UIStoryboard.init(name: "DriverList", bundle: nil)
            if let vcDriverList = driverListStoryBoard.instantiateViewController(withIdentifier: "SelectDriverViewController") as? SelectDriverViewController {
                let arrCurrentModelSelectedCars = NSMutableArray()
                for obj in self.arrNumberOfAvailableCars {
                    if let dict = obj as? [String: AnyObject] {
                        if let strCartype = dict["CarType"] as? String {
                            if strCartype == self.strCarModelID {
                                arrCurrentModelSelectedCars.add(dict)
                            }
                        }
                    }
                }
                vcDriverList.arrCurrentModelSelectedCars = arrCurrentModelSelectedCars
                vcDriverList.delegate = self
                self.navigationController?.pushViewController(vcDriverList, animated: true)
            }
            
            print("Push to select Driver controller")
        }
        let cancelAction = UIAlertAction(title: "NO".localized,
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(yesAction)
        if((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.presentedViewController != nil) {
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.dismiss(animated: true, completion: {
                //                vc.present(alert, animated: true, completion: nil)
                self.dictSelectedDriver = nil
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
            })
        }else {
            self.dictSelectedDriver = nil
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
        }*/
        
        //        else
        //        {
        //
        //            let PackageVC = mainStoryborad.instantiateViewController(withIdentifier: "PackageViewController")as! PackageViewController
        //            let navController = UINavigationController(rootViewController: PackageVC) // Creating a navigation controller with VC1 at the root of the navigation stack.
        //
        //            PackageVC.strPickupLocation = strPickupLocation
        //            PackageVC.doublePickupLat = doublePickupLat
        //            PackageVC.doublePickupLng = doublePickupLng
        //
        //            self.present(navController, animated:true, completion: nil)
        //
        //        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! CarsCollectionViewCell
        cell.viewOfImage.layer.borderColor = themeGrayColor.cgColor
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let CellWidth = ( UIScreen.main.bounds.width - 30 ) / 3
        return CGSize(width: CellWidth , height: self.collectionViewCars.frame.size.height)
        //        self.viewCarLists.frame.size.height
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        //        if (intShareRide == 1) {
        
        if (self.aryEstimateFareData.count) != 0 {
            if self.aryEstimateFareData.object(at: indexPath.row) as? NSDictionary != nil {
                
                if let ride = (self.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "share_ride") as? String {
                    
                    if ride == "1" {
                        return true
                    }
                    else if ride == "0" {
                        return false
                    }
                }
            }
        }
        //        }
        
        return true
    }
    
    var carLocationsLat = Double()
    var carLocationsLng = Double()
    //MARK - Set car icons
    func setData()
    {
        var k = 0 as Int
        self.arrNumberOfOnlineCars.removeAllObjects()
        
        aryTempOnlineCars = NSMutableArray()
        
        for j in 0..<self.arrTotalNumberOfCars.count
        {
            
            if ((self.arrTotalNumberOfCars[j] as! [String:AnyObject])["Status"] as! String) == "1" {
                
                k = 0
                let tempAryLocationOfDriver = NSMutableArray()
                
                let totalCarsAvailableCarTypeID = (self.arrTotalNumberOfCars.object(at: j) as! NSDictionary).object(forKey: "Id") as! String
                for i in 0..<self.arrNumberOfAvailableCars.count
                {
                    let dictLocation = NSMutableDictionary()
                    
                    let carType = (self.arrNumberOfAvailableCars.object(at: i) as! NSDictionary).object(forKey: "CarType") as! String
                    
                    if (totalCarsAvailableCarTypeID == carType) {
                        k = k+1
                    }
                    carLocationsLat = ((self.arrNumberOfAvailableCars.object(at: i) as! NSDictionary).object(forKey: "Location") as! NSArray).object(at: 0) as! Double
                    carLocationsLng = ((self.arrNumberOfAvailableCars.object(at: i) as! NSDictionary).object(forKey: "Location") as! NSArray).object(at: 1) as! Double
                    dictLocation.setDictionary(((self.arrNumberOfAvailableCars.object(at: i) as! NSDictionary) as! [AnyHashable : Any]))
                    tempAryLocationOfDriver.add(dictLocation)
                }
                
                let tempDict =  NSMutableDictionary(dictionary: (self.arrTotalNumberOfCars.object(at: j) as! NSDictionary))
                tempDict.setObject(k, forKey: "carCount" as NSCopying)
                tempDict.setObject(carLocationsLat, forKey: "Lat" as NSCopying)
                tempDict.setObject(carLocationsLng, forKey: "Lng" as NSCopying)
                tempDict.setObject(tempAryLocationOfDriver, forKey: "locations" as NSCopying)
                aryTempOnlineCars.add(tempDict)
            }
        }
        SortIdOfCarsType()
    }
    
    var aryTempOnlineCars = NSMutableArray()
    var checkTempData = NSArray()
    
    var aryOfOnlineCarsIds = [String]()
    var aryOfTempOnlineCarsIds = [String]()
    
    func SortIdOfCarsType() {
        
        //        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
        
        let sortedArray = (self.aryTempOnlineCars as NSArray).sortedArray(using: [NSSortDescriptor(key: "Sort", ascending: true)]) as! [[String:AnyObject]]
        
        self.arrNumberOfOnlineCars = NSMutableArray(array: sortedArray)
        
        if self.checkTempData.count == 0 {
            
            SingletonClass.sharedInstance.isFirstTimeReloadCarList = true
            self.checkTempData = self.aryTempOnlineCars as NSArray
            
            self.collectionViewCars.reloadData()
        }
        else {
            
            for i in 0..<self.aryTempOnlineCars.count {
                
                let arySwif = self.aryTempOnlineCars.object(at: i) as! NSDictionary
                
                if (self.checkTempData.object(at: i) as! NSDictionary) == arySwif {
                    
                    if SingletonClass.sharedInstance.isFirstTimeReloadCarList == true {
                        SingletonClass.sharedInstance.isFirstTimeReloadCarList = false
                        
                        if self.txtCurrentLocation.text!.count != 0 && self.txtDestinationLocation.text!.count != 0 && self.aryOfOnlineCarsIds.count != 0 {
                            self.postPickupAndDropLocationForEstimateFare()
                        }
                        self.collectionViewCars.reloadData()
                    }
                }
                else {
                    self.checkTempData = self.aryTempOnlineCars as NSArray
                    
                    if self.txtCurrentLocation.text!.count != 0 && self.txtDestinationLocation.text!.count != 0 && self.aryOfOnlineCarsIds.count != 0 {
                        self.postPickupAndDropLocationForEstimateFare()
                    }
                    self.collectionViewCars.reloadData()
                }
            }
        }
        //        })
    }
    
    //    func markertIcon(index: Int) -> String {
    //
    //        switch index {
    //        case 0: // "1":
    //            return "imgTaxi"
    //        case 1: // "2":
    //            return "imgTaxi"
    //        case 2: // "3":
    //            return "imgTaxi"
    //        case 3: // "4":
    //            return "imgTaxi"
    //        case 4: // "5":
    //            return "imgTaxi"
    //        case 5: // "6":
    //            return "imgTaxi"
    //        case 6: // "7":
    //            return "imgTaxi"
    //            //        case "8":
    //            //            return "imgTaxi"
    //            //        case "9":
    //            //            return "imgTaxi"
    //            //        case "10":
    //            //            return "imgTaxi"
    //            //        case "11":
    //        //            return "imgTaxi"
    //        default:
    //            return "imgTaxi"
    //        }
    
    func setCarImage(modelId : String) -> String {
        
        var CarModel = String()
        
        switch modelId {
        //        case "1":
        //            CarModel = "imgBusinessClass"
        //            return CarModel
        //        case "2":
        //            CarModel = "imgMIni"
        //            return CarModel
        //        case "3":
        //            CarModel = "imgVan"
        //            return CarModel
        //        case "4":
        //            CarModel = "imgNano"
        //            return CarModel
        //        case "5":
        //            CarModel = "imgTukTuk"
        //            return CarModel
        //        case "6":
        //            CarModel = "imgBreakdown"
        //            return CarModel
        default:
            CarModel = "dummyCar"
            return CarModel
        }
    }
    
    /*/
     switch index {
     case 0: // "1":
     return "iconNano"
     case 1: // "2":
     return "iconPremium"
     case 2: // "3":
     return "iconBreakdownServices"
     case 3: // "4":
     return "iconVan"
     case 4: // "5":
     return "iconTukTuk"
     case 5: // "6":
     return "iconMiniCar"
     case 6: // "7":
     return "iconBusRed"
     //        case "8":
     //            return "Motorbike"
     //        case "9":
     //            return "Car Delivery"
     //        case "10":
     //            return "Van / Trays"
     //        case "11":
     //            return "3T truck"
     default:
     return "imgTaxi"
     }
     */
    
    //        switch index {
    //        case 0:
    //            return "imgFirstClass"
    //        case 1:
    //            return "imgBusinessClass"
    //        case 2:
    //            return "imgEconomy"
    //        case 3:
    //            return "imgTaxi"
    //        case 4:
    //            return "imgLUXVAN"
    //        case 5:
    //            return "imgDisability"
    //        default:
    //            return ""
    //        }
    
    
    func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue)
    {
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "seguePresentTripDetails")
        {
            let drinkViewController = segue.destination as! TripDetailsViewController
            drinkViewController.arrData = arrDataAfterCompletetionOfTrip as NSMutableArray
            drinkViewController.delegate = self
            
        }
        
        if(segue.identifier == "segueDriverInfo")
        {
            //            let deiverInfo = segue.destination as! DriverInfoViewController
        }
        if(segue.identifier == "showRating")
        {
            
            let GiveRatingVC = segue.destination as! GiveRatingViewController
            GiveRatingVC.strBookingType = self.strBookingType
            //            GiveRatingVC.delegate = self
        }
    }
    
    //MARK:- Side Menu Navigation
    @objc func GotoProfilePage() {
        /* Raj Changes
         let NextPage = mainStoryborad.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
         self.navigationController?.pushViewController(NextPage, animated: true) */
        
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "UpdateProfileViewController") as? UpdateProfileViewController
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    @objc func GotoHomePage()
    {
        //        let NextPage = mainStoryborad.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        //        self.navigationController?.pushViewController(NextPage, animated: true)
        self.setLocalization()
        self.setNavBarWithMenu(Title: "Home".localized, IsNeedRightButton: true)
    }
    
    @objc func GotoMyBookingPage() {
        let NextPage = myBookingsStoryboard.instantiateViewController(withIdentifier: "MyBookingViewController") as! MyBookingViewController
        self.navigationController?.pushViewController(NextPage, animated: true)
    }
    
    @objc func GotoPaymentPage() {
        
        if SingletonClass.sharedInstance.CardsVCHaveAryData.count == 0 {
            let next = mainStoryboard.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
            self.navigationController?.pushViewController(next, animated: true)
        }
        else {
            let next = mainStoryboard.instantiateViewController(withIdentifier: "WalletCardsVC") as! WalletCardsVC
            self.navigationController?.pushViewController(next, animated: true)
        }
    }
    
    @objc func GotoWalletPage() {
        if (SingletonClass.sharedInstance.isPasscodeON) {
            
            if SingletonClass.sharedInstance.setPasscode == "" {
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "SetPasscodeViewController") as! SetPasscodeViewController
                viewController.strStatusToNavigate = "Wallet"
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else {
                
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "VerifyPasswordViewController") as! VerifyPasswordViewController
                viewController.strStatusToNavigate = "Wallet"
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        else {
            let next = mainStoryboard.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
            self.navigationController?.pushViewController(next, animated: true)
        }
        
        //        let NextPage = mainStoryborad.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
        //        self.navigationController?.pushViewController(NextPage, animated: true)
    }
    
    @objc func GotoMyReceiptPage() {
        let NextPage = myBookingsStoryboard.instantiateViewController(withIdentifier: "MyReceiptsViewController") as! MyReceiptsViewController
        self.navigationController?.pushViewController(NextPage, animated: true)
    }
    
    @objc func GotoFavouritePage() {
        //        let next = mainStoryboard.instantiateViewController(withIdentifier: "MyRatingViewController") as! MyRatingViewController
        
        //        next.delegateForFavourite = self
        
        //        self.navigationController?.pushViewController(next, animated: true)
        
        let NextPage = mainStoryboard.instantiateViewController(withIdentifier: "FavoriteViewController") as! FavoriteViewController
        NextPage.delegateForFavourite = self
        self.navigationController?.pushViewController(NextPage, animated: true)
    }
    
    @objc func GotoPastDuesPage() {
        let next = mainStoryboard.instantiateViewController(withIdentifier: "PreviousDueViewController") as! PreviousDueViewController
        
        //        next.delegateForFavourite = self
        
        self.navigationController?.pushViewController(next, animated: true)
        
        //        let NextPage = mainStoryborad.instantiateViewController(withIdentifier: "FavoriteViewController") as! FavoriteViewController
        //        self.navigationController?.pushViewController(NextPage, animated: true)
    }
    
    @objc func GotoInviteFriendPage() {
        let NextPage = mainStoryboard.instantiateViewController(withIdentifier: "InviteDriverViewController") as! InviteDriverViewController
        self.navigationController?.pushViewController(NextPage, animated: true)
    }
    
    @objc func GotoSettingPage() {
        let NextPage = mainStoryboard.instantiateViewController(withIdentifier: "SettingPasscodeVC") as! SettingPasscodeVC
        self.navigationController?.pushViewController(NextPage, animated: true)
    }
    
    @objc func GotoSupportPage()
    {
        let next = mainStoryboard.instantiateViewController(withIdentifier: "webViewVC") as! webViewVC
        next.headerName = "\(appName)"
        next.strURL = supportURL
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    //    func BookingConfirmed(dictData : NSDictionary)
    //    {
    
    //        let DriverInfo = ((self.aryRequestAcceptedData.object(at: 0) as! NSDictionary).object(forKey: "DriverInfo") as! NSArray).object(at: 0) as! NSDictionary
    //        let carInfo = ((self.aryRequestAcceptedData.object(at: 0) as! NSDictionary).object(forKey: "CarInfo") as! NSArray).object(at: 0) as! NSDictionary
    //        let bookingInfo = ((self.aryRequestAcceptedData.object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
    
    //        showDriverInfo(bookingInfo: bookingInfo, DriverInfo: DriverInfo, carInfo: carInfo)
    
    //    }
    
    //MARK: - socket? Methods
    func socketMethods()
    {
        var isSocketConnected = Bool()
        
        socket?.on(clientEvent: .disconnect) { (data, ack) in
            print ("socket? is disconnected please reconnect")
        }
        
        socket?.on(clientEvent: .reconnect) { (data, ack) in
            print ("socket? is reconnected")
//            self.webserviceOfCurrentBooking()
        }
        
        socket?.on(clientEvent: .connect) { data, ack in
            
            print("socket? BaseURl : \(SocketData.kBaseURL)")
            print("socket? connected")
            
            self.methodsAfterConnectingToSocket()
            
            if self.socket?.status != .connected {
                
                print("socket?.status != .connected")
            }
            
            if (isSocketConnected == false) {
                isSocketConnected = true
                
                self.socketMethodForGettingBookingAcceptNotification()  // Accept Now Req
                self.socketMethodForGettingBookingRejectNotification()  // Reject Now Req
                self.socketMethodForGettingPickUpNotification()         // Start Now Req
                self.socketMethodForGettingTripCompletedNotification()  // CompleteTrip Now Req
                self.onTripHoldingNotificationForPassengerLater()       // Hold Trip Later
                self.onReceiveDriverLocationToPassenger()               // Driver Location Receive
                self.socketMethodForGettingBookingRejectNotificatioByDriver()   // Reject By Driver
                self.onAcceptBookLaterBookingRequestNotification()              // Accept Later Req
                self.onRejectBookLaterBookingRequestNotification()              // Reject Later Req
                self.onPickupPassengerByDriverInBookLaterRequestNotification()
                self.onTripHoldingNotificationForPassenger()                    // Hold Trip Now
                self.onBookingDetailsAfterCompletedTrip()                       // Booking Details After Complete Trip
                self.socketMethodForGiveTipToDriver()
                self.socketMethodForGiveTipToDriverBookLater()
                self.onAdvanceTripInfoBeforeStartTrip()                         // Start Later Req
                self.onReceiveNotificationWhenDriverAcceptRequest()
                self.socketMethodForDropOffs()
                self.onGetEstimateFare()
                self.onDriverArrived()
                self.onSOS()
            }
            
            // Get Estimate
            self.socket?.on(SocketData.kNearByDriverList, callback: { (data, ack) in
//                print("NearByDriverListIOS is \(data)")
                
//                var lat : Double!
//                var long : Double!
                self.aryOfOnlineCarsIds.removeAll()
                self.arrNumberOfAvailableCars = NSMutableArray(array: ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "driver") as! NSArray)
                self.setData()
                
                if (((data as NSArray).object(at: 0) as! NSDictionary).count != 0)
                {
                    for i in 0..<(((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "driver") as! NSArray).count
                    {
//                        let arrayOfCoordinte = ((((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "driver") as! NSArray).object(at: i) as! NSDictionary).object(forKey: "Location") as! NSArray
//                        lat = arrayOfCoordinte.object(at: 0) as? Double
//                        long = arrayOfCoordinte.object(at: 1) as? Double
                        
                        let DriverId = ((((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "driver") as! NSArray).object(at: i) as! NSDictionary).object(forKey: "DriverId") as! String
                        
                        self.aryOfTempOnlineCarsIds.append(DriverId)
                        self.aryOfOnlineCarsIds = self.uniq(source: self.aryOfTempOnlineCarsIds)
                    }
                }
                self.postPickupAndDropLocationForEstimateFare()
            })
        }
        socket?.connect()
    }
    
    var timesOfAccept = Int()
    @objc func bookingAcceptNotificationMethodCallInTimer() {
        timesOfAccept += 1
        print("ACCCEPT by Timer: \(timesOfAccept)")
        self.socketMethodForGettingBookingAcceptNotification()
    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        self.updateCounting()
        timerToUpdatePassengerlocation = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    func stopTimerforUpdatePassengerLatlong(){
        if timerToUpdatePassengerlocation != nil {
            timerToUpdatePassengerlocation.invalidate()
            timerToUpdatePassengerlocation = nil
        }
    }
    @objc func updateCounting(){
        if doublePickupLat != 0 && doublePickupLng != 0 {
            let myJSON = ["PassengerId" : SingletonClass.sharedInstance.strPassengerID, "Lat": doublePickupLat, "Long": doublePickupLng, "Token" : SingletonClass.sharedInstance.deviceToken, "ShareRide": SingletonClass.sharedInstance.isShareRide] as [String : Any]
            socket?.emit(SocketData.kUpdatePassengerLatLong , with: [myJSON], completion: nil)
//            print(SocketData.kUpdatePassengerLatLong, myJSON)
        }
        else
        {
            let myJSON = ["PassengerId" : SingletonClass.sharedInstance.strPassengerID, "Lat": defaultLocation.coordinate.latitude, "Long": defaultLocation.coordinate.longitude, "Token" : SingletonClass.sharedInstance.deviceToken, "ShareRide": SingletonClass.sharedInstance.isShareRide] as [String : Any]
            socket?.emit(SocketData.kUpdatePassengerLatLong , with: [myJSON], completion: nil)
//            print(SocketData.kUpdatePassengerLatLong, myJSON)
        }
        
    }
    
    func methodsAfterConnectingToSocket()
    {
        scheduledTimerWithTimeInterval()
    }
    func socketMethodForGiveTipToDriverBookLater()
    {
        self.socket?.on(SocketData.kAskForTipsToPassengerForBookLater, callback: { (data, ack) in
            print("kAskForTipsToPassenger for BookLater: \(data)")
            
            self.showTimerProgressViaInstance()
            let msg = (data as NSArray)
            let alertForTip = UIAlertController(title: "Tip Alert".localized,
                                                message: (msg.object(at: 0) as! NSDictionary).object(forKey: "message") as? String,
                                                preferredStyle: UIAlertControllerStyle.alert)
            
            //2. Add the text field. You can configure it however you need.
            alertForTip.addTextField { (textField) in
                textField.placeholder = "Add Tip".localized
                textField.keyboardType = .decimalPad
                //                Utilities.setLeftPaddingInTextfield(textfield: textField, padding: 10)
            }
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alertForTip.addAction(UIAlertAction(title: "YES".localized, style: .default, handler: { ACTION in
                let textField = alertForTip.textFields![0] // Force unwrapping because we know it exists.
                self.strTipAmount = (textField.text)!
                print("Text field: \(String(describing: textField.text))")
                
                //                if !UtilityClass.isEmpty(str: (textField.text)!)
                //                {
                let myJSON = ["PassengerId" : SingletonClass.sharedInstance.strPassengerID, "Amount": self.strTipAmount, "BookingId": SingletonClass.sharedInstance.bookingId] as [String : Any]
                self.socket?.emit(SocketData.kReceiveTipsForBookLater , with: [myJSON], completion: nil)
                //                }
                //                else
                //                {
                //                    let alret = UIAlertController(title: appName,
                //                                                         message: "Please enter amount",
                //                                                         preferredStyle: UIAlertControllerStyle.alert)
                //                    alret.addAction(UIAlertAction(title: "OK", style: .default, handler: { [] (_) in
                //
                //
                //                    }))
                //                    UtilityClass.presentPopupOverScreen(alret)
                //                }
            }))
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alertForTip.addAction(UIAlertAction(title: "NO".localized, style: .destructive, handler: { [] (_) in
                
                let myJSON = ["PassengerId" : SingletonClass.sharedInstance.strPassengerID, "Amount": "", "BookingId": SingletonClass.sharedInstance.bookingId] as [String : Any]
                self.socket?.emit(SocketData.kReceiveTipsForBookLater , with: [myJSON], completion: nil)
                self.strTipAmount = ""
            }))
            
            // 4. Present the alert.
            self.present(alertForTip, animated: true, completion: nil)
        })
    }
    func showTimerProgressViaInstance()
    {
        if timerOfRequest == nil {
            timerOfRequest = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.showTimer), userInfo: nil, repeats: true)
        }
    }
    
    @objc func showTimer()
    {
        progressCompleted += 1
        if progressCompleted >= 25
        {
            self.boolTimeEnd = true
            self.timerDidEnd()
            timerOfRequest.invalidate()
        }
    }
    func timerDidEnd()
    {
        if (boolTimeEnd)
        {
            timerOfRequest.invalidate()
            //            alertForTip.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        } else {
            timerOfRequest.invalidate()
            //            alertForTip.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    func socketMethodForGiveTipToDriver()
    {
        self.socket?.on(SocketData.kAskForTipsToPassenger, callback: { (data, ack) in
            print("kAskForTipsToPassenger: \(data)")
            
            //            kAskForTipsToPassenger: [{
            //            message = "Tesluxe driver Ask For Tips. Do you want to give tips?";
            //            }]
            
            self.showTimerProgressViaInstance()
            
            let msg = (data as NSArray)
            
            
            let alertForTip = UIAlertController(title: "Tip Alert".localized,
                                                message: (msg.object(at: 0) as! NSDictionary).object(forKey: "message") as? String,
                                                preferredStyle: UIAlertControllerStyle.alert)
            
            //2. Add the text field. You can configure it however you need.
            alertForTip.addTextField { (textField) in
                textField.placeholder = "Add Tip".localized
                textField.keyboardType = .decimalPad
                //                Utilities.setLeftPaddingInTextfield(textfield: textField, padding: 10)
                
            }
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alertForTip.addAction(UIAlertAction(title: "YES".localized, style: .default, handler: { ACTION in
                let textField = alertForTip.textFields![0] // Force unwrapping because we know it exists.
                self.strTipAmount = (textField.text)!
                print("Text field: \(String(describing: textField.text))")
                
                //                if !UtilityClass.isEmpty(str: (textField.text)!)
                //                {
                //
                let myJSON = ["Running": 0,"PassengerId" : SingletonClass.sharedInstance.strPassengerID, "Amount": self.strTipAmount, "BookingId": SingletonClass.sharedInstance.bookingId] as [String : Any]
                self.socket?.emit(SocketData.kReceiveTips , with: [myJSON], completion: nil)
                    
                print("kReceiveTips yes tip is given: \(myJSON)")
                //
                //                }
                //                else
                //                {
                //                    let alret = UIAlertController(title: appName,
                //                                                  message: "Please enter amount",
                //                                                  preferredStyle: UIAlertControllerStyle.alert)
                //                    alret.addAction(UIAlertAction(title: "OK", style: .default, handler: { [] (_) in
                //
                //
                //                    }))
                //                    self.present(alret, animated: true, completion: nil)
                ////                    UtilityClass.presentPopupOverScreen(alret)
                //                }
            }))
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alertForTip.addAction(UIAlertAction(title: "NO".localized, style: .destructive, handler: { [] (_) in
                
                let myJSON = ["Running": 0,"PassengerId" : SingletonClass.sharedInstance.strPassengerID, "Amount": "", "BookingId": SingletonClass.sharedInstance.bookingId] as [String : Any]
                self.socket?.emit(SocketData.kReceiveTips , with: [myJSON], completion: nil)
                print("kReceiveTips no tip not given: \(myJSON)")
                self.strTipAmount = ""
            }))
            
            // 4. Present the alert.
            //            self.present(self.alertForTip, animated: true, completion: nil)
            
            //            Utilities.presentPopupOverScreen(self.alertForTip)
            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
            alertWindow.rootViewController = UIViewController()
            alertWindow.windowLevel = UIWindowLevelAlert + 1;
            alertWindow.makeKeyAndVisible()
            alertWindow.rootViewController?.present(alertForTip, animated: true, completion: nil)
        })
    }
    
    func socketMethodForGettingBookingAcceptNotification()
    {
        // socket? Accepted
        self.socket?.on(SocketData.kAcceptBookingRequestNotification, callback: { (data, ack) in
            print("AcceptBooking data is \(data)")
            self.viewActivity.stopAnimating()
            
            self.locationManager.startUpdatingLocation()
            self.timerToUpdatePassengerlocation?.invalidate()
            self.timerToUpdatePassengerlocation = nil
            if let getInfoFromData = data as? [[String:AnyObject]] {
                
                if let infoData = getInfoFromData[0] as? [String:AnyObject] {
                    if let bookingInfo = infoData["BookingInfo"] as? [[String:AnyObject]] {
                        var bookingIdIs = String()
                        if let nowBookingID: Int = (bookingInfo[0])["Id"] as? Int {
                            bookingIdIs = "\(nowBookingID)"
                        }
                        else if let nowBookingID: String = (bookingInfo[0])["Id"] as? String {
                            bookingIdIs = nowBookingID
                        }
                        print("bookingIdIs: \(bookingIdIs)")
                        if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                            if SelectedLanguage == "en" {
                                
                                UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
                                })
                            }
                            else if SelectedLanguage == "sw"
                            {
                                UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["swahili_message"]! as! String, completionHandler: { (index, title) in
                                })
                            }
                        }
                        if SingletonClass.sharedInstance.bookingId != "" {
                            if SingletonClass.sharedInstance.bookingId == bookingIdIs {
                                self.DriverInfoAndSetToMap(driverData: NSArray(array: data))
                            }
                        }
                        else {
                            self.DriverInfoAndSetToMap(driverData: NSArray(array: data))
                        }
                    }
                }
            }
        })
    }
    
    
    func socketMethodForDropOffs()
    {
        self.socket?.on(SocketData.kBookingDetailsDropoffs) { data, ack in
            print("data \(data)")
            if data.count != 0 {
                if let BookingInfo = (data as? [[String:Any]])?.first?["BookingInfo"] as? [[String:Any]] {
                    let aryFilterData = BookingInfo.filter{$0["Status"] as! String == "pending" }
                    self.BookingDetailsDropoffsToSetOnMap(tempAryFilterData: aryFilterData)
                }
            }
        }
    }
    
    func BookingDetailsDropoffsToSetOnMap(tempAryFilterData: [[String:Any]], isFromStartTrip: Bool = false) {
        
        if tempAryFilterData.count != 0 {
            
            self.clearMap()
            
            let DropOffLat = Double("\(tempAryFilterData.first?["DropOffLat"]! ?? "0")")
            let DropOffLon = Double("\(tempAryFilterData.first?["DropOffLon"]! ?? "0")")
            
            var PickupLat:Double = self.defaultLocation.coordinate.latitude
            var PickupLng:Double = self.defaultLocation.coordinate.longitude
            
            if let lat = SingletonClass.sharedInstance.driverLocation["Location"] as? [Double] {
                PickupLat = lat[0]
                PickupLng = lat[1]
            }
            
            let tempLat = Double("\(tempAryFilterData.first?["PickupLat"]! ?? "0")")
            let tempLng = Double("\(tempAryFilterData.first?["PickupLng"]! ?? "0")")
            
            let originalLoc: String = "\(PickupLat == 0 ? (tempLat ?? 0) : PickupLat),\(PickupLng == 0 ? (tempLng ?? 0) : PickupLng)"
            let destiantionLoc: String = "\(DropOffLat ?? 0),\(DropOffLon ?? 0)"
            
            let bounds = GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: PickupLat, longitude: PickupLng) , coordinate: CLLocationCoordinate2D(latitude: DropOffLat ?? 0, longitude: DropOffLon ?? 0))
            
            let update = GMSCameraUpdate.fit(bounds, withPadding: CGFloat(150))
            
            self.mapView.animate(with: update)
            self.mapView.moveCamera(update)
            self.setDirectionLineOnMapForSourceAndDestinationShow(origin: originalLoc, destination: destiantionLoc, waypoints: nil, travelMode: nil, completionHandler: nil)
        }
    }
    func DriverInfoAndSetToMap(driverData: NSArray) {
        
        self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: true)
        
        
        self.MarkerCurrntLocation.isHidden = true
        
        self.viewTripActions.isHidden = false
        self.constraintVerticalSpacingLocation?.priority = UILayoutPriority(600)

        self.ConstantViewCarListsHeight.constant = 0
        self.viewCarLists.isHidden = true
    
        
        self.viewActivity.stopAnimating()
        self.viewMainActivityIndicator.isHidden = true
        self.btnRequest.isHidden = false
        self.btnCancelStartedTrip.isHidden = true
        
        self.aryRequestAcceptedData = NSMutableArray(array: driverData).mutableCopy() as? NSMutableArray ?? []
        
        let bookingInfo : NSDictionary!
        let DriverInfo: NSDictionary!
        let carInfo: NSDictionary!
        
        if((((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "DriverInfo") as? NSDictionary) == nil)
        {
            // print ("Yes its  array ")
            DriverInfo = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "DriverInfo") as! NSArray).object(at: 0) as? NSDictionary
        }
        else {
            // print ("Yes its dictionary")
            DriverInfo = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "DriverInfo") as! NSDictionary)
        }
        
        if((((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as? NSDictionary) == nil)
        {
            // print ("Yes its  array ")
            bookingInfo = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as? NSDictionary
        }
        else {
            // print ("Yes its dictionary")
            bookingInfo = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSDictionary) //.object(at: 0) as! NSDictionary
        }
        
        if((((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "CarInfo") as? NSDictionary) == nil)
        {
            // print ("Yes its  array ")
            carInfo = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as? NSDictionary)?.object(forKey: "CarInfo") as? NSArray)?.object(at: 0) as? NSDictionary
        }
        else {
            // print ("Yes its dictionary")
            carInfo = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "CarInfo") as! NSDictionary) //.object(at: 0) as! NSDictionary
        }
        
        self.TempBookingInfoDict = bookingInfo as? [String:Any] ?? [:]
        if let passengerType = bookingInfo.object(forKey: "PassengerType") as? String {
            
            if passengerType == "other" || passengerType == "others" {
                
                SingletonClass.sharedInstance.passengerTypeOther = true
            }
        }
        
        txtCurrentLocation.isUserInteractionEnabled = false
        txtCurrentLocation.text = bookingInfo["PickupLocation"] as? String ?? ""
        txtDestinationLocation.text = bookingInfo["DropoffLocation"] as? String ?? ""
        viewCurrentLocation.isHidden = false
        viewDestinationLocation.isHidden = false
        btnDoneForLocationSelected.isHidden = true
        let dropLocation2 = bookingInfo["DropoffLocation2"] as? String ?? ""
        viewAdditionalDestinationLocation.isHidden = true
        _ = btnClose.compactMap{
            $0.isHidden = true
            if($0.tag != 0)
            {
                $0.setImage(UIImage(named: "iconEditProfile"), for: .normal)
                $0.tintColor = .red
                $0.isHidden = false
            }
        }
        viewBookNowLater.isHidden = true
        
        if(dropLocation2.trimmingCharacters(in: .whitespacesAndNewlines) != "")
        {
            viewAdditionalDestinationLocation.isHidden = false
            txtAdditionalDestinationLocation.text = dropLocation2
        }
        
        SingletonClass.sharedInstance.dictDriverProfile = DriverInfo
        SingletonClass.sharedInstance.dictCarInfo = (carInfo as? [String: AnyObject])!
        //        showDriverInfo(bookingInfo: bookingInfo, DriverInfo: DriverInfo, carInfo: carInfo)
        
        self.sendPassengerIDAndDriverIDToGetLocation(driverID: String(describing: DriverInfo.object(forKey: "Id")!) , passengerID: String(describing: bookingInfo.object(forKey: "PassengerId")!))
        
        //        self.BookingConfirmed(dictData: (driverData[0] as! NSDictionary) )
        
        //        let driverInfo = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
        //        let details = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "Details") as! NSArray).object(at: 0) as! NSDictionary
        
        if let bookID =  bookingInfo.object(forKey: SocketDataKeys.kBookingIdNow) as? String {
            SingletonClass.sharedInstance.bookingId = bookID
        }
        else if let bookID = bookingInfo.object(forKey: "Id") as? String {
            SingletonClass.sharedInstance.bookingId = bookID
        }
        else if let bookID = bookingInfo.object(forKey: "Id") as? Int {
            SingletonClass.sharedInstance.bookingId = "\(bookID)"
        }
        
        //        txtCurrentLocation.text = bookingInfo.object(forKey: "PickupLocation") as? String
        //        txtDestinationLocation.text = bookingInfo.object(forKey: "DropoffLocation") as? String
        
        //        let PickupLat = defaultLocation.coordinate.latitude
        //        let PickupLng =  defaultLocation.coordinate.longitude
        
        let PickupLat = bookingInfo.object(forKey: "PickupLat") as! String
        let PickupLng =  bookingInfo.object(forKey: "PickupLng") as! String
        
        //        let DropOffLat = driverInfo.object(forKey: "PickupLat") as! String
        //        let DropOffLon = driverInfo.object(forKey: "PickupLng") as! String
        
        let DropOffLat = DriverInfo.object(forKey: "Lat") as! String
        let DropOffLon = DriverInfo.object(forKey: "Lng") as! String
        
        
        let dummyLatitude = Double(PickupLat)! - Double(DropOffLat)!
        let dummyLongitude = Double(PickupLng)! - Double(DropOffLon)!
        
        let waypointLatitude = Double(PickupLat)! - dummyLatitude
        let waypointSetLongitude = Double(PickupLng)! - dummyLongitude
        
        let originalLoc: String = "\(PickupLat),\(PickupLng)"
        let destiantionLoc: String = "\(DropOffLat),\(DropOffLon)"
        
        strPickUpLatitude = PickupLat
        strPickUpLongitude = DropOffLon
        
        let camera = GMSCameraPosition.camera(withLatitude: Double(DropOffLat)!,
                                              longitude: Double(DropOffLon)!,
                                              zoom: 17)
        mapView.camera = camera
        
        self.getDirectionsAcceptRequest(origin: originalLoc, destination: destiantionLoc, waypoints: ["\(waypointLatitude),\(waypointSetLongitude)"], travelMode: nil) { (index, title) in
        }
        //        updatePolyLineToMapFromDriverLocation()
        //        NotificationCenter.default.post(name: NotificationForAddNewBooingOnSideMenu, object: nil)
        
    }
    
    
    var TempBookingInfoDict = [String:Any]()
    
    func methodAfterStartTrip(tripData: NSArray) {
        self.stopTimerforUpdatePassengerLatlong()
        self.MarkerCurrntLocation.isHidden = true
        
        SingletonClass.sharedInstance.isTripContinue = true
        
        destinationCordinate = CLLocationCoordinate2D(latitude: dropoffLat, longitude: dropoffLng)
        
        self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: true)
        self.TempBookingInfoDict = tripData[0] as? [String:Any] ?? [:]
        self.viewTripActions.isHidden = false
        self.constraintVerticalSpacingLocation?.priority = UILayoutPriority(600)

        self.ConstantViewCarListsHeight.constant = 0
        self.viewCarLists.isHidden = true
        // self.viewFromToSubmitButton.isHidden = true
        //        self.viewShareRideView.isHidden = true
        
        self.viewActivity.stopAnimating()
        self.viewMainActivityIndicator.isHidden = true
        self.btnRequest.isHidden = true
        self.btnCancelStartedTrip.isHidden = true
        
        let bookingInfo : NSDictionary!
        let DriverInfo: NSDictionary!
        let carInfo: NSDictionary!
        
        if((((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "DriverInfo") as? NSDictionary) == nil)
        {
            // print ("Yes its  array ")
            DriverInfo = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "DriverInfo") as! NSArray).object(at: 0) as? NSDictionary
        }
        else {
            // print ("Yes its dictionary")
            DriverInfo = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "DriverInfo") as! NSDictionary)
        }
        
        if((((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as? NSDictionary) == nil)
        {
            // print ("Yes its  array ")
            bookingInfo = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as? NSDictionary
        }
        else
        {
            // print ("Yes its dictionary")
            bookingInfo = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSDictionary) //.object(at: 0) as! NSDictionary
        }
        
        if((((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "CarInfo") as? NSDictionary) == nil)
        {
            // print ("Yes its  array ")
            carInfo = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "CarInfo") as! NSArray).object(at: 0) as? NSDictionary
        }
        else
        {
            // print ("Yes its dictionary")
            carInfo = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "CarInfo") as! NSDictionary) //.object(at: 0) as! NSDictionary
        }
        
        SingletonClass.sharedInstance.dictDriverProfile = DriverInfo
        SingletonClass.sharedInstance.dictCarInfo = carInfo as! [String: AnyObject]
        //        showDriverInfo(bookingInfo: bookingInfo, DriverInfo: DriverInfo, carInfo: carInfo)
        txtCurrentLocation.isUserInteractionEnabled = false
        txtCurrentLocation.text = bookingInfo["PickupLocation"] as? String ?? ""
        txtDestinationLocation.text = bookingInfo["DropoffLocation"] as? String ?? ""
        viewCurrentLocation.isHidden = false
        viewDestinationLocation.isHidden = false
        btnDoneForLocationSelected.isHidden = true
        let dropLocation2 = bookingInfo["DropoffLocation2"] as? String ?? ""
        viewAdditionalDestinationLocation.isHidden = true
        _ = btnClose.compactMap{
            $0.isHidden = true
            if($0.tag != 0)
            {
                $0.setImage(UIImage(named: "iconEditProfile"), for: .normal)
                $0.tintColor = .red
                $0.isHidden = false
            }
        }
        viewBookNowLater.isHidden = true
        
        if(dropLocation2.trimmingCharacters(in: .whitespacesAndNewlines) != "")
        {
            viewAdditionalDestinationLocation.isHidden = false
            txtAdditionalDestinationLocation.text = dropLocation2
        }
        
        // ------------------------------------------------------------
        let DropOffLat = bookingInfo.object(forKey: "DropOffLat") as! String
        let DropOffLon = bookingInfo.object(forKey: "DropOffLon") as! String
        
        let picklat = bookingInfo.object(forKey: "PickupLat") as! String
        let picklng = bookingInfo.object(forKey: "PickupLng") as! String
        
        dropoffLat = Double(DropOffLat) ?? 0
        dropoffLng = Double(DropOffLon) ?? 0
        
        self.txtDestinationLocation.text = bookingInfo.object(forKey: "DropoffLocation") as? String
        self.txtCurrentLocation.text = bookingInfo.object(forKey: "PickupLocation") as? String
        
        let PickupLat = self.defaultLocation.coordinate.latitude
        let PickupLng = self.defaultLocation.coordinate.longitude
        
        //        let PickupLat = Double(picklat)
        //        let PickupLng = Double(picklng)
        
        let dummyLatitude = Double(PickupLat) - (Double(DropOffLat) ?? Double(0))
        let dummyLongitude = Double(PickupLng) - (Double(DropOffLon) ?? Double(0))
        
        let waypointLatitude = self.defaultLocation.coordinate.latitude - dummyLatitude
        let waypointSetLongitude = self.defaultLocation.coordinate.longitude - dummyLongitude
        
        let originalLoc: String = "\(PickupLat),\(PickupLng)"
        let destiantionLoc: String = "\(DropOffLat),\(DropOffLon)"
        
        let bounds = GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: Double(picklat)!, longitude: Double(picklng)!), coordinate: CLLocationCoordinate2D(latitude: Double(DropOffLat)!, longitude: Double(DropOffLon)!))
        
        let update = GMSCameraUpdate.fit(bounds, withPadding: CGFloat(100))
        
        self.mapView.animate(with: update)
        
        self.mapView.moveCamera(update)
        
        self.getDirectionsSeconMethod(origin: originalLoc, destination: destiantionLoc, waypoints: ["\(waypointLatitude),\(waypointSetLongitude)"], travelMode: nil, completionHandler: nil)
        
        NotificationCenter.default.post(name: NotificationForAddNewBooingOnSideMenu, object: nil)
        
    }
    
    //MARK:- Show Driver Information
    
    func showDriverInfo(bookingInfo : NSDictionary, DriverInfo: NSDictionary, carInfo : NSDictionary) {
        let next = mainStoryboard.instantiateViewController(withIdentifier: "DriverInfoViewController") as! DriverInfoViewController
        
        next.strDriverName = DriverInfo.object(forKey: "Fullname") as! String
        if let strDriverID = DriverInfo.object(forKey: "Id") as? String
        {
            next.strDriverID = strDriverID
        }
        else  if let intDriverID = DriverInfo.object(forKey: "Id") as? Int
        {
            next.strDriverID = "\(intDriverID)"
        }
        next.strPickupLocation = "\(bookingInfo.object(forKey: "PickupLocation") as! String)"
        next.strDropoffLocation = "\(bookingInfo.object(forKey: "DropoffLocation") as! String)"
        if let carClass = carInfo.object(forKey: "Model") as? NSDictionary {
            next.strCarClass = carClass.object(forKey: "Name") as! String // String(describing: carInfo.object(forKey: "VehicleModel")!)
        }
        else {
            next.strCarClass = String(describing: carInfo.object(forKey: "VehicleModel")!)
        }
        
        if let strDropLocation2 = bookingInfo.object(forKey: "DropoffLocation2") as? String {
            next.strDropoffLocation2 = strDropLocation2
        }
        
        
        if let carPlateNumber = carInfo.object(forKey: "VehicleRegistrationNo") as? String {
            next.strCarPlateNumber = carPlateNumber
        }
        
        if let Color = carInfo.object(forKey: "Color") as? String {
            next.strVehicleColor = Color
        }
        if let Company = carInfo.object(forKey: "Company") as? String {
            next.strVehicleMake = Company
        }
        
        if let VehicleModelName = carInfo.object(forKey: "VehicleModelName") as? String {
            next.strVehicleType = VehicleModelName
        }
        
        if let VehicleRegistrationNo = carInfo.object(forKey: "VehicleRegistrationNo") as? String {
            next.strCarPlateNumber = VehicleRegistrationNo
        }
        
        next.strCareName = "\(carInfo.object(forKey: "Company") as! String) - \(next.strCarClass) - \(next.strCarPlateNumber)"
        next.strDriverImage = WebserviceURLs.kImageBaseURL + (DriverInfo.object(forKey: "Image") as? String ?? "")
        next.strCarImage = WebserviceURLs.kImageBaseURL + (carInfo.object(forKey: "VehicleImage") as? String ?? "")
        
        //        if (SingletonClass.sharedInstance.passengerTypeOther) {
        //            next.strPassengerMobileNumber = bookingInfo.object(forKey: "PassengerContact") as! String
        //        }
        //        else {
        next.strPassengerMobileNumber = DriverInfo.object(forKey: "MobileNo") as! String
        
        print("The status is \(TempBookingInfoDict["Status"] ?? "")")
        if((TempBookingInfoDict["Status"] as? String)?.lowercased() == "pending" || ((TempBookingInfoDict["Status"] as? String)?.lowercased() == "accepted"))
        {
            next.shouldShow = true
        }
        //        }
//        let PickupLat:Double = self.defaultLocation.coordinate.latitude
//        let PickupLng:Double = self.defaultLocation.coordinate.longitude

//        let strDriverLat = "\(PickupLat)"
//        let strDriverLng = "\(PickupLng)"
        let strBookingID = "\(bookingInfo.object(forKey: "Id") as? Int ?? 0)"
        
        let strBookingType = (self.strBookingType == "BookNow") ? "Booking" : "AdvanceBooking"
        next.strPickUpLat = bookingInfo.object(forKey: "PickupLat") as? String ?? ""
        next.strPickUpLng = bookingInfo.object(forKey: "PickupLng") as? String ?? ""
//        next.strCurrentLat = strDriverLat
//        next.strCurrentLng = strDriverLng
        next.strBookingID = String(strBookingID)
        next.strBookingType = strBookingType
        next.homeVC = self
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(next, animated: true, completion: nil)
    }
    
    
    
    func socketMethodForGettingBookingRejectNotification()
    {
        // socket? Accepted
        self.socket?.on(SocketData.kRejectBookingRequestNotification, callback: { (data, ack) in
            print("socketMethodForGettingBookingRejectNotification() is \(data)")
            
            var bookingId = String()
            
            let bookingInfoData = (data as! [[String:AnyObject]])[0] //as? [String:AnyObject]  {
            if let bookingInfo = bookingInfoData["BookingId"] as? Int {
                bookingId = "\(bookingInfo)"
            }
            else if let bookingInfo = bookingInfoData["BookingId"] as? String {
                bookingId = bookingInfo
            }
            
            if SingletonClass.sharedInstance.bookingId != "" {
                if SingletonClass.sharedInstance.bookingId == bookingId {
                    self.viewActivity.stopAnimating()
                    self.TempBookingInfoDict.removeAll()
                    self.viewMainActivityIndicator.isHidden = true
                    
                    if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                        if SelectedLanguage == "en" {
                            
                            UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
                            })
                        }
                        else if SelectedLanguage == "sw"
                        {
                            UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["swahili_message"]! as! String, completionHandler: { (index, title) in
                            })
                        }
                    }
                }
            }
            else {
                self.viewActivity.stopAnimating()
                self.viewMainActivityIndicator.isHidden = true
                //                    UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
                //
                //                    })
                if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                    if SelectedLanguage == "en" {
                        
                        UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
                        })
                    }
                    else if SelectedLanguage == "sw"
                    {
                        UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["swahili_message"]! as! String, completionHandler: { (index, title) in
                        })
                    }
                }
            }
            //            }
            
            //            self.viewActivity.stopAnimating()
            //            self.viewMainActivityIndicator.isHidden = true
            //            UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
            //
            //            })
            
            /*
             [{
             BookingId = 7623;
             message = "Your Booking request has been canceled";
             type = BookingRequest;
             }]
             */
        })
    }
    
    func socketMethodForGettingBookingRejectNotificatioByDriver()
    {
        // socket? Accepted
        self.socket?.on(SocketData.kCancelTripByDriverNotficication, callback: { (data, ack) in
            print("socketMethodForGettingBookingRejectNotificatioByDriver() is \(data)")
            
            //            var bookingId = String()
            
            //            if let bookingInfoData = (data as! [[String:AnyObject]])[0]["BookingInfo"] as? [[String:AnyObject]] {
            //                if let bookingInfo = bookingInfoData[0]["Id"] as? Int {
            //                    bookingId = "\(bookingInfo)"
            //                }
            //                else if let bookingInfo = bookingInfoData[0]["Id"] as? String {
            //                    bookingId = bookingInfo
            //                }
            
            if SingletonClass.sharedInstance.bookingId != "" {
                //                    if SingletonClass.sharedInstance.bookingId == bookingId {
                self.viewActivity.stopAnimating()
                self.viewMainActivityIndicator.isHidden = true
                self.currentLocationAction()
                self.getPlaceFromLatLong()
                self.clearDataAfteCompleteTrip()
                self.currentLocationAction()
                self.viewAdditionalDestinationLocation.isHidden = false
                _ = self.btnClose.compactMap{$0.isHidden = false}
                self.TempBookingInfoDict.removeAll()
                self.mapView.clear()
                self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
                
                self.viewTripActions.isHidden = true
                self.constraintVerticalSpacingLocation?.priority = UILayoutPriority(800)

                SingletonClass.sharedInstance.passengerTypeOther = false
                self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
                SingletonClass.sharedInstance.bookingId = ""
                //                        UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
                //
                //                        })
                if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                    if SelectedLanguage == "en" {
                        
                        UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
                        })
                    }
                    else if SelectedLanguage == "sw"
                    {
                        UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["swahili_message"]! as! String, completionHandler: { (index, title) in
                        })
                    }
                    //                        }
                }
            } else {
                self.viewActivity.stopAnimating()
                self.viewMainActivityIndicator.isHidden = true
                self.currentLocationAction()
                self.getPlaceFromLatLong()
                self.clearDataAfteCompleteTrip()
                self.currentLocationAction()
                self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
                
                self.viewTripActions.isHidden = true
                self.constraintVerticalSpacingLocation?.priority = UILayoutPriority(800)

                SingletonClass.sharedInstance.passengerTypeOther = false
                self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
                //                    UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
                //
                //                    })
                
                if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                    if SelectedLanguage == "en" {
                        
                        UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
                        })
                    }
                    else if SelectedLanguage == "sw"
                    {
                        UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["swahili_message"]! as! String, completionHandler: { (index, title) in
                        })
                    }
                }
            }
            //            }
        })
    }
    
    func socketMethodForGettingPickUpNotification()
    {
        self.socket?.on(SocketData.kPickupPassengerNotification, callback: { (data, ack) in
            print("socketMethodForGettingPickUpNotification() is \(data)")
            //            self.stopTimer()
            /*
             [{
             BookingId = 7625;
             DriverId = 70;
             message = "Your trip has now started.";
             }]
             */
            
            //            let alert = UIAlertController(title: appName, message: "Your trip has now started.", preferredStyle: .alert)
            //            let OK = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
            //            })
            //            alert.addAction(OK)
            //            //            self.present(alert, animated: true, completion: nil)
            //
            //            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
            //            alertWindow.rootViewController = UIViewController()
            //            alertWindow.windowLevel = UIWindowLevelAlert + 1;
            //            alertWindow.makeKeyAndVisible()
            //            alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
            
            
            if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                if SelectedLanguage == "en" {
                    
                    UtilityClass.setCustomAlert(title: "\(appName)", message: (data as? [[String:AnyObject]])?[0]["message"]! as? String ?? "----", completionHandler: { (index, title) in
                    })
                }
                else if SelectedLanguage == "sw"
                {
                    UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["swahili_message"] as? String ?? "----", completionHandler: { (index, title) in
                    })
                }
            }
            
            self.btnRequest.isHidden = true
            self.btnCancelStartedTrip.isHidden = true
            
            self.methodAfterStartTrip(tripData: NSArray(array: data))
            
            //            var bookingIdIs = String()
            //
            //            if let bookingData = data as? [[String:AnyObject]] {
            //                if let id = bookingData[0]["BookingId"] as? String {
            //                    bookingIdIs = id
            //                }
            //                else if let id = bookingData[0]["BookingId"] as? Int {
            //                    bookingIdIs = "\(id)"
            //                }
            //
            //                if SingletonClass.sharedInstance.bookingId != "" {
            //                    if SingletonClass.sharedInstance.bookingId == bookingIdIs {
            //                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            //                        UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
            //
            //                        })
            //
            //                        self.btnRequest.isHidden = true
            //                        self.btnCancelStartedTrip.isHidden = true
            //
            //                        self.methodAfterStartTrip(tripData: NSArray(array: data))
            //                    }
            //                }
            //                else {
            //                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            //                    UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
            //
            //                    })
            //
            //                    self.btnRequest.isHidden = true
            //                    self.btnCancelStartedTrip.isHidden = true
            //
            //                    self.methodAfterStartTrip(tripData: NSArray(array: data))
            //                }
            //
            //            }
            
            
            //            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            //            UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
            //
            //            })
            //
            //            self.btnRequest.isHidden = true
            //            self.btnCancelStartedTrip.isHidden = true
            //
            //            self.methodAfterStartTrip(tripData: NSArray(array: data))
            
        })
    }
    
    func socketMethodForGettingTripCompletedNotification()
    {
        self.socket?.on(SocketData.kBookingCompletedNotification, callback: { (data, ack) in
            print("socketMethodForGettingTripCompletedNotification() is \(data)")
            
            SingletonClass.sharedInstance.isTripContinue = false
            self.aryCompleterTripData = data
            _ = self.btnClose.compactMap{
                $0.isHidden = false
                if($0.tag != 0)
                {
                    $0.setImage(UIImage(named: "iconClose"), for: .normal)
                }
            }
            self.viewAdditionalDestinationLocation.isHidden = false
            if (SingletonClass.sharedInstance.passengerTypeOther) {
                
                SingletonClass.sharedInstance.passengerTypeOther = false
                self.completeTripInfo()
            }
            else {
                self.completeTripInfo()
            }
            
            //            if let getInfoFromData = data as? [[String:AnyObject]] {
            //
            //                if let infoData = getInfoFromData[0] as? [String:AnyObject] {
            //                    if let bookingInfo = infoData["Info"] as? [[String:AnyObject]] {
            //                        var bookingIdIs = String()
            //                        if let nowBookingID: Int = (bookingInfo[0])["Id"] as? Int {
            //                            bookingIdIs = "\(nowBookingID)"
            //                        }
            //                        else if let nowBookingID: String = (bookingInfo[0])["Id"] as? String {
            //                            bookingIdIs = nowBookingID
            //                        }
            //                        print("bookingIdIs: \(bookingIdIs)")
            //
            //                        if SingletonClass.sharedInstance.bookingId != "" {
            //                            if SingletonClass.sharedInstance.bookingId == bookingIdIs {
            //                                if (SingletonClass.sharedInstance.passengerTypeOther) {
            //
            //                                    SingletonClass.sharedInstance.passengerTypeOther = false
            //                                    self.completeTripInfo()
            //                                }
            //                                else {
            //                                    self.completeTripInfo()
            //                                    //                self.performSegue(withIdentifier: "showRating", sender: nil)
            //                                }
            //                            }
            //                        }
            //                    }
            //                }
            //            }
            
            /*
             
             let bookingId = ((((data as! [[String:AnyObject]])[0] as! [String:AnyObject])["Info"] as! [[String:AnyObject]])[0] as! [String:AnyObject])["Id"]
             
             //            self.viewMainFinalRating.isHidden = false
             
             if (SingletonClass.sharedInstance.passengerTypeOther) {
             
             SingletonClass.sharedInstance.passengerTypeOther = false
             self.completeTripInfo()
             }
             else {
             
             self.completeTripInfo()
             //                self.performSegue(withIdentifier: "showRating", sender: nil)
             }
             
             //            let next = mainStoryborad.instantiateViewController(withIdentifier: "GiveRatingViewController") as! GiveRatingViewController
             //            next.strBookingType = self.strBookingType
             //            next.delegate = self
             //            next.modalPresentationStyle = .overCurrentContext
             //            self.present(next, animated: true, completion: nil)
             */
            
        })
    }
    func delegateforGivingRate()
    {
        let ViewController = mainStoryboard.instantiateViewController(withIdentifier: "GiveRatingViewController") as? GiveRatingViewController
        ViewController?.delegateRating = self
        ViewController?.strBookingType = strBookingType
        ViewController?.dictData = self.arrDataAfterCompletetionOfTrip[0] as? NSDictionary
        UIApplication.shared.windows.first?.rootViewController?.present(ViewController!, animated: true, completion: nil)
    }
    
    func completeTripInfo() {
        
        clearMap()
        self.stopTimer()
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        //        Utilities.hideActivityIndicator()
        self.scheduledTimerWithTimeInterval()
        self.TempBookingInfoDict.removeAll()
        self.txtCurrentLocation.isUserInteractionEnabled = true

        let alert = UIAlertController(title: appName, message: "Your trip has been completed".localized, preferredStyle: .alert)
        let OK = UIAlertAction(title: "OK".localized, style: .default, handler: { ACTION in
            
            
            //                self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
            self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
            
            self.dismiss(animated: true, completion: nil)
            //                    self.socket?.off(SocketData.kBookingCompletedNotification)
            self.arrDataAfterCompletetionOfTrip = NSMutableArray(array: (self.aryCompleterTripData[0] as! NSDictionary).object(forKey: "Info") as! NSArray)
            
            self.viewTripActions.isHidden = true
            self.constraintVerticalSpacingLocation?.priority = UILayoutPriority(800)

            self.viewCarLists.isHidden = false
            //                self.viewShareRideView.isHidden = false
            self.ConstantViewCarListsHeight.constant = 150
            //                    self.constraintTopSpaceViewDriverInfo.constant = 170
            self.viewMainFinalRating.isHidden = true
            SingletonClass.sharedInstance.passengerTypeOther = false
            
            self.viewCarLists.isHidden = true
            self.ConstantViewCarListsHeight.constant = 150
            self.currentLocationAction()
            self.getPlaceFromLatLong()
            //            self.getRaringNotification()
            
            
            self.clearDataAfteCompleteTrip()
            //                self.performSegue(withIdentifier: "seguePresentTripDetails", sender: nil)
            
            
            //            let viewController = mainStoryborad.instantiateViewController(withIdentifier: "TripDetailsViewController") as? TripDetailsViewController
            //            viewController?.arrData = self.arrDataAfterCompletetionOfTrip as NSMutableArray
            //            viewController?.delegate = self
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "TripInfoViewController") as! TripInfoViewController
            viewController.dictData = self.arrDataAfterCompletetionOfTrip[0] as! NSDictionary
            viewController.delegate = self
            
            DispatchQueue.main.async
            {
                //                    self.btnCurrentLocation(self.btnCurrentLocationIcon)
                self.btnCurrentLocation(self.btnCurrentLocation)
            }
            
            
            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
            alertWindow.rootViewController = UIViewController()
            alertWindow.windowLevel = UIWindowLevelAlert + 1;
            alertWindow.makeKeyAndVisible()
            alertWindow.rootViewController?.present(viewController, animated: true, completion: nil)
            
            //            let next = mainStoryborad.instantiateViewController(withIdentifier: "TripInfoViewController") as! TripInfoViewController
            //            next.dictData = self.arrDataAfterCompletetionOfTrip[0] as! NSDictionary
            //            next.delegate = self
            //            DispatchQueue.main.async
            //                {
            //                    //                    self.btnCurrentLocation(self.btnCurrentLocationIcon)
            //                    self.btnCurrentLocation(self.btnCurrentLocation)
            //            }
            //            Utilities.presentPopupOverScreen(next)
            
        })
        
        alert.addAction(OK)
        //        Sj Change:
        //                self.present(alert, animated: true, completion: nil)
        
        
        //        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        //        alertWindow.rootViewController = UIViewController()
        //        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        //        alertWindow.makeKeyAndVisible()
        //        alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
        
        //        UtilityClass.showAlertWithCompletion("Your trip has been completed", message: "", vc: self, completionHandler: { (status) in
        //
        //            if (status == true)
        //            {
        //
        //
        //
        ////                self.performSegue(withIdentifier: "seguePresentTripDetails", sender: nil)
        //
        ////                let drinkViewController = segue.destination as! TripDetailsViewController
        ////                drinkViewController.arrData = arrDataAfterCompletetionOfTrip as NSMutableArray
        ////                drinkViewController.delegate = self
        //
        //
        //
        //
        //
        ////                UIApplication.shared.keyWindow?.rootViewController?.present(viewController!, animated: true, completion: nil)
        //
        //                //                if (SingletonClass.sharedInstance.passengerTypeOther) {
        //                //                }
        //                //                else {
        //                //
        //                //                    self.openRatingView()
        //                //                }
        //
        //
        //            }
        //            else
        //            {
        //                print("Else Part")
        //            }
        //        })
        
        UtilityClass.setCustomAlert(title: appName, message: "Your trip has been completed") { (index, str) in
            self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
            self.arrDataAfterCompletetionOfTrip = NSMutableArray(array: (self.aryCompleterTripData[0] as! NSDictionary).object(forKey: "Info") as! NSArray)
            
            self.viewTripActions.isHidden = true
            self.constraintVerticalSpacingLocation?.priority = UILayoutPriority(800)

            self.viewCarLists.isHidden = false
            self.ConstantViewCarListsHeight.constant = 150
            
            self.viewMainFinalRating.isHidden = true
            SingletonClass.sharedInstance.passengerTypeOther = false
            
            self.viewCarLists.isHidden = false
            self.ConstantViewCarListsHeight.constant = 150
            
            self.currentLocationAction()
            self.getPlaceFromLatLong()
            self.getRaringNotification()
            self.clearDataAfteCompleteTrip()
            
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "TripInfoViewController") as! TripInfoViewController
            viewController.dictData = self.arrDataAfterCompletetionOfTrip[0] as! NSDictionary
            viewController.delegate = self
            self.btnCurrentLocation(self.btnCurrentLocation)
            UIApplication.shared.windows.first?.rootViewController?.present(viewController, animated: true, completion: nil)
        }
    }
    
    func clearSetupMapForNewBooking() {
        
        self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
        clearMap()
        self.currentLocationAction()
        self.viewTripActions.isHidden = true
        self.constraintVerticalSpacingLocation?.priority = UILayoutPriority(800)

        //        self.viewCarLists.isHidden = false
        //        self.ConstantViewCarListsHeight.constant = 150
        clearDataAfteCompleteTrip()
    }
    
    func clearDataAfteCompleteTrip() {
        
        self.MarkerCurrntLocation.isHidden = false
        selectedIndexPath = nil
        self.collectionViewCars.reloadData()
        self.txtCurrentLocation.text = ""
        self.txtDestinationLocation.text = ""
        self.txtAdditionalDestinationLocation.text = ""
        self.dropoffLat = 0
        self.doublePickupLng = 0
        
        //        SingletonClass.sharedInstance.strPassengerID = ""
        aryRequestAcceptedData = NSMutableArray()
        self.strModelId = ""
        self.strPickupLocation = ""
        self.strDropoffLocation = ""
        self.doublePickupLat = 0
        self.doublePickupLng = 0
        self.doubleDropOffLat = 0
        self.doubleDropOffLng = 0
        self.strModelId = ""
        self.strCarModelIDIfZero = ""
        self.strCarModelID = ""
        self.txtNote.text = ""
        self.txtFeedbackFinal.text = ""
        self.txtHavePromocode.text = ""
        self.strAdditionalDropoffLocation = ""
        self.doubleUpdateNewLat = 0
        self.doubleUpdateNewLng = 0
        SingletonClass.sharedInstance.isTripContinue = false
        self.viewAdditionalDestinationLocation.isHidden = false
        self.txtCurrentLocation.isUserInteractionEnabled = true

    }
    
    func getRaringNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.openRatingView), name: Notification.Name("CallToRating"), object: nil)
    }
    
    @objc func openRatingView() {
        
        let next = mainStoryboard.instantiateViewController(withIdentifier: "GiveRatingViewController") as! GiveRatingViewController
        next.strBookingType = self.strBookingType
        //        next.delegate = self
        //            self.presentingViewController?.modalPresentationStyle
        self.present(next, animated: true, completion: nil)
    }
    
    func socketMethodForCancelRequestTrip(withReason : String)
    {
        
        let myJSON = [SocketDataKeys.kBookingIdNow : SingletonClass.sharedInstance.bookingId, SocketDataKeys.kCancelReasons : withReason] as [String : Any]
        socket?.emit(SocketData.kCancelTripByPassenger , with: [myJSON], completion: nil)
        viewAdditionalDestinationLocation.isHidden = false
        _ = btnClose.compactMap{$0.isHidden = false}
        self.strAdditionalDropoffLocation = ""
        self.doubleUpdateNewLat = 0
        self.doubleUpdateNewLng = 0
        stopTimer()
        self.aryRequestAcceptedData.removeAllObjects()
        self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
        self.viewCarLists.isHidden = true
        SingletonClass.sharedInstance.bookingId = ""
        //        self.viewShareRideView.isHidden = true
        
    }
    // ------------------------------------------------------------
    
    func onAcceptBookLaterBookingRequestNotification() {
        
        self.socket?.on(SocketData.kAcceptAdvancedBookingRequestNotification, callback: { (data, ack) in
            print("onAcceptBookLaterBookingRequestNotification() is \(data)")
            
            //            self.playSound(fileName: "RequestConfirm", extensionType: "mp3")
            
            //            UtilityClass.showAlertWithCompletion("", message: "Your request has been Accepted.", vc: self, completionHandler: { ACTION in
            //
            //                self.stopSound(fileName: "RequestConfirm", extensionType: "mp3")
            //            })
            
            var bookingId = String()
            
            if let bookingInfoData = (data as! [[String:AnyObject]])[0]["BookingInfo"] as? [[String:AnyObject]] {
                if let bookingInfo = bookingInfoData[0]["Id"] as? Int {
                    bookingId = "\(bookingInfo)"
                }
                else if let bookingInfo = bookingInfoData[0]["Id"] as? String {
                    bookingId = bookingInfo
                }
                
                if SingletonClass.sharedInstance.bookingId != "" {
                    if SingletonClass.sharedInstance.bookingId == bookingId {
                        
                        UtilityClass.setCustomAlert(title: "\(appName)", message: "Your request has been Accepted.") { (index, title) in
                            //               self.stopSound(fileName: "RequestConfirm", extensionType: "mp3")
                        }
                        self.strBookingType = "BookLater"
                        self.DriverInfoAndSetToMap(driverData: NSArray(array: data))
                    }
                }
                else {
                    UtilityClass.setCustomAlert(title: "\(appName)", message: "Your request has been Accepted.") { (index, title) in
                        //               self.stopSound(fileName: "RequestConfirm", extensionType: "mp3")
                    }
                    self.strBookingType = "BookLater"
                    self.DriverInfoAndSetToMap(driverData: NSArray(array: data))
                }
            }
        })
    }
    
    func onRejectBookLaterBookingRequestNotification() {
        
        self.socket?.on(SocketData.kRejectAdvancedBookingRequestNotification, callback: { (data, ack) in
            print("onRejectBookLaterBookingRequestNotification() is \(data)")
            
            //            self.playSound(fileName: "PickNGo", extensionType: "mp3")
            
//            let alert = UIAlertController(title: nil, message: "Your request has been rejected.".localized, preferredStyle: .alert)
//            let OK = UIAlertAction(title: "OK".localized, style: .default, handler: { (ACTION) in
//                //                self.stopSound(fileName: "PickNGo", extensionType: "mp3")
//            })
//            alert.addAction(OK)
//            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
            
            
            UtilityClass.setCustomAlert(title: "", message: "Your request has been rejected.".localized, completionHandler: nil)
            
        })
    }
    
    func onPickupPassengerByDriverInBookLaterRequestNotification() {
        
        self.socket?.on(SocketData.kAdvancedBookingPickupPassengerNotification, callback: { (data, ack) in
            print("onPickupPassengerByDriverInBookLaterRequestNotification() is \(data)")
            
            var bookingId = String()
            
            if let bookingInfoData = (data as! [[String:AnyObject]])[0]["BookingInfo"] as? [[String:AnyObject]] {
                if let bookingInfo = bookingInfoData[0]["Id"] as? Int {
                    bookingId = "\(bookingInfo)"
                }
                else if let bookingInfo = bookingInfoData[0]["Id"] as? String {
                    bookingId = bookingInfo
                }
                
                if SingletonClass.sharedInstance.bookingId != "" {
                    
                    if SingletonClass.sharedInstance.bookingId == bookingId {
                        self.strBookingType = "BookLater"
//                        let alert = UIAlertController(title: nil, message: "Your trip has now started.".localized, preferredStyle: .alert)
//                        let OK = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
//                        alert.addAction(OK)
//                        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
                        
                        
                        UtilityClass.setCustomAlert(title: "", message: "Your trip has now started.".localized, completionHandler: nil)

                        
                        self.btnRequest.isHidden = true
                        self.btnCancelStartedTrip.isHidden = true
                        //            SingletonClass.sharedInstance.isTripContinue = true
                        self.methodAfterStartTrip(tripData: NSArray(array: data))
                        
                    }
                }
                else {
                    self.strBookingType = "BookLater"
//                    let alert = UIAlertController(title: nil, message: "Your trip has now started.".localized, preferredStyle: .alert)
//                    let OK = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
//                    alert.addAction(OK)
//                    (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
                    
                    
                    UtilityClass.setCustomAlert(title: "", message: "Your trip has now started.".localized, completionHandler: nil)

                    
                    self.btnRequest.isHidden = true
                    self.btnCancelStartedTrip.isHidden = true
                    //            SingletonClass.sharedInstance.isTripContinue = true
                    self.methodAfterStartTrip(tripData: NSArray(array: data))
                }
            }
        })
    }
    
    func onTripHoldingNotificationForPassenger() {
        
        self.socket?.on(SocketData.kReceiveHoldingNotificationToPassenger, callback: { (data, ack) in
            print("onTripHoldingNotificationForPassenger() is \(data)")
            
            var message = String()
            message = "Trip on Hold"
            
            if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                if SelectedLanguage == "en" {
                    
                    let resAry = NSArray(array: data) //as? NSArray {
                        message = (resAry.object(at: 0) as? NSDictionary)?.object(forKey: "message") as? String ?? "----"
                        //                UtilityClass.showAlert("", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
//                    }
//                    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//                    let OK = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
//
//                    alert.addAction(OK)
//
//                    (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
//
                    
                    UtilityClass.setCustomAlert(title: "", message: message.localized, completionHandler: nil)

                }
                else if SelectedLanguage == "sw"
                {
                     let resAry = NSArray(array: data) //as? NSArray {
                        message = (resAry.object(at: 0) as? NSDictionary)?.object(forKey: "swahili_message") as? String ?? "----"
                        //                UtilityClass.showAlert("", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
//                    }
//                    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//                    let OK = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
//
//                    alert.addAction(OK)
//
//                    (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
                    
                    UtilityClass.setCustomAlert(title: "", message: message.localized, completionHandler: nil)

                }
            }
        })
    }
    
    func onTripHoldingNotificationForPassengerLater() {
        
        self.socket?.on(SocketData.kAdvancedBookingTripHoldNotification, callback: { (data, ack) in
            print("onTripHoldingNotificationForPassengerLater() is \(data)")
            
            var message = String()
            message = "Trip on Hold"
            
            let resAry = NSArray(array: data) //as? NSArray {
                message = (resAry.object(at: 0) as? NSDictionary)?.object(forKey: "message") as? String ?? ""
                //                UtilityClass.showAlert("", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
       //     }
//
//            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//            let OK = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
//
//            alert.addAction(OK)
//
//            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
            
            
            UtilityClass.setCustomAlert(title: "", message: message.localized, completionHandler: nil)

            
        })
    }
    
    func onReceiveDriverLocationToPassenger() {
        if(self.socket?.status == .connected)
        {
            print("hi")
        }
        self.socket?.on(SocketData.kReceiveDriverLocationToPassenger, callback: { (data, ack) in
            print("onReceiveDriverLocationToPassenger() is \(data)")
            
            SingletonClass.sharedInstance.driverLocation = (data as NSArray).object(at: 0) as! [String : AnyObject]
            
            var DoubleLat = Double()
            var DoubleLng = Double()
            
            if let lat = SingletonClass.sharedInstance.driverLocation["Location"]! as? [Double] {
                DoubleLat = lat[0]
                DoubleLng = lat[1]
            }
            else if let lat = SingletonClass.sharedInstance.driverLocation["Location"]! as? [String] {
                DoubleLat = Double(lat[0])!
                DoubleLng = Double(lat[1])!
            }
            
            var DriverCordinate = CLLocationCoordinate2D(latitude: DoubleLat , longitude: DoubleLng)
            
            
            //            var DriverCordinate = CLLocationCoordinate2D(latitude: Double("23.076701577176262")! , longitude: Double("72.51612203357585")!)
            
            DriverCordinate = CLLocationCoordinate2DMake(DriverCordinate.latitude, DriverCordinate.longitude)
            
            if(self.destinationCordinate == nil)
            {
                self.destinationCordinate = CLLocationCoordinate2DMake(DriverCordinate.latitude, DriverCordinate.longitude)
            }
            
            if self.driverMarker == nil {
                
                self.driverMarker = GMSMarker(position: DriverCordinate) // self.originCoordinate
                self.driverMarker.icon = UIImage(named: "dummyCar")
                self.driverMarker.map = self.mapView
            }
            else {
                self.driverMarker.icon = UIImage.init(named: "dummyCar")
            }
            _ = DriverCordinate
            self.moveMent.ARCarMovement(marker: self.driverMarker, oldCoordinate: self.destinationCordinate, newCoordinate: DriverCordinate, mapView: self.mapView, bearing: Float(SingletonClass.sharedInstance.floatBearing))

            self.driverMarker.position = DriverCordinate// = GMSMarker(position: DriverCordinate) // self.originCoordinate
            self.driverMarker.map = self.mapView
            
            self.driverMarker.icon = UIImage(named: "dummyCar")
            
            self.destinationCordinate = DriverCordinate
            self.MarkerCurrntLocation.isHidden = true
            
//            if let topVC = self.navigationController?.topViewController?.presentedViewController as? DriverInfoViewController
//            {
//                if(topVC.lblApproxTime.text == "calculating...")
//                {
//                    
//                    
//                    let bookingInfo = ((self.aryRequestAcceptedData.object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
//                    
////                    next.strPickUpLat = bookingInfo.object(forKey: "PickupLat") as? String ?? ""
////                    next.strPickUpLng = bookingInfo.object(forKey: "PickupLng") as? String ?? ""
//
//                    topVC.strPickUpLat = "\(DoubleLat)"
//                    topVC.strPickUpLng = "\(DoubleLng)"
//                    topVC.strCurrentLat =  bookingInfo.object(forKey: "PickupLat") as? String ?? ""
//                    topVC.strCurrentLng = bookingInfo.object(forKey: "PickupLng") as? String ?? ""
//                    topVC.getEstimate()
//                }
//            }
          
            
            if(self.boolShouldTrackCamera)
            {
                let camera = GMSCameraPosition.camera(withLatitude: DriverCordinate.latitude,longitude: DriverCordinate.longitude, zoom: 17)
                self.mapView.camera = camera
            }
            // ----------------------------------------------------------------------
            
            //            CATransaction.begin()
            //            CATransaction.setAnimationDuration(0.5)
            //            CATransaction.setValue(Int(2.0), forKey: kCATransactionAnimationDuration)
            //            CATransaction.setCompletionBlock({() -> Void in
            //                self.driverMarker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
            //
            //                //New bearing value from backend after car movement is done
            //            })
            //
            ////             UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
            ////                self.driverMarker.position = newCordinate
            ////                self.driverMarker.map = self.mapView
            ////
            //////                self.updatePolyLineToMapFromDriverLocation()
            ////             })
            //
            //            CATransaction.commit()
            // ----------------------------------------------------------------------
            
        })
    }
    
    var driverIDTimer : String!
    var passengerIDTimer : String!
    func sendPassengerIDAndDriverIDToGetLocation(driverID : String , passengerID: String) {
        
        
        driverIDTimer = driverID
        passengerIDTimer = passengerID
        if timerToGetDriverLocation == nil {
//            timerToGetDriverLocation = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(HomeViewController.getDriverLocation), userInfo: nil, repeats: true)
        }
        
    }
    
    func stopTimer() {
        if timerToGetDriverLocation != nil {
            timerToGetDriverLocation.invalidate()
            timerToGetDriverLocation = nil
        }
    }
    
    @objc func getDriverLocation()
    {
        let myJSON = ["PassengerId" : passengerIDTimer,  "DriverId" : driverIDTimer] as [String : Any]
        socket?.emit(SocketData.kSendDriverLocationRequestByPassenger , with: [myJSON], completion: nil)
    }
    
    
    func postPickupAndDropLocationForEstimateFare()
    {
        let driverID = aryOfOnlineCarsIds.compactMap{ $0 }.joined(separator: ",")
        
        SingletonClass.sharedInstance.strOnlineDriverID = driverID
        var myJSON = ["PassengerId" : SingletonClass.sharedInstance.strPassengerID,  "PickupLocation" : strPickupLocation ,"PickupLat" :  self.doublePickupLat , "PickupLong" :  self.doublePickupLng, "DropoffLocation" : strDropoffLocation,"DropoffLat" : self.doubleDropOffLat, "DropoffLon" : self.doubleDropOffLng,"Ids" : driverID, "ShareRiding": intShareRide ] as [String : Any]
        
        
//        {"PassengerId":"56","PickupLocation":"9416, 9416, Harankui Rd, Arankui Village, Sherthali, Botad, Gujarat 364710, India","DropoffLocation":"Iskcon Cross Rd, Ramdev Nagar, Ahmedabad, Gujarat 380015, India","PickupLat":22.170498,"PickupLong":71.675768,"DropoffLocation2":"Isquare Corporate Park, Panchamrut Bunglows II, Sola, Ahmedabad, Gujarat 380059","Ids":""}
        
        if(strDropoffLocation.count == 0)
        {
            myJSON = ["PassengerId" : SingletonClass.sharedInstance.strPassengerID,  "PickupLocation" : strPickupLocation ,"PickupLat" :  self.doublePickupLat , "PickupLong" :  self.doublePickupLng, "DropoffLocation" : strDropoffLocation,"DropoffLat" : self.doubleDropOffLng, "DropoffLon" : self.doubleDropOffLng,"Ids" : driverID, "ShareRiding": intShareRide] as [String : Any]
        }
        else if(strDropoffLocation.count != 0 && strAdditionalDropoffLocation.count != 0)
        {
            myJSON = ["PassengerId" : SingletonClass.sharedInstance.strPassengerID,  "PickupLocation" : strPickupLocation ,"PickupLat" :  self.doublePickupLat , "PickupLong" :  self.doublePickupLng, "DropoffLocation" : strDropoffLocation,"DropoffLat" : self.doubleDropOffLng, "DropoffLon" : self.doubleDropOffLng,"Ids" : driverID, "ShareRiding": intShareRide, "DropoffLocation2" : strAdditionalDropoffLocation,"DropOffLat2" : self.doubleUpdateNewLat,"DropOffLon2" : self.doubleUpdateNewLng] as [String : Any]
        }
//        print("kSendRequestForGetEstimateFare \(myJSON)")
        socket?.emit(SocketData.kSendRequestForGetEstimateFare , with: [myJSON], completion: nil)
    }
    
    func onBookingDetailsAfterCompletedTrip() {
        
        self.socket?.on(SocketData.kAdvancedBookingDetails, callback: { (data, ack) in
            print("onBookingDetailsAfterCompletedTrip() is \(data)")
            
            SingletonClass.sharedInstance.isTripContinue = false
            
            self.aryCompleterTripData = data
            
            //            self.viewMainFinalRating.isHidden = false
            
            var bookingId = String()
            if let bookingData = data as? [[String:AnyObject]] {
                
                if let info = bookingData[0]["Info"] as? [[String:AnyObject]] {
                    
                    if let infoId = info[0]["Id"] as? String {
                        bookingId = infoId
                    }
                    else if let infoId = info[0]["Id"] as? Int {
                        bookingId = "\(infoId)"
                    }
                    
                    if SingletonClass.sharedInstance.bookingId != "" {
                        if SingletonClass.sharedInstance.bookingId == bookingId {
                            
                            if (SingletonClass.sharedInstance.passengerTypeOther) {
                                
                                SingletonClass.sharedInstance.passengerTypeOther = false
                                self.completeTripInfo()
                            }
                            else {
                                self.completeTripInfo()
                                //                let next = mainStoryborad.instantiateViewController(withIdentifier: "GiveRatingViewController") as! GiveRatingViewController
                                //                next.strBookingType = self.strBookingType
                                //                next.delegate = self
                                //                //            self.presentingViewController?.modalPresentationStyle
                                //                self.present(next, animated: true, completion: nil)
                            }
                        }
                    }
                    
                }
                
            }
        })
    }
    
    func CancelBookLaterTripAfterDriverAcceptRequest(withReason : String) {
        
        let myJSON = [SocketDataKeys.kBookingIdNow : SingletonClass.sharedInstance.bookingId, SocketDataKeys.kCancelReasons : withReason] as [String : Any]
        socket?.emit(SocketData.kAdvancedBookingCancelTripByPassenger , with: [myJSON], completion: nil)
        
        self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
        
        self.aryRequestAcceptedData.removeAllObjects()
        self.strAdditionalDropoffLocation = ""
        self.doubleUpdateNewLat = 0
        self.doubleUpdateNewLng = 0
        viewAdditionalDestinationLocation.isHidden = false
        _ = btnClose.compactMap{$0.isHidden = false}
        clearSetupMapForNewBooking()
        clearCurrentLocation()
        clearDataAfteCompleteTrip()
        
    }
    
    func onAdvanceTripInfoBeforeStartTrip() {
        
        self.socket?.on(SocketData.kInformPassengerForAdvancedTrip, callback: { (data, ack) in
            print("onAdvanceTripInfoBeforeStartTrip() is \(data)")
            
            var message = String()
            message = "Trip on Hold"
            
             let resAry = NSArray(array: data) //as? NSArray {
                message = (resAry.object(at: 0) as? NSDictionary)?.object(forKey: "message") as? String ?? ""
                
         //   }
            
//            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//            let OK = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
//
//            alert.addAction(OK)
//
//            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
            
            
            UtilityClass.setCustomAlert(title: "", message: message.localized, completionHandler: nil)

            
        })
        
    }
    
    func onReceiveNotificationWhenDriverAcceptRequest() {
        
        self.socket?.on(SocketData.kAcceptAdvancedBookingRequestNotify, callback: { (data, ack) in
            print("onReceiveNotificationWhenDriverAcceptRequest is \(data)")
            
            var bookingId = String()
            
            if let bookingInfoData = (data as! [[String:AnyObject]])[0]["BookingInfo"] as? [[String:AnyObject]] {
                self.TempBookingInfoDict = bookingInfoData[0] //as? [String:Any] ?? [:]
 
                if let bookingInfo = bookingInfoData[0]["Id"] as? Int {
                    bookingId = "\(bookingInfo)"
                }
                else if let bookingInfo = bookingInfoData[0]["Id"] as? String {
                    bookingId = bookingInfo
                    
                }
                
                if SingletonClass.sharedInstance.bookingId != "" {
                    
                    if SingletonClass.sharedInstance.bookingId == bookingId {
                        var message = String()
                        message = "Trip on Hold"
                        
                        let resAry = NSArray(array: data) //as? NSArray //{
                        message = (resAry.object(at: 0) as? NSDictionary)?.object(forKey: "message") as? String ?? "---"
                        //}
                        
                        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                        let OK = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
                        alert.addAction(OK)
//                        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
                        
                        UtilityClass.setCustomAlert(title: "\(appName)", message: message) { (index, title) in
                        }
                    }
                }
                else {
                    var message = String()
                    message = "Trip on Hold"
                    
                     let resAry = NSArray(array: data) //as? NSArray {
                    message = (resAry.object(at: 0) as? NSDictionary)?.object(forKey: "message") as? String ?? "----"
                  //  }
                    
                    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    let OK = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
                    alert.addAction(OK)
//                    (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
                    
                    
                    UtilityClass.setCustomAlert(title: "\(appName)", message: message) { (index, title) in
                    }

                }
            }
            
        })
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Auto Suggession on Google Map
    //-------------------------------------------------------------
    
    //    var BoolCurrentLocation = Bool()
    
    @IBAction func txtDestinationLocation(_ sender: UITextField) {
        
        let visibleRegion = mapView.projection.visibleRegion()
        let bounds = GMSCoordinateBounds(coordinate: visibleRegion.farLeft, coordinate: visibleRegion.nearRight)
        
        
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        acController.autocompleteBounds = bounds
        let filter = GMSAutocompleteFilter()
        filter.country = "GY"
        if(UIDevice.current.name.lowercased() == "rahul’s iphone" || UIDevice.current.name.lowercased() == "iphone (6)")
        {
//            filter.country = "IN"
        }
        acController.autocompleteFilter = filter
        if(sender.tag == 0)
        {
            locationEnteredType = .dropOffFirst
        }
        else if (sender.tag == 1)
        {
            locationEnteredType = .dropOffSecond
        }
        present(acController, animated: true, completion: nil)
        
    }
    
    @IBAction func txtCurrentLocation(_ sender: UITextField) {
        
        let visibleRegion = mapView.projection.visibleRegion()
        let bounds = GMSCoordinateBounds(coordinate: visibleRegion.farLeft, coordinate: visibleRegion.nearRight)
        
        
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        acController.autocompleteBounds = bounds

        let filter = GMSAutocompleteFilter()
        filter.country = "GY"
        if(UIDevice.current.name.lowercased() == "rahul’s iphone" || UIDevice.current.name.lowercased() == "iphone (6)")
        {
//            filter.country = "IN"
        }
        acController.autocompleteFilter = filter
        //        BoolCurrentLocation = true
        locationEnteredType = .pickup
        
        //        acController.tintColor = UIColor.white
        
        present(acController, animated: true, completion: nil)
    }
    
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        self.MarkerCurrntLocation.isHidden = false
        self.btnDoneForLocationSelected.isHidden = false
        self.viewBookNowLater.isHidden = true
        self.isFromAutoComplete = true
        if locationEnteredType == .pickup {
            
            self.locationEnteredType = .pickup
            self.ConstantViewCarListsHeight.constant = 0
            self.viewCarLists.isHidden = true
            let SelectedFromLocation = place.formattedAddress ?? "-"
            txtCurrentLocation.text = SelectedFromLocation
            strPickupLocation = SelectedFromLocation
            doublePickupLat = place.coordinate.latitude
            doublePickupLng = place.coordinate.longitude
            currentLocationMarker.map = nil
            let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude,longitude: place.coordinate.longitude, zoom: 17)
            self.mapView.camera = camera
//            mapView.animate(to: camera)
            
        }
        else if locationEnteredType == .dropOffFirst{
            
            locationEnteredType = .dropOffFirst
            self.ConstantViewCarListsHeight.constant = 0
            self.viewCarLists.isHidden = true
            let SelectedDestinationLocation = place.formattedAddress ?? "-"
            txtDestinationLocation.text = SelectedDestinationLocation
            strDropoffLocation = SelectedDestinationLocation
            doubleDropOffLat = place.coordinate.latitude
            doubleDropOffLng = place.coordinate.longitude
            print("the coordinates are \(doubleDropOffLat) \(doubleDropOffLng)")
            destinationLocationMarker.map = nil
            let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude,longitude: place.coordinate.longitude, zoom: 17)
            self.mapView.camera = camera
//            mapView.animate(to: camera)
            
        }
        else if locationEnteredType == .dropOffSecond{
            
            locationEnteredType = .dropOffSecond
            //            self.strLocationType = destinationLocationMarkerText
            self.ConstantViewCarListsHeight.constant = 0
            self.viewCarLists.isHidden = true
            let SelectedDestinationLocation = place.formattedAddress ?? "-"
            txtAdditionalDestinationLocation.text = SelectedDestinationLocation
            strAdditionalDropoffLocation = SelectedDestinationLocation
            doubleUpdateNewLat = place.coordinate.latitude
            doubleUpdateNewLng = place.coordinate.longitude
            destinationLocationMarker.map = nil
            let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude,longitude: place.coordinate.longitude, zoom: 17)
            self.mapView.camera = camera
//            mapView.animate(to: camera)
            
        }
        
        //        if txtCurrentLocation.text!.count != 0 && txtDestinationLocation.text!.count != 0 && aryOfOnlineCarsIds.count != 0 {
        //            postPickupAndDropLocationForEstimateFare()
        //        }
        
        if txtCurrentLocation.text!.count != 0 && txtDestinationLocation.text!.count != 0 {
            postPickupAndDropLocationForEstimateFare()
            self.btnDoneForLocationSelected.isHidden = false
            //            setupBothCurrentAndDestinationMarkerAndPolylineOnMap()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    /* func setupBothCurrentAndDestinationMarkerAndPolylineOnMap() {
     
     if  txtCurrentLocation.text != "" && txtDestinationLocation.text != "" {
     
     MarkerCurrntLocation.isHidden = true
     
     var PickupLat = doublePickupLat
     var PickupLng = doublePickupLng
     
     if(SingletonClass.sharedInstance.isTripContinue)
     {
     PickupLat = doubleUpdateNewLat
     PickupLng = doubleUpdateNewLng
     }
     
     
     let DropOffLat = doubleDropOffLat
     let DropOffLon = doubleDropOffLng
     
     let dummyLatitude = Double(PickupLat) - Double(DropOffLat)
     let dummyLongitude = Double(PickupLng) - Double(DropOffLon)
     
     let waypointLatitude = Double(PickupLat) - dummyLatitude
     let waypointSetLongitude = Double(PickupLng) - dummyLongitude
     
     let originalLoc: String = "\(PickupLat),\(PickupLng)"
     let destiantionLoc: String = "\(DropOffLat),\(DropOffLon)"
     
     
     let bounds = GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: PickupLat, longitude: PickupLng), coordinate: CLLocationCoordinate2D(latitude: DropOffLat, longitude: DropOffLon))
     
     let update = GMSCameraUpdate.fit(bounds, withPadding: CGFloat(100))
     
     self.mapView.animate(with: update)
     
     self.mapView.moveCamera(update)
     
     setDirectionLineOnMapForSourceAndDestinationShow(origin: originalLoc, destination: destiantionLoc, waypoints: ["\(waypointLatitude),\(waypointSetLongitude)"], travelMode: nil, completionHandler: nil)
     
     }
     }*/
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        //print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        //print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnClearPickupLocation(_ sender: UIButton) {
        //        txtCurrentLocation.text = ""
        clearMap()
        clearCurrentLocation()
    }
    
    @IBAction func btnClearDropOffLocation(_ sender: UIButton) {
        //        txtDestinationLocation.text = ""
        if(sender.imageView?.image == UIImage(named: "iconEditProfile"))
        {
            if(sender.tag == 1)
            {
                self.txtDestinationLocation(txtDestinationLocation)
            }
            else if (sender.tag == 2)
            {
                self.txtDestinationLocation(txtAdditionalDestinationLocation)
            }
        }
        else
        {
            clearMap()
            //        clearDestinationLocation()
            
            if(sender.tag == 0)
            {
                
                if(txtAdditionalDestinationLocation.text?.count != 0)
                {
                    txtDestinationLocation.text = txtAdditionalDestinationLocation.text
                    strDropoffLocation = strAdditionalDropoffLocation
                    doubleDropOffLat = doubleUpdateNewLat
                    doubleDropOffLng = doubleUpdateNewLng
                    clearAdditionalDestinationLocation()
                }
                else
                {
                    clearDestinationLocation()
                }
            }
            else if(sender.tag == 1)
            {
                clearDestinationLocation()
            }
            else
            {
                clearAdditionalDestinationLocation()
            }
        }
    }
    
    func clearCurrentLocation() {
        
        MarkerCurrntLocation.isHidden = false
        txtCurrentLocation.text = ""
        strPickupLocation = ""
        doublePickupLat = 0
        doublePickupLng = 0
        self.currentLocationMarker.map = nil
        self.destinationLocationMarker.map = nil
        self.locationEnteredType = .pickup
        self.routePolyline.map = nil
        
        self.btnDoneForLocationSelected.isHidden = false
        self.viewBookNowLater.isHidden = true
        self.ConstantViewCarListsHeight.constant = 0
        self.viewCarLists.isHidden = true
        //        self.viewShareRideView.isHidden = true
    }
    
    func clearDestinationLocation() {
        
        MarkerCurrntLocation.isHidden = false
        txtDestinationLocation.text = ""
        strDropoffLocation = ""
        doubleDropOffLat = 0
        doubleDropOffLng = 0
        self.destinationLocationMarker.map = nil
        self.currentLocationMarker.map = nil
        self.locationEnteredType = .dropOffFirst
        self.routePolyline.map = nil
        
        self.btnDoneForLocationSelected.isHidden = false
        self.viewBookNowLater.isHidden = true
        self.ConstantViewCarListsHeight.constant = 0
        self.viewCarLists.isHidden = true
        //        self.viewShareRideView.isHidden = true
    }
    
    func clearAdditionalDestinationLocation() {
        
        MarkerCurrntLocation.isHidden = false
        self.txtAdditionalDestinationLocation.text = ""
        strAdditionalDropoffLocation = ""
        doubleUpdateNewLng = 0
        doubleUpdateNewLat = 0
        self.destinationLocationMarker.map = nil
        self.currentLocationMarker.map = nil
        self.locationEnteredType = .dropOffSecond
        self.routePolyline.map = nil
        
        self.btnDoneForLocationSelected.isHidden = false
        self.viewBookNowLater.isHidden = true
        self.ConstantViewCarListsHeight.constant = 0
        self.viewCarLists.isHidden = true
        //        self.viewShareRideView.isHidden = true
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    let aryDummyLineData = [[23.073178, 72.514223], [23.073104, 72.514438], [23.073045, 72.514604], [23.073052, 72.514700], [23.072985, 72.514826],
                            [23.073000, 72.514885], [23.072985, 72.514944], [23.072931, 72.514949], [23.072896, 72.514960], [23.072875, 72.514959],
                            [23.072791, 72.514941], [23.072722, 72.514920], [23.072554, 72.514807], [23.072416, 72.514716], [23.071898, 72.514432],
                            [23.071641, 72.514282], [23.071365, 72.514110], [23.071329, 72.514090], [23.071299, 72.514085], [23.071262, 72.514176],
                            [23.071195, 72.514350], [23.071121, 72.514508]]
    
    var dummyOriginCordinate = CLLocationCoordinate2D()
    var dummyDestinationCordinate = CLLocationCoordinate2D()
    
    var dummyOriginCordinateMarker: GMSMarker!
    var dummyDestinationCordinateMarker: GMSMarker!
    
    func getDummyDataLinedata() {
        
        for index in 0..<aryDummyLineData.count {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.setDummyLine(index: index)
            }
        }
    }
    
    func setDummyLine(index: Int) {
        
        let dt = aryDummyLineData[index]
        
        let PickupLat = "\(dt[0])"
        let PickupLng = "\(dt[1])"
        
        let DropOffLat = "\(aryDummyLineData.last![0])"
        let DropOffLon = "\(aryDummyLineData.last![1])"
        
        
        let dummyLatitude = Double(PickupLat)! - Double(DropOffLat)!
        let dummyLongitude = Double(PickupLng)! - Double(DropOffLon)!
        
        let waypointLatitude = Double(PickupLat)! - dummyLatitude
        let waypointSetLongitude = Double(PickupLng)! - dummyLongitude
        
        let originalLoc: String = "\(PickupLat),\(PickupLng)"
        let destiantionLoc: String = "\(DropOffLat),\(DropOffLon)"
        
        //        changePolyLine(origin: originalLoc, destination: destiantionLoc, waypoints: ["\(waypointLatitude),\(waypointSetLongitude)"], travelMode: nil, completionHandler: nil)
        
        DispatchQueue.global(qos: .background).async {
            self.getDirectionsChangedPolyLine(origin: originalLoc, destination: destiantionLoc, waypoints: ["\(waypointLatitude),\(waypointSetLongitude)"], travelMode: nil, completionHandler: nil)
        }
    }
    
    func updatePolyLineToMapFromDriverLocation() {
        
        var DoubleLat = Double()
        var DoubleLng = Double()
        
        if !SingletonClass.sharedInstance.driverLocation.isEmpty {
            
            if let lat = SingletonClass.sharedInstance.driverLocation["Location"]! as? [Double] {
                DoubleLat = lat[0]
                DoubleLng = lat[1]
            }
            else if let lat = SingletonClass.sharedInstance.driverLocation["Location"]! as? [String] {
                DoubleLat = Double(lat[0])!
                DoubleLng = Double(lat[1])!
            }
            
            //            DoubleLat = defaultLocation.coordinate.latitude
            //            DoubleLng = defaultLocation.coordinate.longitude
            
            if strPickUpLatitude != "" {
                
                let PickupLat = "\(DoubleLat)" // strPickUpLatitude // "\(DoubleLat)" // "\(pickUpLat)"
                let PickupLng = "\(DoubleLng)" // strPickUpLongitude // "\(DoubleLng)"  // pickupLng
                
                //        let DropOffLat = driverInfo.object(forKey: "PickupLat") as! String
                //        let DropOffLon = driverInfo.object(forKey: "PickupLng") as! String
                
                let DropOffLat = strPickUpLatitude // "23.008183" // strPickUpLatitude // "\(DoubleLat)" // dropOffLat
                let DropOffLon = strPickUpLongitude // "72.513819" // strPickUpLongitude // "\(DoubleLng)" // dropOfLng
                
                let dummyLatitude = Double(PickupLat)! - Double(DropOffLat)! // 23.008183, 72.513819
                let dummyLongitude = Double(PickupLng)! - Double(DropOffLon)!
                
                let waypointLatitude = Double(PickupLat)! - dummyLatitude
                let waypointSetLongitude = Double(PickupLng)! - dummyLongitude
                
                let originalLoc: String = "\(PickupLat),\(PickupLng)"
                let destiantionLoc: String = "\(DropOffLat),\(DropOffLon)"
                
                
                DispatchQueue.global(qos: .background).async {
                    self.getDirectionsChangedPolyLine(origin: originalLoc, destination: destiantionLoc, waypoints: ["\(waypointLatitude),\(waypointSetLongitude)"], travelMode: nil, completionHandler: nil)
                }
            }
        }
        //
    }
    
    //-------------------------------------------------------------
    // MARK: - Map Draw Line
    //-------------------------------------------------------------
    
    func setLineData() {
        
        let singletonData = SingletonClass.sharedInstance.dictIsFromPrevious
        
        txtCurrentLocation.text = singletonData.object(forKey: "PickupLocation") as? String
        txtDestinationLocation.text = singletonData.object(forKey: "DropoffLocation") as? String
        
        let DropOffLat = singletonData.object(forKey: "DropOffLat") as! Double
        let DropOffLon = singletonData.object(forKey: "DropOffLon") as! Double
        
        let PickupLat = singletonData.object(forKey: "PickupLat") as! Double
        let PickupLng = singletonData.object(forKey: "PickupLng")as! Double
        
        let dummyLatitude: Double = Double(PickupLat) - Double(DropOffLat)
        let dummyLongitude: Double = Double(PickupLng) - Double(DropOffLon)
        
        let waypointLatitude = PickupLat - dummyLatitude
        let waypointSetLongitude = PickupLng - dummyLongitude
        
        let originalLoc: String = "\(PickupLat),\(PickupLng)"
        let destiantionLoc: String = "\(DropOffLat),\(DropOffLon)"
        
        self.getDirectionsSeconMethod(origin: originalLoc, destination: destiantionLoc, waypoints: ["\(waypointLatitude),\(waypointSetLongitude)"], travelMode: nil, completionHandler: nil)
    }
    
    func clearMap() {
        
        self.mapView.clear()
        self.driverMarker = nil
//        self.mapView.delegate = self
        
        self.destinationLocationMarker.map = nil
        
//        if self.originCoordinate != nil { //RJ change
//            self.currentLocationMarker = GMSMarker(position: self.originCoordinate) // destinationCoordinate
//        }
        
        
//        self.currentLocationMarker.map = self.mapView
//        self.currentLocationMarker.snippet = locationTypeEntered.pickup.rawValue
//        self.currentLocationMarker.icon = UIImage(named: "iconMapPin")
        
        //        self.mapView.stopRendering()
        //        self.mapView = nil
    }
    
    // ------------------------------------------------------------
    func getDirectionsSeconMethod(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, completionHandler: ((_ status:   String, _ success: Bool) -> Void)?)
    {
        
        clearMap()
        
        MarkerCurrntLocation.isHidden = true
        
        UtilityClass.showACProgressHUD()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            
            if let originLocation = origin {
                if let destinationLocation = destination {
                    var directionsURLString = self.baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation + "&key=" + googlApiKey
                    //                    if let routeWaypoints = waypoints {
                    //                        directionsURLString += "&waypoints=optimize:true"
                    //
                    //                        for waypoint in routeWaypoints {
                    //                            directionsURLString += "|" + waypoint
                    //                        }
                    //                    }
                    
                    // .addingPercentEscapes(using: String.Encoding.utf8)!
                    
                    // print("directionsURLString: \(directionsURLString)")
                    
                    directionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                    
                    
                    // .addingPercentEscapes(using: String.Encoding.utf8)!
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
                                
                                self.locationManager.startUpdatingLocation()
                                
                                let originAddress = legs[0]["start_address"] as! String
                                let destinationAddress = legs[legs.count - 1]["end_address"] as! String
                                //                                if(SingletonClass.sharedInstance.isTripContinue)
                                //                                {
                                if self.driverMarker == nil {
                                    
                                    self.driverMarker = GMSMarker(position: self.originCoordinate) // self.originCoordinate
                                    self.driverMarker.map = self.mapView
                                    //                                    var vehicleID = Int()
                                    //                                    //                                    var vehicleID = Int()
                                    //                                    if let vID = SingletonClass.sharedInstance.dictCarInfo["VehicleModel"] as? Int {
                                    //
                                    //                                        if vID == 0 {
                                    //                                            vehicleID = 7
                                    //                                        }
                                    //                                        else {
                                    //                                            vehicleID = vID
                                    //                                        }
                                    //                                    }
                                    //                                    else if let sID = SingletonClass.sharedInstance.dictCarInfo["VehicleModel"] as? String
                                    //                                    {
                                    //
                                    //                                        if sID == "" {
                                    //                                            vehicleID = 7
                                    //                                        }
                                    //                                        else {
                                    //                                            vehicleID = Int(sID)!
                                    //                                        }
                                    //                                    }
                                    //
                                    self.driverMarker.icon = UIImage(named: "dummyCar")
                                    
                                    self.driverMarker.title = originAddress
                                }
                                
                                let destinationMarker = GMSMarker(position: self.destinationCoordinate)// self.destinationCoordinate  // self.destinationCoordinate
                                destinationMarker.map = self.mapView
                                destinationMarker.icon = UIImage.init(named: "iconMapPin")//GMSMarker.markerImage(with: UIColor.red)
                                destinationMarker.title = destinationAddress
                                
                                
                                var aryDistance = [String]()
                                var finalDistance = Double()
                                
                                
                                for i in 0..<legs.count
                                {
                                    let legsData = legs[i]
                                    let distanceKey = legsData["distance"] as! Dictionary<String, AnyObject>
                                    let distance = distanceKey["text"] as! String
                                    //                                    print(distance)
                                    
                                    let stringDistance = distance.components(separatedBy: " ")
                                    //                                    print(stringDistance)
                                    
                                    if stringDistance[1] == "m"
                                    {
                                        finalDistance += Double(stringDistance[0])! / 1000
                                    }
                                    else
                                    {
                                        finalDistance += Double(stringDistance[0].replacingOccurrences(of: ",", with: ""))!
                                    }
                                    
                                    aryDistance.append(distance)
                                }
                                
                                if finalDistance == 0 { }
                                else {
                                    self.sumOfFinalDistance = finalDistance
                                }
                                
                                let route = self.overviewPolyline["points"] as! String
                                let path: GMSPath = GMSPath(fromEncodedPath: route)!
                                let routePolyline = GMSPolyline(path: path)
                                routePolyline.map = self.mapView
                                routePolyline.strokeColor = themeYellowColor
                                routePolyline.strokeWidth = 3.0
                                
                                UtilityClass.hideACProgressHUD()
                                
                                //                                UtilityClass.showAlert("", message: "Line Drawn", vc: self)
                                
                                //  print("Line Drawn")
                                
                            }
                            else {
                                print("status")
                                UtilityClass.hideACProgressHUD()
                                //                                self.getDirectionsSeconMethod(origin: origin, destination: destination, waypoints: waypoints, travelMode: nil, completionHandler: nil)
                                print("OVER_QUERY_LIMIT Line number : \(#line) function name : \(#function)")
                            }
                        }
                        catch {
                            print("catch")
                            
                            
                            UtilityClass.hideACProgressHUD()
                            
                            UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get location data, please restart app") { (index, title) in
                            }
                            // completionHandler(status: "", success: false)
                        }
                    })
                }
                else {
                    print("Destination is nil.")
                    
                    UtilityClass.hideACProgressHUD()
                    
                    UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get location Destination, please restart app") { (index, title) in
                    }
                    //completionHandler(status: "Destination is nil.", success: false)
                }
            }
            else {
                print("Origin is nil")
                
                UtilityClass.hideACProgressHUD()
                
                UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get location Origin, please restart app") { (index, title) in
                }
                //completionHandler(status: "Origin is nil", success: false)
            }
        }
    }
    
    var demoPolyline = GMSPolyline()
    //    var demoPolylineOLD = GMSPolyline()
    
    func getDirectionsChangedPolyLine(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, completionHandler: ((_ status:   String, _ success: Bool) -> Void)?)
    {
        
        //        clearMap()
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
            if let originLocation = origin {
                if let destinationLocation = destination {
                    var directionsURLString = self.baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation
                    //                    if let routeWaypoints = waypoints {
                    //                        directionsURLString += "&waypoints=optimize:true"
                    //
                    //                        for waypoint in routeWaypoints {
                    //                            directionsURLString += "|" + waypoint
                    //                        }
                    //                    }
                    
                    directionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                    
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
                                self.locationManager.startUpdatingLocation()
                                
                                let route = self.overviewPolyline["points"] as! String
                                let path: GMSPath = GMSPath(fromEncodedPath: route)!
                                
                                
                                
                                //                                self.dummyOriginCordinateMarker = self.dummyDestinationCordinateMarker
                                //
                                //                                self.dummyDestinationCordinateMarker = nil
                                
                                //                                if self.dummyDestinationCordinateMarker == nil {
                                //                                    self.dummyDestinationCordinateMarker = GMSMarker(position: self.originCoordinate)
                                //                                }
                                //
                                //                                self.dummyDestinationCordinateMarker.map = self.mapView
                                //                                self.dummyDestinationCordinateMarker.icon = GMSMarker.markerImage(with: UIColor.green)
                                //                                self.dummyOriginCordinateMarker = self.dummyDestinationCordinateMarker
                                //
                                //                                self.dummyDestinationCordinateMarker.map = nil
                                //                                self.dummyDestinationCordinateMarker.map = self.mapView
                                ////
                                //
                                //
                                //                                UIView.animate(withDuration: 5, delay: 0, options: .curveLinear, animations: {
                                //
                                //                                    if self.dummyOriginCordinateMarker == nil {
                                //                                        self.dummyOriginCordinateMarker = GMSMarker(position: self.originCoordinate)
                                //                                        self.dummyOriginCordinateMarker.map = self.mapView
                                //                                        self.dummyOriginCordinateMarker.icon = GMSMarker.markerImage(with: UIColor.green)
                                ////                                        self.dummyDestinationCordinateMarker = self.dummyOriginCordinateMarker
                                ////
                                ////                                    self.dummyOriginCordinateMarker.map = nil
                                ////                                    self.dummyOriginCordinateMarker.map = self.mapView
                                //
                                //                                    }
                                //                                }, completion: nil)
                                //
                                //
                                
                                //                                    self.demoPolylineOLD = self.demoPolyline
                                //                                    self.demoPolylineOLD.strokeColor = themeYellowColor
                                //                                    self.demoPolylineOLD.strokeWidth = 3.0
                                //                                    self.demoPolylineOLD.map = self.mapView
                                //                                    self.demoPolyline.map = nil
                                //
                                //
                                //                                self.demoPolyline = GMSPolyline(path: path)
                                //                                self.demoPolyline.map = self.mapView
                                //                                self.demoPolyline.strokeColor = themeYellowColor
                                //                                self.demoPolyline.strokeWidth = 3.0
                                //                                self.demoPolylineOLD.map = nil
                                
                                //                                if self.driverMarker == nil {
                                //
                                //                                    self.driverMarker = GMSMarker(position: self.defaultLocation.coordinate) // self.originCoordinate
                                //                                    self.driverMarker.map = self.mapView
                                //                                    self.driverMarker.icon = UIImage(named: "dummyCar")
                                //
                                //                                }
                                
                                DispatchQueue.main.async {
                                    
                                    self.demoPolylineOLD = self.demoPolyline
                                    self.demoPolylineOLD.strokeColor = themeYellowColor
                                    self.demoPolylineOLD.strokeWidth = 3.0
                                    self.demoPolylineOLD.map = self.mapView
                                    self.demoPolyline.map = nil
                                    
                                    self.demoPolyline = GMSPolyline(path: path)
                                    self.demoPolyline.map = self.mapView
                                    self.demoPolyline.strokeColor = themeYellowColor
                                    self.demoPolyline.strokeWidth = 3.0
                                    self.demoPolylineOLD.map = nil
                                    
                                }
                                
                                
                                
                                //                                if GMSGeometryIsLocationOnPath(self.destinationCoordinate, path, true) {
                                //                                    print("GMSGeometryIsLocationOnPath")
                                //                                } else {
                                //                                    print("Else")
                                //                                }
                                
                                
                                //                                UIView.animate(withDuration: 3.0, delay: 0, options: .curveLinear, animations: {
                                //                                    self.demoPolyline = GMSPolyline(path: path)
                                //                                    self.demoPolyline.map = self.mapView
                                //                                    self.demoPolyline.strokeColor = themeYellowColor
                                //                                    self.demoPolyline.strokeWidth = 3.0
                                //                                    self.demoPolylineOLD.map = nil
                                //                                }, completion: { (status) in
                                //
                                //                                })
                                
                                
                                print("Line Drawn")
                                
                                
                                UtilityClass.hideACProgressHUD()
                            } else {
                                UtilityClass.hideACProgressHUD()
                                //                                self.getDirectionsChangedPolyLine(origin: origin, destination: destination, waypoints: waypoints, travelMode: travelMode, completionHandler: completionHandler)
                            }
                        } catch {
                            UtilityClass.hideACProgressHUD()
                            //                            self.getDirectionsChangedPolyLine(origin: origin, destination: destination, waypoints: waypoints, travelMode: travelMode, completionHandler: completionHandler)
                        }
                    })
                } else {
                    UtilityClass.hideACProgressHUD()
                    //                    self.getDirectionsChangedPolyLine(origin: origin, destination: destination, waypoints: waypoints, travelMode: travelMode, completionHandler: completionHandler)
                }
            } else {
                UtilityClass.hideACProgressHUD()
                //                self.getDirectionsChangedPolyLine(origin: origin, destination: destination, waypoints: waypoints, travelMode: travelMode, completionHandler: completionHandler)
            }
        }
    }
    
    
    
    func changePolyLine(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, completionHandler: ((_ status:   String, _ success: Bool) -> Void)?)
    {
        
        if let originLocation = origin {
            if let destinationLocation = destination {
                var directionsURLString = self.baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation + "&key=" + googlApiKey
                //                if let routeWaypoints = waypoints {
                //                    directionsURLString += "&waypoints=optimize:true"
                //
                //                    for waypoint in routeWaypoints {
                //                        directionsURLString += "|" + waypoint
                //                    }
                //                }
                //
                directionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                
                let directionsURL = NSURL(string: directionsURLString)
                DispatchQueue.main.async( execute: { () -> Void in
                    let directionsData = NSData(contentsOf: directionsURL! as URL)
                    do{
                        let dictionary: Dictionary<String, AnyObject> = try JSONSerialization.jsonObject(with: directionsData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
                        
                        let status = dictionary["status"] as! String
                        
                        if status == "OK" {
                            
                            self.locationManager.startUpdatingLocation()
                            
                            self.selectedRoute = (dictionary["routes"] as! Array<Dictionary<String, AnyObject>>)[0]
                            self.overviewPolyline = self.selectedRoute["overview_polyline"] as? Dictionary<String, AnyObject>
                            
                            let legs = self.selectedRoute["legs"] as! Array<Dictionary<String, AnyObject>>
                            
                            let startLocationDictionary = legs[0]["start_location"] as! Dictionary<String, AnyObject>
                            self.dummyOriginCordinate = CLLocationCoordinate2DMake(startLocationDictionary["lat"] as! Double, startLocationDictionary["lng"] as! Double)
                            
                            let endLocationDictionary = legs[legs.count - 1]["end_location"] as! Dictionary<String, AnyObject>
                            self.dummyDestinationCordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
                            
                            self.locationManager.startUpdatingLocation()
                            
                            if self.dummyOriginCordinateMarker == nil {
                                self.dummyOriginCordinateMarker = GMSMarker(position: self.dummyOriginCordinate)// self.destinationCoordinate  // self.destinationCoordinate
                                self.dummyOriginCordinateMarker.map = self.mapView
                                self.dummyOriginCordinateMarker.icon = UIImage.init(named: "iconMapPin")//GMSMarker.markerImage(with: UIColor.green)
                                //                            destinationMarker.title = destinationAddres
                                
                                //                                let route = self.overviewPolyline["points"] as! String
                                //                                let path: GMSPath = GMSPath(fromEncodedPath: route)!
                                //                                self.routePolyline = GMSPolyline(path: path)
                                //                                self.routePolyline.map = self.mapView
                                //                                self.routePolyline.strokeColor = UIColor.blue // themeYellowColor
                                //                                self.routePolyline.strokeWidth = 3.0
                                //                                self.demoPolylineOLD.map = nil
                            }
                            
                            if self.dummyDestinationCordinateMarker == nil {
                                self.dummyDestinationCordinateMarker = GMSMarker(position: self.dummyDestinationCordinate)// self.destinationCoordinate  // self.destinationCoordinate
                                self.dummyDestinationCordinateMarker.map = self.mapView
                                self.dummyDestinationCordinateMarker.icon = UIImage.init(named: "iconMapPin")//GMSMarker.markerImage(with: UIColor.blue)
                            }
                            
                            //                            if self.routePolyline.map == nil {
                            //                                self.demoPolylineOLD = self.routePolyline
                            //                                self.demoPolylineOLD.map = self.mapView
                            //                                self.demoPolylineOLD.strokeColor = themeYellowColor
                            //                                self.demoPolylineOLD.strokeWidth = 5.0
                            //                               self.routePolyline.map = nil
                            
                            
                            
                            //                                let route = self.overviewPolyline["points"] as! String
                            //                                let path: GMSPath = GMSPath(fromEncodedPath: route)!
                            //                                self.routePolyline = GMSPolyline(path: path)
                            //                                self.routePolyline.map = self.mapView
                            //                                self.routePolyline.strokeColor = UIColor.blue // themeYellowColor
                            //                                self.routePolyline.strokeWidth = 3.0
                            //                                self.demoPolylineOLD.map = nil
                            
                            
                            // ----------------------------------------------------------------------
                            //                            self.demoPolylineOLD = self.routePolyline
                            //                            self.demoPolylineOLD.map = self.mapView
                            //
                            //                            self.demoPolylineOLD.strokeColor = UIColor.green
                            //                            self.demoPolylineOLD.strokeWidth = 3.0
                            //                            self.routePolyline.map = nil
                            
                            let route = self.overviewPolyline["points"] as! String
                            let path: GMSPath = GMSPath(fromEncodedPath: route)!
                            
                            self.routePolyline = GMSPolyline(path: path)
                            self.routePolyline.map = self.mapView
                            self.routePolyline.strokeColor = UIColor.blue
                            self.routePolyline.strokeWidth = 3.0
                            self.demoPolylineOLD.map = nil
                            // ----------------------------------------------------------------------
                            
                            UtilityClass.hideACProgressHUD()
                            
                            print("Line Drawn")
                            
                        }
                        else {
                            print("status")
                            UtilityClass.hideACProgressHUD()
                            
                            //                            self.changePolyLine(origin: origin, destination: destination, waypoints: waypoints, travelMode: nil, completionHandler: nil)
                            print("OVER_QUERY_LIMIT Line number : \(#line) function name : \(#function)")
                        }
                    }
                    catch {
                        print("catch")
                        
                        
                        UtilityClass.hideACProgressHUD()
                        
                        UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get location data, please restart app") { (index, title) in
                            //                            self.changePolyLine(origin: origin, destination: destination, waypoints: waypoints, travelMode: nil, completionHandler: nil)
                        }
                        // completionHandler(status: "", success: false)
                    }
                })
            }
            else {
                print("Destination is nil.")
                
                UtilityClass.hideACProgressHUD()
                
                UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get location Destination, please restart app") { (index, title) in
                    //                    self.changePolyLine(origin: origin, destination: destination, waypoints: waypoints, travelMode: nil, completionHandler: nil)
                }
                //completionHandler(status: "Destination is nil.", success: false)
            }
        }
        else {
            print("Origin is nil")
            
            UtilityClass.hideACProgressHUD()
            UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get location Origin, please restart app") { (index, title) in
                //                self.changePolyLine(origin: origin, destination: destination, waypoints: waypoints, travelMode: nil, completionHandler: nil)
            }
            //completionHandler(status: "Origin is nil", success: false)
        }
    }
    
    func getDirectionsAcceptRequest(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, completionHandler: ((_ status:   String, _ success: Bool) -> Void)?)
    {
        
        clearMap()
        
        MarkerCurrntLocation.isHidden = true
        
        UtilityClass.showACProgressHUD()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            
            if let originLocation = origin {
                if let destinationLocation = destination {
                    var directionsURLString = self.baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation + "&key=" + googlApiKey
                    //                    if let routeWaypoints = waypoints {
                    //                        directionsURLString += "&waypoints=optimize:true"
                    //
                    //                        for waypoint in routeWaypoints {
                    //                            directionsURLString += "|" + waypoint
                    //                        }
                    //                    }
                    
                    // .addingPercentEscapes(using: String.Encoding.utf8)!
                    
                    
                    
                    directionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                    
                    print("directionsURLString: \(directionsURLString)")
                    // .addingPercentEscapes(using: String.Encoding.utf8)!
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
                                
                                self.locationManager.startUpdatingLocation()
                                
                                let originAddress = legs[0]["start_address"] as! String
                                let destinationAddress = legs[legs.count - 1]["end_address"] as! String
                                if(SingletonClass.sharedInstance.isTripContinue)
                                {
                                    if self.driverMarker == nil {
                                        
                                        self.driverMarker = GMSMarker(position: self.destinationCoordinate) // self.originCoordinate
                                        self.driverMarker.map = self.mapView
                                        self.driverMarker.icon = UIImage(named: "dummyCar")
                                        
                                        self.driverMarker.title = originAddress
                                    }
                                    
                                }
                                
                                let destinationMarker = GMSMarker(position: self.originCoordinate)// self.destinationCoordinate  // self.destinationCoordinate
                                destinationMarker.map = self.mapView
                                destinationMarker.icon = UIImage.init(named: "iconMapPin")//GMSMarker.markerImage(with: UIColor.red)
                                destinationMarker.title = destinationAddress
                                
                                
                                var aryDistance = [String]()
                                var finalDistance = Double()
                                
                                
                                for i in 0..<legs.count
                                {
                                    let legsData = legs[i]
                                    let distanceKey = legsData["distance"] as! Dictionary<String, AnyObject>
                                    let distance = distanceKey["text"] as! String
                                    //                                    print(distance)
                                    
                                    let stringDistance = distance.components(separatedBy: " ")
                                    //                                    print(stringDistance)
                                    
                                    if stringDistance[1] == "m"
                                    {
                                        finalDistance += Double(stringDistance[0])! / 1000
                                    }
                                    else
                                    {
                                        finalDistance += Double(stringDistance[0].replacingOccurrences(of: ",", with: ""))!
                                    }
                                    
                                    aryDistance.append(distance)
                                }
                                
                                if finalDistance == 0 {
                                }
                                else {
                                    self.sumOfFinalDistance = finalDistance
                                }
                                
                                let route = self.overviewPolyline["points"] as! String
                                let path: GMSPath = GMSPath(fromEncodedPath: route)!
                                let routePolyline = GMSPolyline(path: path)
                                routePolyline.map = self.mapView
                                routePolyline.strokeColor = themeYellowColor
                                routePolyline.strokeWidth = 3.0
                                
                                UtilityClass.hideACProgressHUD()
                                
                                //                                UtilityClass.showAlert("", message: "Line Drawn", vc: self)
                                
                                print("Line Drawn")
                                
                            }
                            else {
                                print("status")
                                UtilityClass.hideACProgressHUD()
                                //                                self.getDirectionsAcceptRequest(origin: origin, destination: destination, waypoints: waypoints, travelMode: nil, completionHandler: nil)
                                print("OVER_QUERY_LIMIT Line number : \(#line) function name : \(#function)")
                            }
                        }
                        catch {
                            print("catch")
                            
                            
                            UtilityClass.hideACProgressHUD()
                            
                            UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get location data, please restart app") { (index, title) in
                            }
                            // completionHandler(status: "", success: false)
                        }
                    })
                }
                else {
                    print("Destination is nil.")
                    
                    UtilityClass.hideACProgressHUD()
                    
                    UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get Destination location, please restart app") { (index, title) in
                    }
                    //completionHandler(status: "Destination is nil.", success: false)
                }
            }
            else {
                print("Origin is nil")
                
                UtilityClass.hideACProgressHUD()
                
                UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get  Origin location, please restart app") { (index, title) in
                }
                //completionHandler(status: "Origin is nil", success: false)
            }
        }
    }
    
    func setDirectionLineOnMapForSourceAndDestinationShow(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, completionHandler: ((_ status:   String, _ success: Bool) -> Void)?)
    {
        //        clearMap()
        //        UtilityClass.showACProgressHUD()
        //
        //        self.routePolyline.map = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            if let originLocation = origin {
                if let destinationLocation = destination {
                    var directionsURLString = self.baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation  // getGoogleApiKey(functionName: "\(#function)", URL: "", LineNumber: "\(#line)") // + "&waypoints=optimize:true|"
                    if let routeWaypoints = waypoints {
                        directionsURLString += "&waypoints=optimize:true"
                        
                        for waypoint in routeWaypoints {
                            directionsURLString += "|" + waypoint
                        }
                        
                        directionsURLString += "&sensor=true"
                    }
                    directionsURLString += "&key=" + googlPlacesApiKey
                    
                    directionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                    
                    let directionsURL = NSURL(string: directionsURLString)
                    
                    print ("directionsURLString: \(directionsURLString)")
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
                                
                                if legs.count == 2 {
                                    DispatchQueue.main.async {
                                        let endLocationDictionary = legs[0]["end_location"] as! Dictionary<String, AnyObject>
                                        let tempThirdPoint = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
                                        let tempThirdPointMarker = GMSMarker(position: tempThirdPoint) // destinationCoordinate
                                        tempThirdPointMarker.map = self.mapView
                                        tempThirdPointMarker.snippet = legs[0]["end_address"] as? String
                                        tempThirdPointMarker.icon = UIImage(named: "iconMapPin")
                                    }
                                    
                                }
                                //                                if SingletonClass.sharedInstance.isTripContinue {
                                self.locationManager.startUpdatingLocation()
                                
                                
                                // Set currentLocationMarker
                                self.currentLocationMarker = GMSMarker(position: self.originCoordinate) // destinationCoordinate
                                self.currentLocationMarker.map = self.mapView
                                self.currentLocationMarker.snippet = self.txtCurrentLocation.text
                                self.currentLocationMarker.icon = UIImage(named: "iconMapPin")
                                //                                self.currentLocationMarker.isDraggable = true
                                
                                // Set destinationLocationMarker
                                self.destinationLocationMarker = GMSMarker(position: self.destinationCoordinate) // originCoordinate
                                self.destinationLocationMarker.map = self.mapView
                                self.destinationLocationMarker.snippet = legs[legs.count - 1]["end_address"] as? String
                                self.destinationLocationMarker.icon = UIImage(named: "iconMapPin")
                                
                                //                                     }
                                
                                let route = self.overviewPolyline["points"] as! String
                                let path: GMSPath = GMSPath(fromEncodedPath: route)!
                                self.routePolyline = GMSPolyline(path: path)
                                self.routePolyline.map = self.mapView
                                self.routePolyline.strokeColor = themeYellowColor
                                self.routePolyline.strokeWidth = 3.0
                                
                                
                                UtilityClass.hideACProgressHUD()
                                
                                print("Line Drawn")
                                
                            }
                            else {
                                print("status")
                                //completionHandler(status: status, success: false)
                                UtilityClass.hideACProgressHUD()
                                
                                //                                self.setDirectionLineOnMapForSourceAndDestinationShow(origin: origin, destination: destination, waypoints: waypoints, travelMode: nil, completionHandler: nil)
                                print("OVER_QUERY_LIMIT Line number : \(#line) function name : \(#function)")
                            }
                        }
                        catch {
                            print("catch")
                            
                            
                            UtilityClass.hideACProgressHUD()
                            
                            UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get location data, please restart app") { (index, title) in
                            }
                            // completionHandler(status: "", success: false)
                        }
                    })
                }
                else {
                    print("Destination is nil.")
                    
                    UtilityClass.hideACProgressHUD()
                    
                    UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get Destination location, please restart app") { (index, title) in
                    }
                    //completionHandler(status: "Destination is nil.", success: false)
                }
            }
            else {
                print("Origin is nil")
                
                UtilityClass.hideACProgressHUD()
                
                UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get  Origin location, please restart app") { (index, title) in
                }
                //completionHandler(status: "Origin is nil", success: false)
            }
        }
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Webservice Current Booking Methods
    //-------------------------------------------------------------
    
    var dictCurrentBookingInfoData = NSDictionary()
    var dictCurrentDriverInfoData = NSDictionary()
    var aryCurrentBookingData = NSMutableArray()
    var checkBookingType = String()
    
    var bookingIDNow = String()
    var advanceBookingID = String()
    var passengerId = String()
    
    var strBookingType = String()
    
    
    
    
    
    
    func webserviceOfCurrentBooking() {
        
        if let Token = UserDefaults.standard.object(forKey: "Token") as? String {
            SingletonClass.sharedInstance.deviceToken = Token
            print("SingletonClass.sharedInstance.deviceToken : \(SingletonClass.sharedInstance.deviceToken)")
        }
        
        let param = SingletonClass.sharedInstance.strPassengerID + "/" + SingletonClass.sharedInstance.deviceToken
        
        webserviceForCurrentTrip(param as AnyObject) { (result, status) in
            
            if (status) {
                // print(result)
                
                self.clearMap()
                
                let resultData = (result as! NSDictionary)
                
                SingletonClass.sharedInstance.passengerRating = resultData.object(forKey: "rating") as! String
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "rating"), object: nil)
                self.aryCurrentBookingData.removeAllObjects()
                self.aryCurrentBookingData.add(resultData)
                self.aryRequestAcceptedData = self.aryCurrentBookingData.mutableCopy() as? NSMutableArray ?? []
                
                let bookingType = (self.aryCurrentBookingData.object(at: 0) as! NSDictionary).object(forKey: "BookingType") as! String
                self.strBookingType = bookingType
                if bookingType != "" {
                    
//                    self.timerToUpdatePassengerlocation?.invalidate()
//                    self.timerToUpdatePassengerlocation = nil

//                    self.MarkerCurrntLocation.isHidden = true
                    
                    if bookingType == "BookNow" {
                        
                        self.dictCurrentBookingInfoData = ((resultData).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
                        
                        self.TempBookingInfoDict = self.dictCurrentDriverInfoData as? [String:Any] ?? [:]
                        let statusOfRequest = self.dictCurrentBookingInfoData.object(forKey: "Status") as! String
                        
                        self.strBookingType = bookingType
                        
                        if statusOfRequest == "accepted" {
                            
                            self.bookingIDNow = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.passengerId = SingletonClass.sharedInstance.strPassengerID
                            SingletonClass.sharedInstance.bookingId = self.bookingIDNow
                            
                            self.bookingTypeIsBookNowAndAccepted()
                            
                        }
                        else if statusOfRequest == "traveling" {
                            self.bookingIDNow = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.passengerId = SingletonClass.sharedInstance.strPassengerID
                            SingletonClass.sharedInstance.bookingId = self.bookingIDNow
                            
                            SingletonClass.sharedInstance.isTripContinue = true
                            
                            self.bookingTypeIsBookNowAndTraveling()
                        }
                        
                    }
                    else if bookingType == "BookLater" {
                        
                        self.dictCurrentBookingInfoData = ((resultData).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
                        let statusOfRequest = self.dictCurrentBookingInfoData.object(forKey: "Status") as! String
                        self.TempBookingInfoDict = self.dictCurrentDriverInfoData as? [String:Any] ?? [:]

                        self.strBookingType = bookingType
                        
                        if statusOfRequest == "accepted" {
                            
                            self.bookingIDNow = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.passengerId = SingletonClass.sharedInstance.strPassengerID
                            SingletonClass.sharedInstance.bookingId = self.bookingIDNow
                            
                            self.bookingTypeIsBookNowAndAccepted()
                            
                        }
                        else if statusOfRequest == "traveling" {
                            self.bookingIDNow = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.passengerId = SingletonClass.sharedInstance.strPassengerID
                            SingletonClass.sharedInstance.bookingId = self.bookingIDNow
                            
                            SingletonClass.sharedInstance.isTripContinue = true
                            
                            self.bookingTypeIsBookNowAndTraveling()
                        }
                    }
                    
                    NotificationCenter.default.post(name: NotificationForAddNewBooingOnSideMenu, object: nil)
                    
                }
            }
            else {
                
                let resultData = (result as! NSDictionary)
                
                SingletonClass.sharedInstance.passengerRating = resultData.object(forKey: "rating") as! String
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "rating"), object: nil)
                
            }
        }
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Update droplocation
    //-------------------------------------------------------------
    
    func webserviceForUpdateDestinationAfterStartTrip(dropLocation : String, lat : String , lng : String, dropLocation2 : String, lat2 : String , lng2 : String) {
        
        let DriverInfo = ((self.aryRequestAcceptedData.object(at: 0) as! NSDictionary).object(forKey: "DriverInfo") as! NSArray).object(at: 0) as! NSDictionary
        let bookingInfo = ((self.aryRequestAcceptedData.object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary

            
            var dictParam = [String:Any]()
                    
            dictParam["DropoffLocation"] = dropLocation
            dictParam["PassengerId"] = bookingInfo.object(forKey: "PassengerId")
            dictParam["DriverId"] = DriverInfo.object(forKey: "Id")
            dictParam["BookingId"] = bookingIDNow == "" ? SingletonClass.sharedInstance.bookingId : bookingIDNow
            dictParam["DropOffLat"] = lat
            dictParam["DropOffLon"] = lng
            dictParam["BookingType"] = strBookingType
            dictParam["DropoffLocation2"] = dropLocation2
            dictParam["DropOffLat2"] = lat2
            dictParam["DropOffLon2"] = lng2
        
        
            webserviceForUpdateDropoffLocation(dictParam as AnyObject) { (result, status) in
                
                print(#function, result)
                
                if status {
                    if let dictResult = result as? [String:Any] {
                        
                        if let message = dictResult["message"] as? String {
                            let alert = UIAlertController(title: appName, message: message, preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                                self.webserviceOfCurrentBooking()
                            }
                            alert.addAction(ok)
                            print("\n \(#line) \(#function) \n")
                            UIApplication.shared.delegate?.window??.rootViewController?.present(alert, animated: true, completion: nil)
                        }
                    }
                } else {
                    print("\n \(#line) \(#function) \n")
                    UtilityClass.showAlertOfAPIResponse(param: result, vc: self)
                }
            }
//        }
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Running TripTrack
    //-------------------------------------------------------------
    
    @objc func webserviceOfRunningTripTrack() {
        
        
        webserviceForTrackRunningTrip(SingletonClass.sharedInstance.bookingId as AnyObject) { (result, status) in
            
            if (status) {
                // print(result)
                
                self.clearMap()
                
                let resultData = (result as! NSDictionary)
                
                //                SingletonClass.sharedInstance.passengerRating = resultData.object(forKey: "rating") as! String
                //                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "rating"), object: nil)
                self.aryCurrentBookingData.removeAllObjects()
                self.aryCurrentBookingData.add(resultData)
                self.aryRequestAcceptedData = self.aryCurrentBookingData.mutableCopy() as? NSMutableArray ?? []
                
                let bookingType = (self.aryCurrentBookingData.object(at: 0) as! NSDictionary).object(forKey: "BookingType") as! String
                
                if bookingType != "" {
                    
                    self.MarkerCurrntLocation.isHidden = true
                    
                    if bookingType == "BookNow" {
                        
                        self.dictCurrentBookingInfoData = ((resultData).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
                        let statusOfRequest = self.dictCurrentBookingInfoData.object(forKey: "Status") as! String
                        
                        self.strBookingType = bookingType
                        
                        if statusOfRequest == "accepted" {
                            
                            self.bookingIDNow = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.passengerId = SingletonClass.sharedInstance.strPassengerID
                            SingletonClass.sharedInstance.bookingId = self.bookingIDNow
                            
                            self.bookingTypeIsBookNowAndAccepted()
                            
                        }
                        else if statusOfRequest == "traveling" {
                            self.bookingIDNow = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.passengerId = SingletonClass.sharedInstance.strPassengerID
                            SingletonClass.sharedInstance.bookingId = self.bookingIDNow
                            
                            SingletonClass.sharedInstance.isTripContinue = true
                            
                            self.bookingTypeIsBookNowAndTraveling()
                        }
                        
                    }
                    else if bookingType == "BookLater" {
                        
                        self.dictCurrentBookingInfoData = ((resultData).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
                        let statusOfRequest = self.dictCurrentBookingInfoData.object(forKey: "Status") as! String
                        
                        self.strBookingType = bookingType
                        
                        if statusOfRequest == "accepted" {
                            
                            self.bookingIDNow = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.passengerId = SingletonClass.sharedInstance.strPassengerID
                            SingletonClass.sharedInstance.bookingId = self.bookingIDNow
                            
                            self.bookingTypeIsBookNowAndAccepted()
                            
                        }
                        else if statusOfRequest == "traveling" {
                            self.bookingIDNow = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.passengerId = SingletonClass.sharedInstance.strPassengerID
                            SingletonClass.sharedInstance.bookingId = self.bookingIDNow
                            
                            SingletonClass.sharedInstance.isTripContinue = true
                            
                            self.bookingTypeIsBookNowAndTraveling()
                        }
                    }
                }
            }
            else {
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                let OK = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
                alert.addAction(OK)
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
    // ----------------------------------------------------------------------
    
    // ----------------------------------------------------------------------
    // Book Now Accept Request
    // ----------------------------------------------------------------------
    func bookingTypeIsBookNowAndAccepted() {
        
        
        if let vehicleModelId = (((aryCurrentBookingData.object(at: 0) as? NSDictionary)?.object(forKey: "CarInfo") as? NSArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "VehicleModel") as? String {
            
            for i in 0..<self.arrTotalNumberOfCars.count {
                
                let indexOfCar = self.arrTotalNumberOfCars.object(at: i) as! NSDictionary
                if vehicleModelId == indexOfCar.object(forKey: "Id") as! String {
                    strSelectedCarMarkerIcon = "dummyCar"//markertIconName(carType: indexOfCar.object(forKey: "Name") as! String)
                }
            }
        }
        
        //        SingletonClass.sharedInstance.isTripContinue = true
        self.DriverInfoAndSetToMap(driverData: NSArray(array: aryCurrentBookingData))
        
    }
    
    func bookingTypeIsBookNowAndTraveling() {
        
        //        clearMap()
        
        if let vehicleModelId = (((aryCurrentBookingData.object(at: 0) as! NSDictionary).object(forKey: "CarInfo") as! NSArray).object(at: 0) as! NSDictionary).object(forKey: "VehicleModel") as? String {
            
            for i in 0..<self.arrTotalNumberOfCars.count {
                
                let indexOfCar = self.arrTotalNumberOfCars.object(at: i) as! NSDictionary
                if vehicleModelId == indexOfCar.object(forKey: "Id") as! String {
                    strSelectedCarMarkerIcon = "dummyCar"//markertIconName(carType: indexOfCar.object(forKey: "Name") as! String)
                }
            }
        }
        self.methodAfterStartTrip(tripData: NSArray(array: aryCurrentBookingData))
    }
    
    func markertIconName(carType: String) -> String {
        
        switch carType {
        //        case "First Class":
        //            return "iconFirstClass"
        //        case "Business Class":
        //            return "iconBusinessClass"
        //        case "Economy":
        //            return "iconEconomy"
        //        case "Taxi":
        //            return "iconTaxi"
        //        case "LUX-VAN":
        //            return "iconLuxVan"
        //        case "Disability":
        //            return "iconDisability"
        default:
            return "dummyCar"
        }
    }
    
    func markerCarIconName(modelId: Int) -> String {
        
        var CarModel = String()
        
        switch modelId {
        case 1:
            CarModel = "imgBusinessClass"
            return CarModel
        case 2:
            CarModel = "imgMIni"
            return CarModel
        case 3:
            CarModel = "imgVan"
            return CarModel
        case 4:
            CarModel = "imgNano"
            return CarModel
        case 5:
            CarModel = "imgTukTuk"
            return CarModel
        case 6:
            CarModel = "imgBreakdown"
            return CarModel
        default:
            CarModel = "imgTaxi"
            return CarModel
        }
    }
    
    func sortCarListFirstTime() {
        
        let sortedArray = (aryTempOnlineCars as NSArray).sortedArray(using: [NSSortDescriptor(key: "Sort", ascending: true)]) as! [[String:AnyObject]]
        arrNumberOfOnlineCars = NSMutableArray(array: sortedArray)
        self.collectionViewCars.reloadData()
    }
    
    //-------------------------------------------------------------
    // MARK: - ARCar Movement Delegate Method
    //-------------------------------------------------------------
    func ARCarMovementMoved(_ Marker: GMSMarker) {
        driverMarker = Marker
        driverMarker.map = mapView
    }
    
    var destinationCordinate: CLLocationCoordinate2D!
}


// Delegates to handle events for the location manager.
extension HomeViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        //        print("Location: \(location)")
        
        defaultLocation = location
        
        SingletonClass.sharedInstance.currentLatitude = "\(location.coordinate.latitude)"
        SingletonClass.sharedInstance.currentLongitude = "\(location.coordinate.longitude)"
        
        if(SingletonClass.sharedInstance.isFirstTimeDidupdateLocation)
        {
            SingletonClass.sharedInstance.isFirstTimeDidupdateLocation = false
        }
        
        if SingletonClass.sharedInstance.isTripContinue {
            let currentCordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            
            if(destinationCordinate == nil)
            {
                destinationCordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            }
            
            if driverMarker == nil {
                driverMarker = GMSMarker(position: destinationCordinate)
                
//                var vehicleID = Int()
                //                                    var vehicleID = Int()
                if SingletonClass.sharedInstance.dictCarInfo.count != 0 {
//                    if let vID = SingletonClass.sharedInstance.dictCarInfo["VehicleModel"] as? Int {
//
//                        if vID == 0 {
//                            vehicleID = 7
//                        }
//                        else {
//                            vehicleID = vID
//                        }
//                    }
//                    else if let sID = SingletonClass.sharedInstance.dictCarInfo["VehicleModel"] as? String {
//
//                        if sID == "" {
//                            vehicleID = 7
//                        }
//                        else {
//                            vehicleID = Int(sID)!
//                        }
//                    }
//                    self.driverMarker.icon = UIImage(named: "dummyCar")
                    
//                } else {
                    driverMarker.icon = UIImage(named: "dummyCar")
                }
                
                driverMarker.map = mapView
            }
//                        self.moveMent.ARCarMovement(marker: driverMarker, oldCoordinate: destinationCordinate, newCoordinate: currentCordinate, mapView: mapView, bearing: Float(SingletonClass.sharedInstance.floatBearing))
            destinationCordinate = currentCordinate
            self.MarkerCurrntLocation.isHidden = true
        }
        
//        if mapView.isHidden
//        {
//            self.getPlaceFromLatLong()
//            self.socketMethods()
            
//            mapView.delegate = self
            
//            _ = CLLocationCoordinate2D(latitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude)
//            MarkerCurrntLocation.isHidden = false
//            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,longitude: location.coordinate.longitude, zoom: 17)
//            mapView.animate(to: camera)
//        }
        
//        let latitude: CLLocationDegrees = (location.coordinate.latitude)
//        let longitude: CLLocationDegrees = (location.coordinate.longitude)
//
//        let locations = CLLocation(latitude: latitude, longitude: longitude) //changed!!!
//        CLGeocoder().reverseGeocodeLocation(locations, completionHandler: {(placemarks, error) -> Void in
//            if error != nil {
//                return
//            }else if let _ = placemarks?.first?.country,
//                     let city = (placemarks?.first?.addressDictionary as! [String : AnyObject])["City"] {
//
//                SingletonClass.sharedInstance.strCurrentCity = city as! String
//            }
//            else {
//            }
//        })
        //        updatePolyLineToMapFromDriverLocation()
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        // Display the map using the default location.
        //            mapView.isHidden = true
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways:
            //            mapView.isHidden = false
            locationManager.startUpdatingLocation()
            
        case .authorizedWhenInUse:
            //            mapView.isHidden = true // false
            locationManager.startUpdatingLocation()
            
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        return touch.view == gestureRecognizer.view
    }
}

extension UILabel {
    func setSizeFont (sizeFont: Double) {
        self.font =  UIFont(name: self.font.fontName, size: CGFloat(sizeFont))!
        self.sizeToFit()
    }
}

// MARK: - Delegate For Selection Driver
extension HomeViewController : SendBackSelectedDriverDelegate {
    func didSelectDriver(_ dictSelectedDriver: [String : AnyObject], isBookNow: Bool) {
        self.dictSelectedDriver = dictSelectedDriver
        if(isBookNow)
        {
            self.btnBookNow(UIButton())
        }
        else
        {
            self.btnBookLater(UIButton())
        }
    }
}
