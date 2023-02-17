//
//  CancelRentalReasonCell.swift
//  Book A Ride
//
//  Created by Yagnik on 07/02/23.
//  Copyright © 2023 Excellent Webworld. All rights reserved.
//

import UIKit

class CancelRentalReasonCell: UITableViewCell {
    
    @IBOutlet weak var lblReason: UILabel!
    @IBOutlet weak var imgSelected: UIImageView!
    @IBOutlet weak var vWBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
