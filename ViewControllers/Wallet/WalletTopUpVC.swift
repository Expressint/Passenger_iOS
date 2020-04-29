//
//  WalletTopUpVC.swift
//  TiCKTOC-Driver
//
//  Created by Excelent iMac on 23/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit


@objc protocol SelectCardDelegate {
    
    func didSelectCard(dictData: [String:AnyObject])
}

class WalletTopUpVC: BaseViewController, SelectCardDelegate,delegatePesapalWebView {

    
    @IBOutlet var viewCardNumber: UIView!
    var strCardId = String()
    var strAmt = String()
    
    @IBOutlet var iconCard: UIImageView!
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavBarWithBack(Title: "TOP UP".localized, IsNeedRightButton: true)
        viewMain.layer.cornerRadius = 5
        viewMain.layer.masksToBounds = true
        
        viewCardNumber.layer.cornerRadius = 5
        viewCardNumber.layer.masksToBounds = true
        viewCardNumber.layer.borderColor = UIColor.lightGray.cgColor
        viewCardNumber.layer.borderWidth = 1.5
        
        btnAddFunds.layer.cornerRadius = 5
        btnAddFunds.layer.masksToBounds = true
        
        txtAmount.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         
        btnAddFunds.setTitle("Top Up".localized, for: .normal)
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var lblCardTitle: UILabel!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var btnAddFunds: ThemeButton!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var btnCardTitle: UIButton!
    
    
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnCardTitle(_ sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletCardsVC") as! WalletCardsVC
        SingletonClass.sharedInstance.isFromTopUP = true
        next.delegateForTopUp = self
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    func setCreditCardImage(str: String) -> String {
        
        //   visa , mastercard , amex , diners , discover , jcb , other
        
        var strType = String()
        
        if str == "visa" {
            strType = "Visa_Black"
        }
        else if str == "mastercard" {
            strType = "MasterCard_Black"
        }
        else if str == "amex" {
            strType = "Amex"
        }
        else if str == "diners" {
            strType = "Diners Club"
        }
        else if str == "discover" {
            strType = "Discover_Black"
        }
        else if str == "jcb" {
            strType = "JCB"
        }
        else {
            strType = "iconDummyCard"
        }
        
        return strType
    }
    @IBAction func btnAddFunds(_ sender: ThemeButton) {
        
//        if strCardId == "" {
//
//            UtilityClass.setCustomAlert(title: "Missing", message: "Please reselect card") { (index, title) in
//            }
//        }
//        else
        if txtAmount.text == "" {
     
            UtilityClass.setCustomAlert(title: "Missing", message: "Please Enter Amount") { (index, title) in
            }
        }
        else {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "PesapalWebViewViewController") as! PesapalWebViewViewController
            next.strUrl = "https://www.tantaxitanzania.com/pesapal/add_money/\(SingletonClass.sharedInstance.strPassengerID)/\(txtAmount.text!.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: currencySign, with: ""))/passenger"
//            self.present(next, animated: true, completion: nil)
            next.delegate = self
            self.navigationController?.pushViewController(next, animated: true)
//            let navController = UINavigationController.init(rootViewController: next)
//            UIApplication.shared.keyWindow?.rootViewController?.present(navController, animated: true, completion: nil)
            
//            webserviceOFTopUp()
        }
        
    }
    @IBAction func txtAmount(_ sender: UITextField) {
        
        if let amountString = txtAmount.text?.currencyInputFormatting() {
            
            
//            txtAmount.text = amountString
            
            
            let unfiltered1 = amountString   //  "!   !! yuahl! !"
            
            // Array of Characters to remove
            
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
    // MARK: - Select Card Delegate Methods
    //-------------------------------------------------------------
    
    func didSelectCard(dictData: [String : AnyObject]) {
        
        print(dictData)
        
        let strIconCard = dictData["Type"] as! String
        iconCard.image = UIImage.init(named: setCreditCardImage(str: strIconCard))
        lblCardTitle.text = "\(dictData["CardNum2"] as! String)"
        strCardId = dictData["Id"] as! String
        
    }
    func didOrderPesapalStatus(status: Bool)
    {
        if status
        {
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
        }
    }
    //-------------------------------------------------------------
    // MARK: - Webservice Methods For TOP UP
    //-------------------------------------------------------------
    
    func webserviceOFTopUp() {
        
//        PassengerId,Amount,CardId
        txtAmount .resignFirstResponder()
        var dictParam = [String:AnyObject]()
 
        strAmt = strAmt.trimmingCharacters(in: .whitespacesAndNewlines)
        
        dictParam["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
        dictParam["CardId"] = strCardId as AnyObject
        dictParam["Amount"] = strAmt.replacingOccurrences(of: " ", with: "") as AnyObject
        
        webserviceForAddMoney(dictParam as AnyObject) { (result, status) in
        
        
            if (status) {
                print(result)
                
                self.txtAmount.text = ""
                SingletonClass.sharedInstance.strCurrentBalance = ((result as! NSDictionary).object(forKey: "walletBalance") as AnyObject).doubleValue
                UtilityClass.setCustomAlert(title: "Done", message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    
                    self.navigationController?.popViewController(animated: true)
                }
                
                
                
                
            }
            else {
                print(result)
                
                self.txtAmount.text = ""
                
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

/*
{
    message = "Add Money successfully";
    status = 1;
    walletBalance = "-4.63";
}
 */


