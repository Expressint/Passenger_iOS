//
//  AppDelegate.swift
//  TickTok User
//
//  Created by Excellent Webworld on 25/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
//import Fabric
//import Crashlytics
import SideMenuController
import SocketIO
import UserNotifications
import Firebase
import FBSDKLoginKit
import GoogleSignIn
import PhotosUI
import SideMenu


//"AIzaSyDDhx61DtSR4k174_60MQ6EyiQIF-qrd4o"
//968991622520-rrcn1f67kn2pai5gr526sfo6nthlaq44.apps.googleusercontent.com
let googlApiKey = "AIzaSyCQ10cPN_q98K0PrDxvZx-aVYD05hiNB7g" 
let googlPlacesApiKey = googlApiKey


let kGoogle_Client_ID : String = "968991622520-rrcn1f67kn2pai5gr526sfo6nthlaq44.apps.googleusercontent.com" //"1048315388776-2f8m0mndip79ae6jem9doe0uq0k25i7b.apps.googleusercontent.com"//"787787696945-nllfi2i6j9ts7m28immgteuo897u9vrl.apps.googleusercontent.com"
let kDeviceType : String = "1"


//AIzaSyBBQGfB0ca6oApMpqqemhx8-UV-gFls_Zk
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, GIDSignInDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var isAlreadyLaunched : Bool?
    var isSocialLogin : Bool = false
    
    var isChatVisible: Bool = false
    var currentChatID: String = ""
    static var pushNotificationObj : NotificationObjectModel?
    static var pushNotificationType : NotificationTypes?

    
    static var current: AppDelegate? {
        UIApplication.shared.delegate as? AppDelegate
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        
    }
    let manager = SocketManager(socketURL: URL(string: NetworkEnvironment.current.socketURL)!, config: [.log(true), .compress,.version(.two)])
    var socket : SocketIOClient!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        UINavigationBar.appearance().barTintColor = themeYellowColor
//        UINavigationBar.appearance().tintColor = UIColor.white
//        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.clear], for: .normal)
//        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.clear], for: UIControlState.highlighted)
//        
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font : UIFont.regular(ofSize: 14.0)]

        // Set Stored Language from Local Database
        FirebaseApp.configure()
        socket = manager.defaultSocket
        
        UserDefaults.standard.set(false, forKey: kIsUpdateAvailable)
        UserDefaults.standard.synchronize()
        
        if UserDefaults.standard.value(forKey: "i18n_language") == nil {
            UserDefaults.standard.set("en", forKey: "i18n_language")
            UserDefaults.standard.synchronize()
        }
        
        ApplicationDelegate.shared.application(
                   application,
                   didFinishLaunchingWithOptions: launchOptions
               )

        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        isAlreadyLaunched = false
        // Firebase
        Messaging.messaging().delegate = self
        
        IQKeyboardManager.sharedManager().enable = true
        
        GMSServices.provideAPIKey(googlApiKey)
        GMSPlacesClient.provideAPIKey(googlApiKey)
        
        
//        Fabric.with([Crashlytics.self])
        GIDSignIn.sharedInstance().clientID = kGoogle_Client_ID
        GIDSignIn.sharedInstance().delegate = self
//        googleAnalyticsTracking()
        
        // TODO: Move this to where you establish a user session
        //   self.logUser()
        
        // ------------------------------------------------------------
        
        SideMenuController.preferences.drawing.menuButtonImage = UIImage(named: "menu")
        SideMenuController.preferences.drawing.sidePanelPosition = .overCenterPanelLeft
        SideMenuController.preferences.drawing.sidePanelWidth = (window?.frame.width)! * 0.85//(((window?.frame.width)! / 2) + ((window?.frame.width)! / 4))
        SideMenuController.preferences.drawing.centerPanelShadow = true
        SideMenuController.preferences.animating.statusBarBehaviour = .showUnderlay
        
        self.setupSideMenu()
        
        // ------------------------------------------------------------
        if ((UserDefaults.standard.data(forKey: "profileData")) != nil)
        {
            let outData = UserDefaults.standard.data(forKey: "profileData")
            let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSMutableDictionary
            SingletonClass.sharedInstance.dictProfile = dict
            SingletonClass.sharedInstance.strPassengerID = String(describing: SingletonClass.sharedInstance.dictProfile.object(forKey: "Id")!)
//            SingletonClass.sharedInstance.arrCarLists = NSMutableArray(array:  UserDefaults.standard.object(forKey: "carLists") as! NSArray)
            SingletonClass.sharedInstance.isUserLoggedIN = true
        }
        else
        {
            SingletonClass.sharedInstance.isUserLoggedIN = false
        }
        
        // For Passcode Set
        if UserDefaults.standard.object(forKey: "Passcode") as? String == nil || UserDefaults.standard.object(forKey: "Passcode") as? String == "" {
            SingletonClass.sharedInstance.setPasscode = ""
            UserDefaults.standard.set(SingletonClass.sharedInstance.setPasscode, forKey: "Passcode")
        }
        else {
            SingletonClass.sharedInstance.setPasscode = UserDefaults.standard.object(forKey: "Passcode") as! String
        }
        
        // For Passcode Switch
        if let isSwitchOn = UserDefaults.standard.object(forKey: "isPasscodeON") as? Bool {
            
            SingletonClass.sharedInstance.isPasscodeON = isSwitchOn
            UserDefaults.standard.set(SingletonClass.sharedInstance.isPasscodeON, forKey: "isPasscodeON")
        }
        else {
            SingletonClass.sharedInstance.isPasscodeON = false
            UserDefaults.standard.set(SingletonClass.sharedInstance.isPasscodeON, forKey: "isPasscodeON")
        }
        
        
        // Push Notification Code
        registerForPushNotification()
        checkAndSetDefaultLanguage()
        
        let remoteNotif = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary
        
        if remoteNotif != nil {
            let key = (remoteNotif as! NSDictionary).object(forKey: "gcm.notification.type")!
            NSLog("\n Custom: \(String(describing: key))")
            self.pushAfterReceiveNotification(typeKey: key as! String)
        }
        else {
            //            let aps = remoteNotif!["aps" as NSString] as? [String:AnyObject]
            NSLog("//////////////////////////Normal launch")
            //            self.pushAfterReceiveNotification(typeKey: "")
            
        }
        
        /*
         if let notification = launchOptions?[.remoteNotification] as? [String:AnyObject] {
         
         //            let aps = notification["aps"] as! [String:AnyObject]
         //            _ = NewsItems.makeNewsItems(aps)
         
         //            (window?.rootViewController as? UITabBarController)?.selectedIndex = 0
         }
         */
        LocationManager.shared.start()
        return true
    }
    
//    func application(_ app: UIApplication,open url: URL,options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    
          ApplicationDelegate.shared.application(
              app,
              open: url,
              sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
              annotation: options[UIApplication.OpenURLOptionsKey.annotation]
          )

      }
    
    func checkAndSetDefaultLanguage() {
        let currentLang = Localize.currentLanguage()
        Localize.setCurrentLanguage(currentLang)
    }
    

//    func googleAnalyticsTracking() {
//        guard let gai = GAI.sharedInstance() else {
//            assert(false, "Google Analytics not configured correctly")
//        }
//        gai.tracker(withTrackingId: googleAnalyticsTrackId)
//        // Optional: automatically report uncaught exceptions.
//        gai.trackUncaughtExceptions = true
//
//        // Optional: set Logger to VERBOSE for debug information.
//        // Remove before app release.
//        gai.logger.logLevel = .verbose
//    }
    
    //    func logUser() {
    //        // TODO: Use the current user's information
    //        // You can call any combination of these three methods
    //
    //        if ((UserDefaults.standard.object(forKey: "profileData")) != nil)
    //        {
    //            SingletonClass.sharedInstance.dictProfile = UserDefaults.standard.object(forKey: "profileData") as! NSMutableDictionary
    //            Crashlytics.sharedInstance().setUserEmail("user@fabric.io")
    //            Crashlytics.sharedInstance().setUserIdentifier("12345")
    //            Crashlytics.sharedInstance().setUserName("Test User")
    //        }
    //
    //    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        let isSwitchOn = UserDefaults.standard.object(forKey: "isPasscodeON") as? Bool
        let passCode = SingletonClass.sharedInstance.setPasscode
        
        
        if isSwitchOn != nil
        {
            SingletonClass.sharedInstance.isPasscodeON = isSwitchOn!
        }
        
        
//        if (passCode != "" && SingletonClass.sharedInstance.isPasscodeON) {
//
//            let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "VerifyPasswordViewController") as! VerifyPasswordViewController
//
//            initialViewController.isFromAppDelegate = true
//            self.window?.rootViewController?.present(initialViewController, animated: true, completion: nil)
//        }
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if ((UIApplication.topViewController()?.isKind(of: LoginViewController.self) ?? false)) {
            if UserDefaults.standard.bool(forKey: kIsUpdateAvailable) == true {
                print("Update app...")
                if !UIApplication.topViewController()!.isKind(of: UIAlertController.self) {
                    
                    let alert = UIAlertController(title: "App Name".localized, message: UserDefaults.standard.string(forKey: kIsUpdateMessage) ?? "", preferredStyle: .alert)
                    let UPDATE = UIAlertAction(title: "Update".localized, style: .default, handler: { ACTION in
                        UIApplication.shared.open((NSURL(string: appURL)! as URL), options: [:], completionHandler: { (status) in

                        })
                    })
                    let Cancel = UIAlertAction(title: "Register".localized, style: .default, handler: { ACTION in
                        NotificationCenter.default.post(name: Notification.Name("goToRegister"), object: nil, userInfo: nil)
                    })
                    alert.addAction(UPDATE)
                    alert.addAction(Cancel)
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // Push Notification Methods
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let toketParts = deviceToken.map({ (data)-> String in
            return String(format: "%0.2.2hhx", data)
        })
        
        let token = toketParts.joined()
        print("Device Token: \(token)")
        
        
        Messaging.messaging().apnsToken = deviceToken as Data
        
        print("deviceToken : \(deviceToken)")
        
        
        let fcmToken = Messaging.messaging().fcmToken
        print("FCM token: \(fcmToken ?? "")")
        
        if fcmToken == nil {
            
        } else {
            SingletonClass.sharedInstance.deviceToken = fcmToken!
            UserDefaults.standard.set(SingletonClass.sharedInstance.deviceToken, forKey: "Token")
        }
        
        print("SingletonClass.sharedInstance.deviceToken : \(SingletonClass.sharedInstance.deviceToken)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
        
        let currentDate = Date()
        print("currentDate : \(currentDate)")
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let key = (userInfo as NSDictionary).object(forKey: "gcm.notification.type") ?? ""
        if(application.applicationState == .background){
            self.pushAfterReceiveNotification(typeKey: key as? String ?? "")
        }
        Messaging.messaging().appDidReceiveMessage(userInfo)
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
        
    }
    
    func setupSideMenu() {
        SideMenuController.preferences.basic.menuWidth = UIScreen.main.bounds.size.width - 60 //((SCREEN_WIDTH * 25) / 100)
        SideMenuController.preferences.basic.defaultCacheKey = "0"
        SideMenuController.preferences.basic.position = .above
        SideMenuController.preferences.basic.direction = .left
        SideMenuController.preferences.basic.enablePanGesture = true
        SideMenuController.preferences.basic.enableRubberEffectWhenPanning = false
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(#function, notification)
        let content = notification.request.content
        let userInfo = notification.request.content.userInfo
        
        if let mainDic = userInfo as? [String: Any]{
            
            let pushObj = NotificationObjectModel(info: mainDic)
            AppDelegate.pushNotificationObj = pushObj
            AppDelegate.pushNotificationType = pushObj.type
            if let type = pushObj.type {
                switch type {
                case .newMeassage:
                    let currentID = pushObj.sender_id
                    if(currentID == AppDelegate.current?.currentChatID){
                        completionHandler([])
                        return
                    }
                case .logout:
                    break
                case .accountVerified:
                    if let status = pushObj.passengerVerificationStatus {
                        SingletonClass.sharedInstance.passengerVerificationStatus = String(status)
                    }
                }
            }
            completionHandler([.alert,.sound])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        
        let userInfo = response.notification.request.content.userInfo
        print("USER INFo : ",userInfo)
        
        if let mainDic = userInfo as? [String: Any]{
            
            let pushObj = NotificationObjectModel(info: mainDic)

            AppDelegate.pushNotificationObj = pushObj
            AppDelegate.pushNotificationType = pushObj.type
            
            if pushObj.type == NotificationTypes.newMeassage {
                if(!isChatVisible){
                    NotificationCenter.default.post(name: GoToChatScreen, object: nil)
                }else{
                    var DataDict: [String: AnyObject] = [:]
                    DataDict["booking_id"] = mainDic["gcm.notification.id"] as AnyObject
                    DataDict["receiver_Id"] = mainDic["gcm.notification.sender_id"] as AnyObject
                    let isDispacherChat = ("\(mainDic["gcm.notification.id"] as AnyObject)" == "" || "\(mainDic["gcm.notification.id"] as AnyObject)" == "0") ? true : false
                    DataDict["isDispacherChat"] = isDispacherChat as AnyObject
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadChatScreen"), object: nil, userInfo: DataDict)
                }
            }
        }
        
        completionHandler()
    }
    
    //-------------------------------------------------------------
    // MARK: - Push Notification Methods
    //-------------------------------------------------------------
    
    func registerForPushNotification() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_ , _ in })
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (granted, error) in
//
//            print("Permissin granted: \(granted)")
//
//            self.getNotificationSettings()
//
//        })
        
    }
    
    
    func getNotificationSettings() {
        
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: {(settings) in
            print("Notification Settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }

        })
    }
    
    //-------------------------------------------------------------
    // MARK: - FireBase Methods
    //-------------------------------------------------------------
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Actions On Push Notifications
    //-------------------------------------------------------------
    
    func pushAfterReceiveNotification(typeKey : String)
    {        
        if(typeKey == "AddMoney")
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let navController = self.window?.rootViewController as? UINavigationController
                let notificationController: UIViewController? = navController?.storyboard?.instantiateViewController(withIdentifier: "WalletHistoryViewController")
                navController?.present(notificationController ?? UIViewController(), animated: true, completion: {
                    
                })
            }
        }
        else if(typeKey == "TransferMoney")
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let navController = self.window?.rootViewController as? UINavigationController
                let notificationController: UIViewController? = navController?.storyboard?.instantiateViewController(withIdentifier: "WalletHistoryViewController")
                navController?.present(notificationController ?? UIViewController(), animated: true, completion: {
                    
                })
            }
        }
        else if(typeKey == "Tickpay")
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let navController = self.window?.rootViewController as? UINavigationController
                let notificationController: UIViewController? = navController?.storyboard?.instantiateViewController(withIdentifier: "PayViewController")
                navController?.present(notificationController ?? UIViewController(), animated: true, completion: {
                    
                })
            }
        }
        else if(typeKey == "AcceptBooking")
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let navController = self.window?.rootViewController as? UINavigationController
                let notificationController = navController?.storyboard?.instantiateViewController(withIdentifier: "MyBookingViewController") as! MyBookingViewController
                notificationController.bookingType = "accept"
                notificationController.isFromPushNotification = true
                
                navController?.present(notificationController, animated: true, completion: {
                    
                })
            }
        }
        else if(typeKey == "RejectBooking")
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let navController = self.window?.rootViewController as? UINavigationController
                let notificationController = navController?.storyboard?.instantiateViewController(withIdentifier: "MyBookingViewController")  as! MyBookingViewController
                notificationController.bookingType = "reject"
                notificationController.isFromPushNotification = true
                navController?.present(notificationController, animated: true, completion: {
                    
                })
            }
        }
        else if(typeKey == "OnTheWay")
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let navController = self.window?.rootViewController as? UINavigationController
                let notificationController = navController?.storyboard?.instantiateViewController(withIdentifier: "MyBookingViewController") as! MyBookingViewController
                notificationController.bookingType = "accept"
                notificationController.isFromPushNotification = true
                navController?.present(notificationController, animated: true, completion: {
                    
                })
            }
        }
        else if(typeKey == "Booking")
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let navController = self.window?.rootViewController as? UINavigationController
                let notificationController = navController?.storyboard?.instantiateViewController(withIdentifier: "MyBookingViewController")  as! MyBookingViewController
                notificationController.bookingType = "reject"
                notificationController.isFromPushNotification = true
                navController?.present(notificationController, animated: true, completion: {
                    
                })
            }
        }
        else if(typeKey == "AdvanceBooking")
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let navController = self.window?.rootViewController as? UINavigationController
                let notificationController = navController?.storyboard?.instantiateViewController(withIdentifier: "MyBookingViewController")  as! MyBookingViewController
                notificationController.bookingType = "reject"
                notificationController.isFromPushNotification = true
                navController?.present(notificationController, animated: true, completion: {
                    
                })
            }
        }
        
        //        else if(typeKey == "RejectDispatchJobRequest")
        //        {
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        //                let navController = self.window?.rootViewController as? UINavigationController
        //                let notificationController: UIViewController? = navController?.storyboard?.instantiateViewController(withIdentifier: "PastJobsListVC")
        //                navController?.present(notificationController ?? UIViewController(), animated: true, completion: {
        //
        //                })
        //            }
        //        }
        //        else if(typeKey == "BookLaterDriverNotify")
        //        {
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        //                let navController = self.window?.rootViewController as? UINavigationController
        //                let notificationController: UIViewController? = navController?.storyboard?.instantiateViewController(withIdentifier: "FutureBookingVC")
        //                navController?.present(notificationController ?? UIViewController(), animated: true, completion: {
        //
        //                })
        //            }
        //        }
    }
    
    // MARK: - Navigation Methods
    func GoToHome() {
        let CustomSideMenu = mainStoryboard.instantiateViewController(withIdentifier: "CustomSideMenuViewController") as! CustomSideMenuViewController
        let NavHomeVC = UINavigationController(rootViewController: CustomSideMenu)
        NavHomeVC.isNavigationBarHidden = true
        UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.rootViewController = NavHomeVC
    }
    
    func GoToIntro() {
        let CustomSideMenu = InitialStoryboard.instantiateViewController(withIdentifier: "IntroVC") as! IntroVC
        let NavHomeVC = UINavigationController(rootViewController: CustomSideMenu)
        NavHomeVC.isNavigationBarHidden = false
        let profileViewController = InitialStoryboard.instantiateViewController(withIdentifier: "SideMenuTableVC") as! SideMenuTableVC
        window?.rootViewController = SideMenuController(contentViewController: NavHomeVC,menuViewController: profileViewController)
    }

    func GoToLogin() {
        let Login = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let NavHomeVC = UINavigationController(rootViewController: Login)
        NavHomeVC.isNavigationBarHidden = true
        UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.rootViewController = NavHomeVC
    }
    
    func GoToLogout() {
        
        for (key, _) in UserDefaults.standard.dictionaryRepresentation() {
//            print("\(key) = \(value) \n")
            
            if key == "Token" || key  == "i18n_language" {
                
            }
            else {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }

        SingletonClass.sharedInstance.strPassengerID = ""
        UserDefaults.standard.removeObject(forKey: "profileData")
        SingletonClass.sharedInstance.isUserLoggedIN = false
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        
        UserDefaults.standard.removeObject(forKey: "Passcode")
        SingletonClass.sharedInstance.setPasscode = ""
        
        UserDefaults.standard.removeObject(forKey: "isPasscodeON")
        SingletonClass.sharedInstance.isPasscodeON = false
        
        SingletonClass.sharedInstance.isPasscodeON = false
        self.GoToLogin()
    }
    
    static func showAlert(title: String?, message: String?, actions: [UIAlertAction]? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let array = actions {
            array.forEach { alertVC.addAction($0) }
        } else {
            alertVC.addAction(.init(title: "Ok", style: .cancel))
        }
        UIApplication.topViewController()?.present(alertVC, animated: true)
    }

    static func hasCameraAccess( result: @escaping (_ access: Bool) -> Void) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                DispatchQueue.main.sync {
                    result(granted)
                }
            }
        case .restricted:
            AppDelegate.showAlert(title: "Unable to access the Camera", message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.")
            result(false)
        case .denied:
            AppDelegate.showAlert(title: "Unable to access the Camera", message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.")
                result(false)

        case .authorized:
                 result(true)

        @unknown default:
                result(false)
        }
    }

    static func hasPhotoLibraryAccess( result: @escaping (_ access: Bool) -> Void) {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { granted in
                DispatchQueue.main.async {
                    result(granted == .authorized)
                }
            }
        case .restricted, .denied:
            AppDelegate.showAlert(title: "Unable to access the Photos", message: "To enable access, go to Settings > Privacy > Photos and turn on Photos access for this app.")
            DispatchQueue.main.async {
                result(false)
            }

        case .authorized:
            DispatchQueue.main.async {
                result(true)
            }
        default:
            DispatchQueue.main.async {
                result(true)
            }
        }
    }
}

//extension String {
//    var localized: String {
////        if let _ = UserDefaults.standard.string(forKey: "i18n_language") {} else {
////            // we set a default, just in case
////
////
////
////        }
////        if  UserDefaults.standard.string(forKey: "i18n_language") == nil
////        {
////            UserDefaults.standard.set("en", forKey: "i18n_language")
////            UserDefaults.standard.synchronize()
////        }
//
//        let lang = UserDefaults.standard.string(forKey: "i18n_language")
////        print(lang)
//        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
//        let bundle = Bundle(path: path!)
////        print(path ?? "")
////        print(bundle ?? "")
//              return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
//    }
//}

//i18n_language = sw

class NotificationObjectModel: Codable {
    let booking_id: String
    let sender_id: String
    let type: NotificationTypes?
    let title: String
    let text: String
    let passengerVerificationStatus: Int?
    
    init(info: [String: Any]) {
        if let bookingId = info["gcm.notification.booking_id"] as? String {
            booking_id = bookingId
        } else {
            booking_id = info["gcm.notification.id"] as? String ?? ""
        }

        sender_id = info["gcm.notification.sender_id"] as? String ?? ""
        let typeKey = info["gcm.notification.type"] as? String ?? ""
        type = NotificationTypes(rawValue: typeKey)
        title = info["title"] as? String ?? ""
        text = info["text"] as? String ?? ""
        if let dataString = info["gcm.notification.data_push"] as? String {
            do {
                if let data = dataString.data(using: .utf8),
                   let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                {
                    passengerVerificationStatus = dictionary["PassengerVerificationStatus"] as? Int
                } else {
                    passengerVerificationStatus = nil
                }
            } catch {
                passengerVerificationStatus = nil
            }
        } else {
            passengerVerificationStatus = nil
        }
    }
    
}

enum NotificationTypes : String, Codable {
    case newMeassage = "Chat"
    case logout = "logout"
    case accountVerified = "AccountVerified"
}
