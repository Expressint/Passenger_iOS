//
//  UpdateProfileViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 13/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import SDWebImage
import M13Checkbox
import NVActivityIndicatorView
import ACFloatingTextfield_Swift
import IQDropDownTextField


class UpdateProfileViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,IQDropDownTextFieldDelegate {
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblEmailId: UILabel!
    @IBOutlet weak var lblContactNumber: UILabel!
    var  imgUpdatedProfilePic = UIImage()
    @IBOutlet weak var txtFirstName: UITextField!
    //    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtDateOfBirth: UITextField!
    
//    @IBOutlet weak var viewMale: M13Checkbox!
//    @IBOutlet weak var viewFemale: M13Checkbox!
    
//    @IBOutlet weak var btnSave: ThemeButton!
    
//    @IBOutlet var viewChangePassword: UIView!
    @IBOutlet var btnChangePassword: UIButton!
    @IBOutlet var btnProfile: UIButton!
    
    
    
    
    var firstName = String()
    var lastName = String()
    var fullName = String()
    var gender = String()
    
    @IBOutlet weak var viewFullName: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewMobile: UIView!
    @IBOutlet weak var viewGender: UIView!
    @IBOutlet weak var viewDateofBirth: UIView!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPhoneNum: UILabel!
    @IBOutlet weak var lblDateOfBirth: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var btnSave: ThemeButton!
    @IBOutlet var btnMale: RadioButton!
    @IBOutlet var btnFemale: RadioButton!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet var iconCamera: UIImageView!
    @IBOutlet var viewRadioGender: UIView!
//    @IBOutlet weak var btnChangePassword: UIButton!
    
    
    var isEditable = Bool()
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        txtDateOfBirth.delegate = self
     
        self.btnMale.isSelected = true
        self.txtPhoneNumber.isUserInteractionEnabled = false
 
//        self.setShadowToTextFieldView(txtField: txtFirstName)
//        self.setShadowToTextFieldView(txtField: txtAddress)
//        self.setShadowToTextFieldView(txtField: txtPhoneNumber)
//        self.setShadowToTextFieldView(txtField: txtDateOfBirth)
        
        
        UtilityClass.setLeftPaddingInTextfield(textfield: txtFirstName, padding: 10)
        UtilityClass.setLeftPaddingInTextfield(textfield: txtAddress, padding: 10)
        UtilityClass.setLeftPaddingInTextfield(textfield: txtPhoneNumber, padding: 10)
        UtilityClass.setLeftPaddingInTextfield(textfield: txtDateOfBirth, padding: 10)
        
        UtilityClass.setRightPaddingInTextfield(textfield: txtFirstName, padding: 10)
        UtilityClass.setRightPaddingInTextfield(textfield: txtAddress, padding: 10)
        UtilityClass.setRightPaddingInTextfield(textfield: txtPhoneNumber, padding: 10)
        UtilityClass.setRightPaddingInTextfield(textfield: txtDateOfBirth, padding: 10)
        
        
//        viewRadioGender.layer.cornerRadius = 2
//        viewRadioGender.layer.shadowRadius = 3.0
//        viewRadioGender.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
//        viewRadioGender.layer.shadowOffset = CGSize (width: 1.0, height: 1.0)
//        viewRadioGender.layer.shadowOpacity = 1.0
        
//        btnSave.layer.cornerRadius = 5
//        btnSave.layer.masksToBounds = true
//          setViewWillAppear()
        
            setData()
            setLocalization()
            self.setNavBarWithBack(Title: "Profile".localized, IsNeedRightButton: true)
        }
//
    func setShadowToTextFieldView(txtField : UITextField)
    {
        txtField.layer.cornerRadius = 2
        txtField.layer.shadowRadius = 3.0
        txtField.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
        txtField.layer.shadowOffset = CGSize (width: 1.0, height: 1.0)
        txtField.layer.shadowOpacity = 1.0
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imgProfile.layer.cornerRadius = imgProfile.frame.width / 2
        imgProfile.layer.borderWidth = 1.0
        imgProfile.layer.borderColor = themeYellowColor.cgColor
        imgProfile.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    
    func setLocalization()
    {
       
        lblFullName.text = "Full Name".localized
        lblAddress.text = "Address".localized
        lblPhoneNum.text = "Phone Number".localized
        lblDateOfBirth.text =  "Date Of Birth".localized
        lblGender.text = "Gender".localized
        btnSave.setTitle("Save".localized, for: .normal)
        btnMale.setTitle("Male".localized, for: .normal)
        btnFemale.setTitle("Female".localized, for: .normal)
        btnChangePassword.setTitle("Change Password".localized, for: .normal)
    }


    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------

//    @IBAction func btnMale(_ sender: UIButton) {
//
//        viewMale.checkState = .checked
//        viewMale.tintColor = themeYellowColor
//        viewFemale.checkState = .unchecked
//
//        gender = "Male"
//    }
//    @IBAction func btnFemale(_ sender: UIButton) {
//
//        viewFemale.checkState = .checked
//        viewFemale.tintColor = themeYellowColor
//        viewMale.checkState = .unchecked
//
//        gender = "Female"
//    }
   
    @IBAction func txtDateOfBirthAction(_ sender: UITextField) {


        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.pickupdateMethod(_:)), for: UIControlEvents.valueChanged)
    }

    @objc func pickupdateMethod(_ sender: UIDatePicker)
    {
        let dateFormaterView = DateFormatter()
        dateFormaterView.dateFormat = "yyyy-MM-dd"
        
        txtDateOfBirth.text = dateFormaterView.string(from: sender.date)
    }
    func textField(_ textField: IQDropDownTextField, didSelect date: Date?)
    {
        

    }
    @IBAction func btnChangePassword(_ sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        self.navigationController?.pushViewController(next, animated: true)

    }
    
    
    @IBAction func btnSubmit(_ sender: ThemeButton) {
    
        if txtAddress.text == "" || txtFirstName.text == "" || gender == "" {
            
            
            UtilityClass.setCustomAlert(title: "Misssing", message: "Please fill all details".localized) { (index, title) in
            }
        }
        else
        {
            webserviceOfUpdateProfile()
        }
        
    }
    
    @IBAction func btnUploadImage(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Choose Image From", message: nil, preferredStyle: .actionSheet)
        
        let Camera = UIAlertAction(title: "Camera", style: .default, handler: { ACTION in
            
            self.PickingImageFromCamera()
        })
        
        let Gallery = UIAlertAction(title: "Gallery", style: .default, handler: { ACTION in
            
             self.PickingImageFromGallery()
        })
        
        let Cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(Camera)
        alert.addAction(Gallery)
        alert.addAction(Cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func PickingImageFromGallery()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        // picker.stopVideoCapture()
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    func PickingImageFromCamera()
    {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        
        present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgProfile.contentMode = .scaleToFill
            imgProfile.image = pickedImage
            self.imgUpdatedProfilePic = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
    func setData()
    {
        
        let getData = SingletonClass.sharedInstance.dictProfile
        
        imgProfile.sd_setShowActivityIndicatorView(true)
        imgProfile.sd_setIndicatorStyle(.whiteLarge)
        imgProfile.sd_setImage(with: URL(string: getData.object(forKey: "Image") as! String), completed: nil)
        
        txtPhoneNumber.text = getData.object(forKey: "MobileNo") as? String
        txtDateOfBirth.text = getData.object(forKey: "DOB") as? String
        

        fullName = getData.object(forKey: "Fullname") as! String
  
        let fullNameArr = fullName.components(separatedBy: " ")
        
        firstName = fullNameArr[0]
        lastName = fullNameArr[1]

        txtFirstName.text = fullName
        txtAddress.text = getData.object(forKey: "Address") as? String
        
        gender = getData.object(forKey: "Gender") as! String
        
        if gender == "male" || gender == "Male" {
            self.btnMale.isSelected = true
        }
        else {
            self.btnFemale.isSelected = true
        }
    }

    
    @IBAction func btnMaleFemaleClicked(_ sender: UIButton)
    {
        
        if sender.titleLabel?.text == "Female"
        {
            gender = "Female"
        }
        else
        {
            gender = "Male"
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    func webserviceOfUpdateProfile()
    {
        fullName = txtFirstName.text! // + " " + txtLastName.text!
        
        var dictData = [String:AnyObject]()
        dictData["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
        dictData["Fullname"] = fullName as AnyObject
        dictData["Gender"] = gender as AnyObject
        dictData["Address"] = txtAddress.text as AnyObject
        dictData["DOB"] = txtDateOfBirth.text as AnyObject
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        
        webserviceForUpdateProfile(dictData as AnyObject, image1: self.imgUpdatedProfilePic ) { (result, status) in
            
            if (status) {
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
                print(result)
                SingletonClass.sharedInstance.dictProfile = NSMutableDictionary(dictionary: (result as! NSDictionary).object(forKey: "profile") as! NSDictionary)
                
                UserDefaults.standard.set(SingletonClass.sharedInstance.dictProfile, forKey: "profileData")
                
                NotificationCenter.default.post(name: UpdateProfileNotification, object: nil)
               
                UtilityClass.setCustomAlert(title: "Done", message: "Your profile updated successfully".localized) { (index, title) in
                    self.navigationController?.popViewController(animated: true)
                }
                
                
            }
            else {
                print(result)
            }
        }
    }
    
    
}
