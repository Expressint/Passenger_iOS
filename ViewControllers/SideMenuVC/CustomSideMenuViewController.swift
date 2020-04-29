//
//  CustomSideMenuViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 11/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import SideMenuController

class CustomSideMenuViewController: SideMenuController {


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        performSegue(withIdentifier: "embedInitialCenterController", sender: nil)
        performSegue(withIdentifier: "embedSideController", sender: nil)
     
//        webserviceForAllDrivers()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    
    var aryAllDrivers = NSArray()
    func webserviceForAllDrivers()
    {
        webserviceForAllDriversList { (result, status) in
            
            if (status) {
                
                self.aryAllDrivers = ((result as! NSDictionary).object(forKey: "drivers") as! NSArray)
                
                SingletonClass.sharedInstance.allDiverShowOnBirdView = self.aryAllDrivers
                
                self.performSegue(withIdentifier: "embedInitialCenterController", sender: nil)
                self.performSegue(withIdentifier: "embedSideController", sender: nil)
                
                
//                self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
            }
            else {
                print(result)
            }
        }
    }


}


