//
//  SelectModelCell.swift
//  Book A Ride
//
//  Created by Yagnik on 20/12/22.
//  Copyright © 2022 Excellent Webworld. All rights reserved.
//

import UIKit

class SelectModelCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgModel: UIImageView!
    @IBOutlet weak var imgSelected: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
