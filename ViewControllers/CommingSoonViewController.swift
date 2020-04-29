//
//  CommingSoonViewController.swift
//  PickNGo User
//
//  Created by Excelent iMac on 13/02/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit

class CommingSoonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var lblCommingSoon: UILabel!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        lblCommingSoon.text = "Comming Soon!".localized
    }
    @IBAction func btnBack(_ sender: UIButton) {
        
        
        self.navigationController?.popViewController(animated: true)

    }
    
    
    

}
