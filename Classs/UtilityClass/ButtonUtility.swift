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

class PaddingLabel: UILabel {

   @IBInspectable var topInset: CGFloat = 5.0
   @IBInspectable var bottomInset: CGFloat = 5.0
   @IBInspectable var leftInset: CGFloat = 5.0
   @IBInspectable var rightInset: CGFloat = 5.0

   override func drawText(in rect: CGRect) {
      let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
      super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
   }

   override var intrinsicContentSize: CGSize {
      get {
         var contentSize = super.intrinsicContentSize
         contentSize.height += topInset + bottomInset
         contentSize.width += leftInset + rightInset
         return contentSize
      }
   }
}
