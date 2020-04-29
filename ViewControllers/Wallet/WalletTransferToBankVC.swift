//
//  WalletTransferToBankVC.swift
//  TiCKTOC-Driver
//
//  Created by Excelent iMac on 23/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift

@objc protocol SelectBankCardDelegate {
    
    func didSelectBankCard(dictData: [String: AnyObject])
}

class WalletTransferToBankVC: BaseViewController, SelectBankCardDelegate {

    
    
    var strCardId = String()
    var strAmt = String()
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setLocalization()
        setData()

        self.setNavBarWithBack(Title: "TRANSFER TO BANK".localized, IsNeedRightButton: true)
        
//        headerView?.btnBack.addTarget(self, action: #selector(self.btnBackAction), for: .touchUpInside)
        
        viewMain.layer.cornerRadius = 5
        viewMain.layer.masksToBounds = true
        
        btnWithdrawFunds.layer.cornerRadius = 5
        btnWithdrawFunds.layer.masksToBounds = true
        
      txtBankAccountNo.keyboardType = .numberPad
        lblNotAvailable.text = "\(SingletonClass.sharedInstance.strCurrentBalance)"
        
        txtAmount.becomeFirstResponder()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         
        
    }
    @IBOutlet weak var lblTZS: UILabel!
    func setLocalization()
    {
        lblCurrentBalanceTitle.text = "Current Balance".localized
        lblNotAvailable.text = "Not Available".localized
        lblTZS.text = "TZS".localized
        txtAccountHolderName.placeholder = "Account Holder Name".localized
        txtBankName.placeholder = "Bank Account Name".localized
        txtBankAccountNo.placeholder = "Bank Account No.".localized
        txtBSB.placeholder = "Branch Code".localized
        btnWithdrawFunds.setTitle("Transfer To Bank".localized, for: .normal)
    }
    @IBOutlet weak var lblNotAvailable: UILabel!
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        txtAccountHolderName.lineColor = .black
//        txtABN.lineColor = .black
        txtBankName.lineColor = .black
        txtBankAccountNo.lineColor = .black
        txtBSB.lineColor = .black
    }
    
//    @objc override func btnBackAction() {
//
//        if isModal() {
//            self.dismiss(animated: true, completion: {
//
//            })
//
//        }
//        else {
//
//            self.navigationController?.popViewController(animated: true)
//        }
//
//    }
//
//    override func isModal() -> Bool {
//        if (presentingViewController != nil) {
//            return true
//        }
//        if navigationController?.presentingViewController?.presentedViewController == navigationController {
//            return true
//        }
//        if (tabBarController?.presentingViewController is UITabBarController) {
//            return true
//        }
//        return false
//    }
    
    func clearTextFields() {
        txtAccountHolderName.text = ""
//        txtABN.text = ""
        txtBankName.text = ""
        txtBankAccountNo.text = ""
        txtBSB.text = ""
        strAmt = ""
        
    }

    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var lblCardTitle: UILabel!
    @IBOutlet weak var lblCurrentBalanceTitle: UILabel!
    
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var btnWithdrawFunds: ThemeButton!
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var btnCardTitle: UIButton!
    
    @IBOutlet weak var txtAccountHolderName: ACFloatingTextfield!
    @IBOutlet weak var txtABN: ACFloatingTextfield!
    @IBOutlet weak var txtBankName: ACFloatingTextfield!
    @IBOutlet weak var txtBankAccountNo: ACFloatingTextfield!
    @IBOutlet weak var txtBSB: ACFloatingTextfield!
    
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnCardTitle(_ sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletCardsVC") as! WalletCardsVC
        SingletonClass.sharedInstance.isFromTransferToBank = true
        next.delegateForTransferToBank = self
        self.navigationController?.pushViewController(next, animated: true)
        
    }
    
    
    
    @IBAction func btnWithdrawFunds(_ sender: ThemeButton) {
        
        if (validationOfTransferToBank()) {
            
            webserviceOfTransferToBank()
        }
    }
    
    func setData() {
        
        let profileData = SingletonClass.sharedInstance.dictProfile
//        txtNote.text = profileData.object(forKey: "Description") as? String
//        txtABN.text = profileData.object(forKey: "ABN") as? String
//        txtBSB.text = profileData.object(forKey: "BSB") as? String
        txtBankName.text = profileData.object(forKey: "BankName") as? String
        txtBankAccountNo.text = profileData.object(forKey: "BankAccountNo") as? String
        txtAccountHolderName.text = profileData.object(forKey: "CompanyName") as? String
     
    }
    
    //-------------------------------------------------------------
    // MARK: - Select Card Delegate Methods
    //-------------------------------------------------------------
    
    func didSelectBankCard(dictData: [String : AnyObject]) {
        
        print(dictData)
        
        lblCardTitle.text = "\(dictData["Type"] as! String) \(dictData["CardNum2"] as! String)"
        strCardId = dictData["Id"] as! String
        
//        lblCurrentBalanceTitle = dictData["Type"] as? AnyObject
        
        //        dictData1["PassengerId"] = "1" as AnyObject
        //        dictData1["CardNo"] = "**** **** **** 1081" as AnyObject
        //        dictData1["Cvv"] = "123" as AnyObject
        //        dictData1["Expiry"] = "08/22" as AnyObject
        //        dictData1["CardType"] = "MasterCard" as AnyObject
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    
    @IBAction func txtAmount(_ sender: UITextField) {
        
        if let amountString = txtAmount.text?.currencyInputFormatting() {
            
            
            //            txtAmount.text = amountString
            
            
            let unfiltered1 = amountString   //  "!   !! yuahl! !"
            
            let spaceAdd = " "
            
            let insertCurrencySymboleInString = "\(currencySign),\(spaceAdd)"
            let insertcurrencySymboleInCharacter = [Character](insertCurrencySymboleInString)
            
            let removal1: [Character] = insertcurrencySymboleInCharacter    // ["!"," "]
            
            // turn the string into an Array
            let unfilteredCharacters1 = unfiltered1.characters
            
            // return an Array without the removal Characters
            let filteredCharacters1 = unfilteredCharacters1.filter { !removal1.contains($0) }
            
            // build a String with the filtered Array
            let filtered1 = String(filteredCharacters1)
            
            print(filtered1) // => "yeah"
            
            // combined to a single line
            print(String(unfiltered1.characters.filter { !removal1.contains($0) })) // => "yuahl"
            
            txtAmount.text = String(unfiltered1.characters.filter { !removal1.contains($0) })
            
            
            let space = " "
            let comma = " "
            let currencySymboleInString = "\(currencySign),\(comma),\(space)"
            let currencySymboleInCharacter = [Character](currencySymboleInString)
            
            
            // ----------------------------------------------------------------------
            // ----------------------------------------------------------------------
            let unfiltered = amountString   //  "!   !! yuahl! !"
            
            // Array of Characters to remove
            let removal: [Character] = currencySymboleInCharacter    // ["!"," "]
            
            // turn the string into an Array
            let unfilteredCharacters = unfiltered.characters
            
            // return an Array without the removal Characters
            let filteredCharacters = unfilteredCharacters.filter { !removal.contains($0) }
            
            // build a String with the filtered Array
            let filtered = String(filteredCharacters)
            
            print(filtered) // => "yeah"
            
            // combined to a single line
            print(String(unfiltered.characters.filter { !removal.contains($0) })) // => "yuahl"
            
            strAmt = String(unfiltered.characters.filter { !removal.contains($0) })
            print("amount : \(strAmt)")
            
            
        }
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    
    func validationOfTransferToBank() -> Bool {
        
        strAmt = strAmt.trimmingCharacters(in: .whitespacesAndNewlines)
        strAmt = strAmt.replacingOccurrences(of: " ", with: "")
        
//        if txtABN.text!.count == 0 {
//            
//            UtilityClass.setCustomAlert(title: "Missing", message: "Enter ABN Number") { (index, title) in
//            }
//            return false
//        }
        if txtAmount.text!.count == 0 {
            
            UtilityClass.setCustomAlert(title: "Missing", message: "Please enter amount".localized) { (index, title) in
            }
            return false
        }
        else if txtAccountHolderName.text!.count == 0 {
            
            UtilityClass.setCustomAlert(title: "Missing", message: "Please enter Account Holder Name".localized) { (index, title) in
            }
            return false
        }
            
        
        
        
        
            
        else if txtBankName.text!.count == 0 {
            
            UtilityClass.setCustomAlert(title: "Missing", message: "Please enter Bank Name".localized) { (index, title) in
            }
            return false
        }
        else if txtBankAccountNo.text!.count == 0 {
            UtilityClass.setCustomAlert(title: "Missing", message: "Please enter Bank Account Number".localized) { (index, title) in
            }
            return false
        }
//         else if txtBSB.text!.count == 0 {
//
//            UtilityClass.setCustomAlert(title: "Missing", message: "Please enter Branch Code".localized) { (index, title) in
//            }
//            return false
//        }
//

        else if Double(strAmt)! > SingletonClass.sharedInstance.strCurrentBalance {

            UtilityClass.setCustomAlert(title: "Missing", message: "Entered amout is more than current balance") { (index, title) in
            }
            return false
        }
        
        
        return true
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    func webserviceOfTransferToBank() {
//        PassengerId,Amount,HolderName,ABN,BankName,BSB,AccountNo
        
        
        var param = [String:AnyObject]()
        
        param["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
        param["Amount"] = strAmt as AnyObject
        param["HolderName"] = txtAccountHolderName.text as AnyObject
        param["ABN"] = txtABN.text as AnyObject
        param["BankName"] = txtBankName.text as AnyObject
//        param["BSB"] = txtBSB.text as AnyObject
        param["AccountNo"] = txtBankAccountNo.text as AnyObject

        
        webserviceForTransferToBank(param as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
              
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "Done", message: res) { (index, title) in
                    }
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "Done", message: resDict.object(forKey: "message") as! String) { (index, title) in
                    }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "Done", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    }
                }
                
                self.webserviceOfTransactionHistory()
                self.navigationController?.popViewController(animated: true)
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
    
    func webserviceOfTransactionHistory() {
        
        webserviceForTransactionHistory(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                SingletonClass.sharedInstance.strCurrentBalance = ((result as! NSDictionary).object(forKey: "walletBalance") as AnyObject).doubleValue
                self.lblNotAvailable.text = "\(SingletonClass.sharedInstance.strCurrentBalance)"
                
                
//                SingletonClass.sharedInstance.walletHistoryData = (result as! NSDictionary).object(forKey: "history") as! [[String:AnyObject]]

                if let dictData = result as? [String:AnyObject]
                {
                    if let aryHistory = dictData["history"] as? [[String:AnyObject]]
                    {
                        SingletonClass.sharedInstance.walletHistoryData = aryHistory
                    }
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
    
    

}
