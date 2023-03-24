//
//  Toast.swift
//  Danfo_Rider
//
//  Created by Hiral Jotaniya on 08/06/21.
//

import Foundation
import UIKit

enum MessageAlertState {

    case success, failure, info, theme

    var backgroundColor: UIColor {
        switch self {
        case .success:
            return .themeGreen
        case .failure:
            return .themeRed
        case .info:
            return .themeGrayTextSecondary
        case .theme:
            return .themeGradientSecondary
        }
    }

    var icon: UIImage {
        switch self {
        case .success:
            return AppImages.alertCheck.image
        case .failure:
            return AppImages.alertCancel.image
        case .info:
            return AppImages.alertInfo.image
        case .theme:
            return AppImages.alertInfo.image
        }
    }
}

class Toast {
    
    static func show(title: String = "", delay: Double = 5.0, message: String?, state: MessageAlertState, completion: (() -> Void)? = nil) {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return}
        
        let toastContainer = UIView(frame: CGRect())
        toastContainer.tag = ViewComponentsTags.toastView
        if window.viewWithTag(ViewComponentsTags.toastView) != nil {
            return
        }
        
        let toastLabel = UILabel(frame: CGRect())
        let statusImage = UIImageView(frame: CGRect())
        statusImage.contentMode = .center
        toastContainer.backgroundColor = state.backgroundColor
        statusImage.image = state.icon
        statusImage.layer.cornerRadius = 15
        statusImage.backgroundColor = UIColor.white
        statusImage.clipsToBounds = true

        toastContainer.alpha = 1.0
        toastContainer.layer.cornerRadius = 15
        toastContainer.clipsToBounds = true
        
        toastLabel.textAlignment = .left
        
        let messagetoPrint = title != "" ?
            
            NSMutableAttributedString()
            .bold( "\(title)\n", fontSize: 13.0, fontColor: .white)
            .normal(message ?? "", fontSize: 13.0, fontColor: .white)
            :
            NSMutableAttributedString()
            .normal(message ?? "", fontSize: 13.0, fontColor: .white)
        toastLabel.attributedText = messagetoPrint
        
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0
        
        toastContainer.addSubview(statusImage)
        toastContainer.addSubview(toastLabel)
        
        statusImage.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let i1 = NSLayoutConstraint(item: statusImage, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 15)
        statusImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        statusImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let i4 = NSLayoutConstraint(item: statusImage, attribute: .centerY, relatedBy: .equal, toItem: toastContainer, attribute: .centerY, multiplier: 1, constant: 0)
        toastContainer.addConstraints([i1, i4])
        
        let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: statusImage, attribute: .trailing, multiplier: 1, constant: 15)
        let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -15)
        let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
        let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
        toastContainer.addConstraints([a1, a2, a3, a4])
        
        window.addSubview(toastContainer)
        
        let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: window, attribute: .leading, multiplier: 1, constant: 20)
        let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: window, attribute: .trailing, multiplier: 1, constant: -20)
        let c3 = NSLayoutConstraint(item: toastContainer, attribute: .top, relatedBy: .equal, toItem: window, attribute: .top, multiplier: 1, constant: 0)
        window.addConstraints([c1, c2, c3])
        
        DispatchQueue.main.async {
            c3.constant = 50
            
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.beginFromCurrentState, .curveLinear, .allowUserInteraction], animations: {
                //                toastContainer.alpha = 1.0
                window.layoutIfNeeded()
                
            }, completion: { _ in
                c3.constant = 0
                UIView.animate(withDuration: 0.1, delay: delay, options: .curveLinear, animations: {
                    //                    toastContainer.alpha = 0.0
                    window.layoutIfNeeded()
                }) { _ in
                    toastContainer.removeFromSuperview()
                    if let comp = completion {
                        comp()
                    }
                    
                }
            })
        }
    }
}

extension UIColor {
    
    static var themePrimary: UIColor {
        return #colorLiteral(red: 0.1607843137, green: 0.3764705882, blue: 0.6117647059, alpha: 1) // #29609C
    }

    static var themeGradientSecondary: UIColor {
        return #colorLiteral(red: 0.05098039216, green: 0.1450980392, blue: 0.368627451, alpha: 1) // #0D255E
    }

    static var themeGradientPrimary: UIColor {
        return #colorLiteral(red: 0.2784313725, green: 0.6196078431, blue: 0.8705882353, alpha: 1) // #479EDE
    }

    static var themeRed: UIColor {
        return #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) // #DB6060
    }

    static var themeGrayTextPrimary: UIColor {
        return #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1) // #4A4A4A
    }

    static var themeGrayTextSecondary: UIColor {
        return #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1) // #9B9B9B
    }

    static var themeOrange: UIColor {
        return #colorLiteral(red: 0.9215686275, green: 0.4470588235, blue: 0.08235294118, alpha: 1) // #EB7215
    }

    static var themeYellow: UIColor {
        return #colorLiteral(red: 0.9764705882, green: 0.8470588235, blue: 0, alpha: 1) // #F9D800
    }

    static var themeGreen: UIColor {
        return #colorLiteral(red: 0.3764705882, green: 0.8588235294, blue: 0.4235294118, alpha: 1) // #60DB6C
    }

    static var themeGrayLabel: UIColor {
        return #colorLiteral(red: 0.6980392157, green: 0.6980392157, blue: 0.6980392157, alpha: 1) // #B2B2B2
    }

    static var themeMediumGrayLabel: UIColor {
        return #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.4941176471, alpha: 1) // #7E7E7E
    }

    static var themeDarkGrayLabel: UIColor {
        return #colorLiteral(red: 0.2941176471, green: 0.2941176471, blue: 0.2941176471, alpha: 1) // #4B4B4B
    }

    static var themeSeparator: UIColor {
        return #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1) // ##707070
    }

    static var themePrimarySeparator: UIColor {
        return #colorLiteral(red: 0.9082275629, green: 0.9382922053, blue: 0.9633782506, alpha: 1) // E9EFF5
    }

    static var themeButtonSelected: UIColor {
        return #colorLiteral(red: 0.9489567876, green: 0.9490665793, blue: 0.9489073157, alpha: 1) // F2F2F2
    }

    static var themeChatBackColor: UIColor {
        return #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1) // EDEDED
    }

}

enum AppImages: String {

    case alertCancel          = "error_icon"
    case alertCheck           = "success_icon"
    case alertInfo            = "info_icon"
    
    var image: UIImage {
        return UIImage(named: rawValue)!
    }
    
}

enum ViewComponentsTags {
    static let activityIndicator = 1001
    static let toastView = 2002
}

extension NSMutableAttributedString {
 var fontSize: CGFloat { return 13 }
//    var boldFont:UIFont { return UIFont(name: FontBook.semibold.rawValue, size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont: UIFont { return UIFont(name: "ZonaPro-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}
    
    func bold(_ value: String, fontSize: CGFloat, fontColor: UIColor = .white) -> NSMutableAttributedString {
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.semiBold(ofSize: fontSize), // boldFont,
            .foregroundColor: fontColor
        ]
        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }
    
    func normal(_ value: String, fontSize: CGFloat, fontColor: UIColor = .white) -> NSMutableAttributedString {
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.regular(ofSize: fontSize), // normalFont,
            .foregroundColor: fontColor
        ]
        
        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }

    func orangeHighlight(_ value: String) -> NSMutableAttributedString {
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: normalFont,
            .foregroundColor: UIColor.white,
            .backgroundColor: UIColor.orange
        ]
        
        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }
    
    func blackHighlight(_ value: String) -> NSMutableAttributedString {
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: normalFont,
            .foregroundColor: UIColor.white,
            .backgroundColor: UIColor.black
            
        ]
        
        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }
    
    func underlined(_ value: String) -> NSMutableAttributedString {
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: normalFont,
            .underlineStyle: NSUnderlineStyle.styleSingle.rawValue
            
        ]
        
        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }
}
