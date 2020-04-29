//
//  PacageHoursDaysTableViewCell.swift
//  PickNGo User
//
//  Created by Excellent WebWorld on 05/03/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit

class PacageHoursDaysTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblHours: UILabel!
    
    @IBOutlet weak var lblKMs: UILabel!
    
    @IBOutlet weak var lblAdditional: UILabel!
    
    @IBOutlet weak var lblAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
