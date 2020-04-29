
//
//  TripInfoCompletedTripVC.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 06/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class TripInfoViewController: UIViewController,delegatePesapalWebView//,delegateRateGiven
{
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    var delegate: delegateRateGiven!
    @IBOutlet weak var lblPickupLocation: UILabel!
    @IBOutlet weak var lblDropOffLocation: UILabel!
    
    @IBOutlet var lblTripStatusTitle: UILabel!
    @IBOutlet weak var lblTripFare: UILabel!     // as Base Fare
    @IBOutlet weak var lblDistanceFare: UILabel!
    @IBOutlet weak var lblTripStatus: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblbookingID: UILabel!
    @IBOutlet weak var lblNightFare: UILabel!
    @IBOutlet weak var lblTollFree: UILabel!
    @IBOutlet weak var lblBookingCharge: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet var btnViewCompleteTripData: UIView!
    
    @IBOutlet var lblTip: UILabel!
    @IBOutlet var lblPaymentType: UILabel!
    @IBOutlet var lblPickTime: UILabel!
    @IBOutlet var lblDropTime: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblGrandTotal: UILabel!
    
    @IBOutlet weak var lblFlightNumber: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    
    @IBOutlet weak var stackViewPomocide: UIStackView!
    @IBOutlet weak var stackViewFlightNumber: UIStackView!
    @IBOutlet weak var stackViewNote: UIStackView!
    
    @IBOutlet weak var lblBaseFare: UILabel!
    @IBOutlet weak var lblTripDistance: UILabel!
    @IBOutlet weak var lblDiatnceFare: UILabel!
    @IBOutlet weak var lblWaitingTime: UILabel!
    @IBOutlet weak var lblExtraCharges: UILabel!
    @IBOutlet weak var lblWaitingTimeCost: UILabel!
    
//    var delegate: delegateRateGiven!
    @IBOutlet weak var lblPromocodeType: UILabel!
    @IBOutlet weak var lblPromocode: UILabel!

    @IBOutlet weak var lblPaymentTypeTitle: UILabel!
    @IBOutlet weak var lblDropoffTimeTitle: UILabel!
    @IBOutlet weak var lblPickUpTimeTitle: UILabel!
    @IBOutlet weak var lblDisstanceTravelledTitle: UILabel!
    @IBOutlet weak var lblBookingFreeTitle: UILabel!
    
    @IBOutlet var lblTipTitle: UILabel!
    @IBOutlet weak var lblTripFee: UILabel!
    
    @IBOutlet weak var WaitingCostTitle: UILabel!
    
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblLess: UILabel!
    
    @IBOutlet weak var lblPrompAppplied: UILabel!
    @IBOutlet weak var lblWaitingTimeTile: UILabel!
    
    
    
    var dictData = NSDictionary()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        btnViewCompleteTripData.layer.cornerRadius = 10
        btnViewCompleteTripData.layer.masksToBounds = true
        
        
        btnOK.layer.cornerRadius = 10
        btnOK.layer.masksToBounds = true
        
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        setLocalizaton()
        setData()
    }
    func setLocalizaton()
    {
        lblbookingID.text = "Booking Id".localized
        lblPickupLocation.text = "Address".localized
        lblDropOffLocation.text = "Address".localized
        lblDropoffTimeTitle.text = "Dropoff Location".localized
        lblPickUpTimeTitle.text = "Pickup Time".localized
        lblDisstanceTravelledTitle.text = "Distance Travelled:".localized
        lblBookingFreeTitle.text = "Booking Fee :".localized
        lblTripFee.text = "Trip Fare:".localized
        WaitingCostTitle.text = "Waiting Cost".localized
        lblWaitingTimeTile.text = "Waiting Time:".localized
        lblLess.text = "Less".localized
        lblPrompAppplied.text = "Promo Applied :".localized
        lblTotalAmount.text = "Total Amount :".localized
        lblTripStatusTitle.text = "Trip Status:".localized
        if dictData.object(forKey: "PaymentType") as! String != "pesapal"
        {
        btnOK.setTitle("OK".localized, for: .normal)
        }
        else
        {
            btnOK.setTitle("Make Payment".localized, for: .normal)
        }
        lblPaymentTypeTitle.text = "Payment Type:".localized
        lblWaitingTimeTile.text = "Waiting Time".localized
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func setData() {
        
        
//        dictData = NSMutableDictionary(dictionary: (dictData.object(forKey: "details") as! NSDictionary))
        print(dictData)
        
        lblTip.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "TollFee") as? String))) ? "\(String(describing: dictData.object(forKey: "TollFee") as! String)) \(currencySign)": "-"
        
        
        lblPickupLocation.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "PickupLocation") as? String ))) ? (dictData.object(forKey: "PickupLocation") as? String ) : "-"
        lblDropOffLocation.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "DropoffLocation") as? String))) ?(dictData.object(forKey: "DropoffLocation") as? String): "-"
//        lblTollFree.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "TollFee") as? String))) ?"\(String(describing: dictData.object(forKey: "TollFee") as! String)) \(currencySign)": "-"
        lblGrandTotal.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "GrandTotal") as? String))) ? "\(String(describing: dictData.object(forKey: "GrandTotal") as! String)) \(currencySign)": "-"
        lblBaseFare.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "TripFare") as? String))) ? "\(String(describing: dictData.object(forKey: "TripFare") as! String)) \(currencySign)": "-"
        
        lblbookingID.text = "\("Booking Id :".localized) \(dictData.object(forKey: "Id") as! Int)"

        lblTripStatus.text = dictData.object(forKey: "Status") as? String
        if((!UtilityClass.isEmpty(str: (dictData.object(forKey: "PromoCode") as? String))))
        {
            lblPromocodeType.text = "\(String(describing: dictData.object(forKey: "PromoCode") as! String)) applied: "
            stackViewPomocide.isHidden = false

        }
        lblBookingCharge.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "BookingCharge") as? String))) ? "\(String(describing: dictData.object(forKey: "BookingCharge") as! String)) \(currencySign)": "0.0 \(currencySign)"
        
        let PickTime = Double(dictData.object(forKey: "PickupTime") as! String)
        let dropoffTime = Double(dictData.object(forKey: "DropTime") as! String)
        let unixTimestamp = PickTime //as Double//as! Double//dictData.object(forKey: "PickupTime")
        let unixTimestampDrop = dropoffTime
        let date = Date(timeIntervalSince1970: TimeInterval(unixTimestamp!))
        let dateDrop = Date(timeIntervalSince1970: TimeInterval(unixTimestampDrop!))
        let dateFormatter = DateFormatter()
        //        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        //        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        let strDateDrop = dateFormatter.string(from: dateDrop)
        lblDate.text = strDate
        
        lblPickTime.text = strDate
        lblDropTime.text = strDateDrop
        lblPaymentType.text = dictData.object(forKey: "PaymentType") as! String
        
        lblWaitingTimeCost.text = "\(dictData.object(forKey: "WaitingTimeCost") as! String) \(currencySign)"
//        lblFlightNumber.text = strDate//dictData.object(forKey: "PickupDateTime") as? String
//
//        lblNote.text = strDateDrop //dictData.object(forKey: "PickupDateTime") as? String
        
        if((!UtilityClass.isEmpty(str: (dictData.object(forKey: "Discount") as? String))))
        {
            lblDiscount.text = " \(String(describing: dictData.object(forKey: "Discount") as! String)) \(currencySign)"
            stackViewPomocide.isHidden = false
        }
        //        lblTripDistance.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "TripDistance") as? String))) ? (dictData.object(forKey: "TripDistance") as? String): "0.00"

//                lblTripDistance.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "TripDistance") as? String))) ? (dictData.object(forKey: "TripDistance") as? String): "0.00"

        let strTemp = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "TripDistance") as? String ))) ?  (dictData.object(forKey: "TripDistance") as! String ) : "0.00 km"

        let distaceFloat = Float(strTemp)
        let doubleStr = String(format: "%.2f", distaceFloat!)

        lblTripDistance.text = (doubleStr != nil) ? "\(doubleStr) km" : "0.00 km"



//        lblDiatnceFare.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "DistanceFare") as? String))) ? "\(String(describing: dictData.object(forKey: "DistanceFare") as! String)) \(currencySign)": "-"
          lblWaitingTime.text = dictData.object(forKey: "WaitingTime") as? String

//        lblExtraCharges.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "ExtraCharges") as? String))) ? " \(String(describing: dictData.object(forKey: "ExtraCharges") as! String))": "-"


        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: Int((dictData.object(forKey: "WaitingTime") as? String)!) ?? 0)
        
                lblWaitingTime.text = "\(getStringFrom(seconds: h)):\(getStringFrom(seconds: m)):\(getStringFrom(seconds: s))"
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func getStringFrom(seconds: Int) -> String {
        
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }
    
    @IBOutlet weak var btnOK: UIButton!
    
    @IBAction func btnOK(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
//        if SingletonClass.sharedInstance.passengerType == "other" || SingletonClass.sharedInstance.passengerType == "others"
//        {
////            self.completeTripInfo()
//            self.delegate.delegateforGivingRate()
//        }
//        else
//        {
//            self.delegate.delegateforGivingRate()

//        }
//         SingletonClass.sharedInstance.passengerType = ""
        
        if (btnOK.titleLabel?.text) != "Make Payment".localized//dictData.object(forKey: "PaymentType") as! String != "pesapal"
        {
            self.delegate.delegateforGivingRate()
        }
        else
        {
//            btnOK.setTitle("Make Payment".localized, for: .normal)
            let next = self.storyboard?.instantiateViewController(withIdentifier: "PesapalWebViewViewController") as! PesapalWebViewViewController
            next.delegate = self
            let Amount = String((lblGrandTotal.text)!.replacingOccurrences(of: currencySign, with: "").trimmingCharacters(in: .whitespacesAndNewlines))//(lblGrandTotal.text?.replacingOccurrences(of: currencySign, with: ""))?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let url = "https://www.tantaxitanzania.com/pesapal/add_money/\(SingletonClass.sharedInstance.strPassengerID)/\("\(Amount)")/passenger"
            next.strUrl = url
//            self.present(next, animated: true, completion: nil)
self.navigationController?.pushViewController(next, animated: true)
//            let navController = UINavigationController.init(rootViewController: next)
//            UIApplication.shared.keyWindow?.rootViewController?.present(navController, animated: true, completion: nil)
        }

    }
    func didOrderPesapalStatus(status: Bool)
    {
        if status
        {
            self.btnOK.setTitle("OK", for: .normal)
            self.delegate.delegateforGivingRate()
        }
        else
        {
            self.btnOK.setTitle("Make Payment", for: .normal)
        }
    }
}
