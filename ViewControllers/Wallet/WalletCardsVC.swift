//
//  WalletCardsVC.swift
//  TiCKTOC-Driver
//
//  Created by Excelent iMac on 23/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

@objc protocol AddCadsDelegate {
    func didAddCard(cards: NSArray)
}

@objc protocol CadsSelectionDelegate {
    func didAddCard(cards: [String:Any])
}

class WalletCardsVC: BaseViewController, UITableViewDataSource, UITableViewDelegate, AddCadsDelegate {

    
    weak var delegateForTopUp: SelectCardDelegate!
    weak var delegateForTransferToBank: SelectBankCardDelegate!
    
    weak var delegateForHomeAddcard: CadsSelectionDelegate!
    
    var aryData = [[String:AnyObject]]()
    
    var canEditRowBool = true
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = themeYellowColor
        
        return refreshControl
    }()
    
   
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func loadView() {
        super.loadView()
        
        if SingletonClass.sharedInstance.isCardsVCFirstTimeLoad {
//            webserviceOFGetAllCards()
            
            if SingletonClass.sharedInstance.CardsVCHaveAryData.count != 0 {
                aryData = SingletonClass.sharedInstance.CardsVCHaveAryData
            }
            else {
                
                webserviceOFGetAllCards()
                
            }
        }
        else {
            if SingletonClass.sharedInstance.CardsVCHaveAryData.count != 0 {
                aryData = SingletonClass.sharedInstance.CardsVCHaveAryData
            }
            else {
                let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
                next.delegateAddCard = self
                self.navigationController?.pushViewController(next, animated: true)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
               
        
        self.setNavBarWithBack(Title: "Card List".localized, IsNeedRightButton: true)
        
        self.tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        self.tableView.addSubview(self.refreshControl)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         
         
        }
    
   
    func setImageColorOfImage(name: String) -> UIImage {
        
        var imageView = UIImageView()
        
        let img = UIImage(named: name)
        imageView.image = img?.maskWithColor(color: UIColor.white)
        
        
        return imageView.image!
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAddCards: UIButton!
    
    //-------------------------------------------------------------
    // MARK: - TableView Methods
    //-------------------------------------------------------------
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return aryData.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletCardsTableViewCell") as! WalletCardsTableViewCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "AddCard") as! WalletCardsTableViewCell
        
        cell.selectionStyle = .none
       
        if indexPath.section == 0 {
            cell2.selectionStyle = .none
            cell2.lblAddCard.text = "Add New Card"//.localized
            return cell2
        } else {
            
            let dictData = aryData[indexPath.section - 1] as [String:AnyObject]
            let expiryDate = (dictData["Expiry"] as! String).split(separator: "/")
            let month = expiryDate.first
            let year = expiryDate.last
            cell.lblMonthExpiry.text = "\(String(describing: month!)) / \(String(describing: year!))"
            
            cell.viewCards.layoutIfNeeded()
            cell.viewCards.dropShadowToCardView(color: .gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 5, scale: true)
            cell.viewCards.layer.cornerRadius = 5
            cell.viewCards.layer.masksToBounds = true
            
            let type = dictData["Type"] as! String
            
            cell.imgCardIcon.image = UIImage(named: setCreditCardImage(str: type))
            cell.lblCardNumber.text = dictData["CardNum2"] as? String
            
            var colorTop:UIColor = .clear //UIColor()
            var colorMiddle:UIColor = .clear //UIColor()
            
            if type == "visa" {
                colorTop = UIColor(red: 253.0/255.0, green: 149.0/255.0, blue:47.0/255.0, alpha: 1.0)
                colorMiddle =  UIColor(red: 251.0/255.0, green: 63.0/255.0, blue: 135.0/255.0, alpha: 1.0)
            } else if type == "mastercard" {
                colorTop = UIColor(red: 76.0/255.0, green: 210.0/255.0, blue:252.0/255.0, alpha: 1.0)
                colorMiddle =  UIColor(red: 46.0/255.0, green: 167.0/255.0, blue: 252.0/255.0, alpha: 1.0)
            } else if type == "discover" {
                colorTop = UIColor(red: 199.0/255.0, green: 40.0/255.0, blue:135.0/255.0, alpha: 1.0)
                colorMiddle =  UIColor(red: 237.0/255.0, green: 59.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            }else if type == "jcb" {
                colorTop = UIColor(red: 199.0/255.0, green: 40.0/255.0, blue:135.0/255.0, alpha: 1.0)
                colorMiddle =  UIColor(red: 237.0/255.0, green: 59.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            }
            
            
            cell.imgCard.setGradientLayer(LeftColor: colorTop.cgColor, RightColor: colorMiddle.cgColor, BoundFrame: self.view.bounds)
            
//            if type == "discover" || type == "mastercard" {
//                // orange
//            }
//            else if type == "diners" {
//                // gray
//            }
//            else {
//                //
//            }
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.section == 0 {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
            next.delegateAddCard = self
            self.navigationController?.pushViewController(next, animated: true)
        }
        else {
            let selectedData = aryData[indexPath.section - 1] as [String:AnyObject]
            
            print("selectedData : \(selectedData)")
            
            if self.delegateForHomeAddcard != nil {
                self.delegateForHomeAddcard.didAddCard(cards: selectedData)
                self.navigationController?.popViewController(animated: true)
            }
            
            if SingletonClass.sharedInstance.isFromTopUP {
                delegateForTopUp.didSelectCard(dictData: selectedData)
                SingletonClass.sharedInstance.isFromTopUP = false
                self.navigationController?.popViewController(animated: true)
            }
            else if SingletonClass.sharedInstance.isFromTransferToBank {
                delegateForTransferToBank.didSelectBankCard(dictData: selectedData)
                SingletonClass.sharedInstance.isFromTransferToBank = false
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50
        }
        else {
            return 75
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
       return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let selectedData = aryData[indexPath.section - 1] as [String:AnyObject]
        
        if editingStyle == .delete {
            
            let selectedID = selectedData["Id"] as? String
            webserviceForRemoveCardFromWallet(cardId : selectedID!)
//
////            tableView.beginUpdates()
//            aryData.remove(at: indexPath.section - 1)
            
//            tableView.deleteRows(at: [indexPath], with: .fade)
////            tableView.endUpdates()
//            tableView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return canEditRowBool
    }
   
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }

    @IBAction func btnAddCards(_ sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
        
        next.delegateAddCard = self
        self.navigationController?.pushViewController(next, animated: true)
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        webserviceOFGetAllCards()
        
        tableView.reloadData()
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
    
    
    //-------------------------------------------------------------
    // MARK: - Add Cads Delegate Methods
    //-------------------------------------------------------------
    
    func didAddCard(cards: NSArray) {
        
        aryData = cards as! [[String:AnyObject]]
        
        tableView.reloadData()
    }
    
    func giveGradientColor() {
        
        let colorTop =  UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
        let colorMiddle =  UIColor(red: 36/255, green: 24/255, blue: 3/255, alpha: 0.5).cgColor
        let colorBottom = UIColor(red: 64/255, green: 43/255, blue: 6/255, alpha: 0.8).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorMiddle, colorBottom]
        gradientLayer.locations = [ 0.0, 0.5, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
   
    //-------------------------------------------------------------
    // MARK: - Webservice Methods For All Cards
    //-------------------------------------------------------------
    
    func webserviceOFGetAllCards() {
 
        webserviceForCardList(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
       
            if (status) {
                print(result)
                
                self.aryData = (result as! NSDictionary).object(forKey: "cards") as! [[String:AnyObject]]
                
                SingletonClass.sharedInstance.CardsVCHaveAryData = self.aryData
                
                SingletonClass.sharedInstance.isCardsVCFirstTimeLoad = false
                
                self.tableView.reloadData()
                
                if SingletonClass.sharedInstance.CardsVCHaveAryData.count == 0 {
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
                    next.delegateAddCard = self
                    self.navigationController?.pushViewController(next, animated: true)
                }
                
                self.refreshControl.endRefreshing()
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
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Remove Cards
    //-------------------------------------------------------------
    
    
    
    func webserviceForRemoveCardFromWallet(cardId : String) {
      
        
        var params = String()
        params = "\(SingletonClass.sharedInstance.strPassengerID)/\(cardId)"

        webserviceForRemoveCard(params as AnyObject) { (result, status) in
        
            if (status) {
                print(result)
                
                self.aryData = (result as! NSDictionary).object(forKey: "cards") as! [[String:AnyObject]]
                
                SingletonClass.sharedInstance.CardsVCHaveAryData = self.aryData
                
                SingletonClass.sharedInstance.isCardsVCFirstTimeLoad = false
                
                
                // Post notification
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CardListReload"), object: nil)

                
                if SingletonClass.sharedInstance.CardsVCHaveAryData.count == 0 {

                    self.navigationController?.popViewController(animated: true)
                }
//                if self.aryData.count > 0
//                {
////                    self.lblNoData.isHidden = true
//                }
//                else
//                {
////                    self.lblNoData.isHidden = false
//                }
                
                self.tableView.reloadData()
                
        
                
                UtilityClass.setCustomAlert(title: "Removed", message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
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

extension UIView {
    
    func dropShadowToCardView(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

