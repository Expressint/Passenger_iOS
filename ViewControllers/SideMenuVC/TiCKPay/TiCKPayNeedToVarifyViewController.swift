//
//  TiCKPayNeedToVarifyViewController.swift
//  TickTok User
//
//  Created by Excelent iMac on 21/12/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class TiCKPayNeedToVarifyViewController: UIViewController {

    
    var strMSG = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if strMSG == "" {
            lblMessage.text = "You \(appName)is in Pending for Approval, Once Admin Approve your Profile then you will able to receive Money from \(appName)."
        }
        else {
            lblMessage.text = strMSG
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBAction func btnBack(_ sender: UIButton) {
        
    
        if let HomeVC = self.navigationController?.childViewControllers[1] as? CustomSideMenuViewController{

            self.navigationController?.popToViewController(HomeVC, animated: true)

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
    

}
