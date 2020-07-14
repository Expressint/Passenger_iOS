//
//  PreviousDueTableViewCell.swift
//  Peppea
//
//  Created by EWW074 on 03/01/20.
//  Copyright © 2020 Mayur iMac. All rights reserved.
//

import UIKit
//import SwiftyJSON

class PreviousDueTableViewCell: UITableViewCell {

    @IBOutlet weak var lblBookingId: UILabel!
    @IBOutlet weak var btnPay: UIButton!
    
    @IBOutlet weak var lblPickTitle: UILabel!
    @IBOutlet weak var lblPickUpLocation: UILabel!
    
    @IBOutlet weak var lblDropTitle: UILabel!
    @IBOutlet weak var lbDropOffLocation: UILabel!
    @IBOutlet weak var lblPreviousDue: UILabel!
    
    var notAvailable = "N/A"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnPay.imageView?.contentMode = .scaleAspectFit
//        btnPay.setTitleColor(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), for: .normal)
//        btnPay.imageView?.setImageColor(color: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setupData(object: [String:Any])
    {
        lblBookingId.text = "Booking Id : \(object["Id"] ?? notAvailable)"
        lblPickUpLocation.text = object["PickupLocation"] as? String ?? ""
        lbDropOffLocation.text = object["DropoffLocation"] as? String ?? ""
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .center
        
        let myAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), .paragraphStyle: titleParagraphStyle]
        let attrString = NSMutableAttributedString(string: "Previous Due", attributes: myAttribute)
        let myAttribute2 = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17), .paragraphStyle: titleParagraphStyle]
        let attrString2 = NSMutableAttributedString(string: "\n\("$") \(object["CompanyAmount"] ?? notAvailable)", attributes: myAttribute2)
       
        let str = NSMutableAttributedString(attributedString: attrString)
        str.append(attrString2)
        
        lblPreviousDue.attributedText = str
    }
    

}
