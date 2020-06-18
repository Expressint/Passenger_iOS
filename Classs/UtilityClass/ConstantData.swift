//
//  ConstantData.swift
//  TickTok User
//
//  Created by Excellent Webworld on 28/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import Foundation

let themeYellowColor: UIColor =  UIColor.init(hex: "005f99")//"ef4036")
let themeButtonColor: UIColor =  UIColor.init(hex: "002e44")//"ef4036")
let themeBlackColor: UIColor =  UIColor.init(hex: "231f20")
let themeRedColor: UIColor = UIColor.init(hex: "EF4036")
//    UIColor.init(red: 255/255, green: 163/255, blue: 0, alpha: 1.0)
let themeGrayColor: UIColor = UIColor.init(red: 114/255, green: 114/255, blue: 114/255, alpha: 1.0)
//let ThemeYellowColor : UIColor = UIColor.init(hex: "ffa300")
let themeGrayBGColor : UIColor = UIColor.init(hex: "DDDDDD")
let themeGrayTextColor : UIColor = UIColor.init(hex: "7A7A7C")
let currencySign = "TZS"
let appName = "AllOut"
let helpLineNumber = "+255777115054"//"0772506506"
let googleAnalyticsTrackId = "UA-122360832-1"

let AppRegularFont:String = "ProximaNova-Regular"
let AppBoldFont:String = "ProximaNova-Bold"
let AppSemiboldFont:String = "ProximaNova-Semibold"
let dictanceType : String = " "
let windowHeight: CGFloat = CGFloat(UIScreen.main.bounds.size.height)
let screenHeightDeveloper : Double = 568
let screenWidthDeveloper : Double = 320

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


struct WebserviceURLs {
    static let kBaseURL                                  = "http://3.6.200.100/Passenger_Api/" // "http://3.6.224.0/Passenger_Api/" //"https://www.tantaxitanzania.com/Passenger_Api/" // "http://54.169.67.226/web/Passenger_Api/" // "https://pickngolk.info/web/Passenger_Api/" "http://54.169.67.226/web/Passenger_Api/" //
    static let kDriverRegister                          = "Register"
    static let kDriverLogin                             = "Login"
    static let kChangePassword                          = "ChangePassword"
    static let kSocialLogin                             = "SocialLogin"
    static let kUpdateProfile                           = "UpdateProfile"
    static let kForgotPassword                          = "ForgotPassword"
    static let kGetCarList                              = "GetCarClass"
    static let kMakeBookingRequest                      = "SubmitBookingRequest"
    static let kAdvancedBooking                         = "AdvancedBooking"
    static let kDriver                                  = "Driver"
    static let kBookingHistory                          = "BookingHistory"
    
    static let kPastBooking                             = "PastBooking"
    static let kGetEstimateFare                         = "GetEstimateFare"
    static let kImageBaseURL                            = "http://3.6.200.100/" // "http://3.6.224.0/"//"https://www.tantaxitanzania.com/" // "https://pickngolk.info/web/" "http://54.169.67.226/web/" //
    static let kFeedbackList                            = "FeedbackList/"
    static let kCardsList                               = "Cards/"
    static let kPackageBookingHistory                   = "PackageBookingHistory"
    static let kBookPackage                             = "BookPackage"
    static let kCurrentBooking                          = "CurrentBooking/"
    static let kAddNewCard                              = "AddNewCard"
    static let kAddMoney                                = "AddMoney"
    static let kTransactionHistory                      = "TransactionHistory/"
    static let kSendMoney                               = "SendMoney"
    static let kQRCodeDetails                           = "QRCodeDetails"
    static let kRemoveCard                              = "RemoveCard/"
    static let kTickpay                                 = "Tickpay"
    static let kAddAddress                              = "AddAddress"
    static let kGetAddress                              = "GetAddress/"
    static let kRemoveAddress                           = "RemoveAddress/"
    static let kVarifyUser                              = "VarifyUser"
    static let kTickpayInvoice                          = "TickpayInvoice"
    static let kGetTickpayRate                          = "GetTickpayRate"
    static let kInit                                    = "Init/"
    
    static let kReviewRating                            = "ReviewRating"
    static let kGetTickpayApprovalStatus                = "GetTickpayApprovalStatus/"
    static let kTransferToBank                          = "TransferToBank"
    static let kUpdateBankAccountDetails                = "UpdateBankAccountDetails"
    static let kOtpForRegister                          = "OtpForRegister"
    static let kGetPackages                             = "Packages"
    static let kMissBokkingRequest                      = "BookingMissRequest"
    static let kTrackRunningTrip                        = "TrackRunningTrip/"
    

//    https://pickngolk.info/web/Passenger_Api/OtpForRegister
}



struct SocketData {
    
    static let kBaseURL                                     = "http://3.6.200.100:8080" // "http://3.6.224.0:8080" //"https://www.tantaxitanzania.com:8081"//"http://3.120.161.225:8080"
    // "http://54.255.222.125:8080/" // "https://pickngolk.info:8081" "http://54.169.67.226:8080" //
    static let kNearByDriverList                            = "NearByDriverListIOS"
    static let kUpdatePassengerLatLong                      = "UpdatePassengerLatLong"
    static let kAcceptBookingRequestNotification            = "AcceptBookingRequestNotification"
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
    
    static let kAcceptAdvancedBookingRequestNotification    = "AcceptAdvancedBookingRequestNotification"
    static let kRejectAdvancedBookingRequestNotification    = "RejectAdvancedBookingRequestNotification"
    static let kAdvancedBookingPickupPassengerNotification  = "AdvancedBookingPickupPassengerNotification"
    static let kAdvancedBookingTripHoldNotification         = "AdvancedBookingTripHoldNotification"
    static let kAdvancedBookingDetails                      = "AdvancedBookingDetails"
    static let kAdvancedBookingCancelTripByPassenger        = "AdvancedBookingCancelTripByPassenger"
    
    static let kInformPassengerForAdvancedTrip              = "InformPassengerForAdvancedTrip"
    static let kAcceptAdvancedBookingRequestNotify          = "AcceptAdvancedBookingRequestNotify"
    
    static let kAskForTipsToPassenger = "AskForTipsToPassenger"
    static let kAskForTipsToPassengerForBookLater = "AskForTipsToPassengerForBookLater"

    static let kReceiveTips = "ReceiveTips"
    static let kReceiveTipsForBookLater = "ReceiveTipsForBookLater"
}

struct SocketDataKeys {
    
    static let kBookingIdNow    = "BookingId"
}



struct SubmitBookingRequest {
// PassengerId,ModelId,PickupLocation,DropoffLocation,PickupLat,PickupLng,DropOffLat,DropOffLon
// PassengerId,ModelId,PickupLocation,DropoffLocation,PickupLat,PickupLng,DropOffLat,DropOffLon,PromoCode,Notes,PaymentType,CardId(If paymentType is card)
    
    
    static let kModelId                 = "ModelId"
    static let kPickupLocation          = "PickupLocation"
    static let kDropoffLocation         = "DropoffLocation"
    static let kPickupLat               = "PickupLat"
    static let kPickupLng               = "PickupLng"
    static let kDropOffLat              = "DropOffLat"
    static let kDropOffLon              = "DropOffLon"
    
    static let kPromoCode               = "PromoCode"
    static let kNotes                   = "Notes"
    static let kPaymentType             = "PaymentType"
    static let kCardId                  = "CardId"
    static let kSpecial                 = "Special"
    
    static let kShareRide               = "ShareRide"
    static let kNoOfPassenger           = "NoOfPassenger"
    
    
}

struct NotificationCenterName {
    
    // Define identifier
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
let OpenPaymentOption = NSNotification.Name("OpenPaymentOption")
let OpenWallet = NSNotification.Name("OpenWallet")
let OpenMyReceipt = NSNotification.Name("OpenMyReceipt")
let OpenFavourite = NSNotification.Name("OpenFavourite")
let OpenInviteFriend = NSNotification.Name("OpenInviteFriend")
let OpenSetting = NSNotification.Name("OpenSetting")
let OpenSupport = NSNotification.Name("OpenSupport")
let OpenHome = NSNotification.Name("OpenHome")

let UpdateProfileNotification =  NSNotification.Name("UpdateProfile")



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

