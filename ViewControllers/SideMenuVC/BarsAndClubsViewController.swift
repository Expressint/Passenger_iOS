//
//  BarsAndClubsViewController.swift
//  TickTok User
//
//  Created by Excelent iMac on 13/12/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import SDWebImage
import CoreLocation

class BarsAndClubsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    
    
    var latitude = Double()
    var longitude = Double()
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        let coordinate₀ = CLLocation(latitude: Double(SingletonClass.sharedInstance.currentLatitude)!, longitude: Double(SingletonClass.sharedInstance.currentLongitude)!)
        let coordinate₁ = CLLocation(latitude: 5.0, longitude: 3.0)
        
        let distanceInMeters = coordinate₀.distance(from: coordinate₁) // result is in meters
        
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        webserviceOfBarAndClubs()
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BarsAndClubsTableViewCell") as! BarsAndClubsTableViewCell
        cell.selectionStyle = .none
        
        if let imgUrl = params["icon"] as? String {
            cell.imgItems.sd_setShowActivityIndicatorView(true)
            cell.imgItems.sd_setIndicatorStyle(.gray)
            cell.imgItems.sd_setImage(with: URL(string: imgUrl), completed: nil)
            
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
        
        if let rating = params["rating"] as? Float {
            cell.ratingView.rating = rating
        }
        else {
            cell.ratingView.rating = 0.0
        }
        
        
        cell.itemTitle.text = params["name"] as? String
        cell.lblAddress.text = params["vicinity"] as? String
        
        
        
//        cell.lblDistanceKM.text =
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let BookCarNow = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Book Car Now") { (action , indexPath ) -> Void in
            
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
    
    func webserviceOfBarAndClubs() {
        
//        let urlOFbarAndClubs = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=23.072664,72.516199&radius=5000&type=bar&key=AIzaSyCRaduVCKdm1ll3kHPY-ebtvwwPV2VVozo"
        
       
        if SingletonClass.sharedInstance.currentLatitude == "" || SingletonClass.sharedInstance.currentLongitude == "" {

            UtilityClass.setCustomAlert(title: "Location Not Found", message: "Your Current Location Not Found") { (index, title) in
            }
            
        }
        else {
            let creentLocation = "\(SingletonClass.sharedInstance.currentLatitude),\(SingletonClass.sharedInstance.currentLongitude)"
            let type = "bar"
            
            webserviceForBarsAndTaxis("" as AnyObject, Location: creentLocation, Type: type) { (result, status) in
                
                if status {
                    print(result)
                    let dataOfNews = (result as! [String:AnyObject])
                    
                    self.aryBarsAndClubs = dataOfNews["results"] as! [[String:AnyObject]]
                    
                    self.tableView.reloadData()
                }
                else {
                    print(result)
                }
            }
        }
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func pickingToBookNow() {
        
    }
    
    func pickingToBookLater() {
        
    }
/*
    func data() {
        ["geometry": {
            location =     {
                lat = "23.046417";
                lng = "72.53102539999999";
            };
            viewport =     {
                northeast =         {
                    lat = "23.0477659802915";
                    lng = "72.5323743802915";
                };
                southwest =         {
                    lat = "23.0450680197085";
                    lng = "72.52967641970848";
                };
            };
            }, "icon": https://maps.gstatic.com/mapfiles/place_api/icons/school-71.png, "reference": CmRSAAAARG3Vmw7wafb6Y-iDO2dZvc2nGwpnkU2PFhr2RYj1Z97l_jvqI6AiwSFDeJHTR9Wdk-0Q_-edUJqk3pSofdZmb4RzOJAiWCCJ6Y-7R3_XtGdSofwSO_f-bnmhQ_fElVffEhANPO7ka4NQi5bvJF-1IkeyGhQdMGa_d9A1C2ra3UeswMwG_qZ_yA, "name": Kush Banker, "id": e7a5484c2a21983f7a669a7983c0ba98fab182b1, "types": <__NSArrayI 0x107be5f90>(
            night_club,
            bar,
            point_of_interest,
            establishment
            )
            , "place_id": ChIJ-f3F5q-EXjkRVDMmIH9Kk_E, "rating": 4.7, "scope": GOOGLE, "opening_hours": {
                "open_now" = 1;
                "weekday_text" =     (
                );
            }, "vicinity": Drive In Road, Nilmani Society, Gurukul, Ahmedabad, "photos": <__NSSingleObjectArrayI 0x10f605300>(
            {
            height = 3456;
            "html_attributions" =     (
            "<a href=\"https://maps.google.com/maps/contrib/111277320969678676825/photos\">Kush Banker Dance Classes and Academy</a>"
            );
            "photo_reference" = "CmRaAAAAZOqBgV_Mf341YpJGi4Tv77mq93aYrbHSNxmU6K_1Imgw8fESNo-cme7UCbxzWroDz3SnG0cuF-b_IN0_4fut94T0H_xVgjSPy5-dZvxa01Gdiqc0iEVqUDA-ntpUrVe3EhDapvHrPj5NOpBWoZkGH3hVGhR3MS15_MoVxQSYj9oKd2P36mlL3A";
            width = 5184;
            }
            )
        ]
    }
  */
    
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

