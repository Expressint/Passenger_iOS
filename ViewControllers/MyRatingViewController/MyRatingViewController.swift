//
//  MyFeedbackviewController.swift
//  TEXLUXE-DRIVER
//
//  Created by Excellent WebWorld on 02/08/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit
import SideMenuController


class MyRatingViewController: BaseViewController,UITableViewDataSource, UITableViewDelegate
{
    

    @IBOutlet var tblview: UITableView!
    var aryData = NSArray()
    var labelNoData = UILabel()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
       
        self.tblview.dataSource = self
        self.tblview.delegate = self
        
        
        self.tblview.tableFooterView = UIView()
//        SideMenuController.preferences.SideMenuController.preferences.interaction.swipingEnabled = false


        labelNoData = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.labelNoData.text = "Loading..."
        labelNoData.textAlignment = .center
        self.view.addSubview(labelNoData)
        self.tblview.isHidden = true
        
        self.tblview.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        
       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
         self.webserviceForMyFeedbackList()
         self.setNavBarWithBack(Title: "My Ratings".localized, IsNeedRightButton: true)
        
    }
    override func didReceiveMemoryWarning()
    {
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
    
    //-------------------------------------------------------------
    // MARK: - TableView Methods
    //-------------------------------------------------------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //        if section == 0 {
        //
        //            if aryData.count == 0 {
        //                return 1
        //            }
        //            else {
        //                return aryData.count
        //            }
        //        }
        //        else {
        //            return 1
        //        }
        
        return aryData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRatingViewCell") as! MyRatingViewCell
        //        let cell2 = tableView.dequeueReusableCell(withIdentifier: "NoDataFound") as! FutureBookingTableViewCell
        cell.lblCommentTitle.text = "Comments".localized
        cell.lblPickUpAddress.text = "First Description".localized
        cell.lblDropUpAddress.text = "Second Description".localized
        cell.selectionStyle = .none
        
        cell.viewCell.layer.cornerRadius = 10
        cell.viewCell.clipsToBounds = true
        cell.viewCell.layer.shadowRadius = 3.0
        cell.viewCell.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        cell.viewCell.layer.shadowOffset = CGSize (width: 1.0, height: 1.0)
        cell.viewCell.layer.shadowOpacity = 1.0

        
        cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.width / 2
        cell.imgProfile.clipsToBounds = true
        cell.imgProfile.layer.borderColor = themeYellowColor.cgColor
        cell.imgProfile.layer.borderWidth = 1.0

        let data = aryData.object(at: indexPath.row) as! NSDictionary
        //
        
        let strURL = "\(WebserviceURLs.kImageBaseURL)\(data.object(forKey: "DriverImage") as! String)"
        
        cell.imgProfile.sd_setImage(with: URL(string: strURL), completed: nil)
        
        cell.lblPassengerName.text = data.object(forKey: "DriverName") as? String
        //
        //
        ////
        cell.lblDropUpAddress.text = (data.object(forKey: "DropoffLocation") as? String)
        ////
        let strDate = data.object(forKey: "Date") as! String
        let arrDate = strDate.components(separatedBy: " ")
        
        cell.lblDateTime.text = arrDate[0]
        var intRating = Float()
        let str = data["Rating"] as? String
        if let n = NumberFormatter().number(from: str!)
        {
            intRating = Float(n)
        }
        //
        //
        let strComment  =  (data.object(forKey: "Comment") as? String)
        
        if UtilityClass.isEmpty(str: strComment)
        {
            cell.lblComments.text = "N/A"
        }
        else
        {
        cell.lblComments.text = strComment
        }
        cell.viewRating.rating = intRating//CGFloat((data.object(forKey: "Rating") as? String)!)
        cell.lblPickUpAddress.text = (data.object(forKey: "PickupLocation") as? String)  // PickupLocation
        //
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func webserviceForMyFeedbackList()
    {
        webserviceForFeedbackList(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
            if status
            {
                print(result)
                self.aryData = ((result as! NSDictionary).object(forKey: "feedback") as! NSArray)
                
                
                if(self.aryData.count == 0)
                {
                    self.labelNoData.text = "Please check back later"
                    self.tblview.isHidden = true
                }
                else
                {
                    self.labelNoData.removeFromSuperview()
                    self.tblview.isHidden = false
                }
                self.tblview.reloadData()
            }
            else
            {
                print(result)
                
                if let res = result as? String
                {
                    if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                        if SelectedLanguage == "en"
                        {
                            UtilityClass.showAlert("Error", message: res, vc: self)
                            
                        }
                        else if SelectedLanguage == "sw"
                        {
                            UtilityClass.showAlert("Error", message: res, vc: self)
                        }
                    }
                }
                else if let resDict = result as? NSDictionary
                {
                    
                    
                    if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                        if SelectedLanguage == "en"
                        {
                            UtilityClass.showAlert("Error", message: resDict.object(forKey: "message") as! String, vc: self)
                            
                        }
                        else if SelectedLanguage == "sw"
                        {
                            UtilityClass.showAlert("Error", message: resDict.object(forKey: "swahili_message") as! String, vc: self)
                        }
                    }
                }
                else if let resAry = result as? NSArray
                {
                    
                    if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                        if SelectedLanguage == "en"
                        {
                            UtilityClass.showAlert("Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                            
                        }
                        else if SelectedLanguage == "sw"
                        {
                            UtilityClass.showAlert("Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "swahili_message") as! String, vc: self)
                        }
                    }
                }
            }
        }
 
    }
}
