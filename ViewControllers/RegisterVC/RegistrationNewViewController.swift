//
//  RegistrationNewViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 26/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift
import TransitionButton

class RegistrationNewViewController: UIViewController,AKRadioButtonsControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
 
    
    
    var strDateOfBirth = String()

    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    var radioButtonsController: AKRadioButtonsController!
    @IBOutlet var radioButtons: [AKRadioButton]!
    
//    @IBOutlet weak var txtFirstName: ACFloatingTextfield!
//    @IBOutlet weak var txtLastName: ACFloatingTextfield!
    
    @IBOutlet weak var btnSignUp: ThemeButton!
    

//    var strEmail = String()
    @IBOutlet weak var txtFullName: ThemeTextField!
    
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setLocalization()
       
    }
    func setLocalization() {
        txtFullName.placeholder  =  "Full Name".localized
        txtAddress.placeholder = "Address".localized
        txtRafarralCode.placeholder  =  "Invite Code".localized
        txtPostCode.placeholder = "Post Code".localized
        txtDateOfBirth.placeholder = "Date Of Birth".localized
        txtDOB.placeholder = "Date Of Birth".localized
        btnSignUp.setTitle("Submit".localized , for: .normal)
        btnmale.setTitle("Male".localized, for: .normal)
        btnFemail.setTitle("Female".localized, for: .normal)
        
    }
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gender = "male"
        self.SetLayout()
        var image = UIImage()
        if SingletonClass.sharedInstance.isFromSocilaLogin == true
        {
            self.txtFullName.text = SingletonClass.sharedInstance.strSocialFullName
            let url = URL(string: SingletonClass.sharedInstance.strSocialImage as! String)
            let data = try? Data(contentsOf: url!)
            
            if let imageData = data {
                image = UIImage(data: imageData)!
            }else {
                image = UIImage(named: "iconUser")!
            }
            
            self.imgProfile.image = image
        }
        
        
        
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
        
        let alert = UIAlertController(title: "Choose Options", message: nil, preferredStyle: .alert)
        
        let Gallery = UIAlertAction(title: "Gallery", style: .default, handler: { ACTION in
            self.PickingImageFromGallery()
        })
        let Camera  = UIAlertAction(title: "Camera", style: .default, handler: { ACTION in
            self.PickingImageFromCamera()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(Gallery)
        alert.addAction(Camera)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func PickingImageFromGallery()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [(kUTTypeImage as String)]
        
        // picker.stopVideoCapture()
//        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    
    func PickingImageFromCamera()
    {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: - Image Delegate and DataSource Methods

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgProfile.contentMode = .scaleToFill
            imgProfile.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func pickupdateMethod(_ sender: UIDatePicker)
    {
        let dateFormaterView = DateFormatter()
        dateFormaterView.dateFormat = "yyyy-MM-dd"
        txtDOB.text = dateFormaterView.string(from: sender.date)
        strDateOfBirth = txtDOB.text!
        
    }

    
    @IBAction func txtDateOfBirth(_ sender: ThemeTextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.maximumDate = Date()
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.pickupdateMethod(_:)), for: UIControlEvents.valueChanged)
        
    }
    
    
    //MARK: - Validation
    
    func checkValidation() -> Bool
    {
        if (txtFullName.text?.count == 0)
        {

            UtilityClass.setCustomAlert(title: "Missing", message: "Enter user name") { (index, title) in
            }
            return false
        }
        else if imgProfile.image!.isEqualToImage(image: UIImage(named: "icon_UserImage")!) {
            
            UtilityClass.setCustomAlert(title: "Missing", message: "Please choose profile picture") { (index, title) in
            }
            return false
        }
//        else if (txtLastName.text?.count == 0)
//        {
//
//            UtilityClass.setCustomAlert(title: "Missing", message: "Enter Last Name") { (index, title) in
//            }
//            return false
//        }
//        else if imgProfile.image == UIImage(named: "iconProfilePicBlank")
//        {
//
//            UtilityClass.setCustomAlert(title: "Missing", message: "Please choose profile picture") { (index, title) in
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
            
            UtilityClass.setCustomAlert(title: "Missing", message: "Please enter address") { (index, title) in
            }
            return false
        } else if gender == "" {
            
            UtilityClass.setCustomAlert(title: "Missing", message: "Please choose gender") { (index, title) in
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
        
        self.TapToProfilePicture()
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        
        let isplaceholder = imgProfile.image!.isEqualToImage(image: UIImage(named: "icon_UserImage")!)
        
        guard (txtFullName.text?.count != 0) || (txtAddress.text?.count != 0) || isplaceholder != true || gender != "" else {
            
            UtilityClass.setCustomAlert(title: "Missing", message: "Please enter all details") { (index, title) in
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
    
    func webServiceCallForRegister()
    {

        let dictParams = NSMutableDictionary()
        let FullName:String = self.txtFullName.text!
        var FirstName:String = ""
        var LastName:String = ""
        
        if FullName.contains(" ") {
            let arrNames = FullName.components(separatedBy: " ")
            FirstName = arrNames[0]
            if arrNames.count > 1 {
                LastName = arrNames[1]
            }
        } else {
            FirstName = FullName
        }
        
        dictParams.setObject(FirstName, forKey: "Firstname" as NSCopying)
        dictParams.setObject(" ", forKey: "Lastname" as NSCopying)
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
        
        UtilityClass.showACProgressHUD()
 
        webserviceForRegistrationForUser(dictParams, image1: imgProfile.image!) { (result, status) in
            
            
            print(result)
            
            if ((result as! NSDictionary).object(forKey: "status") as! Int == 1)
            {
                
                DispatchQueue.main.async(execute: { () -> Void in
                UtilityClass.hideACProgressHUD()
//                    self.btnSignUp.stopAnimation(animationStyle: .normal, completion: {
                    
                        SingletonClass.sharedInstance.dictProfile = NSMutableDictionary(dictionary: (result as! NSDictionary).object(forKey: "profile") as! NSDictionary)   
                        SingletonClass.sharedInstance.isUserLoggedIN = true
                        SingletonClass.sharedInstance.strPassengerID = String(describing: SingletonClass.sharedInstance.dictProfile.object(forKey: "Id")!)
//                        SingletonClass.sharedInstance.arrCarLists = NSMutableArray(array: (result as! NSDictionary).object(forKey: "car_class") as! NSArray)
//                        UserDefaults.standard.set(SingletonClass.sharedInstance.arrCarLists, forKey: "carLists")

                        UserDefaults.standard.set(SingletonClass.sharedInstance.dictProfile, forKey: "profileData")
                        self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
                   

                })
                
            }
            else
            {
//                self.btnSignUp.stopAnimation(animationStyle: .shake, revertAfterDelay: 0, completion: {
                    UtilityClass.hideACProgressHUD()
                    UtilityClass.setCustomAlert(title: "Error", message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
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
