//
//  BookTableSelectedDataViewController.swift
//  TickTok User
//
//  Created by Excelent iMac on 13/12/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import CoreLocation

class BookTableSelectedDataViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    var latitude = Double()
    var longitude = Double()
    
    
    var selectedString = String()
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        webserviceOfBarAndClubs(str: selectedString)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //-------------------------------------------------------------
    // MARK: - TableView Methods
    //-------------------------------------------------------------
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryBarsAndClubs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let params = aryBarsAndClubs[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableSelectedDataTableViewCell") as! BookTableSelectedDataTableViewCell
        cell.selectionStyle = .none
        
        if let imgUrl = params["icon"] as? String {
            cell.imgItems.sd_setShowActivityIndicatorView(true)
            cell.imgItems.sd_setIndicatorStyle(.gray)
            cell.imgItems.sd_setImage(with: URL(string: imgUrl), completed: nil)
        }
        
        cell.itemTitle.text = params["name"] as? String
        cell.lblAddress.text = params["vicinity"] as? String
        
        if let rating = params["rating"] as? Float {
            cell.ratingView.rating = rating
        }
        else {
            cell.ratingView.rating = 0.0
        }
        
        if let geometry = params["geometry"] as? NSDictionary {
            
            if let locat = geometry.object(forKey: "location") as? NSDictionary {
                if let lati = locat.object(forKey: "lat") as? Double {
                    self.latitude = lati
                }
                if let longi = locat.object(forKey: "lng") as? Double {
                    self.longitude = longi
                }
            }
            
            let coordinate₀ = CLLocation(latitude: Double(SingletonClass.sharedInstance.currentLatitude)!, longitude: Double(SingletonClass.sharedInstance.currentLongitude)!)
            let coordinate₁ = CLLocation(latitude: self.latitude, longitude: self.longitude)
            
            let distanceInMeters = coordinate₀.distance(from: coordinate₁) // result is in meters
            
            if distanceInMeters >= 1000 {
                
                let km = (distanceInMeters / 1000)
                
                cell.lblDistanceKM.text = "\(km.rounded(toPlaces: 2)) km"
            }
            else {
                cell.lblDistanceKM.text = "\(distanceInMeters.rounded(toPlaces: 2)) m"
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let BookCarNow = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Book Car Now") { (action , indexPath ) -> Void in
            
            self.isEditing = false
            print("Book Car Now")
            
            let params = self.aryBarsAndClubs[indexPath.row]
            
            var dictParam = [String:AnyObject]()
            
            if let address = params["vicinity"] as? String {
                dictParam["Address"] = address as AnyObject
            }
            else if let address = params["formatted_address"] as? String {
                dictParam["Address"] = address as AnyObject
            }
            
            if let geometry = params["geometry"] as? NSDictionary {
                
                if let locat = geometry.object(forKey: "location") as? NSDictionary {
                    if let lati = locat.object(forKey: "lat") as? Double {
                        
                        dictParam["lat"] = lati as AnyObject
                    }
                    if let longi = locat.object(forKey: "lng") as? Double {
                        
                        dictParam["lng"] = longi as AnyObject
                    }
                }
            }
            
            NotificationCenter.default.post(name: NotificationBookNow, object: nil, userInfo: dictParam)
            
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: CustomSideMenuViewController.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        
            
//        ((self.navigationController?.childViewControllers[1] as! CustomSideMenuViewController).childViewControllers[0] as! UINavigationController).popViewController(animated: true)
            
//            let next = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            
//            ((self.navigationController?.childViewControllers[1] as! CustomSideMenuViewController).childViewControllers[0] as! UINavigationController).popViewController(animated: true)
            
//            for controller in ((self.navigationController?.childViewControllers[1] as! CustomSideMenuViewController).childViewControllers[0] as! UINavigationController).viewControllers as Array {
//                if controller.isKind(of: HomeViewController.self) {
//                    self.navigationController!.popToViewController(controller, animated: true)
//                    break
//                }
//            }
            
            
//            self.navigationController?.popToViewController(((self.navigationController?.childViewControllers[1] as! CustomSideMenuViewController).childViewControllers[0] as! UINavigationController).childViewControllers[0] as! HomeViewController, animated: true)
            
        }
        
        
        let BookCarLater = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Book Car Later") { (action , indexPath) -> Void in
            self.isEditing = false
            print("Book Car Later")
            
            let params = self.aryBarsAndClubs[indexPath.row]
            var dictParam = [String:AnyObject]()
            
            if let address = params["vicinity"] as? String {
                dictParam["Address"] = address as AnyObject
            }
            else if let address = params["formatted_address"] as? String {
                dictParam["Address"] = address as AnyObject
            }
            
            if let geometry = params["geometry"] as? NSDictionary {
                if let locat = geometry.object(forKey: "location") as? NSDictionary {
                    if let lati = locat.object(forKey: "lat") as? Double {
                        
                        dictParam["lat"] = lati as AnyObject
                    }
                    if let longi = locat.object(forKey: "lng") as? Double {
                        
                        dictParam["lng"] = longi as AnyObject
                    }
                }
            }
            
            NotificationCenter.default.post(name: NotificationBookLater, object: nil, userInfo: dictParam)
            SingletonClass.sharedInstance.isFromNotificationBookLater = true
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: CustomSideMenuViewController.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }
        
        BookCarLater.backgroundColor = UIColor.black
        return [BookCarLater,BookCarNow]
    }
    
    
    var aryBarsAndClubs = [[String:AnyObject]]()
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    func webserviceOfBarAndClubs(str: String) {
        
        if SingletonClass.sharedInstance.currentLatitude == "" || SingletonClass.sharedInstance.currentLongitude == "" {

            UtilityClass.setCustomAlert(title: "Location Not Found", message: "Your Current Location Not Found") { (index, title) in
            }
        }
        else {
            let creentLocation = "\(SingletonClass.sharedInstance.currentLatitude),\(SingletonClass.sharedInstance.currentLongitude)"
            let type = "restaurant"
            
            
            webserviceForBookTable("" as AnyObject, Location: creentLocation, Type: type, ItemType: str, completion: { (result, status) in
                
                if (status) {
                    print(result)
                    let dataOfNews = (result as! [String:AnyObject])
                    
                    self.aryBarsAndClubs = dataOfNews["results"] as! [[String:AnyObject]]
                    
                    self.tableView.reloadData()
                }
                else {
                    print(result)
                }
            })
        
        }
    
    }
}

