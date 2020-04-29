//
//  PackageViewController.swift
//  PickNGo User
//
//  Created by Rahul Patel on 04/03/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit

class PackageViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate
{
    var arrCarData = NSMutableArray()
    var arrCarHoursData = NSMutableArray()
    var arrCarDaysData = NSMutableArray()
    var PacakgeData = NSArray()
    var selectedIndexPath: IndexPath?
    var strPickupLocation = String()
    var strVehicleType = String()
    var doublePickupLat = Double()
    var doublePickupLng = Double()
    
    @IBOutlet var lblPickUpLocation: UILabel!
    @IBOutlet var lblDropUpLocation: UILabel!
    @IBOutlet weak var pickerView: UIDatePicker!
     @IBOutlet var tableView: UITableView!
    @IBOutlet var lblPickuptilme: UILabel!
    @IBOutlet var lblPickupdate: UILabel!
    @IBOutlet var lblPickupLDate : UILabel!
    @IBOutlet var lblPickupTime : UILabel!
    @IBOutlet weak var collectionViewCars: UICollectionView!
    @IBOutlet weak var viewDatePicker: UIView!
    @IBOutlet weak var constrainYPosistionDatePicker: NSLayoutConstraint!
    @IBOutlet weak var segmentHoursDays: UISegmentedControl!
    @IBOutlet weak var btnPickerDone: ThemeButton!
    @IBOutlet weak var lblPickerMessage: UILabel!
    @IBOutlet weak var imgClosePicker: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentHoursDays.selectedSegmentIndex = 0
        webserviceOFGetPackagesList()
//        lblPickupLocation.text = strPickupLocation
        
        constrainYPosistionDatePicker.constant = self.view.frame.size.height
        pickerView.datePickerMode = .dateAndTime
        pickerView.minimumDate = Date.today()
        imgClosePicker.image = UIImage.init(named: "iconCloseAlert")?.withRenderingMode(.alwaysTemplate)
        imgClosePicker.tintColor = themeYellowColor
     
        let hourtoAdd = 2
        let currentDate = Date()
        
        var dateComponent = DateComponents()
        
        
        dateComponent.hour = hourtoAdd
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        
        print(currentDate)
        print(futureDate!)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy  h:mm a"
        let strDate = dateFormatter.string(from: futureDate!)
        print(strDate)
        

        let arrdate = strDate.components(separatedBy: "  ")
        lblPickupLDate.text = arrdate[0]
        lblPickupTime.text = arrdate[1]
        
        
//        let monthsToAdd = 2
//        let daysToAdd = 1
//        let yearsToAdd = 1

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
//        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isOpaque = false;
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white;
        self.navigationController?.navigationBar.tintColor = themeYellowColor;
        self.title = "Packages"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : themeYellowColor]
        
        
        let btnback :UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "iconArrowSmall"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(btnBackClicked(_:)))
        self.navigationItem.leftBarButtonItem = btnback
        
//        let btnCall :UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "iconCall"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(btnCallClicked(_:)))
//        self.navigationItem.rightBarButtonItem = btnCall
        
        
        let btnCall  = UIButton(type: UIButtonType.custom)
        btnCall.frame = CGRect (x: 0, y: 0, width: 50, height: 32)
        btnCall.backgroundColor = UIColor.clear
        btnCall.setImage(UIImage.init(named: "iconCallSmall"), for: .normal)
        btnCall.addTarget(self, action: #selector(btnCallClicked(_:)), for: UIControlEvents.touchUpInside)  // Action
        let btnCallBArButton: UIBarButtonItem = UIBarButtonItem(customView: btnCall)  // Create the bar button
        
        // Add the component to the navigation Bar
        self.navigationItem.setRightBarButtonItems([btnCallBArButton], animated: false)
         setLocalization()
    }

    func setLocalization()
    {
        lblPickUpLocation.text = "Pickup Location".localized
        lblDropUpLocation.text = "Dropoff Location".localized
        lblPickupdate.text = "tarehe ya kupakua".localized
        lblPickuptilme.text = "Pickup Time".localized
        btnPickerDone.setTitle("Done".localized, for: .normal)
        lblPickerMessage.text = "Packages can be made after 2 hours from now. Sri Lankan time is 2018-03-06 11:16 AM".localized
        btnPickerDone.setTitle("Done".localized, for: .normal)
        lblSelectYourPickUpDate.text = "Select your pickup Date and Time".localized
    
    }
  
    
    @IBOutlet var lblSelectYourPickUpDate: UILabel!
    
    @IBAction func btnBackClicked(_ sender: UIButton)
    {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnCallClicked(_ sender: UIButton)
    {
        let contactNumber = helpLineNumber
        
        if contactNumber == "" {
            
            UtilityClass.setCustomAlert(title: "\(appName)", message: "Contact number is not available") { (index, title) in
            }
        }
        else
        {
            callNumber(phoneNumber: contactNumber)
        }
    }
    
    private func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    func webserviceOFGetPackagesList() {
        
        webserviceForGetPackages("" as AnyObject) { (result, status) in
             if (status)
             {
                print(result)
                if let res = result as? NSDictionary
                {
                    self.PacakgeData = ((res.object(forKey: "package"))as! NSArray)
                    self.arrCarData.removeAllObjects()
                    
                    for i in (0..<self.PacakgeData.count)
                    {
                        let dictData = self.PacakgeData[i] as? NSDictionary
                        
                        var dictCarData = [String: AnyObject]()
                        
                        dictCarData["ModelId"] = dictData?.object(forKey: "ModelId") as AnyObject
                        dictCarData["ModelImage"] = dictData?.object(forKey: "ModelImage") as AnyObject
                        dictCarData["ModelName"] = dictData?.object(forKey: "ModelName") as AnyObject
                        
                        self.arrCarData.add(dictCarData)
                    }
                    let dictOnlineCarData = (self.PacakgeData.object(at: 0) as! NSDictionary)
                    let arrCar = (dictOnlineCarData.object(forKey: "Package") as! NSArray)
                    
                for i in 0..<arrCar.count
                    {
                        let strType = (arrCar.object(at: i)as! NSDictionary).object(forKey: "Type") as! String
                        
                        let dictData = (arrCar.object(at: i) as! NSDictionary)
                        if strType == "hours"
                        {
                            self.arrCarHoursData.add(dictData)
                        }
                        else if strType == "days"
                        {
                            self.arrCarDaysData.add(dictData)
                        }
                    }
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.selectedIndexPath = indexPath
                    let dict = self.arrCarData.object(at: 0) as! NSDictionary
                    self.strVehicleType = dict.object(forKey: "ModelName") as! String
                    self.tableView.reloadData()
                    self.collectionViewCars.reloadData()
                    //                    self.steGetTickPayRate = res.object(forKey: "rate") as! String
//                    self.strTransactionFee = res.object(forKey: "TransactionFee") as! String
//                    self.lblCredirAndDebitRate.text = "\(self.steGetTickPayRate)% Service fee \n$\(self.strTransactionFee) Transaction fee"
                    
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK:- Collectionview Delegate and Datasource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        return self.arrCarData.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PackageCarListCollectionViewCell", for: indexPath as IndexPath) as! PackageCarListCollectionViewCell
        
        cell.viewOfImage.layer.cornerRadius = cell.viewOfImage.frame.width / 2
        cell.viewOfImage.layer.borderWidth = 3.0
        
        if selectedIndexPath == indexPath
        {
            
            cell.viewOfImage.layer.borderColor = themeYellowColor.cgColor
            cell.viewOfImage.layer.masksToBounds = true
        }
        else
        {
            cell.viewOfImage.layer.borderColor = themeGrayColor.cgColor
            cell.viewOfImage.layer.masksToBounds = true
            
        }
        
        
        
//        if (self.arrNumberOfOnlineCars.count != 0 && indexPath.row < self.arrNumberOfOnlineCars.count)
//        {
            let dictOnlineCarData = (self.arrCarData.object(at: indexPath.row) as! [String : AnyObject])
            let imageURL = dictOnlineCarData["ModelImage"] as! String
            
            cell.imgCars.sd_setIndicatorStyle(.gray)
            cell.imgCars.sd_setShowActivityIndicatorView(true)
            
            cell.imgCars.sd_setImage(with: URL(string: imageURL), completed: { (image, error, cacheType, url) in
                cell.imgCars.sd_setShowActivityIndicatorView(false)
            })
            
//            cell.lblMinutes.text = "0 min"
//            cell.lblPrices.text = "\(currencySign) 0.00"
        
            
//            if dictOnlineCarData["carCount"] as! Int != 0 {
//
//                if self.aryEstimateFareData.count != 0 {
//
//                    if ((self.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "duration") as? NSNull) != nil {
//
//                        cell.lblMinutes.text = "\(0.00) min"
//                    }
//                    else if let minute = (self.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "duration") as? Double {
//                        cell.lblMinutes.text = "\(minute) min"
//                    }
//
//
//
//                    if ((self.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "total") as? NSNull) != nil {
//
//                        cell.lblPrices.text = "\(currencySign) \(0)"
//
//                    }
//                    else if let price = (self.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "total") as? Double {
//
//                        cell.lblPrices.text = "\(currencySign) \(price)"
//
//
//                    }
//
//                }
//
//
//            }
        
//        }
//        else
//        {
//            cell.imgCars.image = UIImage(named: "iconPackage")
//            cell.lblMinutes.text = "Packages"
//            cell.lblPrices.text = ""
//
//        }
    
        return cell
        
        // Maybe for future testing ///////
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    
    {

        let dictOnlineCarData = (self.PacakgeData.object(at: indexPath.row) as! NSDictionary)


        arrCarHoursData.removeAllObjects()
        arrCarDaysData.removeAllObjects()
        selectedIndexPath = indexPath

        strVehicleType = dictOnlineCarData.object(forKey: "ModelName") as! String

        let arrCar = (dictOnlineCarData.object(forKey: "Package") as! NSArray)

        for i in 0..<arrCar.count
        {
            let strType = (arrCar.object(at: i)as! NSDictionary).object(forKey: "Type") as! String

            let dictData = (arrCar.object(at: i) as! NSDictionary)
            if strType == "hours"
            {
                arrCarHoursData.add(dictData)
            }
            else if strType == "days"
            {
                arrCarDaysData.add(dictData)
            }
        }

        self.tableView.reloadData()

        collectionViewCars.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! PackageCarListCollectionViewCell
        cell.viewOfImage.layer.borderColor = themeGrayColor.cgColor
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.collectionViewCars.frame.size.width/3, height: self.collectionViewCars.frame.size.height)
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Table View Methods -
    //-------------------------------------------------------------
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if segmentHoursDays.selectedSegmentIndex == 0
        {
            return self.arrCarHoursData.count
        }
        else
        {
            return self.arrCarDaysData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PacageHoursDaysTableViewCell") as! PacageHoursDaysTableViewCell
        cell.selectionStyle = .none
        
        if segmentHoursDays.selectedSegmentIndex == 0
        {
            let dictData = self.arrCarHoursData.object(at: indexPath.row) as! NSDictionary
            cell.lblKMs.text = "\(dictData.object(forKey: "KM") as! String) KMs"
            if dictData.object(forKey:  "Type") as? String == "hours"
            {
                cell.lblHours.text = "\(dictData.object(forKey: "Time") as! String) Hours"
            }
            else
            {
               cell.lblHours.text = "\(dictData.object(forKey: "Time") as! String) Days"
            }
            
            cell.lblAmount.text = "$ \(dictData.object(forKey: "Amount") as! String)"
            cell.lblAdditional.text = dictData.object(forKey: "Notes") as? String
        }
        else
        {
            let dictData = self.arrCarDaysData.object(at: indexPath.row) as! NSDictionary

            cell.lblKMs.text = "\(dictData.object(forKey: "KM") as! String) KMs"
            if dictData.object(forKey:  "Type") as? String == "hours"
            {
                cell.lblHours.text = "\(dictData.object(forKey: "Time") as! String) Hours"
            }
            else
            {
                cell.lblHours.text = "\(dictData.object(forKey: "Time") as! String) Days"
            }
            cell.lblAmount.text = "$ \(dictData.object(forKey: "Amount") as! String)"
            cell.lblAdditional.text = dictData.object(forKey: "Notes") as? String
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let strDate = lblPickupLDate.text
     
        let formatter = DateFormatter()

        formatter.dateFormat = "dd MMM yyyy"
        let yourDate = formatter.date(from: strDate!)
        let date = Date()
        let strDate1 = formatter.string(from: date)
        let currentDate = formatter.date(from: strDate1)
        formatter.dateFormat = "dd MMM yyyy"
        let myStringafd = formatter.string(from: yourDate!)
        
        print(myStringafd)
        
        let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .month, .year])
        let differenceOfDate = Calendar.current.dateComponents(components, from: currentDate!, to: yourDate!)
        
        print (differenceOfDate.day as Any)
        
        let MinDays = differenceOfDate.day
        let MinMonth = differenceOfDate.month

        if MinMonth! >= 1 && MinDays! <= 1
        {
            let msg = "Pre booking can be made at least before 2 hours from now and before 30 days from today."
            
            let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
            
            let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OK)
            self.present(alert, animated: true, completion: nil)

        }
        else
        {
            
            let DetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "PackageDetailViewController") as! PackageDetailViewController
            
            if segmentHoursDays.selectedSegmentIndex == 0
            {
                let dictData = self.arrCarHoursData.object(at: indexPath.row) as! NSDictionary
                DetailsVC.dictCarModelData = dictData as! [String : AnyObject]
            }
            else
            {
                let dictData = self.arrCarDaysData.object(at: indexPath.row) as! NSDictionary
                DetailsVC.dictCarModelData = dictData as! [String : AnyObject]
                
            }
            
            DetailsVC.strVehicleType = strVehicleType
            DetailsVC.strPickupLocation = strPickupLocation
            DetailsVC.strPickupDate = lblPickupLDate.text!
            DetailsVC.strPickupTime = lblPickupTime.text!
            DetailsVC.doublePickupLat = doublePickupLat
            DetailsVC.doublePickupLng = doublePickupLng
            let navController = UINavigationController(rootViewController: DetailsVC)
            self.present(navController, animated:true, completion: nil)
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - Action Methods -
    //-------------------------------------------------------------
    

    @IBAction func segmentValueChanged(_ sender: Any)
    {
        self.tableView.reloadData()
    }
    
    
    @IBAction func btnPickupDateClicked(_ sender: Any)
    {

        constrainYPosistionDatePicker.constant = self.view.frame.size.height - viewDatePicker.frame.size.height
        
        UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveEaseOut, animations:
        {
                self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    
    @IBAction func btnPickupTimeClicked(_ sender: Any)
    {
        constrainYPosistionDatePicker.constant = self.view.frame.size.height - viewDatePicker.frame.size.height
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations:
            {
                self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func btnPickerDoneClicked(_ sender: Any)
    {
        let dateFormatter = DateFormatter()
        
//        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "dd MMM yyyy  hh:mm a"
        let strDate = dateFormatter.string(from: pickerView.date)
        print(strDate)
        
        let arrdate = strDate.components(separatedBy: "  ")
        lblPickupLDate.text = arrdate[0]
        lblPickupTime.text = arrdate[1]
        
//        dateLabel.text = strDate
        
        constrainYPosistionDatePicker.constant = self.view.frame.size.height
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations:
            {
                self.view.layoutIfNeeded()
        }, completion: nil)
    }
    @IBAction func btnClosePickerClicked(_ sender: Any) {
        constrainYPosistionDatePicker.constant = self.view.frame.size.height
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations:
            {
                self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
