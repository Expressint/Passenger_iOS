//
//  GroceriesViewController.swift
//  TickTok User
//
//  Created by Excelent iMac on 15/12/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class GroceriesViewController: BaseViewController {

    
    var strHeader = String()
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    
    @IBAction func btnAmazon(_ sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "webViewVC") as! webViewVC
        next.strURL = "https://www.amazon.com.au/"
        next.headerName = "Amazon"
        self.navigationController?.pushViewController(next, animated: true)
        
    }
    
    @IBAction func btnColes(_ sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "webViewVC") as! webViewVC
        next.strURL = "https://www.coles.com.au/"
        next.headerName = "Coles"
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func btnWoolworths(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "webViewVC") as! webViewVC
        next.strURL = "https://www.woolworths.com.au/"
        next.headerName = "Woolworths"
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func btnAldi(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "webViewVC") as! webViewVC
        next.strURL = "https://www.aldi.com.au/"
        next.headerName = "Aldi"
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func btnCostcoWholeSale(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "webViewVC") as! webViewVC
        next.strURL = "https://www.costco.com/"
        next.headerName = "Costco Wholesale"
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func btnIGABrand(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "webViewVC") as! webViewVC
        next.strURL = "https://www.iga.com.au/"
        next.headerName = "IGA Brand"
        self.navigationController?.pushViewController(next, animated: true)
        
    }
    
    
    

}
