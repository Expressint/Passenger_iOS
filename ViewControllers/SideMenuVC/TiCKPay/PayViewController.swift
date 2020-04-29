//
//  PayViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 12/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import FormTextField
import CreditCardForm

class PayViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CardIOPaymentViewControllerDelegate, UITextFieldDelegate {

   
    let pickerView = UIPickerView()
    let datePicker = UIDatePicker()
    
    var pickerData: [String] = [String]()
    
    var strPaymentInputMethod = String()
    
    var isCheckedTickPay = Bool()
    var strAmount = String()
    
    var aryMonths = [String]()
    var aryYears = [String]()
    var strSelectedMonth = String()
    var strSelectedYear = String()
    
    var creditCardValidator: CreditCardValidator!
    
    var isCreditCardValid = Bool()
    var validation = Validation()
    var inputValidator = InputValidator()
    
    var CardNumber = String()
    var strMonth = String()
    var strYear = String()
    var strCVV = String()
    
    var aryTempMonth = [String]()
    var aryTempYear = [String]()
    
    var strTransactionFee = String()
    var steGetTickPayRate = String()
    var strAmountOfTotal = String()
    
    var sendAmount = String()
    
    var dummytxtCreditCardNumber = UITextField()
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webserviceOFGetTickpayRate()
        
//        txtCardNumber.delegate = self

        
        SingletonClass.sharedInstance.strIsFirstTimeTickPay = "first"
        
        btnPayNow.layer.cornerRadius = 5
        btnPayNow.layer.masksToBounds = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func setTextFieldCornerRadious() {
        
        txtExpiryDate.layer.cornerRadius = 5
        txtExpiryDate.layer.masksToBounds = true
        
        txtCardNumber.layer.cornerRadius = 5
        txtCardNumber.layer.masksToBounds = true
        
        txtCVV.layer.cornerRadius = 5
        txtCVV.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if SingletonClass.sharedInstance.strIsFirstTimeTickPay == "first" {
            
        }
        else if SingletonClass.sharedInstance.strIsFirstTimeTickPay == "FormAlertYes" {
//            self.performSegue(withIdentifier: "segueForInVoice", sender: nil)
            let next = self.storyboard?.instantiateViewController(withIdentifier: "InVoiceReceiptViewController") as! InVoiceReceiptViewController
            SingletonClass.sharedInstance.strIsFirstTimeTickPay = ""
            self.navigationController?.pushViewController(next, animated: true)
        }
        else if SingletonClass.sharedInstance.strIsFirstTimeTickPay == "FromInVoice" {
            
        
            let next = self.storyboard?.instantiateViewController(withIdentifier: "TickPayAlertViewController") as! TickPayAlertViewController
            next.modalPresentationStyle = .formSheet
            
            
            next.strBtnNo = "OK"
            next.strMessage = "Payment Receipt sent successfully!"
            next.isBtnYesVisible = true
            self.present(next, animated: true, completion: nil)
            
        }
        
        
        
        aryMonths = ["01","02","03","04","05","06","07","08","09","10","11","12"]
        aryYears = ["2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030"]
        
        aryTempMonth = ["01","02","03","04","05","06","07","08","09","10","11","12"]
        aryTempYear = ["2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030"]
        creditCardValidator = CreditCardValidator()
        pickerView.delegate = self
        
        
//        viewTickPay.layer.borderWidth = 1
        viewTickPay.layer.borderColor = UIColor.darkGray.cgColor
        
        viewTickPay.layer.shadowOpacity = 0.3
        viewTickPay.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        
        findCurrentMonthAndYear()
        
        cardNum()
        cardExpiry()
        cardCVV()
        
        
        let profileData = SingletonClass.sharedInstance.dictProfile
        self.txtABNNumber.text = (profileData).object(forKey: "ABN") as? String
        self.txtCompanyName.text = (profileData).object(forKey: "CompanyName") as? String
        
        txtCVV.isHidden = true
        
    }
 
    func cardNum() {
        txtCardNumber.inputType = .integer
        txtCardNumber.formatter = CardNumberFormatter()
        txtCardNumber.placeholder = "Card Number"
        txtCardNumber.leftMargin = 0
        txtCardNumber.layer.cornerRadius = 5
        txtCardNumber.backgroundColor = UIColor.white
        txtCardNumber.activeBackgroundColor = UIColor.white
        txtCardNumber.enabledBackgroundColor = UIColor.white
        txtCardNumber.invalidBackgroundColor = UIColor.white
        txtCardNumber.disabledBackgroundColor = UIColor.white
        txtCardNumber.inactiveBackgroundColor = UIColor.white
        
        validation.maximumLength = 19
        validation.minimumLength = 14
        let characterSet = NSMutableCharacterSet.decimalDigit()
        characterSet.addCharacters(in: " ")
        validation.characterSet = characterSet as CharacterSet
        
        inputValidator = InputValidator(validation: validation)

        txtCardNumber.inputValidator = inputValidator
        
        let cardNumber = FormTextField()
        cardNumber.inputValidator = inputValidator
        
        
        let data = txtCardNumber.text?.suffix(4)
        
        let strCardNumber = txtCardNumber.text!
        print("strCardNumber : \(strCardNumber)")
        
        let changeToX = maskNumber(strCardNumber)
        
         print("changeToX : \(changeToX)")
        
    }
    
    func cardExpiry() {
        txtExpiryDate.inputType = .integer
        txtExpiryDate.formatter = CardExpirationDateFormatter()
        txtExpiryDate.placeholder = "Expiration Date (MM/YY)"
        
        txtExpiryDate.leftMargin = 0
        txtExpiryDate.layer.cornerRadius = 5
        txtExpiryDate.backgroundColor = UIColor.white
        txtExpiryDate.activeBackgroundColor = UIColor.white
        txtExpiryDate.enabledBackgroundColor = UIColor.white
        txtExpiryDate.invalidBackgroundColor = UIColor.white
        txtExpiryDate.disabledBackgroundColor = UIColor.white
        txtExpiryDate.inactiveBackgroundColor = UIColor.white
 
//        var validation = Validation()
        validation.minimumLength = 1
        let inputValidator = CardExpirationDateInputValidator(validation: validation)
        txtExpiryDate.inputValidator = inputValidator
   
        
    }
    
    func cardCVV() {
 
        txtCVV.inputType = .integer
        txtCVV.placeholder = "CVC"
        
        txtCVV.leftMargin = 0
        txtCVV.layer.cornerRadius = 5
        txtCVV.backgroundColor = UIColor.white
        txtCVV.activeBackgroundColor = UIColor.white
        txtCVV.enabledBackgroundColor = UIColor.white
        txtCVV.invalidBackgroundColor = UIColor.white
        txtCVV.disabledBackgroundColor = UIColor.white
        txtCVV.inactiveBackgroundColor = UIColor.white
        
//        var validation = Validation()
        validation.maximumLength = 3
        validation.minimumLength = 3
        validation.characterSet = NSCharacterSet.decimalDigits
        let inputValidator = InputValidator(validation: validation)
        txtCVV.inputValidator = inputValidator
        
        print("txtCVV.text : \(txtCVV.text)")
    }
    

    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
  
    @IBOutlet weak var txtCompanyName: UITextField!
    @IBOutlet weak var txtABNNumber: UITextField!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var txtPaymentInputMethod: UITextField!

    @IBOutlet weak var txtCardNumber: FormTextField!
    @IBOutlet weak var txtExpiryDate: FormTextField!
    @IBOutlet weak var txtCVV: FormTextField!
    
    @IBOutlet weak var viewTickPay: UIView!
    
    @IBOutlet weak var btnCheckMarkTickPay: UIButton!
    
    
    @IBOutlet weak var txtFinalMount: UITextField!
    
    @IBOutlet weak var btnPayNow: ThemeButton!
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnBackToNavigate(_ sender: UIButton) {
        
        if isModal() {
            self.dismiss(animated: true, completion: {
                
            })
        }
        else {
            
            for vc in (self.navigationController?.viewControllers ?? []) {
                if vc is CustomSideMenuViewController {
                    _ = self.navigationController?.popToViewController(vc, animated: true)
                    break
                }
            }
        }
    }
    
    func isModal() -> Bool {
        if (presentingViewController != nil) {
            return true
        }
        if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        }
        if (tabBarController?.presentingViewController is UITabBarController) {
            return true
        }
        return false
    }
    
    
    
    @IBAction func btnCheckMarkTickPay(_ sender: UIButton) {
        
        isCheckedTickPay = !isCheckedTickPay
        
        if (isCheckedTickPay) {
            
            btnCheckMarkTickPay.setImage(UIImage(named: "iconCheckMarkSelected"), for: .normal)
        }
        else {
            
            btnCheckMarkTickPay.setImage(UIImage(named: "iconCheckMarkUnSelected"), for: .normal)
        }
    }
    
    
    @IBAction func btnPaymentInputMethod(_ sender: UIButton) {
    }
    
    @IBAction func txtPaymentInputMethod(_ sender: UITextField) {

        txtPaymentInputMethod.inputView = pickerView
        
    }
    
    
    
    @IBAction func btnPayNow(_ sender: ThemeButton) {

//        let next = self.storyboard?.instantiateViewController(withIdentifier: "TickPayAlertViewController") as! TickPayAlertViewController
//        next.modalPresentationStyle = .formSheet
//        self.present(next, animated: true, completion: nil)


        if txtCardNumber.text == "" {
//            UtilityClass.showAlert("Missing", message: "Please Enter Card Number", vc: self)
            UtilityClass.setCustomAlert(title: "Missing", message: "Please Enter Card Number") { (index, title) in
            }
        }
//        else if isCreditCardValid == false {
//            UtilityClass.showAlert("Sorry", message: "Card Number is invalid", vc: self)
//        }
//        else if txtCardNumber.text!.count < 14 || txtCardNumber.text!.count >= 19 {
//            UtilityClass.showAlert("Sorry", message: "Card Number is invalid", vc: self)
//        }
//        else if strSelectedMonth == "" || strSelectedYear == "" {
//            UtilityClass.showAlert("Missing", message: "Please select Expiry Date", vc: self)
//        }
        else if txtCompanyName.text == ""
        {
//            UtilityClass.showAlert("Missing", message: "Please Enter Company Name / Name", vc: self)
            UtilityClass.setCustomAlert(title: "Missing", message: "Please Enter Company Name / Name") { (index, title) in
            }
        }
        else if txtAmount.text == "" {
//            UtilityClass.showAlert("Missing", message: "Please Enter Amount", vc: self)
            UtilityClass.setCustomAlert(title: "Missing", message: "Please Enter Amount") { (index, title) in
            }
        }
        else if txtExpiryDate.text == "" {
//            UtilityClass.showAlert("Missing", message: "Please Enter Expiry Date", vc: self)
            UtilityClass.setCustomAlert(title: "Missing", message: "Please Enter Expiry Date") { (index, title) in
            }
        }
        else if txtCVV.isHidden == false {
            
            if txtCVV.text == "" {
//                UtilityClass.showAlert("Missing", message: "Please enter CVV Number", vc: self)
                UtilityClass.setCustomAlert(title: "Missing", message: "Please enter CVV Number") { (index, title) in
                }
            }
            else if txtCVV.text!.count != 3 {
//                UtilityClass.showAlert("", message: "Please enter valid CVV Number", vc: self)
                UtilityClass.setCustomAlert(title: "Missing", message: "Please enter valid CVV Number") { (index, title) in
                }
            }
        }
        else {
            
            webserviceofTiCKPay()
        }
 
        
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Picker Methods
    //-------------------------------------------------------------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            
            return aryMonths.count
        }
        else {
            return aryYears.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            
            return aryMonths[row]
        }
        else {
            return aryYears[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 1 {
//            currentYear = "2019"
            
            let year = aryYears[row]
            if Int(currentYear)! == Int(year)! {
                
                aryYears.removeFirst(row)
                for i in 0..<aryMonths.count {
                    if currentMonth == aryMonths[i] {
                        aryMonths.removeFirst(i - 1)
                    }
                }
                aryTempYear = aryYears
                pickerView.reloadAllComponents()
            }
            else {
                aryMonths = aryTempMonth
                aryYears = aryTempYear
                
                pickerView.reloadAllComponents()
            }
        }
        
        if component == 0 {
            strSelectedMonth = aryMonths[row]
        }
        else {
            strSelectedYear = aryYears[row]
            strSelectedYear.removeFirst(2)
        }
        
        txtExpiryDate.text = "\(strSelectedMonth)/\(strSelectedYear)"
    }
    

    func setTextFields() {
        
//        txtPaymentInputMethod.text = strPaymentInputMethod
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    @IBAction func txtExpiryDate(_ sender: UITextField) {
        

//        txtExpiryDate.text = pickerView.selectRow(0, inComponent: 1, animated: true)
    
            strSelectedMonth = aryMonths[0]
            strSelectedYear = aryYears[0]
//        txtExpiryDate.text = "\(strSelectedMonth)/\(strSelectedYear)"
//        txtExpiryDate.inputView = pickerView
    }
    
    @IBAction func txtEnterAmount(_ sender: UITextField) {
        
        if let amountString = txtAmount.text?.currencyInputFormatting() {
            txtAmount.text = amountString
 
            let unfiltered = amountString   //  "!   !! yuahl! !"
            
            // Array of Characters to remove
            let removal: [Character] = ["$",","," "]    // ["!"," "]
            
            // turn the string into an Array
            let unfilteredCharacters = unfiltered.characters
            
            // return an Array without the removal Characters
            let filteredCharacters = unfilteredCharacters.filter { !removal.contains($0) }
            
            // build a String with the filtered Array
            let filtered = String(filteredCharacters)
            
            print(filtered) // => "yeah"
            
            // combined to a single line
            print(String(unfiltered.characters.filter { !removal.contains($0) })) // => "yuahl"
            
            strAmount = String(unfiltered.characters.filter { !removal.contains($0) })
            print("amount : \(strAmount)")

            var amt = strAmount.trimmingCharacters(in: .whitespacesAndNewlines)
            
            var doubleAmt = (amt as NSString).doubleValue
            
            if doubleAmt >= 100.00 {
                txtCVV.isHidden = false
            }
            else {
                txtCVV.isHidden = true
            }
            
            var doubleValue = (steGetTickPayRate as NSString).doubleValue
            
            var countPercenteage = (doubleAmt * doubleValue)/100
            
            var finalValue = ((strAmount as NSString).doubleValue)
            
            let total = finalValue + countPercenteage
            
            txtFinalMount.text = "$\(String(format: "%.2f", total))"  // "$\(finalValue + countPercenteage)"
            strAmountOfTotal = "\(finalValue + countPercenteage)"
            
        }
        
    }
    
    
    @IBAction func txtCardNumber(_ sender: UITextField) {
        
    }
    
    func validateCardNumber(number: String) {
        if creditCardValidator.validate(string: number) {
            
            isCreditCardValid = true
            
        } else {
            
            isCreditCardValid = false
        }
    }
    
    func detectCardNumberType(number: String) {
        if let type = creditCardValidator.type(from: number) {
            
            isCreditCardValid = true
            print(type.name)

        } else {
            isCreditCardValid = false
        }
    }
    
    @IBAction func btnScanCard(_ sender: UIButton) {
        
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC?.modalPresentationStyle = .formSheet
        present(cardIOVC!, animated: true, completion: nil)
        
    }
    
    var currentMonth = String()
    var currentYear = String()
    
    func findCurrentMonthAndYear() {
        
        let now = NSDate()
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"
        let curMonth = monthFormatter.string(from: now as Date)
        print("currentMonth : \(curMonth)")
        currentMonth = curMonth
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        let curYear = yearFormatter.string(from: now as Date)
        print("currentYear : \(curYear)")
        currentYear = curYear
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Scan Card Methods
    //-------------------------------------------------------------
    
    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
        dismiss(animated: true, completion: nil)
    }
    
    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
        
        print("CardInfo : \(cardInfo)")
        
        if let info = cardInfo {
            let str = NSString(format: "Received card info.\n Number: %@\n expiry: %02lu/%lu\n cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv)
            //            resultLabel.text = str as String
            
            print("Card Number : \(info.cardNumber)")
            print("Redacted Card Number : \(customStringFormatting(of: info.redactedCardNumber))")
            print("Month : \(info.expiryMonth)")
            print("Year : \(info.expiryYear)")
            print("CVV : \(info.cvv)")
            
            var years = String(info.expiryYear)
            years.removeFirst(2)
//            customStringFormatting(of: info.redactedCardNumber)
            
            print("Removed Year : \(years)")
            
            txtCardNumber.text = customStringFormatting(of: info.redactedCardNumber)
            txtExpiryDate.text = "\(info.expiryMonth)/\(years)"
            txtCVV.text = info.cvv
            
            CardNumber = String(info.cardNumber)
            strMonth = String(info.expiryMonth)
            strYear = String(years)
            strCVV = String(info.cvv)
            
        }
        paymentViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    func userDidCancelPaymentViewController(paymentViewController: CardIOPaymentViewController!) {
//        resultLabel.text = "user canceled"
        paymentViewController?.dismiss(animated: true, completion: nil)
    }
    
    func userDidProvideCreditCardInfo(cardInfo: CardIOCreditCardInfo!, inPaymentViewController paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {
            let str = NSString(format: "Received card info.\n Number: %@\n expiry: %02lu/%lu\n cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv)
//            resultLabel.text = str as String
            txtCardNumber.text = info.redactedCardNumber
            txtExpiryDate.text = "\(info.expiryMonth)/\(info.expiryYear)"
        }
        paymentViewController?.dismiss(animated: true, completion: nil)
    }
    
    func customStringFormatting(of str: String) -> String {
        return str.characters.chunk(n: 4)
            .map{ String($0) }.joined(separator: " ")

    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func maskNumber(_ num: String) -> String {
        let twelveX = "XXXXXXXXXXXX"
        if (num.count ?? 0) < (twelveX.count ?? 0) {
            return ((twelveX as? NSString)?.substring(to: (num.count ?? 0))) ?? ""
        }
        else {
            return twelveX + (((num as? NSString)?.substring(from: (twelveX.count ?? 0))) ?? "")
        }
    }
  
    var cardNumStr = String()
    

    
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    func webserviceofTiCKPay() {
//        PassengerId,Name,ABN,Amount,CardNo,CVV,Expiry,Passport
        
        print("strAmount : \(strAmount)")
//        strAmount.removeFirst()
        print("finalAmount : \(strAmount)")
        
        var param = [String:AnyObject]()
        param["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
        param["Name"] = txtCompanyName.text as AnyObject
        param["Amount"] = strAmount.trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject
        
        if CardNumber.count != 0 {
           
            param["CardNo"] = CardNumber as AnyObject
        }
        else {
//            (txtCardNumber.text!).replacingOccurrences(of: " ", with: "")
            
            param["CardNo"] = (txtCardNumber.text!).replacingOccurrences(of: " ", with: "") as AnyObject
        }
        
        if  txtCVV.isHidden == true {
            
        }
        else {
            
            if strCVV.count != 0 {
                param["CVV"] = strCVV as AnyObject
            }
            else {
                param["CVV"] = txtCVV.text! as AnyObject
            }
        }
        
        
        
//        param["Expiry"] = "\(strMonth)/\(strYear)" as AnyObject

        if strMonth.count != 0 && strYear.count != 0 {
            param["Expiry"] = "\(strMonth)/\(strYear)" as AnyObject
        }
        else {
             param["Expiry"] = txtExpiryDate.text as AnyObject
        }
        
        SingletonClass.sharedInstance.strAmoutOFTickPay = strAmountOfTotal.trimmingCharacters(in: .whitespacesAndNewlines)
        
        SingletonClass.sharedInstance.strAmoutOFTickPayOriginal = strAmount.trimmingCharacters(in: .whitespacesAndNewlines)
       
        
        webserviceForTickPay(param as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                DispatchQueue.main.async {
                    
                    if let res = result as? NSDictionary {
                        SingletonClass.sharedInstance.strTickPayId = String(describing: res.object(forKey: "tickpay_id")!)
                    }
                    
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "TickPayAlertViewController") as! TickPayAlertViewController
                    next.modalPresentationStyle = .formSheet
                    
                    self.present(next, animated: true, completion: nil)
                    
//                    if let res = result as? String {
//                        UtilityClass.showAlert("", message: res, vc: self)
//                    }
//                    else {
//                        UtilityClass.showAlert("", message: (result as! NSDictionary).object(forKey: "message") as! String, vc: self)
//                    }
                }
                
                
                self.txtCVV.text = ""
                self.txtAmount.text = ""
//                self.txtABNNumber.text = ""
                self.txtCardNumber.text = ""
                self.txtExpiryDate.text = ""
//                self.txtCompanyName.text = ""
            }
            else {
                print(result)
                
                DispatchQueue.main.async {
                    
                    if let res = result as? String {
                      
                        UtilityClass.setCustomAlert(title: "Error", message: res) { (index, title) in
                        }
                        
                    }
                    else {
                        
                        UtilityClass.setCustomAlert(title: "Error", message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                        }
                    }
                    
                    
                }
            }
        }
    }
    
   
    func webserviceOFGetTickpayRate() {
        
        
        webserviceForGetTickpayRate("" as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                if let res = result as? NSDictionary {
                    self.steGetTickPayRate = res.object(forKey: "rate") as! String
                    self.strTransactionFee = res.object(forKey: "TransactionFee") as! String
                    self.lblCredirAndDebitRate.text = "\(self.steGetTickPayRate)% Service fee \n$\(self.strTransactionFee) Transaction fee"
  
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
    @IBOutlet weak var lblCredirAndDebitRate: UILabel!
    
    func validationForTiCKPay() -> Bool {
        
        
        return true
    }
    
    
    
    //-------------------------------------------------------------
    // MARK: - Segue Methods
    //-------------------------------------------------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationOfCarAndTaxi = segue.destination as? InVoiceReceiptViewController {
        }
        
    }
    
    
}


/*
{
    message = "Received money from tickpay";
    status = 1;
    "tickpay_id" = 92;
    walletBalance = "-446.4200308025";
}
 */
