//
//  SenderCell.swift
//  KeepusPostd
//
//  Created by Tej P on 20/07/22.
//  Copyright © 2022 Nathan Osume. All rights reserved.
//

import UIKit

class SenderCell: UITableViewCell {
    
    @IBOutlet weak var lblMsgSender: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var vWMessage: UIView!
    
    @IBOutlet weak var lblImgDate: UILabel!
    @IBOutlet weak var imgMsg: UIImageView!
    @IBOutlet weak var vwImg: UIView!
    
    var btnImgAction : (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnImageAction(_ sender: Any) {
        if let click = self.btnImgAction{
            click()
        }
    }
    
    
}
