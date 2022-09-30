//
//  RegistrationNewViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 26/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift
import PhotosUI
import SDWebImage
//import TransitionButton

class RegistrationNewViewController: UIViewController,AKRadioButtonsControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
 
    
    
    var strDateOfBirth = String()
    var isPassengerImage: Bool = false

    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    var radioButtonsController: AKRadioButtonsController!
    @IBOutlet var radioButtons: [AKRadioButton]!
    
//    @IBOutlet weak var txtFirstName: ACFloatingTextfield!
//    @IBOutlet weak var txtLastName: ACFloatingTextfield!
    
    @IBOutlet weak var btnSignUp: ThemeButton!
    @IBOutlet weak var btnTermsSignUp: UIButton!
    @IBOutlet weak var btnPassengerIId: UIButton!
    @IBOutlet weak var imgPassengerId: UIImageView!
    @IBOutlet weak var lblPassengerIdProof: UILabel!
    

//    var strEmail = String()
   // @IBOutlet weak var txtFullName: ThemeTextField!
    @IBOutlet weak var txtFirstName: ThemeTextField!
    @IBOutlet weak var txtLastName: ThemeTextField!
    
    @IBOutlet weak var txtTermsAndPrivacy: UITextView!
    
    @IBOutlet weak var txtDateOfBirth: ThemeTextField!
    
    @IBOutlet weak var txtAddress: ThemeTextField!
    
    @IBOutlet weak var txtRafarralCode: ThemeTextField!
    
    @IBOutlet weak var txtPostCode: ThemeTextField!
    @IBOutlet weak var txtDOB: ThemeTextField!
    @IBOutlet weak var imgProfile: UIImageView!

    @IBOutlet weak var lblFirstStep: UILabel!
    
    @IBOutlet var btnFemail: AKRadioButton!
    @IBOutlet var btnmale: AKRadioButton!
    @IBOutlet weak var lblSecondStep: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var strPhoneNumber = String()
    var strEmail = String()
    var strPassword = String()
    var gender = String()
    
    var termsLink = app_TermsAndCondition
    var PrivacyLink = app_PrivacyPolicy
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setLocalization()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
       // self.btnSignUp.isMultipleTouchEnabled = false
       
    }
    func setLocalization() {
       // txtFullName.placeholder  =  "Full Name".localized
        txtFirstName.placeholder  =  "First Name".localized
        txtLastName.placeholder  =  "Last Name".localized
        txtAddress.placeholder = "Address".localized
        txtRafarralCode.placeholder  =  "Referral Code (Optional)".localized
        txtPostCode.placeholder = "Post Code".localized
        txtDateOfBirth.placeholder = "Date Of Birth".localized
        txtDOB.placeholder = "Date Of Birth".localized
        btnSignUp.setTitle("Submit".localized , for: .normal)
        btnmale.setTitle("Male".localized, for: .normal)
        btnFemail.setTitle("Female".localized, for: .normal)
        lblPassengerIdProof.text = "ID Proof (License/ID card /Passport)".localized
    }
    
    // MARK: - Base Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        gender = "male"
        self.SetLayout()
        var image = UIImage()
        if SingletonClass.sharedInstance.isFromSocilaLogin == true
        {
         //   self.txtFullName.text = SingletonClass.sharedInstance.strSocialFullName
            self.txtFirstName.text = SingletonClass.sharedInstance.strSocialFirstName
            self.txtLastName.text = SingletonClass.sharedInstance.strSocialLastName
            
            let url = URL(string: SingletonClass.sharedInstance.strSocialImage)
            self.imgProfile.sd_setImage(with: url) { (image, error, cache, urls) in
                if (error != nil) {
                    self.imgProfile.image = UIImage(named: "iconUser")
                } else {
                    self.imgProfile.image = image
                }
            }
        }
        
        txtTermsAndPrivacy.text = "\("I agree with".localized) \("Terms & conditions".localized) \("and".localized) \("Privacy Policy".localized)"
        self.txtTermsAndPrivacy.hyperLink(originalText: "\("I agree with".localized) \("Terms & conditions".localized) \("and".localized) \("Privacy Policy".localized)",linkTextsAndTypes: [("Terms & conditions".localized): termsLink,("Privacy Policy".localized): PrivacyLink])
                
                self.txtTermsAndPrivacy.delegate = self
                self.txtTermsAndPrivacy.textColor = .white
                self.txtTermsAndPrivacy.font = UIFont.regular(ofSize: 14)
        
        // Do any additional setup after loading the view.
 //        txtFirstName.text = "rahul"
//        txtLastName.text = "patel"
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width/2
        self.imgProfile.layer.masksToBounds = true
        self.imgProfile.contentMode = .scaleAspectFill
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func setupScrollView() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            DispatchQueue.main.async {
                self.view.layoutIfNeeded()
                self.view.layoutSubviews()
                self.view.setNeedsLayout()
                self.scrollView.layoutIfNeeded()
                self.scrollView.contentInsetAdjustmentBehavior = .never
                self.scrollView.contentInset = UIEdgeInsetsMake(0,0,0,0)
                self.scrollView.setNeedsLayout()
                print("self.scrollView.setNeedsLayout()")
            }
        }
    }
    
    @objc func changeLanguage(){
        self.setLocalization()
    }
    
    func selectedButton(sender: AKRadioButton) {

        print(sender.currentTitle!)
        switch sender.currentTitle! {
            
        case "Male":
            gender = "male"
        case "Female":
            gender = "female"
        default:
            gender = "male"
        }
        
    }
    
    // MARK: - Pick Image
     func TapToProfilePicture() {
        
         let alert = UIAlertController(title: "Choose Options".localized, message: nil, preferredStyle: .alert)
        
         let Gallery = UIAlertAction(title: "Gallery".localized, style: .default, handler: { ACTION in
            self.PickingImageFromGallery()
        })
         let Camera  = UIAlertAction(title: "Camera".localized, style: .default, handler: { ACTION in
            self.PickingImageFromCamera()
        })
         let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        
        alert.addAction(Gallery)
        alert.addAction(Camera)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func PickingImageFromGallery(){
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    let picker = UIImagePickerController()
                    picker.delegate = self
                    
                    picker.allowsEditing = false
                    picker.sourceType = .photoLibrary
                    picker.mediaTypes = [(kUTTypeImage as String)]
                    self.present(picker, animated: true, completion: nil)
                }
            case .limited:
                DispatchQueue.main.async {
                    let picker = UIImagePickerController()
                    picker.delegate = self
                    
                    picker.allowsEditing = false
                    picker.sourceType = .photoLibrary
                    picker.mediaTypes = [(kUTTypeImage as String)]
                    self.present(picker, animated: true, completion: nil)
                }
            case .restricted:
                break
            //                   showRestrictedAccessUI()
            
            case .denied:
                DispatchQueue.main.async {
                    
                    let alert = UIAlertController(title: "Photos".localized, message: "Photo access is absolutely necessary to use this app".localized, preferredStyle: .alert)
                    
                    // Add "OK" Button to alert, pressing it will bring you to the settings app
                    alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: { action in
                        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Will do later".localized, style: .default, handler: { action in
                    }))
                    // Show the alert with animation
                    self.present(alert, animated: true)
                }
            //                   showAccessDeniedUI()
            
            case .notDetermined:
                break
                
            @unknown default:
                break
            }
        }
    }
    
    
    
    func PickingImageFromCamera(){
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                DispatchQueue.main.async {
                    let picker = UIImagePickerController()
                    
                    picker.delegate = self
                    picker.allowsEditing = false
                    picker.sourceType = .camera
                    picker.cameraCaptureMode = .photo
                    
                    self.present(picker, animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    
                    let alert = UIAlertController(title: "Camera".localized, message: "Camera access is absolutely necessary to use this app".localized, preferredStyle: .alert)
                    
                    // Add "OK" Button to alert, pressing it will bri≥ng you to the settings app
                    alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: { action in
                        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Will do later".localized, style: .default, handler: { action in
                    }))
                    // Show the alert with animation
                    self.present(alert, animated: true)
                }
            }
        }
        
    }
    
    // MARK: - Image Delegate and DataSource Methods

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if(isPassengerImage){
                imgPassengerId.contentMode = .scaleToFill
                imgPassengerId.image = pickedImage
            }else{
                imgProfile.contentMode = .scaleToFill
                imgProfile.image = pickedImage
            }
          
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func pickupdateMethod(_ sender: UIDatePicker){
        let dateFormaterView = DateFormatter()
        dateFormaterView.dateFormat = "yyyy-MM-dd"
        txtDOB.text = dateFormaterView.string(from: sender.date)
        strDateOfBirth = txtDOB.text!
    }

    
    @IBAction func txtDateOfBirth(_ sender: ThemeTextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.maximumDate = Date()
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.pickupdateMethod(_:)), for: UIControlEvents.valueChanged)
        
    }
    
    @IBAction func btnClickTerms(_ sender : UIButton){
        btnTermsSignUp.isSelected = !btnTermsSignUp.isSelected
    }
    //MARK: - Validation
    
    func checkValidation() -> Bool {
        
         if imgProfile.image == UIImage(named: "iconProfilePicBlank"){
             UtilityClass.setCustomAlert(title: "Missing".localized, message: "Please choose profile picture".localized) { (index, title) in
            }
            return false
        }else if imgProfile.image!.isEqualToImage(image: UIImage(named: "icon_UserImage")!) {
            UtilityClass.setCustomAlert(title: "Missing".localized, message: "Please choose profile picture".localized) { (index, title) in
              }
              return false
        }else if imgPassengerId.image!.isEqualToImage(image: UIImage(named: "icon_Picture")!) {
            UtilityClass.setCustomAlert(title: "Missing".localized, message: "Please upload ID Proof Doc".localized) { (index, title) in
              }
              return false
        }
//        else if (txtFullName.text?.count == 0){
//            UtilityClass.setCustomAlert(title: "Missing", message: "Enter full name") { (index, title) in
//            }
//            return false
//        }
        
        else if (txtFirstName.text?.count == 0){
            UtilityClass.setCustomAlert(title: "Missing".localized, message: "Enter first name".localized) { (index, title) in
            }
            return false
        }
        
        else if (txtLastName.text?.count == 0){
            UtilityClass.setCustomAlert(title: "Missing".localized, message: "Enter last name".localized) { (index, title) in
            }
            return false
        }
      /*  else if imgProfile.image!.isEqualToImage(image: UIImage(named: "icon_UserImage")!) {
            
            UtilityClass.setCustomAlert(title: "Missing", message: "Please choose profile picture") { (index, title) in
            }
            return false
        }*/
//        else if (txtLastName.text?.count == 0)
//        {
//
//            UtilityClass.setCustomAlert(title: "Missing", message: "Enter Last Name") { (index, title) in
//            }
//            return false
//        }
 
//        else if strDateOfBirth == "" {
//
//            UtilityClass.setCustomAlert(title: "Missing", message: "Please choose Date of Birth") { (index, title) in
//            }
//            return false
//        }
        else if (txtAddress.text?.count == 0) {
            UtilityClass.setCustomAlert(title: "Missing".localized, message: "Please enter address".localized) { (index, title) in
            }
            return false
        } else if gender == "" {
            UtilityClass.setCustomAlert(title: "Missing".localized, message: "Please choose gender".localized) { (index, title) in
            }
            return false
        }
        else if btnTermsSignUp.isSelected == false{
            UtilityClass.setCustomAlert(title: "Missing".localized, message: "Please accept terms & condition and privacy policy".localized) { (index, title) in
            }
            return false
        }
//        else if (txtPostCode.text?.count == 0)
//        {
//
//            UtilityClass.setCustomAlert(title: "Missing", message: "Enter Post Code") { (index, title) in
//            }
//            return false
//        }
        return true
    }
    
    
    //MARK: - IBActions
    
    @IBAction func btnChooseImage(_ sender: Any) {
        isPassengerImage = false
        self.TapToProfilePicture()
    }
    
    @IBAction func btnPassengereImage(_ sender: Any) {
        isPassengerImage = true
        self.TapToProfilePicture()
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        
        self.btnSignUp.isUserInteractionEnabled = false
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { _ in
            self.btnSignUp.isUserInteractionEnabled = true
        })
        
        let isplaceholder = imgProfile.image!.isEqualToImage(image: UIImage(named: "icon_UserImage")!)
        guard (txtFirstName.text?.count != 0) || (txtLastName.text?.count != 0) || (txtAddress.text?.count != 0) || isplaceholder != true || gender != "" else {
            UtilityClass.setCustomAlert(title: "Missing".localized, message: "Please enter all details".localized) { (index, title) in
            }
            return
        }
        if (checkValidation())
        {
            let registerVC = (self.navigationController?.viewControllers.last as! RegistrationContainerViewController).childViewControllers[0] as! RegisterViewController
            
            strPhoneNumber = (registerVC.txtPhoneNumber.text)!
            strEmail = (registerVC.txtEmail.text)!
            strPassword = (registerVC.txtPassword.text)!
            
            webServiceCallForRegister()
        }
    }
    
    // MARK: - WebserviceCall
    
    func webServiceCallForRegister()  {

        let dictParams = NSMutableDictionary()
        
//        let FullName:String = self.txtFullName.text!
//        var FirstName:String = ""
//        var LastName:String = ""
//
//        if FullName.contains(" ") {
//            let arrNames = FullName.components(separatedBy: " ")
//            FirstName = arrNames[0]
//            if arrNames.count > 1 {
//                LastName = arrNames[1]
//            }
//        } else {
//            FirstName = FullName
//        }
        
        dictParams.setObject(txtFirstName.text!, forKey: "Firstname" as NSCopying)
        dictParams.setObject(txtLastName.text!, forKey: "Lastname" as NSCopying)
        dictParams.setObject(txtRafarralCode.text!, forKey: "ReferralCode" as NSCopying)
        dictParams.setObject(txtPostCode.text!, forKey: "ZipCode" as NSCopying)
        dictParams.setObject(txtAddress.text!, forKey: "Address" as NSCopying)
        dictParams.setObject(strPhoneNumber, forKey: "MobileNo" as NSCopying)
        dictParams.setObject(strEmail, forKey: "Email" as NSCopying)
        dictParams.setObject(strPassword, forKey: "Password" as NSCopying)
        dictParams.setObject(SingletonClass.sharedInstance.deviceToken, forKey: "Token" as NSCopying)
        dictParams.setObject("1", forKey: "DeviceType" as NSCopying)
        dictParams.setObject(gender, forKey: "Gender" as NSCopying)
        dictParams.setObject("12376152367", forKey: "Lat" as NSCopying)
        dictParams.setObject("2348273489", forKey: "Lng" as NSCopying)
        dictParams.setObject(strDateOfBirth, forKey: "DOB" as NSCopying)
        
        dictParams.setObject(SingletonClass.sharedInstance.strAppleId, forKey: "SocialId" as NSCopying)
        if(SingletonClass.sharedInstance.isFromSocilaLogin){
            dictParams.setObject("Apple", forKey: "SocialType" as NSCopying)
            
        }
        
        UtilityClass.showACProgressHUD()
 
        webserviceForRegistrationForUser(dictParams, image1: imgProfile.image!, image2: imgPassengerId.image!, isRegister: true) { (result, status) in
            
            
            print(result)
            AppDelegate.current?.isSocialLogin = false
            SingletonClass.sharedInstance.strSocialEmail = ""
            SingletonClass.sharedInstance.strSocialFullName = ""
            SingletonClass.sharedInstance.strSocialImage = ""
            
            if ((result as! NSDictionary).object(forKey: "status") as! Int == 1)
            {
                
                SingletonClass.sharedInstance.isFromSocilaLogin = false
                SingletonClass.sharedInstance.strAppleId = ""
                
                
                DispatchQueue.main.async(execute: { () -> Void in
                UtilityClass.hideACProgressHUD()
//                    self.btnSignUp.stopAnimation(animationStyle: .normal, completion: {
                    
                    if UserDefaults.standard.bool(forKey: kIsUpdateAvailable) == true {
                        UtilityClass.showAlertWithCompletion("App Name".localized, message: "Registration completed successfully", vc: self, completionHandler: { ACTION in
                            for controller in self.navigationController!.viewControllers as Array {
                                if controller.isKind(of: LoginViewController.self) {
                                    self.navigationController!.popToViewController(controller, animated: false)
                                    break
                                }
                            }
                           
                        })
                        return
                    }
                    
                    
                        SingletonClass.sharedInstance.dictProfile = NSMutableDictionary(dictionary: (result as! NSDictionary).object(forKey: "profile") as! NSDictionary)   
                        SingletonClass.sharedInstance.isUserLoggedIN = true
                        SingletonClass.sharedInstance.strPassengerID = String(describing: SingletonClass.sharedInstance.dictProfile.object(forKey: "Id")!)
                    
//                        UserDefaults.standard.set(SingletonClass.sharedInstance.dictProfile, forKey: "profileData")
                    let data = NSKeyedArchiver.archivedData(withRootObject: SingletonClass.sharedInstance.dictProfile)
                    UserDefaults.standard.set(data, forKey: "profileData")
                    
                        appDelegate.GoToHome()

                })
                
            }
            else
            {
//                self.btnSignUp.stopAnimation(animationStyle: .shake, revertAfterDelay: 0, completion: {
                    UtilityClass.hideACProgressHUD()
                    UtilityClass.setCustomAlert(title: "Error", message: (result as! NSDictionary).object(forKey: GetResponseMessageKey()) as! String) { (index, title) in
                    }
                    
//                })
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


//-------------------------------------------------------------
// MARK: - Custom Methods
//-------------------------------------------------------------

extension RegistrationNewViewController {
    
    func SetLayout() {
        
        self.lblFirstStep.layer.cornerRadius = 12.5
        self.lblSecondStep.layer.cornerRadius = 12.5
        self.lblFirstStep.layer.masksToBounds = true
        self.lblSecondStep.layer.masksToBounds = true
        
        self.radioButtonsController = AKRadioButtonsController(radioButtons: self.radioButtons)
        
        self.radioButtonsController.strokeColor = .white
        
//        self.radioButtonsController.strokeColor = themeYellowColor
        self.radioButtonsController.startGradColorForSelected = themeYellowColor
        self.radioButtonsController.endGradColorForSelected = themeYellowColor
        self.radioButtonsController.selectedIndex = 1
        
        //0 is female
        //1 is female
        
        self.radioButtonsController.delegate = self //class should implement AKRadioButtonsControllerDelegate
        
    }
    
}
extension UIImage {
    
    func isEqualToImage(image: UIImage) -> Bool {
        let data1: NSData = UIImagePNGRepresentation(self)! as NSData
        let data2: NSData = UIImagePNGRepresentation(image)! as NSData
        
        return data1.isEqual(data2)
    }
    
}


//MARK: - TextView Delegate
extension RegistrationNewViewController : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        
        let next = mainStoryboard.instantiateViewController(withIdentifier: "webViewVC") as! webViewVC
        next.headerName = "\(appName)"
        next.strURL = URL.absoluteString
        next.isFromRegister = true
        next.navigationController?.isNavigationBarHidden = false
//        let myNavigationController = UINavigationController(rootViewController: next)
        self.navigationController?.pushViewController(next, animated: true)

        return false
    }
    
}

public extension UITextView {
    
    func hyperLink(originalText: String, linkTextsAndTypes: [String: String]) {
        
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        
        let attributedOriginalText = NSMutableAttributedString(string: originalText)
        
        for linkTextAndType in linkTextsAndTypes {
            let linkRange = attributedOriginalText.mutableString.range(of: linkTextAndType.key)
            let fullRange = NSRange(location: 0, length: attributedOriginalText.length)
            attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: linkTextAndType.value, range: linkRange)
            attributedOriginalText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: fullRange)
            attributedOriginalText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: fullRange)
            attributedOriginalText.addAttribute(NSAttributedString.Key.font, value: UIFont.regular(ofSize: 14.0), range: fullRange)
        }
        
        self.linkTextAttributes = [
            kCTForegroundColorAttributeName: UIColor.blue,
            kCTUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue
        ] as [String: Any]
        
        self.attributedText = attributedOriginalText
    }
}
