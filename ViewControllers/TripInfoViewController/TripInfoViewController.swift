
//
//  TripInfoCompletedTripVC.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 06/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import MarqueeLabel
class TripInfoViewController: UIViewController,delegatePesapalWebView//,delegateRateGiven
{
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    var delegate: delegateRateGiven!
    @IBOutlet weak var lblPickupLocation: MarqueeLabel!
    @IBOutlet weak var lblDropOffLocation: MarqueeLabel!
    @IBOutlet weak var lblDropOffLocation2: MarqueeLabel!
    @IBOutlet var viewDropOffLocation2: UIView!
    @IBOutlet var lblTripStatusTitle: UILabel!
    @IBOutlet weak var lblTripFare: UILabel!     // as Base Fare
    @IBOutlet weak var lblDistanceFare: UILabel!
    @IBOutlet weak var lblTripStatus: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblbookingID: UILabel!
    @IBOutlet weak var lblNightFare: UILabel!
    @IBOutlet weak var lblTollFree: UILabel!
    @IBOutlet weak var lblBookingCharge: UILabel!
    @IBOutlet var btnViewCompleteTripData: UIView!
    
    @IBOutlet weak var lblTitleTripDetail: UILabel!
    @IBOutlet var lblTip: UILabel!
    @IBOutlet var lblPaymentType: UILabel!
    @IBOutlet var lblPickTime: UILabel!
    @IBOutlet var lblDropTime: UILabel!
//    @IBOutlet weak var lblDiscount: UILabel!
//    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblGrandTotal: UILabel!
    
    @IBOutlet weak var lblFlightNumber: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    
    @IBOutlet weak var stackViewPomocide: UIStackView!
    @IBOutlet weak var stackViewFlightNumber: UIStackView!
    @IBOutlet weak var stackViewNote: UIStackView!
    @IBOutlet weak var stackNightFare: UIStackView!
    
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
    
    
    @IBOutlet weak var lblBookingDate: UILabel!
    @IBOutlet weak var lblProcessingDate: UILabel!
    @IBOutlet weak var lblAuthorizationNumber: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblTitleCompnyName: UILabel!
    
    @IBOutlet weak var lblTitleTaxIncluded: UILabel!
    @IBOutlet weak var lblTitleDiscount: UILabel!
    @IBOutlet weak var lblTitleProcessingDate: UILabel!
    @IBOutlet weak var lblTitleBookingDate: UILabel!
    @IBOutlet weak var lblTitleAuthorizationNumber: UILabel!
    @IBOutlet weak var lblTitleNightFare: UILabel!
    @IBOutlet weak var lblTitleSubTotal: UILabel!
    
    @IBOutlet weak var lblTitleExtraCharge: UILabel!
    @IBOutlet weak var lblTitleExtraChargeReason: UILabel!
    @IBOutlet weak var lblExtraCharge: UILabel!
    @IBOutlet weak var lblExtraChargeReason: UILabel!
    @IBOutlet weak var stackViewExtraCharge: UIStackView!
    @IBOutlet weak var stackViewExtraChargeReason: UIStackView!
    
    @IBOutlet weak var lblPriceModel: UILabel!
    @IBOutlet weak var lblPriceModelTitle: UILabel!
    
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
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
        setLocalizaton()
        setData()
    }
    
    @objc func changeLanguage(){
        self.setLocalizaton()
    }
    
    func setLocalizaton(){
        lblbookingID.text = "Order Number/Booking Number".localized
        lblTitleTripDetail.text = "Trip Detail".localized
        lblTitleCompnyName.text = "\("Company name".localized) :"
        lblTitleBookingDate.text = "\("Booking Date".localized) :"
        lblTitleProcessingDate.text = "\("Processing Date".localized) :"
        lblTitleAuthorizationNumber.text = "\("Authorization Number".localized) :"
        lblPaymentTypeTitle.text = "\("Payment Type".localized) :"
        lblDisstanceTravelledTitle.text = "\("Distance Travelled".localized):"
        lblWaitingTimeTile.text = "\("Waiting Time".localized):"
        WaitingCostTitle.text = "Waiting Cost".localized
        lblBookingFreeTitle.text = "\("Booking Fee".localized) :"
        lblTitleNightFare.text = "\("Night Fare".localized) :"
        lblTitleSubTotal.text = "\("Subtotal".localized) :"
        lblTitleDiscount.text = "\("Discount".localized) :"
        lblTitleTaxIncluded.text = "\("Tax(Included)".localized) :"
        lblTotalAmount.text = "\("Grand Total".localized) :"
        lblTripStatusTitle.text = "\("Trip Status".localized):"
        lblTitleExtraCharge.text = "\("Extra Charge".localized) :"
        lblTitleExtraChargeReason.text = "\("Extra Charge Reason".localized) :"
        
        lblPickupLocation.text = "Address".localized
        lblDropOffLocation.text = "Address".localized
        lblDropoffTimeTitle.text = "Dropoff Time".localized
        lblPickUpTimeTitle.text = "Pickup Time".localized
        lblTripFee.text = "\("Trip Fare".localized):"
        lblLess.text = "Less".localized
        
        lblPriceModelTitle.text = "Pricing Model".localized
        
//        lblPrompAppplied.text = "Promo Applied :".localized
        lblNightFare.text = "lblNightFare".localized
        
        if (dictData.object(forKey: "PaymentType") as? String ?? "") != "card"
        {
        btnOK.setTitle("OK".localized, for: .normal)
        }
        else
        {
            btnOK.setTitle("Make Payment".localized, for: .normal)
        }
        lblWaitingTimeTile.text = "Waiting Time".localized
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func setData() {
        
        
//        dictData = NSMutableDictionary(dictionary: (dictData.object(forKey: "details") as! NSDictionary))
        print(dictData)
        
        let AuthorizationNumber = dictData.object(forKey: "Authorization_Number") as? String ?? "N/A"
        self.lblAuthorizationNumber.text = (AuthorizationNumber) == "" ? "N/A" : AuthorizationNumber
       
        let SubTotal = dictData.object(forKey: "SubTotal") as? String ?? "0"
        self.lblSubTotal.text = "\(SubTotal) \(currencySign)"
        //
        let Discount = dictData.object(forKey: "Discount") as? String ?? "0"
        self.lblDiscount.text = "\(Discount) \(currencySign)"
        //Tax
        let Tax = dictData.object(forKey: "Tax") as? String ?? "0"
        self.lblTax.text = "\(Tax) \(currencySign)"
        
        let nightFare = dictData.object(forKey: "NightFare") as? String ?? ""
        if(nightFare == "" || nightFare == "0"){
            stackNightFare.isHidden = true
        }else{
            stackNightFare.isHidden = false
        }
        
        let ExtraCharge = dictData.object(forKey: "ExtraCharge") as? String ?? "0"
        lblExtraCharge.text = "\(ExtraCharge) \(currencySign)"
        stackViewExtraCharge.isHidden = (ExtraCharge == "0") ? true : false
        
        let ExtraChargeReason = dictData.object(forKey: "ExtraChargeReason") as? String ?? ""
        lblExtraChargeReason.text = "\(ExtraChargeReason)"
        stackViewExtraChargeReason.isHidden = (ExtraChargeReason == "") ? true : false
        
        let PriceTypeLabel = (Localize.currentLanguage() == Languages.English.rawValue) ? dictData.object(forKey: "PriceTypeLabel") as? String ?? "" : dictData.object(forKey: "PriceTypeLabelSpanish") as? String ?? ""
        lblPriceModel.text = "\(PriceTypeLabel)"
        
        let createDate = dictData.object(forKey: "CreatedDate") as? String ?? ""
        if(createDate.contains("T")){
            let date = createDate.components(separatedBy: "T")
            self.lblBookingDate.text = date[0]
        }else{
            self.lblBookingDate.text = createDate
        }
        
        let PickDate = Double(dictData.object(forKey: "PickupTime") as! String)
        guard let unixTimestamp1 = PickDate else { return }
        let date1 = Date(timeIntervalSince1970: TimeInterval(unixTimestamp1))
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy/MM/dd"
        let strDate1 = dateFormatter1.string(from: date1)
        self.lblProcessingDate.text = strDate1
        
        
        lblNightFare.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "NightFare") as? String))) ? "\(String(describing: dictData.object(forKey: "NightFare") as! String)) \(currencySign)": "-"
        
//        lblTip.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "TollFee") as? String))) ? "\(String(describing: dictData.object(forKey: "TollFee") as! String)) \(currencySign)": "-"
        
        
        lblPickupLocation.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "PickupLocation") as? String ))) ? (dictData.object(forKey: "PickupLocation") as? String ) : "-"
        lblDropOffLocation.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "DropoffLocation") as? String))) ?(dictData.object(forKey: "DropoffLocation") as? String): "-"
//        lblTollFree.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "TollFee") as? String))) ?"\(String(describing: dictData.object(forKey: "TollFee") as! String)) \(currencySign)": "-"
        lblGrandTotal.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "GrandTotal") as? String))) ? "\(String(describing: dictData.object(forKey: "GrandTotal") as! String)) \(currencySign)": "-"
        
        let strDropLocation2 = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "DropoffLocation2") as? String))) ?(dictData.object(forKey: "DropoffLocation2") as? String): "-"
        
        viewDropOffLocation2.isHidden = true
        if(strDropLocation2 != "-")
        {
            viewDropOffLocation2.isHidden = false
            lblDropOffLocation2.text = strDropLocation2
        }
        
        lblBaseFare.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "TripFare") as? String))) ? "\(String(describing: dictData.object(forKey: "TripFare") as! String)) \(currencySign)": "-"
        
        
        
        lblbookingID.text = "\("\("Order Number/Booking Number".localized) :") \(dictData.object(forKey: "Id") as! Int)"

        lblTripStatus.text = (dictData.object(forKey: "Status") as? String)?.capitalizingFirstLetter()
        if((!UtilityClass.isEmpty(str: (dictData.object(forKey: "PromoCode") as? String))))
        {
            lblPromocodeType.text = "\(String(describing: dictData.object(forKey: "PromoCode") as! String)) applied: "
            stackViewPomocide.isHidden = false

        }
        lblBookingCharge.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "BookingCharge") as? String))) ? "\(String(describing: dictData.object(forKey: "BookingCharge") as! String)) \(currencySign)": "0.0 \(currencySign)"
        
        let PickTime = Double(dictData.object(forKey: "PickupTime") as! String)
        let dropoffTime = Double(dictData.object(forKey: "DropTime") as! String)
        
        lblPaymentType.text = (dictData.object(forKey: "PaymentType") as! String).capitalizingFirstLetter()

        if((!UtilityClass.isEmpty(str: (dictData.object(forKey: "Discount") as? String))))
        {
//            lblDiscount.text = " \(String(describing: dictData.object(forKey: "Discount") as! String)) \(currencySign)"
            stackViewPomocide.isHidden = false
        }
        let strTemp = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "TripDistance") as? String ))) ?  (dictData.object(forKey: "TripDistance") as? String  ?? "") : "0.00 km"

        let distaceFloat = Float(strTemp) ?? 0.0
        let doubleStr = String(format: "%.2f", distaceFloat)

        lblTripDistance.text = (doubleStr != "") ? "\(doubleStr) km" : "0.00 km"
        guard let unixTimestamp = PickTime else { return } //as Double//as! Double//dictData.object(forKey: "PickupTime")
        guard let unixTimestampDrop = dropoffTime else { return  }
        let date = Date(timeIntervalSince1970: TimeInterval(unixTimestamp))
        let dateDrop = Date(timeIntervalSince1970: TimeInterval(unixTimestampDrop))
        let dateFormatter = DateFormatter()
        //        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        //        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        let strDateDrop = dateFormatter.string(from: dateDrop)
        lblDate.text = strDate
        
        lblPickTime.text = strDate
        lblDropTime.text = strDateDrop
    
        
        lblWaitingTimeCost.text = "\(dictData.object(forKey: "WaitingTimeCost") as! String) \(currencySign)"
//        lblFlightNumber.text = strDate//dictData.object(forKey: "PickupDateTime") as? String
//
//        lblNote.text = strDateDrop //dictData.object(forKey: "PickupDateTime") as? String
        
     
        //        lblTripDistance.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "TripDistance") as? String))) ? (dictData.object(forKey: "TripDistance") as? String): "0.00"

//                lblTripDistance.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "TripDistance") as? String))) ? (dictData.object(forKey: "TripDistance") as? String): "0.00"

   
        

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
//        self.dismiss(animated: false, completion: nil)
        self.dismiss(animated: true) {
            if (self.btnOK.titleLabel?.text) != "Make Payment".localized//dictData.object(forKey: "PaymentType") as! String != "pesapal"
            {
                self.delegate.delegateforGivingRate()
            }
            else
            {
                let next = self.storyboard?.instantiateViewController(withIdentifier: "PesapalWebViewViewController") as! PesapalWebViewViewController
                next.delegate = self
                let url = self.dictData["PaymentURL"] as? String
                next.strUrl = url ?? ""
                UIApplication.topViewController()?.childViewControllers.first?.childViewControllers.first?.navigationController?.pushViewController(next, animated: true)
            }
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


extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
