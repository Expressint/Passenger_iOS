//
//  ShoppingViewController.swift
//  TickTok User
//
//  Created by Excelent iMac on 15/12/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class ShoppingViewController: BaseViewController {

    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    
    
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    
    @IBAction func btnBottleShops(_ sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ShoppingDetailsVC") as! ShoppingDetailsVC
        next.strType = "liquor+shop+in+"
        next.strHeader = "BOTTLE SHOPS"
        self.navigationController?.pushViewController(next, animated: true)
        
    }
    
    @IBAction func btnGroceries(_ sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "GroceriesViewController") as! GroceriesViewController
        next.strHeader = "GROCERIES"
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func btnAutoParts(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ShoppingDetailsVC") as! ShoppingDetailsVC
        next.strType = "Auto+Parts+in+"
        next.strHeader = "AUTO PARTS"
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func btnChemist(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ShoppingDetailsVC") as! ShoppingDetailsVC
        next.strType = "Chemist+in+"
        next.strHeader = "CHEMIST"
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func btnHardware(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ShoppingDetailsVC") as! ShoppingDetailsVC
        next.strType = "Hardware+in+"
        next.strHeader = "HARDWARE"
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func btnRetail(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ShoppingDetailsVC") as! ShoppingDetailsVC
        next.strType = "Retail+in+"
        next.strHeader = "RETAIL"
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    
    
    
}
