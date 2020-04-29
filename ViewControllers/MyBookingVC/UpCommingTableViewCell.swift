//
//  UpCommingTableViewCell.swift
//  TickTok User
//
//  Created by Excellent Webworld on 09/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class UpCommingTableViewCell: UITableViewCell {

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
    
    @IBOutlet var viewCell: UIView!
    @IBOutlet weak var lblDriverName: UILabel!
    
    @IBOutlet weak var lblDropoffAddress: UILabel!
    @IBOutlet weak var lblDateAndTime: UILabel!
    
    @IBOutlet weak var lblPickupAddress: UILabel!
    
    @IBOutlet weak var lblPaymentType: UILabel!
    
    @IBOutlet weak var btnCancelRequest: ThemeButton!
    
    @IBOutlet weak var viewDetails: UIView!
    
    @IBOutlet weak var lblVehicleType: UILabel!
    @IBOutlet weak var lblTripStatus: UILabel!
    
    @IBOutlet weak var lblBookingId: UILabel!
    
    
    @IBOutlet weak var lblVehicleTypeTitle: UILabel!
    @IBOutlet weak var lblPaymentTypeTitle: UILabel!
    @IBOutlet weak var lblTripStatusTitle: UILabel!
    
    
}
