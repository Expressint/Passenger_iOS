//
//  WebserviceSubClass.swift
//  TickTok User
//
//  Created by Excellent Webworld on 27/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import Alamofire

let DriverLogin = WebserviceURLs.kDriverLogin
let Registration =  WebserviceURLs.kDriverRegister
let SocialLogin = WebserviceURLs.kSocialLogin
let AppleSocialLogin = WebserviceURLs.kAppleSocialLogin
let ForgotPassword =  WebserviceURLs.kForgotPassword
let CarLists =  WebserviceURLs.kGetCarList
let MakeBookingRequest = WebserviceURLs.kMakeBookingRequest
let WaitingListRequest = WebserviceURLs.kWaitingListRequest
let bookLater = WebserviceURLs.kAdvancedBooking
let CheckPromocode = WebserviceURLs.kCheckPromocode
let GetPromoCodeList = WebserviceURLs.kGetPromoCodeList
let driverList = WebserviceURLs.kDriver
let BookingHistory = WebserviceURLs.kBookingHistory
let GetEstimateFare =  WebserviceURLs.kGetEstimateFare
let GetEstimateFareForBookLater =  WebserviceURLs.kGetEstimateFareForBookLater
let RescheduleBookLater =  WebserviceURLs.kRescheduleBooklater
let ChangePassword = WebserviceURLs.kChangePassword
let UpdateProfile = WebserviceURLs.kUpdateProfile
let PastBooking = WebserviceURLs.kPastBooking
let UpcomingBooking = WebserviceURLs.kUpcomingBooking
let OngoingBooking = WebserviceURLs.kOngoingBooking
let FeedbackList = WebserviceURLs.kFeedbackList
let cardsList = WebserviceURLs.kCardsList
let bookPackage = WebserviceURLs.kBookPackage
let packageHistory = WebserviceURLs.kPackageBookingHistory
let CurrentBooking = WebserviceURLs.kCurrentBooking
let AddNewCard = WebserviceURLs.kAddNewCard
let ChatHistory = WebserviceURLs.kChatHistory
let AddMoney = WebserviceURLs.kAddMoney
let TransactionHistory = WebserviceURLs.kTransactionHistory
let SendMoney = WebserviceURLs.kSendMoney
let QRCodeDetails = WebserviceURLs.kQRCodeDetails
let RemoveCard = WebserviceURLs.kRemoveCard
let Tickpay = WebserviceURLs.kTickpay
let AddAddress = WebserviceURLs.kAddAddress
let GetDriverETA = WebserviceURLs.kGetDriverETA
let GetAddress = WebserviceURLs.kGetAddress
let DeleteAccount1 = WebserviceURLs.kDeleteAccount1
let EditAddress = WebserviceURLs.kEditAddress
let RemoveAddress = WebserviceURLs.kRemoveAddress
let VarifyUser = WebserviceURLs.kVarifyUser
let TickpayInvoice = WebserviceURLs.kTickpayInvoice
let GetTickpayRate = WebserviceURLs.kGetTickpayRate
let Init = WebserviceURLs.kInit
let UpdateDropoffLocation = WebserviceURLs.kUpdateDropoffLocation
let GetPackages = WebserviceURLs.kGetPackages

let ReviewRating = WebserviceURLs.kReviewRating
let MissBookingRequest = WebserviceURLs.kMissBokkingRequest
let GetTickpayApprovalStatus = WebserviceURLs.kGetTickpayApprovalStatus
let TransferToBank = WebserviceURLs.kTransferToBank
let UpdateBankAccountDetails = WebserviceURLs.kUpdateBankAccountDetails

let OTPVerify = WebserviceURLs.kOtpForRegister

let TrackRunningTrip = WebserviceURLs.kTrackRunningTrip
let PastDuesList = WebserviceURLs.kPastDuesList
let PayPastDues = WebserviceURLs.kPayPastDues
let HelpOptions = WebserviceURLs.kHelpOptions
let RentalModels = WebserviceURLs.kRentalModels
let ModelPackages = WebserviceURLs.kModelPackages
let Help = WebserviceURLs.kHelp

// Rental
let RentalCurrentBooking = WebserviceURLs.kRentalCurrentBooking
let RentalReviewRating = WebserviceURLs.kRentalReviewRating
let RentalTripHistory = WebserviceURLs.kRentalTripHistory
let AdvertisementList = WebserviceURLs.AdvertisementList


let SubmitTourReq = WebserviceURLs.kSubmitRentalBookingRequest
//-------------------------------------------------------------
// MARK: - Webservice For Registration
//-------------------------------------------------------------

func webserviceForRegistrationForUser(_ dictParams: AnyObject, image1: UIImage, image2: UIImage, isRegister: Bool = false, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = Registration
    sendImage(dictParams as! [String : AnyObject], image1: image1, image2: image2, isRegister: isRegister, nsURL: url, completion: completion)
    
}

//-------------------------------------------------------------
// MARK: - Webservice For Driver Login
//-------------------------------------------------------------

func webserviceForDriverLogin(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = DriverLogin
    postData(dictParams, nsURL: url, completion: completion)
}



func webserviceForValidPromocode(_ dictParams: AnyObject,showHUD : Bool, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
//    https://www.tantaxitanzania.com/Passenger_Api/PromoCodeCheck
    let url = "PromoCodeCheck"
    postData(dictParams as AnyObject, nsURL: url, completion: completion)
}
//-------------------------------------------------------------
// MARK: - Webservice For Driver Login
//-------------------------------------------------------------

func webserviceForForgotPassword(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = ForgotPassword
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Car List
//-------------------------------------------------------------

func webserviceForCarList(completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = CarLists
    getData([] as AnyObject, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Request a Taxi
//-------------------------------------------------------------

func webserviceForTaxiRequest(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = MakeBookingRequest
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Waitin List
//-------------------------------------------------------------

func webserviceForWaitingListRequest(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = WaitingListRequest
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Book Later
//-------------------------------------------------------------

func webserviceForBookLater(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = bookLater
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Check Promocode
//-------------------------------------------------------------

func webserviceForCheckPromocode(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = CheckPromocode
    postData(dictParams, nsURL: url, completion: completion)
}
//-------------------------------------------------------------
// MARK: - Webservice For Promocode List
//-------------------------------------------------------------

func webserviceForPromoCodeList(completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = "\(GetPromoCodeList)/\(SingletonClass.sharedInstance.strPassengerID)"
    getData([String : AnyObject].self as AnyObject, nsURL: url, completion: completion)
}

func webserviceForAdvList(completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = "\(AdvertisementList)"
    getData([String : AnyObject].self as AnyObject, nsURL: url, completion: completion)
}
//-------------------------------------------------------------
// MARK: - Webservice For All Drivers List
//-------------------------------------------------------------

func webserviceForAllDriversList(completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = driverList
    getData([] as AnyObject, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Social Login
//-------------------------------------------------------------

func webserviceForSocialLogin(_ dictParams: AnyObject,image1: UIImage, showHUD : Bool, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = SocialLogin
    //    postData(dictParams, nsURL: url, showHUD: showHUD, completion: completion)
    sendImage(dictParams as! [String : AnyObject], image1: image1, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Apple Social Login
//-------------------------------------------------------------

func webserviceForAppleSocialLogin(_ dictParams: AnyObject,image1: UIImage,showHUD : Bool, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = AppleSocialLogin
    sendImage(dictParams as! [String : AnyObject], image1: image1, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Booking History
//-------------------------------------------------------------

func webserviceForBookingHistory(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = "\(BookingHistory)/\(dictParams)"
    getData(dictParams as AnyObject, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For PastBooking List
//-------------------------------------------------------------

func webserviceForPastBookingList(_ dictParams: AnyObject,PageNumber : AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = "\(PastBooking)/\(dictParams)/\(PageNumber)"
    getData(dictParams as AnyObject, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Upcoming Bookings List
//-------------------------------------------------------------

func webserviceForUpcomingBookingList(_ dictParams: AnyObject,PageNumber : AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = "\(UpcomingBooking)/\(dictParams)/\(PageNumber)"
    getData(dictParams as AnyObject, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For OnGoing Bookings List
//-------------------------------------------------------------

func webserviceForOngoingBookingList(_ dictParams: AnyObject,PageNumber : AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = "\(OngoingBooking)/\(dictParams)"    // /\(PageNumber)
    getData(dictParams as AnyObject, nsURL: url, completion: completion)
}



//-------------------------------------------------------------
// MARK: - Webservice For Feedback List
//-------------------------------------------------------------

func webserviceForFeedbackList(_ passengerID : AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = "\(FeedbackList)\(passengerID)"
    getData("" as AnyObject, nsURL: url, completion: completion)
}
//-------------------------------------------------------------
// MARK: - Webservice For Get Estimate Fare
//-------------------------------------------------------------

func webserviceForGetEstimateFare(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = GetEstimateFare
    estimateMethod(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Estiimate Fare For Book Later
//-------------------------------------------------------------

func webserviceForEstimateFareForbookLater(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = GetEstimateFareForBookLater
    postData(dictParams, nsURL: url, completion: completion)
}

func webserviceForRentalHistory(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = RentalTripHistory
    postData(dictParams, nsURL: url, completion: completion)
}

func webserviceForRscheduleBookLater(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = RescheduleBookLater
    postData(dictParams, nsURL: url, completion: completion)
}
//-------------------------------------------------------------
// MARK: - Webservice For Change Password
//-------------------------------------------------------------

func webserviceForChangePassword(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = ChangePassword
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Update Profile
//-------------------------------------------------------------

func webserviceForUpdateProfile(_ dictParams: AnyObject, image1: UIImage, image2: UIImage, isRegister: Bool = false, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = UpdateProfile
    sendImage(dictParams as! [String : AnyObject], image1: image1, image2: image2, isRegister: isRegister, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Current Trip List
//-------------------------------------------------------------

func webserviceForCurrentTrip(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = "\(CurrentBooking)/\(dictParams)"
    getData("" as AnyObject, nsURL: url, completion: completion)
}

func webserviceForRntalCurrentTrip(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url =  RentalCurrentBooking
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Previous due
//-------------------------------------------------------------

func webserviceForPastDuesList(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url =  PastDuesList 
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice to pay Previous due
//-------------------------------------------------------------

func webserviceToPayPastDue(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = PayPastDues
    postData(dictParams, nsURL: url, completion: completion)
}



//-------------------------------------------------------------
// MARK: - Webservice For Cards List
//-------------------------------------------------------------

func webserviceForCardList(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = "\(cardsList)/\(dictParams)"
    getData("" as AnyObject, nsURL: url, completion: completion)
}
//-------------------------------------------------------------
// MARK: - Webservice For Package History
//-------------------------------------------------------------

func webserviceForPackageHistory(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = "\(packageHistory)/\(dictParams)"
    getData("" as AnyObject, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Package Booking
//-------------------------------------------------------------

func webserviceForBookPackage(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = bookPackage //"\(bookPackage)\(dictParams)"
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Add Cards
//-------------------------------------------------------------

func webserviceForAddCards(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = AddNewCard
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Chat Histoy
//-------------------------------------------------------------

func webserviceForChatHistory(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = ChatHistory
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Add Money
//-------------------------------------------------------------

func webserviceForAddMoney(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = AddMoney
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Transaction History
//-------------------------------------------------------------

func webserviceForTransactionHistory(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = "\(TransactionHistory)/\(dictParams)"
    getData("" as AnyObject, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Send Money
//-------------------------------------------------------------

func webserviceForSendMoney(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = SendMoney
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Get QR Code Details
//-------------------------------------------------------------

func webserviceForGetQRCodeDetails(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = QRCodeDetails
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Remove Card
//-------------------------------------------------------------

func webserviceForRemoveCard(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = "\(RemoveCard)/\(dictParams)"
    getData("" as AnyObject, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For TickPay
//-------------------------------------------------------------

func webserviceForTickPay(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = Tickpay
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Add Address
//-------------------------------------------------------------

func webserviceForAddAddress(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = AddAddress
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Get Driver ETA
//-------------------------------------------------------------

func webserviceForGetDriverETA(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = GetDriverETA
    postData(dictParams, nsURL: url, completion: completion)
}


//-------------------------------------------------------------
// MARK: - Webservice For Get Address
//-------------------------------------------------------------

func webserviceForGetAddress(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = "\(GetAddress)/\(dictParams)"
    getData("" as AnyObject, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Get Address
//-------------------------------------------------------------

func webserviceForDeleteAccount(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = "\(DeleteAccount1)/\(dictParams)"
    getData("" as AnyObject, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Edit Address
//-------------------------------------------------------------

func webserviceForEditAddress(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = EditAddress
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Delete Address
//-------------------------------------------------------------

func webserviceForDeleteAddress(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = "\(RemoveAddress)/\(dictParams)"
    getData("" as AnyObject, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Varify Passenger
//-------------------------------------------------------------

func webserviceForVarifyPassenger(_ dictParams: [String:AnyObject], image1: UIImage, image2: UIImage, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = VarifyUser
//    sendImage(dictParams, image1: image1, nsURL: url, completion: completion)
    postTwoImageMethod(dictParams, image1: image1, image2: image2, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Send Invoice
//-------------------------------------------------------------

func webserviceForSendInvoice(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = TickpayInvoice
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Get TickPay Rate
//-------------------------------------------------------------

func webserviceForGetTickPayRate(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = "\(GetTickpayRate)/\(dictParams)"
    getData("" as AnyObject, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For App Setting
//-------------------------------------------------------------

func webserviceForAppSetting(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = "\(Init)\(dictParams)"
    getData("" as AnyObject, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Bars And Taxis Methods
//-------------------------------------------------------------

func webserviceForBarsAndTaxis(_ dictParams: AnyObject, Location: String, Type: String, completion: @escaping(_ result: NSDictionary, _ success: Bool) -> Void)
{
    
    BarsAndClubs(dictParams, Location: Location, Type: Type, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Bars And Taxis Methods
//-------------------------------------------------------------

func webserviceForBookTable(_ dictParams: AnyObject, Location: String, Type: String, ItemType: String, completion: @escaping(_ result: NSDictionary, _ success: Bool) -> Void)
{
    
    BookTable(dictParams, Location: Location, Type: Type, Item: ItemType, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For TiCKPay Get Rate
//-------------------------------------------------------------

func webserviceForGetTickpayRate(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = GetTickpayRate + (dictParams as! String)
    getData("" as AnyObject, nsURL: url, completion: completion)
}
//-------------------------------------------------------------
// MARK: - Webservice For Packaging List
//-------------------------------------------------------------

func webserviceForGetPackages(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = GetPackages
    getData("" as AnyObject, nsURL: url, completion: completion)
}
//-------------------------------------------------------------
// MARK: - Webservice For Rating and Comment
//-------------------------------------------------------------

func webserviceForRatingAndComment(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = ReviewRating
    postData(dictParams, nsURL: url, completion: completion)
}

func webserviceForRentalRating(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = RentalReviewRating
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Tickpay Approval Status
//-------------------------------------------------------------

func webserviceForTickpayApprovalStatus(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = GetTickpayApprovalStatus + (dictParams as! String)
    getData("" as AnyObject, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Transfer To Bank
//-------------------------------------------------------------

func webserviceForTransferToBank(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = TransferToBank
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Update Bank Account Details
//-------------------------------------------------------------

func webserviceForUpdateBankAccountDetails(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = UpdateBankAccountDetails
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For OTP Register
//-------------------------------------------------------------

func webserviceForOTPRegister(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = OTPVerify
    postData(dictParams, nsURL: url, completion: completion)
}


//-------------------------------------------------------------
// MARK: - Webservice For Miss Booking Request
//-------------------------------------------------------------

func webserviceForMissBookingRequest(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = MissBookingRequest
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Track Running Trip
//-------------------------------------------------------------

func webserviceForTrackRunningTrip(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = TrackRunningTrip + "\(dictParams)"
    getData("" as AnyObject, nsURL: url, completion: completion)
}


//-------------------------------------------------------------
// MARK: - Webservice For Update Dropoff Location
//-------------------------------------------------------------

func webserviceForUpdateDropoffLocation(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = UpdateDropoffLocation
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Help options
//-------------------------------------------------------------

func webserviceForHelpOptions(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = HelpOptions
    getData("" as AnyObject, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Sending Help Request
//-------------------------------------------------------------



func webserviceForSendingHelpRequest(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = Help
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Rental Model options
//-------------------------------------------------------------

func webserviceForRentalModels(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = RentalModels
    getData("" as AnyObject, nsURL: url, completion: completion)
}

func webserviceForModelPackages(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = ModelPackages
    postData(dictParams, nsURL: url, completion: completion)
}

func webserviceForSubmitTourRequest(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = SubmitTourReq
    postData(dictParams, nsURL: url, completion: completion)
}
