//
//  ShoppingTableViewCell.swift
//  TickTok User
//
//  Created by Excelent iMac on 15/12/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class ShoppingTableViewCell: UITableViewCell {

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
    
    
    @IBOutlet weak var lblShopTitle: UILabel!
    
    @IBOutlet weak var lblRatting: UILabel!
    @IBOutlet weak var viewRatting: FloatRatingView!
    
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var imgItem: UIImageView!
    
    @IBOutlet weak var btnShopStatus: UIButton!
    
    
    @IBOutlet weak var imgTailingConstraints: NSLayoutConstraint!
    @IBOutlet weak var imgWidthConstraints: NSLayoutConstraint!
    
}
