//
//  ConstantData.swift
//  TickTok User
//
//  Created by Excellent Webworld on 28/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import Foundation
let themeAppMainColor : UIColor =  UIColor.init(hex: "fcee21")//Sky Blue 3fa9f5 //"ef4036") // Yellow Color theme color
let themeYellowColor: UIColor =  UIColor.init(hex: "02a64d")//themeAppMainColor //UIColor.init(hex: "005f99")//"ef4036") /// Nav Color
let themeButtonColor: UIColor =  UIColor.init(hex: "000000")//"ef4036") //Blue "002e44" //Skyblue "3fa9f5"
let themeBlackColor: UIColor =  UIColor.init(hex: "000000")
let themeRedColor: UIColor = UIColor.init(hex: "BE212E")
//    UIColor.init(red: 255/255, green: 163/255, blue: 0, alpha: 1.0)
let themeGrayColor: UIColor = UIColor.init(red: 114/255, green: 114/255, blue: 114/255, alpha: 1.0)
//let ThemeYellowColor : UIColor = UIColor.init(hex: "ffa300")
let themeGrayBGColor : UIColor = UIColor.init(hex: "DDDDDD")
let themeGrayTextColor : UIColor = UIColor.init(hex: "7A7A7C")
let currencySign = "$" //"KSh"

let kIsUpdateAvailable : String = "IsUpdateAvailable"
let kIsUpdateMessage : String = "kIsUpdateMessage"

let appName = "" //Book A Ride"
let appURL = "itms-apps://itunes.apple.com/app/apple-store/id1541296701?mt=8"
let appURLAndroid = "https://play.google.com/store/apps/details?id=com.bookride.passenger"
let appURLiOS = "https://apps.apple.com/in/app/bookaridegy/id1541296701"
let kAPPUrlAndroid = "https://play.google.com/store/apps/details?id=com.bookride.driver"
let kAPPUrliOS = "https://apps.apple.com/in/app/bookaridegy-driver/id1541299485"

var app_PrivacyPolicy = "https://www.bookaridegy.com/privacy_policy"
var app_TermsAndCondition = "https://www.bookaridegy.com/terms_conditions"
var app_RefundPolicy = "https://www.bookaridegy.com/refund_policy"


var helpLineNumber = ""
var WhatsUpNumber = ""
var DispatchCall = ""
var DispatchName = ""
var DispatchId = ""

var msgNoCarsAvailable = ""
var msgNoCarsAvailable_Spanish = ""

var currentPricingModel = ""
var currentPricingModelSpanish = ""
var currentTripType = ""

var NotifyMessageForBookLater = ""
var NotifyMessageForBookLaterSpanish = ""

var freeWaitingTime = 300

let googleAnalyticsTrackId = "UA-122360832-1"
let supportURL = "https://www.tantaxitanzania.com/front/about"
let AppRegularFont:String = "ProximaNova-Regular"
let AppBoldFont:String = "ProximaNova-Bold"
let AppSemiboldFont:String = "ProximaNova-Semibold"
let dictanceType : String = " "
let windowHeight: CGFloat = CGFloat(UIScreen.main.bounds.size.height)
let screenHeightDeveloper : Double = 568
let screenWidthDeveloper : Double = 320
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
let bookingsStoryboard = UIStoryboard(name: "BookingScreen", bundle: nil)
let myBookingsStoryboard = UIStoryboard(name: "MyBookings", bundle: nil)
let InitialStoryboard = UIStoryboard(name: "Initial", bundle: nil)

/* App Font Names
 
 Family : Proxima Nova Font Name : ProximaNova-Extrabld
 Family : Proxima Nova Font Name : ProximaNova-Light
 Family : Proxima Nova Font Name : ProximaNova-Black
 Family : Proxima Nova Font Name : ProximaNova-Semibold
 Family : Proxima Nova Font Name : ProximaNova-RegularIt
 Family : Proxima Nova Font Name : ProximaNova-BoldIt
 Family : Proxima Nova Font Name : ProximaNova-Bold
 Family : Proxima Nova Font Name : ProximaNova-SemiboldIt
 Family : Proxima Nova Font Name : ProximaNova-Regular
 Family : Proxima Nova Font Name : ProximaNova-LightIt
 
 */




//func setLayoutForEnglishLanguage() {
//    UIView.appearance().semanticContentAttribute = .forceLeftToRight
//    UINavigationBar.appearance().semanticContentAttribute = .forceLeftToRight
//}
//func setLayoutForSwahilLanguage() {
//    UIView.appearance().semanticContentAttribute = .forceLeftToRight
//    UINavigationBar.appearance().semanticContentAttribute = .forceLeftToRight
//}

//let appCurrentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String

//Live: https://www.bookaridegy.com/Passenger_Api/
//Development: http://52.23.45.119/v2/
struct WebserviceURLs {
    static let kBaseImageURL                            = "https://www.bookaridegy.com/"
    static let kBasePaymentURL                          = "https://www.bookaridegy.com/"
    static let kBaseURL                                  = "https://www.bookaridegy.com/v3/Passenger_Api/"
    static let kDriverRegister                           = "Register"
    static let kDriverLogin                              = "Login"
    static let kChangePassword                           = "ChangePassword"
    static let kSocialLogin                              = "SocialLogin"
    static let kAppleSocialLogin                         = "AppleLogin"
    static let kUpdateProfile                            = "UpdateProfile"
    static let kForgotPassword                           = "ForgotPassword"
    static let kGetCarList                               = "GetCarClass"
    static let kMakeBookingRequest                      = "SubmitBookingRequest"
    static let kWaitingListRequest                      = "PassengerWaitingRequest"
    static let kAdvancedBooking                         = "AdvancedBooking"
    static let kCheckPromocode                          = "PromoCodeCheck"
    static let kGetPromoCodeList                        = "PromoCodeList"
    static let kDriver                                   = "Driver"
    static let kBookingHistory                          = "BookingHistory"
    static let kUpdateDropoffLocation                  = "UpdateDropoffLocation"
    static let kPastBooking                             = "PastBooking"
    static let kUpcomingBooking                         = "UpcomingBooking"
    static let kOngoingBooking                          = "OngoingBooking"
    static let kGetEstimateFare                         = "GetEstimateFare"
    static let kGetEstimateFareForBookLater            = "GetEstimateFareForBookLater"
    static let kRescheduleBooklater                    = "reschedule_booklater"
    static let kImageBaseURL                            = "http://3.83.58.5/"
    static let kFeedbackList                            = "FeedbackList/"
    static let kCardsList                               = "Cards/"
    static let kPackageBookingHistory                   = "PackageBookingHistory"
    static let kBookPackage                             = "BookPackage"
    static let kCurrentBooking                          = "CurrentBooking/"
    static let kAddNewCard                              = "AddNewCard"
    static let kChatHistory                             = "chat_history"
    static let kAddMoney                                = "AddMoney"
    static let kTransactionHistory                     = "TransactionHistory/"
    static let kSendMoney                               = "SendMoney"
    static let kQRCodeDetails                           = "QRCodeDetails"
    static let kRemoveCard                              = "RemoveCard/"
    static let kTickpay                                 = "Tickpay"
    static let kAddAddress                              = "AddAddress"
    static let kGetAddress                              = "GetAddress/"
    static let kDeleteAccount1                          = "DeleteAccount/"
    static let kEditAddress                             = "EditAddress/"
    static let kRemoveAddress                           = "RemoveAddress/"
    static let kVarifyUser                              = "VarifyUser"
    static let kTickpayInvoice                          = "TickpayInvoice"
    static let kGetTickpayRate                          = "GetTickpayRate"
    static let kInit                                     = "Init/"
    
    static let kReviewRating                            = "ReviewRating"
    static let kGetTickpayApprovalStatus                = "GetTickpayApprovalStatus/"
    static let kTransferToBank                          = "TransferToBank"
    static let kUpdateBankAccountDetails                = "UpdateBankAccountDetails"
    static let kOtpForRegister                          = "OtpForRegister"
    static let kGetPackages                             = "Packages"
    static let kMissBokkingRequest                      = "BookingMissRequest"
    static let kTrackRunningTrip                        = "TrackRunningTrip/"
    
    static let kPastDuesList                            = "PastDues"
    static let kPayPastDues                             = "PastDuesPayment"
    
    static let kGetDriverETA                            = "GetETA"
    static let kHelpOptions                             = "HelpOptions"
    static let kRentalModels                           = "RentalModel"
    static let kModelPackages                          = "RentalModePackages"
    static let kHelp                                    = "Help"
    
    //Tours
    static let kSubmitRentalBookingRequest           = "SubmitRentalBookingRequest"
    static let kRentalCurrentBooking                  = "RentalCurrentBooking"
    static let kRentalReviewRating                    = "RentalReviewRating"
    static let kRentalTripHistory                     = "RentalBookingHistory"
    static let AdvertisementList                      = "AdvertisementList"
    static let RecommendedHoursForRentalTrip         = "RecommendedHoursForRentalTrip"
    
    //    https://pickngolk.info/web/Passenger_Api/OtpForRegister
}


//Live: https://www.bookaridegy.com:8080
//Development: http://52.23.45.119:8080
struct SocketData {
    
    static let kBaseURL                                     = "https://www.bookaridegy.com:8080"
    static let kNearByDriverList                            = "NearByDriverListIOS"
    static let kUpdatePassengerLatLong                      = "UpdatePassengerLatLong"
    static let kAcceptBookingRequestNotification            = "AcceptBookingRequestNotification"
    static let kBookingDetailsDropoffs                      = "BookingDetailsDropoffs"
    static let kRejectBookingRequestNotification            = "RejectBookingRequestNotification"
    static let kPickupPassengerNotification                 = "PickupPassengerNotification"
    static let kBookingCompletedNotification                = "BookingDetails"
    static let kCancelTripByPassenger                       = "CancelTripByPassenger"
    static let kCancelTripByDriverNotficication             = "PassengerCancelTripNotification"
    static let kSendDriverLocationRequestByPassenger        = "DriverLocation"
    static let kReceiveDriverLocationToPassenger            = "GetDriverLocation"
    static let kReceiveHoldingNotificationToPassenger       = "TripHoldNotification"
    static let kSendRequestForGetEstimateFare               = "EstimateFare"
    static let kReceiveGetEstimateFare                      = "GetEstimateFare"
    static let kDriverArrived                               = "DriverArrived"
    static let kAcceptAdvancedBookingRequestNotification    = "AcceptAdvancedBookingRequestNotification"
    static let kRejectAdvancedBookingRequestNotification    = "RejectAdvancedBookingRequestNotification"
    static let kAdvancedBookingPickupPassengerNotification  = "AdvancedBookingPickupPassengerNotification"
    static let kAdvancedBookingTripHoldNotification         = "AdvancedBookingTripHoldNotification"
    static let kAdvancedBookingDetails                      = "AdvancedBookingDetails"
    static let kAdvancedBookingCancelTripByPassenger        = "AdvancedBookingCancelTripByPassenger"
    
    static let kInformPassengerForAdvancedTrip              = "InformPassengerForAdvancedTrip"
    static let kAcceptAdvancedBookingRequestNotify          = "AcceptAdvancedBookingRequestNotify"
    
    static let kAskForTipsToPassenger                       = "AskForTipsToPassenger"
    static let kAskForTipsToPassengerForBookLater           = "AskForTipsToPassengerForBookLater"
    
    static let kReceiveTips                                 = "ReceiveTips"
    static let kReceiveTipsForBookLater                     = "ReceiveTipsForBookLater"
    static let kGetDriverCurrentLatLong                     = "GetDriverCurrentLatLong"
    
    static let kGetDriverLocation                           = "GetDriverLocation"
    
    static let SOS = "SOS"
    static let sendMessage = "sendMessage"
    static let receiveMessage = "receive_message"
    
    static let starTyping = "start_typing"
    static let stopTyping = "stop_typing"
    static let DriverTyping = "is_typing"
    static let DriverStopTyping = "is_stop_typing"
    
    // Tours
    static let RejectRentalBookingRequest = "RejectRentalBookingRequestNotification"
    static let AcceptRentalBookingRequest = "AcceptRentalBookingRequestNotification"
    static let RentalDriverArrived = "RentalDriverArrived"
    static let PickupRentalPassengerNotification = "PickupRentalPassengerNotification"
    static let RentalTripCompleted = "RentalBookingDetails"
    static let CancelRentalTripByPassenger = "CancelRentalTripByPassenger"
    static let CancelRentalTripNotification = "PassengerCancelRentalTripNotification"
    static let RentalSOS = "RentalSOS"
}

struct SocketDataKeys {
    
    static let kBookingIdNow    = "BookingId"
    static let kCancelReasons   = "Reason"
    static let kUserType        = "UserType"
}

struct SubmitBookingRequest {
    static let kModelId                 = "ModelId"
    static let kPickupLocation          = "PickupLocation"
    static let kDropoffLocation         = "DropoffLocation"
    static let kDropoffLocation2        = "DropoffLocation2"
    static let kPickupLat               = "PickupLat"
    static let kPickupLng               = "PickupLng"
    static let kDropOffLat              = "DropOffLat"
    static let kDropOffLon              = "DropOffLon"
    static let kDropOffLat2             = "DropOffLat2"
    static let kDropOffLon2             = "DropOffLon2"
    static let kPromoCode               = "PromoCode"
    static let kNotes                   = "Notes"
    static let kPaymentType             = "PaymentType"
    static let kCardId                  = "CardId"
    static let kSpecial                 = "Special"
    static let kLanguage                = "language"
    static let kShareRide               = "ShareRide"
    static let kNoOfPassenger           = "NoOfPassenger"
}

struct NotificationCenterName {
    static let keyForOnGoing   = "keyForOnGoing"
    static let keyForUpComming = "keyForUpComming"
    static let keyForPastBooking = "keyForPastBooking"
}

struct PassengerDataKeys {
    static let kPassengerID = "PassengerId"
}

struct setAllDevices {
    static let allDevicesStatusBarHeight = 20
    static let allDevicesNavigationBarHeight = 44
    static let allDevicesNavigationBarTop = 20
}

struct setiPhoneX {
    
    static let iPhoneXStatusBarHeight = 44
    static let iPhoneXNavigationBarHeight = 40
    static let iPhoneXNavigationBarTop = 44
    
}

let NotificationKeyFroAllDriver =  NSNotification.Name("NotificationKeyFroAllDriver")
let NotificationBookNow = NSNotification.Name("NotificationBookNow")
let NotificationBookLater = NSNotification.Name("NotificationBookLater")
let NotificationTrackRunningTrip = NSNotification.Name("NotificationTrackRunningTrip")
let NotificationForBookingNewTrip = NSNotification.Name("NotificationForBookingNewTrip")
let NotificationForAddNewBooingOnSideMenu = NSNotification.Name("NotificationForAddNewBooingOnSideMenu")
let OpenEditProfile = NSNotification.Name("OpenEditProfile")
let OpenMyBooking = NSNotification.Name("OpenMyBooking")
let OpenHourlyBooking = NSNotification.Name("OpenHourlyBooking")
let OpenPaymentOption = NSNotification.Name("OpenPaymentOption")
let OpenWallet = NSNotification.Name("OpenWallet")
let OpenMyReceipt = NSNotification.Name("OpenMyReceipt")
let OpenFavourite = NSNotification.Name("OpenFavourite")
let OpenInviteFriend = NSNotification.Name("OpenInviteFriend")
let OpenSetting = NSNotification.Name("OpenSetting")
let OpenSupport = NSNotification.Name("OpenSupport")
let OpenHome = NSNotification.Name("OpenHome")
let OpenPastDues = NSNotification.Name("OpenPastDues")
let DeleteAccount = NSNotification.Name("DeleteAccount")
let UpdateProfileNotification =  NSNotification.Name("UpdateProfile")
let ReloadFavLocations = NSNotification.Name("ReloadFavLocations")
let openNPP = NSNotification.Name("openPP")
let openNTC = NSNotification.Name("openTC")
let openNRP = NSNotification.Name("openRP")
let openNAboutUs = NSNotification.Name("openAboutUs")
//let openChatForDispatcher1 = NSNotification.Name("openChatForDispatcher")
let GoToChatScreen = NSNotification.Name("GoToChatScreen")
let RequestForTaxiHourly = NSNotification.Name("RequestForTaxiHourly")


//let NotificationHotelReservation = NSNotification.Name("NotificationHotelReservation")
//let NotificationBookaTable = NSNotification.Name("NotificationBookaTable")
//let NotificationShopping = NSNotification.Name("NotificationShopping")

//struct iPhoneDevices {
//    
//    static func getiPhoneXDevice() -> String {
//        
//        var deviceName = String()
//        
//        if UIDevice().userInterfaceIdiom == .phone {
//            switch UIScreen.main.nativeBounds.height {
//            case 1136:
//                print("iPhone 5 or 5S or 5C")
//                return deviceName = "iPhone 5"
//                
//            case 1334:
//                print("iPhone 6/6S/7/8")
//                deviceName = "iPhone 6"
//                
//            case 2208:
//                print("iPhone 6+/6S+/7+/8+")
//                deviceName = "iPhone 6+"
//                
//            case 2436:
//                print("iPhone X")
//                deviceName = "iPhone X"
//                
//            default:
//                print("unknown")
//            }
//        }
//    }
//}
/*
 struct iPhoneDevices {
 
 let SCREEN_MAX_LENGTH = max(UIScreen.screenWidth, UIScreen.screenHeight)
 let SCREEN_MIN_LENGTH = min(UIScreen.screenWidth, UIScreen.screenHeight)
 
 let IS_IPHONE_4_OR_LESS = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH < 568.0
 let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 568.0
 let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 667.0
 let IS_IPHONE_6P = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 736.0
 let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad && SCREEN_MAX_LENGTH == 1024.0
 let IS_IPHONE_X = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 812.0
 
 }
 */


