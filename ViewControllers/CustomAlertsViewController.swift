//
//  CustomAlertsViewController.swift
//  CapRide
//
//  Created by MAYUR on 29/01/18.
//  Copyright © 2018 Excelent iMac. All rights reserved.
//

import UIKit


@objc protocol alertViewMethodsDelegates {
    @objc optional func didOKButtonPressed()
    @objc optional func didCancelButtonPressed()
}

class CustomAlertsViewController: UIViewController
{
    
    var delegateOfAlertView: alertViewMethodsDelegates!
    
    var strTitle = String()
    var strMessage = String()
    var btnOKisHidden = Bool()
    var btnCancelisHidden = Bool()
    
    
    var closeBtnPosition = CGPoint()
    var alertViewSize = CGRect()
    var alertViewZeroSize = CGRect()
   

    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .lightContent
//        self.navigationController?.isNavigationBarHidden = true
        
        lblTitleName.text = strTitle
        lblMessageDetails.text = strMessage

        gaveCornerRadus(item: viewMainAlert)
        gaveCornerRadus(item: viewAlert)
        
        self.viewMainAlert.isHidden = true
        
        lblTitleName.text = "Booking Confirmed".localized
        lblMessageDetails.text = "Your Booking has been Confirmed" .localized
        btnOK.setTitle("OK".localized, for: .normal)
    
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        startAnimation()
    }
    
    func gaveCornerRadus(item: UIView) {
        item.layer.cornerRadius = 5
        item.layer.masksToBounds = true
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    
    @IBOutlet var viewMain: UIView!
    @IBOutlet weak var viewMainAlert: UIView!
    @IBOutlet var viewAlert: UIView!
    
    @IBOutlet var imgHeaderImage: UIImageView!
    
    @IBOutlet var lblTitleName: UILabel!
    @IBOutlet var lblMessageDetails: UILabel!
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet var btnOK: UIButton!
    
    @IBOutlet weak var constainlblTitleNameLabelHeight: NSLayoutConstraint!
    
    
    func setAlertViewwithData(title:String?, message:String?, buttonRightTitle:String?)
    {
        
//        if title?.length == 0
//        {
//            constainlblTitleNameLabelHeight.constant = 0
//        }
//        else
//        {
//            constainlblTitleNameLabelHeight.constant = 42
//        }
        
//        lblTitleName.text = title
//        lblMessageDetails.text = message
//
//
//        btnOK.setTitle(buttonRightTitle, for: .normal)
        
//        if numberOfButton == "1"
//        {
//            btnRight.isHidden = true
//        }
    }
 


    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    
    @IBAction func btnClose(_ sender: UIButton)
    {
        print("btnClose Pressed")
        DismissAnimation()
        
//        self.dismiss(animated: true, completion: {
//
//        self.delegateOfAlertView?.didCancelButtonPressed!()
//        })
    }
    
    
    
    @IBAction func btnOK(_ sender: UIButton) {
        
        print("btnOK Pressed")
        
        self.dismiss(animated: false, completion: {
        
         self.delegateOfAlertView?.didOKButtonPressed!()
        })
    }
    
    func startAnimation() {
        
        self.viewMainAlert.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseIn, animations:
            {
                self.viewMainAlert.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
                self.viewMainAlert.isHidden = false
                
                self.viewMainAlert.layoutIfNeeded()
        }) { _ in
        }
        
    }
    
    func DismissAnimation() {
        
        self.viewMainAlert.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseOut, animations:
            {
                self.viewMainAlert.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                
                self.viewMainAlert.isHidden = true
                
                self.viewMainAlert.layoutIfNeeded()
        }) { _ in
            
            self.dismiss(animated: false, completion: {
            
             self.delegateOfAlertView?.didCancelButtonPressed!()
            })
        }
        
    }
    
    
}






