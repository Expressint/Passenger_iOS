//
//  ReceiverCell.swift
//  KeepusPostd
//
//  Created by Tej P on 20/07/22.
//  Copyright © 2022 Nathan Osume. All rights reserved.
//

import UIKit

class ReceiverCell: UITableViewCell {
    
    @IBOutlet weak var lblMsgReceiver: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var vWMessage: UIView!
    
    @IBOutlet weak var imgMsg: UIImageView!
    @IBOutlet weak var lblImgDate: UILabel!
    @IBOutlet weak var lblImgCompanyName: UILabel!
    @IBOutlet weak var vwImg: UIView!

    var btnImgAction : (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnImgAction(_ sender: Any) {
        if let click = self.btnImgAction{
            click()
        }
    }
    
}
