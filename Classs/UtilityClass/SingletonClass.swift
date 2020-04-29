//
//  SingletonClass.swift
//  TickTok User
//
//  Created by Excellent Webworld on 28/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class SingletonClass: NSObject {
   
    var dictProfile = NSMutableDictionary()
    var strPassengerID = String()
    var isUserLoggedIN = Bool()
    var arrCarLists = NSMutableArray()
    static let sharedInstance = SingletonClass()
    
    var isFirstTimeInTickPay = Bool()
    var isFirstTimeDidupdateLocation = true
    
    var bookedDetails = NSDictionary()
    
    var currentLatitude = String()
    var currentLongitude = String()
    
    var aryHistory = NSArray()
    var aryOnGoing = NSArray()
    var aryUpComming = NSArray()
    var aryPastBooking = NSArray()
    
    var boolIsFromPrevious = Bool()
    
    var bookingId = String()
    
    var dictIsFromPrevious = NSDictionary()
    
    
    var isCardsVCFirstTimeLoad: Bool = true
    var CardsVCHaveAryData = [[String:AnyObject]]()
    
    var strCurrentBalance = Double()
    var walletHistoryData = [[String:AnyObject]]()
    
    var strQRCodeForSendMoney = String()
    var isSendMoneySuccessFully = Bool()
    var isFromSocilaLogin = Bool()

    var latitude : Double!
    var longitude : Double!
    
    var isFromTopUP = Bool()
    var isFromTransferToBank = Bool()
    
    var isTiCKPayFromSideMenu = Bool()
    var firstRequestIsAccepted = Bool()
    
    var isfirstTimeTickPay = Bool()
    var strIsFirstTimeTickPay = String()
    var strTickPayId = String()
    var strAmoutOFTickPay = String()
    var strAmoutOFTickPayOriginal = String()
    
    var strCurrentCity = String()
    
    var isFirstTimeReloadCarList = Bool()
    
    var aryDriverInfo = NSArray()
    
    var isRequestAccepted = Bool()
    var isTripContinue = false

    var floatBearing:Float = 0.0
    
    var deviceToken = String()
    
    var setPasscode = String()
    var passwordFirstTime = Bool()
    
    var passengerRating = String()
    
    var isPasscodeON = Bool()
    
    var dictDriverProfile = NSDictionary()
    var dictCarInfo = [String : AnyObject]()
    var passengerTypeOther = Bool()
    
    var driverLocation = [String:AnyObject]()
    
    
    var TiCKPayVarifyKey = Int()
    var allDiverShowOnBirdView = NSArray()
    
    var isFromNotificationBookLater = Bool()
    
    var otpCode = String()
    
    /// If 1 Than share Ride is ON else 0 than OFF
    var isShareRide: Int = 0
    
    
    var strSocialEmail = String()
    var strSocialFullName = String()
    var strSocialImage = String()
}
