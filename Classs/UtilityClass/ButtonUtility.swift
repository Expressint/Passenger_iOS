//
//  ButtonUtility.swift
//  TickTok User
//
//  Created by Excellent Webworld on 31/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import Foundation

class ButtonUtility: UIButton {
    
   @IBInspectable let corner_radius : CGFloat =  10.0

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        self.layer.cornerRadius = corner_radius
        self.clipsToBounds = true

    }
 

}
