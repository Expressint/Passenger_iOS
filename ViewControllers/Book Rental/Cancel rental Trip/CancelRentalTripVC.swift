//
//  CancelRentalTripVC.swift
//  Book A Ride
//
//  Created by Yagnik on 07/02/23.
//  Copyright © 2023 Excellent Webworld. All rights reserved.
//

import UIKit

protocol CancelRentalTripProtocol: AnyObject {
    func CancelRentalTrip(Reason: String)
}

class CancelRentalTripVC: BaseViewController {
    
    @IBOutlet weak var tblData: UITableView!
    @IBOutlet weak var txtOthers: UITextView!
    @IBOutlet weak var tblDataHeight: NSLayoutConstraint!
    @IBOutlet weak var btnCancelTrip: UIButton!
    @IBOutlet weak var vWMain: UIView!
    
    weak var delegate: CancelRentalTripProtocol?
    var arrData = ["Long pick up time","Driver delayed","No longer interested","Other"]
    var selectedReason: String?
    let placeHolder = "Enter reason here".localized
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.txtOthers.delegate = self
        self.txtOthers?.text = self.placeHolder
        self.txtOthers?.textColor = UIColor.lightGray
        
        self.vWMain.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.vWMain.layer.masksToBounds = false
        self.vWMain.layer.shadowRadius = 4
        self.vWMain.layer.borderColor = #colorLiteral(red: 0.1098039216, green: 0.4588235294, blue: 0.7333333333, alpha: 1)
        self.vWMain.layer.cornerRadius = 10
        self.vWMain.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.vWMain.layer.shadowOpacity = 0.15
        
        self.tblData.delegate = self
        self.tblData.dataSource = self
        self.tblData.separatorStyle = .none
        self.tblData.showsHorizontalScrollIndicator = false
        self.tblData.showsVerticalScrollIndicator = false
        self.tblData.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        self.registerNib()
        self.txtOthers.isHidden = true
        self.tblData.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        UIView.animate(withDuration: 0.3, delay: 0.3) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.clear
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.tblData.layer.removeAllAnimations()
        self.tblDataHeight.constant = self.tblData.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    
    func registerNib(){
        let nib = UINib(nibName: CancelRentalReasonCell.className, bundle: nil)
        self.tblData.register(nib, forCellReuseIdentifier: CancelRentalReasonCell.className)
    }
    
    @IBAction func btnCancelAction(_ sender: Any) {
        var reason = ""
        if self.selectedReason == nil {
            UtilityClass.setCustomAlert(title: "Required", message: "Please select reason to cancel trip") { (index, title) in}
        } else if self.selectedReason?.lowercased() == "other" {
            let other = self.txtOthers.text ?? ""
            if(other == "" || other == "Enter reason here".localized){
                UtilityClass.setCustomAlert(title: "Required", message: "Please enter reason to cancel trip") { (index, title) in}
            } else {
                reason = self.txtOthers.text ?? ""
            }
        } else {
            reason = self.selectedReason ?? ""
        }
        
        if reason == "" {
            return
        }
        self.delegate?.CancelRentalTrip(Reason: reason)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCloseAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CancelRentalTripVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblData.dequeueReusableCell(withIdentifier: CancelRentalReasonCell.className) as! CancelRentalReasonCell
        cell.selectionStyle = .none
        
        cell.lblReason.text = arrData[indexPath.row]
        if self.selectedReason == arrData[indexPath.row]{
            cell.imgSelected.isHidden = false
        } else {
            cell.imgSelected.isHidden = true
        }
        
        if(self.selectedReason?.lowercased() == "other"){
            self.txtOthers.isHidden = false
        } else {
            self.txtOthers.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedReason = arrData[indexPath.row]
        self.tblData.reloadData()
    }
}

extension CancelRentalTripVC : UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolder
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
}
