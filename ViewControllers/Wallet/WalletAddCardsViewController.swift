//
//  WalletAddCardsViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excelent iMac on 28/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import FormTextField

class WalletAddCardsViewController: BaseViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    var aryMonth = [String]()
    var aryYear = [String]()
    
    var strSelectMonth = String()
    var strSelectYear = String()
    
    var pickerView = UIPickerView()
    
    weak var delegateAddCard: AddCadsDelegate!
    
    var delegateAddCardFromHomeVC: addCardFromHomeVCDelegate!
    var delegateAddCardFromBookLater: isHaveCardFromBookLaterDelegate!
    
    var creditCardValidator: CreditCardValidator!
    var isCreditCardValid = Bool()
    
    var cardTypeLabel = String()
    var aryData = [[String:AnyObject]]()
    
    
    
    var CardNumber = String()
    var strMonth = String()
    var strYear = String()
    var strCVV = String()
    
    var aryTempMonth = [String]()
    var aryTempYear = [String]()
    
    var validation = Validation()
    var inputValidator = InputValidator()
    
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
            self.setNavBarWithBack(Title: "ADD CARD".localized, IsNeedRightButton: true)
            setDesignView()
        
        self.btnScanCard.isHidden = true
      
        
        // Initialise Credit Card Validator
            creditCardValidator = CreditCardValidator()
            pickerView.delegate = self
        
        
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        self.currentYear = "\(currentYear)"
        aryYear = (currentYear...(currentYear + 15)).map { String($0) }
        
//        aryMonth = calendar.shortMonthSymbols
        
//        aryMonths = ["January","February","March","April","May","June","July","August","September","October","November","December"]
//        aryMonths = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
            aryMonth = ["01","02","03","04","05","06","07","08","09","10","11","12"]
//            aryYear = ["2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030"]
        
            aryTempMonth = aryMonth //["01","02","03","04","05","06","07","08","09","10","11","12"]
            aryTempYear = aryYear //["2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030"]

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cardNum()
        cardExpiry()
        cardCVV()
        setLocaliztion()
        
    }
    
    func setLocaliztion()
    {
        txtCardNumber.placeholder = "Card Number".localized
        txtValidThrough.placeholder = "Expiry Date".localized
        txtCVVNumber.placeholder = "Enter Card Holder Name"
        btnScanCard.setTitle("scanCard".localized, for: .normal)
        btnAddPaymentMethods.setTitle("Add Card".localized, for: .normal)
    }
    
    @IBOutlet weak var btnScanCard: UIButton!
    func setDesignView() {
        txtCardNumber.leftMargin = 0
        txtCVVNumber.leftMargin = 0
        txtValidThrough.leftMargin = 0
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var btnAddPaymentMethods: ThemeButton!
    
    @IBOutlet weak var txtCardNumber: FormTextField!
    @IBOutlet weak var txtValidThrough: FormTextField!
    @IBOutlet weak var txtCVVNumber: FormTextField!
    @IBOutlet weak var imgCard: UIImageView!
    @IBOutlet weak var txtAlies: UITextField!
    
//    @IBOutlet weak var viewScanCard: UIView!
    //-------------------------------------------------------------
    // MARK: - PicketView Methods
    //-------------------------------------------------------------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return aryMonth.count
        }
        else {
            return aryYear.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return aryMonth[row]
        }
        else {
            return aryYear[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 1 {
            if currentYear == aryYear[row] {
                
                aryYear.removeFirst(row)
                for i in 0..<aryMonth.count {
                    if currentMonth == aryMonth[i] {
                        aryMonth.removeFirst(i - 1)
                    }
                }
                pickerView.reloadComponent(0)
            }
            else {
                aryMonth = aryTempMonth
                aryYear = aryTempYear
                
                pickerView.reloadComponent(0)
            }
        }
        
        if component == 0 {
            strSelectMonth = aryMonth[row]
        }
        else {
            strSelectYear = aryYear[row]
            strSelectYear.removeFirst(2)
        }
        txtValidThrough.text = "\(strSelectMonth)/\(strSelectYear)"
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
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    func cardNum() {
        txtCardNumber.inputType = .integer
        txtCardNumber.formatter = CardNumberFormatter()
        txtCardNumber.setValue(UIColor.black , forKeyPath: "placeholderLabel.textColor")
        txtCardNumber.placeholder = "Card Number"
        txtCardNumber.font = UIFont.regular(ofSize: 13.0)
        txtCardNumber.textColor = UIColor.black
        txtCardNumber.leftMargin = 0
        txtCardNumber.layer.cornerRadius = 5
        validation.maximumLength = 19
        validation.minimumLength = 14
        let characterSet = NSMutableCharacterSet.decimalDigit()
        characterSet.addCharacters(in: " ")
        validation.characterSet = characterSet as CharacterSet
        inputValidator = InputValidator(validation: validation)
        txtCardNumber.inputValidator = inputValidator
    }
    
    func cardExpiry() {

        txtValidThrough.inputType = .integer
        txtValidThrough.formatter = CardExpirationDateFormatter()
        txtValidThrough.placeholder = "Expiration Date (MM/YY)"
        txtValidThrough.setValue(UIColor.black , forKeyPath: "placeholderLabel.textColor")
        txtValidThrough.font = UIFont.regular(ofSize: 13.0)
        txtValidThrough.textColor = UIColor.black
        validation.minimumLength = 1
        let inputValidator = CardExpirationDateInputValidator(validation: validation)
        txtValidThrough.inputValidator = inputValidator
        
    }
    
    
    func cardCVV() {
  
        txtValidThrough.inputType = .name
        txtCVVNumber.placeholder = "Card Holder Name"
        txtCVVNumber.setValue(UIColor.black , forKeyPath: "placeholderLabel.textColor")
        txtCVVNumber.font = UIFont.regular(ofSize: 13.0)
        txtCVVNumber.textColor = UIColor.black
        //        var validation = Validation()
        
//        if self.cardTypeLabel == "Amex" {
//            self.validation.maximumLength = 4
//            self.validation.minimumLength = 4
//        }
//        else {
//            self.validation.maximumLength = 3
//            self.validation.minimumLength = 3
//        }

//        validation.characterSet = NSCharacterSet.decimalDigits
//        let inputValidator = InputValidator(validation: validation)
//        txtCVVNumber.inputValidator = inputValidator
        
        print("txtCVV.text : \(txtCVVNumber.text!)")
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnAddPaymentMethods(_ sender: ThemeButton) {
   
        if (ValidationForAddPaymentMethod()) {
            webserviceOfAddCard()
        }
        
    }
    
    @IBAction func txtValidThrough(_ sender: UITextField) {
        
        txtValidThrough.inputView = pickerView
        
    }
    @IBAction func txtCardNumber(_ sender: UITextField) {
        
        if let number = sender.text {
            if number.isEmpty {
                isCreditCardValid = false
                imgCard.image = UIImage(named: "iconDummyCard")
            } else {
                validateCardNumber(number: number)
                detectCardNumberType(number: number)
            }
        }
    }
    
   /* @IBAction func btnScanCard(_ sender: UIButton) {
        
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC?.modalPresentationStyle = .formSheet
        present(cardIOVC!, animated: true, completion: nil)
    }*/
    
    
    func validateCardNumber(number: String) {
        if creditCardValidator.validate(string: number) {
            isCreditCardValid = true
        } else {
            isCreditCardValid = false
            imgCard.image = UIImage(named: "iconDummyCard")
        }
    }
    
    func detectCardNumberType(number: String) {
        if let type = creditCardValidator.type(from: number) {
            
            isCreditCardValid = true
            
            self.cardTypeLabel = type.name
            
            print(type.name)
            
            imgCard.image = UIImage(named: type.name)
            
            self.cardCVV()
        } else {
            
            imgCard.image = UIImage(named: "iconDummyCard")
            
            isCreditCardValid = false
            self.cardTypeLabel = "Undefined"
        }
    }
    
    func ValidationForAddPaymentMethod() -> Bool {
        
        if (txtCardNumber.text!.count == 0) {

            UtilityClass.setCustomAlert(title: "Missing", message: "Enter Card Number") { (index, title) in
            }
            return false
        }
        else if (txtValidThrough.text!.count == 0) {

            UtilityClass.setCustomAlert(title: "Missing", message: "Enter Expiry Date") { (index, title) in
            }
            return false
        }
        else if (txtCVVNumber.text!.count == 0) {

            UtilityClass.setCustomAlert(title: "Missing", message: "Enter Card Holder Name") { (index, title) in
            }
            return false
        }
//        else if (txtAlies.text!.count == 0) {
//
//            UtilityClass.setCustomAlert(title: "Missing", message: "Enter Bank Name") { (index, title) in
//            }
//            return false
//        }
        
        return true
    }
 
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    
    func webserviceOfAddCard() {
        // PassengerId,CardNo,Cvv,Expiry,Alias (CarNo : 4444555511115555,Expiry:09/20)
   
        var dictData = [String:AnyObject]()
 
        dictData["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
        
        if CardNumber != "" {
            dictData["CardNo"] = CardNumber as AnyObject
        }
        else {
            dictData["CardNo"] = txtCardNumber.text!.replacingOccurrences(of: " ", with: "") as AnyObject
        }
        dictData["card_holder_name"] = txtCVVNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject
        dictData["Expiry"] = txtValidThrough.text!.trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject
        
//        dictData["Alias"] = txtAlies.text as AnyObject
        
        
        webserviceForAddCards(dictData as AnyObject) { (result, status) in
        
            if (status) {
                print(result)
                
                if self.delegateAddCard != nil {
                    self.delegateAddCard.didAddCard(cards: (result as! NSDictionary).object(forKey: "cards") as! NSArray)
                }
              
                self.aryData = (result as! NSDictionary).object(forKey: "cards") as! [[String:AnyObject]]
                
                SingletonClass.sharedInstance.CardsVCHaveAryData = self.aryData
                
                
                if self.delegateAddCardFromBookLater != nil {
                    self.delegateAddCardFromBookLater.didHaveCards()
                }
                
                // Post notification
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CardListReload"), object: nil)

                let alert = UIAlertController(title: nil, message: (result as! NSDictionary).object(forKey: "message") as? String, preferredStyle: .alert)
                let OK = UIAlertAction(title: "OK".localized, style: .default, handler: { ACTION in
                
                    if self.checkPresentation() {
                        self.delegateAddCardFromHomeVC?.didAddCardFromHomeVC()
                        self.delegateAddCardFromBookLater?.didHaveCards()
                        self.dismiss(animated: true, completion: nil)
                    }
                    else {
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            
                alert.addAction(OK)
                self.present(alert, animated: true, completion: nil)
                
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
    
    func checkPresentation() -> Bool {
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
    
    //-------------------------------------------------------------
    // MARK: - Scan Card Methods
    //-------------------------------------------------------------
    
    
/*    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
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
//            txtCardNumber.text = info.cardNumber
            txtValidThrough.text = "\(info.expiryMonth)/\(years)"
            txtCVVNumber.text = info.cvv
            
            
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
            txtValidThrough.text = "\(info.expiryMonth)/\(info.expiryYear)"
        }
        paymentViewController?.dismiss(animated: true, completion: nil)
    }*/
    
    func customStringFormatting(of str: String) -> String {
        return str.characters.chunk(n: 4)
            .map{ String($0) }.joined(separator: " ")
        
    }

}

extension Collection {
    public func chunk(n: IndexDistance) -> [SubSequence] {
        var res: [SubSequence] = []
        var i = startIndex
        var j: Index
        while i != endIndex {
            j = index(i, offsetBy: n, limitedBy: endIndex) ?? endIndex
            res.append(self[i..<j])
            i = j
        }
        return res
    }
}

extension String {
    var pairs: [String] {
        var result: [String] = []
        let characters = Array(self.characters)
        stride(from: 0, to: characters.count, by: 2).forEach {
            result.append(String(characters[$0..<min($0+2, characters.count)]))
        }
        return result
    }
    mutating func insert(separator: String, every n: Int) {
        self = inserting(separator: separator, every: n)
    }
    func inserting(separator: String, every n: Int) -> String {
        var result: String = ""
        let characters = Array(self.characters)
        stride(from: 0, to: characters.count, by: n).forEach {
            result += String(characters[$0..<min($0+n, characters.count)])
            if $0+n < characters.count {
                result += separator
            }
        }
        return result
    }
}
/*

// SuccessFully

{
    cards =     (
        {
            Alias = Kotak;
            CardNum = 4242424242424242;
            CardNum2 = "xxxx xxxx xxxx 4242";
            Id = 3;
            Type = visa;
        }
    );
    message = "Card saved successfully";
    status = 1;
}
 
// Failed
 
{
    message = "Parameter missing";
    status = 0;
}
 
*/
