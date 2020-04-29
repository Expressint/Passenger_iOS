//
//  MyRecepitTableViewCell.swift
//  TickTok User
//
//  Created by Excelent iMac on 13/12/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class MyRecepitTableViewCell: UITableViewCell {

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
    
    @IBOutlet weak var btnGetRecepat: ThemeButton!
    @IBOutlet var viewCell: UIView!
    
    @IBOutlet var lblDrooffTime: UILabel!
    @IBOutlet var lblPickupTime: UILabel!
    @IBOutlet weak var viewDetails: UIView!
    
    @IBOutlet var lblDriversNames: UILabel!
    @IBOutlet weak var btnGetReceipt: ThemeButton!
    
    @IBOutlet var lblTripFare: UILabel!
    @IBOutlet var lblBookingFee: UILabel!
    @IBOutlet var lblDropLocationDescription: UILabel!
    @IBOutlet var lblDateAndTime: UILabel!
    @IBOutlet var lblPickUpLocationDescription: UILabel!
    
    @IBOutlet var lblBookingId: UILabel!
    @IBOutlet var lblTotalAmount: UILabel!
    @IBOutlet var lblPromoCode: UILabel!
    @IBOutlet var lblWaitingTime: UILabel!
    @IBOutlet var lblWaitingCost: UILabel!
    @IBOutlet var lblPaymentType: UILabel!
    @IBOutlet weak var lblVehicleType: UILabel!
    @IBOutlet weak var lblDistanceTravelled: UILabel!
    @IBOutlet weak var lblTolllFee: UILabel!
    
    @IBOutlet weak var lblFareTotal: UILabel!
    @IBOutlet weak var lblDiscountApplied: UILabel!
    @IBOutlet weak var lblChargedCard: UILabel!

    @IBOutlet weak var lblTripStatusTitlr: UILabel!
    @IBOutlet weak var lblInclTaxTitle: UILabel!
    @IBOutlet weak var lblTotalAmountTitle: UILabel!
    @IBOutlet weak var lblPromoAppliedTitle: UILabel!
    @IBOutlet weak var lblLessTitle: UILabel!
    @IBOutlet weak var lblWaitingTimeTitle: UILabel!
    @IBOutlet weak var lblWaitingCostTitle: UILabel!
    @IBOutlet weak var lblTripFareTitle: UILabel!
    @IBOutlet weak var lblBookingFeeTitle: UILabel!
    @IBOutlet weak var lblPaymentTypeTitle: UILabel!
    @IBOutlet weak var lblPickUpTimeTitle: UILabel!
    
    @IBOutlet weak var lblVehicleTypeTitle: UILabel!
    @IBOutlet weak var lblDropOffTimeTitle: UILabel!
    @IBOutlet var lblTripStatus: UILabel!
}
