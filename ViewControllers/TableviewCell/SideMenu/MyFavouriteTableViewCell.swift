//
//  MyFavouriteTableViewCell.swift
//  TickTok User
//
//  Created by Excelent iMac on 15/12/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class MyFavouriteTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBOutlet weak var imgItem: UIImageView!
    
    @IBOutlet weak var lblItemTitle: UILabel!
    
    

}
