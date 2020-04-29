//
//  FavoriteViewController.swift
//  TickTok User
//
//  Created by Excelent iMac on 13/12/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit


class FavoriteViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    var labelNoData = UILabel()
    var aryAddress = [[String:AnyObject]]()
    var delegateForFavourite: FavouriteLocationDelegate!
    
    @IBOutlet weak var lblSwipeRightToLeftForRemoveAddress: UILabel!

    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webserviceOfGetAddress()
        
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setLocalization()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func setLocalization()
    {
        lblSwipeRightToLeftForRemoveAddress.text = "Please Swape Right To Left for remove address.".localized
    }
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var tableView: UITableView!
    

    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func setData() {
        
        self.labelNoData = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.labelNoData.text = "No Favourite Location Found!"
        self.labelNoData.textAlignment = .center
        self.view.addSubview(self.labelNoData)
        
    }
    
    //-------------------------------------------------------------
    // MARK: - TableView Methods
    //-------------------------------------------------------------
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryAddress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dataDict = aryAddress[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFavouriteTableViewCell") as! MyFavouriteTableViewCell
        cell.selectionStyle = .none
        if let address = dataDict["Address"] as? String {
            cell.lblItemTitle.text = address

        }
        if let iconType = dataDict["Type"] as? String {
            cell.imgItem.image = UIImage(named: setIconType(str: iconType))
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         let dataDict = aryAddress[indexPath.row]
        
        if (dataDict["Address"] as? String) != nil {
            
            var dict = [String:AnyObject]()
            dict["Address"] = dataDict["Address"] as AnyObject
            dict["Lat"] = dataDict["Lat"] as AnyObject
            dict["Lng"] = dataDict["Lng"] as AnyObject
            
            delegateForFavourite?.didEnterFavouriteDestination(Source: dict)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let selectedData = aryAddress[indexPath.row]
        
        if editingStyle == .delete {
            
            if let selectedID = selectedData["Id"] as? String {
            
                tableView.beginUpdates()
                aryAddress.remove(at: indexPath.row)
                webserviceOfDeleteAddress(addressID: selectedID)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
                
                if aryAddress.count == 0 {
                    let dict = [String:AnyObject]()
                    delegateForFavourite?.didEnterFavouriteDestination(Source: dict)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func setIconType(str: String) -> String {
        
        var iconType = String()
        
        switch str {
        case "Home":
            iconType = "iconHome"
            return iconType
        case "Office":
            iconType = "iconOffice"
            return iconType
        case "Airport":
            iconType = "iconAirport"
            return iconType
        case "Others":
            iconType = "iconOthers"
            return iconType
        default:
            return ""
        }
        
    }
    
 
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    func webserviceOfGetAddress() {
        
        webserviceForGetAddress(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                if let res = result as? NSDictionary {
                    if let address = res["address"] as? [[String:AnyObject]] {
                        self.aryAddress = address
                        
                        self.tableView.reloadData()
                    }
                }
                
                if self.aryAddress.count == 0 {
                    self.setData()
                }
            }
            else {
                print(result)
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
            }
        }
    }
    
    
    
    func webserviceOfDeleteAddress(addressID: String) {
        
//        PassengerId,AddressId
        
        var params = String()
        params = "\(SingletonClass.sharedInstance.strPassengerID)/\(addressID)"
        
        webserviceForDeleteAddress(params as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "Deleted Record", message: res) { (index, title) in
                    }
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "Deleted Record", message: resDict.object(forKey: "message") as! String) { (index, title) in
                    }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "Deleted Record", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    }
                }
            }
            else {
                print(result)
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
                
            }
            
        }
    }

}
//{
//    "status": true,
//    "address": [
//    {
//    "Id": "17",
//    "PassengerId": "36",
//    "Type": "Office",
//    "Address": "Iscon Mega Mall, Ahmedabad, Gujarat, India",
//    "Lat": "23.030513",
//    "Lng": "72.5075401"
//    },
//    {
//    "Id": "18",
//    "PassengerId": "36",
//    "Type": "Home",
//    "Address": "Sarkhej - Gandhinagar Hwy, Bodakdev, Ahmedabad, Gujarat 380054, India",
//    "Lat": "23.0728324268082",
//    "Lng": "72.5165691220586"
//    }
//    ]
//}

