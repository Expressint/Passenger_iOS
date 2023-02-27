//
//  DurationPopupVC.swift
//  Book A Ride
//
//  Created by Yagnik on 04/01/23.
//  Copyright © 2023 Excellent Webworld. All rights reserved.
//

import UIKit
import Protobuf

protocol DurationProtocol: AnyObject {
    func selectedDuration(id: Int, Name: String)
}

class DurationPopupVC: BaseViewController {

    @IBOutlet weak var vWMain: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var lblIntro: UILabel!
    
    @IBOutlet weak var lblSelectPackage: UILabel!
    
    weak var delegate: DurationProtocol?
    var modelSelected: Int?
    var arrData = [[String:Any]]()
    var duratonId: String = ""
    var duratonName: String = ""
    var strSelectedModel: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        UIView.animate(withDuration: 0.3, delay: 0.3) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
        self.setLocalization()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.clear
    }
    
    @objc func changeLanguage(){
        self.setLocalization()
    }
    func setLocalization(){
        self.lblSelectPackage.text = "Please select a suitable package".localized
        self.btnCancel.setTitle("Cancel".localized, for: .normal)
    }
  
    func prepareView() {
        self.setupUI()
        self.setupData()
    }
    
    func setupUI() {
        self.vWMain.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.vWMain.layer.masksToBounds = false
        self.vWMain.layer.shadowRadius = 4
        self.vWMain.layer.borderColor = #colorLiteral(red: 0.1098039216, green: 0.4588235294, blue: 0.7333333333, alpha: 1)
        self.vWMain.layer.cornerRadius = 10
        self.vWMain.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.vWMain.layer.shadowOpacity = 0.15
        self.btnConfirm.setTitle("\("Confirm".localized) \(strSelectedModel) \("Tour".localized)", for: .normal)
    }
    
    func setupData() {
        self.webserviceCallForModelPackages()
    }
    
    func setIntroText(amount: String, cancelAmount: String) {
        lblIntro.text = "\("Extra time will be charged to you at".localized) $\(amount) \("per minute".localized). \("Cancellation fees charged to you at".localized) $\(cancelAmount), \("If you cancel trip, after driver accept ride".localized)."
    }

    @IBAction func btnCancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnConfirmAction(_ sender: Any) {
        if(duratonId == ""){
            duratonId = arrData[0]["Id"] as? String ?? ""
            self.duratonName = "\(arrData[0]["MinimumHours"] as? String ?? "") hrs/\(arrData[0]["MinimumKm"] as? String ?? "") km $\(arrData[0]["MinimumAmount"] as? String ?? "")"
        }
        self.dismiss(animated: true, completion: {
            self.delegate?.selectedDuration(id: Int(self.duratonId) ?? 0, Name: self.duratonName)
        })
    }
    
    @IBAction func btnTapOutSideAction(_ sender: Any) {
       // self.dismiss(animated: true, completion: nil)
    }
}

extension DurationPopupVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if  pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = "\(arrData[row]["MinimumHours"] as? String ?? "") hrs/\(arrData[row]["MinimumKm"] as? String ?? "") km $\(arrData[row]["MinimumAmount"] as? String ?? "")"
        pickerLabel?.textColor = UIColor.black
        return pickerLabel!
    }
        
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrData.count
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(arrData[row]["MinimumHours"] as? String ?? "") hrs/\(arrData[row]["MinimumKm"] as? String ?? "") km $\(arrData[row]["MinimumAmount"] as? String ?? "")"
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.duratonId = arrData[row]["Id"] as? String ?? ""
        self.duratonName = "\(arrData[row]["MinimumHours"] as? String ?? "") hrs/\(arrData[row]["MinimumKm"] as? String ?? "") km $\(arrData[row]["MinimumAmount"] as? String ?? "")"
    }
        
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
}

extension DurationPopupVC {
    func webserviceCallForModelPackages()
    {
        UtilityClass.showHUD()
        var dictData = [String:Any]()
        dictData["ModelId"] =  self.modelSelected
        
        webserviceForModelPackages(dictData as AnyObject) { result, success in
            if(success) {
                let resultData = (result as! NSDictionary)
                let amount = resultData.object(forKey: "ChargeByTime") as? String ?? "0"
                let CancelAmount = resultData.object(forKey: "ChargeByCancelled") as? String ?? "0"
                self.setIntroText(amount: amount, cancelAmount: CancelAmount)
                self.arrData = (result as? [String:Any])?["data"] as? [[String:Any]] ?? []
                self.pickerView.reloadAllComponents()
            } else {
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "Error", message: res) { (index, title) in}
                } else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "Error", message: resDict.object(forKey: GetResponseMessageKey()) as! String) { (index, title) in }
                } else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: GetResponseMessageKey()) as! String) { (index, title) in }
                }
            }
        }
    }
}
