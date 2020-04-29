//
//  TripDetailsViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 06/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class TripDetailsViewController: BaseViewController {

    var arrData = NSMutableArray()
    let dictData = NSMutableDictionary()
    var delegate: CompleterTripInfoDelegate!
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------

    @IBOutlet weak var lblPickUpTitle: UILabel!
    @IBOutlet weak var lblPickupLocation: UILabel!
    @IBOutlet weak var lblDropoffLocation: UILabel!
    @IBOutlet weak var lblBaseFare: UILabel!
    @IBOutlet weak var lblDistanceFare: UILabel!
    @IBOutlet weak var lblNightFare: UILabel!
    @IBOutlet weak var lblWaitingCost: UILabel!
    @IBOutlet weak var lblTollFee: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblBookingCharge: UILabel!
    @IBOutlet weak var lblSpecialExtraCharge: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblGrandTotal: UILabel!
    @IBOutlet weak var stackViewSpecialExtraCharge: UIStackView!
    @IBOutlet weak var tblObject : UITableView!
    @IBOutlet weak var lblPickUpLocaltion: UILabel!
    @IBOutlet weak var lblDropuplocation: UILabel!
    @IBOutlet weak var lblDrpupLocationDetail: UILabel!
    @IBOutlet weak var lblBaseFareDesc: UILabel!
    @IBOutlet weak var lblBaseFareTitle: UILabel!
    @IBOutlet weak var lblDistanceFareTitle: UILabel!
    @IBOutlet weak var lblNightFareTitle: UILabel!
    @IBOutlet weak var lblSubTotalTitle: UILabel!
    @IBOutlet weak var lblGrandTotalTitle: UILabel!
    @IBOutlet weak var lblDiscountTitle: UILabel!
    @IBOutlet weak var lblTaxTitle: UILabel!
    @IBOutlet weak var txtSpecialExtrsCharging: UILabel!
    @IBOutlet weak var lblBookingChargeTitle: UILabel!
    @IBOutlet weak var lblTollFreeTitle: UILabel!
    @IBOutlet weak var lblWaitingCostTitle: UILabel!
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setData()
        
//        self.tblObject.estimatedRowHeight = 100.0;
//        self.tblObject.rowHeight = UITableViewAutomaticDimension;
//        self.tblObject.tableFooterView = UIView()

        let dict = NSMutableDictionary(dictionary: arrData.object(at: 0) as! NSDictionary) as NSMutableDictionary
        dictData.setObject(dict.object(forKey: "PickupLocation")!, forKey: "Pickup Location" as NSCopying)
        dictData.setObject(dict.object(forKey: "DropoffLocation")!, forKey: "Dropoff Location" as NSCopying)
        dictData.setObject(dict.object(forKey: "NightFare")!, forKey: "Night Fee" as NSCopying)
        dictData.setObject(dict.object(forKey: "TripFare")!, forKey: "Trip Fee" as NSCopying)
        dictData.setObject(dict.object(forKey: "WaitingTimeCost")!, forKey: "Waiting Cost" as NSCopying)
        dictData.setObject(dict.object(forKey: "BookingCharge")!, forKey: "Booking Charge" as NSCopying)
        dictData.setObject(dict.object(forKey: "Discount")!, forKey: "Discount" as NSCopying)
        dictData.setObject(dict.object(forKey: "SubTotal")!, forKey: "Sub Total" as NSCopying)
        dictData.setObject(dict.object(forKey: "Status")!, forKey: "Status" as NSCopying)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLocalization()
         
          
    }
    
    func setLocalization()
    {
        lblPickUpTitle.text = "Pickup Location".localized
        lblDistanceFareTitle.text = "Dropoff Location".localized
        lblBaseFareTitle.text = "Distance Fare:".localized
        lblDistanceFareTitle.text = "Distance Fare:".localized
        lblNightFare.text = "Night Fare:".localized
        lblWaitingCost.text = "Waiting Cost".localized
        lblTollFreeTitle.text = "Toll Fee".localized
        lblSubTotalTitle.text = "Sub Total".localized
        lblBookingChargeTitle.text = "Booking Charge".localized
        lblTaxTitle.text = "Toll Fee".localized
        lblDiscount.text = "Discount".localized
        lblGrandTotalTitle.text = "Grand Total".localized
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func setData() {
        
        if let data = arrData.object(at: 0) as? NSDictionary {
            
            let distanceFare = "\(data.object(forKey: "DistanceFare")!) (\(data.object(forKey: "TripDistance")!) km)"
        
            lblPickupLocation.text = data.object(forKey: "PickupLocation") as? String
            lblDropoffLocation.text = data.object(forKey: "DropoffLocation") as? String
            
            lblBaseFare.text = data.object(forKey: "TripFare") as? String
            lblDistanceFare.text = distanceFare
            lblNightFare.text = data.object(forKey: "NightFare") as? String
            lblWaitingCost.text = data.object(forKey: "WaitingTimeCost") as? String
            lblTollFee.text = data.object(forKey: "TollFee") as? String
            lblSubTotal.text = data.object(forKey: "SubTotal") as? String
            
            lblBookingCharge.text = data.object(forKey: "BookingCharge") as? String
            lblTax.text = data.object(forKey: "Tax") as? String
            lblDiscount.text = data.object(forKey: "Discount") as? String
            
            lblGrandTotal.text = data.object(forKey: "GrandTotal") as? String
            
            var strSpecial = String()
            
            if let special = data.object(forKey: "Special") as? String {
                strSpecial = special
            } else if let special = data.object(forKey: "Special") as? Int {
                strSpecial = String(special)
            }
            
            stackViewSpecialExtraCharge.isHidden = true
            if strSpecial == "1" {
                stackViewSpecialExtraCharge.isHidden = false
                lblSpecialExtraCharge.text = data.object(forKey: "SpecialExtraCharge") as? String
            }
            
            
        }
    }
    @IBAction func btnBackAction(sender: UIButton) {
        
//       NotificationCenter.default.addObserver(self, selector: #selector(YourClassName.methodOfReceivedNotification(notification:)), name: Notification.Name("CallToRating"), object: nil)
        
//        NotificationCenter.default.post(name: Notification.Name("CallToRating"), object: nil)
        
//        self.delegate.didRatingCompleted()
        self.dismiss(animated: true, completion: nil)
    }
    

    
    @IBOutlet weak var btnCall: UIButton!
    @IBAction func btCallClicked(_ sender: UIButton)
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
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
 /*
    {
    "Info": [
    {
    "Id": 263,
    "PassengerId": 29,
    "ModelId": 5,
    "DriverId": 42,
    "CreatedDate": "2017-11-25T11:31:59.000Z",
    "TransactionId": "",
    "PaymentStatus": "",
    "PickupTime": "1511589728",
    "DropTime": "",
    "TripDuration": "",
    "TripDistance": "0.001",
    "PickupLocation": "119, Science City Rd, Sola, Ahmedabad, Gujarat 380060, India",
    "DropoffLocation": "Iscon Mega Mall, Ahmedabad, Gujarat, India",
    "NightFareApplicable": 0,
    "NightFare": "0",
    "TripFare": "30",
    "DistanceFare": "0",
    "WaitingTime": "",
    "WaitingTimeCost": "0",
    "TollFee": "0",
    "BookingCharge": "2",
    "Tax": "3.20",
    "PromoCode": "",
    "Discount": "0",
    "SubTotal": "30.00",
    "GrandTotal": "32.00",
    "Status": "completed",
    "Reason": "",
    "PaymentType": "cash",
    "ByDriverAmount": "",
    "AdminAmount": "5.00",
    "CompanyAmount": "27.00",
    "PickupLat": "23.07272",
    "PickupLng": "72.516387",
    "DropOffLat": "23.030513",
    "DropOffLon": "72.5075401",
    "BookingType": "",
    "ByDriverId": 0,
    "PassengerName": "",
    "PassengerContact": "",
    "PassengerEmail": ""
    }
    ]
    }
    
    */
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
    
    /*
    //MARK:- Tableview delegate and dataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dictData.allKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:TripDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TripDetailsTableViewCell") as! TripDetailsTableViewCell
        cell.lblTitle.text = dictData.allKeys[indexPath.row] as? String
        cell.lblDescription.text = dictData.allValues[indexPath.row] as? String
        return cell
    }
//
//
//    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        return 100
//    }
    
    
    
    override func didReceiveMemoryWarning() {
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
*/

