//
//  Extensions.swift
//  TanTaxi User
//
//  Created by EWW-iMac Old on 03/10/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import Foundation
import UIKit


// MARK:- UIColor

extension UISegmentedControl {
    
    func defaultConfiguration(font: UIFont = UIFont.systemFont(ofSize: 12), color: UIColor = UIColor.gray) {
        let defaultAttributes = [
            NSAttributedStringKey.font.rawValue: font,
            NSAttributedStringKey.foregroundColor.rawValue: color
        ]
        setTitleTextAttributes(defaultAttributes, for: .normal)
    }
    
    func selectedConfiguration(font: UIFont = UIFont.boldSystemFont(ofSize: 12), color: UIColor = UIColor.red) {
        let selectedAttributes = [
            NSAttributedStringKey.font.rawValue: font,
            NSAttributedStringKey.foregroundColor.rawValue: color
        ]
        setTitleTextAttributes(selectedAttributes, for: .selected)
    }
}

extension UIColor {
    
    convenience init(hex: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        var hex:   String = hex
        
        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex         = String(hex.suffix(from: index))
        }
        
        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hex.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                alpha = CGFloat(hexValue & 0x000F)             / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default:
                print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
            }
        } else {
            print("Scan hex error")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}

extension UIButton {
    func underline(text:String) {
        let attributedString = NSMutableAttributedString(string: text)
        //NSAttributedStringKey.foregroundColor : UIColor.blue
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

extension UIScrollView {
   func scrollToBottom(animated: Bool) {
     if self.contentSize.height < self.bounds.size.height { return }
     let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
     self.setContentOffset(bottomOffset, animated: animated)
  }
}

extension UINavigationController {
  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
      popToViewController(vc, animated: animated)
    }
  }
}

extension String {

    var nsRange : NSRange {
        return NSRange(self.startIndex..., in: self)
    }

    func nsRange(of string: String) -> NSRange {
        return (self as NSString).range(of: string)
    }

    var trimmed: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func convertToUnderLineAttributedString(font: UIFont, color: UIColor) -> NSAttributedString {
        let attr: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        return NSAttributedString(string: self, attributes: attr)
    }

    func secondsToTimeFormate() -> String? {
        Int(self)?.secondsToTimeFormate()
    }

    func toTimeFormate() -> String? {
        guard let minutes = Int(self) else {
            return nil
        }
        if minutes < 60 {
            return "\(minutes) Min"
        } else {
            let hr = minutes / 60
            let restMinutes = minutes % 60
            return "\(hr)Hr \(restMinutes)Min"
        }
    }

 


    func toDistanceString() -> String {
        guard let doubleValue = Double(self) else {
            return self
        }
        return "\(doubleValue) Km"
        /*if doubleValue >= 2 {
            return "\(doubleValue) Miles"
        } else {
            return "\(doubleValue) Mile"
        }*/
    }
    
   
}

extension Int {
    func secondsToTimeFormate() -> String? {
        let seconds = self
        if seconds < 60 {
            return "\(seconds)s"
        }
        let minutes = seconds / 60
        if minutes < 60 {
            let restSeconds = seconds % 60
            return "\(minutes)m \(restSeconds)s"
        }
        let hours = minutes / 60
        let restMinutes = minutes % 60
        return "\(hours)h \(restMinutes)m"
    }

    func secondsToMeterTimeFormate() -> String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let seconds = (self % 3600) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

//MARK:- UIFont

extension UIFont {
    class func regular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name:  AppRegularFont, size: manageFont(font: size))!
    }
    class func semiBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppSemiboldFont, size: manageFont(font: size))!
    }
    class func bold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppBoldFont, size: manageFont(font: size))!
    }
    
    private class func manageFont(font : CGFloat) -> CGFloat {
        let cal  = windowHeight * font
        print(CGFloat(cal / CGFloat(screenHeightDeveloper)))
        return CGFloat(cal / CGFloat(screenHeightDeveloper))
    }

}


//MARK:- UIView

extension UIView {
    
    func setGradientLayer(LeftColor:CGColor, RightColor:CGColor, BoundFrame:CGRect) {
        let gradient = CAGradientLayer()
        gradient.frame = BoundFrame
        gradient.colors = [LeftColor, RightColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        self.layer.addSublayer(gradient)
        
    }
    
}
