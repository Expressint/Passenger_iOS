//
//  PastBooingTableViewCell.swift
//  TickTok User
//
//  Created by Excellent Webworld on 09/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class PastBooingTableViewCell: UITableViewCell {

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
    @IBOutlet weak var lblPickupTimeTitle: UILabel!
    @IBOutlet weak var lblDropoffTimeTitle: UILabel!
    @IBOutlet weak var lblVehicleTypeTitle: UILabel!
    @IBOutlet weak var lblPaymentTypeTitle: UILabel!
    @IBOutlet weak var lblBookingFreeTitle: UILabel!
    @IBOutlet weak var lblTripFareTitle: UILabel!
    @IBOutlet weak var lblTripTitle: UILabel!
    @IBOutlet weak var lblWaitingCostTitle: UILabel!
    @IBOutlet weak var lblTripStatusTitle: UILabel!
    @IBOutlet weak var lblInclTax: UILabel!
    @IBOutlet weak var lblTotlaAmountTitile: UILabel!
    @IBOutlet weak var lblPromoApplied: UILabel!
    @IBOutlet weak var lblLessTitle: UILabel!
    @IBOutlet weak var lblWaitingTimeTitle: UILabel!
    
    @IBOutlet weak var viewDetails: UIView!
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblBookingID: UILabel!
    @IBOutlet weak var lblDropoffAddress: UILabel!  // DropOff Address is PickupAddress
    @IBOutlet weak var lblDateAndTime: UILabel!
    @IBOutlet var viewCell: UIView!
    @IBOutlet weak var lblPickupAddress: UILabel! // Pickup Address is PickupAddress
    @IBOutlet weak var stackViewPickupTime: UIStackView!
    @IBOutlet weak var lblPickupTime: UILabel!
    @IBOutlet weak var stackViewDropoffTime: UIStackView!
    @IBOutlet weak var lblDropoffTime: UILabel!
    @IBOutlet weak var stackViewVehicleType: UIStackView!
    @IBOutlet weak var lblVehicleType: UILabel!
    @IBOutlet var lblPaymentType: UILabel!
    @IBOutlet var lblBookingFee: UILabel!
    @IBOutlet var lblTripFare: UILabel!
    @IBOutlet var lblTip: UILabel!
    @IBOutlet weak var lblWaitingCost: UILabel!
    @IBOutlet weak var lblTripStatus: UILabel!
    @IBOutlet weak var lblWaitingTime: UILabel!
    @IBOutlet weak var lblPromoCode: UILabel!
//    @IBOutlet weak var lblTax: UILabel!
//    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    
    
    
    
    @IBOutlet weak var stackViewDistanceTravelled: UIStackView!
    @IBOutlet weak var lblDistanceTravelled: UILabel!
    
    @IBOutlet weak var stackViewTripFare: UIStackView!
//    @IBOutlet weak var lblTripFare: UILabel!
    
    @IBOutlet weak var stackViewNightFare: UIStackView!
    
    
    @IBOutlet weak var stackViewTollFee: UIStackView!
    
    
    @IBOutlet weak var stackViewWaitingCost: UIStackView!
    
    
    @IBOutlet weak var stackViewBookingCharge: UIStackView!
   
    
    @IBOutlet weak var stackViewTax: UIStackView!
   
    
    @IBOutlet weak var stackViewDiscount: UIStackView!
   
    
    @IBOutlet weak var stackViewPaymentType: UIStackView!
    
    @IBOutlet weak var stackViewTotalCost: UIStackView!
  
    @IBOutlet weak var btnPaymentOrReceipt: ThemeButton!
}
