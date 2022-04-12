//
//  CancelAlertViewController.swift
//  Book A Ride
//
//  Created by Rahul Patel on 27/01/22.
//  Copyright © 2022 Excellent Webworld. All rights reserved.
//

import UIKit

class CancelAlertViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate {
  
    var arrReasons = ["Long pick up time","Driver delayed","No longer interested","Other"]
    var arrHelpOptions = [[String:Any]]()
    @IBOutlet weak var txtReasons : UITextView?
    @IBOutlet weak var txtDescription : UITextView?
    @IBOutlet weak var lblLongDescription : UILabel?
    @IBOutlet weak var lblShortDescription : UILabel?
    var pickerController : UIPickerView?
    var isHelp = false
    var okPressedClosure : ((String) -> ()) = {reason in }
    let placeHolder = "Enter reason here"
    
    //MARK: - Setup Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        pickerController = UIPickerView()
        pickerController?.delegate = self
        pickerController?.dataSource = self
        txtDescription?.isHidden = true
        txtDescription?.delegate = self
        txtReasons?.inputView = pickerController
        txtReasons?.delegate = self
//        UtilityClass.setLeftPaddingInTextfield(textfield: txtReasons ?? UITextField(), padding: 10)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.50)
        
        
        
        txtDescription?.text = placeHolder
        txtDescription?.textColor = UIColor.lightGray

        
        if(isHelp)
        {
            self.webserviceCallForReasonsForHelp()
            lblLongDescription?.text = ""
            lblShortDescription?.text = "Please Select Help Reason"
        }
        else
        {
            txtReasons?.text = arrReasons.first

            lblLongDescription?.text = "Dear Customer. To Keep Our Driver Motivated. Please Note That Cancelling  a Trip 3 Mins After Booking Attracts A Fee of 50 Payable To The Driver. Please Confirm Whether You Still Wish To Cancel?"
            lblShortDescription?.text = "Please Select Cancel Reason"
        }
    }
    
    
    
    //MARK: - Picker Methods

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(isHelp)
        {
            return arrHelpOptions.count
        }
        return arrReasons.count

    }
  
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(isHelp)
        {
            return (arrHelpOptions[row])["HelpOption"] as? String
        }
        return arrReasons[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtReasons?.centerVertically()
        if(isHelp)
        {
            txtReasons?.text = (arrHelpOptions[row])["HelpOption"] as? String
        }
        else
        {
            txtReasons?.text = arrReasons[row]
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 44));
        label.lineBreakMode = .byWordWrapping;
        label.numberOfLines = 0;
        
        if(isHelp)
        {
            label.text = (arrHelpOptions[row])["HelpOption"] as? String
        }
        else
        {
            label.text = arrReasons[row]
        }
        label.sizeToFit()
        return label;
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 80
    }
    
    
    //MARK: - Textview Methods
    
    func textViewDidEndEditing(_ textView: UITextView) {
        txtDescription?.isHidden = true
        if(txtReasons?.text?.lowercased() == "other")
        {
            if(textView == txtDescription)
            {
                if textView.text.isEmpty {
                    textView.text = "Placeholder"
                    textView.textColor = UIColor.lightGray
                }
            }
            txtDescription?.isHidden = false
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView == txtDescription)
        {
            if textView.textColor == UIColor.lightGray {
                textView.text = nil
                textView.textColor = UIColor.black
            }
        }
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        txtDescription?.isHidden = true
//        if(txtReasons?.text?.lowercased() == "other")
//        {
//            txtDescription?.isHidden = false
//        }
//    }
    
    
    //MARK: - IBActions
    
    @IBAction func btnOkPressed(_ sender : UIButton)
    {
        if(isHelp)
        {
            webserviceCallForSubmitHelpRequest()
        }
        else
        {
            okPressedClosure(txtReasons?.text ?? "")
        }
    }
    
    @IBAction func btnCancelPressed(_ sender : UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Webservice Calls

    func webserviceCallForReasonsForHelp()
    {
        UtilityClass.showHUD()
        webserviceForHelpOptions("" as AnyObject) { response, status in
            UtilityClass.hideHUD()
            if(status)
            {
                
                DispatchQueue.main.async {
                    self.arrHelpOptions = (response as? [String:Any])?["data"] as? [[String:Any]] ?? []
                    self.txtReasons?.text = self.arrHelpOptions.first?["HelpOption"] as? String ?? ""
                    self.pickerController?.reloadAllComponents()
                }
            }
        }
    }
    
    func webserviceCallForSubmitHelpRequest()
    {
        UtilityClass.showHUD()
        var dictData = [String:Any]()
        dictData["PassengerId"] =  SingletonClass.sharedInstance.strPassengerID
        
        let index = pickerController?.selectedRow(inComponent: 0) as? Int
        dictData["HelpId"] =  (arrHelpOptions[index ?? 0])["Id"] as? String
        dictData["Notes"] =  txtDescription?.text
        
        webserviceForSendingHelpRequest(dictData as AnyObject) { result, success in
            if(success)
            {
                self.dismiss(animated: false)
                UtilityClass.showAlert(appName, message: result["message"] as? String ?? "", vc: self)
//                print("Hello")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UITextView {
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}
