//
//  TourTripHistoryCell.swift
//  Book A Ride
//
//  Created by Yagnik on 17/02/23.
//  Copyright © 2023 Excellent Webworld. All rights reserved.
//

import UIKit
import MarqueeLabel

class TourTripHistoryCell: UITableViewCell {

    @IBOutlet weak var vWContainer: UIView!
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblOrderID: UILabel!
    @IBOutlet weak var lblPickUpLoc: MarqueeLabel!
    @IBOutlet weak var lblDropOffLoc: MarqueeLabel!
    @IBOutlet weak var lblDropOffLoc2: MarqueeLabel!
    @IBOutlet weak var stackBtns: UIStackView!
    @IBOutlet weak var stackBookingDate: UIStackView!
    @IBOutlet weak var stackPickUpDate: UIStackView!
    @IBOutlet weak var stackDropOffDate: UIStackView!
    @IBOutlet weak var stackPaymentType: UIStackView!
    @IBOutlet weak var stackTripStatus: UIStackView!
    @IBOutlet weak var lblTitleBookingDate: UILabel!
    @IBOutlet weak var lblTitlePickUpDate: UILabel!
    @IBOutlet weak var lblTitleDropoffDate: UILabel!
    @IBOutlet weak var lblTitlePaymentType: UILabel!
    @IBOutlet weak var lblTitleTripStatus: UILabel!
    @IBOutlet weak var lblBookingDate: UILabel!
    @IBOutlet weak var lblPickUpDate: UILabel!
    @IBOutlet weak var lblDropOffDate: UILabel!
    @IBOutlet weak var lblPaymentType: UILabel!
    @IBOutlet weak var lblTripStatus: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnGetReceipt: UIButton!
    @IBOutlet weak var btnViewReceipt: UIButton!
    @IBOutlet weak var btnPayment: UIButton!
    
    @IBOutlet weak var lblTitlePackageName: UILabel!
    @IBOutlet weak var lblTitleTotalDistance: UILabel!
    @IBOutlet weak var lblTitleTotalDuration: UILabel!
    @IBOutlet weak var lblTitleGrandTotal: UILabel!
    @IBOutlet weak var lblPackageName: UILabel!
    @IBOutlet weak var lblTotalDistance: UILabel!
    @IBOutlet weak var lblTotalDuration: UILabel!
    @IBOutlet weak var lblGrandTotal: UILabel!
    @IBOutlet weak var stackDistance: UIStackView!
    @IBOutlet weak var stackDuration: UIStackView!
    @IBOutlet weak var stackgrandtotal: UIStackView!
    @IBOutlet weak var stackMain: UIStackView!
    
    var cancelTap : (()->()) = { }
    var getReceiptTap : (()->()) = { }
    var viewReceiptTap : (()->()) = { }
    var paymentTap : (()->()) = { }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.stackMain.isHidden = true
       
        self.vWContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.vWContainer.layer.masksToBounds = false
        self.vWContainer.layer.shadowRadius = 4
        self.vWContainer.layer.borderColor = #colorLiteral(red: 0.1098039216, green: 0.4588235294, blue: 0.7333333333, alpha: 1)
        self.vWContainer.layer.cornerRadius = 10
        self.vWContainer.layer.shadowOpacity = 0.15
  
        self.lblTitleBookingDate.text = "\("Booking Date".localized) :"
        self.lblTitlePickUpDate.text = "\("Pickup Date & Time".localized) :"
        self.lblTitleDropoffDate.text = "\("Dropoff Date & Time".localized) :"
        self.lblTitlePaymentType.text = "\("Payment Type".localized) :"
        self.lblTitleTripStatus.text = "\("Trip Status".localized) :"
        self.lblTitlePackageName.text = "\("Package Name".localized) :"
        self.lblTitleTotalDistance.text = "\("Total Distance".localized) :"
        self.lblTitleTotalDuration.text = "\("Total Duration".localized) :"
        self.lblTitleGrandTotal.text = "\("Grand Total".localized) :"
        
        self.btnGetReceipt.setTitle("GET RECEIPT".localized, for: .normal)
        self.btnViewReceipt.setTitle("VIEW RECEIPT".localized, for: .normal)
        self.btnCancel.setTitle("Cancel Request".localized, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnCancelAction(_ sender: Any) {
        cancelTap()
    }
    
    @IBAction func btnGetReceiptAction(_ sender: Any) {
        getReceiptTap()
    }
    
    @IBAction func btnViewReceiptAction(_ sender: Any) {
        viewReceiptTap()
    }
    
    @IBAction func btnPaymentAction(_ sender: Any) {
        paymentTap()
    }
    
    
}
