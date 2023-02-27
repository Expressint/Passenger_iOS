//
//  RequestLoadingVC.swift
//  Book A Ride
//
//  Created by Yagnik on 16/01/23.
//  Copyright © 2023 Excellent Webworld. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SocketIO

class RequestLoadingVC: BaseViewController {

    // MARK: - Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewActivity: UIView!
    @IBOutlet weak var viewActivityAnimation: NVActivityIndicatorView!
    
    // MARK: - Variable
    let socket = (UIApplication.shared.delegate as! AppDelegate).socket
    var customerId = ""
    var bookingId = ""
    
    // MARK: - Base Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTitle.text = "Booking Request Processing".localized
        viewActivityAnimation.startAnimating()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewActivityAnimation.stopAnimating()
    }
    
    // MARK: - Action

    func onCancelRide() {
        viewActivityAnimation.stopAnimating()
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnBookingRequestCancelAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: "Are you sure you want to cancel the trip?".localized, preferredStyle: .alert)
        let OK = UIAlertAction(title: "Accept".localized, style: .default, handler: { ACTION in
            self.onCancelRide()
        })
        let Cancel = UIAlertAction(title: "Decline".localized, style: .destructive, handler: { ACTION in
           
        })
        alert.addAction(OK)
        alert.addAction(Cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
   
}
