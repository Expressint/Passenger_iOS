//
//  PackageDetailViewController.swift
//  PickNGo User
//
//  Created by Rahul Patel on 04/03/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit

class PackageDetailViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {

    var strPickupLocation = String()

    var strPickupDate = String()
    var strPickupTime = String()
    var pickerView = UIPickerView()
    var dictCarModelData = [String: AnyObject]()
    var paymentType = String()
    var strVehicleType = String()
    var doublePickupLat = Double()
    var doublePickupLng = Double()
    var CardID = String()
    
    
    @IBOutlet var btnConfirm: UIButton!
    @IBOutlet var lblAdditionalChange: UILabel!
    @IBOutlet var lblPackagelimit: UILabel!
    //    @IBOutlet var lblPickupLocation: UILabel!
    @IBOutlet var lblAdditionalCharges: UILabel!
    @IBOutlet var lblPickupLocation : UILabel!
    @IBOutlet var lblPickupLDate : UILabel!
    @IBOutlet var lblPickupTime : UILabel!
    @IBOutlet var lblPackageType : UILabel!
    @IBOutlet var lblDays : UILabel!
    @IBOutlet var lblDistance : UILabel!
    @IBOutlet var lblVehicleType : UILabel!
    @IBOutlet var lblAmount : UILabel!
    @IBOutlet var lblTypeTitle : UILabel!
     @IBOutlet weak var txtSelectPaymentMethod: UITextField!
     @IBOutlet weak var txtPromoCode: UITextField!
    @IBOutlet weak var imgPaymentOption: UIImageView!
 
    override func viewDidLoad() {
        super.viewDidLoad()

         pickerView.delegate = self
        webserviceOfCardList()
        lblPickupLocation.text = strPickupLocation

        lblPickupLDate.text = strPickupDate
        lblPickupTime.text = strPickupTime
        
        
        lblPackageType.text = dictCarModelData["Type"] as? String
        lblDistance.text = "\(dictCarModelData["KM"] as! String) KMs"
        
        lblAmount.text = "$ \(dictCarModelData["Amount"] as! String)"
        lblVehicleType.text = strVehicleType
        
        if dictCarModelData["Type"] as? String == "hours"
        {
            lblTypeTitle.text = "Hours"
            lblDays.text = dictCarModelData["Time"] as? String
        }
        else
        {
            lblTypeTitle.text = "Days"
            lblDays.text = dictCarModelData["Time"] as? String
        }
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
        self.title = "Packages Details"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : themeYellowColor]
        
        
        let btnback :UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "iconCloseAlert"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(btnBackClicked(_:)))
        self.navigationItem.leftBarButtonItem = btnback
        
        let btnCall :UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "iconCallSmall"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(btnCallClicked(_:)))
        self.navigationItem.rightBarButtonItem = btnCall
        
        if SingletonClass.sharedInstance.CardsVCHaveAryData.count != 0 {
            pickerView.reloadAllComponents()
            txtSelectPaymentMethod.text = ""
            imgPaymentOption.image = UIImage(named: "iconDummyCard")
            //            paymentType = "cash"
            pickerView.selectedRow(inComponent: 0)
            txtSelectPaymentMethod.becomeFirstResponder()
            txtSelectPaymentMethod.resignFirstResponder()
            
        }
        
        txtSelectPaymentMethod.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(self.IQKeyboardmanagerDoneMethod))
        
        setLocalization()
    }
    func setLocalization()
    {
        lblPickupLocation.text = "Pickup Location".localized
        lblPickupLDate.text = "PickupDate".localized
        lblPickupTime.text = "Pickup Time".localized
        lblPackageType.text = "Package Type".localized
        lblAmount.text = "Amount".localized
        txtSelectPaymentMethod.text = "Select Payment Method".localized
        txtPromoCode.text = "Promo Code".localized
        lblPackagelimit.text = "If you were to will be chanxceed package limites you will be charged as follows".localized
        lblAdditionalCharges.text = "Additional Charges".localized
        btnConfirm.setTitle("Confirm".localized, for: .normal)
        
    }
    
    
    @IBAction func txtSelectPaymentMethod(_ sender: UITextField) {
        
        txtSelectPaymentMethod.inputView = pickerView
    }
    
    
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
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)")
        {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
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
    
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    var aryCards = [[String:AnyObject]]()
    
    func webserviceOfCardList() {
        
        webserviceForCardList(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                if let res = result as? [String:AnyObject] {
                    if let cards = res["cards"] as? [[String:AnyObject]] {
                        self.aryCards = cards
                    }
                }
                
                var dict = [String:AnyObject]()
                dict["CardNum"] = "cash" as AnyObject
                dict["CardNum2"] = "cash" as AnyObject
                dict["Type"] = "iconCashBlack" as AnyObject
                
                var dict2 = [String:AnyObject]()
                dict2["CardNum"] = "wallet" as AnyObject
                dict2["CardNum2"] = "wallet" as AnyObject
                dict2["Type"] = "iconWalletBlack" as AnyObject
                
                
                self.aryCards.append(dict)
                self.aryCards.append(dict2)
                
                if self.aryCards.count == 2 {
                    var dict3 = [String:AnyObject]()
                    dict3["Id"] = "000" as AnyObject
                    dict3["CardNum"] = "Add a Card" as AnyObject
                    dict3["CardNum2"] = "Add a Card" as AnyObject
                    dict3["Type"] = "iconPlusBlack" as AnyObject
                    self.aryCards.append(dict3)
                    
                }
                
                self.pickerView.selectedRow(inComponent: 0)
                let data = self.aryCards[0]
                
                self.imgPaymentOption.image = UIImage(named: self.setCardIcon(str: data["Type"] as! String))
                self.txtSelectPaymentMethod.text = data["CardNum2"] as? String
                
                let type = data["CardNum"] as! String
                
                if type  == "wallet" {
                    self.paymentType = "wallet"
                }
                else if type == "cash" {
                    self.paymentType = "cash"
                }
                else
                {
                    self.paymentType = "card"
                }
                if self.paymentType == "card" {
                    
                    if data["Id"] as? String != "" {
                        self.CardID = data["Id"] as! String
                    }
                }
                else
                {
                    self.CardID = ""
                }
                self.pickerView.reloadAllComponents()
                
                /*
                 {
                 cards =     (
                 {
                 Alias = visa;
                 CardNum = 4639251002213023;
                 CardNum2 = "xxxx xxxx xxxx 3023";
                 Id = 59;
                 Type = visa;
                 }
                 );
                 status = 1;
                 }
                 */
                
                
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
    
    func webserviceOfBookPackage() {
        
        var dictPara = [String:AnyObject]()
//        PassengerId , PackageId , PickupLocation , PickupDate , PickupTime , PaymentType(cash,card) , CardId(If Select PaymentType is card then it is mandatory field)
        dictPara["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
        dictPara["PackageId"] = dictCarModelData["Id"] as? String as AnyObject
        dictPara["PickupLocation"] = strPickupLocation as AnyObject

        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        let yourDate = formatter.date(from: strPickupDate)
        formatter.dateFormat = "yyyy-MM-dd"
        let myStringafd = formatter.string(from: yourDate!)
        print(myStringafd)
        
        
        dictPara["PickupDate"] = myStringafd as AnyObject
        
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "hh:mm a"
        let yourDateTime = formatter1.date(from: strPickupTime)
        formatter1.dateFormat = "HH:mm:ss"
        let mytime = formatter1.string(from: yourDateTime!)
        print(mytime)
        
        dictPara["PickupTime"] = mytime as AnyObject
        
        
        if paymentType == "" {
            
            UtilityClass.setCustomAlert(title: "Missing", message: "Select Payment Type") { (index, title) in
            }
        }
        else
        {
            dictPara["PaymentType"] = paymentType as AnyObject
        }
        
        if CardID == "" {
            
        }
        else {
            dictPara["CardId"] = CardID as AnyObject
        }
        
        
//        if lblPromoCode.text == "" {
//            
//        }
//        else {
//            dictData["PromoCode"] = lblPromoCode.text as AnyObject
//        }
        
        
        
        
        webserviceForBookPackage(dictPara as AnyObject)
        { (result, status) in
            if (status)
            {
                print(result)
                let alert = UIAlertController(title: nil, message: result["message"] as? String, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: { [weak alert] (_) in
                    self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)

                }))
                self.present(alert, animated: true, completion: nil)
                
                //                                if let res = result as? [String:AnyObject] {
                //                                    if let cards = res["cards"] as? [[String:AnyObject]] {
                //                                        self.aryCards = cards
                //                                    }
                //                                }
                //
                //                                var dict = [String:AnyObject]()
                //                                dict["CardNum"] = "cash" as AnyObject
                //                                dict["CardNum2"] = "cash" as AnyObject
                //                                dict["Type"] = "iconCashBlack" as AnyObject
                //
                //                                var dict2 = [String:AnyObject]()
                //                                dict2["CardNum"] = "wallet" as AnyObject
                //                                dict2["CardNum2"] = "wallet" as AnyObject
                //                                dict2["Type"] = "iconWalletBlack" as AnyObject
                //
                //
                //                                self.aryCards.append(dict)
                //                                self.aryCards.append(dict2)
                //
                //                                if self.aryCards.count == 2 {
                //                                    var dict3 = [String:AnyObject]()
                //                                    dict3["Id"] = "000" as AnyObject
                //                                    dict3["CardNum"] = "Add a Card" as AnyObject
                //                                    dict3["CardNum2"] = "Add a Card" as AnyObject
                //                                    dict3["Type"] = "iconPlusBlack" as AnyObject
                //                                    self.aryCards.append(dict3)
                //
                //                                }
                //
                //                                self.pickerView.selectedRow(inComponent: 0)
                //                                let data = self.aryCards[0]
                //
                //                                self.imgPaymentOption.image = UIImage(named: self.setCardIcon(str: data["Type"] as! String))
                //                                self.txtSelectPaymentMethod.text = data["CardNum2"] as? String
                //
                //                                let type = data["CardNum"] as! String
                //
                //                                if type  == "wallet" {
                //                                    self.paymentType = "wallet"
                //                                }
                //                                else if type == "cash" {
                //                                    self.paymentType = "cash"
                //                                }
                //                                else {
                //                                    self.paymentType = "card"
                //                                }
                //
                //                                self.pickerView.reloadAllComponents()
                //
                //                                /*
                //                                 {
                //                                 cards =     (
                //                                 {
                //                                 Alias = visa;
                //                                 CardNum = 4639251002213023;
                //                                 CardNum2 = "xxxx xxxx xxxx 3023";
                //                                 Id = 59;
                //                                 Type = visa;
                //                                 }
                //                                 );
                //                                 status = 1;
                //                                 }
                //                                 */
                //
                
            }
            else {
                                print(result)


                
                let alert = UIAlertController(title: nil, message: result["message"] as? String, preferredStyle: .alert)
                
                let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OK)
                self.present(alert, animated: true, completion: nil)
                //                if let res = result as? String {
                //                    UtilityClass.setCustomAlert(title: "Error", message: res) { (index, title) in
                //                    }
                //                }
                //                else if let resDict = result as? NSDictionary {
                //                    UtilityClass.setCustomAlert(title: "Error", message: resDict.object(forKey: "message") as! String) { (index, title) in
                //                    }
                //                }
                //                else if let resAry = result as? NSArray {
                //                    UtilityClass.setCustomAlert(title: "Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                //                    }
                //                }
                            }
        }
        

    }
    
    
    //-------------------------------------------------------------
    // MARK: - PickerView Methods
    //-------------------------------------------------------------
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return aryCards.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    //    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    //
    //    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let data = aryCards[row]
        
        let myView = UIView(frame: CGRect(x:0, y:0, width: pickerView.bounds.width - 30, height: 60))
        
        let centerOfmyView = myView.frame.size.height / 4
        
        
        let myImageView = UIImageView(frame: CGRect(x:0, y:centerOfmyView, width:40, height:26))
        myImageView.contentMode = .scaleAspectFit
        
        var rowString = String()
        
        
        switch row {
            
        case 0:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 1:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 2:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 3:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 4:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 5:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 6:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 7:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 8:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 9:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 10:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        default:
            rowString = "Error: too many rows"
            myImageView.image = nil
        }
        let myLabel = UILabel(frame: CGRect(x:60, y:0, width:pickerView.bounds.width - 90, height:60 ))
        //        myLabel.font = UIFont(name:some, font, size: 18)
        myLabel.text = rowString
        
        myView.addSubview(myLabel)
        myView.addSubview(myImageView)
        
        return myView
    }
    
    var isAddCardSelected = Bool()
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let data = aryCards[row]
        
        imgPaymentOption.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        txtSelectPaymentMethod.text = data["CardNum2"] as? String
        
        if data["CardNum"] as! String == "Add a Card" {
            
            isAddCardSelected = true
            //            self.addNewCard()
        }
        
        let type = data["CardNum"] as! String
        
        if type  == "wallet" {
            paymentType = "wallet"
        }
        else if type == "cash" {
            paymentType = "cash"
        }
        else {
            paymentType = "card"
        }
        
        
        if paymentType == "card" {
            
            if data["Id"] as? String != "" {
                CardID = data["Id"] as! String
            }
        }
        
        // do something with selected row
    }
    func setCardIcon(str: String) -> String {
        //        visa , mastercard , amex , diners , discover , jcb , other
        var CardIcon = String()
        
        switch str {
        case "visa":
            CardIcon = "Visa"
            return CardIcon
        case "mastercard":
            CardIcon = "MasterCard"
            return CardIcon
        case "amex":
            CardIcon = "Amex"
            return CardIcon
        case "diners":
            CardIcon = "Diners Club"
            return CardIcon
        case "discover":
            CardIcon = "Discover"
            return CardIcon
        case "jcb":
            CardIcon = "JCB"
            return CardIcon
        case "iconCashBlack":
            CardIcon = "iconCashBlack"
            return CardIcon
        case "iconWalletBlack":
            CardIcon = "iconWalletBlack"
            return CardIcon
        case "iconPlusBlack":
            CardIcon = "iconPlusBlack"
            return CardIcon
        case "other":
            CardIcon = "iconDummyCard"
            return CardIcon
        default:
            return ""
        }
        
    }
    
    func didHaveCards()
    {
        
        aryCards.removeAll()
        webserviceOfCardList()
    }
    
    
    @objc func IQKeyboardmanagerDoneMethod() {
        
        if (isAddCardSelected) {
            self.addNewCard()
        }
        
        //        txtSelectPaymentMethod.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(self.IQKeyboardmanagerDoneMethod))
    }
    
    func addNewCard() {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
//        next.delegateAddCardFromBookLater = self
        self.isAddCardSelected = false
        self.navigationController?.present(next, animated: true, completion: nil)
    }
    
    @IBAction func btnBookingConfirmClicked(_ sender: Any)
    {
        webserviceOfBookPackage()
    }
    
    
    
}
