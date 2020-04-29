//
//  HeaderView.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 09/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit


protocol HeaderViewDelegate: NSObjectProtocol {
    func didSideMenuClicked()       //  Side Menu
    func didBackButtonClicked()     //  Back Button
    func didSignOutClicked()        //  SignOut
    func didSwitchOnOFFClicked(isOn : Bool)    //  Switch On/OFF
    func didCallClicked()           // Call Button
}


class HeaderView: UIView {
    
    
    weak var delegate: HeaderViewDelegate?
    
    @IBOutlet weak var contraintLabelCentr: NSLayoutConstraint!
    override func draw(_ rect: CGRect) {
        
//        btnSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        // Drawing code
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    //HeaderView 1
    @IBOutlet var imgHeaderImage: UIImageView!
    @IBOutlet var btnSwitch: UIButton!
    @IBOutlet var btnMenu: UIButton!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnCall: UIButton!
    
    
    //HeaderView 2
    @IBOutlet var btnSignOut: UIButton!
    @IBOutlet var lblHeaderTitle: UILabel!    
    @IBOutlet var bottomView: UIView!
    
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    class func headerView(withDelegate delegate: HeaderViewDelegate?) -> HeaderView {
        print("Hello")
        var arr: [Any] = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)!
        let hView: HeaderView? = (arr[0] as? HeaderView)
        hView?.delegate = delegate
        
        return hView!
    }
    
    
    //HeaderView 1
    @IBAction func btnSignOut(_ sender: UIButton) {
        delegate?.didSignOutClicked()
    }
    
    
    @IBAction func btnSwitch(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        btnSwitch.isEnabled = false
        
        if (sender.isSelected)
        {
            delegate?.didSwitchOnOFFClicked(isOn: true)
        }
        else
        {
            delegate?.didSwitchOnOFFClicked(isOn: false)
        }
        
        
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        delegate?.didBackButtonClicked()
    }
    
    @IBAction func btnSideMenu(_ sender: UIButton) {
        delegate?.didSideMenuClicked()
    }
    
    @IBAction func btnCallClicked(_ sender: UIButton)
    {
        delegate?.didCallClicked()
    }
    // ------------------------------------------------------------
    
    //HeaderView 2
    
    
    // ------------------------------------------------------------
    
    
    
    
    
    
}
