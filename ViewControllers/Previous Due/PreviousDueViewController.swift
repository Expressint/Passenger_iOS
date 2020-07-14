//
//  PreviousDueViewController.swift
//  Peppea
//
//  Created by EWW074 on 03/01/20.
//  Copyright © 2020 Mayur iMac. All rights reserved.
//

import UIKit
//import SwiftyJSON

class PreviousDueViewController: BaseViewController {
    
    

    @IBOutlet weak var tableView: UITableView!
    
    var aryData = [[String : Any]]()
    var model = [String : Any]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavBarWithBack(Title: "Previous Due".localized, IsNeedRightButton: false)

//        setNavBarWithBack(Title: "Previous Due", IsNeedRightButton: true)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        webserviceForPreviousDue()
    }
    
    @objc func btnPayAction(sender: UIButton) {
        
        print("Pay Action")
        let dictData = aryData[sender.tag][""] as? [String:Any]
        let str = dictData?["Id"]
        model["PastDuesId"] = str
        webserviceForPaymentPreviousDue()

    }

    func webserviceForPreviousDue() {
        
        
        var dictParam = [String:Any]()
        dictParam["PassengerId"] = SingletonClass.sharedInstance.strPassengerID
        
        webserviceForPastDuesList(dictParam as AnyObject, completion: { (response, status) in
            
            if status {
                if let res = response["data"] as? [String:Any]
                {
                    self.aryData = [res]
                }
            } else {
                UtilityClass.showAlert("", message: response["message"] as? String ?? "Something went wrong", vc: self)
            }
            
            self.tableView.reloadData()
            
        })
        
        
    }
    
    func webserviceForPaymentPreviousDue() {
        UtilityClass.showHUD()//showHUD(with: UIApplication.shared.keyWindow)
        
//        var dictParams = [String : Any]()
//        dictParams["PastDuesId"] = ""
//        dictParams["CardId"] = ""
        
        webserviceToPayPastDue(model as AnyObject) { (response, status) in
            UtilityClass.hideHUD()
            if status {
                
                UtilityClass.showAlert("", message: (response["message"] as? String) ?? "", vc: self)
                
             
                
            } else {
              UtilityClass.showAlert("", message: (response["message"] as? String) ?? "", vc: self)
            }
            
        }
    }
}


extension PreviousDueViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(aryData.count == 0)
        {
//            self.tableView.backgroundView = UtilityClass.EmptyMessage(message: "No Due Payments", viewController: self)
            self.tableView.separatorStyle = .none
            return 0
        }
        self.tableView.backgroundView = UIView()
        return aryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "PreviousDueTableViewCell", for: indexPath) as! PreviousDueTableViewCell
        cell.selectionStyle = .none
        let currentItem = aryData[indexPath.row][""] as? [String:Any]
        cell.setupData(object: currentItem?["booking_details"] as! [String : Any])
        cell.btnPay.tag = indexPath.row
//        model["booking_id"] = currentItem["bookingId"]
        cell.btnPay.addTarget(self, action: #selector(self.btnPayAction(sender:)), for: .touchUpInside)
        return cell
    }
}


