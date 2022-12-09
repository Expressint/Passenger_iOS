//
//  Extention+UIViewController.swift
//  PickNGo User
//
//  Created by Excelent iMac on 30/07/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import Foundation
import UIKit


extension String {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8),
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
}

extension NSAttributedString {

    func trimmedAttributedString() -> NSAttributedString {
        let invertedSet = CharacterSet.whitespacesAndNewlines.inverted
        let startRange = string.rangeOfCharacter(from: invertedSet)
        let endRange = string.rangeOfCharacter(from: invertedSet, options: .backwards)
        guard let startLocation = startRange?.upperBound, let endLocation = endRange?.lowerBound else {
            return NSAttributedString(string: string)
        }
        let location = string.distance(from: string.startIndex, to: startLocation) - 1
        let length = string.distance(from: startLocation, to: endLocation) + 2
        let range = NSRange(location: location, length: length)
        return attributedSubstring(from: range)
    }
}

extension UIViewController {
/*
    /// Convert Any data to String From Dictionary
    func checkDictionaryHaveValue(dictData: [String:AnyObject], didHaveKey paramString: String, ifHaveNotValue: String) -> String {
        
        var currentData = dictData
        
        if currentData[paramString] == nil {
            return ifHaveNotValue
        }
        
        if ((currentData[paramString] as? String) != nil) {
            if String(currentData[paramString] as! String) == "" {
                return ifHaveNotValue
            }
            return String(currentData[paramString] as! String)
            
        } else if ((currentData[paramString] as? Int) != nil) {
            if String(currentData[paramString] as! Int) == "" {
                return ifHaveNotValue
            }
            return String((currentData[paramString] as! Int))
            
        } else if ((currentData[paramString] as? Double) != nil) {
            if String(currentData[paramString] as! Double) == "" {
                return ifHaveNotValue
            }
            return String(currentData[paramString] as! Double)
            
        } else if ((currentData[paramString] as? Float) != nil){
            if String(currentData[paramString] as! Float) == "" {
                return ifHaveNotValue
            }
            return String(currentData[paramString] as! Float)
        }
        else {
            return ifHaveNotValue
        }
    }
    
*/
    /// Convert Seconds to Hours, Minutes and Seconds
//    func ConvertSecondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
//        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
//    }
}

