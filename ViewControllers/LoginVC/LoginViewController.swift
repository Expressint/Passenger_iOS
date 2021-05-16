//
//  LoginViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 25/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import Foundation
import UIKit
import TransitionButton
import ACFloatingTextfield_Swift
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
//import SideMenu
import NVActivityIndicatorView
import CoreLocation






class LoginViewController: UIViewController, CLLocationManagerDelegate, alertViewMethodsDelegates, GIDSignInDelegate
{
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
//      let loginButton = FBLoginButton()
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewFacebookLoginContainer: UIView?

    @IBOutlet weak var txtPassword: ThemeTextField!
    @IBOutlet weak var txtMobile: ThemeTextField!
    
    @IBOutlet weak var btnLogin: ThemeButton!
    
    @IBOutlet weak var btnSignup: UIButton!
    
    @IBOutlet weak var btnForgotPass: UIButton!
    
    @IBOutlet weak var lblDontAc: UILabel!
    
    @IBOutlet weak var lblOr: UILabel!
    
    @IBOutlet weak var btnFB: UIButton!
    
    @IBOutlet weak var btnGoogle: UIButton!
     @IBOutlet var lblLaungageName: UILabel!
    var manager = CLLocationManager()

    var strURLForSocialImage = String()
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func loadView() {
        super.loadView()
        
        if Connectivity.isConnectedToInternet() {
            print("Yes! Internet is available.")
            // do some tasks..
        }
        else {

            UtilityClass.setCustomAlert(title: "Connection Error".localized, message: "Internet connection not available".localized) { (index, title) in
            }
        }
        
        webserviceOfAppSetting()
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            if (manager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) || manager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization)))
            {
                if manager.location != nil
                {
                    manager.startUpdatingLocation()
                    manager.desiredAccuracy = kCLLocationAccuracyBest
                    manager.activityType = .automotiveNavigation
                    manager.startMonitoringSignificantLocationChanges()
//                    manager.allowsBackgroundLocationUpdates = true
                    //                    manager.distanceFilter = //
                }
                
            }
        }
        manager.startUpdatingLocation()
        
//        if(SingletonClass.sharedInstance.isUserLoggedIN)
//        {
//            //                            self.webserviceForAllDrivers()
//            self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
//        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        viewMain.isHidden = true
        
//        txtMobile.lineColor = UIColor.white
//        txtPassword.lineColor = UIColor.white
        lblLaungageName.text = "SW"
        UserDefaults.standard.set("en", forKey: "i18n_language")
        UserDefaults.standard.synchronize()
        
        if UIDevice.current.name == "Bhavesh iPhone" || UIDevice.current.name == "Excellent Web's iPhone 5s" || UIDevice.current.name == "Rahul's iPhone" {
            
            txtMobile.text = "9904439228"
            txtPassword.text = "12345678"
        }
        txtMobile.text = "9898989898"
        txtPassword.text = "12345678"
        
        lblLaungageName.layer.cornerRadius = 5
        lblLaungageName.backgroundColor = themeYellowColor
        lblLaungageName.layer.borderColor = UIColor.black.cgColor
        lblLaungageName.layer.borderWidth = 0.5
      
//        view.addSubview(loginButton)
        
//        let loginButton = FBLoginButton(type: .custom)
//        loginButton.frame = CGRect(x: 0, y: 0, width: self.viewFacebookLoginContainer?.frame.size.width ?? 0.0, height: self.viewFacebookLoginContainer?.frame.size.height ?? 0.0)
//        loginButton.center = self.viewFacebookLoginContainer?.center ?? CGPoint(x: 0, y: 0)
//        loginButton.addTarget(self, action: #selector(self.btnFBClicked(_:)), for: .touchUpInside)
//        self.viewFacebookLoginContainer?.addSubview(loginButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            self.setLocalization()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        loginButton.frame = self.viewFacebookLoginContainer!.frame
//        loginButton.center = self.viewFacebookLoginContainer!.center
        
    }
    
   func setLocalization()
    {
        txtMobile.placeholder = "Phone Number".localized
        txtPassword.placeholder = "Password".localized
        lblDontAc.text = "Don't have an account?".localized
//       lblOr.text = "OR".localized
        btnForgotPass.setTitle("Forgot Password?".localized, for: .normal)
        btnLogin.setTitle("Sign In".localized, for: .normal)
        btnSignup.setTitle("Sign Up".localized, for: .normal)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    //MARK: - Validation
    
    func checkValidation() -> Bool
    {
        if (txtMobile.text?.count == 0)
        {

            UtilityClass.setCustomAlert(title: "Missing", message: "Enter Mobile Number") { (index, title) in
            }
            
             // txtMobile.showErrorWithText(errorText: "Enter Email")
            return false
        }
        else if ((txtMobile.text?.count)! < 10){
            
            UtilityClass.setCustomAlert(title: "Missing", message: "Please enter a valid Mobile Number") { (index, title) in
            }
        }
        else if (txtPassword.text?.count == 0)
        {

            UtilityClass.setCustomAlert(title: "Missing", message: "Enter Password") { (index, title) in
            }

            return false
        }
        else if (txtPassword.text!.count < 8) {
            UtilityClass.setCustomAlert(title: "Missing", message: "Password must contain atleast 8 characters") { (index, title) in
            }

            return false
        }
        return true
    }
    
    
    //MARK: - Webservice Call for Login
    
    func webserviceCallForLogin()
    {
       
        let dictparam = NSMutableDictionary()
        dictparam.setObject(txtMobile.text!, forKey: "Username" as NSCopying)
        dictparam.setObject(txtPassword.text!, forKey: "Password" as NSCopying)
        dictparam.setObject("1", forKey: "DeviceType" as NSCopying)
        dictparam.setObject("6287346872364287", forKey: "Lat" as NSCopying)
        dictparam.setObject("6287346872364287", forKey: "Lng" as NSCopying)
        dictparam.setObject(SingletonClass.sharedInstance.deviceToken, forKey: "Token" as NSCopying)
        UtilityClass.showACProgressHUD()
        
        webserviceForDriverLogin(dictparam) { (result, status) in
            
            if ((result as! NSDictionary).object(forKey: "status") as! Int == 1)
            {
                DispatchQueue.main.async(execute: { () -> Void in
                    UtilityClass.hideACProgressHUD()
                        SingletonClass.sharedInstance.dictProfile = NSMutableDictionary(dictionary: (result as! NSDictionary).object(forKey: "profile") as! NSDictionary)
//                        SingletonClass.sharedInstance.arrCarLists = NSMutableArray(array: (result as! NSDictionary).object(forKey: "car_class") as! NSArray)
                        SingletonClass.sharedInstance.strPassengerID = String(describing: SingletonClass.sharedInstance.dictProfile.object(forKey: "Id")!)//as! String
                        SingletonClass.sharedInstance.isUserLoggedIN = true
                        UserDefaults.standard.set(SingletonClass.sharedInstance.dictProfile, forKey: "profileData")
//                        UserDefaults.standard.set(SingletonClass.sharedInstance.arrCarLists, forKey: "carLists")

                        self.webserviceForAllDrivers()
                        
                })
            } else {
                UtilityClass.hideACProgressHUD()
                UtilityClass.setCustomAlert(title: "Error", message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                }
            }
        }
    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueToHomeVC") {
       
        }
    }

    
    var aryAllDrivers = NSArray()
    func webserviceForAllDrivers()
    {
        webserviceForAllDriversList { (result, status) in
            
            if (status) {
                
                self.aryAllDrivers = ((result as! NSDictionary).object(forKey: "drivers") as! NSArray)
                
                SingletonClass.sharedInstance.allDiverShowOnBirdView = self.aryAllDrivers
                
                (UIApplication.shared.delegate as! AppDelegate).GoToHome()
                
//                self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
//                let viewHomeController = self.storyboard?.instantiateViewController(withIdentifier: "CustomSideMenuViewController")as? CustomSideMenuViewController
//                let navController = UINavigationController(rootViewController: viewHomeController!)
//                self.sideMenuController?.embed(centerViewController: navController)
            }
            else {
                print(result)
            }
        }
    }
    @IBAction func btnFBClicked(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
        
//        if self.btnFB.isSelected
//        {
//            self.btnGoogle.isSelected = false
//        }
        let login = LoginManager()
        
        
        UIApplication.shared.statusBarStyle = .default
        login.logOut()
        login.logIn(permissions: ["public_profile","email"], from: self) { (result, error) in
            
            
            if error != nil
            {
//                UIApplication.shared.statusBarStyle = .lightContent
            }
            else if (result?.isCancelled)!
            {
//                UIApplication.shared.statusBarStyle = .lightContent
            }
            else
            {
                if (result?.grantedPermissions.contains("email"))!
                {
//                    UIApplication.shared.statusBarStyle = .lightContent
                    self.getFBUserData()
                }
                else
                {
                    print("you don't have permission")
                }
            }
        }
    }
    //function is fetching the user data
    func getFBUserData()
    {
        
        //        Utilities.showActivityIndicator()
        
        var parameters = [AnyHashable: Any]()
        parameters["fields"] = "first_name, last_name, picture, email,id"
        
        GraphRequest.init(graphPath: "me", parameters: parameters as! [String : Any]).start { (connection, result, error) in
            if error == nil
            {
                let dictData = result as! [String : AnyObject]
                let strFirstName = String(describing: dictData["first_name"]!)
                let strLastName = String(describing: dictData["last_name"]!)
                let strEmail = String(describing: dictData["email"]!)
                let strUserId = String(describing: dictData["id"]!)
                
                //                //NSString *strPicurl = [NSString stringWithFormat:@"%@",[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
                let imgUrl = ((dictData["picture"] as! [String:AnyObject])["data"]  as! [String:AnyObject])["url"] as? String
                
                //                var imgUrl = "http://graph.facebook.com/\(strUserId)/picture?type=large"
                
                
                
                //                let pictureDict = self.report["picture"]!["data"] as AnyObject
                //                let imgUrl = pictureDict["url"] as AnyObject
                
                var image = UIImage()
                let url = URL(string: imgUrl!)
                
                self.strURLForSocialImage = imgUrl!
                let data = try? Data(contentsOf: url!)
                
                if let imageData = data {
                    image = UIImage(data: imageData)!
                }else {
                    image = UIImage(named: "iconUser")!
                }
                
                var strFullName = ""
                
                
                if !UtilityClass.isEmpty(str: strFirstName)
                {
                    strFullName = strFullName + ("\(strFirstName)")
                }
                if !UtilityClass.isEmpty(str: strLastName) {
                    strFullName = strFullName + (" \(strLastName)")
                }
                
                var dictUserData = [String: AnyObject]()
                
                //                dictUserData["name"] = strFullName as AnyObject
                //                dictUserData["email"] = strEmail as AnyObject
                //                //                dictUserData["email"] = "" as AnyObject
                //                dictUserData["social_id"] = strUserId as AnyObject
                //                dictUserData["image"] = strPicurl as AnyObject
                //                dictUserData["type"] = "facebook" as AnyObject
                //                dictUserData["device_token"] = "1234567" as AnyObject
                
                dictUserData["Firstname"] = strFirstName as AnyObject
                dictUserData["Lastname"] = strLastName as AnyObject
                dictUserData["Email"] = strEmail as AnyObject
                dictUserData["MobileNo"] = "" as AnyObject
                dictUserData["Lat"] = "\(SingletonClass.sharedInstance.latitude)" as AnyObject
                dictUserData["Lng"] = "\(SingletonClass.sharedInstance.longitude)" as AnyObject
                dictUserData["SocialId"] = strUserId as AnyObject
                dictUserData["SocialType"] = "Facebook" as AnyObject
                dictUserData["Token"] = SingletonClass.sharedInstance.deviceToken as AnyObject
                dictUserData["DeviceType"] = "1" as AnyObject
                
                //
                //            SocialId , SocialType(Facebook OR Google) , DeviceType (1 OR 2) , Token , Firstname, Lastname ,  Email (optional), MobileNo , Lat , Lng , Image(optional)
                
                //            GVUserDefaults.standard().userData =  NSMutableDictionary(dictionary: dictUserData)
                self.webserviceForSocilLogin(dictUserData as AnyObject, ImgPic: image)
                
                //                GVUserDefaults.standard().userData =  NSMutableDictionary(dictionary: dictUserData)
                //
                SingletonClass.sharedInstance.isFromSocilaLogin = true
                
                //                self.APIcallforSocialMedia(dictParam: dictUserData)
                
                //                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
                //                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
     //MARK: - Webservice Call for Forgot Password
    
    func webserviceCallForForgotPassword(strEmail : String)
    {
        let dictparam = NSMutableDictionary()
        dictparam.setObject(strEmail, forKey: "Email" as NSCopying)
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        webserviceForForgotPassword(dictparam) { (result, status) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()

            if ((result as! NSDictionary).object(forKey: "status") as! Int == 1) {
  
                 UtilityClass.setCustomAlert(title: "Success", message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                }
            }
            else {

                 UtilityClass.setCustomAlert(title: "Error", message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                }
            }
        }
    }
    @IBAction func btnGoogleClicked(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
//        if self.btnGoogle.isSelected
//        {
//            self.btnFB.isSelected = false
//        }
        
        GIDSignIn.sharedInstance().delegate = self
//        GIDSignIn.sharedInstance().uiDelegate = self as GIDSignInUIDelegate
        GIDSignIn.sharedInstance().signIn()
    }
    
    //MARK: - Google SignIn Delegate -
    
    func signInWillDispatch(signIn: GIDSignIn!, error: Error!)
    {
        // myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        UIApplication.shared.statusBarStyle = .default
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!)
    {
        UIApplication.shared.statusBarStyle = .lightContent
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        
        if (error == nil)
        {
            // Perform any operations on signed in user here.
            let userId : String = user.userID // For client-side use only!
            let firstName : String  = user.profile.givenName
            let lastName : String  = user.profile.familyName
            let email : String = user.profile.email
            
            var dictUserData = [String: AnyObject]()
            var image = UIImage()
            if user.profile.hasImage
            {
                let pic = user.profile.imageURL(withDimension: 400)
                let imgUrl: String = (pic?.absoluteString)!
                print(imgUrl)
                self.strURLForSocialImage = imgUrl
                let url = URL(string: imgUrl as! String)
                let data = try? Data(contentsOf: url!)
                
                if let imageData = data {
                    image = UIImage(data: imageData)!
                }else {
                    image = UIImage(named: "iconUser")!
                }
                
                //                dictUserData["image"] = strImage as AnyObject
            }
            
            var strFullName = ""
            
            if !UtilityClass.isEmpty(str: firstName)
            {
                strFullName = strFullName + ("\(firstName)")
            }
            if !UtilityClass.isEmpty(str: strFullName) {
                strFullName = strFullName + (" \(lastName)")
            }
//            SocialId,SocialType,DeviceType,Token,Firstname,Lastname,Lat,Lng
            
            //            dictUserData["profileimage"] = "" as AnyObject
            dictUserData["Firstname"] = firstName as AnyObject
            dictUserData["Lastname"] = lastName as AnyObject
            dictUserData["Email"] = email as AnyObject
            dictUserData["MobileNo"] = "" as AnyObject
            dictUserData["Lat"] = "\(SingletonClass.sharedInstance.latitude)" as AnyObject
            dictUserData["Lng"] = "\(SingletonClass.sharedInstance.longitude)" as AnyObject
            dictUserData["SocialId"] = "\(userId)" as AnyObject
            dictUserData["SocialType"] = "Google" as AnyObject
            dictUserData["Token"] = SingletonClass.sharedInstance.deviceToken as AnyObject
            dictUserData["DeviceType"] = "1" as AnyObject
            
            //
            //            SocialId , SocialType(Facebook OR Google) , DeviceType (1 OR 2) , Token , Firstname, Lastname ,  Email (optional), MobileNo , Lat , Lng , Image(optional)
            
            //            GVUserDefaults.standard().userData =  NSMutableDictionary(dictionary: dictUserData)
            self.webserviceForSocilLogin(dictUserData as AnyObject, ImgPic: image)
                        SingletonClass.sharedInstance.isFromSocilaLogin = true
            
            
            //                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
            //                self.navigationController?.pushViewController(viewController, animated: true)
        }
        else
        {
            print("\(error.localizedDescription)")
        }
        
    }
    
    //MARK: - Webservice methods -
    func webserviceForSocilLogin(_ dictData : AnyObject, ImgPic : UIImage)
    {
        webserviceForSocialLogin(dictData as AnyObject, image1: ImgPic, showHUD: true) { (result, status) in
            if(status)
            {
//                Utilities.hideActivityIndicator()
                print(result)
//                SingletonClass.sharedInstance.isFromSocilaLogin = true
//                Utilities.hideActivityIndicator()
                print(result)
                
                let dictData = result as! [String : AnyObject]
                UtilityClass.hideACProgressHUD()
                SingletonClass.sharedInstance.dictProfile = NSMutableDictionary(dictionary: (result as! NSDictionary).object(forKey: "profile") as! NSDictionary)
//                SingletonClass.sharedInstance.arrCarLists = NSMutableArray(array: (result as! NSDictionary).object(forKey: "car_class") as! NSArray)
                SingletonClass.sharedInstance.strPassengerID = String(describing: SingletonClass.sharedInstance.dictProfile.object(forKey: "Id")!)//as! String
                SingletonClass.sharedInstance.isUserLoggedIN = true
                UserDefaults.standard.set(SingletonClass.sharedInstance.dictProfile, forKey: "profileData")
//                UserDefaults.standard.set(SingletonClass.sharedInstance.arrCarLists, forKey: "carLists")

                self.webserviceForAllDrivers()
//                let dict = dictData["profile"] as! [String : AnyObject]
//                let tempID = dict["Id"] as? String
//                SingletonClass.sharedInstance.strPassengerID = String(tempID!)
//                UserDefaults.standard.set(true, forKey: kIsLogin)
//                Utilities.encodeDatafromDictionary(KEY: kLoginData, Param: dictData["profile"] as! [String : AnyObject])
//
//                SingletonClass.sharedInstance.dictPassengerProfile = NSMutableDictionary(dictionary: (result as! NSDictionary)) as! [String : AnyObject]
//                SingletonClass.sharedInstance.isPassengerLoggedIN = true
//
//                UserDefaults.standard.set(SingletonClass.sharedInstance.dictPassengerProfile, forKey: passengerProfileKeys.kKeyPassengerProfile)
//                UserDefaults.standard.set(true, forKey: passengerProfileKeys.kKeyIsPassengerLoggedIN)
                
                //                SingletonClass.sharedInstance.strPassengerID = ((SingletonClass.sharedInstance.dictPassengerProfile.object(forKey: "profile") as! NSDictionary).object(forKey: "Vehicle") as! NSDictionary).object(forKey: "PassengerId") as! String
                
                //                SingletonClass.sharedInstance.driverDuty = ((SingletonClass.sharedInstance.dictDriverProfile.object(forKey: "profile") as! NSDictionary).object(forKey: "DriverDuty") as! String)
                //                    Singletons.sharedInstance.showTickPayRegistrationSceeen =
                
//                let profileData = SingletonClass.sharedInstance.dictPassengerProfile
                
                //                if let currentBalance = (profileData?.object(forKey: "profile") as! NSDictionary).object(forKey: "Balance") as? Double
                //                {
                //                    SingletonClass.sharedInstance.strCurrentBalance = currentBalance
                //                }
                
                
                (UIApplication.shared.delegate as! AppDelegate).GoToHome()
                
                

            }
            else
            {
//                Utilities.hideActivityIndicator()
                print(result)
                if let res = result as? String
                {
                    UtilityClass.showAlert("", message: res, vc: self)
                }
                else if let resDict = result as? NSDictionary
                {
                    //                    Utilities.showAlert(appName, message: resDict.object(forKey: "message") as! String, vc: self)
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationContainerViewController") as? RegistrationContainerViewController
                    
                    SingletonClass.sharedInstance.strSocialEmail = dictData["Email"] as! String
                    SingletonClass.sharedInstance.strSocialFullName = "\(dictData["Firstname"] as! String) \(dictData["Lastname"] as! String)"
                    SingletonClass.sharedInstance.strSocialImage = self.strURLForSocialImage
                    
                    
                    self.navigationController?.pushViewController(viewController!, animated: true)
                    
                }
                else if let resAry = result as? NSArray
                {
                    UtilityClass.showAlert("", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                }
            }
        }
    }
    func webserviceOfAppSetting() {
//        version : 1.0.0 , (app_type : AndroidPassenger , AndroidDriver , IOSPassenger , IOSDriver)

        let nsObject: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        let version = nsObject as! String
        
        print("Vewsion : \(version)")
        
        var param = String()
        param = version + "/" + "IOSPassenger"
        webserviceForAppSetting(param as AnyObject) { (result, status) in
            
            if (status) {
                print("result is : \(result)")
                SingletonClass.sharedInstance.arrCarLists = NSMutableArray(array: (result as! NSDictionary).object(forKey: "car_class") as! NSArray)

//                self.viewMain.isHidden = false
                
                if ((result as! NSDictionary).object(forKey: "update") as? Bool) != nil {
                    
                    let alert = UIAlertController(title: nil, message: (result as! NSDictionary).object(forKey: "message") as? String, preferredStyle: .alert)
                    let UPDATE = UIAlertAction(title: "UPDATE", style: .default, handler: { ACTION in
                        
                        UIApplication.shared.open((NSURL(string: "itms-apps://itunes.apple.com/app/id1445179460")! as URL), options: [:], completionHandler: { (status) in

                        })
                    })
                    let Cancel = UIAlertAction(title: "Cancel", style: .default, handler: { ACTION in
                        
                        if(SingletonClass.sharedInstance.isUserLoggedIN)
                        {
//                            self.webserviceForAllDrivers()
                            self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
                        }
                    })
                    alert.addAction(UPDATE)
                    alert.addAction(Cancel)
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    
                    if(SingletonClass.sharedInstance.isUserLoggedIN) {

                        self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
                    }
                }
            }
            else {
                print(result)
                
                SingletonClass.sharedInstance.arrCarLists = NSMutableArray(array: (result as! NSDictionary).object(forKey: "car_class") as? NSArray ?? [])

                if let update = (result as! NSDictionary).object(forKey: "update") as? Bool {
                    
                    if (update) {

                        UtilityClass.showAlertWithCompletion("", message: (result as! NSDictionary).object(forKey: "message") as! String, vc: self, completionHandler: { ACTION in
                            
                            UIApplication.shared.open((NSURL(string: "itms-apps://itunes.apple.com/app/id1445179460")! as URL), options: [:], completionHandler: { (status) in
                                
                            })//openURL(NSURL(string: "https://itunes.apple.com/us/app/pick-n-go/id1320783092?mt=8")! as URL)
                        })
                    }
                    else {

                         UtilityClass.setCustomAlert(title: "Error", message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                            if (index == 0)
                            {
                                UIApplication.shared.open((NSURL(string: "itms-apps://itunes.apple.com/app/id1445179460")! as URL), options: [:], completionHandler: { (status) in
                                    
                                })
                            }
                        }

                    }
                    
                }
/*
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
 */
            }
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
    }
    
    
    
    @IBAction func btnLogin(_ sender: Any) {
        
        
        
        guard (txtMobile.text?.count != 0) || (txtPassword.text?.count != 0) else {
            UtilityClass.setCustomAlert(title: "Missing", message: "Please fill all details") { (index, title) in
            }
            return
        }
        
        if (checkValidation()) {
            self.webserviceCallForLogin()
        }
    
    }
    
    @IBAction func btnSignup(_ sender: Any) {
        
    
    }
    
    
    @IBAction func btnForgotPassword(_ sender: UIButton) {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Forgot Password?".localized, message: "", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            
            textField.placeholder = "Email".localized
            textField.keyboardType = .emailAddress
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(String(describing: textField?.text))")
            
            let isEmailAddressValid = self.isValidEmailAddress(emailID: textField!.text!)
            if (textField?.text?.count != 0) && (isEmailAddressValid)
            {
                self.webserviceCallForForgotPassword(strEmail: (textField?.text)!)
            } else {
                UtilityClass.setCustomAlert(title: "Invalid!", message: "Enter a valid email") { (index, title) in
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: { (_) in
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func isValidEmailAddress(emailID: String) -> Bool
    {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z)-9.-]+\\.[A-Za-z]{2,3}"
        
        do{
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailID as NSString
            let results = regex.matches(in: emailID, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
        }
        catch _ as NSError
        {
            returnValue = false
        }
        
        return returnValue
    }
    
    func setLayoutForswahilLanguage()
    {
        UserDefaults.standard.set("sw", forKey: "i18n_language")
        UserDefaults.standard.synchronize()
        //            setLayoutForSwahilLanguage()
    }
    func setLayoutForenglishLanguage()
    {
        UserDefaults.standard.set("en", forKey: "i18n_language")
        UserDefaults.standard.synchronize()
        //        setLayoutForSwahilLanguage()
        //        setLayoutForEnglishLanguage()
    }
    @IBAction func btnLaungageClicked(_ sender: Any)
    {
        
        if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
            if SelectedLanguage == "en" {
                setLayoutForswahilLanguage()
                lblLaungageName.text = "EN"
            } else if SelectedLanguage == "sw" {
                setLayoutForenglishLanguage()
                lblLaungageName.text = "SW"
            }
            
            self.navigationController?.loadViewIfNeeded()
            
    
            
            self.setLocalization()
        }
        
        //        if strSelectedLaungage == KEnglish
        //        {
        //            strSelectedLaungage = KSwiley
        //
        //            if UserDefaults.standard.value(forKey: "i18n_language") != nil {
        //                if let language = UserDefaults.standard.value(forKey: "i18n_language") as? String {
        //                        if language == "en"
        //                        {
        //                            setLayoutForswahilLanguage()
        //
        //                            print("Swahil")
        //                    }
        //                }
        //            }
        //        }
        //        else
        //        {
        //            strSelectedLaungage = KEnglish
        //            if UserDefaults.standard.value(forKey: "i18n_language") != nil {
        //                if let language = UserDefaults.standard.value(forKey: "i18n_language") as? String {
        //                    if language == "sw" {
        ////                        setLayoutForEnglishLanguage()
        //                        setLayoutForenglishLanguage()
        //                        print("English")
        //                    }
        //                }
        //            }
        //        }
        //
        //        lblLaungageName.text = strSelectedLaungage
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-------------------------------------------------------------
    // MARK: - Location Methods
    //-------------------------------------------------------------
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
//        print("Location: \(location)")
        
//        let location: CLLocation = locations.last!
        
        let state = UIApplication.shared.applicationState
        if state == .background {
            print("The location we are getting in background mode is \(location)")
        }
//        defaultLocation = location
        
        
        
        SingletonClass.sharedInstance.latitude = location.coordinate.latitude
        SingletonClass.sharedInstance.longitude = location.coordinate.longitude
        
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
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    func didOKButtonPressed() {
        
    }
    
    func didCancelButtonPressed() {
        
    }
    
    
    func setCustomAlert(title: String, message: String) {
        AJAlertController.initialization().showAlertWithOkButton(aStrTitle: title, aStrMessage: message) { (index,title) in
        }
        
//        let next = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertsViewController") as! CustomAlertsViewController
//
//        next.delegateOfAlertView = self
//        next.strTitle = title
//        next.strMessage = message
//
//        self.navigationController?.present(next, animated: false, completion: nil)
        
    }
   
    
}
