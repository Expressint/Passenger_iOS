//
//  OnGoingTableViewCell.swift
//  TickTok User
//
//  Created by Excellent Webworld on 09/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class OnGoingTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    @IBOutlet weak var viewDetails: UIView!
    
    @IBOutlet weak var lblSecoundDescription: UILabel!
    @IBOutlet var viewCell: UIView!
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblBookingID: UILabel!
    
    @IBOutlet weak var lblFirstDescription: UILabel!
    @IBOutlet weak var btnTrackYourTrip: ThemeButton!
    
    @IBOutlet weak var lblDropoffAddress: UILabel!
    @IBOutlet weak var lblDateAndTime: UILabel!
    
    @IBOutlet weak var lblPickupAddress: UILabel!
    
    @IBOutlet weak var lblPickupTime: UILabel!
    @IBOutlet weak var lblDropoffTime: UILabel!
    
    @IBOutlet weak var lblVehicleType: UILabel!
    
    @IBOutlet weak var lblDistanceTravelled: UILabel!
    @IBOutlet weak var lblTripFare: UILabel!
    
    @IBOutlet weak var lblNightFare: UILabel!
    @IBOutlet weak var lblTollFee: UILabel!
    
    @IBOutlet weak var lblWaitingCost: UILabel!
    
    @IBOutlet weak var lblBookingCharge: UILabel!
    
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    
    @IBOutlet weak var lblPaymentType: UILabel!
    @IBOutlet weak var lblTotalCost: UILabel!
    
    

}
